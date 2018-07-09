//
//  TableViewController.swift
//  ArmoryTests
//
//  Created by Cameron Smith on 6/13/18.
//  Copyright © 2018 stablekernel. All rights reserved.
//

import UIKit

// MARK: - TableViewControllerDelegate

protocol TableViewControllerDelegate: class {
    func didCallEditAction(withTitle title: String)
    func didSelectRow(at indexPath: IndexPath)
}

// MARK: - TableViewController

class TableViewController: TestViewController {

    // MARK: - Properties

    private(set) var names: [String] = []

    let reuseIdentifier = "Cell"

    weak var delegate: TableViewControllerDelegate?

    // MARK: - IBOutlets

    @IBOutlet weak var tableView: UITableView!

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }

    // MARK: - Public

    func setupDataSource(names: [String]) {
        self.names = names
        tableView.reloadData()
    }
}

// MARK: - UITableView Data Source Methods

extension TableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = names[indexPath.row]

        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
}

// MARK: - UITableView Delegate Methods

extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
            self.delegate?.didCallEditAction(withTitle: action.title!)
        }

        let favorite = UITableViewRowAction(style: .normal, title: "Favorite") { action, index in
            self.delegate?.didCallEditAction(withTitle: action.title!)
        }

        return [delete, favorite]
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectRow(at: indexPath)
    }
}
