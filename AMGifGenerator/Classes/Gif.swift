//
//  Copyright © 2021 kaname ohara. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

/// Easy and light-weight GIF encode / decode library
public struct Gif {

    // MARK: - read only properties

    private (set) var animationImages: [UIImage]
    private (set) var repeatCount: Int = 0 // Infinite loop
    private (set) var frameDuration: Float = 0.05
    var animationDuration: TimeInterval { TimeInterval(frameDuration * Float(animationImages.count)) }
    private (set) var data: Data?

    /// initializer
    /// - Parameters:
    ///   - images: each frame
    ///   - repeatCount: zero for infinite loop
    ///   - delay: inter-frame duration in second
    private init(images: [UIImage], repeatCount: Int = 0, frameDuration: Float = 0.05) {
        animationImages = images
        self.repeatCount = repeatCount
        self.frameDuration = frameDuration
        data = generateData
    }

    /// initializer
    /// - Parameter data: Gif data
    private init(data: Data) {
        let source = CGImageSourceCreateWithData(data as CFData, nil)!
        let count = CGImageSourceGetCount(source)

        let fileProperties = NSDictionary(dictionary: CGImageSourceCopyProperties(source, nil)!)
        let fileDict = fileProperties[kCGImagePropertyGIFDictionary] as! NSDictionary
        repeatCount = Int(truncating: fileDict[kCGImagePropertyGIFLoopCount] as! NSNumber)

        let frameProperties = NSDictionary(dictionary: CGImageSourceCopyPropertiesAtIndex(source, 0, nil)!)
        let gifDict = frameProperties[kCGImagePropertyGIFDictionary] as! NSDictionary
        frameDuration = Float(truncating: gifDict[kCGImagePropertyGIFDelayTime] as! NSNumber)

        animationImages = []

        for i in 0 ..< count {
            autoreleasepool {
                let image = CGImageSourceCreateImageAtIndex(source, i, nil)!
                animationImages.append(UIImage(cgImage: image, scale: 1.0, orientation: .up))
            }
        }
        self.data = data
    }

    /// export file
    /// - Parameter fileUrl: url
    /// - Returns: success
    public func export(fileUrl: URL) -> Bool {
        guard let data = data else { return false }

        do {
            try data.write(to: fileUrl, options: .atomicWrite)
            return true
        } catch {
            return false
        }
    }

    /// generate GIF async
    /// - Parameters:
    ///   - data: data
    ///   - completion: Gif object
    public static func generate(data: Data, completion: ((Gif?) -> Void)?) {
        DispatchQueue.global().async {
            let gif = Gif(data: data)
            DispatchQueue.main.async { completion?(gif) }
        }
    }

    /// generate GIF
    /// - Parameter data: data
    /// - Returns: Gif object
    public static func generate(data: Data) -> Gif? {
        guard !Thread.isMainThread else {
            assertionFailure("must not be called from main thread")
            return nil
        }

        return Gif(data: data)
    }

    /// generate GIF aync
    /// - Parameters:
    ///   - images: image array
    ///   - repeatCount: zero is infinite loop
    ///   - delay: each frame duration in second
    ///   - completion: Gif object
    public static func generate(images: [UIImage], repeatCount: Int = 0, frameDuration: Float = 0.05, completion: ((Gif?) -> Void)?) {
        DispatchQueue.global().async {
            let gif = Gif(images: images, repeatCount: repeatCount, frameDuration: frameDuration)
            DispatchQueue.main.async { completion?(gif) }
        }
    }

    /// generate GIF sync
    /// - Parameters:
    ///   - images: image array
    ///   - repeatCount: zero is infinite loop
    ///   - delay: each frame duration in second
    /// - Returns: Gif object
    public static func generate(images: [UIImage], repeatCount: Int = 0, frameDuration: Float = 0.05) -> Gif? {
        guard !Thread.isMainThread else {
            assertionFailure("must not be called from main thread")
            return nil
        }

        return Gif(images: images, repeatCount: repeatCount, frameDuration: frameDuration)
    }

    private var generateData: Data? {
        guard !Thread.isMainThread else {
            assertionFailure("must not be called from main thread")
            return nil
        }

        // infinite loop
        let loopDic = NSDictionary(object: repeatCount, forKey: kCGImagePropertyGIFLoopCount as! NSCopying)
        let fileProperties = NSMutableDictionary(object: loopDic, forKey: kCGImagePropertyGIFDictionary as! NSCopying)

        // property of each frame
        let frameDic = NSDictionary(object: frameDuration, forKey: kCGImagePropertyGIFDelayTime as! NSCopying)
        let frameProperties = NSMutableDictionary(object: frameDic, forKey: kCGImagePropertyGIFDictionary as! NSCopying)

        let digestLength = Int(16)
        let md5Buffer = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLength)
        let dstData: NSMutableData = NSMutableData(bytesNoCopy: md5Buffer, length: digestLength)

        let dest = CGImageDestinationCreateWithData(dstData as CFMutableData, kUTTypeGIF, animationImages.count, nil)!
        CGImageDestinationSetProperties(dest, fileProperties)

        // add each images
        animationImages.forEach { image in
            autoreleasepool {
                CGImageDestinationAddImage(dest, image.cgImage!, frameProperties)
            }
        }

        if CGImageDestinationFinalize(dest) {
            return dstData as Data
        } else {
            return nil
        }
    }
}

extension UIImageView {

    /// load GIF and start animating
    /// - Parameter gif: Gif
    public func load(gif: Gif) {
        image = gif.animationImages.first // thumbnail when animation stopped
        animationImages = gif.animationImages
        animationDuration = gif.animationDuration
        animationRepeatCount = gif.repeatCount

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            self.startAnimating()
        }
    }
}
