<a href="https://www.ramotion.com/agency/app-development?utm_source=gthb&utm_medium=repo&utm_campaign=garland-view"><img src="https://github.com/Ramotion/folding-cell/blob/master/header.png"></a>

<a href="https://github.com/Ramotion/garland-view">
<img align="left" src="https://github.com/Ramotion/garland-view/blob/master/garland-view.gif" width="480" height="360" /></a>

<p><h1 align="left">GARLAND VIEW</h1></p>

<h4>Garland View seamlessly transitions between multiple lists of content.</h4>


___



<p><h6>We specialize in the designing and coding of custom UI for Mobile Apps and Websites.</h6>
<a href="https://www.ramotion.com/agency/app-development?utm_source=gthb&utm_medium=repo&utm_campaign=garland-view">
<img src="https://github.com/ramotion/gliding-collection/raw/master/contact_our_team@2x.png" width="187" height="34"></a>
</p>
<p><h6>Stay tuned for the latest updates:</h6>
<a href="https://goo.gl/rPFpid" >
<img src="https://i.imgur.com/ziSqeSo.png/" width="156" height="28"></a></p>

</br>

[![Twitter](https://img.shields.io/badge/Twitter-@Ramotion-blue.svg?style=flat)](http://twitter.com/Ramotion)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Ramotion/garland-view)
[![codebeat badge](https://codebeat.co/badges/6f67da5d-c416-4bac-9fb7-c2dc938feedc)](https://codebeat.co/projects/github-com-ramotion-garland-view)
[![Donate](https://img.shields.io/badge/Donate-PayPal-blue.svg)](https://paypal.me/Ramotion)


## Requirements

- iOS 10.0  
- Xcode 9    
- Swift 4.0

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



## 🗂 Check this library on other language:
<a href="https://github.com/Ramotion/garland-view-android">
<img src="https://github.com/ramotion/navigation-stack/raw/master/Android_Java@2x.png" width="178" height="81"></a>


## 📄 License

Garland View is released under the MIT license.
See [LICENSE](./LICENSE) for details.

This library is a part of a <a href="https://github.com/Ramotion/swift-ui-animation-components-and-libraries"><b>selection of our best UI open-source projects.</b></a>

If you use the open-source library in your project, please make sure to credit and backlink to www.ramotion.com

## 📱 Get the Showroom App for iOS to give it a try
Try this UI component and more like this in our iOS app. Contact us if interested.

<a href="https://itunes.apple.com/app/apple-store/id1182360240?pt=550053&ct=garland-view&mt=8" >
<img src="https://github.com/ramotion/gliding-collection/raw/master/app_store@2x.png" width="117" height="34"></a>

<a href="https://www.ramotion.com/agency/app-development?utm_source=gthb&utm_medium=repo&utm_campaign=garland-view">
<img src="https://github.com/ramotion/gliding-collection/raw/master/contact_our_team@2x.png" width="187" height="34"></a>
