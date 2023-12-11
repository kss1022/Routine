//
//  AppFontListInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/16/23.
//

import ModernRIBs
import UIKit.UIFont

protocol AppFontListRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol AppFontListPresentable: Presentable {
    var listener: AppFontListPresentableListener? { get set }
    func setFonts(_ viewModels: [AppFontListViewModel])
    func filterFonts(_ viewModels: [AppFontViewModel])
}

protocol AppFontListListener: AnyObject {
    func appFontListCloseButtonDidTap()
    func appFontListDidSelectFont()
}

final class AppFontListInteractor: PresentableInteractor<AppFontListPresentable>, AppFontListInteractable, AppFontListPresentableListener {

    weak var router: AppFontListRouting?
    weak var listener: AppFontListListener?

    private var listViewModels: [AppFontListViewModel]
    private var fontViewModels: [AppFontViewModel]
    
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: AppFontListPresentable) {
        listViewModels = []
        fontViewModels = []
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        let fontList = UIFont.familyNames
        let viewModels = Dictionary(grouping: fontList){ $0.first.flatMap(String.init)! }
            .sorted(by: { $0.key < $1.key} )
            .map {
                AppFontListViewModel(
                    section: $0.key,
                    fonts: $0.value.map(AppFontViewModel.init)
                )
            }
        
        self.listViewModels = viewModels
        self.fontViewModels = viewModels.flatMap{ $0.fonts }
        
        presenter.setFonts(viewModels)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func tableViewdidSelectRowAt(viewModel: AppFontViewModel) {
        do{
            try AppFontService.shared.updateFont(familyName: viewModel.fontName)
            listener?.appFontListDidSelectFont()
        }catch{            
            if let fontManageError = error as? AppFontManagerException{
                Log.e("\(fontManageError.message)")
            }else{
                Log.e("Unkown Error: \(error.localizedDescription)")
            }                    
        }
    }
    
    func searchBarCancelButtonTap() {
        presenter.setFonts(self.listViewModels)
    }
    
    func searchTextDidChange(text: String) {
        if text.isEmpty{
            presenter.setFonts(self.listViewModels)
            return 
        }
        
        let filtered = self.fontViewModels.filter { $0.fontName.hasPrefix(text) }
        presenter.filterFonts(filtered)
    }
    
    func closeButtonDidTap() {
        listener?.appFontListCloseButtonDidTap()
    }
    

}
