//
//  CalendarViewModel.swift
//  CalendarApp
//
//  Created by Janus Jordan on 6/3/23.
//

import Foundation
import RxSwift
import EventKit

class CalendarViewModel {
    let defaults = UserDefaults.standard
    let eventStore = EKEventStore()
    // MARK: - Inputs
    let logout: AnyObserver<Void>
    let reload: AnyObserver<Void>
    let showPopup: AnyObserver<Void>
    let closePopup: AnyObserver<Void>
    let events: AnyObserver<[EKEvent]>
    let selectedEvent: AnyObserver<EKEvent>
    let deletedEvent: AnyObserver<EKEvent>
    // MARK: - Outputs
    let didLogout: Observable<Void>
    let didReload: Observable<Void>
    let didShowPopup: Observable<Void>
    let didClosePopup: Observable<Void>
    let onShowEvents: Observable<[EKEvent]>
    let onSelectedEvent: Observable<EKEvent>
    let onDeletedEvent: Observable<EKEvent>
    
    init() {
        let _logout = PublishSubject<Void>()
        self.logout = _logout.asObserver()
        self.didLogout = _logout.asObservable()
        
        let _reload = PublishSubject<Void>()
        self.reload = _reload.asObserver()
        self.didReload = _reload.asObservable()
        
        let _showPopup = PublishSubject<Void>()
        self.showPopup = _showPopup.asObserver()
        self.didShowPopup = _showPopup.asObservable()
        
        let _closePopup = PublishSubject<Void>()
        self.closePopup = _closePopup.asObserver()
        self.didClosePopup = _closePopup.asObservable()
        
        let _selectedEvent = PublishSubject<EKEvent>()
        self.selectedEvent = _selectedEvent.asObserver()
        self.onSelectedEvent = _selectedEvent.asObservable()
        
        let _events = BehaviorSubject<[EKEvent]>(value: [])
        self.events = _events.asObserver()
        self.onShowEvents = _events.asObservable()
        
        let _deletedEvent = PublishSubject<EKEvent>()
        self.deletedEvent = _deletedEvent.asObserver()
        self.onDeletedEvent = _deletedEvent.asObservable()
        
        _ = self.didReload.asObservable().subscribe(onNext: { [weak self] in
            self?.eventStore.makeSureGranted {
                let calendars = self?.eventStore.calendars(for: .event) ?? []
                for calendar in calendars {
                    let oneMonthAgo = NSDate(timeIntervalSinceNow: -30*24*3600)
                    let oneMonthAfter = NSDate(timeIntervalSinceNow: +30*24*3600)
                    let predicate = (self?.eventStore.predicateForEvents(withStart: oneMonthAgo as Date, end: oneMonthAfter as Date, calendars: [calendar]))!
                    let events = self?.eventStore.events(matching: predicate)
                    self?.events.onNext(events ?? [])
                }
            }
        })
        
        _ = self.didLogout.asObservable().subscribe(onNext: { [weak self] in
            self?.unpersistUser()
        })
        
        _ = self.onDeletedEvent.asObservable().subscribe(onNext: { [weak self] eventToDelete in
            self?.eventStore.makeSureGranted {
                do {
                    try self?.eventStore.remove(eventToDelete, span: .thisEvent)
                    self?.reload.onNext(())
                } catch let error as NSError {
                    print("failed to save event with error : \(error)")
                }
            }
        })
    }
    private func unpersistUser() {
        self.defaults.reset()
        self.defaults.synchronize()
    }
    
    
}
