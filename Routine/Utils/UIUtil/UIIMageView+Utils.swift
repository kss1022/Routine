import UIKit
import Kingfisher


public extension UIImageView{
    
    func load(
        imageUrl : String
    ){
        let url = URL(string: imageUrl)
        
        KF.url(url)          
          .loadDiskFileSynchronously()
          .fade(duration: 0.25)
          .scaleFactor(UIScreen.main.scale)
          .onFailureImage(UIImage(named: "noImage"))
          .set(to: self)
    }
    
    func setIndicator(){
        self.kf.indicatorType = .activity
    }
    
    
    func loadCrop(
        imageUrl : String,
        size : CGSize
    ){
        let processor =  CroppingImageProcessor(size: size) ////anchor: Default is `CGPoint(x: 0.5, y: 0.5)`, which means the center of input image.
        
        let url = URL(string: imageUrl)
        KF.url(url)
            .loadDiskFileSynchronously()
            .setProcessor(processor)
            .fade(duration: 0.25)
            .set(to: self)
    }
    
    
    
    func load(
        imageUrl : String,
        placeholderImage : UIImage?
    ){
        let url = URL(string: imageUrl)
    
        KF.url(url)
          .placeholder(placeholderImage)
          .loadDiskFileSynchronously()
          .fade(duration: 0.25)
          .set(to: self)
    }
    
    func load(
        imageUrl : String,
        placeholderImage : UIImage?,
        size : CGSize,
        radius : CGFloat
    ){
        let url = URL(string: imageUrl)

        let processor = DownsamplingImageProcessor(size: size)
        |> RoundCornerImageProcessor(cornerRadius: radius)
        
        KF.url(url)
          .placeholder(placeholderImage)
          .setProcessor(processor)
          .loadDiskFileSynchronously()
          .fade(duration: 0.25)
          .set(to: self)
    }
    


}


public extension UIButton{
    
    func setImage(
        imageUrl : String
    ){
        
        let url = URL(string: imageUrl)

        self.kf.setImage(
            with: url,
            for: .normal,
            placeholder: UIImage(named: "noImage"),
            options: [
                .loadDiskFileSynchronously,
                .transition(.fade(0.25)),
                .scaleFactor(UIScreen.main.scale),
                .onFailureImage(UIImage(named: "noImage"))
            ])
    }
        
}
