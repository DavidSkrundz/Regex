//
//  Character+Regex.swift
//  Regex
//

extension Character {
	internal var isWordCharacter: Bool {
		return self.isLetter || self.isDigit || self == "_"
	}
}