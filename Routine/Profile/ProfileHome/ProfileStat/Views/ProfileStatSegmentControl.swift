//
//  ProfileStatSegmentControl.swift
//  Routine
//
//  Created by 한현규 on 11/15/23.
//

import UIKit


final class ProfileStatSegmentControl : UIControl{
    
    private var buttonList = [UIButton]()
    
    public var selectedSegmentIndex : Int{
        _selectedSegmentIndex
    }
    
    private var _selectedSegmentIndex: Int = 0{
        didSet(oldVal){
            buttonList[oldVal].isSelected = false
            buttonList[selectedSegmentIndex].isSelected = true
            
            //value값이 바뀌면 sendAcionts(for:)인 valueChanged이벤트를 발생
            self.sendActions(for: .valueChanged)
        }
    }
    
//    private let scrollView : TouchesShouldCancelScrollView = {
//        let scrollView = TouchesShouldCancelScrollView()
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.showsHorizontalScrollIndicator = false
//        return scrollView
//    }()
    
    private lazy var stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 16.0
        return stackView
    }()
            
    
    init(items: [String]){
        super.init(frame: .zero)
        
        setView()
        setButton(items: items)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setView()
    }
    

    private func setView(){
      
        addSubview(stackView)
                                
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
//        addSubview(scrollView)
//        scrollView.addSubview(stackView)
//
//        NSLayoutConstraint.activate([
//            scrollView.topAnchor.constraint(equalTo: topAnchor),
//            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
//            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
//
//            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
//            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
//            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
//            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
//        ])
    }
    
    
    private func setButton(items: [String]){
        
        let buttons = items.map(ProfileStatSegmentButton.init)
                        
        buttons.enumerated().forEach { (index, button) in
            button.setBoldFont(style: .title3)
            button.setTitleColor(.label, for: .selected)
            button.setTitleColor(.tertiaryLabel, for: .normal)
            
            button.tag = index
            button.addTarget(self, action: #selector(segmentButtonDidTap), for: .touchUpInside)
            stackView.addArrangedSubview(button)
            buttonList.append(button)
        }
        
        buttons.first?.isSelected = true
    }
    
    @objc
    private func segmentButtonDidTap(sender : UIButton){
        let newButtonTag = sender.tag
        if _selectedSegmentIndex == newButtonTag{
            return
        }
        
        _selectedSegmentIndex = newButtonTag
    }
    
    
    func setTitle( title : String , index : Int){
        buttonList[index].setTitle(title, for: .normal)
    }
    

    func selectedIndex( index : Int ){
        _selectedSegmentIndex = index
    }
       
}


//private final class TouchesShouldCancelScrollView : UIScrollView{
//    override func touchesShouldCancel(in view: UIView) -> Bool {
//       if view is UIButton {
//         return true
//       }
//       return super.touchesShouldCancel(in: view)
//     }
//}
//
//
