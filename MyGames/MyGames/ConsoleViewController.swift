//
//  ConsoleViewController.swift
//  MyGames
//
//  Created by RENATA on 12/05/21.
//

import UIKit
import CoreData

class ConsoleViewController: UIViewController {
    
    var console: Console?
    
    @IBOutlet weak var lbConsole: UILabel!
    @IBOutlet weak var ivConsole: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        setupScreen()
    }
  
    private func setupScreen() {
        lbConsole.text = console?.name ?? ""
        if let image = console?.image as? UIImage {
            ivConsole.image = image
        } else {
            ivConsole.image = UIImage(named: "noCoverFull")
        }
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "consoleEditSegue") {
            let vc = segue.destination as! ConsoleAddEditViewController
            //selectedIndexPath =
            vc.console = console!
        }
    }
}
