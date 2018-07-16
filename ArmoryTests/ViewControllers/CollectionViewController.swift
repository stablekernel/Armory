//
//  CollectionViewController.swift
//  ArmoryTests
//
//  Created by Cameron Smith on 6/13/18.
//  Copyright © 2018 stablekernel. All rights reserved.
//

import UIKit

class CollectionViewController: TestViewController {
    
    // MARK: - Properties
    
    private(set) var colors: [UIColor] = []
    
    let reuseIdentifier = "Cell"
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    // MARK: - Public
    
    func setupDataSource(colors: [UIColor]) {
        self.colors = colors
        collectionView.reloadData()
    }
}

// MARK: - UICollectionView Data Source Methods

extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        cell.color = colors[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

// MARK: - UICollectionView Delegate Methods

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 75, height: 75)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
}

// MARK: - CollectionViewCell

class CollectionViewCell: UICollectionViewCell {
    
    var color: UIColor? {
        didSet {
            mapStateToView()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            mapStateToView()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        color = nil
    }
    
    func mapStateToView() {
        contentView.layer.borderWidth = 5
        contentView.layer.borderColor = isSelected ? UIColor.yellow.cgColor : UIColor.clear.cgColor
        
        if color == nil {
            contentView.backgroundColor = UIColor.white
        } else {
            contentView.backgroundColor = color!
        }
    }
}
