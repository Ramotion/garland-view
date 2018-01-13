![header](./header.png)
<!--- ![preview](./preview.gif) --->

# Garland View
[![Twitter](https://img.shields.io/badge/Twitter-@Ramotion-blue.svg?style=flat)](http://twitter.com/Ramotion)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Ramotion/garland-view)
[![codebeat badge](https://codebeat.co/badges/6f67da5d-c416-4bac-9fb7-c2dc938feedc)](https://codebeat.co/projects/github-com-ramotion-garland-view)


**Looking for developers for your project?**<br>
This project is maintained by Ramotion, Inc. We specialize in the designing and coding of custom UI for Mobile Apps and Websites.

<a href="https://ramotion.com/?utm_source=gthb&utm_medium=special&utm_campaign=garland-view-contact-us/#Get_in_Touch">
<img src="https://github.com/ramotion/gliding-collection/raw/master/contact_our_team@2x.png" width="187" height="34"></a> <br>

The [iPhone mockup](https://store.ramotion.com?utm_source=gthb&utm_medium=special&utm_campaign=garland-view) available [here](https://store.ramotion.com?utm_source=gthb&utm_medium=special&utm_campaign=garland-view).

## Requirements

iOS 10.0  
Xcode 9    
Swift 4.0

## Installation
You can install `garland-view` in several ways:

- Add source files to your project.

<br>

- Use [CocoaPods](https://cocoapods.org):
``` ruby
pod 'garland-view'
```

<br>

- Use [Carthage](https://github.com/Carthage/Carthage):
```
github "Ramotion/garland-view"
```

## Usage

### Garland View

Garland view can be used directly or by subclassing `GarlandViewController`. In both variants you need to implement `UICollectionViewDataSource` and `UICollectionViewDelegate` protocols.

```swift
let nib = UINib(nibName: "CollectionCell", bundle: nil)
garlandCollection.register(nib, forCellWithReuseIdentifier: "Cell")
garlandCollection.delegate = self
garlandCollection.dataSource = self
```

Control can be user with or without header view. Use `setupHeader(:UIView)` to customize collection header.
Use `GarlandConfig` to make your custom configuration.

Take a look at the `Example` project for an integration example.

# Get the Showroom App for iOS to give it a try
Try our UI components in our iOS app. Contact us if interested.

<a href="https://itunes.apple.com/app/apple-store/id1182360240?pt=550053&ct=fluid-slider&mt=8" >
<img src="https://github.com/ramotion/gliding-collection/raw/master/app_store@2x.png" width="117" height="34"></a>
<a href="https://ramotion.com/?utm_source=gthb&utm_medium=special&utm_campaign=fluid-slider/#Get_in_Touch">
<img src="https://github.com/ramotion/gliding-collection/raw/master/contact_our_team@2x.png" width="187" height="34"></a>
<br>
<br>

Follow us for the latest updates:<br>
[![Twitter URL](https://img.shields.io/twitter/url/http/shields.io.svg?style=social)](https://twitter.com/intent/tweet?text=https://github.com/ramotion/fluid-slider)
[![Twitter Follow](https://img.shields.io/twitter/follow/ramotion.svg?style=social)](https://twitter.com/ramotion)
