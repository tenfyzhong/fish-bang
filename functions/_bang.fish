function _bang -a pattern
    switch "$pattern"
        case '!^' '!$' '!\*'
            set cmd $history[1]
            _bang_find_word "$cmd" (string sub -s 2 $pattern)
            return 0
        case '!%'
            # TODO
        case '^*^*' '^*^*^'
            set cmd $history[1]
            _bang_find_word "$cmd" "$pattern"
            return $status
        case '*'
            string match -q -r $_bang_regex "$pattern"
            if test $status -ne 0
                return 1
            end

            set cmd (_bang_find_cmd "$cmdp")
            if test $status -ne 0
                return $status
            end
            if test -z "$cmd"
                return 1
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
    else if string match -q -r -- '^\?(?<key>[^?]+)\??$' "$cmdp"
        # !?string[?]
        for cmd in $history 
            if string match -q -r -- "$key" "$cmd"
                echo $cmd
                return 0
            end
        end
    else if test "$cmdp" = "#"
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

    set -l wordmatch $wordp
    set char (string sub -s 1 -l 1 $wordp)
    if test "$char" = ':'
        set wordmatch (string sub -s 2 "$wordp")
    end


    echo $cmd | read -t -a token
    set args $token[2..-1]

    if test "$wordmatch" = "^"
        # :^
        echo $args[1]
    else if test "$wordmatch" = '$'
        # :$
        echo $args[-1]
    else if test "$wordmatch" = '*'
        # :*
        echo (string join ' ' $args)
    else if test "$wordmatch" = '-'
        echo (string join ' ' $token[1..-2])
    else if test "$wordmatch" = '%'
        # :%
        # TODO
    else if string match -q -r -- '^(?<x>\d+)?-(?<y>\d+)?$' "$wordmatch"
        # x-y
        # x-
        # -y
        # -
        if test -z "$x"
            set x 0
        end
        if test -z "$y"
            # Abbreviates ‘x-$’ like ‘x*’, but omits the last word
            # the y should set to -2, but the next part we will plus 1
            # so we set it to -3
            set y -3
        end
        # index 0 match command
        # the array index is base 1
        # we use the token array to match the result, so the args index should
        # plus 1
        set x (math "$x+1")
        set y (math "$y+1")
        echo (string join ' ' $token[$x..$y])
    else if string match -q -r -- '^(?<x>\d+)\*$' "$wordmatch" 
        # x*

        # index 0 match command
        # we use the token array to match the result, so the args index should
        # plus 1
        set x (math "$x+1")
        echo (string join ' ' $token[$x..-1])
    else if string match -q -r -- '^s?\^(?<s1>[^^]+)\^(?<s2>[^^]+)\^?$' "$wordmatch"
        # s^s1^s2^
        # ^s1^s2^
        echo (string replace -a "$s1" "$s2" "$cmd")
    else
        return 1
    end
end
