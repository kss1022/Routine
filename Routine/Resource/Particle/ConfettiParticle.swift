//
//  ConfettiParticle.swift
//  Routine
//
//  Created by 한현규 on 11/1/23.
//

import UIKit




final class ConfettiParticle: UIView{
    
    
    init(){
        super.init(frame: .zero)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setView()
    }
    
    
    private func setView(){
        let particlesLayer = CAEmitterLayer()

        layer.addSublayer(particlesLayer)
        layer.masksToBounds = true

        particlesLayer.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
        particlesLayer.emitterShape = .circle
        particlesLayer.emitterPosition = CGPoint(x: 522.0, y: -325.0)
        particlesLayer.emitterSize = CGSize(width: 2088.0, height: 1005.0)
        particlesLayer.emitterMode = .surface
        particlesLayer.renderMode = .oldestLast



        let image1 = UIImage(named: "Square")?.cgImage

        let cell1 = CAEmitterCell()
        cell1.contents = image1
        cell1.name = "Square"
        cell1.birthRate = 22.0
        cell1.lifetime = 20.0
        cell1.velocity = 59.0
        cell1.velocityRange = -15.0
        cell1.xAcceleration = 5.0
        cell1.yAcceleration = 40.0
        cell1.emissionRange = 180.0 * (.pi / 180.0)
        cell1.spin = -28.6 * (.pi / 180.0)
        cell1.spinRange = 57.2 * (.pi / 180.0)
        cell1.scale = 0.01
        cell1.scaleRange = 0.3
        cell1.color = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor



        let image2 = UIImage(named: "Circle")?.cgImage

        let cell2 = CAEmitterCell()
        cell2.contents = image2
        cell2.name = "Circle"
        cell2.birthRate = 22.0
        cell2.lifetime = 20.0
        cell2.velocity = 59.0
        cell2.velocityRange = -15.0
        cell2.xAcceleration = 5.0
        cell2.yAcceleration = 40.0
        cell2.emissionRange = 180.0 * (.pi / 180.0)
        cell2.spin = -28.6 * (.pi / 180.0)
        cell2.spinRange = 57.2 * (.pi / 180.0)
        cell2.scale = 0.01
        cell2.scaleRange = 0.3
        cell2.color = UIColor(red: 27.0/255.0, green: 54.0/255.0, blue: 250.0/255.0, alpha: 1.0).cgColor



        let image3 = UIImage(named: "Spiral")?.cgImage

        let cell3 = CAEmitterCell()
        cell3.contents = image3
        cell3.name = "Spiral"
        cell3.birthRate = 22.0
        cell3.lifetime = 20.0
        cell3.velocity = 59.0
        cell3.velocityRange = -15.0
        cell3.xAcceleration = 5.0
        cell3.yAcceleration = 40.0
        cell3.emissionRange = 180.0 * (.pi / 180.0)
        cell3.spin = -28.6 * (.pi / 180.0)
        cell3.spinRange = 57.2 * (.pi / 180.0)
        cell3.scale = 0.01
        cell3.scaleRange = 0.3
        cell3.color = UIColor(red: 248.0/255.0, green: 78.0/255.0, blue: 249.0/255.0, alpha: 1.0).cgColor



        let image4 = UIImage(named: "Triangle")?.cgImage

        let cell4 = CAEmitterCell()
        cell4.contents = image4
        cell4.name = "Triangle"
        cell4.birthRate = 22.0
        cell4.lifetime = 20.0
        cell4.velocity = 59.0
        cell4.velocityRange = -15.0
        cell4.xAcceleration = 5.0
        cell4.yAcceleration = 40.0
        cell4.emissionRange = 180.0 * (.pi / 180.0)
        cell4.spin = -28.6 * (.pi / 180.0)
        cell4.spinRange = 57.2 * (.pi / 180.0)
        cell4.scale = 0.01
        cell4.scaleRange = 0.3
        cell4.color = UIColor(red: 75.0/255.0, green: 251.0/255.0, blue: 81.0/255.0, alpha: 1.0).cgColor



        let image5 = UIImage(named: "Star")?.cgImage

        let cell5 = CAEmitterCell()
        cell5.contents = image5
        cell5.name = "Star"
        cell5.birthRate = 22.0
        cell5.lifetime = 20.0
        cell5.velocity = 59.0
        cell5.velocityRange = -15.0
        cell5.xAcceleration = 5.0
        cell5.yAcceleration = 40.0
        cell5.emissionRange = 180.0 * (.pi / 180.0)
        cell5.spin = -28.6 * (.pi / 180.0)
        cell5.spinRange = 57.2 * (.pi / 180.0)
        cell5.scale = 0.01
        cell5.scaleRange = 0.3
        cell5.color = UIColor(red: 236.0/255.0, green: 27.0/255.0, blue: 75.0/255.0, alpha: 1.0).cgColor

        


        let image6 = UIImage(named: "Confetti")?.cgImage

        let cell6 = CAEmitterCell()
        cell6.contents = image6
        cell6.name = "Confetti"
        cell6.birthRate = 22.0
        cell6.lifetime = 20.0
        cell6.velocity = 59.0
        cell6.velocityRange = -15.0
        cell6.xAcceleration = 5.0
        cell6.yAcceleration = 40.0
        cell6.emissionRange = 180.0 * (.pi / 180.0)
        cell6.spin = -28.6 * (.pi / 180.0)
        cell6.spinRange = 57.2 * (.pi / 180.0)
        cell6.scale = 1.0
        cell6.scaleRange = 0.3
        cell6.color = UIColor(red: 27.0/255.0, green: 54.0/255.0, blue: 250.0/255.0, alpha: 1.0).cgColor

        particlesLayer.emitterCells = [cell1, cell2, cell3, cell4, cell5, cell6]
    }
    
    
}
