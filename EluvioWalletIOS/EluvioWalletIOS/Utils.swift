//
//  Utils.swift
//  Utils
//
//  Created by Wayne Tran on 2021-09-27.
//

import Foundation

func loadJsonFile<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

func HexToBytes(_ string: String) -> [UInt8]? {
    var str = string
    print("HexToBytes 1 \(str)")
    
    if(string.hasPrefix("0x")){
        str = String(string.dropFirst(2))
    }
    
    print("HexToBytes 2 \(str)")

    if str.isEmpty{
        print("Error: Length == 0")
        return nil
    }
    
    return str.hexaBytes
}

extension StringProtocol {
    var hexaData: Data { .init(hexa) }
    var hexaBytes: [UInt8] { .init(hexa) }
    private var hexa: UnfoldSequence<UInt8, Index> {
        sequence(state: startIndex) { startIndex in
            guard startIndex < self.endIndex else { return nil }
            let endIndex = self.index(startIndex, offsetBy: 2, limitedBy: self.endIndex) ?? self.endIndex
            defer { startIndex = endIndex }
            return UInt8(self[startIndex..<endIndex], radix: 16)
        }
    }
}
