#!/bin/sh

#  ci_pre_xcodebuild.sh
#  WeatherFriend
#
#  Created by Jaden Nation on 8/12/23.
#

echo "Stage: PRE-Xcode Build is activated .... "

# Move to the place where the scripts are located.
# This is important because the position of the subsequently mentioned files depend of this origin.
cd ..
echo "OPENAIKEY: $OPENAI_API_KEY"
plutil -replace OPENAI_API_KEY -string $OPENAI_API_KEY Info.plist
plutil -p Info.plist

echo "Stage: PRE-Xcode Build is DONE .... "

exit 0
