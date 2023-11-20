//
//  SettingFontViewController.swift
//  Routine
//
//  Created by 한현규 on 11/18/23.
//

import ModernRIBs
import UIKit

protocol SettingFontPresentableListener: AnyObject {
    func segmentControlDidTap(index: Int)
}

final class SettingFontViewController: UIViewController, SettingFontPresentable, SettingFontViewControllable {

    weak var listener: SettingFontPresentableListener?
    
    private var viewControllers = [UIViewController]()

    private lazy var segmentControl: SettingFontSegmentControl = {
        let segmentControl = SettingFontSegmentControl(items: ["Font Size","Font Typeface"])
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.addTarget(self, action: #selector(segmentControlTap(control:)), for: .valueChanged)
        return segmentControl
    }()
    
    private let pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        return pageViewController
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
        let pageView = pageViewController.view!
        
        view.addSubview(segmentControl)
        view.addSubview(pageView)
                
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: view.topAnchor),
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor),
            pageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        pageViewController.didMove(toParent: self)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
       
        setSegment()
    }
    
    
    func setSettingFontSize(_ view: ViewControllable) {
        let vc = view.uiviewController
        addChild(vc)
        self.pageViewController.setViewControllers([vc], direction: .forward, animated: true, completion: nil)
        self.viewControllers.append(vc)
        vc.didMove(toParent: self)
    }
    
    func setSettingTypeface(_ view: ViewControllable) {
        let vc = view.uiviewController
        addChild(vc)
        self.viewControllers.append(vc)
        vc.didMove(toParent: self)
    }
    
    private func setSegment(){
        segmentControl.addTarget(self, action: #selector(segmentControlTap(control:)), for: .valueChanged)
        segmentControl.selectedSegmentIndex = 0
        segmentControlTap(control: segmentControl)
    }
    
    
    
    @objc
    private func segmentControlTap(control: UISegmentedControl) {
        segmentControl.changeUnderlinePosition()
        listener?.segmentControlDidTap(index: control.selectedSegmentIndex)
        
        if !self.viewControllers.isEmpty{
            pageViewController.setViewControllers([self.viewControllers[control.selectedSegmentIndex]], direction: .forward, animated: false)
        }        
    }

}


extension SettingFontViewController: UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = self.viewControllers.firstIndex(of: viewController), index + 1 < self.viewControllers.count else { return nil }
        return self.viewControllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = self.viewControllers.firstIndex(of: viewController), index - 1 >= 0 else { return nil }
        return self.viewControllers[index - 1]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool
    ) {
        guard let viewController = pageViewController.viewControllers?[0], let index = self.viewControllers.firstIndex(of: viewController) else { return }
        self.segmentControl.selectedSegmentIndex = index
        segmentControl.changeUnderlinePosition()
    }
    
}

extension SettingFontViewController: UIPageViewControllerDelegate{
    
}
