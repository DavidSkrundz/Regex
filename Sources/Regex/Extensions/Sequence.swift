//
//  Sequence.swift
//  Regex
//

extension Sequence {
	/// Converts the `Sequence` to an `Array<Element>`
	public func toArray() -> [Self.Iterator.Element] {
		return self.map { $0 }
	}
}
