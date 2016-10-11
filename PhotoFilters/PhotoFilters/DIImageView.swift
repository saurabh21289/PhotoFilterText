//
//  DIImageView.swift
//  DIImageVIew
//
//  Created by Daniel Inoa on 7/31/16.
//  Copyright © 2016 Daniel Inoa. All rights reserved.
//

import UIKit

var textOnPhoto = "test"

class DIImageView: UIImageView, UITextFieldDelegate {
    
    @IBOutlet weak var myBtn: UIBarButtonItem!
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    fileprivate func configure() {
        addSubview(caption)
        //addGestureRecognizer(tapRecognizer)
        addGestureRecognizer(panRecognizer)
        isUserInteractionEnabled = true
        captionCenterY = bounds.height/2
    }
    
    // MARK: - Subviews
    
    fileprivate lazy var caption: UITextField = {
        var x = 0
        let textField = UITextField()
        textField.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        textField.textAlignment = .center
        textField.textColor = UIColor.white
        textField.tintColor = UIColor.white
        textField.keyboardAppearance = .dark
        textField.returnKeyType = UIReturnKeyType.done //Turn return button to "Done"
        textField.delegate = self
        x = x+1
        print("this is a test!", x)
        return textField
    }()
    
    fileprivate var captionCenterY: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let captionSize = CGSize(width: bounds.size.width, height: 32)
        caption.bounds = CGRect(origin: CGPoint.zero, size: captionSize)
        caption.center = CGPoint(x: center.x, y: captionCenterY)
    }
    
    // MARK: - Gestures
    
    fileprivate lazy var tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
    fileprivate lazy var panRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panned(_:)))
    
    func tapped(_ sender: AnyObject) {
        if caption.isFirstResponder {
            caption.resignFirstResponder()
            caption.isHidden = caption.text?.isEmpty ?? false
        } else {
            caption.becomeFirstResponder()
            caption.isHidden = false
        }
    }
    
    func panned(_ sender: AnyObject) {
        guard let panRecognizer = sender as? UIPanGestureRecognizer else { return }
        let location = panRecognizer.location(in: self)
        captionCenterY = location.y
    }
    
    // MARK: - Text Field Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let captionFont = textField.font , textField == caption && !string.isEmpty else { return true }
        let textSize = textField.text?.size(attributes: [NSFontAttributeName: captionFont]) ?? CGSize.zero
        
        //The statement below prints true for each key-stroke
        //print (textSize.width + 16 < textField.bounds.size.width)
        //x = textField.text!
        //print (x)
        //return (true)
        return (textSize.width + 16 < textField.bounds.size.width)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //print(x)
        
        guard caption == textField else { return true }
        caption.resignFirstResponder()
        caption.isHidden = caption.text?.isEmpty ?? true
        //print(caption.resignFirstResponder())
        //print (caption)
        textOnPhoto = textField.text! //Updating the global variabl when the user hits "Done"
        print(textOnPhoto)
        return caption.resignFirstResponder()
    }
    
}
