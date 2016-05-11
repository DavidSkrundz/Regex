//
//  Package.swift
//  Regex
//

import PackageDescription

let package = Package(
	name: "Regex",
	dependencies: [
		.Package(url: "https://github.com/DavidSkrundz/UnicodeOperators.git", versions: Version(1,0,0)..<Version(1,1,0)),
		.Package(url: "https://github.com/DavidSkrundz/Util.git", versions: Version(1,0,0)..<Version(1,1,0)),
	]
)

let staticLibrary = Product(
	name: "Regex",
	type: .Library(.Static),
	modules: ["Regex"]
)
let dynamicLibrary = Product(
	name: "Regex",
	type: .Library(.Dynamic),
	modules: ["Regex"]
)

products.append(staticLibrary)
products.append(dynamicLibrary)
