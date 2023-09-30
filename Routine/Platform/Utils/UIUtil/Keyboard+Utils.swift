//
//  Keyboard+Utils.swift
//  Routine
//
//  Created by 한현규 on 2023/09/25.
//

import UIKit
import Combine

public protocol CombineKeyboardType {
    var frame: AnyPublisher<CGRect, Never> { get }
    var visibleHeight: AnyPublisher<CGFloat, Never> { get }
    var willShowVisibleHeight: AnyPublisher<CGFloat, Never> { get }
    var isHidden: AnyPublisher<Bool, Never> { get }
}

public class CombineKeyboard: NSObject, CombineKeyboardType {

    public static let shared = CombineKeyboard()

    public var frame: AnyPublisher<CGRect, Never>
    public var visibleHeight: AnyPublisher<CGFloat, Never>
    public var willShowVisibleHeight: AnyPublisher<CGFloat, Never>
    public var isHidden: AnyPublisher<Bool, Never>

    private var cancellables = Set<AnyCancellable>()
    private let panRecognizer = UIPanGestureRecognizer()

    private override init() {
        let keyboardWillChangeFrame = NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)
        let keyboardWillHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
        let keyboardFrameEndKey = UIResponder.keyboardFrameEndUserInfoKey

        let defaultFrame = CGRect(
            x: 0,
            y: UIScreen.main.bounds.height,
            width: UIScreen.main.bounds.width,
            height: 0
        )
        let frameSubject = CurrentValueSubject<CGRect, Never>(defaultFrame)
        self.frame = frameSubject.eraseToAnyPublisher()
        self.visibleHeight = self.frame.map { UIScreen.main.bounds.intersection($0).height }
            .eraseToAnyPublisher()
        self.willShowVisibleHeight = self.visibleHeight.scan((visibleHeight: 0, isShowing: false)) { lastState, newVisibleHeight in
            return (visibleHeight: newVisibleHeight, isShowing: lastState.visibleHeight == 0 && newVisibleHeight > 0)
        }
        .filter { state in state.isShowing }
        .map { state in state.visibleHeight }
        .eraseToAnyPublisher()
        self.isHidden = self.visibleHeight.map({ $0 == 0.0 }).eraseToAnyPublisher()
        super.init()

        // Keyboard will change frame
        let willChangeFrame = keyboardWillChangeFrame
            .compactMap { notification -> CGRect? in
                let rectValue = notification.userInfo?[keyboardFrameEndKey] as? NSValue
                return rectValue?.cgRectValue
            }
            .map { frame -> CGRect in
                if frame.origin.y < 0 {
                    var newFrame = frame
                    newFrame.origin.y = UIScreen.main.bounds.height - newFrame.height
                    return newFrame
                }
                return frame
            }
            .eraseToAnyPublisher()

        // Keyboard will hide
        let willHide = keyboardWillHide
            .compactMap { notification -> CGRect? in
                let rectValue = notification.userInfo?[keyboardFrameEndKey] as? NSValue
                return rectValue?.cgRectValue
            }
            .map { frame -> CGRect in
                if frame.origin.y < 0 {
                    var newFrame = frame
                    newFrame.origin.y = UIScreen.main.bounds.height
                    return newFrame
                }
                return frame
            }
            .eraseToAnyPublisher()

        // Pan gesture
        
        
        let didPan = panRecognizer.publisher()
            .withLatestFrom(frameSubject) { ($0, $1) }
            .flatMap { (gestureRecognizer, frame) -> AnyPublisher<CGRect, Never> in
                guard case .changed = gestureRecognizer.state,
                    let window = UIApplication.shared.windows.first,
                    frame.origin.y < UIScreen.main.bounds.height
                else { return Empty().eraseToAnyPublisher() }

                let origin = gestureRecognizer.location(in: window)
                var newFrame = frame
                newFrame.origin.y = max(origin.y, UIScreen.main.bounds.height - frame.height)
                return Just(newFrame).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()


            
        Publishers.Merge3(didPan, willChangeFrame, willHide)
            .sink(receiveValue: { frameSubject.send($0) })
            .store(in: &cancellables)

        // Gesture recognizer
        panRecognizer.delegate = self
        panRecognizer.maximumNumberOfTouches = 1

        UIApplication.shared.windows.first?.addGestureRecognizer(panRecognizer)
    }
}

extension CombineKeyboard: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let point = touch.location(in: gestureRecognizer.view)
        var view = gestureRecognizer.view?.hitTest(point, with: nil)
        while let candidate = view {
            if let scrollView = candidate as? UIScrollView,
                case .interactive = scrollView.keyboardDismissMode {
                return true
            }
            view = candidate.superview
        }
        return false
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        gestureRecognizer === self.panRecognizer
    }
}



extension UIPanGestureRecognizer {
    func publisher() -> UIGestureRecognizer.GesturePublisher<UIPanGestureRecognizer> {
        return GesturePublisher(recognizer: self)
    }
}


extension UIGestureRecognizer {
  struct GesturePublisher<GestureRecognizer: UIGestureRecognizer>: Publisher {
    typealias Output = GestureRecognizer
    typealias Failure = Never
    
    private let recognizer: GestureRecognizer
    
    init(recognizer: GestureRecognizer) {
      self.recognizer = recognizer
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, GestureRecognizer == S.Input {
      let subscription = GestureSubscription(
        subscriber: subscriber,
        recognizer: recognizer
      )
      subscriber.receive(subscription: subscription)
    }
  }
}


extension UIGestureRecognizer {
    final class GestureSubscription<S: Subscriber, GestureRecognizer: UIGestureRecognizer>: Subscription
    where S.Input == GestureRecognizer {
        private var subscriber: S?
        private let recognizer: GestureRecognizer
        
        init(subscriber: S, recognizer: GestureRecognizer) {
            self.subscriber = subscriber
            self.recognizer = recognizer
            recognizer.addTarget(self, action: #selector(eventHandler))
            //event.addGestureRecognizer(recognizer)
        }
        
        func request(_ demand: Subscribers.Demand) {}
        
        func cancel() {
            subscriber = nil
        }
        
        @objc func eventHandler() {
            _ = subscriber?.receive(recognizer)
        }
    }
}
