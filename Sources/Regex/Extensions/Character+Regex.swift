//
//  Character+Regex.swift
//  Regex
//

extension Character {
	public var unicodeValue: Int {
		return Int(String(self).unicodeScalars.first!.value)
	}
	
	public var hexValue: Int {
		switch self {
		case _ where self.isDigit:
			return self.unicodeValue - Character("0").unicodeValue
		case _ where self >= "a" && self <= "f":
			return self.unicodeValue - Character("a").unicodeValue + 10
		case _ where self >= "A" && self <= "F":
			return self.unicodeValue - Character("A").unicodeValue + 10
		default:
			fatalError("\(self) is not a hexadecimal character")
		}
	}
	
	public var alphabetIndex: Int {
		switch self {
		case _ where self >= "a" && self <= "z":
			return self.unicodeValue - Character("a").unicodeValue + 1
		case _ where self >= "A" && self <= "Z":
			return self.unicodeValue - Character("A").unicodeValue + 1
		default:
			fatalError("\(self) is not in the English alphabet")
		}
	}
	
	public var isLetter: Bool {
		return (self >= "a" && self <= "z") || (self >= "A" && self <= "Z")
	}
	
	public var isDigit: Bool {
		return self >= "0" && self <= "9"
	}
	
	public var isHexDigit: Bool {
		return (
			self.isDigit ||
			(self >= "A" && self <= "F") ||
			(self >= "a" && self <= "f")
		)
	}
	
	public var isOctDigit: Bool {
		return self >= "0" && self <= "7"
	}
	
	internal var isWordCharacter: Bool {
		return self.isLetter || self.isDigit || self == "_"
	}
	
	public var lowercase: Character {
		return String(self).lowercased().first!
	}
}
