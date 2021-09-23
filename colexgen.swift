#!/usr/bin/swift

import Foundation


let fm = FileManager()
let excludes = ["AccentColor"]
var properties = [(name: Substring, propertyName: String)]()

if let contents = fm.enumerator(at: URL(fileURLWithPath: "."), includingPropertiesForKeys: [.isRegularFileKey], options: FileManager.DirectoryEnumerationOptions()) {
	for case let url as URL in contents {
		let attr = try! url.resourceValues(forKeys: [.isRegularFileKey])
		
		if !(attr.isRegularFile ?? true) && url.absoluteString.hasSuffix(".colorset/") {
			
			let path = url.absoluteString
			let last = path.index(path.endIndex, offsetBy: -".colorset/".count)
			if let secondToLast = path[...path.index(before:last)].lastIndex(of: "/") {
				let name = path[path.index(after:secondToLast)..<last]
				
				if (excludes.first {
					$0.caseInsensitiveCompare(name) == .orderedSame
				}) != nil {
					continue;
				}
				let propertyName = name.prefix(1).lowercased() + name.dropFirst()
				properties.append((name, propertyName))
			}
		}
	}
}

var result = """
// generated with colexgen

import SwiftUI

extension Color {

"""

properties.sorted {
	$0.1 < $1.1
}.forEach {
	result.append(
"""
	static var \($0.1): Color {
   		Color("\($0.0)")
	}


""")
}
result.append("}")
print(result)


