#!/bin/bash

cd ../BuildConfigure || exit

echo "Pod install"
# pod install

echo "Copy and rename files, Ex Debug.xcconfig.example to Debug.xcconfig"
find . -name "*.example" -exec sh -c 'cp {} `echo {} | sed 's/\.example//g'`' \;

