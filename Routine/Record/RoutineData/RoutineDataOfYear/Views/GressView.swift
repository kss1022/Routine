//
//  GressView.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import UIKit



final class GressView: UIView{
        
        
    private let gressCalender = GressCalender()
    
    private var viewModel = GressViewModel(year: 2023, cellViewModels: [:])
    

    private let itemSize: CGFloat = 10.0
    private let spacing: CGFloat = 2.0
    
    
    private let gressHeaderView: GressHeaderView = {
        let gressHeaderView = GressHeaderView()
        gressHeaderView.translatesAutoresizingMaskIntoConstraints = false
        return gressHeaderView
    }()
    
    private let gressLeftAxisView: GressLeftAxisView = {
        let view = GressLeftAxisView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.itemSize = CGSize(width: itemSize, height: itemSize)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(cellType: GressCell.self)
        collectionView.register(cellType: GressEmptyCell.self)
        
        collectionView.backgroundColor = .clear
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
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
        addSubview(gressHeaderView)
        addSubview(collectionView)
        addSubview(gressLeftAxisView)
        
        
        NSLayoutConstraint.activate([
            gressHeaderView.bottomAnchor.constraint(equalTo: collectionView.topAnchor),
            gressHeaderView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            gressHeaderView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            gressHeaderView.heightAnchor.constraint(equalToConstant: 10.0),
                        
            gressLeftAxisView.topAnchor.constraint(equalTo: collectionView.topAnchor),
            gressLeftAxisView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gressLeftAxisView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
                        
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 10.0),
            collectionView.leadingAnchor.constraint(equalTo: gressLeftAxisView.trailingAnchor, constant: 8.0),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: itemSize * 7 + (spacing * 6))
        ])
    }
    
    
    
        
    func bindView(_ viewModel: GressViewModel){
        self.viewModel = viewModel
        gressHeaderView.setLabelsConstraint(year: 2022)
        collectionView.reloadData()
    }
  
    
}



extension GressView: UICollectionViewDataSource{
    
    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        365 + 6
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        
        if !viewModel.range.contains(indexPath.row){
            let emptyCell = collectionView.dequeueReusableCell(for: indexPath, cellType: GressEmptyCell.self)
            return emptyCell
        }
        
        
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: GressCell.self)
        
        
        return cell
    }
    

}


extension GressView: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var dateComponents = DateComponents()
        dateComponents.year = viewModel.year
        dateComponents.day = (indexPath.row + 1) - viewModel.range.first!

        if let date = Calendar.current.date(from: dateComponents) {
            let formattedDate = DateFormatter()
            formattedDate.dateFormat = "yyyy-MM-dd"
            let dateString = formattedDate.string(from: date)
            Log.v("\(dateString)")
        } else {
            Log.v("Unable to get date.")
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        gressHeaderView.contentOffset =  scrollView.contentOffset
    }
    
    
}


