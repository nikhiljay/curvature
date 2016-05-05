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

import ResearchKit

class ConsentDocument: ORKConsentDocument {
    // MARK: Properties
    
    let ipsum = [
        "This study gathers and analyses data to check whether you have or could potentially have scoliosis. OTHER INFORMATION GOES HERE.",
        "This study will gather sensor data from your iPhone. OTHER INFORMATION GOES HERE.",
        "Your data will not be stored online nor shared with others. OTHER INFORMATION GOES HERE.",
        "We will need to use the gathered data for research purposes. OTHER INFORMATION GOES HERE.",
        "Your participation in this study will average 10 minutes each month for 2 years. OTHER INFORMATION GOES HERE.",
        "You will answer some questions about how scoliosis is affecting you. These questions should only take a couple mintues. OTHER INFORMATION GOES HERE.",
        "Learning more about scoliosis and monitoring your health can help you be healthier. It is possible that neither you nor others may benefit from taking part in this study.",
        "At anytime, you can withdraw and discontinue participation from this study. OTHER INFORMATION GOES HERE."
    ]
    
    // MARK: Initialization
    
    override init() {
        super.init()
        
        title = NSLocalizedString("Research Health Study Consent Form", comment: "")
        
        let sectionTypes: [ORKConsentSectionType] = [
            .Overview,
            .DataGathering,
            .Privacy,
            .DataUse,
            .TimeCommitment,
            .StudySurvey,
            .StudyTasks,
            .Withdrawing
        ]
        
        sections = zip(sectionTypes, ipsum).map { sectionType, ipsum in
            let section = ORKConsentSection(type: sectionType)
            
            let localizedIpsum = NSLocalizedString(ipsum, comment: "")
            let localizedSummary = localizedIpsum.componentsSeparatedByString(".")[0] + "."
            
            section.summary = localizedSummary
            section.content = localizedIpsum
            
            return section
        }

        let signature = ORKConsentSignature(forPersonWithTitle: nil, dateFormatString: nil, identifier: "ConsentDocumentParticipantSignature")
        addSignature(signature)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ORKConsentSectionType: CustomStringConvertible {

    public var description: String {
        switch self {
            case .Overview:
                return "Overview"
                
            case .DataGathering:
                return "DataGathering"
                
            case .Privacy:
                return "Privacy"
                
            case .DataUse:
                return "DataUse"
                
            case .TimeCommitment:
                return "TimeCommitment"
                
            case .StudySurvey:
                return "StudySurvey"
                
            case .StudyTasks:
                return "StudyTasks"
                
            case .Withdrawing:
                return "Withdrawing"
                
            case .Custom:
                return "Custom"
                
            case .OnlyInDocument:
                return "OnlyInDocument"
        }
    }
}