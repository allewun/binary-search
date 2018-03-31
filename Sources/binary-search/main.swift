import Foundation
import Core
import Commander

command(
    Argument<String>("file", description: "The sorted file to search."),
    Argument<String>("string", description: "The string to search for.")
) { file, string in
    guard let searcher = BinarySearch(in: file) else { exit(1) }
    guard let match = searcher.search(for: string) else { exit(1) }
    
    print(match)
    exit(0)
}.run()
