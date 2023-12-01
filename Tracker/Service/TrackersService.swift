//
//  TrackersService.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 12.10.2023.
//

import Foundation
import UIKit

public protocol TrackersServiseProtocol {
    var view: TrackersViewControllerProtocol? {get set}
    var selectedFilter: String {get set}
    var visibleDay: Date? {get set}
    func changeDate(for day: Date)
    func addTracker(categoryNewName: String, name: String, emoji: String, color: UIColor, timetable: [Int] )
    func deleteTracker(for indexPath: IndexPath)
    func addTrackerRecord(for indexPath: IndexPath)
    func deleteTrackerRecord(for indexPath: IndexPath)
    func getTrackerRecord(for indexPath: IndexPath)-> Int
    func addTrackerEvent(categoryNewName: String, name: String, emoji: String, color: UIColor)
    func searchTrackers(text: String, day: Date)
    var numberOfSections: Int { get }
    func numberOfRowsInSection(_ section: Int) -> Int
    func objectModel(at indexPath: IndexPath) -> TrackerCellModel?
    func nameforSection(_ section: Int) -> String?
    func setFilters(filter: String, selectedDay: Date)
    func editTracker(categoryNewName: String, index: IndexPath, name: String, emoji: String, color: UIColor, timetable: [Int])
    func pinnedTracker(index: IndexPath, state: Bool)
}

final class TrackersService: TrackersServiseProtocol {
    
    static var shared = TrackersService()
    static let didChangeNotification = Notification.Name(rawValue: "TrackersServiceDidChange")
    private var currentDay = NSDate()
    private let UIcolorMarshalling = UIColorMarshalling()
    var visibleDay: Date?
    var selectedFilter: String = "Все трекеры"
    weak var view: TrackersViewControllerProtocol?
    private lazy var trackerStore: TrackerStore = {
        let store = TrackerStore()
        store.delegate = self
        return store
    }()
    private lazy var trackerCategoryStore: TrackerCategoryStore = {
        let store = TrackerCategoryStore()
        store.delegate = self
        return store
    }()
    private var trackerRecordStore = TrackerRecordStore()
    

    //MARK: - Filters

    func setFilters(filter: String, selectedDay: Date) {
        selectedFilter = filter
        visibleDay = selectedDay
       // selectedDay = selectedDay
        let filter = Filters.init(rawValue: filter)

        switch filter {
        case .all:
            filterAllTrackers(day: selectedDay)
        case .allToday:
            filterTrackersToday()
        case .completed:
            filterCompleted(day: selectedDay)
        case .notCompleted:
            filterNotCompletedTrackers(day: selectedDay)
        default:
            return
        }
    }

    
    func filterAllTrackers(day: Date){
        //Все трекеры в выбранный на календаре день
        self.changeDate(for: day)
        view?.update()
    }
    
    func filterTrackersToday(){
        //Трекеры на сегондя. В календаре устанавливается выбранный дата (сегодня),
        self.changeDate(for: currentDay as Date)
        view?.update()
    }
    
    func filterCompleted(day: Date){
        //Завершенные - только выолненные трекеры в текущий день. При переключении дней отображаются завершенные трекеры
        
        trackerStore.predicateFetch(completedDay: day)
        view?.update()
    }
    
    func filterNotCompletedTrackers(day: Date){
        //Завершенные - только НЕвыолненные трекеры в текущий день  При переключении дней отображаются НЕ завершенные трекеры
        trackerStore.predicateFetch(notCompleted: day)
        view?.update()
    }
    
    //MARK: - Search Trackers by date
    
    func changeDate(for day: Date)  {
        
        let numberOfDay = Calendar.current.component(.weekday, from: day ) - 1
        trackerStore.predicateFetch(numberOfDay: numberOfDay)
        visibleDay = day
        view?.update()
    }
    
    //MARK: - Search Trackers by text
    
    func searchTrackers(text: String, day: Date) {
        
        let numberOfDay = Calendar.current.component(.weekday, from: day as Date ) - 1
        trackerStore.predicateFetch(text: text, numberOfDay: numberOfDay)
        view?.update()
    }
    
    //MARK: - Add Trackers
    
    func saveTracker(tracker: Tracker, with categoryName: String){
        let trackerCoreData = trackerStore.convertTracker(tracker: tracker)
        try?  trackerCategoryStore.addTrackerToCategory(tracker: trackerCoreData, categoryName: categoryName)
    }
    
    func addTracker(categoryNewName: String, name: String, emoji: String, color: UIColor, timetable: [Int] ) {
        let tracker = Tracker(
            id:  UUID(),
            name: name,
            color: color,
            emoji: emoji,
            timetable: timetable,
            isPinned: false
        )
        saveTracker(tracker: tracker, with: categoryNewName)
    }
    
    func addTrackerEvent(categoryNewName: String, name: String, emoji: String, color: UIColor) {
        let timetable =  [0,1,2,3,4,5,6]
        
        let tracker = Tracker(
            id:  UUID(),
            name: name,
            color: color,
            emoji: emoji,
            timetable: timetable,
            isPinned: false
        )
        saveTracker(tracker: tracker, with: categoryNewName)
    }
    
    
    //MARK: - Edit Trackers
    
    func editTracker(categoryNewName: String, index: IndexPath, name: String, emoji: String, color: UIColor, timetable: [Int]){
        
        //Получаем старый трекер
        guard let tracker = trackerStore.getTrackerCoreData(for: index) else {return print("Не удалось создать трекер для редактирования") }
        
        //проверяем изменилась ли категория?
        if tracker.category?.categoryName == categoryNewName {
            //Категория не изменилась
            // меняем только данные трекера
            tracker.emoji = emoji
            tracker.colorHex = UIcolorMarshalling.hexString(from:color)
            tracker.schedule =  WeekDay.getShedule(for: timetable )
            tracker.name = name
            trackerStore.saveContext()
        } else {
            //Категория другая
            //Удаляем трекер из старой категории и добавляем в новую
           try? trackerCategoryStore.editTrackerToCategory(tracker: tracker, newCategoryName: categoryNewName )
        }
        
    }
    
    func pinnedTracker(index: IndexPath, state: Bool){
        //Получаем старый трекер
        guard let tracker = trackerStore.getTrackerCoreData(for: index) else {return print("Не удалось создать трекер для редактирования") }
        tracker.isPinned = state
        trackerStore.saveContext()
    }
    
    
    //MARK: - Delete Trackers
    
    func deleteTracker(for indexPath: IndexPath){
        try? trackerStore.deleteTracker(for: indexPath)
    }
    
    func isEnableCompleteButton() -> Bool {
        guard let visibleDay else { return true }
        return visibleDay.daysBetweenDate(toDate: currentDay as Date) >= 0
    }
    
    func getCompleteState(tracker: Tracker, date: Date)-> Bool {
        return trackerRecordStore.getCompleteState(tracker: tracker, date: date)
    }
    
    func deleteTrackerRecord(for indexPath: IndexPath){
        guard let recordDay = visibleDay,
              let tracker = trackerStore.tracker(for: indexPath) else { return }
        
        try? trackerRecordStore.deleteTracker(tracker: tracker, recordDay: recordDay)
        
        if let visibleDay = visibleDay {
            setFilters(filter: selectedFilter, selectedDay: visibleDay)
        }
        
    }
    
    func addTrackerRecord(for indexPath: IndexPath){
        guard let recordDay = visibleDay,
              let tracker = trackerStore.tracker(for: indexPath)
        else { return }
        
        try? trackerRecordStore.addRecord(tracker: tracker, recordDate: recordDay)
    }
    
    func getTrackerRecord(for indexPath: IndexPath)-> Int {
        guard let tracker = trackerStore.tracker(for: indexPath)
        else { return 0 }
        
        return trackerRecordStore.getTrackerRecord(tracker: tracker)
    }
    
}


//MARK: - Store Delegate

extension TrackersService: StoreDelegateProtocol {
   
    func didUpdate(_ update: StoreUpdate) {
        view?.update()
       // view?.updateData(update)
    }
    
    
    var numberOfSections: Int {
      trackerStore.fetchedResultsController.sections?.count ?? 0
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
       trackerStore.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func objectModel(at indexPath: IndexPath) -> TrackerCellModel? {
       let trackerCore = trackerStore.fetchedResultsController.object(at: indexPath)
        guard let tracker = try? trackerStore.getTrackers(from: trackerCore) else { return nil }
        
        if visibleDay == nil {
            visibleDay = currentDay as Date
        }
        let trackerModell = TrackerCellModel(
            id: tracker.id,
            descriptionTracker: tracker.name,
            color: tracker.color,
            emoji: tracker.emoji,
            timetable: tracker.timetable,
            complete: getCompleteState(tracker: tracker, date: visibleDay!), // функция проверки на выполнение
            record: getTrackerRecord(for: indexPath), // функция проверки на рекорд
            isEnable: isEnableCompleteButton(), // проверка доступности состояния кнопки
            categoryName: trackerCore.category?.categoryName,
            isPinned: tracker.isPinned,
            index: indexPath
        )
        return trackerModell
    }
    
    func fetchTrackers() -> [Tracker] {
        guard let trackers = try? trackerStore.fetchTrackers()  else { return [] }
        return trackers
    }
    
    func nameforSection(_ section: Int) -> String? {
        return trackerStore.fetchedResultsController.sections?[section].name ?? ""
        }
    
}

extension TrackersService: TrackerCategoryStoreDelegate {
    func storeDidUpdate(_ store: TrackerCategoryStore) {
    
    }
}
