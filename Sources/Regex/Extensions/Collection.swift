//
//  Collection.swift
//  Regex
//

extension Collection {
	public func advanceIndex(_ index: Self.Index,
							 by amount: Int) -> Self.Index {
		return self.index(index, offsetBy: amount, limitedBy: self.endIndex)
			?? self.endIndex
	}
	
	public func reverseIndex(_ index: Self.Index,
							 by amount: Int) -> Self.Index {
		return self.index(index, offsetBy: -amount, limitedBy: self.startIndex)
			?? self.startIndex
	}
}
