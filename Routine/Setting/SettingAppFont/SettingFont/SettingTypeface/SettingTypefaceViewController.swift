//
//  SettingTypefaceViewController.swift
//  Routine
//
//  Created by 한현규 on 11/20/23.
//

import ModernRIBs
import UIKit

protocol SettingTypefacePresentableListener: AnyObject {
    func selectFontButtonDidTap()
}

final class SettingTypefaceViewController: UIViewController, SettingTypefacePresentable, SettingTypefaceViewControllable {

    weak var listener: SettingTypefacePresentableListener?
    
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false        
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let appTypefacestackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    

    private let osTypefaceTitleLabel: UILabel = {
        let label = UILabel()
        label.setFont(style: .caption2)
        label.textColor = .secondaryLabel
        return label
    }()
    
    
    private let osTypefaceListView: OSTypefaceListView = {
        let view = OSTypefaceListView()
        return view
    }()
    
    
    private let divierView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        view.backgroundColor = .opaqueSeparator
        return view
    }()
    
    private let appTypefaceTitleLabel: UILabel = {
        let label = UILabel()
        label.setFont(style: .caption2)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let apppTypefaceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 16.0
        return stackView
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
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        stackView.addArrangedSubview(osTypefaceTitleLabel)
        stackView.addArrangedSubview(osTypefaceListView)
        
        stackView.addArrangedSubview(divierView)
        
        stackView.addArrangedSubview(appTypefaceTitleLabel)
        stackView.addArrangedSubview(appTypefacestackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])        
    }
    
    func setOsTypeface(_ viewModel: OsTypefaceListViewModel) {
        osTypefaceListView.bindView(viewModel)
    }
    
    func setAppTypeface(_ viewModel: [AppTypefaceListViewModel]) {
        viewModel.map(AppTypefaceListView.init)
            .forEach { view in
                appTypefacestackView.addArrangedSubview(view)
            }
    }
    
    @objc
    private func selectFontButtonTap(){
        listener?.selectFontButtonDidTap()
    }
}
