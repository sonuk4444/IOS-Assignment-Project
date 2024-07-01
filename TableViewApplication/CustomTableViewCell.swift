
import Foundation
import UIKit
class CustomTableViewCell: UITableViewCell {
 
    private let cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
      let checkboxButton: UIButton = {
        let button = UIButton(type: .custom)
         button.setImage(UIImage(systemName: "square"), for: .normal)
         button.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
button.addTarget(self, action: #selector(checkboxButtonTapped(_:)), for: .touchUpInside)
              
         
         return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        

        
        contentView.addSubview(cellImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(checkboxButton)
        
 
        
        // Example constraints:
        cellImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        checkboxButton.translatesAutoresizingMaskIntoConstraints = false
        

        
        NSLayoutConstraint.activate([
//            cellImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cellImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            cellImageView.widthAnchor.constraint(equalToConstant: 100),
            cellImageView.heightAnchor.constraint(equalToConstant: 100),
            
            
            
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: cellImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            

            
//            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
//            descriptionLabel.leadingAnchor.constraint(equalTo: cellImageView.trailingAnchor, constant: 16),
//            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
        
            
            checkboxButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 78),
            checkboxButton.leadingAnchor.constraint(equalTo: cellImageView.trailingAnchor, constant: -26),
            checkboxButton.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -4)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with imageData: ImageData) {
        // Configure cell with data
        titleLabel.text = imageData.author
        descriptionLabel.text = "ID: \(imageData.id)\nDimensions: \(imageData.width) x \(imageData.height)"
    
        checkboxButton.isSelected = imageData.isSelected

        // Example for loading image asynchronously (using URL or any other method)
     
        if let url = URL(string: imageData.url) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.cellImageView.image = UIImage(data: data)
                    }
                }
            }
        }
    }
    
    @objc func checkboxButtonTapped(_ sender: UIButton) {
           sender.isSelected = !sender.isSelected
//        sender.isSelected.toggle()
              print("Checkbox tapped")
    }
    
}
