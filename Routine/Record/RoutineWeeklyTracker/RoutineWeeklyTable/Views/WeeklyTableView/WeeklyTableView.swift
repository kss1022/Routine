//
//  WeeklyTableView.swift
//  Routine
//
//  Created by 한현규 on 11/11/23.
//

import UIKit



final class WeeklyTableView: UIView{
        
    private var dataEntrys = [WeeklyTableDataEntry]()
    
    private var itemSize: CGFloat = 30.0
    private var fontSize: CGFloat = 12.0
    

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .getBoldFont(size: 12.0)
        label.textColor = .label
        label.textAlignment = .right
        label.text = "Weekly Tracker"
        return label
    }()
        
    
    private let xAxisView: WeeklyXAxisView = {
        let headerView = WeeklyXAxisView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        return headerView
    }()
    
    private let leftAxisView: WeeklyLeftAxisView = {
        let leftAxisView = WeeklyLeftAxisView()
        leftAxisView.translatesAutoresizingMaskIntoConstraints = false
        return leftAxisView
    }()
    
    private var tableHeightConstraint: NSLayoutConstraint!
    private var tableWidthConstraint: NSLayoutConstraint!
    
    private lazy var tableCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
                
        collectionView.backgroundColor = .clear
        collectionView.layer.borderWidth = 1.0
        collectionView.layer.borderColor = UIColor.tertiaryLabel.cgColor
        
        collectionView.register(cellType: WeeklyTableCell.self)
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isUserInteractionEnabled = false
        
        return collectionView
    }()
    
    init(){
        super.init(frame: .zero)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setLayout()
    }
    
    private func setLayout(){
        addSubview(titleLabel)
        addSubview(xAxisView)
        addSubview(leftAxisView)
        addSubview(tableCollectionView)
                
                       
        tableHeightConstraint = tableCollectionView.heightAnchor.constraint(equalToConstant: 120.0)
        tableWidthConstraint = tableCollectionView.widthAnchor.constraint(equalToConstant: itemSize * 7)
        
        NSLayoutConstraint.activate([
            tableCollectionView.topAnchor.constraint(equalTo: xAxisView.bottomAnchor, constant: 8.0),
            tableCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableWidthConstraint,
            tableHeightConstraint,
                                    
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: tableCollectionView.leadingAnchor, constant: -16.0),
            
            xAxisView.topAnchor.constraint(equalTo: topAnchor),
            xAxisView.leadingAnchor.constraint(equalTo: tableCollectionView.leadingAnchor),
            xAxisView.trailingAnchor.constraint(equalTo: tableCollectionView.trailingAnchor),
            
            leftAxisView.leadingAnchor.constraint(equalTo: leadingAnchor),
            leftAxisView.topAnchor.constraint(equalTo: tableCollectionView.topAnchor),
            leftAxisView.bottomAnchor.constraint(equalTo: tableCollectionView.bottomAnchor),
            leftAxisView.trailingAnchor.constraint(equalTo: tableCollectionView.leadingAnchor, constant: -16.0),
        ])
    }
    
    
    func bindView(_ dataEntrys: [WeeklyTableDataEntry]){
        self.dataEntrys = dataEntrys
        
        self.dataEntrys.forEach {
            leftAxisView.addCell(title: $0.title, emoji: $0.emoji)
        }
        
        tableHeightConstraint.constant = CGFloat(dataEntrys.count) * itemSize
        
        self.tableCollectionView.reloadData()
    }
    
    func setFont(size: CGFloat){
        self.fontSize = size
        leftAxisView.setFont(size: fontSize)
        xAxisView.setFontSize(size: fontSize)
        titleLabel.font = .getBoldFont(size: fontSize)
    }
    
    func setItemSize(size: CGFloat){
        guard let layout = tableCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { fatalError() }
        self.itemSize = size
        layout.itemSize = CGSize(width: size, height: size)
        layout.prepare()  // <-- call prepare before invalidateLayout
        layout.invalidateLayout()
        
        tableWidthConstraint.constant = itemSize * 7
        tableHeightConstraint.constant = CGFloat(dataEntrys.count) * itemSize
        
        tableCollectionView.reloadData()
    }
}


extension WeeklyTableView: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        7 * (dataEntrys.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: WeeklyTableCell.self)
                
        let index = indexPath.row / 7
        if let dataEntry = dataEntrys[safe: index]{
            let row = indexPath.row % 7
            
            switch row{
            case 0: cell.bindView(done: dataEntry.weekDataEntry.sunday, fillColor: dataEntry.tint)
            case 1: cell.bindView(done: dataEntry.weekDataEntry.monday, fillColor: dataEntry.tint)
            case 2: cell.bindView(done: dataEntry.weekDataEntry.tuesday, fillColor: dataEntry.tint)
            case 3: cell.bindView(done: dataEntry.weekDataEntry.wednesday, fillColor: dataEntry.tint)
            case 4: cell.bindView(done: dataEntry.weekDataEntry.thursday, fillColor: dataEntry.tint)
            case 5: cell.bindView(done: dataEntry.weekDataEntry.friday, fillColor: dataEntry.tint)
            case 6: cell.bindView(done: dataEntry.weekDataEntry.saturday, fillColor: dataEntry.tint)
            default: fatalError()
            }            
            
        }
        return cell
    }
    
}

extension WeeklyTableView: UICollectionViewDelegateFlowLayout{
}
