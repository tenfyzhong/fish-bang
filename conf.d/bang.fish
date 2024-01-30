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
# [:]^
# [:]$
# [:]*
# [:]-
# [:]% TODO
# :x-y
# :x*
# :-y
# :x-
# :s^string1^string2^
# 
# special format
# !^
# !$
# !*
# !% TODO
# ^string1^string2^

# https://regex101.com/r/gYfhPu/2
set -gx _bang_regex '^!(?<cmdp>!|-?\d+|\w+|\?[^?]+\??|#)(?<wordp>:?\^|:?\$|:?\*|:?-|:?%|:\d+-\d+|:\d+\*|:-\d+|:\d+-|:s\^[^^]+\^[^^]+\^)?$'
abbr -a _bang -r $_bang_regex --position anywhere --function _bang

# https://regex101.com/r/V4nhLy/1
set -gx _bang_special_regex '^!\^|!\$|!\*|!%$'
abbr -a _bang_special -r $_bang_special_regex --position anywhere --function _bang

# https://regex101.com/r/fbdpnH/1
set -gx _bang_gsub_regex '^\^(?<s1>[^^]+)\^(?<s2>[^^]+)\^?$'
abbr -a _bang_gsub -r $_bang_gsub_regex --position anywhere --function _bang

bind -M default \r expand-abbr execute
bind -M insert \r expand-abbr execute
