def BUILD_NAME = "Centurylink"
def BUNDLEID = "com.centurylink.BIWF"
def CONFIGURATION = "Debug"
def PROJECT = "BiWF.xcodeproj"
def WORKSPACE = "BiWF.xcodeproj/project.xcworkspace"
def SCHEME = "BiWF"
def SOURCE = "BiWF"
def SSH_CREDS = 'ec308abf-2ec7-4ade-b7f8-8969b1cb41f0'
def SLACK_ALWAYS_CHANNEL = "#centurylink-alerts"
def SLACK_FAIL_CHANNEL = "#centurylink-dev"
def XCODE_VERSION = '11.3'
def XCODE_DEVICE = 'iPhone 11'

pipeline {
    agent { label 'ios' }
    options {
        timeout(time: 1, unit: 'HOURS')
    }
    stages {
        stage('Prepare Agent') {
            steps {
                script {
                    removeCache()
                    ios.prepareEnvironment(device: XCODE_DEVICE, xcode: XCODE_VERSION, cocoapods: false)
                }
            }
        }
        stage('Test') {
            steps {
                withSigningIdentity() {
                    swiftlint(source: SOURCE, stash: false)
                    lizard(source: SOURCE, stash: false)
                    script { fastlane.scan(device: XCODE_DEVICE, scheme: SCHEME, stash: false, workspace: WORKSPACE) }
                    slather(scheme: SCHEME, workspace: WORKSPACE, project: PROJECT, stash: false)
                }
            }
            post {
                always {
                    danger()
                }
            }
        }

        stage('Sonar') {
            when {
                not { changeRequest() }
            }
            steps {
                sonar(projectVersion: env.BUILD_NUMBER)
            }
        }

        stage('Build Debug') {
            when {
                not { changeRequest() }
            }
            steps {
                updateProjectVersion()
                withSigningIdentity() {
                    script {
                        xcode.resign(bundleIdentifier: BUNDLEID)
                        fastlane.gym(name: BUILD_NAME, scheme: SCHEME, workspace: WORKSPACE, configuration: CONFIGURATION, stash: false)
                    }
                }
            }
            post {
                success {
                    script {
                        ota.publishIPA(bundleId: BUNDLEID, config: CONFIGURATION, name: BUILD_NAME, stash: false)
                    }
                }
            }
        }

        stage('Documentation') {
            when {
                not { changeRequest() }
            }
            steps {
                generateDocumentation(WORKSPACE, SCHEME, CONFIGURATION, SSH_CREDS)
            }
            post {
                success {
                    publishHTML([
                        allowMissing: true,
                        alwaysLinkToLastBuild: true,
                        keepAll: false,
                        reportDir: 'docs',
                        reportFiles: 'index.html',
                        reportName: 'Documentation'
                    ])
                }
            }
        }
	}
    post {
        always {
            script {
                def slackMessage = slack.defaultMessage()
                slackMessage += " - <${env.JENKINS_URL}/job/Centurylink/job/centurylink-ios/job/master/Documentation|Documentation>"
                slack(alertPullRequests: true, channels: [SLACK_ALWAYS_CHANNEL], alertFailures: true, includeChanges: true, message: slackMessage)
            }
        }
        failure {
            slack(alertPullRequests: true, channels: [SLACK_FAIL_CHANNEL], alertFailures: true, includeChanges: true)
        }
    }
}

def generateDocumentation(String workspace, String scheme, String configuration, String credentials) {
    script {
        sh(script: "jazzy --min-acl private -x -workspace,${workspace},-scheme,${scheme},-configuration,${configuration},-derivedDataPath,DerivedData,clean")
    }
}

def updateProjectVersion() {
	script {
		sh 'sed -i".bkp" "s/CURRENT_PROJECT_VERSION = .*/CURRENT_PROJECT_VERSION = $BUILD_NUMBER;/g" BiWF.xcodeproj/project.pbxproj'
	}
}

def removeCache() {
    script {
        sh 'rm -rf ~/Library/Developer/Xcode/DerivedData/BiWF-*'
    }
}
