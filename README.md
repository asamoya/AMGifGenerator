# AMGifGenerator

[![CI Status](https://img.shields.io/travis/asamoya/AMGifGenerator.svg?style=flat)](https://travis-ci.org/asamoya/AMGifGenerator)
[![Version](https://img.shields.io/cocoapods/v/AMGifGenerator.svg?style=flat)](https://cocoapods.org/pods/AMGifGenerator)
[![License](https://img.shields.io/cocoapods/l/AMGifGenerator.svg?style=flat)](https://cocoapods.org/pods/AMGifGenerator)
[![Platform](https://img.shields.io/cocoapods/p/AMGifGenerator.svg?style=flat)](https://cocoapods.org/pods/AMGifGenerator)

## Screen Shot

![Screen Record](/ScreenShots/shot0.gif)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

iOS 12.1 and later

## Installation

AMGifGenerator is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'AMGifGenerator'
```

## How to use
```ruby
import AMGifGenerator
```

#### Sync processing
```ruby
// generate GIF from UIImage array
let gif = Gif.generate(images: yourImages, repeatCount: 0, delay: 0.2)

// generate GIF from data
let gif = Gif.generate(data: yourGifData)
```

#### Async processing
In general, Image processing is a heavy task.
So you should use async method when you call them from main thread.
```ruby
// generate GIF from UIImage array
Gif.generate(images: yourImages, repeatCount: 0, delay: 0.2) { gif in
    // handler will be back to main thread
}

// generate GIF from data
Gif.generate(data: yourGifData) { gif in
    // handler will be back to main thread
}
```

#### Save as a file
```ruby
let success = gif.export(fileUrl: yourFileURL)
```
Use PhotoKit framework when you want to save into user's photo library.

#### Set to UIImageView
```ruby
imageView.load(gif: gif)
```

Please check out my sample code for more detail.

## Author

kaname surya, kaname.ohara@gmail.com

## License

AMGifGenerator is available under the MIT license. See the LICENSE file for more info.
