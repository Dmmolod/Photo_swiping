import Foundation
import UIKit

class AnimateTapButton: UIButton {
    override var isHighlighted: Bool {
        didSet {
            UIView.animateKeyframes(withDuration: 0.3,
                                    delay: 0.0,
                                    options: [.beginFromCurrentState,
                                              .allowUserInteraction],
                                    animations: {
                self.alpha = self.isHighlighted ? 0.3 : 1
            })
        }
    }
}
