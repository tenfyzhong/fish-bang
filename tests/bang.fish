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

  # history
end

function deinit
    set q (history_path)
    # rm -f "$q"
    set -e fish_history
    echo ''
end

function history_path
    echo -n "$HOME/.local/share/fish/$fish_history"_history
end

init

set output (_bang '!^')
@test 'test !^' "$output" = 'three'

set output (_bang '!$')
@test 'test !$' "$output" = 'seven'

set output (_bang '!*')
@test 'test !*' "$output" = 'three four five six seven'

set output (_bang !!)
@test 'test !!' "$output" = 'cd three four five six seven'

set output (_bang !2)
@test 'test !2' "$output" = 'mv foo bar foobar barfoo foobarfoo'

set output (_bang !3)
@test 'test !3' "$output" = 'ln -s hello world1'

set output (_bang !-2)
@test 'test !-2' "$output" = 'ln -s hello world'

set output (_bang !-1)
@test 'test !-1' "$output" = 'ls -a -l one two'

set output (_bang !ln)
@test 'test !ln' "$output" = 'ln -s hello world1'

set output (_bang '!?foo')
@test 'test !?foo' "$output" = 'mv foo bar foobar barfoo foobarfoo'

set output (_bang '!?foo?')
@test 'test !?foo?' "$output" = 'mv foo bar foobar barfoo foobarfoo'

@test 'test !+' (_bang '!+') $status -eq 1

set output (_bang '!!:^')
@test 'test !!:^' "$output" = 'three'

set output (_bang '!!:$')
@test 'test !!:$' "$output" = 'seven'

set output (_bang '!!:*')
@test 'test !!:*' "$output" = 'three four five six seven'

set output (_bang '!!:-')
@test 'test !!:-' "$output" = 'cd three four five six seven'

set output (_bang '!!:1-2')
@test 'test !!:1-2' "$output" = 'three four'

set output (_bang '!!:1-10')
@test 'test !!:1-10' "$output" = 'three four five six seven'

set output (_bang '!!:1-5')
@test 'test !!:1-5' "$output" = 'three four five six seven'

set output (_bang '!!:1-6')
@test 'test !!:1-6' "$output" = 'three four five six seven'

set output (_bang '!!:1-4')
@test 'test !!:1-4' "$output" = 'three four five six'

set output (_bang '!!:0-4')
@test 'test !!:0-4' "$output" = 'cd three four five six'

set output (_bang '!!:4-4')
@test 'test !!:4-4' "$output" = 'six'

set output (_bang '!!:5-6')
@test 'test !!:5-6' "$output" = 'seven'

set output (_bang '!!:6-6')
@test 'test !!:6-6' "$output" = ''

set output (_bang '!!:4-')
@test 'test !!:4-' "$output" = 'six seven'

set output (_bang '!!:0-')
@test 'test !!:0-' "$output" = 'cd three four five six seven'

set output (_bang '!!:1-')
@test 'test !!:1-' "$output" = 'three four five six seven'

set output (_bang '!!:5-')
@test 'test !!:5-' "$output" = 'seven'

set output (_bang '!!:6-')
@test 'test !!:6-' "$output" = ''

set output (_bang '!!:-0')
@test 'test !!:-0' "$output" = 'cd'

set output (_bang '!!:-1')
@test 'test !!:-1' "$output" = 'cd three'

set output (_bang '!!:-5')
@test 'test !!:-5' "$output" = 'cd three four five six seven'

set output (_bang '!!:-6')
@test 'test !!:-6' "$output" = 'cd three four five six seven'

set output (_bang '!!:0*')
@test 'test !!:0*' "$output" = 'cd three four five six seven'

set output (_bang '!!:1*')
@test 'test !!:1*' "$output" = 'three four five six seven'

set output (_bang '!!:2*')
@test 'test !!:2*' "$output" = 'four five six seven'

set output (_bang '!!:5*')
@test 'test !!:5*' "$output" = 'seven'

set output (_bang '!!:6*')
@test 'test !!:6*' "$output" = ''

set output (_bang '!!:s^three^eight^')
@test 'test !!:s^three^eight^' "$output" = 'cd eight four five six seven'

@test 'test !!:a*' (_bang '!!:a*') "$status" -eq 1

set output (_bang '!mv:^')
@test 'test !mv:^' "$output" = 'foo'

set output (_bang '!mv:$')
@test 'test !mv:$' "$output" = 'foobarfoo'

set output (_bang '!mv:*')
@test 'test !mv:*' "$output" = 'foo bar foobar barfoo foobarfoo'

set output (_bang '!mv:-')
@test 'test !mv:-' "$output" = 'mv foo bar foobar barfoo foobarfoo'

set output (_bang '!mv:1-2')
@test 'test !mv:1-2' "$output" = 'foo bar'

set output (_bang '!mv:1-10')
@test 'test !mv:1-10' "$output" = 'foo bar foobar barfoo foobarfoo'

set output (_bang '!mv:1-5')
@test 'test !mv:1-5' "$output" = 'foo bar foobar barfoo foobarfoo'

set output (_bang '!mv:1-6')
@test 'test !mv:1-6' "$output" = 'foo bar foobar barfoo foobarfoo'

set output (_bang '!mv:1-4')
@test 'test !mv:1-4' "$output" = 'foo bar foobar barfoo'

set output (_bang '!mv:0-4')
@test 'test !mv:0-4' "$output" = 'mv foo bar foobar barfoo'

set output (_bang '!mv:4-4')
@test 'test !mv:4-4' "$output" = 'barfoo'

set output (_bang '!mv:5-6')
@test 'test !mv:5-6' "$output" = 'foobarfoo'

set output (_bang '!mv:6-6')
@test 'test !mv:6-6' "$output" = ''

set output (_bang '!mv:4-')
@test 'test !mv:4-' "$output" = 'barfoo foobarfoo'

set output (_bang '!mv:0-')
@test 'test !mv:0-' "$output" = 'mv foo bar foobar barfoo foobarfoo'

set output (_bang '!mv:1-')
@test 'test !mv:1-' "$output" = 'foo bar foobar barfoo foobarfoo'

set output (_bang '!mv:5-')
@test 'test !mv:5-' "$output" = 'foobarfoo'

set output (_bang '!mv:6-')
@test 'test !mv:6-' "$output" = ''

set output (_bang '!mv:-0')
@test 'test !mv:-0' "$output" = 'mv'

set output (_bang '!mv:-1')
@test 'test !mv:-1' "$output" = 'mv foo'

set output (_bang '!mv:-5')
@test 'test !mv:-5' "$output" = 'mv foo bar foobar barfoo foobarfoo'

set output (_bang '!mv:-6')
@test 'test !mv:-6' "$output" = 'mv foo bar foobar barfoo foobarfoo'

set output (_bang '!mv:0*')
@test 'test !mv:0*' "$output" = 'mv foo bar foobar barfoo foobarfoo'

set output (_bang '!mv:1*')
@test 'test !mv:1*' "$output" = 'foo bar foobar barfoo foobarfoo'

set output (_bang '!mv:2*')
@test 'test !mv:2*' "$output" = 'bar foobar barfoo foobarfoo'

set output (_bang '!mv:5*')
@test 'test !mv:5*' "$output" = 'foobarfoo'

set output (_bang '!mv:6*')
@test 'test !mv:6*' "$output" = ''

set output (_bang '!mv:s^foo^hello^')
@test 'test !mv:s^foo^hello^' "$output" = 'mv hello bar hellobar barhello hellobarhello'

set output (_bang '!mv:s^foo1^hello^')
@test 'test !mv:s^foo^hello^' "$output" = 'mv foo bar foobar barfoo foobarfoo'

@test 'test !mv:a*' (_bang '!!:a*') "$status" -eq 1

set output (_bang '^three^ten^')
@test 'test ^three^ten^' "$output" = 'cd ten four five six seven'

set output (_bang '^three1^ten^')
@test 'test ^three1^ten^' "$output" = 'cd three four five six seven'

deinit
