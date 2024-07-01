
//

import UIKit

class splashViewController: UIViewController {

    private let splashImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "transparent.png")) // Replace with your desired image name
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(splashImageView)
        
        splashImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            splashImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            splashImageView.widthAnchor.constraint(equalToConstant:250),
            splashImageView.heightAnchor.constraint(equalToConstant: 250)
        ])
        
//        splashImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//                splashImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//                splashImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//                splashImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

               
        
        
        // Navigate to TableView after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.navigateToTableView()
        }
    }
    
    private func navigateToTableView() {
//        let tableViewController = TableViewController()
//        navigationController?.pushViewController(tableViewController, animated: true)
        
        
        
        let tableViewController = TableViewController()
                let navigationController = UINavigationController(rootViewController: tableViewController)
                navigationController.navigationBar.isHidden = true // Optional: Hide navigation bar if needed
                UIApplication.shared.windows.first?.rootViewController = navigationController
                UIApplication.shared.windows.first?.makeKeyAndVisible()
        
        
    }
}
