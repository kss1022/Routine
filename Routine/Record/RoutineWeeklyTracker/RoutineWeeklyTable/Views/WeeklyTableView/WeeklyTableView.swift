//
//  WeeklyTableView.swift
//  Routine
//
//  Created by 한현규 on 11/11/23.
//

import UIKit



final class WeeklyTableView: UIView{
        
    private var datas = [UUID: WeekTableDataEntry]()
    private var columns = [WeeklyTableColumn]()
    
    private var itemSize: CGFloat = 11.0
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
    
    
    func columns(columns: [WeeklyTableColumn]){
        self.columns = columns
        
        leftAxisView.values(columns)
        tableHeightConstraint.constant = CGFloat(columns.count) * itemSize        
    }
    
    func datas(datas: [WeekTableDataEntry]){
        datas.forEach {
            self.datas[$0.id] = $0
        }        
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
        tableHeightConstraint.constant = CGFloat(datas.count) * itemSize
        
        tableCollectionView.reloadData()
    }
}


extension WeeklyTableView: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        7 * (columns.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: WeeklyTableCell.self)
                
        let index = indexPath.row / 7
        let columns = columns[index]
        
        let tintColor = columns.tint
        
        let row = indexPath.row % 7
        let dataEntry = datas[columns.id]
        
        switch row{
        case 0: cell.bindView(done: dataEntry?.sunday ?? false, fillColor: tintColor)
        case 1: cell.bindView(done: dataEntry?.monday ?? false, fillColor: tintColor)
        case 2: cell.bindView(done: dataEntry?.tuesday ?? false, fillColor: tintColor)
        case 3: cell.bindView(done: dataEntry?.wednesday ?? false, fillColor: tintColor)
        case 4: cell.bindView(done: dataEntry?.thursday ?? false, fillColor: tintColor)
        case 5: cell.bindView(done: dataEntry?.friday ?? false, fillColor: tintColor)
        case 6: cell.bindView(done: dataEntry?.saturday ?? false, fillColor: tintColor)
        default: fatalError()
        }
        return cell
    }
    
}

extension WeeklyTableView: UICollectionViewDelegateFlowLayout{
}
