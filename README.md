Regex [![Swift Version](https://img.shields.io/badge/Swift-3.1-orange.svg)](https://swift.org/download/#releases) [![Platforms](https://img.shields.io/badge/Platforms-macOS%20|%20Linux-lightgray.svg)](https://swift.org/download/#releases) [![Build Status](https://travis-ci.org/DavidSkrundz/Regex.svg?branch=master)](https://travis-ci.org/DavidSkrundz/Regex) [![Codebeat Status](https://codebeat.co/badges/d3bc5b39-aa73-47f5-94e9-3c019368341e)](https://codebeat.co/projects/github-com-davidskrundz-regex) [![Codecov](https://codecov.io/gh/DavidSkrundz/Regex/branch/master/graph/badge.svg)](https://codecov.io/gh/DavidSkrundz/Regex)
=====

A pure Swift implementation of a Regular Expression Engine


Usage
-----

To avoid compiling overhead it is possible to create a `Regex` instance

```Swift
// Compile the expression
let regex = try! Regex(pattern: "[a-zA-Z]+")

let string = "RegEx is tough, but useful."

// Search for matches
let words = regex.match(string)

/*
words = [
	RegexMatch(match: "RegEx", groups: []),
	RegexMatch(match: "is", groups: []),
	RegexMatch(match: "tough", groups: []),
	RegexMatch(match: "but", groups: []),
	RegexMatch(match: "useful", groups: []),
]
*/
```

If compiling overhead is not an issue it is possible to use the `=~` operator to match a string

```Swift
let fourLetterWords = "drink beer, it's very nice!" =~ "\\b\\w{4}\\b" ?? []

/*
fourLetterWords = [
	RegexMatch(match: "beer", groups: []),
	RegexMatch(match: "very", groups: []),
	RegexMatch(match: "nice", groups: []),
]
*/
```

By default the `Global` flag is active. To change which flag are active, add a `/` at the start of the pattern, and add `/<flags>` at the end. The available flags are:

- `g` `Global`
- `i` `Case Insensitive`
- `m` `Multiline`

```Swift
// Global and Case Insensitive search
let regex = try! Regex(pattern: "/\\w+/ig")
```


Supported Operations
--------------------

### Character Classes
| Pattern | Descripion | Supported |
|---------|------------|-----------|
| `.` | `[^\n\r]` | <ul><li>[x] </li></ul> |
| `[^]` | `[\s\S]` | <ul><li>[x] </li></ul> |
| `\w` | `[A-Za-z0-9_]` | <ul><li>[x] </li></ul> |
| `\W` | `[^A-Za-z0-9_]` | <ul><li>[x] </li></ul> |
| `\d` | `[0-9]` | <ul><li>[x] </li></ul> |
| `\D` | `[^0-9]` | <ul><li>[x] </li></ul> |
| `\s` | `[\ \r\n\t\v\f]` | <ul><li>[x] </li></ul> |
| `\S` | `[^\ \r\n\t\v\f]` | <ul><li>[x] </li></ul> |
| `[ABC]` | Any in the set | <ul><li>[x] </li></ul> |
| `[^ABC]` | Any not in the set | <ul><li>[x] </li></ul> |
| `[A-Z]` | Any in the range inclusively | <ul><li>[x] </li></ul> |

### Anchors (Match positions not characters)
| Pattern | Descripion | Supported |
|---------|------------|-----------|
| `^` | Beginning of string | <ul><li>[x] </li></ul> |
| `$` | End of string | <ul><li>[x] </li></ul> |
| `\b` | Word boundary | <ul><li>[x] </li></ul> |
| `\B` | Not word boundary | <ul><li>[x] </li></ul> |

### Escaped Characters
| Pattern | Descripion | Supported |
|---------|------------|-----------|
| `\0` | Octal escaped character | <ul><li>[x] </li></ul> |
| `\00` | Octal escaped character | <ul><li>[x] </li></ul> |
| `\000` | Octal escaped character | <ul><li>[x] </li></ul> |
| `\xFF` | Hex escaped character | <ul><li>[x] </li></ul> |
| `\uFFFF` | Unicode escaped character | <ul><li>[x] </li></ul> |
| `\cA` | Control character | <ul><li>[x] </li></ul> |
| `\t` | Tab | <ul><li>[x] </li></ul> |
| `\n` | Newline | <ul><li>[x] </li></ul> |
| `\v` | Vertical tab | <ul><li>[x] </li></ul> |
| `\f` | Form feed | <ul><li>[x] </li></ul> |
| `\r` | Carriage return | <ul><li>[x] </li></ul> |
| `\0` | Null | <ul><li>[x] </li></ul> |
| `\.` | `.` | <ul><li>[x] </li></ul> |
| `\\` | `\` | <ul><li>[x] </li></ul> |
| `\+` | `+` | <ul><li>[x] </li></ul> |
| `\*` | `*` | <ul><li>[x] </li></ul> |
| `\?` | `?` | <ul><li>[x] </li></ul> |
| `\^` | `^` | <ul><li>[x] </li></ul> |
| `\$` | `$` | <ul><li>[x] </li></ul> |
| `\{` | `{` | <ul><li>[x] </li></ul> |
| `\}` | `}` | <ul><li>[x] </li></ul> |
| `\[` | `[` | <ul><li>[x] </li></ul> |
| `\]` | `]` | <ul><li>[x] </li></ul> |
| `\(` | `(` | <ul><li>[x] </li></ul> |
| `\)` | `)` | <ul><li>[x] </li></ul> |
| `\/` | `/` | <ul><li>[x] </li></ul> |
| `\|` | `|` | <ul><li>[x] </li></ul> |

### Groups and Lookaround
| Pattern | Descripion | Supported |
|---------|------------|-----------|
| `(ABC)` | Capture group | <ul><li>[x] </li></ul> |
| `\1` | Back reference | Missing VM Support |
| `(?:ABC)` | Non-capturing group | <ul><li>[x] </li></ul> |
| `(?=ABC)` | Positive lookahead | Missing VM Support |
| `(?!ABC)` | Negative lookahead | Missing VM Support |
| `(?<=ABC)` | Positive lookbehind | Missing VM Support |
| `(?<!ABC)` | Negative lookbehing | Missing VM Support |

### Greedy Quantifiers
| Pattern | Descripion | Supported |
|---------|------------|-----------|
| `+` | One or more | <ul><li>[x] </li></ul> |
| `*` | Zero or more | <ul><li>[x] </li></ul> |
| `?` | Optional | <ul><li>[x] </li></ul> |
| `{n}` | n | <ul><li>[x] </li></ul> |
| `{,}` | Same as `*` | <ul><li>[ ] </li></ul> |
| `{,n}` | n or less | <ul><li>[x] </li></ul> |
| `{n,}` | n or more | <ul><li>[x] </li></ul> |
| `{n,m}` | n to m | <ul><li>[x] </li></ul> |

### Lazy Quantifiers
| Pattern | Descripion | Supported |
|---------|------------|-----------|
| `+?` | One or more | <ul><li>[x] </li></ul> |
| `*?` | Zero or more | <ul><li>[x] </li></ul> |
| `??` | Optional | <ul><li>[x] </li></ul> |
| `{n}?` | n | <ul><li>[x] </li></ul> |
| `{,n}?` | n or less | <ul><li>[x] </li></ul> |
| `{n,}?` | n or more | <ul><li>[x] </li></ul> |
| `{n,m}?` | n to m | <ul><li>[x] </li></ul> |

### Alternation
| Pattern | Descripion | Supported |
|---------|------------|-----------|
| `|` | Everything before or everything after | <ul><li>[x] </li></ul> |

### Flags
| Pattern | Descripion | Supported |
|---------|------------|-----------|
| `i` | Case insensitive | <ul><li>[x] </li></ul> |
| `g` | Global | <ul><li>[x] </li></ul> |
| `m` | Multiline | <ul><li>[x] </li></ul> |


Inner Workings
--------------

There are three inner layers used by the `Regex` struct to help with processing user input and compiling the pattern, as well as a virtual machine that runs the compile pattern `Instructions` to process the input `String`.


### Lexer

The `Lexer` takes the raw `String` passed in by the user and converts it to a `[Token]`. This step is important because although not much work is being done, the `Lexer` is decoupling the literal characters being used from their meaning. If the `+` modifier ever changes meaning, only the `Lexer` would need to be modified.

```Swift
Input: "a+"
Output: [.Character("a"), .OneOrMore]
```


### Parser

The `Parser` takes the `[Token]` output from the `Lexer` and converts it to a `[Symbol]` by reducing groups of `Tokens` into a single `Symbol` composed of other `Symbols`.

```Swift
Input: [.Character("a"), .OneOrMore]
Output: [.OneOrMore(.Character("a")]
```


### Compiler

The `Compiler` translates the `[Symbol]` into a `[Instruction]` which is a program that the `VM` can run directly. The instruction set is simple and only has a few instructions.
- `Character(character)` Matches a `Character`
- `Jump(location)` Jump to `location`
- `Match` A match was found
- `...`

```
Input: [.OneOrMore(.Character("a")]
Output: [.Character("a"), .Split(0, 2)]
```


---


Note
====
Swift treats `\r\n` as a single `Character`. Use `\n\r` to have both.



Resources
=========

- [regexr.com](http://www.regexr.com) - Regex testing
- [swtch.com](https://swtch.com/~rsc/regexp/) - Implementing Regular Expressions
