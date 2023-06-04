//
//  Coordinator.swift
//  CalendarApp
//
//  Created by Janus Jordan on 6/1/23.
//

import Foundation
import RxSwift
protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get set }
}
class BaseCoordinator<ResultType>: Coordinator {
    typealias CoordinationResult = ResultType
    var parentCoordinator: Coordinator?
    let disposeBag = DisposeBag()
    private let identifier = UUID()

    private var childCoordinators = [UUID: Any]()
    private func store<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = coordinator
        coordinator.parentCoordinator = self
    }
    private func free<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = nil
    }
    func coordinate<T>(to coordinator: BaseCoordinator<T>) -> Observable<T> {
        store(coordinator: coordinator)
        return coordinator.start()
            .do(onNext: { [weak self] _ in self?.free(coordinator: coordinator) })
    }
    func start() -> Observable<ResultType> {
        fatalError("Start method should be implemented.")
    }
}
