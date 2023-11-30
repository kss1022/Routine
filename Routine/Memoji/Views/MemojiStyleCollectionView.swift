//
//  MemojiStyleCollectionView.swift
//  Routine
//
//  Created by 한현규 on 11/29/23.
//

import UIKit


final class MemojiStyleCollectionView: UICollectionView{

    private let memojiService = MemojiService()
    
    private var styles: [MemojiStyle]
    private var image: UIImage?
    
    
    var tapHandler: ( (MemojiStyle) -> Void )?
    
    init(){
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16.0
        layout.minimumInteritemSpacing = 0.0
        layout.sectionInset = .init(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        
        self.image = nil
        self.styles = memojiService.styleModels()
        
        super.init(frame: .zero, collectionViewLayout: layout)
        
        setView()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setView(){
        self.backgroundColor = .clear
        self.register(cellType: MemojiStyleCell.self)
        
        self.delegate = self
        self.dataSource = self
        
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = true
    }
    
    
    func setType(_ type: MemojiType){
        switch type {
        case .memoji(let image): self.image = image
        case .emoji(let string): self.image = string.toImage()
        case .text(let string): self.image = string.toImage()
        }
        
        reloadData()
    }
    

}

extension MemojiStyleCollectionView: UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        styles.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MemojiStyleCell.self)
        
        cell.bindView(style: styles[indexPath.row], image: image)
        
        return cell
    }
}


extension MemojiStyleCollectionView: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size =  collectionView.frame
        let width = size.width / 5
                        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        if let style = styles[safe: row]{
            tapHandler?(style)
        }
    }
}
