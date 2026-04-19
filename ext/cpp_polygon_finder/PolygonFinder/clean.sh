#!/bin/bash

# Get the script's directory (the project root)
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
BUILD_DIR="$ROOT_DIR/build"

echo "--- Surgical cleanup initiated in: $BUILD_DIR ---"

# Check if the build directory exists
if [ ! -d "$BUILD_DIR" ]; then
    echo "Build directory does not exist. Nothing to clean."
    exit 0
fi

# Enter the build directory to operate safely
cd "$BUILD_DIR" || exit

# Remove critical CMake files and object files without deleting the build folder itself
echo "Removing cache files and build artifacts..."
rm -rf CMakeCache.txt CMakeFiles/ cmake_install.cmake Makefile bin/ lib/ examples/

# Optional: Recursively remove all .o, .a, and .so files if present
find . -name "*.o" -delete
find . -name "*.a" -delete
find . -name "*.so" -delete

echo "--- Cleanup complete. The build directory is now pristine. ---"
echo "You can now run: cmake -DBUILD_EXAMPLES=ON .."