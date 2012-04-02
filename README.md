# Install #

1. git submodule init --update
2. Rename Settings.plist.sample to Settings.plist
3. Complete Settings.plist with an access_token + refresh_token
4. change build settings : Code signing and certificates

# Documentation #

The project's documentation can be generated (docset) via appledoc http://gentlebytes.com/appledoc/
```appledoc .```

# TODO #

* Retrieve active session from server, _see_ feature/token-from-server, to review
* List all videos from klaxpont, _see_ feature/list-videos
* Add validations on title and description of video before uploading, _see_ feature/token-from-server, to review
* Authentication: Facebook connect
* Assign video to user
* ...
 
# Notes #
* Upload video only works on device
