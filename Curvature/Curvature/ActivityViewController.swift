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

enum Activity: Int {
    case KnowledgeSurvey, BackgroundSurvey, Picture, Tilt
    
    static var allValues: [Activity] {
        var idx = 0
        return Array(AnyGenerator{ return self.init(rawValue: idx++)})
    }
    
    var title: String {
        switch self {
            case .KnowledgeSurvey:
                return "Knowledge Survey"
            case .BackgroundSurvey:
                return "Background Survey"
            case .Picture:
                return "Cobb's Curve"
            case .Tilt:
                return "Adam's Test"
        }
    }
    
    var subtitle: String {
        switch self {
            case .KnowledgeSurvey:
                return "Answer 6 short questions about your knowledge of scoliosis"
            case .BackgroundSurvey:
                return "Answer 6 short questions about your background of scoliosis"
            case .Picture:
                return "Take a picture to identify abnormalities of your spinal curve"
            case .Tilt:
                return "Measure asymmetry of your back"
        }
    }
}

extension ActivityViewController : ORKTaskViewControllerDelegate {
    
    func taskViewController(taskViewController: ORKTaskViewController, stepViewControllerWillAppear stepViewController: ORKStepViewController) {
        // Example data processing for the wait step.
    }
    
    func taskViewController(taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {
        // Handle results using taskViewController.result
        motionManager.stopGyroUpdates()
        taskViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}

class ActivityViewController: UITableViewController {
    // MARK: UITableViewDataSource
    
    var motionManager = CMMotionManager()

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section == 0 else { return 0 }
        
        return Activity.allValues.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("activityCell", forIndexPath: indexPath)
        
        if let activity = Activity(rawValue: indexPath.row) {
            cell.textLabel?.text = activity.title
            cell.detailTextLabel?.text = activity.subtitle
        }

        return cell
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let activity = Activity(rawValue: indexPath.row) else { return }
        
        let taskViewController: ORKTaskViewController
        switch activity {
            case .KnowledgeSurvey:
                taskViewController = ORKTaskViewController(task: StudyTasks.KnowledgeSurveyTask, taskRunUUID: NSUUID())
            
            case .BackgroundSurvey:
                taskViewController = ORKTaskViewController(task: StudyTasks.BackgroundSurveyTask, taskRunUUID: NSUUID())
            
            case .Picture:
                taskViewController = ORKTaskViewController(task: StudyTasks.pictureTask, taskRunUUID: NSUUID())

            case .Tilt:
                taskViewController = ORKTaskViewController(task: StudyTasks.tiltTask, taskRunUUID: NSUUID())
                if motionManager.gyroAvailable {
                    var values: [String] = []
                    
                    motionManager.gyroUpdateInterval = 1.0
                    motionManager.startGyroUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { (gyroData, NSError) -> Void in
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
        
        taskViewController.outputDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        taskViewController.delegate = self
        
        navigationController?.presentViewController(taskViewController, animated: true, completion: {
            tableView.cellForRowAtIndexPath(indexPath)!.accessoryType = .Checkmark
        })
    }
}
