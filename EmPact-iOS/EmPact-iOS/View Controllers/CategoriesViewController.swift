//
//  CategoriesViewController.swift
//  EmPact-iOS
//
//  Created by Madison Waters on 3/29/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import UIKit
import CoreLocation

// MARK: - Hamburger Menu protocol
protocol MenuActionDelegate {
    func openSegue(_ segueName: String, sender: AnyObject?)
    func reopenMenu()
}

class CategoriesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var helpLabel: UILabel!
    @IBOutlet weak var helpView: UIView!
    
    @IBOutlet weak var categoriesScrollView: UIScrollView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewSearchBar: UISearchBar!
    
    @IBOutlet weak var nearestShelterView: UIView!
    @IBOutlet weak var nearestShelterLabel: UILabel!
    @IBOutlet weak var shelterView: UIView!
    @IBOutlet weak var shelterNameLabel: UILabel!
    
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var shelterAddressLabel: UILabel!
    
    
    @IBOutlet weak var distanceView: UIView!
    @IBOutlet weak var shelterDistanceLabel: UILabel!
    @IBOutlet weak var shelterDurationLabel: UILabel!
    
    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var shelterPhoneLabel: UILabel!
    @IBOutlet weak var shelterHoursLabel: UILabel!
    @IBOutlet weak var viewMapButton: UIButton!
    @IBOutlet weak var viewDetailsButton: UIButton!
    
    @IBOutlet weak var addressImageView: UIImageView!
    @IBOutlet weak var transitImageView: UIImageView!
    @IBOutlet weak var walkImageView: UIImageView!
    @IBOutlet weak var phoneImageView: UIImageView!
    @IBOutlet weak var hoursImageView: UIImageView!
    
    let categoryController = CategoryController()
    let networkController = NetworkController()
    let cacheController = CacheController()
    
    var serviceCoordinates: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Delegate & DataSource
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        collectionViewSearchBar.delegate = self
        
        setupTheme()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        networkController.fetchCategoryNames { (error) in
            
            if let error = error {
                NSLog("Error fetching categories: \(error)")
            }
            DispatchQueue.main.async {
                self.categoriesCollectionView.reloadData()
            }
        }
    }
    
    @IBAction func viewMapClicked(_ sender: Any) {
        
        guard let unwrappedServiceCoordinate = serviceCoordinates else { return }
        
//        print("Launch Google Maps URL: https://www.google.com/maps/dir/?api=1&origin=\(unwrappedServiceCoordinate.latitude),\(unwrappedServiceCoordinate.longitude)&destination=\(serviceDetail!.latitude!),\(serviceDetail!.longitude!)&travelmode=transit")
//        
//        if let url = URL(string: "https://www.google.com/maps/dir/?api=1&origin=\(unwrappedServiceCoordinate.latitude),\(unwrappedServiceCoordinate.longitude)&destination=\(serviceDetail!.latitude!),\(serviceDetail!.longitude!)&travelmode=transit") {
//            
//            UIApplication.shared.open(url, options: [:])
//        }
    }
    @IBAction func viewDetailsClicked(_ sender: Any) {
        performSegue(withIdentifier: "shelterNearestYouSegue", sender: nil)
    }
    
    
    @IBAction func unwindToSubcategoriesVC(segue:UIStoryboardSegue) {
        //dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return networkController.categoryNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCollectionViewCell.reuseIdentifier, for: indexPath) as! CategoriesCollectionViewCell
        
        let category = networkController.categoryNames[indexPath.row]
        cell.categoryNameLabel.text = category.uppercased()
        
        categoryController.getIconImage(from: category)
        cell.categoryImageView.image = categoryController.iconImage
        
        cell.cellView.backgroundColor = UIColor.customDarkGray
        cell.cellView.layer.cornerRadius = 10
        cell.cellView.layer.borderColor = UIColor.white.cgColor
        cell.cellView.layer.borderWidth = 2
        
        cell.cellView.setViewShadow(color: UIColor.black, opacity: 0.5, offset: CGSize(width: 0, height: 1), radius: 1, viewCornerRadius: 0)
        
        cell.categoryNameLabel.textColor = UIColor.white
        
//        cell.contentView.setViewShadow(color: UIColor.black, opacity: 0.5, offset: CGSize(width: 0, height: 1), radius: 1, viewCornerRadius: 0)
//        cell.contentView.layer.cornerRadius = 10
//        cell.contentView.layer.borderColor = UIColor.customLightestGray.cgColor
//        cell.contentView.layer.borderWidth = 2
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let categoryAtIndexPath = networkController.categoryNames[indexPath.row]
        networkController.tempCategorySelection = categoryAtIndexPath

        performSegue(withIdentifier: "modalSubcategoryMenu", sender: nil)
    }
    
    // MARK: - UI Search Bar
    
    // Tell the delegate the search button was tapped
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
        // Filter the results based on the text in the search bar
        filterServiceResults()
        
        // Perform segue to Service Results View Controller
        performSegue(withIdentifier: "searchResultsSegue", sender: nil)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func filterServiceResults() {
        
        // Grab the text, make sure it's not empty
        guard let searchTerm = self.collectionViewSearchBar.text, !searchTerm.isEmpty else {
            return
        }
        
        var matchingObjects = NetworkController.filteredObjects.filter({ $0.keywords.contains(searchTerm.lowercased()) })
        
        networkController.subcategoryDetails = matchingObjects
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "searchResultsSegue" {
            let searchDestinationVC = segue.destination as! ServiceResultsViewController
            searchDestinationVC.networkController = networkController
            //searchDestinationVC.selectedSubcategory = 
        }
        
        if let destinationViewController = segue.destination as? SubcategoriesViewController {
            destinationViewController.transitioningDelegate = self
            destinationViewController.interactor = interactor
            destinationViewController.menuActionDelegate = self
        }
        
        if segue.identifier == "modalSubcategoryMenu" {
            let destination = segue.destination as! SubcategoriesViewController
            destination.networkController = networkController
            destination.selectedCategory = networkController.tempCategorySelection
        }
    }
    
    // MARK: - Theme
    
    func setupTheme() {
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0)
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        helpView.backgroundColor = UIColor.customDarkPurple
        helpView.layer.cornerRadius = 5
        helpLabel.textColor = UIColor.white
        
        viewDetailsButton.setTitle("  VIEW DETAILS", for: .normal)
        viewDetailsButton.setTitleColor(.white, for: .normal)
        viewDetailsButton.titleLabel?.font = Appearance.boldFont
        viewDetailsButton.backgroundColor = .customDarkPurple
        viewDetailsButton.layer.cornerRadius = 5
        
        let launchColoredIcon = UIImage(named: "launch")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        viewDetailsButton.tintColor = .white
        viewDetailsButton.setImage(launchColoredIcon, for: .normal)
        
        viewMapButton.setTitle("  View Map", for: .normal)
        viewMapButton.setTitleColor(UIColor.customDarkPurple, for: .normal)
        viewMapButton.backgroundColor = .white
        viewMapButton.layer.borderWidth = 0.25
        viewMapButton.layer.borderColor = UIColor.lightGray.cgColor
        
        let nearMeColoredIcon = UIImage(named: "near_me")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        viewMapButton.tintColor = .customDarkPurple
        viewMapButton.setImage(nearMeColoredIcon, for: .normal)
        
        shelterNameLabel.textColor = .customDarkBlack
        shelterNameLabel.font = Appearance.regularFont
        
        nearestShelterLabel.textColor = .customDarkPurple
        nearestShelterLabel.font = Appearance.boldFont
        nearestShelterView.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0)
        
        helpView.backgroundColor = UIColor.customDarkPurple
        helpView.layer.cornerRadius = 5
        helpLabel.textColor = UIColor.white
        
        // Icon Colors
        let placeColoredIcon = UIImage(named: "place")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        addressImageView.tintColor = .customDarkPurple
        addressImageView.image = placeColoredIcon
        
        let busColoredIcon = UIImage(named: "bus")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        transitImageView.tintColor = .customDarkPurple
        transitImageView.image = busColoredIcon
        
        let walkColoredIcon = UIImage(named: "walk")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        walkImageView.tintColor = .customDarkPurple
        walkImageView.image = walkColoredIcon
        
        let phoneColoredIcon = UIImage(named: "phone")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        phoneImageView.tintColor = .customDarkPurple
        phoneImageView.image = phoneColoredIcon
        
        let clockColoredIcon = UIImage(named: "clock")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        hoursImageView.tintColor = .customDarkPurple
        hoursImageView.image = clockColoredIcon
        
        shelterView.setViewShadow(color: UIColor.black, opacity: 0.3, offset: CGSize(width: 0, height: 1), radius: 1, viewCornerRadius: 0)
        
        addressView.layer.borderWidth = 0.25
        addressView.layer.borderColor = UIColor.lightGray.cgColor
        distanceView.layer.borderWidth = 0.25
        distanceView.layer.borderColor = UIColor.lightGray.cgColor
        contactView.layer.borderWidth = 0.25
        contactView.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    // MARK: - Hamburger Menu Variables
    let interactor = Interactor()
    var seguePerformed = false
}

// MARK: - Hamburger Menu Extensions
extension CategoriesViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentMenuAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissMenuAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}

extension CategoriesViewController : MenuActionDelegate {
    func openSegue(_ segueName: String, sender: AnyObject?) {
        dismiss(animated: true){
            self.performSegue(withIdentifier: segueName, sender: sender)
        }
    }
    
    func reopenMenu(){
        performSegue(withIdentifier: "showResultsTableVC", sender: nil)
        
    }
}

//showResultsTableVC

//networkController.fetchSubcategoriesNames(SubCategory.shelters)       // Shelters: WORKS!!!!
//networkController.fetchSubcategoriesNames(SubCategory.education)      // Phone: Expected to decode Int but found a string/data
//networkController.fetchSubcategoriesNames(SubCategory.legal)          // Phone: Expected to decode Int but found a string/data
//networkController.fetchSubcategoriesNames(SubCategory.food)           // Phone: Expected to decode Int but found a string/data
//networkController.fetchSubcategoriesNames(SubCategory.healthcare)     // Details: Expected to decode String but found a dictionary instead
//networkController.fetchSubcategoriesNames(SubCategory.outreach)       // Convert from Kebab case
//networkController.fetchSubcategoriesNames(SubCategory.hygiene)        // Phone: Expected to decode Int but found a string/data
//networkController.fetchSubcategoriesNames(SubCategory.jobs)           // Phone: Expected to decode Int but found a string/data
