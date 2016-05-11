//
//  ThreadID+Testing.swift
//  Regex
//

@testable import Regex

extension ThreadID {
	init() {
		self.globalID = 0
		self.parentIDs = [0]
	}
}
