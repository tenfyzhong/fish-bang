function init
    set -gx fish_history bang
    set q (history_path)
    echo "- cmd: ls -a -l one two
  when: 1706449070
- cmd: ln -s hello world
  when: 1706449079
- cmd: ln -s hello world1
  when: 1706449079
- cmd: mv foo bar foobar barfoo foobarfoo
  when: 1706449079
- cmd: cd three four five six seven
  when: 1706449080
" > $q
end

function deinit
    set q (history_path)
    rm -f "$q"
    set -e fish_history
    echo ''
end

function history_path
    echo -n "$HOME/.local/share/fish/$fish_history"_history
end

function mock_commandline -a cmd
    set -gx _mock_commandline_value (string split ' ' "$cmd")
    function commandline
        for v in $_mock_commandline_value
            echo $v
        end
    end
end

function demock_commandline
    set -e _mock_commandline_value
    functions -e commandline
end

init

@test 'test regex match !^' (string match -q -r $_bang_special_regex '!^') $status -eq 0
set output (_bang '!^')
@test 'test !^' "$output" = 'three'

@test 'test regex match !$' (string match -q -r $_bang_special_regex '!$') $status -eq 0
set output (_bang '!$')
@test 'test !$' "$output" = 'seven'

@test 'test regex match !*' (string match -q -r $_bang_special_regex '!*') $status -eq 0
set output (_bang '!*')
@test 'test !*' "$output" = 'three four five six seven'

@test 'test regex match !%' (string match -q -r $_bang_special_regex '!%') $status -eq 0
set output (_bang '!%')
@test 'test !%' "$output" = ''
_bang '!?bar foobar?'
set output (_bang '!%')
@test 'test !%' "$output" = 'bar'
_bang '!?foo bar foobar?'
set output (_bang '!%')
@test 'test !%' "$output" = 'foo'

@test 'test regex match !!' (string match -q -r $_bang_regex '!!') $status -eq 0
set output (_bang !!)
@test 'test !!' "$output" = 'cd three four five six seven'

@test 'test regex match !2' (string match -q -r $_bang_regex '!2') $status -eq 0
set output (_bang !2)
@test 'test !2' "$output" = 'mv foo bar foobar barfoo foobarfoo'

@test 'test regex match !3' (string match -q -r $_bang_regex '!3') $status -eq 0
set output (_bang !3)
@test 'test !3' "$output" = 'ln -s hello world1'

@test 'test regex match !3' (string match -q -r $_bang_regex '!3') $status -eq 0
set output (_bang !-2)
@test 'test !-2' "$output" = 'ln -s hello world'

@test 'test regex match !-1' (string match -q -r $_bang_regex '!-1') $status -eq 0
set output (_bang !-1)
@test 'test !-1' "$output" = 'ls -a -l one two'

@test 'test regex match !ln' (string match -q -r $_bang_regex '!ln') $status -eq 0
set output (_bang !ln)
@test 'test !ln' "$output" = 'ln -s hello world1'

# @test 'test regex match !?foo' (string match -q -r $_bang_regex '!?foo') $status -eq 0
# set output (_bang '!?foo')
# @test 'test !?foo' "$output" = 'mv foo bar foobar barfoo foobarfoo'

@test 'test regex match !?foo?' (string match -q -r $_bang_regex '!?foo?') $status -eq 0
set output (_bang '!?foo?')
@test 'test !?foo?' "$output" = 'mv foo bar foobar barfoo foobarfoo'
@test 'test _bind_last_search' "$_bind_last_search" = "foo"

@test 'test regex match !#' (string match -q -r $_bang_regex '!#') $status -eq 0
mock_commandline 'cd go !#'
set output (_bang '!#')
@test 'test !#' "$output" = 'cd go'
demock_commandline

@test 'test regex match !+' (string match -q -r $_bang_regex '!+') $status -ne 0
@test 'test !+' (_bang '!+') $status -eq 1

@test 'test regex match !!:^' (string match -q -r $_bang_regex '!!:^') $status -eq 0
set output (_bang '!!:^')
@test 'test !!:^' "$output" = 'three'

@test 'test regex match !!^' (string match -q -r $_bang_regex '!!^') $status -eq 0
set output (_bang '!!^')
@test 'test !!^' "$output" = 'three'

@test 'test regex match !!:$' (string match -q -r $_bang_regex '!!:$') $status -eq 0
set output (_bang '!!:$')
@test 'test !!:$' "$output" = 'seven'

@test 'test regex match !!$' (string match -q -r $_bang_regex '!!$') $status -eq 0
set output (_bang '!!$')
@test 'test !!$' "$output" = 'seven'

@test 'test regex match !!:*' (string match -q -r $_bang_regex '!!:*') $status -eq 0
set output (_bang '!!:*')
@test 'test !!*' "$output" = 'three four five six seven'

@test 'test regex match !!*' (string match -q -r $_bang_regex '!!*') $status -eq 0
set output (_bang '!!*')
@test 'test !!*' "$output" = 'three four five six seven'

@test 'test regex match !!:-' (string match -q -r $_bang_regex '!!:-') $status -eq 0
set output (_bang '!!:-')
@test 'test !!:-' "$output" = 'cd three four five six'

@test 'test regex match !!-' (string match -q -r $_bang_regex '!!-') $status -eq 0
set output (_bang '!!-')
@test 'test !!-' "$output" = 'cd three four five six'

@test 'test regex match !!:1-2' (string match -q -r $_bang_regex '!!:1-2') $status -eq 0
set output (_bang '!!:1-2')
@test 'test !!:1-2' "$output" = 'three four'

@test 'test regex match !!:1-10' (string match -q -r $_bang_regex '!!:1-10') $status -eq 0
set output (_bang '!!:1-10')
@test 'test !!:1-10' "$output" = 'three four five six seven'

@test 'test regex match !!:1-5' (string match -q -r $_bang_regex '!!:1-5') $status -eq 0
set output (_bang '!!:1-5')
@test 'test !!:1-5' "$output" = 'three four five six seven'

@test 'test regex match !!:1-6' (string match -q -r $_bang_regex '!!:1-6') $status -eq 0
set output (_bang '!!:1-6')
@test 'test !!:1-6' "$output" = 'three four five six seven'

@test 'test regex match !!:1-4' (string match -q -r $_bang_regex '!!:1-4') $status -eq 0
set output (_bang '!!:1-4')
@test 'test !!:1-4' "$output" = 'three four five six'

@test 'test regex match !!:0-4' (string match -q -r $_bang_regex '!!:0-4') $status -eq 0
set output (_bang '!!:0-4')
@test 'test !!:0-4' "$output" = 'cd three four five six'

@test 'test regex match !!:4-4' (string match -q -r $_bang_regex '!!:4-4') $status -eq 0
set output (_bang '!!:4-4')
@test 'test !!:4-4' "$output" = 'six'

@test 'test regex match !!:5-6' (string match -q -r $_bang_regex '!!:5-6') $status -eq 0
set output (_bang '!!:5-6')
@test 'test !!:5-6' "$output" = 'seven'

@test 'test regex match !!:6-6' (string match -q -r $_bang_regex '!!:6-6') $status -eq 0
set output (_bang '!!:6-6')
@test 'test !!:6-6' "$output" = ''

@test 'test regex match !!:4-' (string match -q -r $_bang_regex '!!:4-') $status -eq 0
set output (_bang '!!:4-')
@test 'test !!:4-' "$output" = 'six'

@test 'test regex match !!:0-' (string match -q -r $_bang_regex '!!:0-') $status -eq 0
set output (_bang '!!:0-')
@test 'test !!:0-' "$output" = 'cd three four five six'

@test 'test regex match !!:0' (string match -q -r $_bang_regex '!!:0') $status -eq 0
set output (_bang '!!:0')
@test 'test !!:0' "$output" = 'cd'

@test 'test regex match !!:1-' (string match -q -r $_bang_regex '!!:1-') $status -eq 0
set output (_bang '!!:1-')
@test 'test !!:1-' "$output" = 'three four five six'

@test 'test regex match !!:1' (string match -q -r $_bang_regex '!!:1') $status -eq 0
set output (_bang '!!:1')
@test 'test !!:1' "$output" = 'three'

@test 'test regex match !!:4-' (string match -q -r $_bang_regex '!!:4-') $status -eq 0
set output (_bang '!!:4-')
@test 'test !!:4-' "$output" = 'six'

@test 'test regex match !!:5-' (string match -q -r $_bang_regex '!!:5-') $status -eq 0
set output (_bang '!!:5-')
@test 'test !!:5-' "$output" = ''

@test 'test regex match !!:6-' (string match -q -r $_bang_regex '!!:6-') $status -eq 0
set output (_bang '!!:6-')
@test 'test !!:6-' "$output" = ''

@test 'test regex match !!:-0' (string match -q -r $_bang_regex '!!:-0') $status -eq 0
set output (_bang '!!:-0')
@test 'test !!:-0' "$output" = 'cd'

@test 'test regex match !!:-1' (string match -q -r $_bang_regex '!!:-1') $status -eq 0
set output (_bang '!!:-1')
@test 'test !!:-1' "$output" = 'cd three'

@test 'test regex match !!:-5' (string match -q -r $_bang_regex '!!:-5') $status -eq 0
set output (_bang '!!:-5')
@test 'test !!:-5' "$output" = 'cd three four five six seven'

@test 'test regex match !!:5' (string match -q -r $_bang_regex '!!:5') $status -eq 0
set output (_bang '!!:5')
@test 'test !!:5' "$output" = 'seven'

@test 'test regex match !!:-6' (string match -q -r $_bang_regex '!!:-6') $status -eq 0
set output (_bang '!!:-6')
@test 'test !!:-6' "$output" = 'cd three four five six seven'

@test 'test regex match !!:6' (string match -q -r $_bang_regex '!!:6') $status -eq 0
set output (_bang '!!:6')
@test 'test !!:6' "$output" = ''

@test 'test regex match !!:0*' (string match -q -r $_bang_regex '!!:0*') $status -eq 0
set output (_bang '!!:0*')
@test 'test !!:0*' "$output" = 'cd three four five six seven'

@test 'test regex match !!:1*' (string match -q -r $_bang_regex '!!:1*') $status -eq 0
set output (_bang '!!:1*')
@test 'test !!:1*' "$output" = 'three four five six seven'

@test 'test regex match !!:2*' (string match -q -r $_bang_regex '!!:2*') $status -eq 0
set output (_bang '!!:2*')
@test 'test !!:2*' "$output" = 'four five six seven'

@test 'test regex match !!:5*' (string match -q -r $_bang_regex '!!:5*') $status -eq 0
set output (_bang '!!:5*')
@test 'test !!:5*' "$output" = 'seven'

@test 'test regex match !!:6*' (string match -q -r $_bang_regex '!!:6*') $status -eq 0
set output (_bang '!!:6*')
@test 'test !!:6*' "$output" = ''

@test 'test regex match !!:s^three^eight^' (string match -q -r $_bang_regex '!!:s^three^eight^') $status -eq 0
set output (_bang '!!:s^three^eight^')
@test 'test !!:s^three^eight^' "$output" = 'cd eight four five six seven'

@test 'test regex match test !!:a*' (string match -q -r $_bang_regex 'test !!:a*') $status -ne 0
@test 'test !!:a*' (_bang '!!:a*') "$status" -eq 1

@test 'test regex match !mv:^' (string match -q -r $_bang_regex '!mv:^') $status -eq 0
set output (_bang '!mv:^')
@test 'test !mv:^' "$output" = 'foo'

@test 'test regex match !mv^' (string match -q -r $_bang_regex '!mv^') $status -eq 0
set output (_bang '!mv^')
@test 'test !mv^' "$output" = 'foo'

@test 'test regex match !mv:$' (string match -q -r $_bang_regex '!mv:$') $status -eq 0
set output (_bang '!mv:$')
@test 'test !mv:$' "$output" = 'foobarfoo'

@test 'test regex match !mv$' (string match -q -r $_bang_regex '!mv$') $status -eq 0
set output (_bang '!mv$')
@test 'test !mv$' "$output" = 'foobarfoo'

@test 'test regex match !mv:*' (string match -q -r $_bang_regex '!mv:*') $status -eq 0
set output (_bang '!mv:*')
@test 'test !mv:*' "$output" = 'foo bar foobar barfoo foobarfoo'

@test 'test regex match !mv*' (string match -q -r $_bang_regex '!mv*') $status -eq 0
set output (_bang '!mv*')
@test 'test !mv*' "$output" = 'foo bar foobar barfoo foobarfoo'

@test 'test regex match !mv:-' (string match -q -r $_bang_regex '!mv:-') $status -eq 0
set output (_bang '!mv:-')
@test 'test !mv:-' "$output" = 'mv foo bar foobar barfoo'

@test 'test regex match !mv:%' (string match -q -r $_bang_regex '!mv:%') $status -eq 0
_bang '!?foo bar foobar?'
set output (_bang '!mv:%')
@test 'test !mv:%' "$output" = 'foo'

@test 'test regex match !mv%' (string match -q -r $_bang_regex '!mv%') $status -eq 0
_bang '!?foo bar foobar?'
set output (_bang '!mv%')
@test 'test !mv%' "$output" = 'foo'

@test 'test regex match !mv-' (string match -q -r $_bang_regex '!mv-') $status -eq 0
set output (_bang '!mv-')
@test 'test !mv-' "$output" = 'mv foo bar foobar barfoo'

@test 'test regex match !mv:1-2' (string match -q -r $_bang_regex '!mv:1-2') $status -eq 0
set output (_bang '!mv:1-2')
@test 'test !mv:1-2' "$output" = 'foo bar'

@test 'test regex match !mv:1-10' (string match -q -r $_bang_regex '!mv:1-10') $status -eq 0
set output (_bang '!mv:1-10')
@test 'test !mv:1-10' "$output" = 'foo bar foobar barfoo foobarfoo'

@test 'test regex match !mv:1-5' (string match -q -r $_bang_regex '!mv:1-5') $status -eq 0
set output (_bang '!mv:1-5')
@test 'test !mv:1-5' "$output" = 'foo bar foobar barfoo foobarfoo'

@test 'test regex match !mv:1-6' (string match -q -r $_bang_regex '!mv:1-6') $status -eq 0
set output (_bang '!mv:1-6')
@test 'test !mv:1-6' "$output" = 'foo bar foobar barfoo foobarfoo'

@test 'test regex match !mv:1-4' (string match -q -r $_bang_regex '!mv:1-4') $status -eq 0
set output (_bang '!mv:1-4')
@test 'test !mv:1-4' "$output" = 'foo bar foobar barfoo'

@test 'test regex match !mv:0-4' (string match -q -r $_bang_regex '!mv:0-4') $status -eq 0
set output (_bang '!mv:0-4')
@test 'test !mv:0-4' "$output" = 'mv foo bar foobar barfoo'

@test 'test regex match !mv:4-4' (string match -q -r $_bang_regex '!mv:4-4') $status -eq 0
set output (_bang '!mv:4-4')
@test 'test !mv:4-4' "$output" = 'barfoo'

@test 'test regex match !mv:5-6' (string match -q -r $_bang_regex '!mv:5-6') $status -eq 0
set output (_bang '!mv:5-6')
@test 'test !mv:5-6' "$output" = 'foobarfoo'

@test 'test regex match !mv:6-6' (string match -q -r $_bang_regex '!mv:6-6') $status -eq 0
set output (_bang '!mv:6-6')
@test 'test !mv:6-6' "$output" = ''

@test 'test regex match !mv:4-' (string match -q -r $_bang_regex '!mv:4-') $status -eq 0
set output (_bang '!mv:4-')
@test 'test !mv:4-' "$output" = 'barfoo'

@test 'test regex match !mv:0-' (string match -q -r $_bang_regex '!mv:0-') $status -eq 0
set output (_bang '!mv:0-')
@test 'test !mv:0-' "$output" = 'mv foo bar foobar barfoo'

@test 'test regex match !mv:1-' (string match -q -r $_bang_regex '!mv:1-') $status -eq 0
set output (_bang '!mv:1-')
@test 'test !mv:1-' "$output" = 'foo bar foobar barfoo'

@test 'test regex match !mv:4-' (string match -q -r $_bang_regex '!mv:4-') $status -eq 0
set output (_bang '!mv:4-')
@test 'test !mv:4-' "$output" = 'barfoo'

@test 'test regex match !mv:5-' (string match -q -r $_bang_regex '!mv:5-') $status -eq 0
set output (_bang '!mv:5-')
@test 'test !mv:5-' "$output" = ''

@test 'test regex match !mv:6-' (string match -q -r $_bang_regex '!mv:6-') $status -eq 0
set output (_bang '!mv:6-')
@test 'test !mv:6-' "$output" = ''

@test 'test regex match !mv:-0' (string match -q -r $_bang_regex '!mv:-0') $status -eq 0
set output (_bang '!mv:-0')
@test 'test !mv:-0' "$output" = 'mv'

@test 'test regex match !mv:-1' (string match -q -r $_bang_regex '!mv:-1') $status -eq 0
set output (_bang '!mv:-1')
@test 'test !mv:-1' "$output" = 'mv foo'

@test 'test regex match !mv:-5' (string match -q -r $_bang_regex '!mv:-5') $status -eq 0
set output (_bang '!mv:-5')
@test 'test !mv:-5' "$output" = 'mv foo bar foobar barfoo foobarfoo'

@test 'test regex match !mv:-6' (string match -q -r $_bang_regex '!mv:-6') $status -eq 0
set output (_bang '!mv:-6')
@test 'test !mv:-6' "$output" = 'mv foo bar foobar barfoo foobarfoo'

@test 'test regex match !mv:0*' (string match -q -r $_bang_regex '!mv:0*') $status -eq 0
set output (_bang '!mv:0*')
@test 'test !mv:0*' "$output" = 'mv foo bar foobar barfoo foobarfoo'

@test 'test regex match !mv:1*' (string match -q -r $_bang_regex '!mv:1*') $status -eq 0
set output (_bang '!mv:1*')
@test 'test !mv:1*' "$output" = 'foo bar foobar barfoo foobarfoo'

@test 'test regex match !mv:2*' (string match -q -r $_bang_regex '!mv:2*') $status -eq 0
set output (_bang '!mv:2*')
@test 'test !mv:2*' "$output" = 'bar foobar barfoo foobarfoo'

@test 'test regex match !mv:5*' (string match -q -r $_bang_regex '!mv:5*') $status -eq 0
set output (_bang '!mv:5*')
@test 'test !mv:5*' "$output" = 'foobarfoo'

@test 'test regex match !mv:6*' (string match -q -r $_bang_regex '!mv:6*') $status -eq 0
set output (_bang '!mv:6*')
@test 'test !mv:6*' "$output" = ''

@test 'test regex match !mv:s^foo^hello^' (string match -q -r $_bang_regex '!mv:s^foo^hello^') $status -eq 0
set output (_bang '!mv:s^foo^hello^')
@test 'test !mv:s^foo^hello^' "$output" = 'mv hello bar hellobar barhello hellobarhello'

@test 'test regex match !mv:s^foo^hello' (string match -q -r $_bang_regex '!mv:s^foo^hello') $status -eq 0
set output (_bang '!mv:s^foo^hello')
@test 'test !mv:s^foo^hello' "$output" = 'mv hello bar hellobar barhello hellobarhello'

@test 'test regex match !mv:s^foo1^hello^' (string match -q -r $_bang_regex '!mv:s^foo1^hello^') $status -eq 0
set output (_bang '!mv:s^foo1^hello^')
@test 'test !mv:s^foo^hello^' "$output" = 'mv foo bar foobar barfoo foobarfoo'

@test 'test regex match !mv:s^foo1^hello' (string match -q -r $_bang_regex '!mv:s^foo1^hello') $status -eq 0
set output (_bang '!mv:s^foo1^hello')
@test 'test !mv:s^foo^hello^' "$output" = 'mv foo bar foobar barfoo foobarfoo'

@test 'test regex match test !mv:a*' (string match -q -r $_bang_regex '!mv:a*') $status -ne 0
@test 'test !mv:a*' (_bang '!mv:a*') "$status" -eq 1

@test 'test regex match !#^' (string match -q -r $_bang_regex '!#^') $status -eq 0
mock_commandline 'cd go !#^'
set output (_bang '!#^')
@test 'test !#^' "$output" = 'go'
demock_commandline

@test 'test regex match !#$' (string match -q -r $_bang_regex '!#$') $status -eq 0
mock_commandline 'cd go !#$'
set output (_bang '!#$')
@test 'test !#$' "$output" = 'go'
demock_commandline

@test 'test regex match !#*' (string match -q -r $_bang_regex '!#*') $status -eq 0
mock_commandline 'cd go sdk !#*'
set output (_bang '!#*')
@test 'test !#*' "$output" = 'go sdk'
demock_commandline

@test 'test regex match !#-' (string match -q -r $_bang_regex '!#-') $status -eq 0
mock_commandline 'cd hello go sdk !#-'
set output (_bang '!#-')
@test 'test !#-' "$output" = 'cd hello go'
demock_commandline

@test 'test regex match !#:^' (string match -q -r $_bang_regex '!#:^') $status -eq 0
mock_commandline 'cd go !#:^'
set output (_bang '!#:^')
@test 'test !#:^' "$output" = 'go'
demock_commandline

@test 'test regex match !#:$' (string match -q -r $_bang_regex '!#:$') $status -eq 0
mock_commandline 'cd go !#:$'
set output (_bang '!#:$')
@test 'test !#:$' "$output" = 'go'
demock_commandline

@test 'test regex match !#:*' (string match -q -r $_bang_regex '!#:*') $status -eq 0
mock_commandline 'cd go sdk !#:*'
set output (_bang '!#:*')
@test 'test !#:*' "$output" = 'go sdk'
demock_commandline

@test 'test regex match !#:-' (string match -q -r $_bang_regex '!#:-') $status -eq 0
mock_commandline 'cd hello go sdk !#:-'
set output (_bang '!#:-')
@test 'test !#:-' "$output" = 'cd hello go'
demock_commandline

@test 'test regex match !#:1-2' (string match -q -r $_bang_regex '!#:1-2') $status -eq 0
mock_commandline 'cd hello go sdk !#:1-2'
set output (_bang '!#:1-2')
@test 'test !#:-' "$output" = 'hello go'
demock_commandline

@test 'test regex match !#:2*' (string match -q -r $_bang_regex '!#:2*') $status -eq 0
mock_commandline 'cd hello go sdk !#:2*'
set output (_bang '!#:2*')
@test 'test !#:2*' "$output" = 'go sdk'
demock_commandline

@test 'test regex match !#:-2' (string match -q -r $_bang_regex '!#:1-2') $status -eq 0
mock_commandline 'cd hello go sdk !#:-2'
set output (_bang '!#:-2')
@test 'test !#:-2' "$output" = 'cd hello go'
demock_commandline

@test 'test regex match !#:3-' (string match -q -r $_bang_regex '!#:3-') $status -eq 0
mock_commandline 'cd hello go sdk world !#:3-'
set output (_bang '!#:3-')
@test 'test !#:3-' "$output" = 'sdk'
demock_commandline

@test 'test regex match !#:s^hello^world^' (string match -q -r $_bang_regex '!#:s^hello^world^') $status -eq 0
mock_commandline 'cd hello go sdk world !#:s^hello^world^'
set output (_bang '!#:s^hello^world^')
@test 'test !#:s^hello^world^' "$output" = 'cd world go sdk world'
demock_commandline

@test 'test regex match !#:s^hello^world' (string match -q -r $_bang_regex '!#:s^hello^world') $status -eq 0
mock_commandline 'cd hello go sdk world !#:s^hello^world'
set output (_bang '!#:s^hello^world')
@test 'test !#:s^hello^world' "$output" = 'cd world go sdk world'
demock_commandline

@test 'test regex match !#:s^hello1^world' (string match -q -r $_bang_regex '!#:s^hello1^world') $status -eq 0
mock_commandline 'cd hello go sdk world !#:s^hello1^world'
set output (_bang '!#:s^hello1^world')
@test 'test !#:s^hello1^world' "$output" = 'cd hello go sdk world'
demock_commandline

@test 'test regex match test ^three^ten^' (string match -q -r $_bang_gsub_regex '^three^ten^') $status -eq 0
set output (_bang '^three^ten^')
@test 'test ^three^ten^' "$output" = 'cd ten four five six seven'

@test 'test regex match test ^three^ten' (string match -q -r $_bang_gsub_regex '^three^ten') $status -eq 0
set output (_bang '^three^ten')
@test 'test ^three^ten' "$output" = 'cd ten four five six seven'

@test 'test regex match test ^three1^ten^' (string match -q -r $_bang_gsub_regex '^three1^ten^') $status -eq 0
set output (_bang '^three1^ten^')
@test 'test ^three1^ten^' "$output" = 'cd three four five six seven'

@test 'test regex match test ^three1^ten' (string match -q -r $_bang_gsub_regex '^three1^ten') $status -eq 0
set output (_bang '^three1^ten')
@test 'test ^three1^ten' "$output" = 'cd three four five six seven'

deinit
