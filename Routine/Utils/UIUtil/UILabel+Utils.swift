import UIKit



public extension [UILabel]{
    // label array set same width ( by maxSize )
    func adjustMaxWidth(){
        let max = self.compactMap{ $0.intrinsicContentSize.width }
            .max()
        if let max = max{
            NSLayoutConstraint.activate( self.map { $0.widthAnchor.constraint(equalToConstant: max) })
        }
    }
}
