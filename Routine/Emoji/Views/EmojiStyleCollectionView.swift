//
//  EmojiStyleCollectionView.swift
//  Routine
//
//  Created by 한현규 on 11/30/23.
//

import UIKit




final class EmojiStyleCollectionView: UICollectionView{
    
    private let emojiService = EmojiService()
    private var styles: [EmojiStyle]
    
    
    var tapHandler: ( (EmojiStyle) -> Void )?
    
        
    init(){
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16.0
        layout.minimumInteritemSpacing = 4.0
        layout.sectionInset = .init(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
                
        self.styles = emojiService.styles()
        super.init(frame: .zero, collectionViewLayout: layout)
        
        setView()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setView(){
        self.backgroundColor = .clear
        self.register(cellType: EmojiStyleCell.self)
        
        self.delegate = self
        self.dataSource = self
        
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = true        
    }
    
    func setStyle(style: EmojiStyle){
        if let index = styles.firstIndex(of: style){
            let indexPath = IndexPath(row: index, section: 0)
            self.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
        }
    }
    
    
    //Dynamic height
    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }

}

extension EmojiStyleCollectionView: UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        styles.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: EmojiStyleCell.self)
        
        cell.bindView(style: styles[indexPath.row])
        
        return cell
    }
}


extension EmojiStyleCollectionView: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60.0, height: 60.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        if let style = styles[safe: row]{
            tapHandler?(style)
        }
    }

}
