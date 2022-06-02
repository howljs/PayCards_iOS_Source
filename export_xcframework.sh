set -e

ARTIFACT_NAME="PayCardsRecognizer"
DEVICE_ARCHIVE="${ARTIFACT_NAME}.framework-iphoneos.xcarchive"
SIMULATOR_ARCHIVE="${ARTIFACT_NAME}.framework-iphonesimulator.xcarchive"
ARCHIVE_PATH="archives/"
FLAGS="SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES"
PRODUCT_PATH="/Products/Library/Frameworks/"
DEVICE_PRODUCT="${ARTIFACT_NAME}.framework"
SIMULATOR_PRODUCT="${ARTIFACT_NAME}.framework"

mkdir -p $ARCHIVE_PATH
rm -rf $ARCHIVE_PATH**

# Device slice.
xcodebuild archive -project "${ARTIFACT_NAME}.xcodeproj" \
  -scheme "PayCardsRecognizer" \
  -configuration Release \
  -destination 'generic/platform=iOS' \
  -archivePath "${ARCHIVE_PATH}${DEVICE_ARCHIVE}" \
  ${FLAGS}

# Simulator slice.
xcodebuild archive -project "${ARTIFACT_NAME}.xcodeproj" \
  ONLY_ACTIVE_ARCH=NO \
  -scheme "PayCardsRecognizerSim" \
  -configuration Release \
  -destination 'generic/platform=iOS Simulator' \
  -archivePath "${ARCHIVE_PATH}${SIMULATOR_ARCHIVE}" \
  ${FLAGS}

# Create XCFramework
xcodebuild -create-xcframework \
  -framework "${ARCHIVE_PATH}${DEVICE_ARCHIVE}${PRODUCT_PATH}${DEVICE_PRODUCT}" \
  -framework "${ARCHIVE_PATH}${SIMULATOR_ARCHIVE}${PRODUCT_PATH}${SIMULATOR_PRODUCT}" \
  -output "${ARCHIVE_PATH}${ARTIFACT_NAME}.xcframework"

open "${ARCHIVE_PATH}"
