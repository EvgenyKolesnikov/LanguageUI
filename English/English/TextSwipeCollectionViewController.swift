//
//  ExerсiseOneViewController.swift
//  English
//
//  Created by Женя К on 12.07.2025.
//

import UIKit

class TextSwipeCollectionViewController: UIViewController {
    
    let texts = [
        "The sun shines brightly in the blue sky. Birds are singing in the green trees. A small river flows quietly through the valley. Everything looks peaceful and beautiful.",
        "I wake up at 7 o'clock every morning. First, I brush my teeth and take a shower. Then I eat breakfast with my family. After that, I go to work or school.",
        "Dogs are loyal and friendly animals. They love playing with their owners. Many dogs can learn different commands. Cats are more independent but also make great pets.",
        "London is a big and interesting city. There are many famous places to visit. The weather is often rainy but not very cold. I would like to go there one day."
    ]
    
    // Словарь переводов
    let translations: [String: String] = [
        // Первый текст
        "The": "Определенный артикль",
        "sun": "солнце",
        "shines": "светит",
        "brightly": "ярко",
        "in": "в",
        "the": "определенный артикль",
        "blue": "синий",
        "sky": "небо",
        "Birds": "птицы",
        "are": "есть/являются",
        "singing": "поют",
        "green": "зеленый",
        "trees": "деревья",
        "A": "неопределенный артикль",
        "small": "маленький",
        "river": "река",
        "flows": "течет",
        "quietly": "тихо",
        "through": "через",
        "valley": "долина",
        "Everything": "все",
        "looks": "выглядит",
        "peaceful": "спокойный",
        "and": "и",
        "beautiful": "красивый",
        
        // Второй текст
        "I": "я",
        "wake": "просыпаюсь",
        "up": "вверх",
        "at": "в",
        "7": "семь",
        "o'clock": "часов",
        "every": "каждый",
        "morning": "утро",
        "First": "сначала",
        "brush": "чищу",
        "my": "мой",
        "teeth": "зубы",
        "take": "принимаю",
        "shower": "душ",
        "Then": "затем",
        "eat": "ем",
        "breakfast": "завтрак",
        "with": "с",
        "family": "семья",
        "After": "после",
        "that": "того",
        "go": "иду",
        "to": "к",
        "work": "работа",
        "or": "или",
        "school": "школа",
        
        // Третий текст
        "Dogs": "собаки",
        "loyal": "верный",
        "friendly": "дружелюбный",
        "animals": "животные",
        "They": "они",
        "love": "любят",
        "playing": "играть",
        "their": "их",
        "owners": "хозяева",
        "Many": "многие",
        "can": "могут",
        "learn": "учиться",
        "different": "разные",
        "commands": "команды",
        "Cats": "кошки",
        "more": "более",
        "independent": "независимый",
        "but": "но",
        "also": "также",
        "make": "делают",
        "great": "отличные",
        "pets": "питомцы",
        
        // Четвертый текст
        "London": "Лондон",
        "big": "большой",
        "interesting": "интересный",
        "city": "город",
        "There": "там",
        "many": "много",
        "famous": "известные",
        "places": "места",
        "visit": "посетить",
        "weather": "погода",
        "often": "часто",
        "rainy": "дождливая",
        "not": "не",
        "very": "очень",
        "cold": "холодная",
        "would": "бы",
        "like": "хотел бы",
        "there": "там",
        "one": "один",
        "day": "день"
    ]
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.register(TextCell.self, forCellWithReuseIdentifier: "TextCell")
        cv.dataSource = self
        cv.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension TextSwipeCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return texts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextCell", for: indexPath) as! TextCell
        cell.configure(with: texts[indexPath.item], translations: translations)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}

class TextCell: UICollectionViewCell {
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.textAlignment = .center
        textView.font = UIFont.systemFont(ofSize: 25)
        textView.textColor = UIColor.black
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
            
            // Слово
            wordLabel.topAnchor.constraint(equalTo: translationPopup.topAnchor, constant: 16),
            wordLabel.leadingAnchor.constraint(equalTo: translationPopup.leadingAnchor, constant: 16),
            wordLabel.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -8),
            
            // Перевод
            translationLabel.topAnchor.constraint(equalTo: wordLabel.bottomAnchor, constant: 8),
            translationLabel.leadingAnchor.constraint(equalTo: translationPopup.leadingAnchor, constant: 16),
            translationLabel.trailingAnchor.constraint(equalTo: translationPopup.trailingAnchor, constant: -16),
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

// Вспомогательный extension для поиска слова по индексу
extension NSString {
    func rangeOfWord(at index: Int, separators: CharacterSet) -> NSRange {
        let length = self.length
        guard length > 0, index < length else { return NSRange(location: 0, length: 0) }
        var start = index
        var end = index
        while start > 0 && !separators.contains(UnicodeScalar(character(at: start - 1))!) {
            start -= 1
        }
        while end < length && !separators.contains(UnicodeScalar(character(at: end))!) {
            end += 1
        }
        return NSRange(location: start, length: end - start)
    }
}


