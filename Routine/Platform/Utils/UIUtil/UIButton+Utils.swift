import UIKit


extension UIButton{
    func setImage(image : UIImage? , state : UIControl.State){
        
        contentVerticalAlignment = .fill
        contentHorizontalAlignment = .fill
        
        imageView?.contentMode = .scaleAspectFit
        imageEdgeInsets = .zero
        
        setImage(image, for: state)
    }
}
