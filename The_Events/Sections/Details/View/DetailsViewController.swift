//
//  DetailsViewController.swift
//  The_Events
//
//  Created by Gabriel Mendonça on 03/10/21.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var viewModel: DetailsViewModel!
    var idEvent: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        requestListener()
        viewModel.getDetailsEvent(id: idEvent)
        view.backgroundColor = .lightGray
    }
    
    init(id: String, viewModel: DetailsViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.idEvent = id
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var scrollView: UIScrollView = {
        var scroll = UIScrollView()
        scroll.contentSize = CGSize(width: view.bounds.size.width, height: view.frame.height)
        return scroll
    }()
    
    lazy var imageDetail: UIImageView = {
        var image = UIImageView()
        return image
    }()
    
    lazy var titleDetail: UILabel = {
        var title = UILabel()
        title.text = "--"
        title.textColor = .black
        return title
    }()
    
    lazy var descriptionDetail: UILabel = {
        var description = UILabel()
        description.numberOfLines = 0
        description.font = UIFont(name: "Kefa", size: 13)
        return description
    }()
    
    lazy var pricelabel: UILabel = {
        var price = UILabel()
        price.textColor = .green
        return price
    }()
    
    lazy var dateLabel: UILabel = {
        var date = UILabel()
        date.text = "---"
        return date
    }()
    
    func requestListener() {
        viewModel.statusObservable.didChange = { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.config(state: response)
            }
        }
    }
    
    func config(state: RequestStates<DetailsModel>) {
        switch state {
        case .loading:
            print("loading...")
        case .load(data: let detail):
            self.viewModel.model = detail
            populateModel(model: detail)
        default:
            break
        }
    }
    
    func populateModel(model: DetailsModel) {
        title = model.title
        let dateValueFormat = processDate(for: "1534784400000")
        if let url = URL(string: model.image ?? "none") {
            imageDetail.sd_setImage(with: url)
        } else {
            imageDetail.image = UIImage(systemName: "camera.fill")
        }
        titleDetail.text = model.title
        descriptionDetail.text = model.description
        pricelabel.text = "R$: \(model.price ?? 0.0)"
        dateLabel.text = dateValueFormat
       
    }
    
    func processDate(for dateString: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt_BR")
        dateFormatter.dateFormat = Date.FormatStyle.dateIso.rawValue
        
        guard let resultDate = dateFormatter.date(from: dateString)?.toString(with: Date.FormatStyle.longDate) else {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "pt_BR")
            dateFormatter.dateFormat = Date.FormatStyle.dateIso2.rawValue
            return dateFormatter.date(from: dateString)?.toString(with: Date.FormatStyle.longDate) ?? ""
        }
        return resultDate
    }
    
    func setupConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageDetail)
        scrollView.addSubview(titleDetail)
        scrollView.addSubview(descriptionDetail)
        scrollView.addSubview(dateLabel)
        scrollView.addSubview(pricelabel)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        imageDetail.translatesAutoresizingMaskIntoConstraints = false
        titleDetail.translatesAutoresizingMaskIntoConstraints = false
        descriptionDetail.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        pricelabel.translatesAutoresizingMaskIntoConstraints = false
        
        let scrollTop = scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor)
        let scrollLeading = scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let scrollTrailing = scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let scrollBottom = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        NSLayoutConstraint.activate([scrollTop, scrollLeading, scrollTrailing, scrollBottom])
        
        let imageTop = imageDetail.topAnchor.constraint(equalTo: scrollView.topAnchor)
        let imageLeading = imageDetail.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor)
        let imageTrailing = imageDetail.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        let imageWidth = imageDetail.widthAnchor.constraint(equalToConstant: view.frame.width)
        let imageHeight = imageDetail.heightAnchor.constraint(equalToConstant: 200)
        NSLayoutConstraint.activate([imageTop, imageLeading, imageTrailing, imageHeight, imageWidth])
        
        let dateTop = dateLabel.topAnchor.constraint(equalTo: imageDetail.bottomAnchor, constant: 15)
        let dateLeading = dateLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 15)
        let dateTrailing = dateLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -15)
        NSLayoutConstraint.activate([dateTop, dateLeading, dateTrailing])
        
        let titleTop = titleDetail.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 15)
        let titleLeading = titleDetail.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor)
        let titleTrailing = titleDetail.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor)
        NSLayoutConstraint.activate([titleTop, titleLeading, titleTrailing])

        let descriptionTop = descriptionDetail.topAnchor.constraint(equalTo: titleDetail.bottomAnchor, constant: 15)
        let descriptionLeading = descriptionDetail.leadingAnchor.constraint(equalTo: titleDetail.leadingAnchor)
        let descriptionTrailing = descriptionDetail.trailingAnchor.constraint(equalTo: titleDetail.trailingAnchor)
        NSLayoutConstraint.activate([descriptionTop, descriptionLeading, descriptionTrailing])

        let priceTop = pricelabel.topAnchor.constraint(equalTo: descriptionDetail.bottomAnchor, constant: 15)
        let priceleading = pricelabel.leadingAnchor.constraint(equalTo: descriptionDetail.leadingAnchor)
        let priceTrailing = pricelabel.trailingAnchor.constraint(equalTo: descriptionDetail.trailingAnchor)
        let priceBottom = pricelabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -15)
        NSLayoutConstraint.activate([priceTop, priceleading, priceTrailing, priceBottom])
    }
}
