//
//  StatisticsTableViewDataSource.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/7/13.
//

import UIKit

class StatisticsTableViewDataSource: NSObject, UITableViewDataSource {
    
    
    weak var viewController: StatisticsViewController?
    
    
    
    //MARK: UITableView DataSource
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            2
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MoodFlowCell.reuseIdentifier, for: indexPath) as?
                        MoodFlowCell
                else {fatalError("Could not create Cell")}
                
                
                return cell
            } else  {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SleepAnalysisCell.reuseIdentifier, for: indexPath) as? SleepAnalysisCell
                else {fatalError("Could not create Cell")}
                
                //sleepLabel
                let sleepLabel = UILabel()
                sleepLabel.removeFromSuperview()
                sleepLabel.text = NSLocalizedString("sleepLabel", comment: "")
                sleepLabel.textColor = .orangeBrown
                sleepLabel.font = UIFont.systemFont(ofSize: 16)
                cell.containerView.addSubview(sleepLabel)

                sleepLabel.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    sleepLabel.topAnchor.constraint(equalTo: cell.containerView.topAnchor, constant: 22),
                    sleepLabel.leadingAnchor.constraint(equalTo: cell.containerView.leadingAnchor, constant: 22)
                ])
                
                //hrs
                let hrsLabel = UILabel()
                hrsLabel.removeFromSuperview()
                hrsLabel.text = NSLocalizedString("hrs", comment: "")
                hrsLabel.textColor = .lightGray
                hrsLabel.font = UIFont.systemFont(ofSize: 13)
                cell.containerView.addSubview(hrsLabel)
                
                hrsLabel.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    hrsLabel.trailingAnchor.constraint(equalTo: cell.containerView.trailingAnchor, constant: -50),
                    hrsLabel.topAnchor.constraint(equalTo: cell.containerView.topAnchor, constant: 45)
                ])
                
                //Average label (
                let bedTimeLabel = UILabel.createLabel(text: NSLocalizedString("averageBed", comment: ""),
                                                       font: UIFont.systemFont(ofSize: 13),
                                                       textColor: .lightGray, textAlignment: .center,
                                                       numberOfLines: 2,
                                                       in: cell.containerView,
                                                       bottomAnchorConstant: 85, leadingAnchorConstant: 35)

                
                let wakeTimeLabel = UILabel.createLabel(text: NSLocalizedString("averageWake", comment: ""),
                                                       font: UIFont.systemFont(ofSize: 13),
                                                       textColor: .lightGray, textAlignment: .center,
                                                        numberOfLines: 2,
                                                        in: cell.containerView,
                                                       bottomAnchorConstant: 85, centerXAnchorConstant: 0)

                
                let sleepTimeLabel = UILabel.createLabel(text: NSLocalizedString("averageSleep", comment: ""),
                                                       font: UIFont.systemFont(ofSize: 13),
                                                       textColor: .lightGray, textAlignment: .center,
                                                        numberOfLines: 2,
                                                        in: cell.containerView,
                                                       bottomAnchorConstant: 85, trailingAnchorConstant: -35)

                
//
//                let bedTimeLabel = UILabel()
//                let wakeTimeLabel = UILabel()
//                let sleepTimelabel = UILabel()
//
//                bedTimeLabel.text = NSLocalizedString("averageBed", comment: "")
//                bedTimeLabel.numberOfLines = 2
//                bedTimeLabel.textAlignment = .center
//                wakeTimeLabel.text = NSLocalizedString("averageWake", comment: "")
//                wakeTimeLabel.numberOfLines = 2
//                wakeTimeLabel.textAlignment = .center
//                sleepTimelabel.text = NSLocalizedString("averageSleep", comment: "")
//                sleepTimelabel.numberOfLines = 2
//                sleepTimelabel.textAlignment = .center
//                bedTimeLabel.font = UIFont.systemFont(ofSize: 13)
//                wakeTimeLabel.font = UIFont.systemFont(ofSize: 13)
//                sleepTimelabel.font = UIFont.systemFont(ofSize: 13)
//                bedTimeLabel.textColor = .lightGray
//                wakeTimeLabel.textColor = .lightGray
//                sleepTimelabel.textColor = .lightGray
//                cell.containerView.addSubview(bedTimeLabel)
//                cell.containerView.addSubview(wakeTimeLabel)
//                cell.containerView.addSubview(sleepTimelabel)
//
//                bedTimeLabel.translatesAutoresizingMaskIntoConstraints = false
//                wakeTimeLabel.translatesAutoresizingMaskIntoConstraints = false
//                sleepTimelabel.translatesAutoresizingMaskIntoConstraints = false
//
//                NSLayoutConstraint.activate([
//                    bedTimeLabel.leadingAnchor.constraint(equalTo: cell.containerView.leadingAnchor, constant: 35),
//                    bedTimeLabel.bottomAnchor.constraint(equalTo: cell.containerView.bottomAnchor, constant: -30),
//                ])
//                NSLayoutConstraint.activate([
//                    wakeTimeLabel.centerXAnchor.constraint(equalTo: cell.containerView.centerXAnchor),
//                    wakeTimeLabel.bottomAnchor.constraint(equalTo: cell.containerView.bottomAnchor, constant: -30)
//                ])
//                NSLayoutConstraint.activate([
//                    sleepTimelabel.trailingAnchor.constraint(equalTo: cell.containerView.trailingAnchor, constant: -35),
//                    sleepTimelabel.bottomAnchor.constraint(equalTo: cell.containerView.bottomAnchor, constant: -30)
//                ])
                
                
                //TimeLabel (不能在裡面new，不然reload data會一直出現重複的）
//                let bedTime = UILabel()
//                let wakeTime = UILabel()
//                let sleepTime = UILabel()
                
                //預設先拿掉TimeLabel，以免拿到資料後，更新會重複add (default)
                viewController?.bedTime.removeFromSuperview()
                viewController?.wakeTime.removeFromSuperview()
                viewController?.sleepTime.removeFromSuperview()
                
                viewController?.bedTime.text = viewController?.averageBedTime
                viewController?.wakeTime.text = viewController?.averageWakeTime
                viewController?.sleepTime.text = viewController?.averageSleepTime
                viewController?.bedTime.font = UIFont.boldSystemFont(ofSize: 18)
                viewController?.wakeTime.font = UIFont.boldSystemFont(ofSize: 18)
                viewController?.sleepTime.font = UIFont.boldSystemFont(ofSize: 18)
                viewController?.bedTime.textColor = .darkGray
                viewController?.wakeTime.textColor = .darkGray
                viewController?.sleepTime.textColor = .darkGray
                cell.containerView.addSubview(viewController?.bedTime ?? UIView())
                cell.containerView.addSubview(viewController?.wakeTime ?? UIView())
                cell.containerView.addSubview(viewController?.sleepTime ?? UIView())
                
                viewController?.bedTime.translatesAutoresizingMaskIntoConstraints = false
                viewController?.wakeTime.translatesAutoresizingMaskIntoConstraints = false
                viewController?.sleepTime.translatesAutoresizingMaskIntoConstraints = false
                
                //先unwrap再設constraint
                if let bedTimeLeadingConstraint = viewController?.bedTime.leadingAnchor.constraint(equalTo: cell.containerView.leadingAnchor, constant: 35),
                   let bedTimeCenterYConstraint = viewController?.bedTime.centerYAnchor.constraint(equalTo: cell.containerView.centerYAnchor) {
                    
                    NSLayoutConstraint.activate([bedTimeLeadingConstraint, bedTimeCenterYConstraint
                    ])
                }
                
                if let wakeTimeCenterXAnchor = viewController?.wakeTime.centerXAnchor.constraint(equalTo: cell.containerView.centerXAnchor),
                   let wakeTimeCenterYConstraint = viewController?.wakeTime.centerYAnchor.constraint(equalTo: cell.containerView.centerYAnchor) {
                    
                    NSLayoutConstraint.activate([wakeTimeCenterXAnchor, wakeTimeCenterYConstraint
                    ])
                }
                
                if let sleepTimeTrailingAnchor = viewController?.sleepTime.trailingAnchor.constraint(equalTo: cell.containerView.trailingAnchor, constant: -35),
                   let sleepTimeCenterYConstraint = viewController?.sleepTime.centerYAnchor.constraint(equalTo: cell.containerView.centerYAnchor) {
                    
                    NSLayoutConstraint.activate([sleepTimeTrailingAnchor, sleepTimeCenterYConstraint
                    ])
                }
                
                return cell
            }
        }

}
