//
//  ViewController.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/14.
//

import UIKit

class HomeViewController: UIViewController, NewPageDelegate {
    
   
    let calendarView = UICalendarView()
    let gregorianCalendar = Calendar(identifier: .gregorian)
    var selectDate: DateComponents?
    
    private var moodTag = ""

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 隱藏 navigationBar
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 顯示 navigationBar
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        calendarView.delegate = self
        
        calendarView.calendar = gregorianCalendar
        view.addSubview(calendarView)
        calendarView.backgroundColor = .white
        
        //add constraints
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            calendarView.heightAnchor.constraint(equalToConstant: 420)
        ])
        
        //單選模式
        let singleDateSelection = UICalendarSelectionSingleDate(delegate: self)
        singleDateSelection.selectedDate = selectDate
        calendarView.selectionBehavior = singleDateSelection
        
    }
    
    //傳資料到newPage
    override func prepare (for segue: UIStoryboardSegue, sender: Any?) {
        //確認傳遞要項無誤
        if segue.identifier == "newPageSegue" {
            if let dateComponents = sender as? DateComponents,
               let segueVC = segue.destination as? NewPageViewController {
                //將任意點到的product資料，傳給newPageVC
                segueVC.dateComponents = dateComponents
                //建立delegate
                segueVC.delegate = self

            }
        }
    }
    
    //conform to protocol
    func newPage(_ newPage: NewPageViewController, didGet moodTag: String) {
        self.moodTag = moodTag
        print("tag成功傳過來啦")
    }

}

//MARK: Extension
extension HomeViewController: UICalendarViewDelegate {
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        let font = UIFont.systemFont(ofSize: 10)
        let configuration = UIImage.SymbolConfiguration(font: font)
        if let originalImage = UIImage(named: "Ellipse 4")?.withRenderingMode(.alwaysOriginal){
            let scaledSize = CGSize(width: 18, height: originalImage.size.height * 18 / originalImage.size.width)
            let renderer = UIGraphicsImageRenderer(size: scaledSize)
            let scaledImage = renderer.image { _ in
                originalImage.draw(in: CGRect(origin: .zero, size: scaledSize))
            }
            return .image(scaledImage)
        }else {
            return nil
        }
        
        //示範2
//        let font = UIFont.systemFont(ofSize: 10)
//        let configuration = UIImage.SymbolConfiguration(font: font)
//        let image = UIImage(systemName: "star.fill", withConfiguration: configuration)?.withRenderingMode(.alwaysOriginal)
//        return .image(image)
        
//        //示範1
//        if (dateComponents.day == selectDate?.day) && (dateComponents.year == selectDate?.year), (dateComponents.month == selectDate?.month) {
//            return UICalendarView.Decoration.customView {
//                //以下為他人示範
//                let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 50.0, height: 30.0))
//                label.textColor = .red
//                label.font = UIFont.systemFont(ofSize: 10.0)
//                label.text = "今"
//                return label
//            }
//        } else {
//            return .none
//        }
    }
}

extension HomeViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        if let date = dateComponents {
            self.selectDate = date
        }
        print(self.selectDate)
        
        //perform segue
        performSegue(withIdentifier: "newPageSegue", sender: dateComponents)
    }
}




