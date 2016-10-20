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
import CoreMotion

struct StudyTasks {
    
    internal enum Identifier {
        // Task with a form, where multiple items appear on one page.
        case formTask
        case formStep
        case formItem01
        case formItem02
        case formItem03
        
        // Survey task specific identifiers.
        case surveyKnowledgeStep
        case introStep
        case questionStep
        case summaryStep
        case countDownStep
        case completionStep
        
        // Task with a Boolean question.
        case booleanQuestionTask
        case booleanQuestionStep
        
        // Task with an example of date entry.
        case dateQuestionTask
        case dateQuestionStep
        
        // Task with an example of date and time entry.
        case dateTimeQuestionTask
        case dateTimeQuestionStep
        
        // Task with an image choice question.
        case imageChoiceQuestionTask
        case imageChoiceQuestionStep
        
        // Task with a location entry.
        case locationQuestionTask
        case locationQuestionStep
        
        // Task with examples of numeric questions.
        case numericQuestionTask
        case numericQuestionStep
        case numericNoUnitQuestionStep
        
        // Task with examples of questions with sliding scales.
        case scaleQuestionTask
        case discreteScaleQuestionStep
        case continuousScaleQuestionStep
        case discreteVerticalScaleQuestionStep
        case continuousVerticalScaleQuestionStep
        case textScaleQuestionStep
        case textVerticalScaleQuestionStep
        
        // Task with an example of free text entry.
        case textQuestionTask
        case textQuestionStep
        
        // Task with an example of a multiple choice question.
        case textChoiceQuestionTask
        case textChoiceQuestionStep
        
        // Task with an example of time of day entry.
        case timeOfDayQuestionTask
        case timeOfDayQuestionStep
        
        // Task with an example of time interval entry.
        case timeIntervalQuestionTask
        case timeIntervalQuestionStep
        
        // Task with a value picker.
        case valuePickerChoiceQuestionTask
        case valuePickerChoiceQuestionStep
        
        // Task with an example of validated text entry.
        case validatedTextQuestionTask
        case validatedTextQuestionStepEmail
        case validatedTextQuestionStepDomain
        
        // Image capture task specific identifiers.
        case imageCaptureTask
        case imageCaptureStep
        
        // Task with an example of waiting.
        case waitTask
        case waitStepDeterminate
        case waitStepIndeterminate
        
        // Eligibility task specific indentifiers.
        case eligibilityTask
        case eligibilityIntroStep
        case eligibilityFormStep
        case eligibilityFormItem01
        case eligibilityFormItem02
        case eligibilityFormItem03
        case eligibilityIneligibleStep
        case eligibilityEligibleStep
        
        // Consent task specific identifiers.
        case consentTask
        case visualConsentStep
        case consentSharingStep
        case consentReviewStep
        case consentDocumentParticipantSignature
        case consentDocumentInvestigatorSignature
        
        // Account creation task specific identifiers.
        case accountCreationTask
        case registrationStep
        case waitStep
        case verificationStep
        
        // Login task specific identifiers.
        case loginTask
        case loginStep
        case loginWaitStep
        
        // Passcode task specific identifiers.
        case passcodeTask
        case passcodeStep
        
        // Active tasks.
        case audioTask
        case fitnessTask
        case holePegTestTask
        case psatTask
        case reactionTime
        case shortWalkTask
        case spatialSpanMemoryTask
        case timedWalkTask
        case toneAudiometryTask
        case towerOfHanoi
        case twoFingerTappingIntervalTask
        case tiltTask
        case tiltTutorial
    }
    
    //KNOWLEDGE SURVEY!!!!!!!!!!!!!!!!!!
    static let KnowledgeSurveyTask: ORKOrderedTask = {
        var steps = [ORKStep]()
        
        // Instruction step
        let instructionStep = ORKInstructionStep(identifier: "IntroStep")
        instructionStep.title = "Scoliosis Knowledge Survey"
        instructionStep.text = "Please answer the following 6 questions to the best of your ability. It's okay to skip a question if you don't know the answer."
        
        steps += [instructionStep]
        
        // Definition question using text choice
        let definitionChoiceTitle = "What is scoliosis?"
        let definitionTextChoices = [
            ORKTextChoice(text: "Damage to any part of the spinal cord or nerves.", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "A sprain, strain, or tear to a muscle or ligament in the back.", value: 1 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "An abnormal lateral curvature of the spine.", value: 2 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Painful inflammation and stiffness of the back.", value: 3 as NSCoding & NSCopying & NSObjectProtocol)
        ]
        let definitionChoiceAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: definitionTextChoices)
        let definitionChoiceQuestionStep = ORKQuestionStep(identifier: "DefinitionChoiceQuestionStep", title: definitionChoiceTitle, answer: definitionChoiceAnswerFormat)
        
        steps += [definitionChoiceQuestionStep]
        
        // Quest question using text choice
        let multipleChoiceTitle = "What are the causes of scoliosis? Pick more than one if necessary."
        let textChoices = [
            ORKTextChoice(text: "Bone abnormalities present at birth.", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Bad posture.", value: 1 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Injury, previous major back surgery, or osteoporosis.", value: 2 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Inheritance.", value: 3 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Unknown.", value: 4 as NSCoding & NSCopying & NSObjectProtocol)
        ]
        let multipleChoiceAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .multipleChoice, textChoices: textChoices)
        let multipleChoiceQuestionStep = ORKQuestionStep(identifier: "TextChoiceQuestionStep", title: multipleChoiceTitle, answer: multipleChoiceAnswerFormat)
        
        steps += [multipleChoiceQuestionStep]
        
        // Cured question
        let curedAnswerFormat = ORKBooleanAnswerFormat()
        let curedQuestionStepTitle = "Can scoliosis be cured?"
        let curedQuestionStep = ORKQuestionStep(identifier: "CuredQuestionStep", title: curedQuestionStepTitle, answer: curedAnswerFormat)
        
        steps += [curedQuestionStep]
        
        // Length question
        let lengthQuestionStepTitle = "Is scoliosis a short term or long term condition?"
        let lengthTextChoices = [
            ORKTextChoice(text: "Short Term", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Long Term", value: 1 as NSCoding & NSCopying & NSObjectProtocol)
        ]
        let lengthAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: lengthTextChoices)
        let lengthQuestionStep = ORKQuestionStep(identifier: "LengthQuestionStep", title: lengthQuestionStepTitle, answer: lengthAnswerFormat)
        
        steps += [lengthQuestionStep]
        
        // Brace question
        let braceAnswerFormat = ORKBooleanAnswerFormat()
        let braceQuestionStepTitle = "Brace treatment is used for a child who is still growing to prevent progression of moderate spinal curves. Does bracing necessarily correct a spinal curve?"
        let braceQuestionStep = ORKQuestionStep(identifier: "BraceQuestionStep", title: braceQuestionStepTitle, answer: braceAnswerFormat)
        
        steps += [braceQuestionStep]
        
        // Degrees question
        let degreesAnswerFormat = ORKAnswerFormat.scale(withMaximumValue: 90, minimumValue: 10, defaultValue: 0, step: 10, vertical: false, maximumValueDescription: "Degrees", minimumValueDescription: " ")
        let degreesQuestionStepTitle = "A spinal curve of how many degrees is often recommended for surgery?"
        let degreesQuestionStep = ORKQuestionStep(identifier: "DegreesQuestionStep", title: degreesQuestionStepTitle, answer: degreesAnswerFormat)
        
        steps += [degreesQuestionStep]

        // Summary step
        let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
        summaryStep.title = "Thank you."
        summaryStep.text = "We appreciate your time."
        
        steps += [summaryStep]
        
        return ORKOrderedTask(identifier: "KnowledgeSurveyTask", steps: steps)
    }()
    
    //BACKGROUND SURVEY!!!!!!!!!!!!!!!!!!!
    static let BackgroundSurveyTask: ORKOrderedTask = {
        var steps = [ORKStep]()
        
        // Instruction step
        let instructionStep = ORKInstructionStep(identifier: "IntroStep")
        instructionStep.title = "Scoliosis Background Survey"
        instructionStep.text = "Please answer these questions to the best of your ability. It's okay to skip a question if you don't know the answer."
        
        steps += [instructionStep]
        
        // Have question
        let haveAnswerFormat = ORKBooleanAnswerFormat()
        let haveQuestionStepTitle = "Do you have scoliosis?"
        let haveQuestionStep = ORKQuestionStep(identifier: "HaveQuestionStep", title: haveQuestionStepTitle, answer: haveAnswerFormat)
        
        steps += [haveQuestionStep]
        
        // Age Question
        let ageAnswerFormat: ORKNumericAnswerFormat = ORKNumericAnswerFormat.integerAnswerFormat(withUnit: "years old")
        ageAnswerFormat.minimum = 2
        ageAnswerFormat.maximum = 90
        let ageQuestionStepTitle = "How old were you when you were diagnosed with scoliosis?"
        let ageQuestionStep = ORKQuestionStep(identifier: "AgeQuestionStep", title: ageQuestionStepTitle, answer: ageAnswerFormat)
        
        steps += [ageQuestionStep]
        
        // Type question using text choice
        let typeChoiceTitle = "Which type of scoliosis do you have?"
        let typetextChoices = [
            ORKTextChoice(text: "Idiopathic scoliosis", value: 0 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Congenital scoliosis", value: 1 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Neuromuscular scoliosis", value: 2 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Degenerative scoliosis", value: 3 as NSCoding & NSCopying & NSObjectProtocol),
            ORKTextChoice(text: "Not sure which type of scoliosis", value: 4 as NSCoding & NSCopying & NSObjectProtocol)
        ]
        let typeChoiceAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: typetextChoices)
        let typeChoiceQuestionStep = ORKQuestionStep(identifier: "TextChoiceQuestionStep", title: typeChoiceTitle, answer: typeChoiceAnswerFormat)
        
        steps += [typeChoiceQuestionStep]
        
        // Degrees question
        let degreesAnswerFormat = ORKAnswerFormat.scale(withMaximumValue: 90, minimumValue: 10, defaultValue: 0, step: 10, vertical: false, maximumValueDescription: "Degrees", minimumValueDescription: " ")
        let degreesQuestionStepTitle = "How many degrees is your spinal curve?"
        let degreesQuestionStep = ORKQuestionStep(identifier: "DegreesQuestionStep", title: degreesQuestionStepTitle, answer: degreesAnswerFormat)
        
        steps += [degreesQuestionStep]
        
        // Brace question
        let braceAnswerFormat = ORKBooleanAnswerFormat()
        let braceQuestionStepTitle = "Do you use a brace?"
        let braceQuestionStep = ORKQuestionStep(identifier: "BraceQuestionStep", title: braceQuestionStepTitle, answer: braceAnswerFormat)
        
        steps += [braceQuestionStep]
        
        // Else question using text input
        let elseAnswerFormat = ORKTextAnswerFormat(maximumLength: 500)
        elseAnswerFormat.multipleLines = true
        let elseQuestionStepTitle = "Anything else we should know?"
        let elseQuestionStep = ORKQuestionStep(identifier: "ElseQuestionStep", title: elseQuestionStepTitle, answer: elseAnswerFormat)
        
        steps += [elseQuestionStep]

        // Summary step
        let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
        summaryStep.title = "Thank you."
        summaryStep.text = "We appreciate your time."
        
        steps += [summaryStep]
        
        return ORKOrderedTask(identifier: "BackgroundSurveyTask", steps: steps)
    }()
    
    static var pictureTask: ORKTask {
        let instructionStep = ORKInstructionStep(identifier: String(describing: Identifier.introStep))
        instructionStep.title = NSLocalizedString("Take a Picture", comment: "")
        instructionStep.text = "Take off your shirt so that your spine is visible. Stand straight, with your arms at your sides, feet touching together, and head facing forward. Ask someone to take a picture of your back to determine angles of scoliosis."
        
        let back = UIImage(named: "back")!
        instructionStep.image = back
        
        let imageCaptureStep = ORKImageCaptureStep(identifier: String(describing: Identifier.imageCaptureStep))
        imageCaptureStep.isOptional = false
        imageCaptureStep.accessibilityInstructions = NSLocalizedString("Capture most of the back in the rectangle frame.", comment: "")
        imageCaptureStep.accessibilityHint = NSLocalizedString("Use the preview as guidance.", comment: "")
        imageCaptureStep.templateImage = UIImage(named: "rectangle")!
        imageCaptureStep.templateImageInsets = UIEdgeInsets(top: 0.1, left: 0.1, bottom: 0.1, right: 0.1)
        
        let completionStep = ORKCompletionStep(identifier: String(describing: Identifier.completionStep))
        completionStep.title = "Activity Complete"
        completionStep.text = "Your data will be analyzed and you will be notified when your results are ready."
        
        return ORKOrderedTask(identifier: String(describing: Identifier.imageCaptureTask), steps: [
            instructionStep,
            imageCaptureStep,
            completionStep
        ])
    }
    
    static var tiltTask: ORKTask {
        let countDownStep = ORKCountdownStep(identifier: String(describing: Identifier.countDownStep))
        
        let instructionStep = ORKInstructionStep(identifier: String(describing: Identifier.introStep))
        instructionStep.title = NSLocalizedString("Bend", comment: "")
        instructionStep.text = "Any imbalances in the rib cage could be a sign of scoliosis. This activity uses your iPhone's gyroscope to measure the rotational motion of your back."
        let bend = UIImage(named: "bend")!
        instructionStep.image = bend
        
        let tiltTutorial  = ORKInstructionStep(identifier: String(describing: Identifier.tiltTutorial))
        tiltTutorial.title = "Bend"
        tiltTutorial.text = "Take off your shirt so that your spine is visible. Now, bend forward, starting at the waist until the back comes in the horizontal plane, with the feet together, arms hanging and the knees in extension. Ask someone to place the iPhone horizontally on the middle of your back so that the phone's sides are perpendicular to your spine."
        
        let tiltStep = ORKTimedWalkStep(identifier: String(describing: Identifier.tiltTask))
        tiltStep.title = "Bend"
        tiltStep.text = "Measuring rotational motion in progress..."
        tiltStep.stepDuration = abs(15)
        tiltStep.distanceInMeters = 1
        tiltStep.shouldShowDefaultTimer = true
        tiltStep.shouldStartTimerAutomatically = true
        tiltStep.shouldVibrateOnStart = false
        tiltStep.shouldVibrateOnFinish = true
        tiltStep.shouldContinueOnFinish = true
        
        let completionStep = ORKCompletionStep(identifier: String(describing: Identifier.completionStep))
        completionStep.title = "Activity Complete"
        completionStep.text = "Your data will be analyzed and you will be notified when your results are ready."
        
        return ORKOrderedTask(identifier: String(describing: Identifier.imageCaptureTask), steps: [
            instructionStep,
            tiltTutorial,
            countDownStep,
            tiltStep,
            completionStep
        ])
    }
    
}
