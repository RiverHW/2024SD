import UIKit

class GuessWordGameView: UIView {
    // 单词列表
    let wordList = ["apple", "banana", "cherry", "date", "elderberry", "fig", "grape", "kiwi", "lemon", "mango"]
    
    // 当前要猜的单词
    var currentWord: String!
    
    // 显示单词的下划线标签数组
    var wordLabels: [UILabel] = []
    
    // 玩家输入框
    let guessTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "输入字母"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    // 提示标签
    let hintLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    // 得分标签
    let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "得分: 0"
        return label
    }()
    
    // 剩余机会标签
    let remainingChancesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "剩余机会: 10"
        return label
    }()
    
    // 游戏状态标签（显示游戏是否结束等信息）
    let gameStatusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .red
        label.numberOfLines = 0
        return label
    }()
    
    // 开始新游戏按钮
    let newGameButton: UIButton = {
        let button = UIButton(type:.system)
        button.setTitle("开始新游戏", for:.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        return button
    }()
    
    var score = 0
    var remainingChances = 10
    var guessedLetters: [Character] = []
    
    init() {
        super.init(frame:.zero)
        setupUI()
        startNewGame()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(guessTextField)
        addSubview(hintLabel)
        addSubview(scoreLabel)
        addSubview(remainingChancesLabel)
        addSubview(gameStatusLabel)
        addSubview(newGameButton)
        
        // 设置输入框和按钮的位置和大小
        guessTextField.translatesAutoresizingMaskIntoConstraints = false
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        remainingChancesLabel.translatesAutoresizingMaskIntoConstraints = false
        gameStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        newGameButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            guessTextField.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            guessTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            guessTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            guessTextField.heightAnchor.constraint(equalToConstant: 40),
            
            hintLabel.topAnchor.constraint(equalTo: guessTextField.bottomAnchor, constant: 10),
            hintLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            hintLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            hintLabel.heightAnchor.constraint(equalToConstant: 40),
            
            scoreLabel.topAnchor.constraint(equalTo: hintLabel.bottomAnchor, constant: 10),
            scoreLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            scoreLabel.heightAnchor.constraint(equalToConstant: 40),
            
            remainingChancesLabel.topAnchor.constraint(equalTo: hintLabel.bottomAnchor, constant: 10),
            remainingChancesLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            remainingChancesLabel.heightAnchor.constraint(equalToConstant: 40),
            
            gameStatusLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 10),
            gameStatusLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            gameStatusLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            gameStatusLabel.heightAnchor.constraint(equalToConstant: 60),
            
            newGameButton.topAnchor.constraint(equalTo: gameStatusLabel.bottomAnchor, constant: 10),
            newGameButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            newGameButton.widthAnchor.constraint(equalToConstant: 160),
            newGameButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        guessTextField.delegate = self
        newGameButton.addTarget(self, action: #selector(startNewGame), for:.touchUpInside)
    }
    
    @objc func startNewGame() {
        // 随机选择一个单词
        currentWord = wordList.randomElement()!
        // 重置得分和剩余机会
        score = 0
        remainingChances = 10
        // 清空已猜字母列表
        guessedLetters = []
        // 更新得分和剩余机会标签
        scoreLabel.text = "得分: \(score)"
        remainingChancesLabel.text = "剩余机会: \(remainingChances)"
        // 清空提示标签和游戏状态标签
        hintLabel.text = ""
        gameStatusLabel.text = ""
        // 创建并显示单词的下划线标签
        setupWordLabels()
    }
    
    func setupWordLabels() {
        // 移除之前的单词标签（如果有）
        for label in wordLabels {
            label.removeFromSuperview()
        }
        wordLabels = []
        
        // 根据当前单词创建下划线标签
        for _ in currentWord {
            let label = UILabel()
            label.text = "_"
            label.font = UIFont.systemFont(ofSize: 24)
            addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: guessTextField.bottomAnchor, constant: 80),
                label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40 + (CGFloat(wordLabels.count) * 30)),
                label.heightAnchor.constraint(equalToConstant: 40)
            ])
            wordLabels.append(label)
        }
    }
    
    func updateWordLabels() {
        for (index, label) in wordLabels.enumerated() {
//            if let char = currentWord[index], guessedLetters.contains(char) {
//                label.text = String(char)
//            }
        }
    }
    
    @objc func checkGuess() {
        if let guess = guessTextField.text?.first, let wordIndex = currentWord.firstIndex(of: guess) {
            // 猜对了字母
            guessedLetters.append(guess)
            updateWordLabels()
            hintLabel.text = "猜对了！"
            // 检查是否完成单词猜测
            if !wordLabels.contains(where: { $0.text == "_" }) {
                gameStatusLabel.text = "恭喜你，猜对了单词！得分增加 \(currentWord.count)"
                score += currentWord.count
                scoreLabel.text = "得分: \(score)"
                startNewGame()
            }
        } else {
            // 猜错了字母
            remainingChances -= 1
            remainingChancesLabel.text = "剩余机会: \(remainingChances)"
            if remainingChances == 0 {
                gameStatusLabel.text = "游戏结束，正确单词是 \(currentWord)。"
                guessTextField.isEnabled = false
            } else {
                hintLabel.text = "猜错了，再试试。"
            }
        }
        guessTextField.text = ""
    }
}

extension GuessWordGameView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        checkGuess()
        return true
    }
}
