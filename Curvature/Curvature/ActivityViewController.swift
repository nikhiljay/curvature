/*
 Copyright (c) 2015, Apple Inc. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 
 1.  Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2.  Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation and/or
 other materials provided with the distribution.
 
 3.  Neither the name of the copyright holder(s) nor the names of any contributors
 may be used to endorse or promote products derived from this software without
 specific prior written permission. No license is granted to the trademarks of
 the copyright holders even if such marks are included in this software.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import UIKit
import ResearchKit
import CoreMotion
import Firebase

enum Activity: Int {
    case knowledgeSurvey, backgroundSurvey, picture, tilt
    
    static var allValues: [Activity] {
        var idx = 0
        return Array(AnyIterator{ return self.init(rawValue: idx++)})
    }
    
    var title: String {
        switch self {
        case .knowledgeSurvey:
            return "Knowledge Survey"
        case .backgroundSurvey:
            return "Background Survey"
        case .picture:
            return "Cobb's Curve"
        case .tilt:
            return "Adam's Test"
        }
    }
    
    var subtitle: String {
        switch self {
        case .knowledgeSurvey:
            return "Answer 6 short questions about your knowledge of scoliosis"
        case .backgroundSurvey:
            return "Answer 6 short questions about your background of scoliosis"
        case .picture:
            return "Take a picture to identify abnormalities of your spinal curve"
        case .tilt:
            return "Measure asymmetry of your back"
        }
    }
}

var specificTask: String!
var checked: Bool = false

extension ActivityViewController : ORKTaskViewControllerDelegate {
    /**
     Tells the delegate that the task has finished.
     
     The task view controller calls this method when an unrecoverable error occurs,
     when the user has canceled the task (with or without saving), or when the user
     completes the last step in the task.
     
     In most circumstances, the receiver should dismiss the task view controller
     in response to this method, and may also need to collect and process the results
     of the task.
     
     @param taskViewController  The `ORKTaskViewController `instance that is returning the result.
     @param reason              An `ORKTaskViewControllerFinishReason` value indicating how the user chose to complete the task.
     @param error               If failure occurred, an `NSError` object indicating the reason for the failure. The value of this parameter is `nil` if `result` does not indicate failure.
     */
    public func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        <#code#>
    }

    
    func taskViewController(_ taskViewController: ORKTaskViewController, stepViewControllerWillAppear stepViewController: ORKStepViewController) {
        // Example data processing for the wait step.
    }
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: NSError?) {
        // Handle results using taskViewController.result
        
        var myRootRef = FIRDatabase.database().reference()
        myRootRef.observeSingleEvent(of: .value, with: {
            snapshot in
            myRootRef.observeAuthEvent({ authData in
                if authData != nil {
                    
                    let usersRef = myRootRef?.child(byAppendingPath: "users")
                    
                    //Task Completion
                    var taskCompletion = snapshot?.value["users"]!![authData.uid]!!["taskCompletion"]! as! Double
                    let tasks = snapshot?.value["users"]!![authData.uid]!!["tasks"]! as! [String: Bool]
                    if taskCompletion < 100 && checked == false {
                        let tasksLength = Double(tasks.count)
                        taskCompletion += (1.0 / tasksLength) * 100.0
                        
                        usersRef.updateChildValues([
                            "\(authData.uid)/taskCompletion": Int(taskCompletion)
                        ])
                    }

                    //Specific Tasks
                    
                    usersRef?.updateChildValues([
                        "\(authData?.uid)/tasks/\(specificTask)": true
                    ])
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.tableView.reloadData()
                    })
                    
                    checked = false
                }
            })
        })

        motionManager.stopGyroUpdates()
        taskViewController.dismiss(animated: true, completion: nil)
    }
}

class ActivityViewController: UITableViewController {
    // MARK: UITableViewDataSource
    
    var motionManager = CMMotionManager()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section == 0 else { return 0 }
        
        return Activity.allValues.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath)
        
        if let activity = Activity(rawValue: (indexPath as NSIndexPath).row) {
            cell.textLabel?.text = activity.title
            cell.detailTextLabel?.text = activity.subtitle
        }
        
        var myRootRef = FIRDatabase.database().reference()
        myRootRef.observeSingleEvent(of: .value, with: {
            snapshot in
            myRootRef.observeAuthEvent({ authData in
                if authData != nil {
                    let surveyKnowledgeValue = snapshot?.value["users"]!![authData.uid]!!["tasks"]!!["surveyKnowledge"]! as! Bool
                    let surveyBackgroundValue = snapshot?.value["users"]!![authData.uid]!!["tasks"]!!["surveyBackground"]! as! Bool
                    let picture = snapshot?.value["users"]!![authData.uid]!!["tasks"]!!["picture"]! as! Bool
                    let bend = snapshot?.value["users"]!![authData.uid]!!["tasks"]!!["bend"]! as! Bool
                    
                    if ((cell.textLabel?.text == "Knowledge Survey" && surveyKnowledgeValue) || (cell.textLabel?.text == "Background Survey" && surveyBackgroundValue) || (cell.textLabel?.text == "Cobb's Curve" && picture) || (cell.textLabel?.text == "Adam's Test" && bend)) {
                        tableView.cellForRow(at: indexPath)!.accessoryType = .checkmark
                    }
                }
            })
        })
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let activity = Activity(rawValue: (indexPath as NSIndexPath).row) else { return }
        
        let taskViewController: ORKTaskViewController
        switch activity {
        case .knowledgeSurvey:
            taskViewController = ORKTaskViewController(task: StudyTasks.KnowledgeSurveyTask, taskRun: UUID())
            specificTask = "surveyKnowledge"
            if (tableView.cellForRow(at: indexPath)!.accessoryType == .checkmark) { checked = true }
            
        case .backgroundSurvey:
            taskViewController = ORKTaskViewController(task: StudyTasks.BackgroundSurveyTask, taskRun: UUID())
            specificTask = "surveyBackground"
            if (tableView.cellForRow(at: indexPath)!.accessoryType == .checkmark) { checked = true }
            
        case .picture:
            taskViewController = ORKTaskViewController(task: StudyTasks.pictureTask, taskRun: UUID())
            specificTask = "picture"
            if (tableView.cellForRow(at: indexPath)!.accessoryType == .checkmark) { checked = true }
            
        case .tilt:
            taskViewController = ORKTaskViewController(task: StudyTasks.tiltTask, taskRun: UUID())
            specificTask = "bend"
            if (tableView.cellForRow(at: indexPath)!.accessoryType == .checkmark) { checked = true }
            if motionManager.isGyroAvailable {
                var values: [String] = []
                
                motionManager.gyroUpdateInterval = 1.0
                motionManager.startGyroUpdates(to: OperationQueue.main, withHandler: { (gyroData, NSError) -> Void in
                    var degrees = (gyroData?.rotationRate.y)! * 180 / M_PI
                    var yTotal: Double = 0.0
                    degrees -= 0.4
                    
                    if (degrees > 0.2 || degrees < -0.2) {
                        yTotal += degrees;
                    }
                    
                    let y: String = String(format: "%.02f", yTotal)
                    values.append(y)
                    print(values)
                })
            }
        }
        
        taskViewController.outputDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        taskViewController.delegate = self
        
        navigationController?.present(taskViewController, animated: true, completion: nil)
    }
}
