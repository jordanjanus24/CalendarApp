//
//  CalendarViewController.swift
//  CalendarApp
//
//  Created by Janus Jordan on 6/3/23.
//

import Foundation
import UIKit
import RxSwift
import EventKit
import EventKitUI

class CalendarViewController: UIViewController, Storyboarded {
    let disposeBag = DisposeBag()
    
    var viewModel: CalendarViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    let logoutButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left.circle"), style: .plain, target: nil, action: nil)
    let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: nil, action: nil)
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        refreshControl.sendActions(for: .valueChanged)
    }
    private func setupUI() {
        navigationItem.rightBarButtonItems = [plusButton]
        navigationItem.leftBarButtonItems = [logoutButton]
        
        tableView.insertSubview(refreshControl, at: 0)
    }
    private func setupBindings() {
        plusButton.rx.tap
            .bind(to: viewModel.showPopup)
            .disposed(by: disposeBag)
        
        logoutButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showActionAlert(title: "Calendar", message: "Are you sure you want to logout?", actions: [
                    .init(title: "Cancel", style: .default),
                    .init(title: "Yes", style: .default, handler: { _ in
                        self?.viewModel.logout.onNext(())
                    })
                ])
            })
            .disposed(by: disposeBag)
        
        viewModel.onShowEvents
            .observeOnMain()
            .do(onNext: { [weak self] _ in self?.refreshControl.endRefreshing() })
            .bind(to: tableView.rx.items(cellIdentifier: EventViewCell.identifier, cellType: EventViewCell.self)) { (_, item, cell) in
                cell.configure(item)
            }
            .disposed(by: disposeBag)
        

        tableView.rx.modelSelected(EKEvent.self)
            .bind(to: viewModel.selectedEvent)
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.reload)
            .disposed(by: disposeBag)
        
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        tableView.rx.modelDeleted(EKEvent.self)
            .subscribe(onNext: { [weak self] deletedEvent in
                self?.showActionAlert(title: "Calendar", message: "Are you sure you want to delete?", actions: [
                    .init(title: "Cancel", style: .default),
                    .init(title: "Yes", style: .default, handler: { _ in
                        self?.viewModel.deletedEvent.onNext(deletedEvent)
                    })
                ])
            })
            .disposed(by: disposeBag)
    }
}
extension CalendarViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            self.tableView.dataSource?.tableView!(self.tableView, commit: .delete, forRowAt: indexPath)
            completion(true)
        }
        let config = UISwipeActionsConfiguration(actions: [delete])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
}
