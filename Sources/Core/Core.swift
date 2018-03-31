//
//  Core.swift
//  binary-search
//
//  Created by Allen Wu on 2018-03-28.
//  Copyright © 2018 allewun. All rights reserved.
//

import Foundation

public class BinarySearch {
    
    private let handle: FileHandle
    private let max: UInt64
    private let lineEnding: LineEnding
    private let bufferSize: Int = 128
    
    private enum LineEnding: String {
        case unix = "\n"
        case windows = "\r\n"
    }
    
    deinit {
        handle.closeFile()
    }
    
    public init?(in filePath: String) {
        guard let handle = FileHandle(forReadingAtPath: filePath) else { return nil }
  
        func detectLineEnding(handle: FileHandle, sampleSize: Int) -> LineEnding? {
            handle.seek(toFileOffset: 0)
            let data = handle.readData(ofLength: sampleSize)
            guard let string = String(data: data, encoding: .utf8) else { return nil }
            return [LineEnding.windows, .unix].first { string.contains($0.rawValue) }
        }
        
        self.handle = handle
        self.max = handle.seekToEndOfFile()
        self.lineEnding = detectLineEnding(handle: handle, sampleSize: bufferSize) ?? .unix
        
        handle.seek(toFileOffset: 0)
    }
    
    public func search(for needle: String) -> String? {
        return binarySearch(needle: needle, lo: 0, hi: max)
    }
    
    private func binarySearch(needle: String, lo: UInt64, hi: UInt64) -> String? {
        guard hi > lo, lo >= 0, hi <= max else { return nil }
        
        // if bufferSize exceeds filesize, just search directly
        guard bufferSize < hi - lo else {
            if let buffer = textBuffer(atFileOffset: lo) {
                return firstMatch(for: needle, within: Array(buffer))
            }
            return nil
        }
        
        // fill text buffer from middle of file
        let mid = (hi + lo) / 2
        guard let rawBuffer = textBuffer(atFileOffset: mid), rawBuffer.count >= 3 else { return nil }
        let buffer = rawBuffer.dropFirst().dropLast()

        // search within buffer
        if let match = firstMatch(for: needle, within: Array(buffer)) {
            return match
        }

        // no match found in buffer, so begin binary search
        if needle > buffer.first! {
            // needle must exist in the latter half of the file
            let tailAdjustment = UInt64(rawBuffer.last!.count)
            return binarySearch(needle: needle, lo: mid + UInt64(bufferSize) - tailAdjustment, hi: hi)
        }
        else {
            // needle must exist in the first half of the file
            let headAdjustment = UInt64(rawBuffer.first!.count)
            return binarySearch(needle: needle, lo: lo, hi: mid + headAdjustment)
        }
    }
    
    private func textBuffer(atFileOffset offset: UInt64) -> [String]? {
        handle.seek(toFileOffset: offset)
        let data = handle.readData(ofLength: bufferSize)
        guard let string = String(data: data, encoding: .utf8) else { return nil }
        return string.components(separatedBy: lineEnding.rawValue)
    }
    
    private func firstMatch(for needle: String, within lines: [String]) -> String? {
        return lines.first { $0.hasPrefix(needle) }
    }
}
