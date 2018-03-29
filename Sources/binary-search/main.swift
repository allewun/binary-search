import Foundation
import Core

let arguments = CommandLine.arguments

if arguments.count != 3 {
    print("Usage: ./binary-search <string> <file>")
    exit(1)
}

guard let searcher = SortedFileSearcher(filePath: arguments[2]) else { exit(1) }

if let match = searcher.search(for: arguments[1]) {
    print("Found match: \"\(match)\"")
}
else {
    print("No match found for \"\(arguments[1])\"")
}

