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
}

protocol RoutineDetailPresentable: Presentable {
    var listener: RoutineDetailPresentableListener? { get set }
    func setBackgroundColor(_ tint: String)
}

protocol RoutineDetailListener: AnyObject {
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
        let detailRecordDate = Formatter.recordFormatter().string(from: dependency.routineDetailRecord.value!.recordDate)
        let recordDate = Formatter.recordFormatter().string(from: self.dependency.recordDate)
        
        if detailRecordDate != recordDate{
            Log.e("\(detailRecordDate)(detail.recordDate) != \(recordDate)(self.dependency.recordDate)")
            fatalError()
        }
        
        router?.attachRoutineTitle()
        router?.attachRecordCalendar()
    
        dependency.routineDetail
            .receive(on: DispatchQueue.main)
            .sink { detail in
                self.presenter.setBackgroundColor(detail!.tint)
            }
            .store(in: &cancelables)
    }
    
    override func willResignActive() {
        super.willResignActive()
        cancelables.forEach { $0.cancel() }
        cancelables.removeAll()
    }
    

    
    func editButtonDidTap() {
        Task{ [weak self] in
            guard let self = self else { return }
            do{
                try await dependency.routineRepository.fetchTints()
                try await dependency.routineRepository.fetchEmojis()
                await MainActor.run { self.router?.attachRoutineEdit(routineId: self.dependency.routineId) }
            }catch{
                Log.e("\(error)")
            }
        }
    }
    
    
    func routineTitleCompleteButtonDidTap() {
        let record = dependency.routineDetailRecord.value
        let routineId = dependency.routineId
        let recordDate = dependency.recordDate
        
        if record?.recordId == nil{
            let command = CreateRecord(routineId: routineId, date: recordDate)
            createRecord(command)
        }else{
            let command = SetCompleteRecord(recordId: record!.recordId!, isComplete: !(record!.isComplete))
            setComplete(command)
        }
    }
    
    func presentationControllerDidDismiss() {
        router?.detachRoutineEdit(dismiss: false)
    }
    
    func routineEditDoneButtonDidTap() {
        router?.detachRoutineEdit(dismiss: true)
    }
    
    func routineEditDeleteButtonDidTap() {
        router?.detachRoutineEdit(dismiss: false)
        listener?.routineDetailDismiss()
    }
    
    
    
    private func createRecord(_ command: CreateRecord){
        Task{
            do{
                try await self.dependency.recordApplicationService.when(command)
                try await self.dependency.routineRepository.fetchLists()
            }catch{
                if let error = error as? ArgumentException{
                    Log.e(error.msg)
                }else{
                    Log.e("UnkownError\n\(error)" )
                }
            }
        }
    }
    
    private func setComplete(_ command: SetCompleteRecord){
        Task{
            do{
                try await self.dependency.recordApplicationService.when(command)
                try await self.dependency.routineRepository.fetchLists()
                try await self.dependency.routineRepository.fetchDetail(self.dependency.routineId)
            }catch{
                if let error = error as? ArgumentException{
                    Log.e(error.msg)
                }else{
                    Log.e("UnkownError\n\(error)" )
                }
            }
        }
    }
}
