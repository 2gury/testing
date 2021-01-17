import UIKit

class AddNewsView: UIViewController {
    
    var presenter: AddOutputProtocol!

    var tableView: UITableView!
    
    var addButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Add news", for: .normal)
        btn.setTitleColor(#colorLiteral(red: 0.6289877295, green: 0.624443531, blue: 0.6324685216, alpha: 1), for: .highlighted)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        btn.layer.cornerRadius = 13
        return btn
    }()
    
    // MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        CoreDataManager.shared.deleteNewsFromAdd()
        presenter.fetchAdd()
    }
    // MARK:- DidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout()
    }
    
    // MARK:- Setup
    private func setup() {
        setupMainView()
        setupAddButton()
        setupTableView()
    }
    
    fileprivate func setupMainView() {
        self.view.backgroundColor = .white
    }
    
    fileprivate func setupAddButton() {
        addButton.addTarget(self, action: #selector(generateMysteryNews(sender:)), for: .touchUpInside)
        self.view.addSubview(addButton)
    }
    
    @objc func generateMysteryNews(sender: UIButton) {
        let news = mysteryNews.shuffled()[0]
        CoreDataManager.shared.addProductToAdd(news: news)
        presenter.fetchAdd()
    }
    
    fileprivate func setupTableView() {
        tableView = UITableView()
        tableView.register(AddNewsCell.self, forCellReuseIdentifier: "AddNewsCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.accessibilityLabel = "TableView3"
        self.view.addSubview(tableView)
    }
    
    // MARK:- Layout
    private func layout() {
        layoutMainView()
        layoutAddButton()
        layoutTablewView()
    }
    
    private func layoutMainView() {
        
    }
    
    private func layoutAddButton() {
        addButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        addButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        addButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func layoutTablewView() {
        tableView.topAnchor.constraint(equalTo: self.addButton.bottomAnchor, constant: 10).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
    }

}

extension AddNewsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let news = presenter.getAddProducts() else { return 0 }
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewsCell") as! AddNewsCell
        
        guard let news = presenter.getAddProducts() else { return UITableViewCell() }
        let index = indexPath.row
        let new = news[index]
        cell.setup(withNews: new)
        cell.accessibilityLabel = "AddCell\(indexPath.row)"
//        cell.isUserInteractionEnabled = false
//        if let textLabel = cell.textLabel {
//            textLabel.text = new.title
//        }
//        if let detailTextLabel = cell.detailTextLabel {
//            detailTextLabel.text = new.text
//        }
//
//        if let imageView = cell.imageView, let URL = URL(string: new.urlString) {
//            imageView.kf.setImage(with: URL)
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let news = presenter.getAddProducts() else { return }
        let index = indexPath.row
        let new = news[index]
        guard let presenter = presenter else { return }
        presenter.tapOnDetail(news: new)
    }
}

extension AddNewsView: AddInputProtocol {
    func success() {
        tableView.reloadData()
    }
    
    func failure() {
        tableView.reloadData()
    }
}
