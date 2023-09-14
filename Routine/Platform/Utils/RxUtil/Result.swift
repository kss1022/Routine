//import Foundation
//import Network
//
//
//public enum Result<T> {
//    case Success(T)
//    case Error(T : Error )
//    case Loading
//}
//
//
//extension Observable {
//    public func asResult() -> Observable<Result<Element>>{
//        self.map{
//            Result.Success($0)
//        }
//        .startWith(Result.Loading)
//        .observe(on : MainScheduler.instance)
//        .catch(catchError)
//    }
//    
//    private func catchError( error : Error) -> Observable<Result<Element>>{
//        .just(Result<Element>.Error(T: error))
//    }
//    
//}


