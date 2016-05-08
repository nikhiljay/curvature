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
        case FormTask
        case FormStep
        case FormItem01
        case FormItem02
        case FormItem03
        
        // Survey task specific identifiers.
        case SurveyKnowledgeStep
        case IntroStep
        case QuestionStep
        case SummaryStep
        case CountDownStep
        case CompletionStep
        
        // Task with a Boolean question.
        case BooleanQuestionTask
        case BooleanQuestionStep
        
        // Task with an example of date entry.
        case DateQuestionTask
        case DateQuestionStep
        
        // Task with an example of date and time entry.
        case DateTimeQuestionTask
        case DateTimeQuestionStep
        
        // Task with an image choice question.
        case ImageChoiceQuestionTask
        case ImageChoiceQuestionStep
        
        // Task with a location entry.
        case LocationQuestionTask
        case LocationQuestionStep
        
        // Task with examples of numeric questions.
        case NumericQuestionTask
        case NumericQuestionStep
        case NumericNoUnitQuestionStep
        
        // Task with examples of questions with sliding scales.
        case ScaleQuestionTask
        case DiscreteScaleQuestionStep
        case ContinuousScaleQuestionStep
        case DiscreteVerticalScaleQuestionStep
        case ContinuousVerticalScaleQuestionStep
        case TextScaleQuestionStep
        case TextVerticalScaleQuestionStep
        
        // Task with an example of free text entry.
        case TextQuestionTask
        case TextQuestionStep
        
        // Task with an example of a multiple choice question.
        case TextChoiceQuestionTask
        case TextChoiceQuestionStep
        
        // Task with an example of time of day entry.
        case TimeOfDayQuestionTask
        case TimeOfDayQuestionStep
        
        // Task with an example of time interval entry.
        case TimeIntervalQuestionTask
        case TimeIntervalQuestionStep
        
        // Task with a value picker.
        case ValuePickerChoiceQuestionTask
        case ValuePickerChoiceQuestionStep
        
        // Task with an example of validated text entry.
        case ValidatedTextQuestionTask
        case ValidatedTextQuestionStepEmail
        case ValidatedTextQuestionStepDomain
        
        // Image capture task specific identifiers.
        case ImageCaptureTask
        case ImageCaptureStep
        
        // Task with an example of waiting.
        case WaitTask
        case WaitStepDeterminate
        case WaitStepIndeterminate
        
        // Eligibility task specific indentifiers.
        case EligibilityTask
        case EligibilityIntroStep
        case EligibilityFormStep
        case EligibilityFormItem01
        case EligibilityFormItem02
        case EligibilityFormItem03
        case EligibilityIneligibleStep
        case EligibilityEligibleStep
        
        // Consent task specific identifiers.
        case ConsentTask
        case VisualConsentStep
        case ConsentSharingStep
        case ConsentReviewStep
        case ConsentDocumentParticipantSignature
        case ConsentDocumentInvestigatorSignature
        
        // Account creation task specific identifiers.
        case AccountCreationTask
        case RegistrationStep
        case WaitStep
        case VerificationStep
        
        // Login task specific identifiers.
        case LoginTask
        case LoginStep
        case LoginWaitStep
        
        // Passcode task specific identifiers.
        case PasscodeTask
        case PasscodeStep
        
        // Active tasks.
        case AudioTask
        case FitnessTask
        case HolePegTestTask
        case PSATTask
        case ReactionTime
        case ShortWalkTask
        case SpatialSpanMemoryTask
        case TimedWalkTask
        case ToneAudiometryTask
        case TowerOfHanoi
        case TwoFingerTappingIntervalTask
        case TiltTask
        case TiltTutorial
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
            ORKTextChoice(text: "Damage to any part of the spinal cord or nerves.", value: 0),
            ORKTextChoice(text: "A sprain, strain, or tear to a muscle or ligament in the back.", value: 1),
            ORKTextChoice(text: "An abnormal lateral curvature of the spine.", value: 2),
            ORKTextChoice(text: "Painful inflammation and stiffness of the back.", value: 3)
        ]
        let definitionChoiceAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: definitionTextChoices)
        let definitionChoiceQuestionStep = ORKQuestionStep(identifier: "DefinitionChoiceQuestionStep", title: definitionChoiceTitle, answer: definitionChoiceAnswerFormat)
        
        steps += [definitionChoiceQuestionStep]
        
        // Quest question using text choice
        let multipleChoiceTitle = "What are the causes of scoliosis? Pick more than one if necessary."
        let textChoices = [
            ORKTextChoice(text: "Bone abnormalities present at birth.", value: 0),
            ORKTextChoice(text: "Bad posture.", value: 1),
            ORKTextChoice(text: "Injury, previous major back surgery, or osteoporosis.", value: 2),
            ORKTextChoice(text: "Inheritance.", value: 3),
            ORKTextChoice(text: "Unknown.", value: 4)
        ]
        let multipleChoiceAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormatWithStyle(.MultipleChoice, textChoices: textChoices)
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
            ORKTextChoice(text: "Short Term", value: 0),
            ORKTextChoice(text: "Long Term", value: 1)
        ]
        let lengthAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: lengthTextChoices)
        let lengthQuestionStep = ORKQuestionStep(identifier: "LengthQuestionStep", title: lengthQuestionStepTitle, answer: lengthAnswerFormat)
        
        steps += [lengthQuestionStep]
        
        // Brace question
        let braceAnswerFormat = ORKBooleanAnswerFormat()
        let braceQuestionStepTitle = "Brace treatment is used for a child who is still growing to prevent progression of moderate spinal curves. Does bracing necessarily correct a spinal curve?"
        let braceQuestionStep = ORKQuestionStep(identifier: "BraceQuestionStep", title: braceQuestionStepTitle, answer: braceAnswerFormat)
        
        steps += [braceQuestionStep]
        
        // Degrees question
        let degreesAnswerFormat = ORKAnswerFormat.scaleAnswerFormatWithMaximumValue(90, minimumValue: 10, defaultValue: 0, step: 10, vertical: false, maximumValueDescription: "Degrees", minimumValueDescription: " ")
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
        let ageAnswerFormat: ORKNumericAnswerFormat = ORKNumericAnswerFormat.integerAnswerFormatWithUnit("years old")
        ageAnswerFormat.minimum = 2
        ageAnswerFormat.maximum = 90
        let ageQuestionStepTitle = "How old were you when you were diagnosed with scoliosis?"
        let ageQuestionStep = ORKQuestionStep(identifier: "AgeQuestionStep", title: ageQuestionStepTitle, answer: ageAnswerFormat)
        
        steps += [ageQuestionStep]
        
        // Type question using text choice
        let typeChoiceTitle = "Which type of scoliosis do you have?"
        let typetextChoices = [
            ORKTextChoice(text: "Idiopathic scoliosis", value: 0),
            ORKTextChoice(text: "Congenital scoliosis", value: 1),
            ORKTextChoice(text: "Neuromuscular scoliosis", value: 2),
            ORKTextChoice(text: "Degenerative scoliosis", value: 3),
            ORKTextChoice(text: "Not sure which type of scoliosis", value: 4)
        ]
        let typeChoiceAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: typetextChoices)
        let typeChoiceQuestionStep = ORKQuestionStep(identifier: "TextChoiceQuestionStep", title: typeChoiceTitle, answer: typeChoiceAnswerFormat)
        
        steps += [typeChoiceQuestionStep]
        
        // Degrees question
        let degreesAnswerFormat = ORKAnswerFormat.scaleAnswerFormatWithMaximumValue(90, minimumValue: 10, defaultValue: 0, step: 10, vertical: false, maximumValueDescription: "Degrees", minimumValueDescription: " ")
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
        let instructionStep = ORKInstructionStep(identifier: String(Identifier.IntroStep))
        instructionStep.title = NSLocalizedString("Take a Picture", comment: "")
        instructionStep.text = "Take off your shirt so that your spine is visible. Stand straight, with your arms at your sides, feet touching together, and head facing forward. Ask someone to take a picture of your back to determine angles of scoliosis."
        
        let back = UIImage(named: "back")!
        instructionStep.image = back
        
        let imageCaptureStep = ORKImageCaptureStep(identifier: String(Identifier.ImageCaptureStep))
        imageCaptureStep.optional = false
        imageCaptureStep.accessibilityInstructions = NSLocalizedString("Capture most of the back in the rectangle frame.", comment: "")
        imageCaptureStep.accessibilityHint = NSLocalizedString("Use the preview as guidance.", comment: "")
        imageCaptureStep.templateImage = UIImage(named: "rectangle")!
        imageCaptureStep.templateImageInsets = UIEdgeInsets(top: 0.1, left: 0.1, bottom: 0.1, right: 0.1)
        
        let completionStep = ORKCompletionStep(identifier: String(Identifier.CompletionStep))
        completionStep.title = "Activity Complete"
        completionStep.text = "Your data will be analyzed and you will be notified when your results are ready."
        
        return ORKOrderedTask(identifier: String(Identifier.ImageCaptureTask), steps: [
            instructionStep,
            imageCaptureStep,
            completionStep
        ])
    }
    
    static var tiltTask: ORKTask {
        let countDownStep = ORKCountdownStep(identifier: String(Identifier.CountDownStep))
        
        let instructionStep = ORKInstructionStep(identifier: String(Identifier.IntroStep))
        instructionStep.title = NSLocalizedString("Bend", comment: "")
        instructionStep.text = "Any imbalances in the rib cage could be a sign of scoliosis. This activity uses your iPhone's gyroscope to measure the rotational motion of your back."
        let bend = UIImage(named: "bend")!
        instructionStep.image = bend
        
        let tiltTutorial  = ORKInstructionStep(identifier: String(Identifier.TiltTutorial))
        tiltTutorial.title = "Bend"
        tiltTutorial.text = "Take off your shirt so that your spine is visible. Now, bend forward, starting at the waist until the back comes in the horizontal plane, with the feet together, arms hanging and the knees in extension. Ask someone to place the iPhone horizontally on the middle of your back so that the phone's sides are perpendicular to your spine."
        
        let tiltStep = ORKTimedWalkStep(identifier: String(Identifier.TiltTask))
        tiltStep.title = "Bend"
        tiltStep.text = "Measuring rotational motion in progress..."
        tiltStep.stepDuration = NSTimeInterval.abs(15)
        tiltStep.distanceInMeters = 1
        tiltStep.shouldShowDefaultTimer = true
        tiltStep.shouldStartTimerAutomatically = true
        tiltStep.shouldVibrateOnStart = false
        tiltStep.shouldVibrateOnFinish = true
        tiltStep.shouldContinueOnFinish = true
        
        let completionStep = ORKCompletionStep(identifier: String(Identifier.CompletionStep))
        completionStep.title = "Activity Complete"
        completionStep.text = "Your data will be analyzed and you will be notified when your results are ready."
        
        return ORKOrderedTask(identifier: String(Identifier.ImageCaptureTask), steps: [
            instructionStep,
            tiltTutorial,
            countDownStep,
            tiltStep,
            completionStep
        ])
    }
    
}
