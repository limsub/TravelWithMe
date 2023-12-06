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
    
    
//    let mainView = SelectLocationView()
//    
//    override func loadView() {
//        self.view = mainView
//    }
    
    
    
    let button = UIButton()
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.size.equalTo(200)
            make.center.equalTo(view)
        }
        button.addTarget(self , action: #selector(clicked), for: .touchUpInside)
        
        
//        settingSearch()
//        settingTableView()
    }
    
//    func settingSearch() {
//        mainView.searchBar.delegate = self
//        
//        searchCompleter.delegate = self
//        searchCompleter.resultTypes = .pointOfInterest
//    }
//    
//    func settingTableView() {
//        mainView.tableView.delegate = self
//        mainView.tableView.dataSource = self
//    }
    
    
    
    
    
    @objc
    func clicked() {
        delegate?.sendLocation?(name: "청년취업사관학교 영등포캠퍼스", latitude: 37.517742, longitude: 126.886463)
        
        navigationController?.popViewController(animated: true)
    }
}

//extension SelectLocationViewController: UISearchBarDelegate {
//    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        // 서치바에 입력할 때마다 텍스트 넘겨주기
//        if searchText.count != 0 {
//            searchCompleter.queryFragment = searchText
//        }
//    }
//    
//}
//
//extension SelectLocationViewController: MKLocalSearchCompleterDelegate {
//    
//    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
//        searchResults = completer.results   // 결과 데이터 받기
//        print("서치 결과 : \(searchResults)")
//        mainView.tableView.reloadData()
//    }
//    
//    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
//        print("location 가져오기 에러 발생 : \(error.localizedDescription)")
//    }
//    
//}
//
//
//extension SelectLocationViewController: UITableViewDataSource, UITableViewDelegate {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return searchResults.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectLocationTableViewCell", for: indexPath)
//        
//        cell.textLabel?.text = searchResults[indexPath.row].title
//        
//        return cell
//    }
//    
//    
//}
