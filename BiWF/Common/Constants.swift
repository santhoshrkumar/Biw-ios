//
//  Constants.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 20/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import UIKit

enum DateFormat {
    /// This will contain the date format used in this app
    static let MMMMddyyyy = "MMMM dd, yyyy"
}

/// Define static constants used in the app here as static let variables
enum Constants {
    
    enum Common {
        //Images
        static let backButtonImageName = "back"
        //BiWF service Number
        static let biwfServiceNumber = "833-250-6306"
        static let phoneNumberFormat = "(###) ###-###"
        static let phonePesonalNumberFormat = "###-###-###"
        static let replacmentCharacter: Character = "#"
        //Bar button title
        static let cancel = "cancel".localized
        static let done = "done".localized.uppercased()
        static let clear = "Clear"
        static let next = "next".localized.uppercased()
        //Currency
        static let currency = "currency".localized
        //Loading & Error
        static let loading = "loading".localized
        static let updating = "updating".localized
        static let removing = "removing".localized
        static let restoring = "restoring".localized
        static let cancelling = "cancelling".localized
        static let errorLoadingInformation = "errorLoadingInformation".localized
        static let tapToRetry = "tapToRetry".localized
        static let discardChangesAndClose = "discardChangesAndClose".localized
        static let errorSavingChanges = "errorSavingChanges".localized
        static let anErrorOccurred = "anErrorOccurred".localized
        static let pleaseTryAgain = "pleaseTryAgain".localized
        static let fieldRequired = "fieldRequired".localized
        //Alert
        static let cancelButtonTitle = "cancelButtonTitle".localized
        static let remove = "remove".localized
        static let restore = "restore".localized
        static let ok = "OK".localized
        static let wantToSaveChanges = "wantToSaveChanges".localized
        static let discard = "discard".localized
        static let errorDisabling = "errorDisabling".localized
        static let pleaseTryAgainLater = "pleaseTryAgainLater".localized
        static let save = "save".localized
        
        //Units
        static let mb = "MB".localized
        static let gb = "GB".localized
        static let tb = "TB".localized
        
        static let networkErrorOccurred = "networkErrorOccurred".localized
        static let unknownErrorOccurred = "unknownErrorOccurred".localized
        static let retry = "retry".localized
        static let restartComplete = "restartComplete".localized
        static let restartCompleteMessage = "restartCompleteMessage".localized
        static let isModemRebootingDefualtsKey = "isRebooting"
        static let modemRebootingSucessStatusCode = 1000
        static let networkResponseSucessStatusCode = 1000
        static let modemStatusDispatchTime = 45
        static let modemSubscribeDispatchTime = 5
        //Userdefaults keys
        static let accountID = "accountID"
        static let email = "email"
        static let userID = "userID"
        static let assiaID = "assiaID"
        static let lineID = "lineID"
        static let orgID = "orgID"
        static let phone = "phone"
        static let billingState = "billingState"
        static let isCloseServiceCompleteCard = "isCloseServiceCompleteCard"
        static let isCloseAppointmentNotification = "isCloseAppointmentNotification"
        static let closeNotificationState = "closeNotificationState"
        static let cancelAppointmentId = "cancelAppointmentId"
        //KeychainIdentifier
        static let tokenIdentifier = "accessToken"
        static let specialCharacterValidation = "specialCharacterValidation".localized
        static let appLaunchedAfterDelete = "appLaunched"
        //Network delay timer
        static let networkApiDelay = 90.0
    }
    
    enum IndicatorView {
        //Dimension
        static let cornerRadius: CGFloat = 16.0
        //View tag
        static let viewTag = 1002
        //Alert text
        static let disablingWiFiNetwork = "disablingWiFiNetwork".localized
        static let enablingWiFiNetwork = "enablingWiFiNetwork".localized
        static let disableNetworkAlertMessage = "disableNetworkAlertMessage".localized
    }
    
    enum TextField {
        //Dimension
        static let buttonWidth: CGFloat = 27
        static let buttonHeight: CGFloat = 22
        static let leftViewLeftInset: CGFloat = 14
        static let topInset: CGFloat = 10
        static let height: CGFloat = 41
        static let leftViewWidth: CGFloat = 37
        static let rightViewWidth: CGFloat = 37
        //String
        static let optional = "optional".localized
    }
    
    /// Constants related to FAQTopics
    enum FAQTopics {
        //Strings
        static let helpfulVideos = "helpfulVideos".localized
        static let frequentlyAskedQuestions = "frequentlyAskedQuestions".localized
        static let liveChat = "LiveChat".localized
        static let scheduledCall = "ScheduleCallback".localized
        static let contactUs = "ContactUs".localized
        static let done = "done".localized.uppercased()
        static let cantFindAnswer = "cantFindAnswer".localized
        //Dimensions
        static let expandedCellEstimatedHeight: CGFloat = 60
        static let cellEstimatedHeight: CGFloat = 100
        static let faqHeaderViewCellHeight: CGFloat = 65
        static let cantFindAnswerHeaderCellHeight: CGFloat = 80
        
        //Images
        static let collapseCellArrowImage = "collapse-small"
        static let expandCellArrowImage = "expand"
    }
    /// Constants related to Cancel Susbcription
    enum CancelSubscription {
        //Strings
        static let optional = "optional".localized
        static let cancelSubscription = "CancelSubscription".localized
        static let sorryToSeeYouGo = "sorryToSeeYouGo".localized
        static let cancellationDate = "cancellationDate".localized
        static let cancellationReason = "cancellationReason".localized
        static let moreInfo = "moreInfo".localized
        static let specifyCancellationReason = "specifyCancellationReason".localized
        static let rateExperience = "rateExperience".localized
        static let comments = "comments".localized
        static let tellMoreAboutExperience = "tellMoreAboutExperience".localized
        static let submit = "submit".localized
        static let select = "select".localized
        static let sureWantToCancel = "sureWantToCancel".localized
        static let serviceEndOn = "serviceEndOn".localized
        static let noAccessForService = "noAccessForService".localized
        static let keepService = "keepService".localized
        static let cancelService = "cancelService".localized
        static let fieldRequired = "fieldRequired".localized
        //Images
        static let calendarImageName = "calendar"
        static let dropDownImageName = "expand"
        //Max cancellation date
        static let maxCancellationDate = "December 31, 2120"
        //dimension
        static let cancellationReasonViewHeight: CGFloat = 113.5
        static let cancellationReasonTextviewHeight: CGFloat = 89
        static let errorLabelTopSpace: CGFloat = 8
        static let specifyReasonStackViewTopSpace: CGFloat = 8
        static let stackSubviewsSpacing: CGFloat = 4
        
        enum CancellationReason {
            static let reliabilityOrSpeed = "reliabilityOrSpeed".localized
            static let priceOrBilling = "priceOrBilling".localized
            static let installation = "installation".localized
            static let customerSupport = "customerSupport".localized
            static let moving = "moving".localized
            static let other = "other".localized
        }
    }
    
    /// Constants related to Rating view
    enum Rating {
        //Images
        static let filledStarImageName = "filledStar"
        static let emptyStarImageName = "emptyStar"
        static let maxRating: Int = 5
    }
    
    /// Constants related to Connected Devices view
    enum ConnectedDevices {
        //Strings
        static let connectedDevicesText = "connectedDevices".localized
        static let tapToViewText = "tapToView".localized
        static let wantToRestore = "wantToRestore".localized
        static let youCanRemove = "youCanRemove".localized
    }
    
    enum DashboardTableView {
        static let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        static let estimatedRowHeight: CGFloat = 166
        /// Cell heights
        static let speedTestCellHeight: CGFloat = 200
        //TODO: For now hidding notification functionality as will be implementated in future.
        //static let notifcationsCellHeight: CGFloat = 96
        static let connectedDevicesCellHeight: CGFloat = 55
        static let networkCellHeight: CGFloat = 48
        static let networkInfoCardCellHeight: CGFloat = 455
        
        /// Section header heights
        static let notificationsHeaderHeight: CGFloat = 16
        static let connectedDevicesHeaderHeight: CGFloat = 14
        static let networkHeaderHeight: CGFloat = 16
        static let serviceAppointmentHeaderHeight: CGFloat = 14
        
    }
    
    enum PersonalInformation {
        //Strings
        static let personalInformation = "personalInformation".localized
        static let loginInformation = "loginInformation".localized
        static let requiredFields = "requiredFields".localized
        static let emailAddress = "emailAddress".localized
        static let password = "password".localized
        static let confirmPassword = "confirmPassword".localized
        static let passwordDonotMatch = "passwordDonotMatch".localized
        static let phoneNumber = "phoneNumber".localized
        static let mobileNumber = "mobileNumber".localized
        static let tempPassword = "123456"
        //Image names
        static let question = "question"
        static let offCopy = "offCopy"
        static let onCopy = "onCopy"
        //Dimension
        static let rightViewButtonWidthHeight: CGFloat = 20
        static let rightViewButtonLeftInset: CGFloat = -16
        //Custom alert view
        static let title = "title".localized
        static let message = "message".localized
        static let detail = "detail".localized
        static let buttonText = "ok".localized
        static let errorOccured = "errorOccurred".localized
        static let phoneNumberRange = 67
        static let invalidPhoneNumberLength = "invalidPhoneNumberLength".localized
        static let validPhoneNumberLength : Int = 10
    }
    
    /// Constants related to Schedule callback
    enum ScheduleCallback {
        //Strings
        static let scheduleCallback = "scheduleCallback".localized
        static let justLetUsKnow = "justLetUsKnow".localized
        static let knowMoreAboutInternet = "knowMoreAboutInternet".localized
        static let troubleSigningUp = "troubleSigningUp".localized
        static let cannotSignIn = "cannotSignIn".localized
        static let questionAboutAccount = "questionAboutAccount".localized
        static let somethingNotListed = "somethingNotListed".localized
        static let callUsNow = "callUsNow".localized
        
        /// Section header heights
        static let callUsNowHeaderHeight: CGFloat = 64
    }
    
    /// Constants related to Additional info
    enum AdditionalInfo {
        //Strings
        static let additionalInfo = "additionalInfo".localized
        static let moreInfo = "moreInfo".localized
        static let additionalInfoPlaceholder = "additionalInfoPlaceholder".localized
        static let moreInfoNextButton = "moreInfoNextButton".localized
        static let additionalInfoTextLenght : Int = 255
    }
    
    enum ContactInfo {
        //Strings
        static let contactInfo = "contactInfo".localized
        static let contactText = "contactText".localized
        static let defaultNumber = "defaultNumber".localized
        static let mobileText = "mobileText".localized
        static let mobileNumberplaceholder = "000-000-0000"
        static let errorMessgae = "errorMessage".localized
        static let maxPhoneLimit = 10
    }
    
    /// Constants related to Additional info
    enum SelectTimeScheduleCallback {
        //Strings
        static let selectTime = "selectTime".localized
        static let whenUsToCall = "whenUsToCall".localized
        static let nextAvailableTime = "nextAvailableTime".localized
        static let availabelTimeSubHeader = "availabelTimeSubHeader".localized
        static let pickSpecificTime = "pickSpecificTime".localized
        static let date = "date".localized
        static let time = "time".localized
        static let callMe = "callMe".localized
    }
    
    enum Networking {
        //Account
        static let newPassword = "NewPassword"
        static let message = "message"
        static let firstName = "FirstName__c"
        static let cellPhoneOptIn = "Cell_Phone_Opt_In__c"
        static let marketingEmailOptIn = "Email_Opt_In__c"
        static let marketingCallOptIn = "Marketing_Opt_In__c"
        static let mobileNumber = "MobilePhone"
        static let errorOccurred = "Error occurred"
        static let successfullyUpdated = "Successfully updated"
        
        //Subscription
        static let contactID = "ContactId"
        static let caseKey = "Case_Type__c"
        static let origin = "Origin"
        static let cancelReason = "Cancellation_Reason__c"
        static let cancelComment = "CancelReason_Comments__c"
        static let notes = "Notes__c"
        static let experience = "Experience__c"
        static let cancellationDate = "Cancellation_Date_Holder__c"
        static let recordTypeID = "RecordTypeId"
        static let caseType = "Deactivation"
        static let originType = "Web"
        
        //Network API
        static let forcePing = "forcePing"
        static let mobile = "mobile"
        
        //Appointment
        static let serviceAppointmentID = "ServiceAppointmentId"
        static let arrivalWindowStartTime = "ArrivalWindowStartTime"
        static let arrivalWindowEndTime = "ArrivalWindowEndTime"
        static let appointmentNumber = "ServiceAppointmentNumber"
        static let appointmentStatus = "Status"
        
        //MacAddress Mapping
        static let serialNumber = "serialNumber"
        static let macAddress = "mac_address"
        static let deviceId = "deviceId"
        static let blocked = "blocked"
        static let deviceType = "deviceType"
        static let deviceNickName = "name"
        
        //Support schedule callback
        static let userid = "UserId"
        static let phone = "Phone"
        static let asap = "ASAP"
        static let customerCareOption = "CustomerCareOption"
        static let handleOption = "HandleOption"
        static let callbackTime = "CallbackTime"
        static let callbackReason = "CallbackReason"
    }
    
    enum Biometric {
        static let goToSettingsButtonTitle = "goToSettingsButtonTitle".localized
        static let alertTitleError = "alertTitleError".localized
        static let alertTitleSucess = "alertTitleSucess".localized
        static let faceIdUnlockDevice = "faceIdUnlockDevice".localized
        static let faceIdUnlocking = "faceIdUnlocking".localized
        static let touchIdUnlocking = "touchIdUnlocking".localized
        static let noBiometricSupport = "noBiometricSupport".localized
        static let failedNotValidCredentials = "failedNotValidCredentials".localized
        static let authCancelledByApp  = "authCancelledByApp".localized
        static let invalidContext = "invalidContext".localized
        static let notInteractive = "notInteractive".localized
        static let passcodeNotSet = "passcodeNotSet".localized
        static let authenticationCancelledBySystem = "authenticationCancelledBySystem".localized
        static let userCancelled = "userCancelled".localized
        static let userChoosedFallback = "userChoosedFallback".localized
        static let deviceNotSupportedBiometric = "deviceNotSupportedBiometric".localized
        static let userLockedOut = "userLockedOut".localized
        static let notEnrolledBiometric = "notEnrolledBiometric".localized
        static let unknownError = "unknownError".localized
        //User Defaults keys
        static let biometricEnabled = "biometricEnabled"
        static let shouldShowWelcomePopup = "shouldShowWelcomePopup"
        //Welcome alert strings
        static let welcomeAlertTitle = "welcomeAlertTitle".localized
        static let welcomeAlertMessageFaceID = "welcomeAlertMessageFaceID".localized
        static let welcomeAlertMessageTouchID = "welcomeAlertMessageTouchID".localized
        static let welcomeRightButtonTitle = "welcomeRightButtonTitle".localized
    }
    
    enum PreferenceAndSettings {
        static let settingsPreferenceHeader = "settingsPreferenceHeader".localized
        static let loginSettingsHeader = "loginSettingsHeader".localized
        static let communicationPreferenceHeader = "communicationPreferenceHeader".localized
        static let faceIDText = "faceID".localized
        static let serviceCallText = "serviceCall".localized
        static let serviceCallDescriptionText = "serviceCallDescription".localized
        static let marketingEmailText = "marketingEmail".localized
        static let marketingEmailDescriptionText = "marketingEmailDescription".localized
        static let marketingCallText = "marketingCall".localized
        static let marketingCallDescriptionText = "marketingCallDescription".localized
    }
    
    enum Logout {
        // Strings
        static let logout = "logout".localized
    }
    
    /// Constants related to Subscription
    enum Subscription {
        //Strings
        static let storyBoardIdentifier = "Subscription"
        static let subscription = "subscription".localized
        static let mySubscription = "mySubscription".localized
        static let manageMySubscription = "manageMySubscription".localized
        static let previousStatements = "previousStatements".localized
        static let editBillingInfo = "editBillingInfo".localized
        
        static let viewTitleText = "CancelSubscription".localized
        static let headerText = "SureCancelSubscription".localized
        static let descriptionText = "CancelSubscriptionDescription".localized
        static let continueCancelText = "ContinueCancel".localized
    }
    
    enum FiberPlanDetailCell {
        //Strings
        static let cardWillBeCharged = "cardWillBeCharged".localized
        static let taxesAndFees = "taxesAndFees".localized
        //Dimension
        static let spacingAfterPlanNameLabel: CGFloat = 2
        static let spacingAfterSpeedLabel: CGFloat = 16
    }
    
    /// Constants related to Subscription
    enum StatementDetail {
        //Strings
        static let statement = "statement".localized
    }
    
    enum PaymentDetail {
        //Strings
        static let paymentDetails = "paymentDetails".localized
        static let processedOn = "processedOn".localized
        static let paymentMethod = "paymentMethod".localized
        static let email = "email".localized
        static let billingAddress = "billingAddress".localized
    }
    
    enum PaymentBreakdown {
        //Strings
        static let paymentBreakdown = "paymentBreakdown".localized
        static let salesTax = "salesTax".localized
        static let promoCode = "promoCode".localized
        static let offYourMonthlyBill = "offYourMonthlyBill".localized
        static let total = "total".localized
        static let defaultPaymentName = "Fiber Internet"
        static let emptyDollarValue = "$0.00"
        //Dimensions
        static let cellEstimatedHeight: CGFloat = 295
    }
    
    enum EditPayment {
        // Edit payment URL for QA environment
        static var editPaymentURL: String {
            return EnvironmentPath.salesforceBase + "/" + EnvironmentPath.communityName + "/apex/vf_fiberBuyFlowPaymentMobile?userId="
        }
        static let userNoteDetail = "userNoteDetail".localized
    }
    
    enum DateFormat {
        // date formats
        static let YYYYMMddT = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        static let yyyyMMddT = "yyyy-MM-dd'T'HH:mm:ssZ"
        static let ddMMYYYY = "dd/MM/yyyy"
        static let MMMdyyyy = "MMM. d yyyy"
        static let MMMMddyyyy = "MMMM dd, yyyy"
        static let hmma = "h:mma"
        static let a = "a"
        static let hmm = "h:mm"
        static let YYYY_MM_dd = "yyyy-MM-dd"
        static let MMMM = "MMMM"
        static let MMMMyyyy = "MMMM yyyy"
        static let MMddyyyy = "MM/dd/yyyy"
        static let YYYY_M_d = "yyyy-M-d"
        static let yyyyMMddHHmmss = "yyyy-MM-dd HH:mm:ss"
        static let hMMa = "h:mm a"
        static let MMddyyyy_at_hmma = "MM/dd/yyyy' at 'h:mma"
        static let MMddyy = "MM/dd/yy"
    }
    
    enum WelcomeTableviewCell {
        //String
        static let welcomeText = "Congratulations".localized
        static let weAreOnTheWay = "weAreOnTheWay".localized
        static let workInProgress = "workInProgress".localized
        enum InstallationNextStep {
            static let scheduledText: String = "youAreSignedUp".localized
            static let clearTheArea: String = "clearTheArea".localized
            static let waitWhileTechnicianInstall = "waitWhileTechnicianInstall".localized
        }
        enum ServiceNextStep {
            static let clearTheArea: String = "clearTheAreaForService".localized
            static let waitWhileTechnicianInstall = "waitWhileTechnicianForService".localized
        }
        //Dimensions
        static let closeButtonCornerRadius: CGFloat = 4
        static let contentViewCornerRadius: CGFloat = 16
        static let leftViewCornerRadius: CGFloat = 4.5
    }
    
    enum InstallationStatusView {
        //Dimensions
        static let cornerRadius: CGFloat = 2
    }
    
    enum InstallationScheduledCell {
        //Strings
        static let welcomeText = "installationStatus".localized
        static let scheduledText = "installationScheduled".localized
        static let appointmentBetweenText = "appointmentBetween".localized
        static let changeAppointment = "changeAppointment".localized
        static let cancel = "Cancel".localized
        static let serviceVisitStatus = "serviceVisitStatus".localized
        static let serviceVisitScheduled = "serviceVisitScheduled".localized
        static let cancelAppointment = "cancelAppointment".localized
        //Dimensions
        static let appointmentViewCornerRadius: CGFloat = 16
    }
    
    enum InRouteCell {
        //Strings
        static let estimatedArrivalWindow = "estimatedArrivalWindow".localized
        static let technicianOnTheWay = "technicianOnTheWay".localized
        static let installationStatus = "installationStatus".localized
        static let serviceVisitStatus = "serviceVisitStatus".localized
    }
    
    enum InProgressCell {
        //Strings
        static let isSettingNetwork = "isSettingNetwork".localized
        static let installationUnderway = "installationUnderway".localized
        static let serviceUnderway = "serviceUnderway".localized
        static let installationStatus = "installationStatus".localized
        static let serviceVisitStatus = "serviceVisitStatus".localized
    }
    
    enum InstallationCompletedCell {
        //Strings
        static let installationComplete = "installationComplete".localized
        static let serviceComplete = "serviceComplete".localized
        static let youAreAllSet = "youAreAllSet".localized
        static let networkIsReady = "networkIsReady".localized
        static let congratulations = "Congratulations".localized
        static let serviceVisitComplete = "serviceVisitComplete".localized
        static let getStarted = "getStarted".localized
        static let dismiss = "dismiss".localized
    }
    
    enum MapView {
        //Dimensions
        static let regionRadius: Double = 1000
        static let annotationViewWidthHeight: CGFloat = 16
        static let annotationViewBorderWidth: CGFloat = 2
    }
    
    enum DashboardContainer {
        // Strings
        static let pendingActivation =  "Pending Activation"
        static let abandonedActivation = "Abandoned Activation"
        static let customerFeedBack = "CustomerFeedBack".localized
        static let networkInformationRetryMessage = "networkInformationRetryMessage".localized
        static let feedbackButtonTag : Int = 777
    }
    
    enum NewUserDashboard {
        static let serviceAppointmentPollTime: TimeInterval = 5*60*60 //5 min
        static let estimatedRowHeight: CGFloat = 240
        // Strings
        static let cancelAppointmentConfirmationTitle = "cancelAppointmentConfirmationTitle".localized
        static let cancelAppointmentAlertDescription = "cancelAppointmentAlertDescription".localized
        static let keepIt = "keepIt".localized
        static let cancelIt = "cancelIt".localized
        static let cancelAppointment = "cancelAppointment".localized
    }
    
    enum ServiceAppointment {
        //String
        static let noTechnicianAssigned = "noTechnicianAssigned".localized
    }
    
    enum Passcode {
        // Strings
        static let keyPathPosition = "position"
        static let titleCreatePasscode = "titleCreatePasscode".localized
        static let titleEnterPasscode = "titleEnterPasscode".localized
        static let zero = "0"
        
        //Dimensions
        static let maximumPasscodeValue = 4
        static let totalNumberCount = 10
        static let clearCellIndex = 12
        static let animationDuration = 0.07
        static let animationOffset = 15
        
        //Images
        static let ovalFilledImage = "oval-filled"
        static let ovalEmptyImage = "oval"
    }
    
    /// Constants related to Salesforce Chat
    enum Chat {
        
        // Strings
        static let agentEndedSession = "agentEndedSession".localized
        static let noAgentsAvailable = "noAgentsAvailable".localized
        static let userEndedSession = "userEndedSession".localized
        static let sessionEndReasonUnknown = "sessionEndReasonUnknown".localized
        static let sessionEnded = "sessionEnded".localized
        static let error = "chatError".localized
        static let unexpectedError = "unexpectedChatError".localized
        static let existingSessionErrorDescription = "existingSessionErrorDescription".localized
        static let sessionCreationErrorDescription = "sessionCreationErrorDescription".localized
        static let chatAmbassadorState = "colorado"
    }
    
    /// Constants related to Modify appoinemtn
    enum ModifyAppointment {
        // Strings
        static let title = "modifyAppointment".localized
        static let appointmentAlreadyScheduled = "appointmentAlreadyScheduled".localized
        static let selectDateAndSlot = "selectDateAndSlot".localized
        static let unselectedSlotError = "unselectedSlotError".localized
        //Dimension
        static let estimatedRowHeight: CGFloat = 200
    }
    
    /// Constants related to AvailableTimeSlotTableViewCell
    enum AvailableTimeSlotTableViewCell {
        // Images
        static let selected = "selected"
        static let unSelected = "unSelected"
        static let unSelectedError = "unSelectedError"
        static let selectedWithError = "selectedError"
    }
    
    /// Constants related to AvailableDatesTableViewCell
    enum AvailableDatesTableViewCell {
        // Strings
        static let selectDayAndTime = "selectDayAndTime".localized
        static let modifyAppointmentInstructions = "modifyAppointmentInstructions".localized
        static let availableAppointmentsOn = "availableAppointmentsOn".localized
    }
    
    enum Support {
        //Images
        static let supportButton = "supportFab"
        //Dimensions
        static let cellEstimatedHeight: CGFloat = 280
        //Strings
        static let titleText = "Support".localized
        static let callUsText = "callUsAt".localized
        static let faqTopics = "FaqTopics".localized
        static let troubleshooting = "Troubleshooting".localized
        static let liveChat = "LiveChat".localized
        static let scheduleCallback = "ScheduleCallback".localized
        static let contactUs = "ContactUs".localized
        static let restartModemTroubleshooting = "troubleshootingRestartModem".localized
        /// Cell heights
        static let speedTestCellHeight: CGFloat = 125
        static let restartModemCellHeight: CGFloat = 58
        static let faqCellHeight: CGFloat = 51
        static let contactUsCellHeight: CGFloat = 51
        ///Header heights
        static let headerWithSubtitleHeight: CGFloat = 80
        static let headerWithOutSubtitleHeight: CGFloat = 70
    }
    
    enum SpeedTest {
        //Strings
        static let restartModemText = "RestartModem".localized
        static let troubleshootingRestartModemText = "restartModem".localized
        static let needHelpText = "NeedHelp".localized
        static let visitWebsiteText = "VisitWebsite".localized
        static let lastTestText = "LastSpeedTest".localized
        static let runNewTestText = "RunNewTest".localized
        static let supportUploadMbpsText = "supportMbpsUpload".localized
        static let uploadMbpsText = "mbpsUpload".localized
        static let downloadMbpsText = "mbpsDownload".localized
        static let restartingModemText = "restarting".localized
        static let successAlert = "successAlert".localized
        static let modemRebooting = "modemRebooting".localized
        static let close = "close".localized
        static let speedTestError = "speedTestError".localized
        static let confirmationAlertTitle = "confirmationAlertTitle".localized
        static let confirmationAlertMessage = "confirmationAlertMessage".localized
        static let confirmationAlertRestartButtonTitle = "confirmationAlertRestartButtonTitle".localized
    }
    
    enum LoaderErrorView {
        //Dimension
        static let tag = 10000
        //Images
        static let reloadImageName = "reload"
    }
    
    enum UsageDetails {
        //Strings
        static let usageToday = "usageToday".localized
        static let usageLastTwoWeeks = "usageLastTwoWeeks".localized
        static let connectionPaused = "connectionPaused".localized
        static let deviceConnected = "deviceConnected".localized
        static let notConnected = "notConnected".localized
        static let tapToPause = "tapToPause".localized
        static let tapToResume = "tapToResume".localized
        static let tapToConnectDeviceToNetwork = "tapToConnectDeviceToNetwork".localized
        static let tapToReload = "tapToReload".localized
        static let upload = "upload".localized
        static let download = "download".localized
        static let removeDevice = "removeDevice".localized
        static let wantToRemove = "wantToRemove".localized
        static let fromTheNetwork = "fromTheNetwork".localized
        static let youCanRestoreAccess = "youCanRestoreAccess".localized
        static let max15CharacterLimit = "max15CharacterLimit".localized

        //Image
        static let pauseImageName = "pause"
        static let connectedImageName = "connected"
        static let deviceOrganization = "deviceOrganization".localized
        static let devicesNickname = "devicesNickname".localized
        static let nicknameOptional = "nicknameOptional".localized
        static let deviceName = "devicesName".localized
        static let nicknameMaxlength : Int = 15
        
        static let lastTwoWeeks: Int = 15 //Last two weeks will not include today's date so its 15 instead of 14
    }
    
    enum UsageDetailsView {
        // Dimensions
        static let spaceAfterDownloadUnitLabel: CGFloat = 34
    }
    
    enum Device {
        //Dimensions
        static let cellEstimatedHeight: CGFloat = 60
        static let cellHeight: CGFloat = 60
        static let viewBorderWidth: CGFloat = 1
        static let connectedDeviceHeaderHeight: CGFloat = 70
        static let removedDeviceHeaderHeight: CGFloat = 60
        static let shadowBlur: CGFloat = 12
        static let shadowAplha: Float = 0.8
        static let buttonWidthConstant: CGFloat = 24
        //Images
        static let onNetworkStrength = "on"
        static let mediumNetworkStrength = "on_2bar"
        static let lowNetworkStrength = "1Bar"
        static let offNetworkStrength = "off"
        static let onCableNetworkStrength = "on_cable"
        static let collapseCellArrowImage = "collapse-small"
        static let pauseNetworkStrength = "pause"
        static let disconnectedNetworkStrength = "disconnected"
        static let withoutBackground = "-without-background"
        //Strings
        static let connectedDeviceHeader = "connectedDevice".localized
        static let removedDevicesHeader = "removedDevices".localized
        static let tapToRestore = "tapToRestore".localized
        static let pullToRefresh = "pullToRefresh".localized
        //Timer
        static let deviceListAPIPollTime: TimeInterval = 30.0
    }
    
    /// Constants related to Network Information view
    enum NetworkInfo {
        //Strings
        static let online = "online".localized
        static let offline = "offlne".localized
        static let connectedToInternet = "connectedToInternet".localized
        static let canNotConnectToInternet = "canNotConnectToInternet".localized
        static let serialNumber = "serialNumber".localized
        static let networkInformation = "networkInformation".localized
        static let guestInformation = "guestInformation".localized
        static let internet = "internet".localized
        static let modem = "modem".localized
        static let networkName = "networkName".localized
        static let guestNetworkName = "guestNetworkName".localized
        static let networkPassword = "networkPassword".localized
        static let guestNetworkPassword = "guestNetworkPassword".localized
        static let networkPasswordDescription = "networkPasswordDescription".localized
        static let wifiNetwork = "wifiNetwork".localized
        static let network = "network".localized
        static let guestNetwork = "guestNetwork".localized
        static let enabled = "enabled".localized
        static let disabled = "disabled".localized
        static let tapToEnable = "tapToEnable".localized
        static let tapToDisable = "tapToDisable".localized
        static let tapToEditNetwork = "tapToEditNetwork".localized
        
        static let passwordMinLength: Int = 8
        static let passwordMaxLength: Int = 63
        static let networkNameMaxLength: Int = 32
        static let edgeInsetWhenKeyboardAppear = UIEdgeInsets.init(top: 0, left: 0, bottom: 240, right: 0)
        static let edgeInsetWhenKeyboardDisappear = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        /// Section header heights
        static let onlineStatusHeaderHeight: CGFloat = 24
        static let networkInfoHeaderHeight: CGFloat = 20
        
        ///Row height
        static let rowHeight: CGFloat = 359
    }
    
    /// Constants related to Calendar view
    enum CalendarView {
        static let maxMonthToView: Int = 3
        static let numberOfDaysInWeek: Int = 7
        static let padding: CGFloat = 80
        static let numberOfRows: Int = 6
        //Images
        static let next = "next"
        static let back = "back"
    }
    
    /// Constants related to Appointment confirmation
    enum AppointmentConfirmation {
        static let title = "appointmentBooked".localized
        static let technicianWillArriveOn = "technicianWillArriveOn".localized
        static let between = "between".localized
        static let description = "someoneShouldPresent".localized
        static let bookAppointmentDescription = "bookAppointmentDescription".localized
        static let addAppointmentToCalendar = "addAppointmentToCalendar".localized
        static let viewMyDashboard = "viewMyDashboard".localized
    }
    
    /// Constants related to Appointment cancellation
    enum AppointmentCancelledCell {
        static let madeAMistake = "madeAMistake".localized
        static let fiberInstallationStatus = "fiberInstallationStatus".localized
        static let installationCancelled = "installationCancelled".localized
        
        static let cornerRadius: CGFloat = 16
    }
    
    enum Account {
        /// Personal info cell
        static let personalInfoText = "personalInfo".localized
        static let cellPhoneText = "cellPhone".localized
        static let workPhoneText = "workPhone".localized
        static let homePhoneText = "homePhone".localized
        static let emailInfoText = "emailInfoText".localized
        static let passwordText = "passwordText".localized
        static let passwordPlaceholder = "•••••••••"
        
        /// Cell heights
        static let accountInfoCellHeight: CGFloat = 162
        static let paymentInfoCellHeight: CGFloat = 239
        static let personalInfoCellHeight: CGFloat = 276
        static let preferenceAndSettingsCellHeight: CGFloat = 540
        static let logoutCellHeight: CGFloat = 128
        
        /// Payment info cell
        static let bestInWorldFiberText = "BestInWorldFiber".localized
        static let speedUptoText = "SpeedUpTo".localized
        static let paymentInfoText = "PaymentInformation".localized
        static let nextPaymentDateText = "NextPaymentDate".localized
        static let visaText = "Visa".localized
        
        /// Owner detail cell
        static let serviceAddressText = "ServiceAddress".localized
    }
    
    enum WifiNetwork {
        static let scanToJoinNetwork = "scanToJoinNetwork".localized
        static let scanToJoinGuestNetwork = "scanToJoinGuestNetwork".localized
        static let tapToViewFullScreen = "tapToViewFullScreen".localized
        static let scanToJoin = "scanToJoin".localized
    }
    
    enum JoinQRCode {
        static let scanQRCodeToJoinNetwork = "scanQRCodeToJoinNetwork".localized
        static let qrCodeInfoSubtitle = "qrCodeInfoSubtitle".localized
        static let joinQRCode = "joinQRCode".localized
        static let addToAppleWallet = "addToAppleWallet".localized
    }

    enum Pendo {
        static let age = "Age"
        static let country = "Country"
        static let gender = "Gender"
        static let tier = "Tier"
        static let timezone = "Timezone"
        static let size = "Size"
    }

    /// Tab
    enum Tab {
        static let account = "Account".localized
        static let dashboard = "Dashboard".localized
        static let devices = "Devices".localized
        static let internetOffline = "Internet offline".localized
        static let internetOnline = "Internet online".localized
        static let totalNumberOfTabs = 3
    }
}
