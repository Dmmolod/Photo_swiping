import UIKit

extension UIView {
    
    // MARK: Constraints
    func anchor(
        top: NSLayoutYAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        leading: NSLayoutXAxisAnchor? = nil,
        trailing: NSLayoutXAxisAnchor? = nil,
        paddingTop: CGFloat = 0,
        paddingBottom: CGFloat = 0,
        paddingLeading: CGFloat = 0,
        paddingTrailing: CGFloat = 0,
        width: CGFloat? = nil,
        height: CGFloat? = nil
    ) {
        translatesAutoresizingMaskIntoConstraints = false

        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }

        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }

        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: paddingLeading).isActive = true
        }

        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -paddingTrailing).isActive = true
        }

        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }

        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func dimensionAnchors(width: NSLayoutDimension? = nil, multiplierWidth: CGFloat = 1,
                height: NSLayoutDimension? = nil, multiplierHeight: CGFloat = 1) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let width = width {
            widthAnchor.constraint(equalTo: width, multiplier: multiplierWidth).isActive = true
        }
        if let height = height {
            heightAnchor.constraint(equalTo: height, multiplier: multiplierHeight).isActive = true
        }
    }

    func centerX(inView view: UIView) {
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    func centerY(inView view: UIView) {
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    // MARK: Image/effects
    func setupBlur(with style: UIBlurEffect.Style, blurAlpha: Double = 0.5) {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: style))
        addSubview(blur)
        blur.alpha = blurAlpha
        blur.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor)
    }
    
    func setupBackground(color: UIColor? = nil, name: String) {
        let background = UIImageView(image: UIImage(named: name))
        addSubview(background)
        if let color = color { background.tintColor = color }
        background.contentMode = .scaleToFill
        background.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor)
    }
}
