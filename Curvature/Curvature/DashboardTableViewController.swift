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
import Firebase
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class DashboardTableViewController: UITableViewController, ORKPieChartViewDataSource {
    // MARK: Properties
    
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet var pieChart: ORKPieChartView!
    @IBOutlet var descreteGraph: ORKDiscreteGraphChartView!
    @IBOutlet var lineGraph: ORKLineGraphChartView!
    @IBOutlet weak var healthActivityIndicator: UIActivityIndicatorView!
    
    var allCharts: [UIView] {
        return [pieChart, descreteGraph, lineGraph]
    }
    
    let descreteGraphDataSource = DiscreteGraphDataSource()
    let lineGraphDataSource = LineGraphDataSource()
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        healthActivityIndicator.startAnimating()
        
        loadData { (percentage) in
            self.activityCompletionPercentage = percentage
            self.pieChart.dataSource = self
            self.reloadCharts()
        }
        reloadCharts()
        
        // Set the data source for each graph
        descreteGraph.dataSource = descreteGraphDataSource
        lineGraph.dataSource = lineGraphDataSource
        
        // Set the table view to automatically calculate the height of cells.
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func refresh(_ sender: AnyObject) {
        loadData { (percentage) in
            self.activityCompletionPercentage = percentage
        }
    }
    
    func loadData(_ completionHandler: @escaping (_ percentage: CGFloat) -> ()) {
        var myRootRef = FIRDatabase.database().reference()
        myRootRef.observe(.value, with: {
            snapshot in
            myRootRef.observeSingleEvent({ authData in
                if authData != nil {
                    // user authenticated
                    let condition = snapshot?.value["users"]!![authData.uid]!!["condition"]!
                    self.conditionLabel.text = condition as? String
                    self.healthActivityIndicator.stopAnimating()
                    
                    var taskCompletion = snapshot?.value["users"]!![authData.uid]!!["taskCompletion"]! as! CGFloat!
                    if (taskCompletion < 1) {
                        taskCompletion = 1
                    } else if (taskCompletion > 99) {
                        taskCompletion = 99
                    }
                    completionHandler(percentage: taskCompletion)
                }
            })
        })
    }
    
    func reloadCharts() {
        let visibleCells = tableView.visibleCells
        let visibleAnimatableCharts = visibleCells.flatMap { animatableChartInCell($0) }
        
        for chart in visibleAnimatableCharts {
            chart.animateWithDuration(0.5)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Animate any visible charts
        reloadCharts()
    }
    
    // MARK: PieView
    
    func numberOfSegments(in pieChartView: ORKPieChartView) -> Int {
        if activityCompletionPercentage > 0 {
            return 2
        } else {
            return 1
        }
    }
    
    enum PieChartSegment: Int {
        case completed, remaining
    }
    
    var activityCompletionPercentage: CGFloat = 1
    
    func pieChartView(_ pieChartView: ORKPieChartView, valueForSegmentAt index: Int) -> CGFloat {
        switch PieChartSegment(rawValue: index)! {
        case .completed:
            return activityCompletionPercentage
        case .remaining:
            return 100 - activityCompletionPercentage
        }
    }
    
    func pieChartView(_ pieChartView: ORKPieChartView, colorForSegmentAt index: Int) -> UIColor {
        switch PieChartSegment(rawValue: index)! {
        case .completed:
            return UIColor(red: 101/225, green: 201/255, blue: 122/225, alpha: 1)
        case .remaining:
            return UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
        }
    }
    
    func pieChartView(_ pieChartView: ORKPieChartView, titleForSegmentAt index: Int) -> String {
        switch PieChartSegment(rawValue: index)! {
        case .completed:
            return NSLocalizedString("Completed", comment: "")
        case .remaining:
            return NSLocalizedString("Remaining", comment: "")
        }
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Animate charts as they're scrolled into view.
        if let animatableChart = animatableChartInCell(cell) {
            animatableChart.animateWithDuration(0.5)
        }
    }
    
    // MARK: Convenience
    
    func animatableChartInCell(_ cell: UITableViewCell) -> AnimatableChart? {
        for chart in allCharts {
            guard let animatableChart = chart as? AnimatableChart , chart.isDescendant(of: cell) else { continue }
            return animatableChart
        }
        
        return nil
    }
}
