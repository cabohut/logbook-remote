//
//  AppHelpers.swift
//  Logbook
//
//  Created by bugs on 7/19/22.
//

import Foundation

func convertDate(date: String) -> Date {
    let dt = date.components(separatedBy: " ")
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    return dateFormatter.date(from: dt[0]) ?? Date()
}

func clearReminders(car: inout Car) {
    car.overdueRemindersCount = 0
    car.upcomingRemindersCount = 0
    car.reminders = []
}

func updateReminders (car: inout Car, carIndex: Int) {
    /*
    // clear reminders for this car
    Car.clearReminders(car: &car)
    
    for s in car.services {
        var reminder = Reminder.new()
        self.checkServiceStatus(car: car, service: s, reminder: &reminder)
        
        if (reminder.dateStatus == .isDue || reminder.milesStatus == .isDue) {
            car.overdueRemindersCount += 1

            reminder.serviceType = s.serviceType
            Reminder99.add(reminders: &car.reminders, reminder: reminder)
        }
        
        if (reminder.dateStatus == .isUpcoming && reminder.milesStatus == .isUpcoming) {
            car.upcomingRemindersCount += 1

            reminder.serviceType = s.serviceType
            Reminder99.add(reminders: &car.reminders, reminder: reminder)
        }
    }
    
    car.reminders = car.reminders.sorted()
    
    let idx = _g.shared.remindersCounts.firstIndex(where: { $0.carID == car.id }) ?? -1
    if idx >= 0 {
        _g.shared.remindersCounts[idx].count = car.reminders.count
    } else {
        let c = CarRemindersCount.init(carID: car.id, count: car.reminders.count)
        _g.shared.remindersCounts.append(c)
    }

    _g.shared.updateDueRemindersCount()
     */
}

func checkServiceStatus (car: Car, service: Service, reminder: inout Reminder) {
    if !service.maintEnabled {
        return
    }
    
    // Need to get the last time the service (serviceType) was performed or if it is the first
    // time for that service then get the date and odometer of the last maintenance. App should
    // prompt the user to add an odometer log with date and milages (in case of a used car)
    
    /*
    var lastLog = Log99.getLastLogByType(logs: car.logs, serviceType: service.serviceType)
    if lastLog == nil {  // no log for LogType was found
        lastLog = Log99.new()
        lastLog?.date = car.purchaseDate
        lastLog?.odometer = 0
    }

    let carLastLog = car.logs.max { $0.odometer < $1.odometer }
    let lastMilages = carLastLog?.odometer ?? 0
    
    if service.maintMonths > 0 {
        let dateSchedInSeconds = service.maintMonths * Int(60 * 60 * 24 * 30.4369)
        reminder.dateDue = lastLog!.date.timeIntervalSince1970 + TimeInterval(dateSchedInSeconds)
        
        reminder.daysUntilDue = Int((reminder.dateDue - Date().timeIntervalSince1970) / 86400)
        if reminder.daysUntilDue < 0 && reminder.dateDue > 0 {
            reminder.dateStatus = .isDue
        } else {
            reminder.dateStatus = .isUpcoming
        }
        reminder.dateStatus = (reminder.dateStatus == .isDue || reminder.milesStatus == .isDue) ? .isDue : reminder.dateStatus
    }
    
    if service.maintMiles > 0 {
        reminder.milesDue = lastLog!.odometer + service.maintMiles
        reminder.milesUntilDue = reminder.milesDue - lastMilages
        if reminder.milesUntilDue < 0 && reminder.milesDue > 0 {
            reminder.milesStatus = .isDue
        } else {
            reminder.milesStatus = .isUpcoming
        }
        reminder.milesStatus = (reminder.milesStatus == .isDue || reminder.milesStatus == .isDue) ? .isDue : reminder.milesStatus
    }
     */
}

// custom modifier
// https://useyourloaf.com/blog/swiftui-custom-view-modifiers/
struct NumField: ViewModifier {
    let enabled: Bool
    
    func body(content: Content) -> some View {
        content
            .padding(3)
            .padding(.horizontal, 5)
            .frame(width: 70)
            .multilineTextAlignment(.trailing)
            .overlay(RoundedRectangle(cornerRadius: 4.0)
                .strokeBorder(enabled ? .orange : Color.primary, style: StrokeStyle(lineWidth: enabled ? 0.2 : 0.05)))
            .foregroundColor(enabled ? Color.primary : .gray)
            .disabled(!enabled)
            .keyboardType(.numberPad)
        //.background(Color(0xF2F2F7, alpha: 0.1))
    }
}

extension View {
    func num_field(enabled: Bool = true) -> some View {
        modifier(NumField(enabled: enabled))
    }
}

struct CheckboxStyle: ToggleStyle {
    // https://www.appcoda.com/swiftui-toggle-style/
    func makeBody(configuration: Self.Configuration) -> some View {
        return HStack {
            Image(systemName: "clock")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(configuration.isOn ? .orange : .gray)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
            configuration.label
        }
    }
}
