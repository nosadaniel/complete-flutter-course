#!/bin/bash

# Save current directory
CURRENT_DIR=$(pwd)

echo"Current directory => "
echo $CURRENT_DIR

# Navigate to Flutter project
cd ecommerce_app

# Run Flutter tests
flutter test

# Return to the original directory
cd $CURRENT_DIR
