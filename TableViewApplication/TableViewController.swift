//
//  TableViewController.swift
//  TableViewApplication
//
//  Created by farhan ali on 01/07/24.
//

import Foundation
import UIKit
//import SDWebImage

struct ImageData: Decodable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let url: String
    var downloadUrl: String
    var isSelected: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case author
        case width
        case height
        case url
        case downloadUrl //= "https://picsum.photos/id/0/5000/3333"
    }
}

class TableViewController: UITableViewController {
    
    var imageData: [ImageData] = []
    let networkService = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")

       
        tableView.rowHeight = UITableView.automaticDimension
                tableView.estimatedRowHeight = 250

        
        // Setup pull-to-refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        self.refreshControl = refreshControl
        
        fetchData()
    }
    
    @objc private func refreshData() {
        fetchData()
    }
    
    private func fetchData() {
        networkService.fetchData { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let imageData):
                    self?.imageData = imageData
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Failed to fetch data: \(error)")
                    // Handle error or show alert
                    let alert = UIAlertController(title: "Error", message: "Failed to fetch data. Please try again later.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
                self?.refreshControl?.endRefreshing()
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
           
        
        
        let data = imageData[indexPath.row]
        cell.textLabel?.text = data.author
        cell.detailTextLabel?.text = data.url
     
        if let imageUrl = URL(string: data.downloadUrl) {
                DispatchQueue.global().async {
                    if let imageData = try? Data(contentsOf: imageUrl) {
                        DispatchQueue.main.async {
                            cell.imageView?.image = UIImage(data: imageData)
                            cell.setNeedsLayout()
                        }
                    }
                }
            }
        
        return cell
    }
    
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! CustomTableViewCell

        let data = imageData[indexPath.row]
//        if data.isSelected
        
        
            if cell.checkboxButton.isSelected{
            showDescriptionAlert(description: imageData.description)
            print("Checkbox is selected for \(data.author)")
    
        } else {
            showCheckboxDisabledAlert()
        }
    }
    

    
    // MARK: - Helper methods
//       private
func showDescriptionAlert(description: String) {
        let alert = UIAlertController(title: "Image Description", message:"I was not provided with any DESCRIPTION", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func showCheckboxDisabledAlert() {
        let alert = UIAlertController(title: "Checkbox Disabled", message: "Please enable checkbox to see description.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case requestFailed
    case decodingFailure
    case imageLoadFailure
}
class NetworkService {
    
    func fetchData(completion: @escaping (Result<[ImageData], NetworkError>) -> Void) {
        guard let url = URL(string: "https://picsum.photos/v2/list") else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching data: \(error)")
                completion(.failure(.requestFailed))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200,
                  let data = data else {
                completion(.failure(.invalidResponse))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let imageData = try decoder.decode([ImageData].self, from: data)
                completion(.success(imageData))
            } catch {
                print("Error decoding data: \(error)")
                completion(.failure(.decodingFailure))
            }
        }.resume()
    }
}
