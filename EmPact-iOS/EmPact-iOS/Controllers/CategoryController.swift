//
//  CategoryController.swift
//  EmPact-iOS
//
//  Created by Madison Waters on 4/4/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import UIKit

class CategoryController {
    
    var iconImage: UIImage!
    var subcategoryIconImage: UIImage!
    var tempCategoryName = ""
    var tempSubcategoryName = ""

    func getIconImage() {
        
        if tempCategoryName == "Shelters" {
            iconImage = UIImage(named: CategoryIconImages.shelter.rawValue)
        } else if tempCategoryName == "Health Care" {
            iconImage = UIImage(named: CategoryIconImages.healthcare.rawValue)
        } else if tempCategoryName == "Food" {
            iconImage = UIImage(named: CategoryIconImages.food.rawValue)
        } else if tempCategoryName == "Hygiene" {
            iconImage = UIImage(named: CategoryIconImages.hygiene.rawValue)
        } else if tempCategoryName == "Outreach Services" {
            iconImage = UIImage(named: CategoryIconImages.outreach.rawValue)
        } else if tempCategoryName == "Education" {
            iconImage = UIImage(named: CategoryIconImages.education.rawValue)
        } else if tempCategoryName == "Legal Administrative" {
            iconImage = UIImage(named: CategoryIconImages.legal.rawValue)
        } else if tempCategoryName == "Jobs" {
            iconImage = UIImage(named: CategoryIconImages.jobs.rawValue)
        }
    }
    
    func getSubcategoryIconImage() {
        
        if tempSubcategoryName == "Men" {
            subcategoryIconImage = UIImage(named: SubcategoryIconImages.men.rawValue)
        } else if tempSubcategoryName == "Women" {
            subcategoryIconImage = UIImage(named: SubcategoryIconImages.women.rawValue)
        } else if tempSubcategoryName == "Youth" {
            subcategoryIconImage = UIImage(named: "abuse")
        } else {
            subcategoryIconImage = UIImage(named: "church")
        }
    }
}
