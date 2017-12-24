//
//  ScratchMap.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2017/12/21.
//  Copyright © 2017年 HsinTing Hsieh. All rights reserved.
//

import UIKit

class ScratchMask: UIImageView {

    weak var delegate: ScratchViewDelegate?

    var linetype: CGLineCap!

    var lineWidth: CGFloat!

    var lastPoint: CGPoint?

    override init(frame: CGRect) {
        super.init(frame: frame)

        isUserInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard let touch = touches.first else {
            return
        }

        lastPoint = touch.location(in: self)

        delegate?.scratchBegan(point: lastPoint!)

    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard
            let touch = touches.first,
            let point = lastPoint,
            let image = image
        else { return }

        let newPoint = touch.location(in: self)

        eraseMask(fromPoint: point, toPoint: newPoint)

        lastPoint = newPoint

        let progress = getAlphaPixelPercent(image: image)

        delegate?.scratchMoved(progress: progress)

    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard touches.first != nil else { return }

        delegate?.scratchEnded(point: lastPoint!)
    }



    func eraseMask(fromPoint: CGPoint, toPoint: CGPoint) {

        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, UIScreen.main.scale)

        image?.draw(in: self.bounds)

        let path = CGMutablePath()
        path.move(to: fromPoint)
        path.addLine(to: toPoint)

        let context = UIGraphicsGetCurrentContext()!
        context.setShouldAntialias(true) //抗鋸齒
        context.setLineCap(linetype)
        context.setLineWidth(lineWidth)
        context.setBlendMode(.clear)
        context.addPath(path)
        context.strokePath()

        image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

    }

    private func getAlphaPixelPercent(image: UIImage) -> Float {

        let width = Int(image.size.width)
        let height = Int(image.size.height)
        let bitmapByteCount = width * height

        let pixelData = UnsafeMutablePointer<UInt8>.allocate(capacity: bitmapByteCount)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let context = CGContext(data: pixelData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width, space: colorSpace, bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.alphaOnly.rawValue).rawValue)!

        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        context.clear(rect)
        context.draw(image.cgImage!, in: rect)

        var alphaPixelCount = 0
        for x in 0...width {
            for y in 0...height {
                if pixelData[y * width + x] == 0 {
                    alphaPixelCount += 1
                }
            }
        }

        free(pixelData)

        return Float(alphaPixelCount)/Float(bitmapByteCount)

    }
}
