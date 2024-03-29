//
//  RoutineHomeInteractor.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import ModernRIBs
import Combine
import Foundation

protocol RoutineHomeRouting: ViewableRouting {
    func attachCreateRoutine()
    func detachCreateRoutine()
    
    func attachRoutineDetail(routineId: UUID, recordDate: Date)
    func detachRoutineDetail()
    
    func attachRoutineWeekCalendar()
    func attachRoutineList()
}

protocol RoutineHomePresentable: Presentable {
    var listener: RoutineHomePresentableListener? { get set }
    func setTitle(title: String)
    func showError(title: String, message: String)
}

protocol RoutineHomeListener: AnyObject {
}

protocol RoutineHomeInteractorDependency{
    var routineApplicationService: RoutineApplicationService{ get }
    var recordApplicationService: RecordApplicationService{ get }
    var routineRepository: RoutineRepository{ get }
}



final class RoutineHomeInteractor: PresentableInteractor<RoutineHomePresentable>, RoutineHomeInteractable, RoutineHomePresentableListener, AdaptivePresentationControllerDelegate {

    
    let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
    
    weak var router: RoutineHomeRouting?
    weak var listener: RoutineHomeListener?
    
    private let dependency : RoutineHomeInteractorDependency
    private var cancellables: Set<AnyCancellable>
    
    private var list : [RoutineListDto]
    private var date: Date
    
    private var isCreate: Bool
    private var isDetail: Bool
    
    init(
        presenter: RoutineHomePresentable,
        dependency: RoutineHomeInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellables = .init()
                
        self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
        
        self.list = []
        self.date = Calendar.current.startOfDay(for: Date()) //Date -> now
        self.isDetail = false
        self.isCreate = false
        super.init(presenter: presenter)
        
        presenter.listener = self
        self.presentationDelegateProxy.delegate = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        Log.v("Routine Home DidBecome Active ✅")
        router?.attachRoutineWeekCalendar()
        router?.attachRoutineList()
        
        Task{ [weak self] in
            guard let self = self else { return }
            do{
                try await dependency.routineRepository.fetchLists()
            }catch{
                Log.e(error.localizedDescription)
                await self.showFetchListFailed()
            }
        }
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
        
    
    func presentationControllerDidDismiss() {
        if isCreate{
            isCreate = false
            router?.detachCreateRoutine()
        }
        
        if isDetail{
            isDetail = false
            router?.detachRoutineDetail()
        }
    }
    
    //MARK: RoutineWeekCalendar
    func routineWeekCalendarDidTap(date: Date) {
        Task{ [weak self] in
            guard let self = self else { return }
            do{
                self.date = date
                try await dependency.routineRepository.fetchHomeList(date: date)
                
                await MainActor.run { [weak self] in 
                    let date = Formatter.routineHomeTitleFormatter(date: date)
                    self?.presenter.setTitle(title: date)
                }
            }catch{
                Log.e("\(error)")
                await showFetchListFailed()
            }
        }
    }
    

    //MARK: RoutineList
    func routineListDidComplete(list: RoutineHomeListModel) {
        if list.recordId == nil{
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            Log.v("CheckDate \(formatter.string(from: self.date))")
            
            let command = CreateRoutineRecord(routineId: list.routineId, date: self.date)
            createRecord(command)
        }else{
            let command = SetCompleteRoutineRecord(recordId: list.recordId!, isComplete: !list.isComplete)
            setComplete(command)
        }
    }
            
    // MARK: CreateRoutine
    func createRoutineBarButtonDidTap() {                
        isCreate = true
        router?.attachCreateRoutine()
    }

    func createRoutineDismiss() {
        isCreate = false
        router?.detachCreateRoutine()
    }
        
    
    // MARK: RoutineDetail
    func routineListDidTapRoutineDetail(routineId: UUID) {
        Task{ [weak self] in
            guard let self = self else { return }
            do{
                try await dependency.routineRepository.fetchDetail(routineId)
                await MainActor.run { [weak self] in
                    guard let self = self else { return }
                    isDetail = true
                    router?.attachRoutineDetail(routineId: routineId, recordDate: self.date)
                }
            }catch{
                Log.e("\(error)")
                await self.showFetchDetailFailed()
            }
            
        }
    }
    
    func routineDetailCloseButtonDidTap() {
        isDetail = false
        self.router?.detachRoutineDetail()
    }
    
    func routineDetailDismiss() {
        isDetail = false
        self.router?.detachRoutineDetail()
    }
    
    
    private func createRecord(_ command: CreateRoutineRecord){
        Task{ [weak self] in
            guard let self = self else { return }
            do{
                try await dependency.recordApplicationService.when(command)
                try await dependency.routineRepository.fetchLists()
            }catch{
                if let error = error as? ArgumentException{
                    Log.e(error.message)
                }else{
                    Log.e("UnkownError\n\(error)" )
                }
                await self.showRecordRoutineFailed()
            }
        }
    }
    
    private func setComplete(_ command: SetCompleteRoutineRecord){
        Task{ [weak self] in
            guard let self = self else { return }
            do{
                try await dependency.recordApplicationService.when(command)
                try await dependency.routineRepository.fetchLists()
            }catch{
                if let error = error as? ArgumentException{
                    Log.e(error.message)
                }else{
                    Log.e("UnkownError\n\(error)" )
                }
                await self.showRecordRoutineFailed()
            }
        }
    }
}

// MARK: Error Message
private extension RoutineHomeInteractor{
        
    @MainActor
    func showFetchListFailed(){
        let title = "try_again_later".localized(tableName: "Routine")
        let message = "fetch_list_failed".localized(tableName: "Routine")
        presenter.showError(title: title, message: message)
    }
    
    @MainActor
    func showFetchDetailFailed(){
        let title = "try_again_later".localized(tableName: "Routine")
        let message = "fetch_routine_failed".localized(tableName: "Routine")
        presenter.showError(title: title, message: message)
    }
    
    @MainActor
    func showRecordRoutineFailed(){
        let title = "oops".localized(tableName: "Routine")
        let message = "record_routine_failed".localized(tableName: "Routine")
        presenter.showError(title: title, message: message)
    }
}
