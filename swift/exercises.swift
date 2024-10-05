import Foundation

struct NegativeAmountError: Error {}
struct NoSuchFileError: Error {}

func change(_ amount: Int) -> Result<[Int:Int], NegativeAmountError> {
    if amount < 0 {
        return .failure(NegativeAmountError())
    }
    var (counts, remaining) = ([Int:Int](), amount)
    for denomination in [25, 10, 5, 1] {
        (counts[denomination], remaining) = 
            remaining.quotientAndRemainder(dividingBy: denomination)
    }
    return .success(counts)
}

func firstThenLowerCase(of strings: [String], satisfying predicate: (String) -> Bool) -> String? {
    return strings.first(where: predicate)?.lowercased()
}

struct Sayer{
    let phrase: String

    func and(_ word: String) -> Sayer {
        return Sayer(phrase: "\(phrase) \(word)")
    }
}
func say(_ word: String = "") -> Sayer {
    return Sayer(phrase: word)
}  

enum FileError: Error {
    case fileNotFound
    case unreadable
}

func meaningfulLineCount(_ filename: String) async -> Result<Int, FileError> {
    let fileURL = URL(fileURLWithPath: filename)

    do {
        let fileContents = try String(contentsOf: fileURL)
        let lines = fileContents.split(separator: "\n")
        let meaningfulLines = lines.filter { line in
            let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
            return !trimmedLine.isEmpty && !trimmedLine.hasPrefix("#")
        }
        return .success(meaningfulLines.count)
    } catch {
        return .failure(.fileNotFound)
    }
}

public struct Quaternion: CustomStringConvertible, Equatable {
    let a, b, c, d: Double

    static let ZERO = Quaternion(a: 0, b: 0, c: 0, d: 0)
    static let I = Quaternion(a: 0, b: 1, c: 0, d: 0)
    static let J = Quaternion(a: 0, b: 0, c: 1, d: 0)
    static let K = Quaternion(a: 0, b: 0, c: 0, d: 1)

    init(a: Double = 0, b: Double = 0, c: Double = 0, d: Double = 0) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }

    public var coefficients: [Double] {
        return [a, b, c, d]
    }

    public var conjugate: Quaternion {
        return Quaternion(a: a, b: -b, c: -c, d: -d)
    }

    static func + (lhs: Quaternion, rhs: Quaternion) -> Quaternion {
        return Quaternion(a: lhs.a + rhs.a, b: lhs.b + rhs.b, c: lhs.c + rhs.c, d: lhs.d + rhs.d)
    }

    static func * (lhs: Quaternion, rhs: Quaternion) -> Quaternion {
        return Quaternion(
            a: lhs.a * rhs.a - lhs.b * rhs.b - lhs.c * rhs.c - lhs.d * rhs.d,
            b: lhs.a * rhs.b + lhs.b * rhs.a + lhs.c * rhs.d - lhs.d * rhs.c,
            c: lhs.a * rhs.c - lhs.b * rhs.d + lhs.c * rhs.a + lhs.d * rhs.b,
            d: lhs.a * rhs.d + lhs.b * rhs.c - lhs.c * rhs.b + lhs.d * rhs.a
        )
    }

    public var description: String {
        let terms: [(Double, String)] = [(a, ""), (b, "i"), (c, "j"), (d, "k")]

        var parts: [String] = []

        for (coefficient, unit) in terms {
            guard coefficient != 0 else { continue }

            if abs(coefficient) == 1 && !unit.isEmpty {
                parts.append(coefficient > 0 ? "+\(unit)" : "-\(unit)")
            } else {
                parts.append(coefficient > 0 ? "+\(coefficient)\(unit)" : "\(coefficient)\(unit)")
            }
        }

        let result = parts.joined()
        
        return result.isEmpty ? "0" : (result.first == "+" ? String(result.dropFirst()) : result)
    }
}

enum BinarySearchTree: CustomStringConvertible {
    case empty
    indirect case node(BinarySearchTree, String, BinarySearchTree)

    var isEmpty: Bool {
        switch self {
        case .empty:
            return true
        case .node:
            return false
        }
    }

    var size: Int {
        switch self {
        case .empty:
            return 0
        case let .node(left, _, right):
            return left.size + 1 + right.size
        }
    }

    func insert(_ newValue: String) -> BinarySearchTree {
        switch self {
        case .empty:
            return .node(.empty, newValue, .empty)
        case let .node(left, value, right):
            if newValue < value {
                return .node(left.insert(newValue), value, right)
            } else {
                return .node(left, value, right.insert(newValue))
            }
        }
    }

    func contains(_ x: String) -> Bool {
        switch self {
        case .empty:
            return false
        case let .node(left, value, right):
            if x == value {
                return true
            } else if x < value {
                return left.contains(x)
            } else {
                return right.contains(x)
            }
        }
    }

    var description: String {
        switch self {
        case .empty:
            return "()"
        case let .node(left, value, right):
            let leftDescription = left.isEmpty ? "" : left.description
            let rightDescription = right.isEmpty ? "" : right.description
            return "(\(leftDescription)\(value)\(rightDescription))"
        }
    }
}