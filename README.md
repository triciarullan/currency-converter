# currency-converter

currency-converter is a mobile app developed by Tric Rullan. The app enables user to convert specific currencies. Initial balance is 1000 EUR and there is no transfer fee within the first 5 transactions. Transfer fee is 0.7% of the amount to sell/exchange.


## Table of Contents

- [Getting Started](#getting-started)
  * [Environment setup](#environment-setup)
  * [Project setup](#project-setup)
- [Architecture, Design Patterns and Other Documentation](#architecture-design-patterns-and-other-documentation)

## Getting Started

### Environment setup

-   macOS Version: High Sierra 10.15.x
-   Xcode Version: 11.3
-   Swift Version: 5

### Project setup

**1. Dependencies**

Install the following if not already done so:

- Cocoapods: Installation instructions can be [found here](https://cocoapods.org/)


## Architecture, Design Patterns and Other Documentation

The following concepts are used throughout the codebase:

-  MVVM: MVVM presents a better separation of code which is very easy to maintain (removing and adding of code). Also it makes testing easier since view models are separated. 
-  Alamofire [reference is found here](https://github.com/Alamofire/Alamofire) Alamofire is used to fetch the iTunes Search API.
-  PromiseKit [reference is found here](https://github.com/mxcl/PromiseKit) PromiseKit makes code more readable and easy to maintain when simplifing asynchronous calls.
-  R.Swift [reference is found here](https://github.com/mac-cain13/R.swift) R.Swift catches compile errors since it makes it easier to link resources such as strings, identifiers and file names.
- MBProgressHUD [reference is found here](https://github.com/jdg/MBProgressHUD)
