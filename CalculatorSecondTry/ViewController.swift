//
//  ViewController.swift
//  CalculatorSecondTry
//
//  Created by Erik Alfredsson on 2014-06-10.
//  Copyright (c) 2014 Erik Alfredsson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var displayLabel = UILabel()
    let maximumDigits: Int = 9
    var currentInputValue = String()
    
    var operator = Operator()
    var buttonArray = [
        "AC", "C", "%", "/",
        "7","8","9", "X",
        "4","5","6","-",
        "1","2","3","+",
        "0", ".", "=", "BG"
    ]
    var viewArray = []
    
    var imageArray = [
        "background2.jpg",
//        "background5.jpg",
//        "background3.jpg",
        "background4.jpg",
//        "background1.jpg"
    ]
    var currentImage = 0
    @IBOutlet var backgroundImgView : UIImageView = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setNeedsStatusBarAppearanceUpdate()
        backgroundImgView.image = UIImage(named: imageArray[currentImage])
        
        let screenHeight: CGFloat = self.view.frame.size.height
        let screenWidht: CGFloat = self.view.frame.size.width
        let thirdOfScreen: CGFloat = screenWidht/3;
        
        //**overlayview iOS7**//
        let visualEffectView = UIView()
        visualEffectView.backgroundColor = UIColor.blackColor()
        visualEffectView.alpha = 0.7
        //*****************//
        
        visualEffectView.frame=view.frame
        view.addSubview(visualEffectView)
        
        //displayview
        let displayView = UIView()
        displayView.backgroundColor = UIColor.grayColor()
        displayView.alpha = 0.85
        displayView.frame = CGRectMake(4, 20, screenWidht-8, 146)

        displayLabel.frame = CGRectMake((displayView.frame.origin.x+10), displayView.frame.size.height/2+10, displayView.frame.size.width-40, displayView.frame.size.height/2)
        displayLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 85)
        displayLabel.textColor = UIColor.whiteColor()
        displayLabel.textAlignment = .Right
        displayLabel.text = "0"
        displayLabel.adjustsFontSizeToFitWidth = true
        view.addSubview(displayLabel)
        
        visualEffectView.addSubview(displayView)
        
        var count = 0
        var frame = CGRect()
        var width = 75

        for row: Int in 0..5 {
            for column: Int in 0..4 {

                frame = CGRect(x: 4+79*column, y: 172+(row*79), width: width, height: 75)
                
                var digitView = UIView()
                digitView.backgroundColor = displayView.backgroundColor
                digitView.alpha = displayView.alpha
                
                digitView.frame = frame
                digitView.tag = count
                viewArray.addObject(digitView)
                
                var digitRec = UILongPressGestureRecognizer(target: self, action: "digitPressed:")
                digitRec.minimumPressDuration=0.0
                digitView.addGestureRecognizer(digitRec)
                
                var label = UILabel(frame: frame)
                label.textAlignment = .Center
                label.font = UIFont(name: "HelveticaNeue-UltraLight", size: 40)
                label.userInteractionEnabled = false
                label.textColor = UIColor.whiteColor()
                label.text = buttonArray[count]
                
                view.addSubview(label)
                visualEffectView.addSubview(digitView)
                
                count++
            }
        }
    }
    
    func digitPressed(gesture: UILongPressGestureRecognizer){
        switch gesture.state {
        case .Began, .Possible:
            println("touch")
            deselectOperator()
            animateDigits(gesture.view.tag, completionState: 1.0)
            var input: String = buttonArray[gesture.view.tag]
            
            switch input {
            case "BG":
                self.changeBackground()
            case "AC":
                operator.clearAll()
                self.clearUI()
            case "C":
                operator.clear()
                self.clearUI()
            case "%",
            "/",
            "X",
            "-",
            "+":
                animateDigits(gesture.view.tag, completionState: 0.9)
                operatorPressed(input)
            case "=":
                updateUI(operator.solve())
            case ".":
                if !operator.hasDecimal {
                    currentInputValue = currentInputValue+"\(input)"
                }
                operator.hasDecimal = true
                operator.hasValidInput = true
                operator.inputOnCurrent = true
                updateUI(currentInputValue)
            default:
                var displayLength: Int = countElements(currentInputValue)
                
                if displayLength < maximumDigits || !operator.inputOnCurrent{
                    if operator.currentSlotIsEmpty() && input == "0" {
                        break
                    }else if operator.currentSlotIsEmpty() {
                        currentInputValue = "\(input)"
                    }else {
                        currentInputValue = currentInputValue + "\(input)"
                    }
                }
                if operator.hasDecimal {
                    updateUI(currentInputValue)
                }else {
                    updateUI(operator.formatResult(currentInputValue.bridgeToObjectiveC().doubleValue))
                }
                
                operator.inputOnCurrent = true
            }
        case UIGestureRecognizerState.Ended:
            var value = currentInputValue.bridgeToObjectiveC().doubleValue
            operator.saveCurrentValue(value)
        default:
            break
        }
    }
    
    func operatorPressed(operation: String) {
        if operator.shouldCalculate() {
            operator.saveCurrentValue(currentInputValue.bridgeToObjectiveC().doubleValue)
            updateUI(operator.solve())
        }else {
            operator.changeInputSlot()
        }
        operator.currentOperation=operation
        operator.getReadyForNewInput()
    }
    
    func digitPressed(digit: String) {
        
    }
    
    func animateDigits(inputTag: Int, completionState: CGFloat) {
        for obj: AnyObject in viewArray {
            if let view = obj as? UIView {
                if view.tag == inputTag {
                    UIView.animateKeyframesWithDuration(0.5, delay: 0.0, options: nil, animations: {
                        UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.2, animations: {
                            view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.7, 0.7)
                            })
                        UIView.addKeyframeWithRelativeStartTime(0.2, relativeDuration: 0.3, animations: {
                            view.transform = CGAffineTransformScale(CGAffineTransformIdentity, completionState, completionState)
                            })
                        }, completion: nil)
                }
            }
        }
    }
    
    func deselectOperator() {
        for obj: AnyObject in viewArray {
            if let view = obj as? UIView {
                UIView.animateWithDuration(0.2, animations: {
                    view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0)
                    })
            }
        }
    }
    
    func changeBackground() {
        if (currentImage+1) <= (imageArray.count-1) {
            var imageName: String = imageArray[(currentImage+1)]
            backgroundImgView.image = UIImage(named: imageName)
            currentImage++
        }else {
            currentImage = 0
            var imageName: String = imageArray[(currentImage)]
            backgroundImgView.image = UIImage(named: imageName)
        }
    }

    func updateUI(updatedText: String) {
        displayLabel.text = updatedText
    }
    
    func clearUI() {
        displayLabel.text = "0"
        currentInputValue = displayLabel.text
        deselectOperator()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

