import UIKit

class LightsOutView: UIView {
    let gridSize = 5
    var lights: [[Bool]] = Array(repeating: Array(repeating: false, count: 5), count: 5)
    var isGameOver = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        setupLights()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLights() {
        // 随机初始化一些灯为亮
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                if Int.random(in: 0...1) == 0 {
                    lights[row][col] = true
                }
            }
        }
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        drawLights()
    }
    
    func drawLights() {
        let cellSize = bounds.width / CGFloat(gridSize)
        let context = UIGraphicsGetCurrentContext()!
        context.setLineWidth(2)
        
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                let x = CGFloat(col) * cellSize
                let y = CGFloat(row) * cellSize
                if lights[row][col] {
                    context.setFillColor(UIColor.yellow.cgColor)
                } else {
                    context.setFillColor(UIColor.darkGray.cgColor)
                }
                context.fill([CGRect(x: x, y: y, width: cellSize, height: cellSize)])
//                context.fillRect(CGRect(x: x, y: y, width: cellSize, height: cellSize))
                context.setStrokeColor(UIColor.white.cgColor)
//                context.strokeRect(CGRect(x: x, y: y, width: cellSize, height: cellSize))
                context.stroke(CGRect(x: x, y: y, width: cellSize, height: cellSize))
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let col = Int(location.x / (bounds.width / CGFloat(gridSize)))
            let row = Int(location.y / (bounds.height / CGFloat(gridSize)))
            toggleLight(at: row, col: col)
            checkGameOver()
            setNeedsDisplay()
        }
    }
    
    func toggleLight(at row: Int, col: Int) {
        lights[row][col] = !lights[row][col]
        if row > 0 {
            lights[row - 1][col] = !lights[row - 1][col]
        }
        if row < gridSize - 1 {
            lights[row + 1][col] = !lights[row + 1][col]
        }
        if col > 0 {
            lights[row][col - 1] = !lights[row][col - 1]
        }
        if col < gridSize - 1 {
            lights[row][col + 1] = !lights[row][col + 1]
        }
    }
    
    func checkGameOver() {
        for row in lights {
            for light in row {
                if light {
                    isGameOver = false
                    return
                }
            }
        }
        isGameOver = true
    }
}
