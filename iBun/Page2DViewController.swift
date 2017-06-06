import UIKit
import QuartzCore

class Page2DViewController: UIViewController
{
    @IBOutlet weak var button2d: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    }
    
    @IBAction func onBack(sender:UIButton)
    {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
