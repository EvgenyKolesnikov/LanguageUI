import UIKit

class TextSwipeCollectionViewController: UIViewController {
    
    var textStub = TextStub()
    
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
        return textStub.texts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextCell", for: indexPath) as! TextCell
        cell.configure(with: textStub.texts[indexPath.item], translations: textStub.translations)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
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


