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
import HealthKit
import Firebase

class ProfileViewController: UITableViewController, HealthClientType {
    // MARK: Properties

    let healthObjectTypes = [
        HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)!,
        HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!,
        HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.biologicalSex)!
    ]
    
    var healthStore: HKHealthStore?
    
    @IBOutlet var applicationNameLabel: UILabel!
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let healthStore = healthStore else { fatalError("healhStore not set") }
        
        // Ensure the table view automatically sizes its rows.
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension

        // Request authrization to query the health objects that need to be shown.
        let typesToRequest = Set<HKObjectType>(healthObjectTypes)
        healthStore.requestAuthorization(toShare: nil, read: typesToRequest) { authorized, error in
            guard authorized else { return }
            
            // Reload the table view cells on the main thread.
            OperationQueue.main.addOperation() {
                let allRowIndexPaths = self.healthObjectTypes.enumerated().map { IndexPath(row: $0.index, section: 0) }
                self.tableView.reloadRows(at: allRowIndexPaths, with: .automatic)
            }
        }
    }
    
    @IBAction func logoutButtonPressed(_ sender: AnyObject) {
        var ref = FIRDatabase.database().reference()
        try! FIRAuth.auth()!.signOut()
        performSegue(withIdentifier: "loggedOut", sender: self)
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return healthObjectTypes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileStaticTableViewCell.reuseIdentifier, for: indexPath) as? ProfileStaticTableViewCell else { fatalError("Unable to dequeue a ProfileStaticTableViewCell") }
        let objectType = healthObjectTypes[(indexPath as NSIndexPath).row]
        
        switch(objectType.identifier) {
            case HKCharacteristicTypeIdentifier.dateOfBirth:
                configureCellWithDateOfBirth(cell)
            
            case HKQuantityTypeIdentifier.height:
                configureCellWithHeight(cell, valueForQuantityTypeIdentifier: objectType.identifier)
    
            case HKCharacteristicTypeIdentifier.biologicalSex:
                configureCellWithBiologicalSex(cell)
            
            default:
                fatalError("Unexpected health object type identifier - \(objectType.identifier)")
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Cell configuration
    
    func configureCellWithDateOfBirth(_ cell: ProfileStaticTableViewCell) {
        // Set the default cell content.
        cell.titleLabel.text = NSLocalizedString("Age", comment: "")
        cell.valueLabel.text = NSLocalizedString("-", comment: "")

        // Update the value label with the date of birth from the health store.
        guard let healthStore = healthStore else { return }

        do {
            let dateOfBirth = try healthStore.dateOfBirth()
            let now = Date()

            let ageComponents = (Calendar.current as NSCalendar).components(.year, from: dateOfBirth, to: now, options: .wrapComponents)
            let age = ageComponents.year

            cell.valueLabel.text = "\(age)"
        }
        catch {
        }
    }
    
    func configureCellWithBiologicalSex(_ cell: ProfileStaticTableViewCell) {
        // Set the default cell content.
        cell.titleLabel.text = NSLocalizedString("Gender", comment: "")
        cell.valueLabel.text = NSLocalizedString("-", comment: "")
        
        // Update the value label with the date of birth from the health store.
        guard let healthStore = healthStore else { return }
        
        do {
            let gender = try healthStore.biologicalSex()
            if (gender.biologicalSex.rawValue == 0) {
                cell.valueLabel.text = "Not Set"
            } else if (gender.biologicalSex.rawValue == 1) {
                cell.valueLabel.text = "Female"
            } else if (gender.biologicalSex.rawValue == 2) {
                cell.valueLabel.text = "Male"
            } else {
                cell.valueLabel.text = "Other"
            }
        }
        catch {
        }
    }
    
    func configureCellWithHeight(_ cell: ProfileStaticTableViewCell, valueForQuantityTypeIdentifier identifier: String) {
        // Set the default cell content.
        cell.titleLabel.text = NSLocalizedString("Height", comment: "")
        cell.valueLabel.text = NSLocalizedString("-", comment: "")
        
        // Update the value label with the date of birth from the health store.
        guard let healthStore = healthStore, let quantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier(rawValue: identifier)) else { return }
        healthStore.mostRecentQauntitySampleOfType(quantityType) { quantity, _ in
            guard let quantity = quantity else { return }
            
            // Update the cell on the main thread.
            OperationQueue.main.addOperation() {
                guard let indexPath = self.indexPathForObjectTypeIdentifier(identifier) else { return }
                guard let cell = self.tableView.cellForRow(at: indexPath) as? ProfileStaticTableViewCell else { return }
                let feet = quantity.doubleValue(for: HKUnit.foot())
                let inches = (feet - floor(feet)) * 12
                
                cell.valueLabel.text = "\(Int(feet))' \(Int(inches))''"
            }
        }
            
    }
    
    // MARK: Convenience
    
    func indexPathForObjectTypeIdentifier(_ identifier: String) -> IndexPath? {
        for (index, objectType) in healthObjectTypes.enumerated() where objectType.identifier == identifier {
            return IndexPath(row: index, section: 0)
        }
        
        return nil
    }
}
