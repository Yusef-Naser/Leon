# Leon
leon is a ios library written with swift to enable developer to handle show images with animation and with more gesture

# Installation

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate `Leon` into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'Leon', '~> 0.0.8'
```

# Usage


## How to get image frame

### if container of image is UIView or UIStackView 
```swift
// get point of image
let point = imageView.convert(imageView.bounds.origin, to: self.view /* view is parent view in viewController */ )
// get size of image
let size = CGSize(width: imageView.frame.width , height: imageView.frame.height)
// get frame of image 
let frame = CGRect(origin: point , size: size )
```


There are 6 init funtions in Leon Images

### First init
<img align="right" src="resources/firstInit.gif" width="20%" />  

``` swift
// 1- first init
let vc = LeonImages(image: imageView.image!)
self.present(vc , animated: true )
```

*  image: just pass image in imegView without starter animation
- use this init if u have image as just UIImage and don't need to load image from web


<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>


### Second init
<img align="right" src="resources/secondInit.gif" width="20%" />

```swift
//2- second init
let vc = LeonImages(imageURL: String )
self.present(vc , animated: true )
````
* imageURL:  is a string url of image to load from web without starter animation
- use this init if you don't want start animation

<br/>
<br/>
<br/>
<br/>

### Third init
<img align="right" src="resources/thirdInit.gif" width="20%" />

```swift
// 3- third init
let vc = LeonImages(listImagesURL: [Any] , index : 2 )
self.present(vc , animated: true )
````
* listImagesURL : an array that contain two type of images 
    - array may contain string url image to load from web
    - array may contain UIImage to just set this image in imageView in LeonImages
* index  ( optional -> default value = 0 ) : the index for starter image in array

<br/>
<br/>
<br/>
<br/>


### Fourth init
<img align="right" src="resources/4.1_init.gif" width="20%" />

````swift
// 4- fourth init
let vc = LeonImages(startFrame: imageView.frame , thumbnail: imageView.image! , imageURL: String )
self.present(vc , animated: true )
````
- Use this init to start Leon with animation from start fram to center of screen
*  startFrame :  init frame of image to start frame from this point
* thumbnail : init UIImage in imageView untile animation finished
* imageURL : start load image after animation finish 

<br/>
<br/>
<br/>
<br/>

### Fifth init
<img align="right" src="resources/5_init.gif" width="20%" />

```swift
// 5- fifth init
let vc = LeonImages(startFrame: imageView.frame , thumbnail: imageView.image! )
self.present(vc , animated: true )
```
- Use this init to start Leon with animation from start fram to center of screen
*  startFrame :  init frame of image to start frame from this point
* thumbnail : init UIImage in imageView untile animation finished

<br/>
<br/>
<br/>
<br/>


### Sixth init
<img align="right" src="resources/6.1_init.gif" width="20%" />

```swift
// 6- Six init
let vc = LeonImages(startFrame: imageView.frame , thumbnail: imageView.image!, listImagesURL: [Any] , index : 2 )
self.present(vc , animated: true )
```
*  startFrame :  init frame of image to start frame from this point
* thumbnail : init UIImage in imageView untile animation finished
* listImagesURL : an array that contain two type of images 
- array may contain string url image to load from web
- array may contain UIImage to just set this image in imageView in LeonImages
* index  ( optional -> default value = 0 ) : the index for starter image in array

<br/>
<br/>
<br/>
<br/>

# Features

<p>

<img align="right" src="resources/errorMessage.gif" width="20%" />

- change error message when loading failure (default value : "Error loading, tap to reload" )
```swift
let vc = // use init LeonImages
vc.errorMessage = "write your message"
```
- enable / disable tap to reload when loadin failure
```swift
let vc = // use init LeonImages
vc.tapToReload = true
```
</p>

- enable / disable close button (default value : true)
```swift
let vc = // use init LeonImages
vc.showCloseButton = false
```

- dismiss image by panGesture
- zoom image with pinch gesture
- zoom image with double tap
- create custom View Controller extended LeonImages

  ### Example of CustomLeonImages
  
  <img align="right" src="resources/customView.gif" width="20%" />
  
  [Custom Leon Images](./LeonExample/customLeon/CustomLeonImages.swift)

## Author
### Yusef Naser

- [Twitter](https://twitter.com/yusef_naser93)
- [GitHub](https://github.com/Yusef-Naser)
- [Linkedin](https://www.linkedin.com/in/yusef-naser-485b7710a)


## License
`Leon` is available under the MIT license. See the [LICENSE](./LICENSE) file for more info.

