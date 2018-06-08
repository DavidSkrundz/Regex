//
//  Compiler+GroupCorrection.swift
//  Regex
//

extension Compiler {
	/// Applies an `offset` to any `Instruction` that references an instruction index
	fileprivate static func applyGroupCorrection(_ instructions: [Instruction], offset: Int) -> [Instruction] {
		return instructions.map { instruction in
			switch instruction {
				case let .Jump(location):
					return .Jump(location + offset)
				case let .Split(location1, location2):
					return .Split(location1 + offset, location2 + offset)
				default:
					return instruction
			}
		}
	}
}

extension Sequence where Iterator.Element == Instruction {
	/// A helper function to reduce the need for nested functions in favor of chained functions
	internal func offset(_ offset: Int) -> [Instruction] {
		return Compiler.applyGroupCorrection(self.toArray(), offset: offset)
	}
}
