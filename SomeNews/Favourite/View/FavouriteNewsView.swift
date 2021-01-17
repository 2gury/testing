import UIKit

class FavouriteNewsView: UIViewController {
    
    var presenter: FavouriteOutputProtocol!

    var tableView: UITableView!
    
    // MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter.fetchFavourite()
    }
    // MARK:- DidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout()
    }
    
    // MARK:- ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.fetchFavourite()
    }
    
    // MARK:- Setup
    private func setup() {
        setupMainView()
        setupTableView()
    }
    
    fileprivate func setupMainView() {
        self.view.backgroundColor = .white
    }
    
    fileprivate func setupTableView() {
        tableView = UITableView()
        tableView.register(FavouriteViewCell.self, forCellReuseIdentifier: "FavouriteCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.accessibilityLabel = "TableView2"
        self.view.addSubview(tableView)
    }
    
    // MARK:- Layout
    private func layout() {
        layoutMainView()
        layoutTablewView()
    }
    
    private func layoutMainView() {
        
    }
    
    private func layoutTablewView() {
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
    }

}

extension FavouriteNewsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let news = presenter.getFavouriteNews() else { return 0 }
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteCell") as! FavouriteViewCell
        
        guard let news = presenter.getFavouriteNews() else { return UITableViewCell() }
        let index = indexPath.row
        let new = news[index]
        cell.accessibilityLabel = "FavouriteCell\(indexPath.row)"
        cell.delegate = self
        cell.setup(withNews: new)
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
        guard let news = presenter.getFavouriteNews() else { return }
        let index = indexPath.row
        let new = news[index]
        guard let presenter = presenter else { return }
        presenter.tapOnDetail(news: new)
    }
}

extension FavouriteNewsView: FavouriteInputProtocol {
    func success() {
        tableView.reloadData()
    }
    
    func failure() {
        tableView.reloadData()
    }
}

extension FavouriteNewsView: ReloadDelegate {
    func reloadContent() {
        presenter.fetchFavourite()
    }
}
