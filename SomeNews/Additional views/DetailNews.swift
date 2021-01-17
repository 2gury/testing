import UIKit

class DetailNews: UIViewController {
    
    var news: News!
    
    // MARK:- UI Properties
    private var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.contentMode = .left
        lbl.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 2
        return lbl
    }()
    
    private var textLabel: UILabel = {
        let lbl = UILabel()
        lbl.contentMode = .left
        lbl.font = UIFont(name:"HelveticaNeue", size: 16.0)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private var stackLabelViews: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        return sv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemPink
        setup()
    }
    
    // MARK:- Setup
    private func setup() {
        setupImageView()
        setupLabels()
    }
    
    private func setupImageView() {
        self.view.addSubview(imageView)
        guard let news = self.news else { return }
        guard let URL = URL(string: news.urlString) else { return }
        self.imageView.kf.setImage(with: URL)
    }
    
    private func setupLabels() {
        let tmpView = UIView()
        tmpView.translatesAutoresizingMaskIntoConstraints = false
//        tmpView.backgroundColor = .green
        
        if let title = news?.title{
            titleLabel.text = title
        }
        
        if let text = news?.text {
            textLabel.text = text
        }
        
        stackLabelViews.addArrangedSubview(titleLabel)
        stackLabelViews.addArrangedSubview(textLabel)
        stackLabelViews.addArrangedSubview(tmpView)
        
        self.view.addSubview(stackLabelViews)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout()
    }
    
    // MARK:- Layout
    private func layout() {
        layoutSelfView()
        layoutImageView()
        layoutStackLabelView()
    }
    
    private func layoutSelfView() {
        self.view.backgroundColor = .white
    }
    
    private func layoutImageView() {
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        imageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
    }
    
    private func layoutStackLabelView() {
        stackLabelViews.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 15).isActive = true
        stackLabelViews.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        stackLabelViews.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        stackLabelViews.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
