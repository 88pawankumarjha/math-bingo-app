#!/usr/bin/env bash
set -e

# Install Flutter
git clone https://github.com/flutter/flutter.git -b stable $HOME/flutter
echo 'export PATH="$HOME/flutter/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
flutter doctor
