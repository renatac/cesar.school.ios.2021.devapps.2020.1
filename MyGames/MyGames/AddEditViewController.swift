//
//  AddEditViewController.swift
//  MyGames
//
//  Created by Douglas Frari on 4/27/21.
//

import UIKit

class AddEditViewController: UIViewController {

    var game: Game!
    
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfConsole: UITextField!
    @IBOutlet weak var dpReleaseDate: UIDatePicker!
    @IBOutlet weak var btAddEdit: UIButton!
    @IBOutlet weak var btCover: UIButton!
    @IBOutlet weak var ivCover: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func AddEditCover(_ sender: UIButton) {
        // para adicionar uma imagem da biblioteca
    }
    
    @IBAction func addEditGame(_ sender: UIButton) {
        // acao salvar novo ou editar existente
        
        if game == nil {
            game = Game(context: context)
        }
        game.title = tfTitle.text
        game.releaseDate = dpReleaseDate.date
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        // Back na navigation
        navigationController?.popViewController(animated: true)
        
    }

} // fim da classe
