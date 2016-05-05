//
//  ORKTiltStep.swift
//  Curvature
//
//  Created by Nikhil D'Souza on 5/5/16.
//  Copyright © 2016 Nikhil D'Souza. All rights reserved.
//

import UIKit
import ResearchKit

public class ORKTiltStep : ORKStep {
    
    /**
     An image to be displayed over the camera preview.
     
     The image is stretched to fit the available space while retaining its aspect ratio.
     When choosing a size for this asset, be sure to take into account the variations in device
     form factors.
     */
    
    required public override init(identifier: String) {
        super.init(identifier: identifier)
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var stuff: String! = "hi"
}