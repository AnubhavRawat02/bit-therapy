//
// Pet Therapy.
//

import AppKit

public class ImageAnimator {
    
    public let baseName: String
    public var frames: [NSImage]
    public let frameTime: TimeInterval = 0.1
    public let loopDuracy: TimeInterval
    
    var onFirstFrameLoaded: ((Int) -> Void)?
    var onLoopCompleted: ((Int) -> Void)?
    var currentFrameIndex: Int = 0
    var completedLoops: Int = 0
    
    private var leftoverTime: TimeInterval = 0
    
    public init(
        basePath name: String,
        frames someFrames: [NSImage]? = nil,
        bundle: Bundle = .main,
        onFirstFrameLoaded: ((Int) -> Void)? = nil,
        onLoopCompleted: ((Int) -> Void)? = nil
    ) {
        self.onFirstFrameLoaded = onFirstFrameLoaded
        self.onLoopCompleted = onLoopCompleted
        let frames = someFrames ?? ImageAnimator.frames(for: name, in: bundle)
        self.baseName = name
        self.frames = frames
        self.loopDuracy = TimeInterval(frames.count) * frameTime
    }
    
    public func nextFrame(after time: TimeInterval) -> NSImage? {
        guard frames.count > 0 else { return nil }
        
        if completedLoops == 0 && currentFrameIndex == 0 && leftoverTime == 0 {
            onFirstFrameLoaded?(0)
        }
        let timeSinceLastFrameChange = time + leftoverTime
        guard timeSinceLastFrameChange >= frameTime else {
            leftoverTime = timeSinceLastFrameChange
            return nil
        }
        
        let framesSkipped = Int(floor(timeSinceLastFrameChange / frameTime))
        let usedTime = TimeInterval(framesSkipped) * frameTime
        leftoverTime = timeSinceLastFrameChange - usedTime
        
        let nextIndex = (currentFrameIndex + framesSkipped) % frames.count
        if currentFrameIndex != nextIndex {
            if nextIndex < currentFrameIndex {
                completedLoops += 1
                onLoopCompleted?(completedLoops)
                onFirstFrameLoaded?(completedLoops)
            }
            currentFrameIndex = nextIndex
            return frames[nextIndex]
        }
        return nil
    }
    
    public func invalidate() {
        self.onFirstFrameLoaded = nil
        self.onLoopCompleted = nil
    }
}

// MARK: - Load Frames

private extension ImageAnimator {
    
    static func frames(for name: String, in bundle: Bundle) -> [NSImage] {
        var frames: [NSImage] = []
        var frameIndex = 0
        while true {
            if let path = bundle.path(forResource: "\(name)-\(frameIndex)", ofType: "png"),
               let image = NSImage(contentsOfFile: path) {
                frames.append(image)
            } else {
                if frameIndex != 0 { break }
            }
            frameIndex += 1
        }
        return frames
    }
}

// MARK: - No Animations

extension ImageAnimator {
 
    public static let none = ImageAnimator(basePath: "")
}
