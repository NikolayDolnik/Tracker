//MARK: - UITableViewDelegate
/*
enum HabitsSections {
    case categoty([Int])
    case emoji([String])
    case color([UIColor])
}

extension HabitsViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section]  {
        case let .categoty(v):
//            return v.count
            1
        case let .emoji(v):
            return v.count
        case let .color(v):
            return v.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case let .categoty(array):
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = array[indexPath.row]
            return cell

        case let .emoji(v):
            let cell = tableView.dequeueReusableCell(withIdentifier: "necell", for: indexPath)
            cell.textLabel?.text = array[indexPath.row]
            return cell

        case let .color(v):
            let cell = tableView.dequeueReusableCell(withIdentifier: "2cell", for: indexPath)
            cell.textLabel?.text = array[indexPath.row]
            return cell
        }
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = params[indexPath.row]
//        cell.backgroundColor = .backgroundDayTracker
//        //cell.accessoryView = UISwitch()
//       // cell.accessoryView?.tintColor = .blue
//        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    
}


extension EmojiPresenter: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        switch indexPath.section {
        case 0:
            return CGSize(width: collectionView.bounds.width, height: 50)
        case 1:
            return CGSize(width: 30, height: 30)
        case 2:
            return CGSize(width: 50, height: 50)
        default:
            return .zero
        }
    }
}

 func addTracker(categoryName: String, name: String, emoji: String, color: UIColor, timetable: [WeekDay] ) {
 
    
     let tracker = Tracker(
         id: UInt(),
         name: "First Tracker",
         color: .selection14,
         emoji: "🌺",
         timetable: [WeekDay.monday]
     )
//        if categories.contains(where: { categories in
//            categories.categoreName == category
//        }) {
//
//        } else {
//            categories.append()
//            return
//        }
     
     for (index, category) in categories.enumerated(){
         if category.categoreName == categoryName {
             categories[index].trackers.append(tracker)
         }

     }
 
 var newVisibleCategory = [TrackerCategory]()
 
 for category in categories {
     let text = searchText.lowercased()
     print("Ищем \(text) в \(category)")
     if category.trackers.contains(where: { Tracker in
         Tracker.name.lowercased().contains(text)
     }) {
         newVisibleCategory.append(category)
     }
 }
     
 }
 
 
 func addTracker(categoryName: String, name: String, emoji: String, color: UIColor, timetable: [WeekDay] ) {
 
     var newArray: [Tracker] = []
     let tracker = Tracker(
         id: UInt(),
         name: "First Tracker",
         color: .selection14,
         emoji: "🌺",
         timetable: [WeekDay.monday]
     )

     for (index, category) in categories.enumerated(){
         if category.categoreName == categoryName {
             newArray = categories[index].trackers
         }

     }
     
 }
 
*/


//extension Date {
//    func dayNumberOfWeek() -> Int? {
//        return Calendar.current.dateComponents([.weekday], from: self).weekday
//    }
//}
//
//// returns an integer from 1 - 7, with 1 being Sunday and 7 being Saturday
//print(Date().dayNumberOfWeek()!) // 4
//
//extension Date {
//    func dayOfWeek() -> String? {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "EEEE"
//        return dateFormatter.string(from: self).capitalized
//        // or use capitalized(with: locale) if you want
//    }
//}
//
//print(Date().dayOfWeek()!) // Wednesday
