# https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#Event-Designators
# The regex has two part
# Part 1: Event Designators
# !!
# !-n
# !n
# !string
# !?string[?] (the last ? is optional)
# !#
# 
# Part 2: Word Designators 
# :^
# :$
# :*
# :-
# :%
# :x-y
# :x*
# :-y
# :x-
# :s^string1^string2^
# 
# special format
# ^
# $
# *
# %

# https://regex101.com/r/joi3TJ/2

abbr -a _bang -r '^!(?<cmdp>!|-?\d+|\w+|\?\w+\??|#)(?::(?<wordp>\^|\$|\*|-|%|\d+-\d+|\d+\*|-\d+|\d+-|s\^\w+\^\w+\^))?|\^\w+\^\w+\^|!\^|!\$|!\*|!%$' --position anywhere --function _bang
bind -M insert \r expand-abbr execute
