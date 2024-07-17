//
//  ViewController.swift
//  UKSK3
//
//  Created by ram on 7/17/24.
//
import UIKit
import SnapKit

class Landmark {
    var name: String
    var imageName: String
    var isFavorite: Bool
    
    init(name: String, imageName: String, isFavorite: Bool) {
        self.name = name
        self.imageName = imageName
        self.isFavorite = isFavorite
    }
}

class ViewController: UIViewController {
    
    var collectionView: UICollectionView!
    var landmarks = [Landmark]()
    
    // Updated filteredLandmarks computed property
    var filteredLandmarks: [Landmark] {
        return isFavoriteOnly ? landmarks.filter { $0.isFavorite } : landmarks
    }
    
    var isFavoriteOnly = false {
        didSet {
            collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLandmarks()
        setupUI()
    }
    
    func setupLandmarks() {
        landmarks = [
            Landmark(name: "Turtle Rock", imageName: "turtle_rock", isFavorite: true),
            Landmark(name: "Silver Salmon Creek", imageName: "silver_salmon_creek", isFavorite: false),
            Landmark(name: "Chilkoot Trail", imageName: "chilkoot_trail", isFavorite: true),
            Landmark(name: "St. Mary Lake", imageName: "st_mary_lake", isFavorite: true),
            Landmark(name: "Twin Lake", imageName: "twin_lake", isFavorite: false),
            Landmark(name: "Lake McDonald", imageName: "lake_mcdonald", isFavorite: false),
            Landmark(name: "Charley Rivers", imageName: "charley_rivers", isFavorite: false),
            Landmark(name: "Icy Bay", imageName: "icy_bay", isFavorite: false),
            Landmark(name: "Rainbow Lake", imageName: "rainbow_lake", isFavorite: false),
            Landmark(name: "Hidden Lake", imageName: "hidden_lake", isFavorite: false),
            Landmark(name: "Chincoteague", imageName: "chincoteague", isFavorite: false)
        ]
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(LandmarkCell.self, forCellWithReuseIdentifier: LandmarkCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let favoriteSwitch = UISwitch()
        favoriteSwitch.addTarget(self, action: #selector(toggleFavorites(_:)), for: .valueChanged)
        let favoriteLabel = UILabel()
        favoriteLabel.text = "Show Favorites Only"
        
        let favoriteStack = UIStackView(arrangedSubviews: [favoriteLabel, favoriteSwitch])
        favoriteStack.axis = .horizontal
        favoriteStack.spacing = 8
        
        view.addSubview(favoriteStack)
        favoriteStack.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(16)
        }
    }
    
    @objc func toggleFavorites(_ sender: UISwitch) {
        isFavoriteOnly = sender.isOn
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredLandmarks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LandmarkCell.identifier, for: indexPath) as! LandmarkCell
        let landmark = filteredLandmarks[indexPath.item]
        cell.configure(with: landmark)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let landmark = filteredLandmarks[indexPath.item]
        landmark.isFavorite.toggle()
        collectionView.reloadItems(at: [indexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}

class LandmarkCell: UICollectionViewCell {
    static let identifier = "LandmarkCell"
    
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let favoriteImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(favoriteImageView)
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        nameLabel.font = UIFont.systemFont(ofSize: 18)
        
        favoriteImageView.image = UIImage(systemName: "star.fill")
        favoriteImageView.tintColor = .yellow
        
        imageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(8)
            make.width.equalTo(imageView.snp.height)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(imageView.snp.trailing).offset(16)
        }
        
        favoriteImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
    }
    
    func configure(with landmark: Landmark) {
        imageView.image = UIImage(named: landmark.imageName)
        nameLabel.text = landmark.name
        favoriteImageView.isHidden = !landmark.isFavorite
    }
}
