//
//  EventViewCell.swift
//  CalendarApp
//
//  Created by Janus Jordan on 6/3/23.
//

import Foundation
import UIKit
import EventKit

class EventViewCell: UITableViewCell {
    static let identifier = String(describing: EventViewCell.self)
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var date: UILabel!
    func configure(_ event: EKEvent) {
        eventName.text = event.title
        desc.text = event.location
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY, MMM d, hh:mm"
        date.text = "\(dateFormatter.string(from: event.startDate)) - \(dateFormatter.string(from: event.endDate))"
    }
}
