import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let lightsOutView = LightsOutView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        
        
        view.addSubview(lightsOutView)
        
        lightsOutView.center = view.center
    }
}
