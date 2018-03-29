//
//  main.swift
//  binary-search
//
//  Created by Allen Wu on 2018-03-28.
//  Copyright © 2018 allewun. All rights reserved.
//

import Foundation

public class SortedFileSearcher {
    
    private let handle: FileHandle
    private let max: UInt64
    private let bufferSize: Int = 128
    private let delimiter: String = "\r\n"
    
    deinit {
        handle.closeFile()
    }
    
    public init?(filePath: String) {
        guard let handle = FileHandle(forReadingAtPath: filePath) else { return nil }
        
        handle.seekToEndOfFile()
        
        self.handle = handle
        self.max = handle.offsetInFile
        
        handle.seek(toFileOffset: 0)
    }
    
    public func search(for needle: String) -> String? {
        print("Searching for \"\(needle)\"...")
        return _binarySearch(needle: needle, lo: 0, hi: nil)
    }
    
    private func _binarySearch(needle: String, lo: UInt64, hi: UInt64?) -> String? {
        // seek to middle of file
        let mid = ((hi ?? max) + lo) / 2
        handle.seek(toFileOffset: mid)
        
        // fill text buffer
        let data = handle.readData(ofLength: bufferSize)
        guard let block = String(data: data, encoding: .utf8) else { return nil }
    
        // remove partial lines of text
        let lines = block.components(separatedBy: delimiter)
        guard lines.count >= 3 else { return nil }
        let fullLines = lines.dropFirst().dropLast()
        
        print(fullLines)
        
        // search within buffer
        for line in fullLines {
            if line.hasPrefix(needle) {
                return line
            }
        }
        
        // no match found in buffer, so binary search!
        let headAdjustment = UInt64(lines.first!.count)
        let tailAdjustment = UInt64(lines.last!.count)
        
        guard (hi ?? max) - lo > bufferSize else { return nil }
        
        if needle > fullLines.first! {
            // needle must exist in the latter half of the file
            return _binarySearch(needle: needle, lo: mid + UInt64(bufferSize) - tailAdjustment, hi: hi)
        }
        else {
            // needle must exist in the first half of the file
            return _binarySearch(needle: needle, lo: lo, hi: mid + headAdjustment)
        }
    }
}

