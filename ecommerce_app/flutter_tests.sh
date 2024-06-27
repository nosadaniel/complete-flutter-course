#!/bin/bash

# Save current directory
CURRENT_DIR=$(pwd)

# Navigate to Flutter project
cd /ecommerce_app/test

# Run Flutter tests
flutter test

# Return to the original directory
cd $CURRENT_DIR
