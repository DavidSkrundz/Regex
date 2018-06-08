//
//  String.swift
//  Regex
//

extension String {
	public func indexAt(_ distance: Int) -> String.Index {
		if distance >= 0 {
			return self.advanceIndex(self.startIndex, by: distance)
		}
		return self.reverseIndex(self.endIndex, by: -distance)
	}
	
	public subscript(range: Range<Int>) -> String {
		return String(self[
			self.indexAt(range.lowerBound)..<self.indexAt(range.upperBound)
		])
	}
}
