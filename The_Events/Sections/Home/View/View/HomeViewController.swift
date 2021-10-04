//
//  HomeViewController.swift
//  The_Events
//
//  Created by Gabriel Mendonça on 29/09/21.
//

import UIKit


class HomeViewController: UIViewController {
    
    var viewModel: HomeViewModel!
    var eventModel: [EventModel]?
    
    init(viewModel: HomeViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupContraints()
        requestListener()
        viewModel.fetchEvent()
    }
    
    lazy var tableView: UITableView = {
       var table = UITableView()
        table.allowsSelection = true
        return table
    }()
    
    lazy var progressLoad: UIActivityIndicatorView = {
        var activity = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activity.color = .black
        activity.startAnimating()
        return activity
    }()
    
    func setupContraints() {
        view.addSubview(tableView)
        view.addSubview(progressLoad)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        progressLoad.translatesAutoresizingMaskIntoConstraints = false
        
        let tableTop = tableView.topAnchor.constraint(equalTo: view.topAnchor)
        let tableBottom = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        let tableLeading = tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let tableTrailing = tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        NSLayoutConstraint.activate([tableTop, tableBottom, tableLeading, tableTrailing])
        
        let progressCenterX = progressLoad.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let progressCenterY = progressLoad.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        NSLayoutConstraint.activate([progressCenterX, progressCenterY])
        
        
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HomeEventTableViewCell.self, forCellReuseIdentifier: "homeEventTableViewCell")
    }
    
    func requestListener() {
        viewModel.statusObservable.didChange = { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.config(state: response)
            }
        }
    }
    
    func config(state: RequestStates<[EventModel]>) {
        switch state {
        case .loading:
            print("loading...")
        case .load(data: let event):
            self.eventModel = event
            self.progressLoad.stopAnimating()
            self.tableView.reloadData()
        default:
            break
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfEvents()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let event = eventModel else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "homeEventTableViewCell", for: indexPath) as? HomeEventTableViewCell else { return UITableViewCell() }
        let events = event[indexPath.row]
        cell.setup(model: events)
        cell.setupImage(url: viewModel.setupImageUrl(get: indexPath.row))
        cell.setupContraints()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let event = eventModel else { return }
        let id = event[indexPath.row].id ?? ""
        viewModel.goToDetailsEvent(id: id)
    }
    
    
}
