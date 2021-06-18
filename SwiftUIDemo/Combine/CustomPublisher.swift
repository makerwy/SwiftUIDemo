//
//  CustomPublisher.swift
//  SwiftUIDemo
//
//  Created by wy on 2021/6/18.
//

import Foundation
import Combine

public extension AnyPublisher {

    init(_ factory: @escaping Publishers.Create<Output, Failure>.SubscriberHandler) {
        self = Publishers.Create(factory: factory).eraseToAnyPublisher()
    }

    static func create(_ factory: @escaping Publishers.Create<Output, Failure>.SubscriberHandler)
        -> AnyPublisher<Output, Failure> {
        AnyPublisher(factory)
    }
}

public extension Publishers {
    /// A publisher which accepts a closure with a subscriber argument,
    /// to which you can dynamically send value or completion events.
    ///
    /// You should return a `Cancelable`-conforming object from the closure in
    /// which you can define any cleanup actions to execute when the pubilsher
    /// completes or the subscription to the publisher is canceled.
    struct Create<Output, Failure: Swift.Error>: Publisher {
        
        public typealias SubscriberHandler = (Subscriber) -> Cancellable
        
        private let factory: SubscriberHandler

        /// Initialize the publisher with a provided factory
        ///
        /// - parameter factory: A factory with a closure to which you can
        ///                      dynamically push value or completion events
        public init(factory: @escaping SubscriberHandler) {
            self.factory = factory
        }
        
        public func receive<S: Combine.Subscriber>(subscriber: S) where Failure == S.Failure, Output == S.Input {
            subscriber.receive(subscription: Subscription(factory: factory, downstream: subscriber))
        }
    }
}

public extension Publishers.Create {
    struct Subscriber {
        private let onValue: (Output) -> Void
        private let onCompletion: (Subscribers.Completion<Failure>) -> Void

        fileprivate init(onValue: @escaping (Output) -> Void,
                         onCompletion: @escaping (Subscribers.Completion<Failure>) -> Void) {
            self.onValue = onValue
            self.onCompletion = onCompletion
        }

        /// Sends a value to the subscriber.
        ///
        /// - Parameter value: The value to send.
        public func send(_ input: Output) {
            onValue(input)
        }

        /// Sends a completion event to the subscriber.
        ///
        /// - Parameter completion: A `Completion` instance which indicates whether publishing has finished normally or failed with an error.
        public func send(completion: Subscribers.Completion<Failure>) {
            onCompletion(completion)
        }
    }
}

private extension Publishers.Create {
    class Subscription<Downstream: Combine.Subscriber>: Combine.Subscription where Output == Downstream.Input, Failure == Downstream.Failure {
        private let buffer: DemandBuffer<Downstream>
        private var cancelable: Cancellable?

        init(factory: @escaping SubscriberHandler,
             downstream: Downstream) {
            self.buffer = DemandBuffer(subscriber: downstream)

            let subscriber = Subscriber(onValue: { [weak self] in _ = self?.buffer.buffer(value: $0) },
                                        onCompletion: { [weak self] in self?.buffer.complete(completion: $0) })

            self.cancelable = factory(subscriber)
        }

        func request(_ demand: Subscribers.Demand) {
            _ = self.buffer.demand(demand)
        }

        func cancel() {
            self.cancelable?.cancel()
        }
    }
}

class DemandBuffer<S: Subscriber> {
    private let lock = NSRecursiveLock()
    private var buffer = [S.Input]()
    private let subscriber: S
    private var completion: Subscribers.Completion<S.Failure>?
    private var demandState = Demand()

    init(subscriber: S) {
        self.subscriber = subscriber
    }

    func buffer(value: S.Input) -> Subscribers.Demand {
        precondition(self.completion == nil,
                     "How could a completed publisher sent values?! Beats me  ‍♂️")

        switch demandState.requested {
        case .unlimited:
            return subscriber.receive(value)
        default:
            buffer.append(value)
            return flush()
        }
    }

    func complete(completion: Subscribers.Completion<S.Failure>) {
        precondition(self.completion == nil,
                     "Completion have already occured, which is quite awkward  ")

        self.completion = completion
        _ = flush()
    }

    func demand(_ demand: Subscribers.Demand) -> Subscribers.Demand {
        flush(adding: demand)
    }

    private func flush(adding newDemand: Subscribers.Demand? = nil) -> Subscribers.Demand {
        lock.lock()
        defer { lock.unlock() }

        if let newDemand = newDemand {
            demandState.requested += newDemand
        }

        // If buffer isn't ready for flushing, return immediately
        guard demandState.requested > 0 || newDemand == Subscribers.Demand.none else { return .none }

        while !buffer.isEmpty && demandState.processed < demandState.requested {
            demandState.requested += subscriber.receive(buffer.remove(at: 0))
            demandState.processed += 1
        }

        if let completion = completion {
            // Completion event was already sent
            buffer = []
            demandState = .init()
            self.completion = nil
            subscriber.receive(completion: completion)
            return .none
        }

        let sentDemand = demandState.requested - demandState.sent
        demandState.sent += sentDemand
        return sentDemand
    }
}

private extension DemandBuffer {
    /// A model that tracks the downstream's
    /// accumulated demand state
    struct Demand {
        var processed: Subscribers.Demand = .none
        var requested: Subscribers.Demand = .none
        var sent: Subscribers.Demand = .none
    }
}
