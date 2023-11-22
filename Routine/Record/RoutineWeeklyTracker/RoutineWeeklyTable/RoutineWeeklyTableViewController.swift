//
//  RoutineWeeklyTableViewController.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import ModernRIBs
import UIKit

protocol RoutineWeeklyTablePresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class RoutineWeeklyTableViewController: UIViewController, RoutineWeeklyTablePresentable, RoutineWeeklyTableViewControllable {

    weak var listener: RoutineWeeklyTablePresentableListener?

    
    private lazy var weeklysRange: [WeeklyRange] = {
         getWeeklyRange()
    }()
    
    private var columns =  [WeeklyTableColumn]()
    private var dataEntrys = [WeeklyRange: [RoutineWeeklyTableDataEntryViewModel]]()
    
    
    private lazy var tableCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16.0
        layout.minimumInteritemSpacing = 0.0
        layout.sectionInset = .init(top: 0.0, left: 32.0, bottom: 0.0, right: 32.0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.register(cellType: RoutineWeeklyTableCell.self)
        
        collectionView.dataSource = self
        collectionView.delegate = self
                
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.decelerationRate = .fast
        collectionView.isPagingEnabled = false
        collectionView.contentInsetAdjustmentBehavior = .never


        return collectionView
    }()
    

    init(){
        super.init(nibName: nil, bundle: nil)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableCollectionView.scrollToItem(at: IndexPath(row: weeklysRange.count - 1, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    
    private func setLayout(){
        
        
        view.addSubview(tableCollectionView)
                        
        NSLayoutConstraint.activate([
            tableCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            tableCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    
    
    func setTableData(_ columns: [RoutineWeeklyTableColumnViewModel], dataEntys: [WeeklyRange : [RoutineWeeklyTableDataEntryViewModel]]) {
        self.columns = columns.map(WeeklyTableColumn.init)
        self.dataEntrys = dataEntys
        tableCollectionView.reloadData()
    }
    
    private func getWeeklyRange() -> [WeeklyRange]{
        //let installation = PreferenceStorage.shared.installation! //앱의 설치일자
        
        var dateComponents = DateComponents()
        dateComponents.year = 2023
        dateComponents.month = 11
        dateComponents.day = 1

        // Calendar 객체를 사용하여 Date 객체 생성
        let calendar = Calendar.current
        let installation = calendar.date(from: dateComponents)!
        
            
        let startComponents = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: installation)
        let installtionStartOfWeek = calendar.date(from: startComponents)!
        
        let todayComponents = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        let todayStartOfWeek = calendar.date(from: todayComponents)!
        
        
        let formatter = Formatter.weekRecordFormatter()
   
        return getAllStartOfWeekBetweenDates(startDate: installtionStartOfWeek, endDate: todayStartOfWeek).map {
            let endOfWeek = calendar.date(byAdding: .day, value: 6, to: $0)!
            return WeeklyRange(startOfWeek: formatter.string(from: $0), endOfWeek: formatter.string(from: endOfWeek))
        }
    }
    
    
    private func getAllStartOfWeekBetweenDates(startDate: Date, endDate: Date) -> [Date] {
        let calendar = Calendar.current
        var currentStartDate = startDate
        var startOfWeekDates: [Date] = []

        while currentStartDate <= endDate {
            startOfWeekDates.append(currentStartDate)
            currentStartDate = calendar.date(byAdding: .day, value: 7, to: currentStartDate)!
        }

        return startOfWeekDates
    }
    
}


extension  RoutineWeeklyTableViewController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        weeklysRange.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: RoutineWeeklyTableCell.self)
        let period = weeklysRange[indexPath.row]
        
        let dataEntrys = dataEntrys[period]?.map(WeekTableDataEntry.init) ?? []
        
        cell.setPeriod(period: "\(period.startOfWeek) ~ \(period.endOfWeek)")
        cell.setColumns(columns)
        cell.setDatas(dataEntrys)
        
        return cell
    }
    

    
}


extension RoutineWeeklyTableViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        return CGSize(width: bounds.width - 64.0, height: bounds.height - 32.0)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let cellWidthIncludeSpacing = (scrollView.bounds.width - 64.0) + 16.0
        
        var offset = targetContentOffset.pointee
        var index = (offset.x + 32.0) / cellWidthIncludeSpacing
        
        if velocity.x > 0 {
            index = ceil(index)
        } else if velocity.x < 0 {
            index = floor(index)
        } else {
            index = round(index)
        }
        
        let roundedIndex: CGFloat = round(index)
        offset = CGPoint(x: roundedIndex * cellWidthIncludeSpacing, y: scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}


