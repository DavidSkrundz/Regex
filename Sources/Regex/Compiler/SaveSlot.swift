//
//  SaveSlot.swift
//  Regex
//

/// Specifies if the stringPointer should be saved in the `Start` or `End` slot
internal enum SaveSlot {
	case Start
	case End
}

extension SaveSlot: Equatable {}
func ==(lhs: SaveSlot, rhs: SaveSlot) -> Bool {
	switch (lhs, rhs) {
		case (.Start, .Start): return true
		case (.Start, _):      return false
		case (.End,   .End):   return true
		case (.End,   _):      return false
	}
}
