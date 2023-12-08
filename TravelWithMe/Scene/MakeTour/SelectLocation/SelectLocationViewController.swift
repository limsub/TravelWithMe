//
//  SelectLocationViewController.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/26.
//

import UIKit
import MapKit

class SelectLocationViewController: BaseViewController {
    
    var delegate: SelectTourLocationDelegate?
    
    private var searchCompleter = MKLocalSearchCompleter()
    private var searchResults = [MKLocalSearchCompletion]()
    
    
    private var localSearch: MKLocalSearch? = nil {
        willSet {
            localSearch?.cancel()
        }
    }
    
    let mainView = SelectLocationView()
    
    override func loadView() {
        self.view = mainView
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingSearch()
        settingTableView()
    }
    
    func settingSearch() {
        mainView.searchBar.delegate = self
        
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .pointOfInterest
    }
    
    func settingTableView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
}

extension SelectLocationViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // 서치바에 입력할 때마다 텍스트 넘겨주기
        if searchText.count != 0 {
            searchCompleter.queryFragment = searchText
        }
    }
    
}

extension SelectLocationViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results   // 결과 데이터 받기
        print("서치 결과 : \(searchResults)")
        
        mainView.tableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("location 가져오기 에러 발생 : \(error.localizedDescription)")
    }
    
}


extension SelectLocationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectLocationTableViewCell", for: indexPath) as? SelectLocationTableViewCell else { return UITableViewCell() }
        
        cell.titleLabel.text = searchResults[indexPath.row].title
        cell.subTitleLabel.text = searchResults[indexPath.row].subtitle
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        search(for: searchResults[indexPath.row])
    }
    
    func search(for suggestedCompletion: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: suggestedCompletion)
        search(using: searchRequest)
    }
    
    func search(using searchRequest: MKLocalSearch.Request) {
        searchRequest.resultTypes = .pointOfInterest
        
        localSearch = MKLocalSearch(request: searchRequest)
        
        localSearch?.start { [weak self] (response, error) in
            guard error == nil else { return }
            
            guard let place = response?.mapItems[0] else { return }
            
            let placeName = place.name ?? ""
            let placeAddress = place.placemark.title ?? ""
            let placeLatitude = Double(place.placemark.coordinate.latitude)
            let placeLongtitude = Double(place.placemark.coordinate.longitude)
            
            
            self?.delegate?.sendLocation?(
                name: placeName,
                address: placeAddress,
                latitude: placeLatitude,
                longitude: placeLongtitude
            )
            
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
}
