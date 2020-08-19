**Regular expressions** are patterns we can use to search for information of interest in a set of strings. 

**Patterns are building blocks of regex.** We can construct complex regex by concatenating a series of patterns, and we can analyze a complex regex by breaking it down into its component patterns.

## Basic Matching

### **Alphanumeric Characters**

To match alphanumeric characters, place the letter or number between two slashes (`/`): `/cats/` will match any "cats". Note that it's case sensitive.

### **Special Characters**

The following special characters are meta-characters (i.e. have special meaning) in Ruby or JS regex:
`$ ^ * + ? . ( ) [ ] { } | \ /`
To match a literal meta-characer, we must escape it using a backslash (`\`).

### **Concatenation**

We can concatenate two or more patterns into a new pattern. For example, the regex `/cat/` concatenates the `c`, `a`, and `t` patterns to match any string containing "cat".

### **Alternation**

Alternation is a simple way to construct a regex that matches one of several sub-patterns. We write two or more patterns separated by pipe (`|`) characters, and then surround the entire expresion in parentheses.

Example: `happ(y|ier|iest|ily)` will match "happy", "happier", "happiest", or "happily". 

### **Control Character Escapes**

We use control character escapes to represent characters that don't have a visual representation (i.e. various space characters).
- `\n`: new line
- `\r`: carriage return
- `\t`: tab

### **Ignoring Case**

Make the regex case-insensitive by adding the `i` *flag/modifier* to the close `/` of the regex: `/PuPpi/i` will match "puppi", "PUPPI", "Puppi", ...

## Character Classes

**Character classes** are patterns that let us specify a set of characters we want to match.

### **Set of Characters**

Character class patterns use a list of characters between square brackets: `/[abc]/`. It matches a single occurence of any of the characters between the brackets. 

Inside a character class, these are the special characters/meta-characters: `^ \ - [ ]`.

### **Range of Characters**

We can abbreviate ranges of characters inside a character class using the hyphen (`-`): `/[0-9A-Fa-f]/` will match any hexidecimal digit (notice the concatenation of ranges!).

### **Negated Classess**

We can negate characters by using the caret (`^`) as the first character between the brackets. The negated class matches all characters not identified in the range.

Example: `/[^0-9]/` will match everything except decimal digits.

## Character Class Shortcuts

We can use all of these shortcuts in- or outside square brackets (`[ ]`).

**Any character**: `.` will match any character 
  - Except newline characters. Use the `/m` option/modifier to match newlines.

**Whitespace**: `\s`; equivalent to `[ \t\v\r\n\f]`.
Non-whitespace: `\S` will match any non-whitespace character.
  Can use these inside and outside of square brackets

**Digits**: `\d` will match 0-9
Non-digit: `\D` will match any character except 0-9
  Can use these inside and outside of square brackets

**Hexadecimal digit**: `\h` will match 0-9, A-F, a-f.
Non-hex-dec: `\H` will match any character not in the hexadecimal digits

**Word characters**: `\w` matches "word characters" - a-z, A-Z, 0-9, and underscore (`_`).
Non-word chracters: `\W`

## Anchors

Anchors limit how a regex matches a particular string: it tells the regex engine where matches can begin and end.

**Beginning of line**: `^` 

Example: `/^cat/` will match "catastrophe", but not "I love my cat". 

**End of line**: `$` 

Example: `/cat$/` will match "I love my cat", but not "catastrophe".

**Word Boundaries**

*Recall*: word characters are a-z, A-Z, 0-9, and underscore.

A word boundary occurs: 
- between any pair of characters, one of which is a word character and the other is not
- beginning of a string if the first character is a word character
- end of the string if the last character is a word character

*Anchor to word boundaries with `\b`.*

A non-word boundary occurs:
- between any pair of characters, both of which are word character or both of which are non-word characters
- at the beginning of a string if the first character is a non-word character
- at the end of a string if the last character is a non-word character

*Anchor to non-word boundaries with `\B`.*

## Quantifiers

**Zero or more**: `*` matches >=0 occurrences of the pattern to its left.

**One or more**: `+` matches >=1 occurrence of the pattern to its left

**Zero or one**: `?` matches 0 or 1 occurence(s) of the pattern to its left.

**Ranges of repeat**: 
- `p{m}` matches pattern `p` precisely `m` times
- `p{m,}` matches pattern `p` `m` or more times
- `p{m,n}` matches pattern `p` `m` to `n` times

**Greediness**: the quantifiers above are **greedy**, meaning they always match the longest possible string they can. 

For example, matching `/a[abc]*c/` against `xabcbcbacy` yields `abcbcbac`, not `abc` or `abcbc`. 

If we want to match the *fewest number of characters* possible, we want a **lazy** match. 

For a lazy match: Add `?` after the main quantifier.

## Using Regex in Ruby and JS

**Capture Groups**
