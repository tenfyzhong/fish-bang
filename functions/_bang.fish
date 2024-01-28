function _bang -a pattern
    switch "$pattern"
        case '!^' '!$' '!\*' '!%'
            set cmd $history[1]
            _bang_find_word "$cmd" (string sub -s 2 $pattern)
            return 0
        case '^*^*^'
            set cmd $history[1]
            _bang_find_word "$cmd" "$pattern"
            return $status
        case '*'
            string match -q -r '^!(?<cmdp>!|-?\d+|\w+|\?\w+\??|#)(?::(?<wordp>\^|\$|\*|-|%|\d+-\d+|\d+\*|-\d+|\d+-|s\^\w+\^\w+\^))?$' "$pattern"
            if test $status -ne 0
                return 1
            end

            set cmd (_bang_find_cmd "$cmdp")
            if test $status -ne 0
                return $status
            end
            _bang_find_word "$cmd" "$wordp"
            return $status
    end
    return 1
end

function _bang_find_cmd -a cmdp
    if test "$cmdp" = "!"
        # !!
        echo $history[1]
    else if string match -q -r -- '^-?\d+$' "$cmdp"
        # !-n
        # !n
        echo $history[$cmdp]
    else if string match -q -r -- '^\w+$' "$cmdp"
        # !string
        for cmd in $history 
            if string match -r -q -- "^$cmdp" "$cmd"
                echo $cmd
                return 0
            end
        end
    else if string match -q -r -- '^\?(?<key>\w+)\??$' "$cmdp"
        # !?string[?]
        for cmd in $history 
            if string match -q -r -- "$key" "$cmd"
                echo $cmd
                return 0
            end
        end
    else if test "$cmdp" = "#" "$cmdp"
        # TODO test
        # !#
        echo (commandline)
    else 
        return 1
    end
end

function _bang_find_word -a cmd -a wordp
    if test -z "$wordp"
        echo $cmd
        return 0
    end

    echo $cmd | read -t -a token
    # set command $token[1]
    set args $token[2..-1]

    if test "$wordp" = "^"
        # :^
        echo $args[1]
    else if test "$wordp" = '$'
        # :$
        echo $args[-1]
    else if test "$wordp" = '*'
        # :*
        echo (string join ' ' $args)
    else if test "$wordp" = '%'
        # :%
        # TODO
    else if string match -q -r -- '^(?<x>\d+)?-(?<y>\d+)?$' "$wordp"; \
        or string match -q -r -- '^(?<x>\d+)\*$' "$wordp"
        # x-y
        # x-
        # -y
        # -
        # x*
        if test -z "$x"
            set x 0
        end
        if test -z "$y"
            set y -2
        end
        # index 0 match command
        # we use the token array to match the result, so the args index should
        # plus 1
        set x (math "$x+1")
        set y (math "$y+1")
        echo (string join ' ' $token[$x..$y])
    else if string match -q -r -- '^s?\^(?<s1>\w+)\^(?<s2>\w+)\^$' "$wordp"
        # s^s1^s2^
        # ^s1^s2^
        echo (string replace -a "$s1" "$s2" "$cmd")
    else
        return 1
    end
end
