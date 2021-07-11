//
//  Copyright (c) 2021 kaname ohara All rights reserved.
//

import UIKit
import AMGifGenerator

final class ViewController: UIViewController {

    private var gif: Gif?
    @IBOutlet private weak var imageView: UIImageView!

    private func updateUI() {
        if let gif = gif { imageView.load(gif: gif) }
    }

    @IBAction private func onClickLoadItem(_ sender: Any) {
        guard let gifAsset = NSDataAsset(name: "SampleGif") else { fatalError() }

        Gif.generate(data: gifAsset.data) { [weak self] gif in
            self?.gif = gif
            self?.updateUI()
        }
    }

    @IBAction private func onClickGenerateItem(_ sender: Any) {
        var images: [UIImage] = []
        images.append(UIColor.green.image())
        images.append(UIColor.red.image())
        images.append(UIColor.blue.image())
        images.append(UIColor.orange.image())
        images.append(UIColor.magenta.image())
        images.append(UIColor.yellow.image())

        Gif.generate(images: images, repeatCount: 0, frameDuration: 0.25) { [weak self] gif in
            self?.gif = gif
            self?.updateUI()
        }
    }
}
