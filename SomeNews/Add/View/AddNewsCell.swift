import UIKit
import Kingfisher

class AddNewsCell: UITableViewCell {
    
    var news: News!
    
    var imageNewsView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.layer.cornerRadius = 8
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        return iv
    }()
    
    var titleNewsLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name:"HelveticaNeue-Bold", size: 18.0)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.contentMode = .topLeft
        lbl.numberOfLines = 0
        
        return lbl
    }()
    
    var textNewsLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name:"HelveticaNeue", size: 16.0)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.contentMode = .topLeft
        lbl.numberOfLines = 0
        
        return lbl
    }()
    
    var labelStackView: UIStackView = {
       let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 0
        sv.distribution = .fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    var favouriteButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        let emptyImage = UIImage(named: "emptyFavourite")
        let filledImage = UIImage(named: "filledFavourite")
        btn.setImage(emptyImage, for: .normal)
        btn.setImage(filledImage, for: .highlighted)
        return btn
    }()
    
    public func setup(withNews: News) {
        self.news = withNews
        self.backgroundColor = .white
        setupImageNewsView()
        setupLabelsStackView()
        setupFavouriteButton()
    }
    
    private func setupImageNewsView() {
        if let URL = URL(string: news.urlString) {
            imageNewsView.kf.setImage(with: URL)
        }
//        guard let image = UIImage(named: "macintosh") else { return }
        
        self.addSubview(imageNewsView)
//        imageNewsView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        imageNewsView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
//        imageNewsView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
//        imageNewsView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        imageNewsView.heightAnchor.constraint(equalTo: imageNewsView.widthAnchor, multiplier: 1.1, constant: 0).isActive = true
        
        imageNewsView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8).isActive = true
        imageNewsView.widthAnchor.constraint(equalTo: imageNewsView.heightAnchor, multiplier: 1).isActive = true
        imageNewsView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageNewsView.leftAnchor.constraint(equalToSystemSpacingAfter: self.leftAnchor, multiplier: 2).isActive = true
    }
    
    private func setupLabelsStackView() {
        titleNewsLabel.text = news.title
        textNewsLabel.text = news.text
        
        labelStackView.addArrangedSubview(titleNewsLabel)
        labelStackView.addArrangedSubview(textNewsLabel)
        
        self.addSubview(labelStackView)
        
        labelStackView.leftAnchor.constraint(equalTo: imageNewsView.rightAnchor, constant: 10).isActive = true
        labelStackView.heightAnchor.constraint(equalTo: imageNewsView.heightAnchor, multiplier: 1).isActive = true
        labelStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        labelStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -50).isActive = true
        
        titleNewsLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
//        labelStackView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    private func setupFavouriteButton() {
        favouriteButton.addTarget(self, action: #selector(addToFavouriteTapped), for: .touchUpInside)
        self.contentView.addSubview(favouriteButton)
        favouriteButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.175).isActive = true
        favouriteButton.widthAnchor.constraint(equalTo: favouriteButton.heightAnchor).isActive = true
        favouriteButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        favouriteButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
    }
    
    @objc
    func addToFavouriteTapped(sender: UIButton) {
        if let news = self.news  {
            CoreDataManager.shared.addProductToFavourite(news: news)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageNewsView.image = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
