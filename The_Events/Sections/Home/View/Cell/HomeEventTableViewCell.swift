//
//  HomeEventCell.swift
//  The_Events
//
//  Created by Gabriel Mendonça on 29/09/21.
//

import UIKit
import SDWebImage

class HomeEventTableViewCell: UITableViewCell {
    
    func setup(model: EventModel) {
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        priceLabel.text = "R$: \(model.price ?? 0.0)"
    }
    
    func setupImage(url: URL?) {
        if let url = url {
            imageEvent.sd_setImage(with: url)
            cornerRadiusImage()
        }
    }
    
    func cornerRadiusImage() {
        imageEvent.clipsToBounds = true
        imageEvent.layer.cornerRadius = 40
    }

    lazy var imageEvent: UIImageView = {
       var image = UIImageView()
        image.backgroundColor = .black
        return image
    }()
    
    lazy var titleLabel: UILabel = {
       var title = UILabel()
        title.text = "--"
        title.textColor = .black
        title.numberOfLines = 0
        return title
    }()
    
    lazy var descriptionLabel: UILabel = {
       var description = UILabel()
        description.text = "--"
        description.textColor = .lightGray
        description.font = UIFont(name: "Kefa", size: 13)
        return description
    }()
    
    lazy var priceLabel: UILabel = {
       var price = UILabel()
        price.text = "39,00"
        price.textColor = .green
        return price
    }()
    
    func setupContraints() {
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        imageEvent.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(imageEvent)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(priceLabel)
        
        
        let imageLeading = imageEvent.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15)
        let imageHeight = imageEvent.heightAnchor.constraint(equalToConstant: 80)
        let imageWidth = imageEvent.widthAnchor.constraint(equalToConstant: 80)
        let imageCenterY = imageEvent.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        NSLayoutConstraint.activate([imageLeading, imageHeight, imageWidth, imageCenterY])
        
        let titleTop = titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
        let titleLeading = titleLabel.leadingAnchor.constraint(equalTo: imageEvent.trailingAnchor, constant: 10)
        let titleTrailing = titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        NSLayoutConstraint.activate([titleTop, titleLeading, titleTrailing])
        
        
        let descriptionTop = descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5)
        let descriptionLeading = descriptionLabel.leadingAnchor.constraint(equalTo: imageEvent.trailingAnchor, constant: 10)
        let descriptionTrailing = descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        NSLayoutConstraint.activate([descriptionTop, descriptionLeading, descriptionTrailing])
        
        
        let priceTop = priceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5)
        let priceLeading = priceLabel.leadingAnchor.constraint(equalTo: imageEvent.trailingAnchor, constant: 10)
        let priceBottom = priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15)
        NSLayoutConstraint.activate([priceTop, priceLeading, priceBottom])
    }
}
