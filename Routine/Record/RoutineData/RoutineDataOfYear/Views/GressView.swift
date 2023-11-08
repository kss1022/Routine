//
//  GressView.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import UIKit

//TODO: GressViewModel. GressCellViewModle 수정

final class GressView: UIView{
        
        
    private let gressCalender = GressCalender()
    
    private var viewModel = GressViewModel(year: 2023)
    

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
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollToToday()
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
        gressHeaderView.setLabelsConstraint(year: viewModel.year)
    }
    
    
        
    func bindView(_ viewModel: GressViewModel){
        self.viewModel = viewModel
        gressHeaderView.setLabelsConstraint(year: viewModel.year)
        collectionView.reloadData()
    }

    
    private func scrollToToday(){
        let today = Date()
        if Calendar.current.component(.year, from: today) == viewModel.year{
            let row = getRow(date: today)
            
            collectionView.isPagingEnabled = false
            collectionView.scrollToItem(at: IndexPath(row: row, section: 0), at:  .left, animated: false)
        }
    }
    
    private func getRow(date : Date) -> Int{
        if let yearOfDay = gressCalender.dayOfYear(date: Date()){
            let row = viewModel.range.first! + yearOfDay - 1
            return row
        }
        
        return 0
    }
  
    private func getDate(row: Int) -> Date?{
        var dateComponents = DateComponents()
        dateComponents.year = viewModel.year
        dateComponents.day = (row + 1) - viewModel.range.first!
        return Calendar.current.date(from: dateComponents)
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
        cell.cellBackgroundColor = viewModel.cellColor
        if let date = getDate(row: indexPath.row),
           viewModel.select.contains(date){
            cell.bindView(GressCellViewModel(day: date, count: 1))
        }
        
        return cell
    }
    

}


extension GressView: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let date = getDate(row: indexPath.row){
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


