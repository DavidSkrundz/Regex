# Regex (V2 WIP) [![Swift Version](https://img.shields.io/badge/Swift-4.1-orange.svg)](https://swift.org/download/#releases) [![Platforms](https://img.shields.io/badge/Platforms-macOS%20|%20Linux-lightgray.svg)](https://swift.org/download/#releases) [![Build Status](https://travis-ci.org/DavidSkrundz/Regex.svg?branch=master)](https://travis-ci.org/DavidSkrundz/Regex) [![Codebeat Status](https://codebeat.co/badges/d3bc5b39-aa73-47f5-94e9-3c019368341e)](https://codebeat.co/projects/github-com-davidskrundz-regex) [![Codecov](https://codecov.io/gh/DavidSkrundz/Regex/branch/master/graph/badge.svg)](https://codecov.io/gh/DavidSkrundz/Regex)

A pure Swift implementation of a Regular Expression Engine

**Trying again with V2 using DFAs instead of NFAs to get grep-like performance**


## Usage

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


## Supported Operations

### Character Classes
| Pattern | Descripion | Supported |
|---------|------------|-----------|
| `.` | `[^\n\r]` | <ul><li>[ ] </li></ul> |
| `[^]` | `[\s\S]` | <ul><li>[ ] </li></ul> |
| `\w` | `[A-Za-z0-9_]` | <ul><li>[ ] </li></ul> |
| `\W` | `[^A-Za-z0-9_]` | <ul><li>[ ] </li></ul> |
| `\d` | `[0-9]` | <ul><li>[ ] </li></ul> |
| `\D` | `[^0-9]` | <ul><li>[ ] </li></ul> |
| `\s` | `[\ \r\n\t\v\f]` | <ul><li>[ ] </li></ul> |
| `\S` | `[^\ \r\n\t\v\f]` | <ul><li>[ ] </li></ul> |
| `[ABC]` | Any in the set | <ul><li>[ ] </li></ul> |
| `[^ABC]` | Any not in the set | <ul><li>[ ] </li></ul> |
| `[A-Z]` | Any in the range inclusively | <ul><li>[ ] </li></ul> |

### Anchors (Match positions not characters)
| Pattern | Descripion | Supported |
|---------|------------|-----------|
| `^` | Beginning of string | <ul><li>[ ] </li></ul> |
| `$` | End of string | <ul><li>[ ] </li></ul> |
| `\b` | Word boundary | <ul><li>[ ] </li></ul> |
| `\B` | Not word boundary | <ul><li>[ ] </li></ul> |

### Escaped Characters
| Pattern | Descripion | Supported |
|---------|------------|-----------|
| `\0` | Octal escaped character | <ul><li>[ ] </li></ul> |
| `\00` | Octal escaped character | <ul><li>[ ] </li></ul> |
| `\000` | Octal escaped character | <ul><li>[ ] </li></ul> |
| `\xFF` | Hex escaped character | <ul><li>[ ] </li></ul> |
| `\uFFFF` | Unicode escaped character | <ul><li>[ ] </li></ul> |
| `\cA` | Control character | <ul><li>[ ] </li></ul> |
| `\t` | Tab | <ul><li>[ ] </li></ul> |
| `\n` | Newline | <ul><li>[ ] </li></ul> |
| `\v` | Vertical tab | <ul><li>[ ] </li></ul> |
| `\f` | Form feed | <ul><li>[ ] </li></ul> |
| `\r` | Carriage return | <ul><li>[ ] </li></ul> |
| `\0` | Null | <ul><li>[ ] </li></ul> |
| `\.` | `.` | <ul><li>[ ] </li></ul> |
| `\\` | `\` | <ul><li>[ ] </li></ul> |
| `\+` | `+` | <ul><li>[ ] </li></ul> |
| `\*` | `*` | <ul><li>[ ] </li></ul> |
| `\?` | `?` | <ul><li>[ ] </li></ul> |
| `\^` | `^` | <ul><li>[ ] </li></ul> |
| `\$` | `$` | <ul><li>[ ] </li></ul> |
| `\{` | `{` | <ul><li>[ ] </li></ul> |
| `\}` | `}` | <ul><li>[ ] </li></ul> |
| `\[` | `[` | <ul><li>[ ] </li></ul> |
| `\]` | `]` | <ul><li>[ ] </li></ul> |
| `\(` | `(` | <ul><li>[ ] </li></ul> |
| `\)` | `)` | <ul><li>[ ] </li></ul> |
| `\/` | `/` | <ul><li>[ ] </li></ul> |
| `\|` | `|` | <ul><li>[ ] </li></ul> |

### Groups and Lookaround
| Pattern | Descripion | Supported |
|---------|------------|-----------|
| `(ABC)` | Capture group | <ul><li>[ ] </li></ul> |
| `(<name>ABC)` | Named capture group | <ul><li>[ ] </li></ul> |
| `\1` | Back reference | <ul><li>[ ] </li></ul> |
| `\'name'` | Named back reference | <ul><li>[ ] </li></ul> |
| `(?:ABC)` | Non-capturing group | <ul><li>[ ] </li></ul> |
| `(?=ABC)` | Positive lookahead | <ul><li>[ ] </li></ul> |
| `(?!ABC)` | Negative lookahead | <ul><li>[ ] </li></ul> |
| `(?<=ABC)` | Positive lookbehind | <ul><li>[ ] </li></ul> |
| `(?<!ABC)` | Negative lookbehing | <ul><li>[ ] </li></ul> |

### Greedy Quantifiers
| Pattern | Descripion | Supported |
|---------|------------|-----------|
| `+` | One or more | <ul><li>[ ] </li></ul> |
| `*` | Zero or more | <ul><li>[ ] </li></ul> |
| `?` | Optional | <ul><li>[ ] </li></ul> |
| `{n}` | n | <ul><li>[ ] </li></ul> |
| `{,}` | Same as `*` | <ul><li>[ ] </li></ul> |
| `{,n}` | n or less | <ul><li>[ ] </li></ul> |
| `{n,}` | n or more | <ul><li>[ ] </li></ul> |
| `{n,m}` | n to m | <ul><li>[ ] </li></ul> |

### Lazy Quantifiers
| Pattern | Descripion | Supported |
|---------|------------|-----------|
| `+?` | One or more | <ul><li>[ ] </li></ul> |
| `*?` | Zero or more | <ul><li>[ ] </li></ul> |
| `??` | Optional | <ul><li>[ ] </li></ul> |
| `{n}?` | n | <ul><li>[ ] </li></ul> |
| `{,n}?` | n or less | <ul><li>[ ] </li></ul> |
| `{n,}?` | n or more | <ul><li>[ ] </li></ul> |
| `{n,m}?` | n to m | <ul><li>[ ] </li></ul> |

### Alternation
| Pattern | Descripion | Supported |
|---------|------------|-----------|
| `\|` | Everything before or everything after | <ul><li>[ ] </li></ul> |

### Flags
| Pattern | Descripion | Supported |
|---------|------------|-----------|
| `i` | Case insensitive | <ul><li>[ ] </li></ul> |
| `g` | Global | <ul><li>[ ] </li></ul> |
| `m` | Multiline | <ul><li>[ ] </li></ul> |


## Inner Workings

(Similar to before)

- Lexer (String input to Tokens)
- Parser (Tokens to NFA)
- Compiler (NFA to DFA)
- Optimizer (Simplify DFA (eg. `char(a), char(b)` -> `string(ab)`) for better performance)
- Engine (Matches an input String using the DFA)


---


# Note

Swift treats `\r\n` as a single `Character`. Use `\n\r` to have both.



# Resources

- [regexr.com](http://www.regexr.com) - Regex testing
- [swtch.com](https://swtch.com/~rsc/regexp/) - Implementing Regular Expressions
- [Powerset construction](https://en.wikipedia.org/wiki/Powerset_construction) - NFA to DFA
