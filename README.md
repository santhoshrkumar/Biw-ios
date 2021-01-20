#  BiWF

### This document describes the setup and patterns used by this project implementing the iOS app for BiWF.


## Building
Building this project locally on a development environment does not need any special configuration.  Clone the project and open with Xcode and resolves Swift Packages Dependecies.
Build versions supported: Minimum version: iOS 13

## Configurations
Currently, there are no special build types or build flavors. It has the three standard build types `debug` , `sit` and `release`.

## Jenkins
CI/CD is performed by a Jenkins instance that can be found here:

[Jenkins iOS Builds](https://build.intrepid.digital.accenture.com/job/Centurylink/job/centurylink-ios/)

The project uses a Jenkins Declarative Pipeline for continuous integration. It runs on ACN's build servers under the `Centurylink-iOS` job. The build is controlled via this project's `Jenkinsfile`. This same configuration setup handles new builds when the master branch updates and test builds of pull requests.

### Jenkins Configuration
See this project's `Jenkinsfile`.  SonarQube results are published.

## JIRA
This project JIRA board can be found here:

[JIRA BiWF](https://ctl.atlassian.net/secure/RapidBoard.jspa?rapidView=3148)

## Architecture and Patterns
### Architecture Component Dependency Diagram
The diagram below give an overal overview of the various component types
in the app and how they depend on each other.

<!--
This PNG can be regenerated from this link: https://ts.accenture.com/sites/CenturyLink-BiWFMobile/_layouts/15/Doc.aspx?OR=teams&action=edit&sourcedoc={7A1AAF75-644A-4A5A-BC5E-E97857D040F9}, modifying the diagram and getting a screen-capture)
-->
![Architecture Component Dependency Diagram](ArchDiagramCompDI.png)

###### Local Back End
- **AppAuth SDK**  
  Provides OAuth authorization and remote (access/refresh) token management.
- **Token Service**  
  Provides local token services (get token, refresh token, update token, etc.).
- **Token Storage**  
  Provides secure local storage for token and authorization state.
- **Auth Service**  
  Provides authentication (sign in and logout) services. This is only used for log-in and log-out screens. Can be mocked or easily be replaced by implementations that always emit either failure or success.
- **Networking Client**  
  Provides communication, through HTTP(S), to remote web services such as the Salesforce API or to a local Mock Integraion Server. On Android we’ll use RetroFit and OkHttp for this client’s implementation.
- **Local Storage**  
  Provides local caching of data in local storage or memory. This component type will be used sparingly since most data will not be cached.
- **Salesforce Service**  
  Provides access to a particular set of remote Salesforce APIs. For tests or dummy-data replacements, a Mock Integration Server can be used instead to provide test-data or dummy-data to the Repositories.
- **Repository**  
  Provides access and aggregates data from a particular Salesforce Service. For tests or dummy-data replacements, Data-Model instances could be generated and handled on-the-fly, bypassing the Salesforce Services. Provides some business logic related to business processes. Provides caching strategies, if any.
- **Data-Model**  
  Models the data returned from a Repository and data to be provided to a Repository.

###### Front End
- **ViewModel and View**  
  Handles Repositories at the request of the UI. Translates Data-Models into UI-Models and vice versa. Provides UI-Model data to and from the UI. Provides a navigator/coordinator that instructs the UI to move to a different view or screen.

## Patterns
#### MVVM+C

## Code Structure

###### coordinators
Here live the various coordinators and the `Navigator` that manage the navigation for the various Activities.
###### model
Data that is used by Services and Repositories is defined here.
###### repos
The home of the app's Repositories. Repositories communicate with ViewModels to handle the ViewModels' data needs.

### Third Party Libraries
- RxSwift
- AppAuth
- Pendo
- DPPProtocols
- JTAppleCalendar
- RxDataSources
- RxFeedback
- RxKeyboard
- Firebase Analytics
- Firebase Crashlytics

## Style Guidelines
- Document all public methods and functions
- Avoid code comments, except where code is complicated.  
 Instead of adding comments, try to break-up/refactor it to make it more readable.
- Other Coding Conventions  
    https://swift.org/documentation/api-design-guidelines/
- Apple Styling guidelines - human-interface-guidelines
    https://developer.apple.com/design/human-interface-guidelines/ios/overview/themes/

## Notes

This README.md document is a living document and it is only a guideline. When things change, are re-thought, please don't forget to update this document as well to make our devs' lives a little easier. Thank you!

