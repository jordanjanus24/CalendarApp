//
//  CalendarModule.swift
//  CalendarApp
//
//  Created by Janus Jordan on 6/2/23.
//

import Foundation
import UIKit
import EventKit
import EventKitUI

protocol CalendarModuleProtocol {
    func startInitialFlow(_ navController: UINavigationController)
    func startEventPopup(event: EKEvent?)
}


class CalendarModule: NSObject, CalendarModuleProtocol {
    internal var parent: UIViewController!
    internal var viewModel: CalendarViewModel!
    init(viewModel: CalendarViewModel) {
        self.viewModel = viewModel
    }

    func startInitialFlow(_ navController: UINavigationController) {
        let vc = CalendarViewController.instantiate()
        vc.viewModel = viewModel
        parent = vc
        navController.pushViewController(vc, animated: true)
    }
    
    
    func startEventPopup(event: EKEvent? = nil) {
        let time = Date()
        viewModel.eventStore.makeSureGranted {
            DispatchQueue.main.async {
                if let event = event {
                    self.presentEventPopup(event: event)
                }
                else {
                    let event = EKEvent(eventStore: self.viewModel.eventStore)
                    event.startDate = time
                    event.endDate = time
                    self.presentEventPopup(event: event)
                }
            }
        }
    }
    private func presentEventPopup(event: EKEvent) {
        let eventController = EKEventEditViewController()
        eventController.event = event
        eventController.eventStore = self.viewModel.eventStore
        eventController.editViewDelegate = self
        self.parent.present(eventController, animated: true, completion: nil)
    }
}

extension CalendarModule: EKEventEditViewDelegate {
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
    }
}

