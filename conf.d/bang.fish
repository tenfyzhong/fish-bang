# https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#Event-Designators
# The regex has two part
# Part 1: Event Designators
# !!
# !-n
# !n
# !string
# !?string?
# !#
# 
# Part 2: Word Designators 
# [:]^
# [:]$
# [:]*
# [:]-
# [:]% 
# :x-y
# :x*
# :-y
# :x-
# :x
# :s^string1^string2^
# 
# special format
# !^
# !$
# !*
# !% 
# ^string1^string2^

set -gx _bang_regex '^!(?<cmdp>!|-?\d+|\w+|\?[^?]+\?|#)(?<wordp>:?\^|:?\$|:?\*|:?-|:?%|:\d+-\d+|:\d+\*|:-\d+|:\d+-|:\d+|:s\^[^^]+\^[^^]+\^?)?$'
abbr -a _bang -r $_bang_regex --position anywhere --function _bang

set -gx _bang_special_regex '^!\^|!\$|!\*|!%$'
abbr -a _bang_special -r $_bang_special_regex --position anywhere --function _bang

set -gx _bang_gsub_regex '^\^(?<s1>[^^]+)\^(?<s2>[^^]+)\^?$'
abbr -a _bang_gsub -r $_bang_gsub_regex --position anywhere --function _bang

bind -M default \r expand-abbr execute
bind -M insert \r expand-abbr execute
