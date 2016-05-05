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

struct StudyTasks {
    
    static let tappingTask: ORKOrderedTask = {
        let intendedUseDescription = "Finger tapping is a universal way to communicate."
        
        return ORKOrderedTask.twoFingerTappingIntervalTaskWithIdentifier("TappingTask", intendedUseDescription: intendedUseDescription, duration: 10, options: ORKPredefinedTaskOption.None)
    }()
    
    static let pictureTask: ORKOrderedTask = {
        let intendedUseDescription = "A picture of the back can determine the angles of scoliosis."
        
        let step = ORKStep(identifier: "hi")
        let task = ORKOrderedTask(identifier: "test", steps: [step])
        
        return task
    }()
    
    private enum Identifier {
        // Task with a form, where multiple items appear on one page.
        case FormTask
        case FormStep
        case FormItem01
        case FormItem02
        case FormItem03
        
        // Survey task specific identifiers.
        case SurveyTask
        case IntroStep
        case QuestionStep
        case SummaryStep
        
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
    }
    
    static var imageCaptureTask: ORKTask {
        // Create the intro step.
        let instructionStep = ORKInstructionStep(identifier: String(Identifier.IntroStep))
        
        instructionStep.title = NSLocalizedString("Take a Picture", comment: "")
        
        instructionStep.text = "Someone else should take a picture of your back for determining angles of scoliosis."
        
        let back = UIImage(named: "back")!
        instructionStep.image = back
        
        let imageCaptureStep = ORKImageCaptureStep(identifier: String(Identifier.ImageCaptureStep))
        imageCaptureStep.optional = false
        imageCaptureStep.accessibilityInstructions = NSLocalizedString("Capture most of the back in the rectangle frame.", comment: "")
        imageCaptureStep.accessibilityHint = NSLocalizedString("Use the preview as guidance.", comment: "")
        
        imageCaptureStep.templateImage = UIImage(named: "rectangle")!
        
        imageCaptureStep.templateImageInsets = UIEdgeInsets(top: 0.1, left: 0.1, bottom: 0.1, right: 0.1)
        
        return ORKOrderedTask(identifier: String(Identifier.ImageCaptureTask), steps: [
            instructionStep,
            imageCaptureStep
        ])
    }
    
    static let tiltTask: ORKOrderedTask = {
        let intendedUseDescription = "Any imbalances in the rib cage could be a sign of scoliosis."
        
        return ORKOrderedTask.twoFingerTappingIntervalTaskWithIdentifier("TappingTask", intendedUseDescription: intendedUseDescription, duration: 10, options: ORKPredefinedTaskOption.None)
    }()
    
    static let surveyTask: ORKOrderedTask = {
        var steps = [ORKStep]()
        
        // Instruction step
        let instructionStep = ORKInstructionStep(identifier: "IntroStep")
        instructionStep.title = "Knoweledge of the Universe Survey"
        instructionStep.text = "Please answer these 6 questions to the best of your ability. It's okay to skip a question if you don't know the answer."
        
        steps += [instructionStep]
        
        // Quest question using text choice
        let questQuestionStepTitle = "Which of the following is not a planet?"
        let textChoices = [
            ORKTextChoice(text: "Saturn", value: 0),
            ORKTextChoice(text: "Uranus", value: 1),
            ORKTextChoice(text: "Pluto", value: 2),
            ORKTextChoice(text: "Mars", value: 3)
        ]
        let questAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: textChoices)
        let questQuestionStep = ORKQuestionStep(identifier: "TextChoiceQuestionStep", title: questQuestionStepTitle, answer: questAnswerFormat)
        
        steps += [questQuestionStep]
        
        // Name question using text input
        let nameAnswerFormat = ORKTextAnswerFormat(maximumLength: 25)
        nameAnswerFormat.multipleLines = false
        let nameQuestionStepTitle = "What do you think the next comet that's discovered should be named?"
        let nameQuestionStep = ORKQuestionStep(identifier: "NameQuestionStep", title: nameQuestionStepTitle, answer: nameAnswerFormat)
        
        steps += [nameQuestionStep]
        
        let shapeQuestionStepTitle = "Which shape is the closest to the shape of Messier object 101?"
        let shapeTuples = [
            (UIImage(named: "square")!, "Square"),
            (UIImage(named: "pinwheel")!, "Pinwheel"),
            (UIImage(named: "pentagon")!, "Pentagon"),
            (UIImage(named: "circle")!, "Circle")
        ]
        let imageChoices : [ORKImageChoice] = shapeTuples.map {
            return ORKImageChoice(normalImage: $0.0, selectedImage: nil, text: $0.1, value: $0.1)
        }
        let shapeAnswerFormat: ORKImageChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormatWithImageChoices(imageChoices)
        let shapeQuestionStep = ORKQuestionStep(identifier: "ImageChoiceQuestionStep", title: shapeQuestionStepTitle, answer: shapeAnswerFormat)
        
        steps += [shapeQuestionStep]
        
        // Date question
        let today = NSDate()
        let dateAnswerFormat =  ORKAnswerFormat.dateAnswerFormatWithDefaultDate(nil, minimumDate: today, maximumDate: nil, calendar: nil)
        let dateQuestionStepTitle = "When is the next solar eclipse?"
        let dateQuestionStep = ORKQuestionStep(identifier: "DateQuestionStep", title: dateQuestionStepTitle, answer: dateAnswerFormat)
        
        steps += [dateQuestionStep]
        
        // Boolean question
        let booleanAnswerFormat = ORKBooleanAnswerFormat()
        let booleanQuestionStepTitle = "Is Venus larger than Saturn?"
        let booleanQuestionStep = ORKQuestionStep(identifier: "BooleanQuestionStep", title: booleanQuestionStepTitle, answer: booleanAnswerFormat)
        
        steps += [booleanQuestionStep]
        
        // Continuous question
        let continuousAnswerFormat = ORKAnswerFormat.scaleAnswerFormatWithMaximumValue(150, minimumValue: 30, defaultValue: 20, step: 10, vertical: false, maximumValueDescription: "Objects", minimumValueDescription: " ")
        let continuousQuestionStepTitle = "How many objects are in Messier's catalog?"
        let continuousQuestionStep = ORKQuestionStep(identifier: "ContinuousQuestionStep", title: continuousQuestionStepTitle, answer: continuousAnswerFormat)
        
        steps += [continuousQuestionStep]
        
        // Summary step
        
        let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
        summaryStep.title = "Thank you."
        summaryStep.text = "We appreciate your time."
        
        steps += [summaryStep]
        
        return ORKOrderedTask(identifier: "SurveyTask", steps: steps)
    }()
}
