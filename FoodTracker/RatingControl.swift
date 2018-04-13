//
//  RatingControl.swift
//  TestIOS
//
//  Created by EvampSaanga on 3/31/18.
//  Copyright © 2018 EvampSaanga. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    
    //MARK: Properties
    private var ratingButtons=[UIButton]()
    var rating=0{
        didSet{
            updateButtonSelectionState()
        }
    }
    
    @IBInspectable var startSize: CGSize=CGSize(width: 44, height: 44){
        didSet{
            setupButtons()
        }
    }
    @IBInspectable var startCount: Int = 5 {
        didSet{
            setupButtons()
        }
    }

    //MARK: Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        setupButtons()
    }
    
    //MARK: Buttons Action
    @objc func ratingButtonTapped(button: UIButton){

        guard let  index = ratingButtons.index(of: button) else {
            fatalError("The button, \(button), is not the rating button array: \(ratingButtons)")
        }
        
        // Calculate the rating selected button
        let selectedRating = index+1
        
        if selectedRating == rating {
            // If selected star  represents the current  rating, reset the  rating to 0.
            rating = 0;
        }else{
            // Otherwise set rating to selected star
            rating=selectedRating
        }
        
    }
    
    private func updateButtonSelectionState(){
     
        for (index, button) in ratingButtons.enumerated(){
            // If the index of button is less than the rating, that button should be selected.
            button.isSelected = index<rating
            
            // Set the hint string for the currently selected star
            let hintString: String?
            if rating == index + 1{
                hintString="Tap to reset the rating to zero."
            }else{
                hintString=nil
            }
            
            // Calculate the value String
            let valueString: String
            switch(rating){
            case 0:
                valueString="No rating set."
            case 1:
                valueString="1 star set."
            default:
                valueString="\(rating) stars set."
            }
            
            // Assign the hint String and value String
            
            button.accessibilityHint=hintString
            button.accessibilityValue=valueString
            
        }
        
    }
    
    //MARK: Private methods
    private func setupButtons(){
        
        // Clear any existing button
        for button in ratingButtons{
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        // Load Button Images
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let hilightStar = UIImage(named: "hilightStar", in: bundle, compatibleWith:self.traitCollection)
        
        
        
        for index in 0..<startCount{
        // Create the Button
        let button = UIButton()

        button.setImage(emptyStar, for: .normal)
        button.setImage(filledStar, for: .selected)
        button.setImage(hilightStar, for: .highlighted)
        button.setImage(hilightStar, for: [.highlighted,.selected])
            
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: startSize.height).isActive = true
        button.widthAnchor.constraint(equalToConstant: startSize.width).isActive = true
//        button.contentEdgeInsets.top = 30
//        button.contentEdgeInsets.left = 30
        
        // Set accessibility l  abel
        button.accessibilityLabel = "Set \(index + 1) star rating"
            
        // Setup button action
        button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for:  .touchUpInside)

        // Add the button to stack
        addArrangedSubview(button)
            
        // Add new button to the ratting button Array
        ratingButtons.append(button)
            
        }
        
        updateButtonSelectionState()
        
    }
    
    
    
    
}
