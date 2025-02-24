RELEASE=v0.3.2
ASSET_NAME=library-linux-x86_64.tar.gz
ASKAR_URL="https://github.com/openwallet-foundation/askar/releases/download/$RELEASE/$ASSET_NAME"
TARGET_DIR="linux/lib"

# Create the target directory if it doesn't exist
mkdir -p "$TARGET_DIR"

# Download the tar.gz file
echo "Downloading $ASKAR_URL..."
curl -L "$ASKAR_URL" -o "$TARGET_DIR/$ASSET_NAME"

# Extract the contents
echo "Extracting contents..."
tar -xzf "$TARGET_DIR/$ASSET_NAME" -C $TARGET_DIR

# Clean up the downloaded tar.gz file
rm -rf $TEMP_DIR
rm "$TARGET_DIR/$ASSET_NAME"

# Copy library to example
echo "Copying from $TARGET_DIR to example/$TARGET_DIR"
cp -r "$TARGET_DIR/" "example/linux/"

echo "Done!"