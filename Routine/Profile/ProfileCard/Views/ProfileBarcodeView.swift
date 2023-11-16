//
//  ProfileBarcodeView.swift
//  Routine
//
//  Created by 한현규 on 11/14/23.
//

import UIKit
import CoreImage.CIFilterBuiltins


final class ProfileBarcodeView: UIView{
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0.0
        return stackView
    }()

    private let barcodeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 8.0, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let barcodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    init(){
        super.init(frame: .zero)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setView()
    }
    
    
    private func setView(){
        
        addSubview(stackView)
        
        stackView.addArrangedSubview(barcodeLabel)
        stackView.addArrangedSubview(barcodeImageView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            barcodeImageView.heightAnchor.constraint(equalToConstant: 12.0)
        ])
    }
    
    func setBarcode(barcode: String){
        barcodeLabel.text = barcode
        barcodeImageView.image =  generateBarcode(string: barcode, height: 12.0, quietSpace: 1.0)
    }
    
    
    func generateBarcode(
        string: String,
        height: Float,
        quietSpace: Float
    ) -> UIImage? {
        guard let message = string.data(using: String.Encoding.ascii) else {
            return nil
        }
        let filter = CIFilter.code128BarcodeGenerator()
        filter.message = message
        filter.barcodeHeight = height
        filter.quietSpace = quietSpace
        
        guard let outputImage = filter.outputImage else {
            return nil
        }

        // Change the color using CIFilter
        let colorParameters = [
            "inputColor0": CIColor(color: UIColor.label), // Foreground
            "inputColor1": CIColor(color: UIColor.clear) // Background
        ]
        let colored = outputImage.applyingFilter("CIFalseColor", parameters: colorParameters)

        return UIImage(ciImage: colored)
    }
    
}
