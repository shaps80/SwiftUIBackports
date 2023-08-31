import SwiftUI

extension EnvironmentValues {
    var dump: String {
        let keys = asTextualRepresentationWithNonReaptingKeys

        return """
        --- Environment Values - BEGIN ---
        \(keys.map { $0 }.joined(separator: "\n"))
        --- Environment Values - END   ---
        """
    }
}

private extension EnvironmentValues {
    var asTextualRepresentationWithNonReaptingKeys: [String] {
        // split description into lines starting with EnvironmentPropertyKey
        let lineIndices = description.indices(of: "EnvironmentPropertyKey")
        var entries: [String] = []
        for (idx, beginIndexValue) in lineIndices.enumerated() {
            let next: Int = idx + 1
            if idx == lineIndices.count - 1 {
                continue
            }
            let nextIndexValue = lineIndices[next]
            let beginIndex = description.index(description.startIndex, offsetBy: beginIndexValue)
            let endIndex = description.index(description.startIndex, offsetBy: nextIndexValue)
            guard let line = String(description[beginIndex ... endIndex]).components(separatedBy: ", E").first else { continue }
            entries.append(line)
        }

        // filter out lines with repeating EnvironmentPropertyKey's because only the top level value is relevant
        var processedKeys: [String] = []
        entries = entries.filter { line in
            var isIncluded = false
            guard let key = line.components(separatedBy: "=").first else {
                return isIncluded
            }
            if !processedKeys.contains(key) {
                isIncluded = true
            }
            processedKeys.append(key)
            return isIncluded
        }
        return entries
    }
}

// Credit: https://gist.github.com/BetterProgramming/ac4f639c915ef0560fcca5208d9456f9#file-firstoccur-swift
private extension String {
    func indices(of occurrence: String) -> [Int] {
        var indices = [Int]()
        var position = startIndex
        while let range = range(of: occurrence, range: position ..< endIndex) {
            let i = distance(from: startIndex,
                             to: range.lowerBound)
            indices.append(i)
            let offset = occurrence.distance(from: occurrence.startIndex,
                                             to: occurrence.endIndex) - 1
            guard let after = index(range.lowerBound,
                                    offsetBy: offset,
                                    limitedBy: endIndex)
            else {
                break
            }
            position = index(after: after)
        }
        return indices
    }
}
