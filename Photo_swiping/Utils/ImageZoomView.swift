import UIKit

class ImageZoomView: UIScrollView, UIScrollViewDelegate {
    
    var image: UIImage? {
        didSet {
            self.imageView.image = image
        }
    }
    var startFrame = CGRect()
    var startCenter = CGPoint() {
        didSet {
            self.center = startCenter
        }
    }
    
    private var startTapLocation = CGPoint()
    private var imageView = UIImageView()
    private var gestureRecognizer = UITapGestureRecognizer()
    private var closePanGestureRecongizer = UIPanGestureRecognizer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        
        startFrame = frame
        imageView.frame = bounds
        imageView.center = center
        
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        
        setupScrollView()
        setupGestureRecognizer()
        addCloseButton()
        closePanGestureRecongizer = UIPanGestureRecognizer(target: self, action: #selector(closeZoomImage(_:)))
        addGestureRecognizer(closePanGestureRecongizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func closeZoomImage(_ sender: UIPanGestureRecognizer) {
        let tapLocation = sender.location(in: self)
        switch sender.state {
            
        case .began:
            startTapLocation = tapLocation
        case .changed:
            
            imageView.center.x = (tapLocation.x - startTapLocation.x)/3 + center.x
            
            if tapLocation.y > startTapLocation.y { imageView.center.y = tapLocation.y - startTapLocation.y + center.y }
            else { imageView.center.y = (tapLocation.y - startTapLocation.y)/3 + center.y }
            
            if imageView.center.y - center.y > 50 { alpha = 1 - (imageView.center.y - center.y - 50)/500 }
            
        case .ended:
            if imageView.center.y - center.y > 75 {
                UIView.animate(withDuration: 0.3, delay: 0) {
                    self.alpha = 0
                    self.imageView.frame.origin.y = self.frame.maxY
                } completion: { _ in self.removeFromSuperview() }
                return
            }
            
            UIView.animate(withDuration: 0.3, delay: 0) {
                self.imageView.center = self.center
                self.alpha = 1
            }
        default: return
        }
    }
    
    private func addCloseButton() {
        let closeButton = UIButton(type: .close)
        closeButton.configuration = .filled()
        closeButton.configuration?.baseBackgroundColor = .systemGray2
        closeButton.configuration?.cornerStyle = .capsule
        closeButton.addAction(UIAction(handler: { _ in
            UIView.animate(withDuration: 0.3,
                           delay: 0) {
                
                self.frame = CGRect(x: self.startCenter.x, y: self.startCenter.y, width: self.startFrame.width, height: self.startFrame.height)
                self.center = self.startCenter
                self.imageView.frame = self.startFrame
                self.alpha = 0
                
            } completion: { _ in
                self.removeFromSuperview()
            }        }), for: .touchUpInside)
        
        addSubview(closeButton)
        closeButton.anchor(top: safeAreaLayoutGuide.topAnchor, leading: safeAreaLayoutGuide.leadingAnchor, paddingTop: 20, paddingLeading: 20)
    }
    
    func setupNewFrame(frame: CGRect) {
        self.frame = frame
        self.imageView.frame = frame
    }
    
    // Sets the scroll view delegate and zoom scale limits.
    // Change the `maximumZoomScale` to allow zooming more than 2x.
    private func setupScrollView() {
        delegate = self
        
        minimumZoomScale = 1.0
        maximumZoomScale = 2.0
    }
    
    // Sets up the gesture recognizer that receives double taps to auto-zoom
    private func setupGestureRecognizer() {
        gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        gestureRecognizer.numberOfTapsRequired = 2
        addGestureRecognizer(gestureRecognizer)
    }
    
    // Handles a double tap by either resetting the zoom or zooming to where was tapped
    @objc private func handleDoubleTap() {
        if zoomScale == 1 {
            zoom(to: zoomRectForScale(maximumZoomScale, center: gestureRecognizer.location(in: gestureRecognizer.view)), animated: true)
        } else {
            setZoomScale(1, animated: true)
        }
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.layoutIfNeeded()
        }
    }
    
    // Calculates the zoom rectangle for the scale
    private func zoomRectForScale(_ scale: CGFloat, center: CGPoint) -> CGRect {
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
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale != 1 {
            removeGestureRecognizer(closePanGestureRecongizer)
        }
        else { addGestureRecognizer(closePanGestureRecongizer)}
    }
}


