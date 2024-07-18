import UIKit
import SnapKit

struct Item {
    let imageName: String
    let title: String
    let hashtags: [String]
}

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    let searchBar = UISearchBar()
    var collectionView: UICollectionView!
    let cellIdentifier = "cell"
    
    // 데이터
    let items: [Item] = [
        Item(imageName: "car.fill", title: "차박하기 좋은 계절 전국 차박 명소는?", hashtags: ["가정의달", "캠핑"]),
        Item(imageName: "golfball.fill", title: "초보 골퍼를 위한 라운딩 필수 준비물", hashtags: ["혼인원", "야외필드"]),
        Item(imageName: "car.2.fill", title: "자동차 회사는 AI를 어떻게 활용할까?", hashtags: ["모빌리티"]),
        Item(imageName: "airplane.departure", title: "봄맞이 떠나기 좋은 국내 여행지", hashtags: ["드라이브"]),
        Item(imageName: "book.fill", title: "해외 유학 어떻게 준비하지?", hashtags: ["어학연수", "자녀유학"]),
        Item(imageName: "car.circle.fill", title: "자동차의 똑똑한 진화 텔레매틱스", hashtags: ["자율주행시대"]),
        Item(imageName: "dollarsign.circle.fill", title: "엔테크 지금 해도 될까?", hashtags: ["엔화투자"])
    ]
    
    var filteredItems: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filteredItems = items
        
        setupSearchBar()
        setupCollectionView()
    }
    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "내용을 입력해 보세요"
        
        // SearchBar의 배경색 설정
        searchBar.barTintColor = .white
        searchBar.backgroundImage = UIImage()
        
        // SearchBar의 텍스트 필드 배경색 설정
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .white
        }
        
        view.addSubview(searchBar)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
        }
    }

//    func setupSearchBar() {
//        searchBar.delegate = self
//        searchBar.placeholder = "내용을 입력해 보세요"
//        view.addSubview(searchBar)
//        
//        searchBar.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//            make.left.right.equalToSuperview()
//        }
//    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width, height: 100)
        layout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.backgroundColor = .white
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CollectionViewCell
        let item = filteredItems[indexPath.row]
        cell.configure(with: item.imageName, title: item.title, hashtags: item.hashtags)
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = filteredItems[indexPath.row]
        let detailVC = DetailViewController()
        detailVC.configure(with: item)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredItems = items
        } else {
            filteredItems = items.filter { $0.title.contains(searchText) || $0.hashtags.contains(where: { $0.contains(searchText) }) }
        }
        collectionView.reloadData()
    }
}

class CollectionViewCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let hashtagsLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(hashtagsLabel)
        
        imageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .black
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(16)
            make.top.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(40) // 높이를 지정하여 텍스트가 보이도록 설정
        }
        
        hashtagsLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        hashtagsLabel.numberOfLines = 1
        hashtagsLabel.textColor = .gray
        
        hashtagsLabel.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(20) // 높이를 지정하여 텍스트가 보이도록 설정
        }
        
//        self.backgroundColor = .lightGray // 셀의 배경색을 설정하여 레이아웃 확인
    }
    
    func configure(with imageName: String, title: String, hashtags: [String]) {
        imageView.image = UIImage(systemName: imageName)
        titleLabel.text = title
        hashtagsLabel.text = hashtags.map { "#\($0)" }.joined(separator: " ")
    }
}

class DetailViewController: UIViewController {
    
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let hashtagsLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupViews()
    }
    
    func setupViews() {
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(hashtagsLabel)
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        hashtagsLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        hashtagsLabel.numberOfLines = 0
        hashtagsLabel.textColor = .gray
        hashtagsLabel.textAlignment = .center
        
        hashtagsLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
        }
    }
    
    func configure(with item: Item) {
        imageView.image = UIImage(systemName: item.imageName)
        titleLabel.text = item.title
        hashtagsLabel.text = item.hashtags.map { "#\($0)" }.joined(separator: " ")
    }
}
