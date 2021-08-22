#!/usr/bin/swift

import Foundation


let fm = FileManager()
let excludes = ["AccentColor"]

var result = """
// generated with colexgen

import SwiftUI

extension Color {

"""

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
				
				result.append("""
					static var \(propertyName): Color {
						Color("\(name)")
					}


				""")
				
			}
			
		}
	}
}

result.append("}")
print(result)


