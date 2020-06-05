//
//  ViewController.swift
//  MLRealmTool
//
//  Created by 毛立 on 2020/6/5.
//  Copyright © 2020 毛立. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var dataSources: [String] = [
        "插入一条Dog数据",
        "插入一组Dog数据",
        "删除全部Dog数据",
        "查询所有数据4",
        "查询所有数据5",
        "查询所有数据6",
        "查询所有数据7",
        "查询所有数据8",
        "查询所有数据9",
        "查询所有数据10",
        "查询所有数据11"
    ]
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: MLCollectionViewLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.red
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.register(MLCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.delegate = self
        textView.backgroundColor = UIColor.black
        textView.textColor = UIColor.white
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(collectionView)
        
        self.view.addSubview(textView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let collectionViewFrame = CGRect(x: 0, y: 30, width: self.view.frame.size.width, height: 44 * 3)
        if !self.collectionView.frame.equalTo(collectionViewFrame) {
            self.collectionView.frame = collectionViewFrame
        }
        
        let textViewFrame = CGRect(x: 0, y: collectionViewFrame.maxY, width: self.view.frame.size.width, height: self.view.frame.size.height - collectionViewFrame.maxY)
        if !self.textView.frame.equalTo(textViewFrame) {
            self.textView.frame = textViewFrame
        }
    }
}

extension ViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.isFirstResponder {
            return true
        }
        return false
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSources.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : MLCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MLCollectionViewCell
        cell.title = dataSources[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch self.dataSources[indexPath.item] {
        case "插入一条Dog数据":
            self.writeDog()
            break
        case "插入一组Dog数据":
            self.writeDogs()
            break
        case "删除全部Dog数据":
            self.deleteAll()
            break
        default:
            break
        }
    }
}

//MARK: - 数据库操作
extension ViewController {
    //MARK: 插入一条数据
    private func writeDog() {
        var dogs: [MLDogDB] = [MLDogDB]()
        if let dbDogs = MLDogDB.queryAllObj() {
            dogs = dbDogs
        }
        let dog = MLDogDB()
        dog.birthday = Date()
        dog.name = "狗子\(dogs.count)号"
        // 插入数据
        dog.writeObj()
        self.textView.text = self.textView.text + "\n\n插入一条\(dog.name)数据"
    }
    
    //MARK: 插入一组数据
    private func writeDogs() {
        var dogs: [MLDogDB] = [MLDogDB]()
        if let dbDogs = MLDogDB.queryAllObj() {
            dogs = dbDogs
        }
        
        var writeDogs: [MLDogDB] = [MLDogDB]()
        
        let dog1 = MLDogDB()
        dog1.birthday = Date()
        dog1.name = "狗子\(dogs.count)号"
        writeDogs.append(dog1)
        
        let dog2 = MLDogDB()
        dog2.birthday = Date()
        dog2.name = "狗子\(dogs.count + 1)号"
        writeDogs.append(dog2)
        
        // 插入数据
        writeDogs.writeObjs()
        
        self.textView.text = self.textView.text + "\n\n"
        for dog in writeDogs {
            self.textView.text = self.textView.text + "\n批量插入\(dog.name)"
        }
    }
    
    //MARK: - 删除某张表全部数据
    private func deleteAll() {
        MLDogDB.deleteAllObj()
        self.textView.text = self.textView.text + "\n\n删除全部数据"
    }
}

class MLCollectionViewCell: UICollectionViewCell {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.blue
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        label.backgroundColor = UIColor.brown
        return label
    }()
    
    var title: String = "" {
        didSet{
            self.titleLabel.text = self.title
            self.titleLabel.sizeToFit()
            self.titleLabel.center = self.center
        }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.contentView.addSubview(titleLabel)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.resizeSubviewSize()
    }
    
    func resizeSubviewSize() {
        let titleLabelFrame = CGRect(x: 2.5, y: 2.5, width: self.contentView.frame.size.width - 5, height: self.contentView.frame.size.height - 5)
        if !self.titleLabel.frame.equalTo(titleLabelFrame) {
            self.titleLabel.frame = titleLabelFrame
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MLCollectionViewLayout: UICollectionViewFlowLayout {
    override func prepare() {
        
        super.prepare()
        
        sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let W: CGFloat = UIScreen.main.bounds.size.width / 4.0
        let H: CGFloat = 44
        itemSize = CGSize(width: W, height: H)
        
        self.collectionView?.isPagingEnabled = true
        
        scrollDirection = .horizontal
        
        //行间距
        minimumLineSpacing = 0
        
        //cell间距
        minimumInteritemSpacing = 0
        
    }
}
