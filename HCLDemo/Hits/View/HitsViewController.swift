//
//  HitsViewController.swift
//  HCLDemo
//
//  Created by Pichuka, Anvesh (623-Extern) on 19/06/24.
//

import UIKit


class HitsViewController: UIViewController {
    
    private var viewModel : HitsViewModel
    @IBOutlet var hitsTableView: UITableView!
    
    init(viewModel: HitsViewModel = HitsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = HitsViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBindings()
        viewModel.fetchHits()
    }
    
    private func setupTableView() {
        hitsTableView.delegate = self
        hitsTableView.dataSource = self
        hitsTableView.register(UINib(nibName: "HitsTableViewCell", bundle: nil), forCellReuseIdentifier: "HitsTableViewCell")
        
    }
    
    private func setupBindings() {
        viewModel.onHitsFetched = { [weak self] in
            self?.hitsTableView.reloadData()
        }
        
        viewModel.onError = { error in
            print("Error fetching data: \(error)")
        }
    }
}
    
    // MARK: - UITableViewDataSource
    extension HitsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.hits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = hitsTableView.dequeueReusableCell(withIdentifier: "HitsTableViewCell", for: indexPath) as! HitsTableViewCell
        let hit = viewModel.hits[indexPath.row]
        cell.configure(with: hit)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hit = viewModel.hits[indexPath.row]
        if let url = URL(string: hit.pageURL ?? "") {
            UIApplication.shared.open(url)
        }
    }
}
