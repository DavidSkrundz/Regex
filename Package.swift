// swift-tools-version:4.1
//
//  Package.swift
//  Regex
//

import PackageDescription

let package = Package(
	name: "Regex",
	products: [
		.library(
			name: "Regex",
			targets: ["Regex"]),
		.library(
			name: "sRegex",
			type: .static,
			targets: ["Regex"]),
		.library(
			name: "dRegex",
			type: .dynamic,
			targets: ["Regex"])
	],
	dependencies: [
		.package(url: "https://github.com/DavidSkrundz/Collections.git",
		         .upToNextMinor(from: "1.1.0"))
	],
	targets: [
		.target(
			name: "Regex",
			dependencies: ["Generator"]),
		.testTarget(
			name: "RegexTests",
			dependencies: ["Regex"])
	]
)
