//
//  UserDictionaryViewController.swift
//  English
//
//  Created by Женя К on 16.07.2025.
//

import UIKit

class UserDictionaryViewController: UITableViewController {
    
    private var words: [UserDictionaryWord] = []
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
        
        // Регистрируем ячейку
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "WordCell")
        
        // Устанавливаем стиль ячеек
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        
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
                    print("📚 Загружено слов в словарь: \(userWords.count)")
                    for word in userWords {
                        print("📝 \(word.word) → \(word.translation ?? "nil")")
                    }
                    
                    self.words = userWords
                    self.tableView.reloadData()
                    self.loadingIndicator.stopAnimating()
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    print("❌ Ошибка загрузки словаря: \(error)")
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
    
    private func deleteWord(at indexPath: IndexPath) {
        let word = words[indexPath.row]
        performDelete(word: word, at: indexPath)
    }
    
    private func performDelete(word: UserDictionaryWord, at indexPath: IndexPath) {
        Task {
            do {
                try await UserDictionaryService.shared.deleteWord(id: word.id)
                
                await MainActor.run {
                    self.words.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                }
            } catch {
                await MainActor.run {
                    self.showError(message: "Ошибка удаления слова: \(error.localizedDescription)")
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension UserDictionaryViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "WordCell")
        
        let word = words[indexPath.row]
        
        cell.textLabel?.text = word.word
        cell.detailTextLabel?.text = word.translation ?? ""
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteWord(at: indexPath)
        }
    }
}

// MARK: - UITableViewDelegate
extension UserDictionaryViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
} 