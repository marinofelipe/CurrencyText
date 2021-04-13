fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
## iOS
### ios test
```
fastlane ios test
```
Run tests
### ios release
```
fastlane ios release
```
Release the framework next version. Available bump types are: [patch, minor, major].
### ios tag
```
fastlane ios tag
```
Tag the next release. Available bump types are: patch, minor, major
### ios bump_podspec
```
fastlane ios bump_podspec
```
Bump the podspec version. Available bump types are: patch, minor, major.
### ios publish_pod
```
fastlane ios publish_pod
```
Publish the new pod version!

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
