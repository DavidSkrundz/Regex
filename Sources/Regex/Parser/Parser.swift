//
//  Parser.swift
//  Regex
//

import Graph

internal struct Parser {
	private var graph = Graph<Int, Symbol>()
	private var lastVertex: Vertex<Int>!
	
	private init() {
		self.lastVertex = self.graph.addVertex(0)
	}
	
	internal static func parse(_ tokens: [Token]) throws -> Graph<Int, Symbol> {
		var parser = Parser()
		try tokens.generator().forEach { try parser.parse($0) }
		return parser.graph
	}
	
	private mutating func parse(_ token: Token) throws {
		switch token {
			case .Character(let character):
				let newVertex = self.graph.addVertex(self.graph.vertices.count)
				self.graph.addEdge(from: lastVertex, to: newVertex,
				                   data: .Character(character))
				self.lastVertex = newVertex
		}
	}
}
