//
//  RecordBannerViewController.swift
//  Routine
//
//  Created by 한현규 on 11/2/23.
//

import ModernRIBs
import UIKit

protocol RecordBannerPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class RecordBannerViewController: UIViewController, RecordBannerPresentable, RecordBannerViewControllable {
    
    weak var listener: RecordBannerPresentableListener?
    
    
    private let itemWidth = UIDevice.frame().width - (32.0 + 16.0)
    private var modelCount = 3
    
    private lazy var frontPosition: CGFloat =
        itemWidth * CGFloat (modelCount - 1)
    
    private lazy var lastPosition: CGFloat = itemWidth * CGFloat (modelCount * 2)
    
    
    private var dataSource: UICollectionViewDiffableDataSource<String, RecordBannerViewModel>!
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(cellType: RecordBannerCell.self)
        collectionView.collectionViewLayout = getCollectionViewLayout()
        collectionView.delegate = self
        
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        
        return collectionView
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.pageIndicatorTintColor = .secondaryLabel
        pageControl.currentPageIndicatorTintColor = .label
        //pageControl.isUserInteractionEnabled = false
        pageControl.hidesForSinglePage = true
        return pageControl
    }()
    
    init(){
        super.init(nibName: nil, bundle: nil)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setLayout()
    }
    
    private func setLayout(){
        
        
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 180.0),
            
            pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16.0),
            pageControl.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16.0)
        ])
        
        let viewModels = [
            RecordBannerViewModel(id: UUID(), color: .systemGray),
            RecordBannerViewModel(id: UUID(), color: .label),
            RecordBannerViewModel(id: UUID(), color: .systemBrown),
            RecordBannerViewModel(id: UUID(), color: .systemGray),
            RecordBannerViewModel(id: UUID(), color: .label),
            RecordBannerViewModel(id: UUID(), color: .systemBrown),
            RecordBannerViewModel(id: UUID(), color: .systemGray),
            RecordBannerViewModel(id: UUID(), color: .label),
            RecordBannerViewModel(id: UUID(), color: .systemBrown),
        ]
        
        setBannerList(viewModels)
        pageControl.numberOfPages = modelCount
        pageControl.currentPage = 0
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.scrollToItem(at: [0, modelCount], at: .left, animated: false)
    }
    
    
    func setBannerList(_ viewModels : [RecordBannerViewModel]) {
        if dataSource == nil{
            setDataSource()
        }
        
        var snapShot = self.dataSource.snapshot()
        let beforeItems = snapShot.itemIdentifiers(inSection: "")
        snapShot.deleteItems(beforeItems)
        snapShot.appendItems(viewModels , toSection: "")
        self.dataSource.apply( snapShot , animatingDifferences: false )
    }
    
    private func setDataSource(){
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: RecordBannerCell.self)
            cell.contentView.backgroundColor = itemIdentifier.color.withAlphaComponent(0.5)
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<String, RecordBannerViewModel>()
        snapshot.appendSections([""])
        self.dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func getCollectionViewLayout() -> UICollectionViewLayout{
        let section = getListTypeSection()
        let compositional = UICollectionViewCompositionalLayout(section: section)
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .vertical
        compositional.configuration = config
        
        return compositional
    }
    
    private func getListTypeSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0.0, leading: 8.0, bottom: 0.0, trailing: 8.0)
        
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        section.visibleItemsInvalidationHandler = { [weak self] items, contentOffset, environment in
            guard let self = self else { return }
            let inset = (self.view.bounds.width - itemWidth) / 2
            let realOffset = inset + contentOffset.x
            let bannerIndex = Int(max(0, round( (realOffset) / itemWidth)))
            self.pageControl.currentPage = bannerIndex % modelCount
            
            
            //            items.forEach { item in
            //                let distanceFromCenter = abs((item.frame.midX - contentOffset.x) - environment.container.contentSize.width / 2.0)
            //                let minScale: CGFloat = 0.9
            //                let maxScale: CGFloat = 1.0
            //                let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
            //                item.transform = CGAffineTransform(scaleX: scale, y: scale)
            //            }
            
            
            
            if realOffset < frontPosition{
                collectionView.scrollToItem(at: [0, modelCount * 2 - 1], at: .left, animated: false)
            }else if realOffset >  lastPosition{
                collectionView.scrollToItem(at: [0, modelCount], at: .left, animated: false)
            }
        }
        
        return section
    }
    
    
}


extension RecordBannerViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
}
