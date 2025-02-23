//
//  ServiceResultsViewController.swift
//  EmPact-iOS
//
//  Created by Audrey Welch on 3/29/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import UIKit

class ServiceResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var subcategoriesTitleLabel: UILabel!
    @IBOutlet weak var subcategoriesTitleView: UIView!
    
    @IBAction func unwindToSubcategoriesVC(segue:UIStoryboardSegue) {
        networkController?.subcategoryNames = []
        networkController?.subcategoryDetails = []
        networkController?.tempCategorySelection = ""
        selectedSubcategory = ""
        
        if segue.identifier == "unwindToSubcategoriesVC" {
            networkController?.subcategoryDetails = []
            performSegue(withIdentifier: "unwindToSubcategoriesVC", sender: self)
        }
        
        if segue.identifier == "landingToServiceResultsSegue" {
            networkController?.subcategoryDetails = []
            performSegue(withIdentifier: "landingToServiceResultsSegue", sender: self)
        }
    }
    
    var googleMapsController: GoogleMapsController?
    var networkController: NetworkController?
    var cacheController: CacheController?
    
    var selectedSubcategory: String!
    var matchingObjects: [IndividualResource]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboard()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        searchBar.delegate = self
        
        setSearchTitle()
        setupTheme()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchBar.text = ""
        unwrapSubAtIndexPath()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchBarIsEmpty() == false {
            return matchingObjects?.count ?? 0
        } else {
            return networkController?.subcategoryDetails.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ServiceResultTableViewCell.reuseIdentifier, for: indexPath) as! ServiceResultTableViewCell
        
        cell.serviceNameLabel.textColor = UIColor.customLightBlack
        
        // Icons
        let placeColoredIcon = UIImage(named: "place")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        cell.serviceAddressIcon.tintColor = .customDarkPurple
        cell.serviceAddressIcon.image = placeColoredIcon

        let coloredPhoneIcon = UIImage(named: "phone")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        cell.servicePhoneIcon.tintColor = .customDarkPurple
        cell.servicePhoneIcon.image = coloredPhoneIcon
        
        let coloredClockIcon = UIImage(named: "clock")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        cell.serviceHoursIcon.tintColor = .customDarkPurple
        cell.serviceHoursIcon.image = coloredClockIcon
        
        // Button
        cell.viewDetailsButton.setTitle("  VIEW", for: .normal)
        cell.viewDetailsButton.setTitleColor(.white, for: .normal)
        cell.viewDetailsButton.backgroundColor = .customDarkPurple
        
        let launchColoredIcon = UIImage(named: "launch")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        cell.viewDetailsButton.tintColor = UIColor.white
        cell.viewDetailsButton.setImage(launchColoredIcon, for: .normal)
        cell.viewDetailsButton.setViewShadow(color: UIColor.black, opacity: 0.3, offset: CGSize(width: 1, height: 3), radius: 4, viewCornerRadius: 0)
        
        cell.viewDetailsButton.layer.cornerRadius = 5
        
        // Display the search results
        if matchingObjects != nil {
            guard let filteredSubcategoryDetail = matchingObjects?[indexPath.row] else { return cell }
            
            // Adjust fonts
            cell.serviceNameLabel.adjustsFontSizeToFitWidth = true
            cell.serviceAddressLabel.adjustsFontSizeToFitWidth = true
            cell.servicePhoneLabel.adjustsFontSizeToFitWidth = true
            cell.serviceHoursLabel.adjustsFontSizeToFitWidth = true
            
            // Name
            let alteredString = filteredSubcategoryDetail.name.replacingOccurrences(of: "Â", with: "")
            cell.serviceNameLabel.text = alteredString
            
            // Address
            if filteredSubcategoryDetail.address == nil || filteredSubcategoryDetail.address == "" {
                cell.serviceAddressLabel.text = "Address unavailable"
            } else {
                cell.serviceAddressLabel.text = filteredSubcategoryDetail.address
            }
            
            // Phone
            if filteredSubcategoryDetail.phone == nil || filteredSubcategoryDetail.phone as? String == "" {
                cell.servicePhoneLabel.text = "Phone number unavailable"
            } else if let phoneJSON = filteredSubcategoryDetail.phone {
                cell.servicePhoneLabel.text = phoneJSON as? String
            }
            
            // Hours
            if filteredSubcategoryDetail.hours == nil || filteredSubcategoryDetail.hours == "" {
                cell.serviceHoursLabel.text = "Please call for hours"
            } else {
                cell.serviceHoursLabel.text = filteredSubcategoryDetail.hours
            }
            
        // Display the subcategory resources
        } else {
            
            let subcategoryDetail = networkController?.subcategoryDetails[indexPath.row]
            
            // Name
            let alteredString = subcategoryDetail?.name.replacingOccurrences(of: "Â", with: "")
            cell.serviceNameLabel.text = alteredString
            
            // Address
            if subcategoryDetail?.address == nil || subcategoryDetail?.address == "" {
                cell.serviceAddressLabel.text = "Address unavailable"
            } else {
                cell.serviceAddressLabel.text = subcategoryDetail?.address
            }
            
            // Phone
            if subcategoryDetail?.phone == nil || subcategoryDetail?.phone as? String == ""{
                cell.servicePhoneLabel.text = "Phone number unavailable"
            } else if let phoneJSON = subcategoryDetail?.phone {
                cell.servicePhoneLabel.text = phoneJSON as? String
            }
            
            // Hours
            if subcategoryDetail?.hours == nil || subcategoryDetail?.hours == "" {
                cell.serviceHoursLabel.text = "Please call for hours"
            } else {
                cell.serviceHoursLabel.text = subcategoryDetail?.hours
            }
            
        }
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    @IBAction func spanishButtonClicked(_ sender: Any) {
        
        let alert = UIAlertController(title: "La traducción al español vendrá pronto.", message: "Spanish translation coming soon.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    // MARK: - Search Bar
    // Tell the delegate that the search button was tapped
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        networkController?.subcategoryDetails = []
        matchingObjects = []
        
        filterServiceResults()
        
        DispatchQueue.main.async {
            guard let unwrappedSearchTerm = self.networkController?.searchTerm else { return }
            self.subcategoriesTitleLabel.text = "Search Results: \(unwrappedSearchTerm)"
            self.title = "Search Results: \(unwrappedSearchTerm)"
            self.tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.reloadData()
    }
    
    func filterServiceResults() {
        
        DispatchQueue.main.async {
            guard let searchTerm = self.searchBar.text, !searchTerm.isEmpty else {
                // If no search term, display all of the search results
                //matchingObjects = self.networkController?.subcategoryDetails
                //NetworkController.filteredObjects = (self.networkController?.subcategoryDetails)!
                return
            }
            self.networkController?.searchTerm = searchTerm
            
            // Filter through array to see if keywords contain the text entered by user
            let matchingObjects = NetworkController.filteredObjects.filter({ $0.keywords.contains(searchTerm.lowercased()) || $0.name.contains(searchTerm.lowercased()) })
            
            // Set the value of matchingObjects to the results of the filter
            self.matchingObjects = matchingObjects

            self.tableView.reloadData()
        }
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchBar.text?.isEmpty ?? true
    }
    
    // MARK: - Private Methods
    private func unwrapSubAtIndexPath() {
        guard let unwrappedSubcategoryAtIndexPath = networkController?.subcategoryAtIndexPath else { return }
           if (networkController?.subcategoryDetails.count ?? 0) < 1 {
                   networkController?.fetchSubcategoryDetails(unwrappedSubcategoryAtIndexPath, completion: { (error) in
                   if let error = error {
                       NSLog("Error fetching subcategory details: \(error)")
                   }
                   
                   DispatchQueue.main.async {
                       self.tableView.reloadData()
                   }
               })
           }
    }
    
    private func setSearchTitle() {
        guard let unwrappedSearchTerm = networkController?.searchTerm,
        let subcategory = selectedSubcategory else { return }
        
           if networkController?.tempCategorySelection == "" || networkController?.tempCategorySelection == nil {
               self.title = "Search Results"
               subcategoriesTitleLabel.text = "Search Results: \(unwrappedSearchTerm)"
           } else if selectedSubcategory == "" || selectedSubcategory == nil {
               self.title = "Search Results"
               subcategoriesTitleLabel.text = "Search Results: \(unwrappedSearchTerm)"
           } else {
               guard let unwrappedTempCategorySelection = networkController?.tempCategorySelection else { return }
               self.title = "\(unwrappedTempCategorySelection) | \(String(describing: subcategory))"
               subcategoriesTitleLabel.text = "\(subcategory) | \(unwrappedTempCategorySelection) within New York City, NY"
               self.tableView.reloadData()
           }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "backToCategories" {
            networkController?.subcategoryDetails = []
            let _ = segue.destination as! CategoriesViewController
        }
        
        // Get the new view controller using segue.destination.
        guard let destination = segue.destination as? ServiceDetailViewController,
            let indexPath = tableView.indexPathForSelectedRow else { return }
        
        // Pass the search results array
        if matchingObjects != nil {
            //let serviceDetail = NetworkController.filteredObjects[indexPath.row]
            let serviceDetail = matchingObjects?[indexPath.row]
            destination.serviceDetail = serviceDetail
            destination.selectedSubcategory = selectedSubcategory
            destination.googleMapsController = googleMapsController
            destination.cacheController = cacheController
            destination.networkController = networkController
        } else {
            // Pass the subcategory results array
            destination.selectedSubcategory = selectedSubcategory
            destination.googleMapsController = googleMapsController
            destination.cacheController = cacheController
            destination.networkController = networkController
            
            if networkController?.subcategoryDetails == nil {
                return
            } else {
                let serviceDetail = networkController?.subcategoryDetails[indexPath.row]
                destination.serviceDetail = serviceDetail
            }
        }
    }
    
    // MARK: - Theme
    private func setupTheme() {
        
        subcategoriesTitleLabel.textColor = UIColor.white
        subcategoriesTitleView.backgroundColor = UIColor.customDarkPurple
        subcategoriesTitleLabel.backgroundColor = .customDarkPurple
        subcategoriesTitleView.layer.cornerRadius = 5
        
        navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.barTintColor = nil
               
        // Set navigation bar to the default color
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0)
        UIBarButtonItem.appearance().tintColor = UIColor(red:0.31, green:0.36, blue:0.46, alpha:1.0)
        
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        subcategoriesTitleView.setViewShadow(color: UIColor.black, opacity: 0.3, offset: CGSize(width: 1, height: 3), radius: 4, viewCornerRadius: 0)
    }
}
