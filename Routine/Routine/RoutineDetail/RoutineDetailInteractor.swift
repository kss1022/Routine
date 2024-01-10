//
//  RoutineDetailInteractor.swift
//  Routine
//
//  Created by 한현규 on 9/30/23.
//

import Foundation
import ModernRIBs
import Combine

protocol RoutineDetailRouting: ViewableRouting {
    func attachRoutineEdit(routineId: UUID)
    func detachRoutineEdit(dismiss: Bool)
    
    func attachRoutineTitle()
    func attachRecordCalendar()
    func attachRoutineBasicInfo()
}

protocol RoutineDetailPresentable: Presentable {
    var listener: RoutineDetailPresentableListener? { get set }
    func setTitle(_ title: String)
    func setBackgroundColor(_ tint: String)
    
    func showRecordRoutineFailed()
}

protocol RoutineDetailListener: AnyObject {
    func routineDetailCloseButtonDidTap()
    func routineDetailDismiss()
}

protocol RoutineDetailInteractorDependency{
    var routineId: UUID{ get }
    var recordDate: Date{ get }
    
    var routineRepository: RoutineRepository{ get }
    var recordApplicationService: RecordApplicationService{ get }
    
    var routineDetail: ReadOnlyCurrentValuePublisher<RoutineDetailModel?>{ get }
    var routineDetailRecord: ReadOnlyCurrentValuePublisher<RoutineDetailRecordModel?>{ get }    
}

final class RoutineDetailInteractor: PresentableInteractor<RoutineDetailPresentable>, RoutineDetailInteractable, RoutineDetailPresentableListener, AdaptivePresentationControllerDelegate {
    
    
    weak var router: RoutineDetailRouting?
    weak var listener: RoutineDetailListener?
    
    let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
    
    private let dependency : RoutineDetailInteractorDependency
    private var cancelables: Set<AnyCancellable>
    
    // in constructor.
    init(
        presenter: RoutineDetailPresentable,
        dependency: RoutineDetailInteractorDependency
    ) {
        self.dependency = dependency
        self.cancelables = .init()
        self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
        super.init(presenter: presenter)
        presenter.listener = self
        self.presentationDelegateProxy.delegate = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        
        //Check DetailDate
        if dependency.routineDetail.value?.routineId != self.dependency.routineId{
            Log.e("\(dependency.routineDetail.value!.routineId)(detail.routineId) != \(self.dependency.routineId)(self.dependency.routineId)")
            fatalError()
        }
        
        //Check SelectedDate
        let detailRecordDate = Formatter.recordDateFormatter().string(from: dependency.routineDetailRecord.value!.recordDate)
        let recordDate = Formatter.recordDateFormatter().string(from: self.dependency.recordDate)
        
        if detailRecordDate != recordDate{
            Log.e("\(detailRecordDate)(detail.recordDate) != \(recordDate)(self.dependency.recordDate)")
            fatalError()
        }
        
        router?.attachRoutineTitle()
        router?.attachRecordCalendar()
        router?.attachRoutineBasicInfo()
        
        dependency.routineDetail
            .receive(on: DispatchQueue.main)
            .sink {
                if let detail = $0{
                    self.presenter.setTitle(detail.routineName)
                    self.presenter.setBackgroundColor(detail.tint)
                }
            }
            .store(in: &cancelables)
    }
    
    override func willResignActive() {
        super.willResignActive()
        cancelables.forEach { $0.cancel() }
        cancelables.removeAll()
    }
    
    
    func closeButtonDidTap() {
        listener?.routineDetailCloseButtonDidTap()
    }
    
    func editButtonDidTap() {
        self.router?.attachRoutineEdit(routineId: self.dependency.routineId)
    }
    
    
    func routineTitleCompleteButtonDidTap() {
        let record = dependency.routineDetailRecord.value
        let routineId = dependency.routineId
        let recordDate = dependency.recordDate
        
        if record?.recordId == nil{
            let command = CreateRoutineRecord(routineId: routineId, date: recordDate)
            createRecord(command)
        }else{
            let command = SetCompleteRoutineRecord(recordId: record!.recordId!, isComplete: !(record!.isComplete))
            setComplete(command)
        }
    }
    
    func presentationControllerDidDismiss() {
        router?.detachRoutineEdit(dismiss: false)
    }
    
    
    //MARK: RoutineEdit
    func routineEditCloseButtonDidTap() {
        router?.detachRoutineEdit(dismiss: true)
    }
    
    func routineEditDoneButtonDidTap() {
        router?.detachRoutineEdit(dismiss: true)
    }
    
    func routineEditDeleteButtonDidTap() {
        router?.detachRoutineEdit(dismiss: false)
        listener?.routineDetailDismiss()
    }
    
    
    //MARK: Private
    private func createRecord(_ command: CreateRoutineRecord){
        Task{ [weak self] in
            guard let self = self else { return }
            do{
                try await dependency.recordApplicationService.when(command)
                try await dependency.routineRepository.fetchLists()
                try await dependency.routineRepository.fetchDetail(self.dependency.routineId)
            }catch{
                if let error = error as? ArgumentException{
                    Log.e(error.message)
                }else{
                    Log.e("UnkownError\n\(error)" )
                }
                presenter.showRecordRoutineFailed()
            }
        }
    }
    
    private func setComplete(_ command: SetCompleteRoutineRecord){
        Task{ [weak self] in
            guard let self = self else { return }
            do{
                try await dependency.recordApplicationService.when(command)
                try await dependency.routineRepository.fetchLists()
                try await dependency.routineRepository.fetchDetail(self.dependency.routineId)
            }catch{
                if let error = error as? ArgumentException{
                    Log.e(error.message)
                }else{
                    Log.e("UnkownError\n\(error)" )
                }
                presenter.showRecordRoutineFailed()
            }
        }
    }
}
