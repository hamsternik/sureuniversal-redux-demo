# Variables for make commands work on the local machine.
OS_VERSION_LOCAL ?=18.3.1
IPHONE_LOCAL ?=iPhone 16 Pro
DESTINATION_LOCAL ?="platform=iOS Simulator,OS=$(OS_VERSION_LOCAL),name=$(IPHONE_LOCAL)"

# Variables to make CI (github actions) works with the `macos-latest` available image.
OS_VERSION_CI ?=18.2
IPHONE_CI ?=iPhone 16 Pro
DESTINATION_CI ?="platform=iOS Simulator,OS=$(OS_VERSION_CI),name=$(IPHONE_CI)"

XCODEPROJECT ?=sureuniversal-redux-demo.xcodeproj
PROJECT_SCHEME ?=sureuniversal-redux-demo
UNIT_TEST_SCHEME ?=unit-tests


PIPELINE_ERROR = set -o pipefail &&
XCODEBUILD := xcodebuild
BEAUTIFY := xcbeautify

XCODEBUILD_PIPELINED := $(PIPELINE_ERROR) $(XCODEBUILD)
BUILD_FLAGS := -project $(XCODEPROJECT) -scheme $(SCHEME) -destination $(DESTINATION_LOCAL) -skipPackagePluginValidation
TEST_FLAGS := $(BUILD_FLAGS) -configuration Debug #-testPlan UnitTestsAll
EXTENDED_BUILD_FLAGS := CFLAGS="-ferror-limit=0"

help: 
	@cat Makefile

open: 
	@xed .

validate-gh-actions:
	@act push -P macos-latest=-self-hosted

xcodebuild:
	$(PIPELINE_ERROR) $(XCODEBUILD) $(CMD_ARG) $(BUILD_FLAGS) $(EXTENDED_BUILD_FLAGS) | $(BEAUTIFY)

# Lists the targets and configurations in a project, or the schemes in a workspace. Does not initiate a build.
xcodebuild-configs-json:
	xcodebuild -list -json

xcodebuild-version:
	xcodebuild -version

xcodebuild-swift-version:
	xcodebuild -showBuildSettings | grep SWIFT_VERSION

clean: xcodebuild-version xcodebuild-swift-version
	set -o pipefail && xcodebuild clean -scheme $(PROJECT_SCHEME) 

build: xcodebuild-version xcodebuild-swift-version
	set -o pipefail && xcodebuild build -scheme $(PROJECT_SCHEME) | xcbeautify

test: xcodebuild-version xcodebuild-swift-version
	set -o pipefail && xcodebuild test -scheme $(UNIT_TEST_SCHEME) -destination $(DESTINATION_LOCAL) | xcbeautify

test-ci: xcodebuild-version xcodebuild-swift-version
	set -o pipefail && xcodebuild test -scheme $(UNIT_TEST_SCHEME) -destination $(DESTINATION_CI) | xcbeautify

