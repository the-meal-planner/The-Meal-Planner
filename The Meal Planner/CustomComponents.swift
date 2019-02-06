import Foundation
import UIKit


@available(iOS 10.0, *)
@IBDesignable
class AnimatedCard: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        //Set up our card
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //Set up our card
        setup()
    }
    
    private func setup() {
        //Set the background color
        self.backgroundColor = UIColor(red: 179/255, green: 89/255, blue: 0, alpha: 1)
        self.alpha = 0
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 0.5
        self.layer.cornerRadius = 4
        
        //Add other components
        
        //Animate
        
    }
    
    func animateCard(destinationY: CGFloat) {
        var animator: UIViewPropertyAnimator!
        animator = UIViewPropertyAnimator(duration:1.5, curve: .easeInOut, animations: {
            self.center.y = destinationY
            self.alpha = 1
        }
        )
        animator.startAnimation()
    }
    
    func skipAnimation(destinationY: CGFloat) {
        self.center.y = destinationY
        self.alpha = 1
    }
    
    func generateConstraints(object: UIView) -> [NSLayoutConstraint]{
        let constraints = [
            NSLayoutConstraint(
                item: self,
                attribute: NSLayoutConstraint.Attribute.centerX,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: object,
                attribute: NSLayoutConstraint.Attribute.centerX,
                multiplier: 1,
                constant: 0
                ),
            NSLayoutConstraint(
                item: self,
                attribute: NSLayoutConstraint.Attribute.centerY,
                relatedBy: NSLayoutConstraint.Relation.lessThanOrEqual,
                toItem: object,
                attribute: NSLayoutConstraint.Attribute.centerY,
                multiplier: 1.6,
                constant: 0
            ),
            NSLayoutConstraint(
                item: self,
                attribute: NSLayoutConstraint.Attribute.width,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: object,
                attribute: NSLayoutConstraint.Attribute.width,
                multiplier: 0.9,
                constant: 0
            ),
            NSLayoutConstraint(
                item: self,
                attribute: NSLayoutConstraint.Attribute.height,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: object,
                attribute: NSLayoutConstraint.Attribute.height,
                multiplier: 1,
                constant: 0
            )
        ];
        
        return constraints;
    }
}

@available(iOS 10.0, *)
@IBDesignable
class CenteredLabel: UILabel {
    override init(frame: CGRect){
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textAlignment = .center
        self.font = UIFont.systemFont(ofSize: 35.0)
    }
    
    func setFontSize(size: CGFloat) {
        self.font = UIFont.systemFont(ofSize: size)
        
    }
    
    func setText(text: String) {
        self.text = text
    }
    
    func setPos(point: CGPoint) {
        self.center = point
    }
    
    func generateConstraints(object: UIView, y: CGFloat) -> [NSLayoutConstraint]{
        let constraints = [
            NSLayoutConstraint(
                item: self,
                attribute: NSLayoutConstraint.Attribute.centerX,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: object,
                attribute: NSLayoutConstraint.Attribute.centerX,
                multiplier: 1,
                constant: 0
            ),
            NSLayoutConstraint(
                item: self,
                attribute: NSLayoutConstraint.Attribute.centerY,
                relatedBy: NSLayoutConstraint.Relation.lessThanOrEqual,
                toItem: object,
                attribute: NSLayoutConstraint.Attribute.centerY,
                multiplier: y,
                constant: 0
            ),
            NSLayoutConstraint(
                item: self,
                attribute: NSLayoutConstraint.Attribute.width,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: object,
                attribute: NSLayoutConstraint.Attribute.width,
                multiplier: 1,
                constant: 0
            ),
            NSLayoutConstraint(
                item: self,
                attribute: NSLayoutConstraint.Attribute.height,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: object,
                attribute: NSLayoutConstraint.Attribute.height,
                multiplier: 0.1,
                constant: 0
            )
        ];
        
        return constraints;
    }
}

//Text View
@IBDesignable
class TextBack: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        setup();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        
        setup();
    }
    
    private func setup() {
        self.layer.cornerRadius = 5.0;
        self.layer.borderWidth = 2;
        self.layer.borderColor = UIColor(displayP3Red: 240/255, green: 240/255, blue: 240/255, alpha: 1).cgColor;
    }
}

//TextInput
@IBDesignable
class TextInput: UITextField {
    var insetX: CGFloat = 20;
    var insetY: CGFloat = 20;
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        setup();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        
        setup();
    }
    
    private func setup(){
        self.backgroundColor = .white;
        self.layer.cornerRadius = 5.0;
        self.layer.borderWidth = 2;
        self.layer.borderColor = UIColor(displayP3Red: 240/255, green: 240/255, blue: 240/255, alpha: 1).cgColor;
        //self.translatesAutoresizingMaskIntoConstraints = false;
    }
    
    public func inset(x: CGFloat, y: CGFloat) {
        insetX = x;
        insetY = y;
    }
    
    //Placeholder position
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
    
    //Text position
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
    
    func generateConstraints(object: UIView, yM: CGFloat, yC: CGFloat) -> [NSLayoutConstraint]{
        let constraints = [
            NSLayoutConstraint(
                item: self,
                attribute: NSLayoutConstraint.Attribute.centerX,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: object,
                attribute: NSLayoutConstraint.Attribute.centerX,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: self,
                attribute: NSLayoutConstraint.Attribute.centerY,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: object,
                attribute: NSLayoutConstraint.Attribute.centerY,
                multiplier: yM,
                constant: yC
            ),
            NSLayoutConstraint(
                item: self,
                attribute: NSLayoutConstraint.Attribute.width,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: object,
                attribute: NSLayoutConstraint.Attribute.width,
                multiplier: 0.7,
                constant: insetX
            )
        ];
        
        return constraints;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true);
        return true;
    }
    
}

//Button
@IBDesignable
class Button: UIButton {
    var height = 50;
    var widthM = 0.5;
    
    @IBInspectable public var masterBackground: UIColor = UIColor(red: 219/255, green: 116/255, blue: 14/255, alpha: 1) {
        didSet {
            self.backgroundColor = masterBackground;
        }
    }
    
    @IBInspectable public var borderSize: CGFloat = CGFloat(0.0) {
        didSet {
            self.layer.borderWidth = borderSize;
        }
    }
    
    @IBInspectable public var borderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = borderColor.cgColor;
        }
    }
    
    @IBInspectable public var textColor: UIColor = UIColor.white {
        didSet {
            self.setTitleColor(textColor, for: .normal);
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        setup();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        
        setup();
    }
    
    private func setup() {
        self.backgroundColor = masterBackground;
        self.layer.cornerRadius = 5.0;
        self.setTitleColor(.white, for: .normal);
        
        //self.translatesAutoresizingMaskIntoConstraints = false;
    }
    
    func generateConstraints(object: UIView, yM: CGFloat, yC: CGFloat) -> [NSLayoutConstraint]{
        let constraints = [
            NSLayoutConstraint(
                item: self,
                attribute: NSLayoutConstraint.Attribute.centerX,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: object,
                attribute: NSLayoutConstraint.Attribute.centerX,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: self,
                attribute: NSLayoutConstraint.Attribute.centerY,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: object,
                attribute: NSLayoutConstraint.Attribute.centerY,
                multiplier: yM,
                constant: yC
            ),
            NSLayoutConstraint(
                item: self,
                attribute: NSLayoutConstraint.Attribute.width,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: object,
                attribute: NSLayoutConstraint.Attribute.width,
                multiplier: CGFloat(widthM),
                constant: 0
            ),
            NSLayoutConstraint(
                item: self,
                attribute: NSLayoutConstraint.Attribute.height,
                relatedBy: .equal,
                toItem: object,
                attribute: .height,
                multiplier: 0,
                constant: CGFloat(height)
            )
        ];
        
        return constraints;
    }
}

//Page
@IBDesignable
class Page: UIView {
    override init(frame: CGRect){
        super.init(frame: frame);
        
        setup();
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        
        setup();
    }
    
    private func setup(){
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func generateConstraints( object: UIView) -> [NSLayoutConstraint]{
        let constraints = [
            NSLayoutConstraint(
                item: self,
                attribute: NSLayoutConstraint.Attribute.centerX,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: object,
                attribute: NSLayoutConstraint.Attribute.centerX,
                multiplier: 1,
                constant: 0
            ),
            NSLayoutConstraint(
                item: self,
                attribute: NSLayoutConstraint.Attribute.centerY,
                relatedBy: NSLayoutConstraint.Relation.lessThanOrEqual,
                toItem: object,
                attribute: NSLayoutConstraint.Attribute.centerY,
                multiplier: 1,
                constant: 0
            ),
            NSLayoutConstraint(
                item: self,
                attribute: NSLayoutConstraint.Attribute.width,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: object,
                attribute: NSLayoutConstraint.Attribute.width,
                multiplier: 1,
                constant: 0
            ),
            NSLayoutConstraint(
                item: self,
                attribute: NSLayoutConstraint.Attribute.height,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: object,
                attribute: NSLayoutConstraint.Attribute.height,
                multiplier: 1,
                constant: 0
            )
        ];
        
        return constraints;
    }
}

//Tag
@IBDesignable
class Tag: CenteredLabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        setup();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        
        setup();
    }
    
    private func setup() {
        self.layer.cornerRadius = 10;
        self.backgroundColor = .white;
        
        self.layer.borderWidth = 2;
        self.layer.borderColor = UIColor.red.cgColor;
        self.setFontSize(size: 15.0);
    }
    
    func setBackgroundColor(color: UIColor) {
        self.backgroundColor = color;
    }
    
    func setForegroundColor(color: UIColor) {
        self.layer.borderColor = color.cgColor;
        self.textColor = color;
    }
    
}

//Form
@IBDesignable
class Form: UIScrollView {
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        setup();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        
        setup();
    }
    
    private func setup() {
        self.backgroundColor = UIColor.white;
        self.alpha = 0;
        
        self.translatesAutoresizingMaskIntoConstraints = false;
    }
    
    func generateConstraints(object: UIView) -> [NSLayoutConstraint] {
        let constraints = [
            NSLayoutConstraint(
                item: self,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: object,
                attribute: .centerX,
                multiplier: 1,
                constant: 0
            ),
            NSLayoutConstraint(
                item: self,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: object,
                attribute: .centerY,
                multiplier: 1,
                constant: 0
            ),
            NSLayoutConstraint(
                item: self,
                attribute: .width,
                relatedBy: .equal,
                toItem: object,
                attribute: .width,
                multiplier: 1,
                constant: 0
            ),
            NSLayoutConstraint(
                item: self,
                attribute: .height,
                relatedBy: .equal,
                toItem: object,
                attribute: .height,
                multiplier: 1,
                constant: 0
            )
        ];
        
        return constraints;
    }
}

//Link
@IBDesignable
class Link: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        setup();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        
        setup();
    }
    
    private func setup() {
        //Set the background color to transparent
        self.backgroundColor = UIColor(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 0);
        
        //Set the text color
        self.setTitleColor(UIColor(red: 219/255, green: 116/255, blue: 14/255, alpha: 1), for: .normal)
    }
}

//Rounded View
@IBDesignable
class RoundedView: UIView {
    @IBInspectable public var cornerRadius: CGFloat = CGFloat(10.0) {
        didSet {
            self.layer.cornerRadius = cornerRadius;
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
}
