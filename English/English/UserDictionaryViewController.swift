//
//  UserDictionaryViewController.swift
//  English
//
//  Created by Женя К on 16.07.2025.
//

import UIKit

class UserDictionaryViewController: UITableViewController {
    
    private var words: [String: String] = [:]
    private var isLoading = false
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadUserDictionary()
    }
    
    private func setupViews() {
        title = "Мой словарь"
        view.backgroundColor = UIColor.systemBackground
        
        // Регистрируем ячейку программно
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "WordCell")
        
        // Добавляем индикатор загрузки
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func loadUserDictionary() {
        guard !isLoading else { return }
        isLoading = true
        loadingIndicator.startAnimating()
        
        Task {
            do {
                let userWords = try await UserDictionaryService.shared.fetchUserDictionary()
                
                await MainActor.run {
                    self.words = userWords
                    self.tableView.reloadData()
                    self.loadingIndicator.stopAnimating()
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    print("❌ Ошибка загрузки словаря: \(error)")
                    if let urlError = error as? URLError {
                        print("❌ URL Error: \(urlError.localizedDescription)")
                        print("❌ Error code: \(urlError.code.rawValue)")
                    }
                    self.showError(message: "Ошибка загрузки словаря: \(error.localizedDescription)")
                    self.loadingIndicator.stopAnimating()
                    self.isLoading = false
                }
            }
        }
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Повторить", style: .default) { _ in
            self.loadUserDictionary()
        })
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension UserDictionaryViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Используем ячейку из Storyboard
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordCell", for: indexPath)
        
        // Получаем слово и перевод по индексу
        let sortedWords = words.sorted { $0.key < $1.key }
        let (word, translation) = sortedWords[indexPath.row]
        
        // Настраиваем ячейку в зависимости от того, как она настроена в Storyboard
        if let textLabel = cell.textLabel {
            textLabel.text = word
        }
        
        if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = translation
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension UserDictionaryViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let sortedWords = words.sorted { $0.key < $1.key }
        let (word, translation) = sortedWords[indexPath.row]
        
        let alert = UIAlertController(title: word, message: translation, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
} 