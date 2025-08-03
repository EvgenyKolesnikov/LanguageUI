//
//  TextCell.swift
//  English
//
//  Created by Женя К on 13.07.2025.
//
import UIKit

class TextCell: UICollectionViewCell {
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.textAlignment = .center
        textView.font = UIFont.systemFont(ofSize: 25)
        textView.textColor = UIColor.label
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var translations: [String: String] = [:]
    
    // Всплывающее окно для перевода
    private lazy var translationPopup: UIView = {
        let popup = UIView()
        popup.backgroundColor = UIColor.systemBackground
        popup.layer.cornerRadius = 12
        popup.layer.shadowColor = UIColor.black.cgColor
        popup.layer.shadowOffset = CGSize(width: 0, height: 2)
        popup.layer.shadowOpacity = 0.3
        popup.layer.shadowRadius = 8
        popup.isHidden = true
        popup.translatesAutoresizingMaskIntoConstraints = false
        return popup
    }()
    
    private lazy var wordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var translationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("✕", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        button.setTitleColor(UIColor.secondaryLabel, for: .normal)
        button.addTarget(self, action: #selector(hideTranslationPopup), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(textView)
        contentView.addSubview(translationPopup)
        
        // Убеждаемся, что popup поверх всего
        contentView.bringSubviewToFront(translationPopup)
        
        print("🏗️ Popup создан: \(translationPopup.frame)")
        print("🏗️ Popup скрыт: \(translationPopup.isHidden)")
        
        translationPopup.addSubview(wordLabel)
        translationPopup.addSubview(translationLabel)
        translationPopup.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            textView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            textView.heightAnchor.constraint(lessThanOrEqualTo: contentView.heightAnchor, constant: -40),
            
            // Всплывающее окно
            translationPopup.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            translationPopup.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            translationPopup.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -80),
            translationPopup.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),
            
            // Кнопка закрытия
            closeButton.topAnchor.constraint(equalTo: translationPopup.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: translationPopup.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 32),
            closeButton.heightAnchor.constraint(equalToConstant: 32),
            
            // Слово - центрируем в popup
            wordLabel.topAnchor.constraint(equalTo: translationPopup.topAnchor, constant: 16),
            wordLabel.centerXAnchor.constraint(equalTo: translationPopup.centerXAnchor),
            wordLabel.leadingAnchor.constraint(greaterThanOrEqualTo: translationPopup.leadingAnchor, constant: 16),
            wordLabel.trailingAnchor.constraint(lessThanOrEqualTo: closeButton.leadingAnchor, constant: -8),
            
            // Перевод - центрируем в popup
            translationLabel.topAnchor.constraint(equalTo: wordLabel.bottomAnchor, constant: 8),
            translationLabel.centerXAnchor.constraint(equalTo: translationPopup.centerXAnchor),
            translationLabel.leadingAnchor.constraint(greaterThanOrEqualTo: translationPopup.leadingAnchor, constant: 16),
            translationLabel.trailingAnchor.constraint(lessThanOrEqualTo: translationPopup.trailingAnchor, constant: -16),
            translationLabel.bottomAnchor.constraint(equalTo: translationPopup.bottomAnchor, constant: -16)
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTextTap(_:)))
        textView.addGestureRecognizer(tap)
    }
    
    func configure(with text: String, translations: [String: String]) {
        self.translations = translations
        textView.text = text
    }
    
    @objc private func handleTextTap(_ gesture: UITapGestureRecognizer) {
        let layoutManager = textView.layoutManager
        var location = gesture.location(in: textView)
        location.x -= textView.textContainerInset.left
        location.y -= textView.textContainerInset.top
        
        let characterIndex = layoutManager.characterIndex(for: location, in: textView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        guard characterIndex < textView.text.count else { return }
        
        let nsText = textView.text as NSString
        let separators = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let range = nsText.rangeOfWord(at: characterIndex, separators: separators)
        let word = nsText.substring(with: range)
        let cleanWord = word.trimmingCharacters(in: .punctuationCharacters)
        guard !cleanWord.isEmpty else { return }
        
        var translation = translations[cleanWord]
        if translation == nil {
            translation = translations[cleanWord.lowercased()]
        }
        if translation == nil {
            translation = "Перевод не найден"
        }
        showTranslationPopup(for: cleanWord, translation: translation!)
    }
    
    @objc private func hideTranslationPopup() {
        UIView.animate(withDuration: 0, delay: 0, options: [.curveEaseIn], animations: {
            self.translationPopup.alpha = 0
            self.translationPopup.transform = CGAffineTransform(translationX: 0, y: 10)
        }) { _ in
            self.translationPopup.isHidden = true
        }
    }
    
    private func showTranslationPopup(for word: String, translation: String) {
        print("🎯 Показываем popup для слова: \(word)")
        print("🎯 Перевод: \(translation)")
        
        wordLabel.text = word
        translationLabel.text = translation
        
        // Сначала показываем окно без анимации для мгновенного отклика
        translationPopup.isHidden = false
        translationPopup.alpha = 1
        translationPopup.transform = .identity
        
        print("📱 Popup видимость: \(translationPopup.isHidden ? "скрыт" : "видим")")
        print("📱 Popup alpha: \(translationPopup.alpha)")
        print("📱 Popup frame: \(translationPopup.frame)")
        
        // Затем добавляем небольшую анимацию для плавности
        translationPopup.transform = CGAffineTransform(translationX: 0, y: 10)
        
        UIView.animate(withDuration: 0.15, delay: 0, options: [.curveEaseOut], animations: {
            self.translationPopup.transform = .identity
        }) { _ in
            print("✅ Анимация popup завершена")
        }
    }
}
