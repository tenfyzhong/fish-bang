# Table of Contents
- [fish-bang](#fish-bang)
- [Usage](#usage)
  - [Command Designators](#command-designators)
  - [Word Designators](#word-designators)
  - [Special format](#special-format)
- [install](#install)

# fish-bang
[![GitHub tag](https://img.shields.io/github/tag/tenfyzhong/fish-bang.svg)](https://github.com/tenfyzhong/fish-bang/tags)
![Fish Version](https://img.shields.io/badge/support-fish%203.6.0-yellowgreen.svg?style=flat)
[![CI](https://github.com/tenfyzhong/fish-bang/actions/workflows/test.yml/badge.svg)](https://github.com/tenfyzhong/fish-bang/actions/workflows/test.yml)

The missing abilities of `!` for fish. For example the `!!` will get the previous command, the `!$` will get the last argument of previous command.

The reference manual: https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#Event-Designators

# Usage 
This plugin has fully implement the reference abilities.

## Command Designators
| Abbreviation | Description                                                                                             |
|--------------|---------------------------------------------------------------------------------------------------------|
| `!!`         | refer to the previous command                                                                           |
| `!n`         | refer to the last n command in `history`                                                                |
| `!-n`        | refer to the fist n command in `history`                                                                |
| `!string`    | refer to the most recent command preceding the current position in the `history` list start with string |
| `!?string?`  | refer to the most recent command preceding the current position in the history list containing string   |
| `!#`         | The entire command line typed so far                                                                    |

## Word Designators
| Abbreviation          | Description                                                                  |
|-----------------------|------------------------------------------------------------------------------|
| `[:]^`                | The first argument, that is word 1                                           |
| `[:]$`                | the last argument                                                            |
| `[:]*`                | All of the owrds, except the 0th, equals to `1-$`                            |
| `[:]-`                | equals to `0-`                                                               |
| `[:]%`                | The first word matched by the most recent `?string?` search                  |
| `:0`                  | The 0th word, equals to command word                                         |
| `:n`                  | The nth word                                                                 |
| `:x-y`                | A range of words                                                             |
| `:-y`                 | equals to `0-y`                                                              |
| `:x-`                 | Abbreviates `x-$`, but omits the last word                                   |
| `:x*`                 | Abbreviates `x-$`                                                            |
| `:s^string1^string2^` | Substitute `string2` for the first occurrence of `string1` in the event line |

## Special format
| Abbreviation       | Description                       |
|--------------------|-----------------------------------|
| `!^`               | equals to `!!^`                   |
| `!$`               | equals to `!!$`                   |
| `!*`               | equals to `!!*`                   |
| `!%`               | equals to `!!%`                   |
| `^string1^string2` | equals to `!!:s^string1^string2^` |

# install 
Install using Fisher(or other plugin manager):
```
fisher install tenfyzhong/fish-bang
```
