// The Swift Programming Language
// https://docs.swift.org/swift-book

precedencegroup LoaderChainingPrecedence {
    higherThan: NilCoalescingPrecedence
    associativity: right
}

infix operator --> : LoaderChainingPrecedence

@discardableResult
public func --> (lhs: HTTPLoader, rhs: HTTPLoader) -> HTTPLoader {
    lhs.nextLoader = rhs
    return lhs
}
