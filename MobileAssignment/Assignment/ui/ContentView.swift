//
//  ContentView.swift
//  Assignment
//
//  Created by Kunal on 03/01/25.
//


import UIKit

class ContentViewController: UIViewController{
    
    
    
    private let viewModel = ContentViewModel()
    private var devices: [DeviceData] = []
    private var filteredDevices: [DeviceData] = []
    private var tableView: UITableView!
    private let searchController = UISearchController(searchResultsController: nil)
    private var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DeviceCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        

        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        //api data fetch
        setupSearchBar()
        fetchData()
        
        navigationItem.title = "Computers"
        view.backgroundColor = .white
        
    }
    
    func fetchData() {
        activityIndicator.startAnimating()
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            if let data = self.viewModel.data {
//                self.devices = data
//                print(data)
//                
//                self.tableView.reloadData()
//            }
        viewModel.fetchDevices{ [weak self] devices in
            guard let self = self else { return}
            self.devices = devices
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.tableView.isHidden = false
        }
    }
    private  var isFiltering:Bool{
        searchController.isActive &&
        !(searchController.searchBar.text?.isEmpty ?? true)
    }
    private func setupSearchBar(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Devices"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
}

extension ContentViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  isFiltering ? filteredDevices.count: devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell", for: indexPath)
        let device = isFiltering ? filteredDevices[indexPath.row]
        :devices[indexPath.row]
        cell.textLabel?.text = device.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let device = isFiltering ? filteredDevices[indexPath.row]
        :devices[indexPath.row]
        let detailVC = DetailViewController(device: device)
        navigationController?.pushViewController(detailVC, animated: true)
      
    }
}

extension ContentViewController: UISearchResultsUpdating{
func updateSearchResults(for searchController: UISearchController) {
    let searchText = searchController.searchBar.text ?? ""
    filteredDevices = devices.filter{
        $0.name.lowercased().contains(searchText.lowercased())
    }
    tableView.reloadData()
        
    }
}



