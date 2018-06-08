//
//  Lexer+Flags.swift
//  Regex
//

extension Lexer {
	/// Processes the leading and trailing `/` if they exist and returns the
	/// `Tokens` associated with the flags
	///
	/// - Parameters:
	///   - pattern:           The pattern to process.
	///                        Gets trimmed if flags are found
	///   - isCaseInsensitive: Gets set to `true` if the `CaseInsensitiveFlag`
	///                        is set
	///
	/// - Returns: The flags
	internal mutating func processFlags() throws {
		if self.state.pattern.first == "/" {
			self.state.pattern.removeFirst()
			while self.state.pattern.count > 0 {
				switch self.state.pattern.removeLast() {
					case "g":
						self.tokens.append(.GlobalSearchFlag)
					case "i":
						self.tokens.append(.CaseInsensitiveFlag)
						self.state.isCaseInsensitive = true
					case "m":
						self.tokens.append(.MultilineFlag)
					case "/":
						return
					default:
						throw RegexError.InvalidFlags
				}
			}
		}
		self.tokens.append(.GlobalSearchFlag)
	}
}
