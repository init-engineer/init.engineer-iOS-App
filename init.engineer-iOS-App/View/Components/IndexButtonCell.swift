//
//  IndexButtonCell.swift
//  init.engineer-iOS-App
//
//  Created by 楊承昊 on 2021/1/30.
//  Copyright © 2021 Kantai Developer. All rights reserved.
//

import UIKit

class IndexButtonCell: UIView, NibOwnerLoadable {

    var delegate: IndexButtonCellDelegate?
    var url: String = ""
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    // MARK: Initialier
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    // MARK: Custom Init
    private func customInit() {
        loadNibContent()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(IndexButtonCell.tapEdit(sender:)))
                addGestureRecognizer(tapGesture)
    }
    
    @objc func tapEdit(sender: UITapGestureRecognizer) {
        delegate?.indexButtonViewDelegate(urlString: url)
    }
    
}

// MARK: - IndexButtonViewDelegate
protocol IndexButtonCellDelegate {
    func indexButtonViewDelegate(urlString: String)
}

protocol NibOwnerLoadable: AnyObject {
    static var nib: UINib { get }
}

// MARK: - Default implmentation
extension NibOwnerLoadable {
    
    static var nib: UINib {
        UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
}

// MARK: - Supporting methods
extension NibOwnerLoadable where Self: UIView {
    
    func loadNibContent() {
        guard let views = Self.nib.instantiate(withOwner: self, options: nil) as? [UIView],
            let contentView = views.first else {
                fatalError("Fail to load \(self) nib content")
        }
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}
