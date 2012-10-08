# Requirements #

- Xcode Compiler : Apple LLVM compiler 4.0 or above
- [Cocopods](https://github.com/CocoaPods/CocoaPods)
- Ruby 1.8.7 ->	see issue https://github.com/CocoaPods/CocoaPods/issues/554

# Install #

1. `pod install`
2. Rename Settings.plist.sample to Settings.plist
3. Open `klaxpont.xcworkspace`
4. Complete Settings.plist with an access_token + refresh_token
5. change build settings : Code signing and certificates

# Documentation #

The project's documentation can be generated (docset) via appledoc (http://gentlebytes.com/appledoc/). Just type the following command on your console, under the project directory.

```appledoc .```
 
# Notes #

* Upload video only works on device
* Dailymotion thumbnails resolution: 640*480

# TODO #

View issues on github