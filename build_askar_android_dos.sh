# Define the URL and the target directory
ASKAR_URL="https://github.com/openwallet-foundation/askar/releases/download/v0.3.2/library-ios-android.tar.gz"
TARGET_DIR="example/android/app/src/main/jniLibs"

# Create the target directory if it doesn't exist
if [ ! -d "$TARGET_DIR" ]; then
  mkdir -p "$TARGET_DIR"
fi

# Download the tar.gz file
echo "Downloading $ASKAR_URL..."
curl -L "$ASKAR_URL" -o "$TARGET_DIR/library-ios-android.tar.gz"

# Extract the contents to a temporary directory
TEMP_DIR=$(mktemp -d)
echo "Extracting contents..."
tar -xzf "$TARGET_DIR/library-ios-android.tar.gz" -C $TEMP_DIR

# Move the mobile/android directory to the target directory
echo "Moving mobile/android to $TARGET_DIR..."
mv $TEMP_DIR/mobile/android/* $TARGET_DIR

# Clean up the temporary directory and the downloaded tar.gz file
rm -rf $TEMP_DIR
rm "$TARGET_DIR/library-ios-android.tar.gz"

echo "Done!"