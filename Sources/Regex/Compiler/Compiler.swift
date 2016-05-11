//
//  Compiler.swift
//  Regex
//

/// The `Compiler` takes a `[Symbol]` and converts it to a `[Instruction]` that is runnable by the `Engine`
///
/// - Author: David Skrundz
internal struct Compiler {
	/// The entry point into the `Compiler`
	///
	/// - Returns: The compiled `[Instruction]`
	internal static func compile(_ symbols: [Symbol]) -> [Instruction] {
		var groupCount = 0
		return compileSymbols(symbols, captureGroupCount: &groupCount)
	}
	
	/// The core of the processing done by the compiler. This function calls out to other compiler functions for specific tasks
	internal static func compileSymbols(_ symbols: [Symbol], captureGroupCount: inout Int) -> [Instruction] {
		var flags = [Instruction]()
		var instructions = [Instruction]()
		
		var symbolGenerator = symbols.generator()
		while let symbol = symbolGenerator.next() {
			if symbol.isQuantifier {
				instructions += compileQuantifier(symbol, captureGroupCount: &captureGroupCount, instructions.count)
				continue
			}
			
			switch symbol {
				case .GlobalSearchFlag:    flags.append(.GlobalSearchFlag)
				case .CaseInsensitiveFlag: flags.append(.CaseInsensitiveFlag)
				case .MultilineFlag:       flags.append(.MultilineFlag)
				
				case let .Character(character):
					instructions.append(.Character(character))
				
				case let .CharacterSet(includeSet, exlcudeSet):
					instructions.append(.CharacterSet(include: includeSet, exclude: exlcudeSet))
				
				case let .CaptureGroup(groupSymbols):
					captureGroupCount += 1
					let currentGroup = captureGroupCount
					instructions.append(.GroupSave(currentGroup, .Start))
					let instructionStartIndex = instructions.count
					let groupInstructions = compileSymbols(groupSymbols, captureGroupCount: &captureGroupCount).offset(instructionStartIndex)
					instructions += groupInstructions
					instructions.append(.GroupSave(currentGroup, .End))
				case let .Group(groupSymbols):
					let instructionStartIndex = instructions.count
					let groupInstructions = compileSymbols(groupSymbols, captureGroupCount: &captureGroupCount).offset(instructionStartIndex)
					instructions += groupInstructions
				case let .LookAheadGroup(groupSymbols):
					instructions.append(.StartLookAhead)
					let instructionStartIndex = instructions.count
					let groupInstructions = compileSymbols(groupSymbols, captureGroupCount: &captureGroupCount).offset(instructionStartIndex)
					instructions += groupInstructions
					instructions.append(.EndLook)
				case let .NegativeLookAheadGroup(groupSymbols):
					instructions.append(.StartNegativeLookAhead)
					let instructionStartIndex = instructions.count
					let groupInstructions = compileSymbols(groupSymbols, captureGroupCount: &captureGroupCount).offset(instructionStartIndex)
					instructions += groupInstructions
					instructions.append(.EndLook)
				case let .LookBehindGroup(groupSymbols):
					instructions.append(.StartLookBehind)
					let instructionStartIndex = instructions.count
					let groupInstructions = compileSymbols(groupSymbols, captureGroupCount: &captureGroupCount).offset(instructionStartIndex)
					instructions += groupInstructions
					instructions.append(.EndLook)
				case let .NegativeLookBehindGroup(groupSymbols):
					instructions.append(.StartNegativeLookBehind)
					let instructionStartIndex = instructions.count
					let groupInstructions = compileSymbols(groupSymbols, captureGroupCount: &captureGroupCount).offset(instructionStartIndex)
					instructions += groupInstructions
					instructions.append(.EndLook)
				
				case let .BackReference(group):
					instructions.append(.BackReference(group))
				
				case .Start:           instructions.append(.Start)
				case .End:             instructions.append(.End)
				case .WordBoundary:    instructions.append(.WordBoundary)
				case .NotWordBoundary: instructions.append(.NotWordBoundary)
				
				case let .Alternation(lhs, rhs):
					let startIndex = instructions.count + 1
					let leftInstructions = compile(lhs).offset(startIndex)
					let midIndex = startIndex + leftInstructions.count + 1
					let rightInstructions = compile(rhs).offset(midIndex)
					let endIndex = midIndex + rightInstructions.count
					instructions.append(.Split(startIndex, midIndex))
					instructions += leftInstructions
					instructions.append(.Jump(endIndex))
					instructions += rightInstructions
				
				default: ()
			}
		}
		
		return flags + instructions
	}
}
