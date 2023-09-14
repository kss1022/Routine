//import RxSwift
//import RxCocoa
//import UIKit
//
//
//public extension Reactive where Base: UIScrollView {
//            
//    func reachedBottom(offset: CGFloat = 0.0) -> ControlEvent<Void> {
//        let source = contentOffset.map { contentOffset in
//            let currentOffset = self.base.contentOffset.y // frame영역의 origin에 비교했을때의 content view의 현재 origin 위치
//            if currentOffset < 0 { return false }
//            
//            let maximumOffset = self.base.contentSize.height - self.base.frame.size.height // 화면에는 frame만큼 가득 찰 수 있기때문에 frame의 height를 빼준 것
//            
//            return maximumOffset  <= currentOffset
//        }
//        .distinctUntilChanged()
//        .filter { $0 }
//        .map { _ in () }
//        return ControlEvent(events: source)
//    }
//    
//    func pullDown() -> Observable<Bool>{
//        willBeginDecelerating
//            .map {  _ -> Bool in
//                let currentOffset = self.base.contentOffset.y // frame영역의 origin에 비교했을때의 content view의 현재 origin 위치
//                if currentOffset < 0 { return false }
//                
//                let maximumOffset = self.base.contentSize.height - self.base.frame.size.height // 화면에는 frame만큼 가득 찰 수 있기때문에 frame의 height를 빼준 것
//                
//                return maximumOffset < currentOffset
//            }
//    }
//}
//
//
//
//
////    tableView.rx.willBeginDecelerating
////        .withUnretained(tableView)
////        .map { scrollView , _ -> Bool in
////            let currentOffset = scrollView.contentOffset.y // frame영역의 origin에 비교했을때의 content view의 현재 origin 위치
////            if currentOffset < 0 { return false }
////
////            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height // 화면에는 frame만큼 가득 찰 수 있기때문에 frame의 height를 빼준 것
////
////            return maximumOffset < currentOffset
////        }
////        .filter { $0 }
////        .bind(to: isPaging)
////        .disposed(by: disposeBag)
