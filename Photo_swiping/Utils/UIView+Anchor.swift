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

class ImageZoomView: UIScrollView, UIScrollViewDelegate {
    
    var image: UIImage? {
        didSet {
            self.imageView.image = image
        }
    }
    private var imageView = UIImageView()
    private var gestureRecognizer = UITapGestureRecognizer()
    
    init() {
        super.init(frame: .zero)
        imageView = UIImageView()
        imageView.frame = bounds
        
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        
        setupScrollView()
        setupGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        imageView = UIImageView()
        imageView.frame = bounds
        
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        
        setupScrollView()
        setupGestureRecognizer()
    }
    
    // Sets the scroll view delegate and zoom scale limits.
    // Change the `maximumZoomScale` to allow zooming more than 2x.
    func setupScrollView() {
        delegate = self
        
        minimumZoomScale = 1.0
        maximumZoomScale = 2.0
    }
    
    // Sets up the gesture recognizer that receives double taps to auto-zoom
    func setupGestureRecognizer() {
        gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        gestureRecognizer.numberOfTapsRequired = 2
        addGestureRecognizer(gestureRecognizer)
    }


    // Handles a double tap by either resetting the zoom or zooming to where was tapped
    @objc func handleDoubleTap() {
        if zoomScale == 1 {
            zoom(to: zoomRectForScale(maximumZoomScale, center: gestureRecognizer.location(in: gestureRecognizer.view)), animated: true)
        } else {
            setZoomScale(1, animated: true)
        }
    }


    // Calculates the zoom rectangle for the scale
    func zoomRectForScale(_ scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width = imageView.frame.size.width / scale
        let newCenter = convert(center, from: imageView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    // Tell the scroll view delegate which view to use for zooming and scrolling
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

