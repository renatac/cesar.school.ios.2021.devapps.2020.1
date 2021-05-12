//
//  ConsoleAddEditViewController.swift
//  MyGames
//
//  Created by RENATA on 12/05/21.
//
import UIKit
import Photos

class ConsoleAddEditViewController: UIViewController {

    var console: Console!
    
    @IBOutlet weak var tfConsole: UITextField!
    @IBOutlet weak var ivConsole: UIImageView!
    @IBOutlet weak var btConsole: UIButton!
    @IBOutlet weak var btAddEdit: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        ConsolesManager.shared.loadConsoles(with: context)
        //saveConsole(with: nil)
        // Do any additional setup after loading the view.
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareLayout()
    }
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
 */
    private func prepareLayout() {
        if console != nil {
            title = "Editar Plataforma"
            btAddEdit.setTitle("ALTERAR", for: .normal)
            tfConsole.text = console.name
            
            
            ivConsole.image = console.image as? UIImage
            if console.image != nil {
                btConsole.setTitle(nil, for: .normal)
            }
        }
    }
    
    @IBAction func addEditImage(_ sender: Any) {
        
        let alert = UIAlertController(title: "Selecinar capa", message: "De onde você quer escolher a foto?", preferredStyle: .actionSheet)
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default, handler: {(action: UIAlertAction) in
            self.selectPictureForConsole(sourceType: .photoLibrary)
        })
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Album de fotos", style: .default, handler: {(action: UIAlertAction) in
            self.selectPictureForConsole(sourceType: .savedPhotosAlbum)
        })
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func chooseImageFromLibrary(sourceType: UIImagePickerController.SourceType) {
        
        DispatchQueue.main.async {
            //Notifica quando o usuário selecionar a foto, pegar a foto
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = sourceType
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.navigationBar.tintColor = UIColor(named: "main")
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    private func selectPictureForConsole(sourceType: UIImagePickerController.SourceType) {
        //Photos
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    
                    self.chooseImageFromLibrary(sourceType: sourceType)
                    
                } else {
                    
                    print("unauthorized -- TODO message")
                }
            })
        } else if photos == .authorized {
            
            self.chooseImageFromLibrary(sourceType: sourceType)
        }
    }
    
    @IBAction func addEditConsole(_ sender: Any) {
        //Acao de salvar um novo jogo ou editar um existente
        
        if console == nil {
            //tratasse de uma plataforma nova
            //context foi obtido via ViewController + CoreData
            console = Console(context: context)
        }
        console.name = tfConsole.text
           
        console.image = ivConsole.image
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        // Back na navigation
        
        navigationController?.popViewController(animated: true)
        
    }
    
}
//Extensão dos Eventos da PickerView
extension ConsoleAddEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // tip. implementando os 2 protocols o evento sera notificando apos user selecionar a imagem
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            // ImageView won't update with new image
            // bug fixed: https://stackoverflow.com/questions/42703795/imageview-wont-update-with-new-image
            DispatchQueue.main.async {
                self.ivConsole.image = pickedImage
                self.ivConsole.setNeedsDisplay()
                self.btConsole.setTitle(nil, for: .normal)
                self.btConsole.setNeedsDisplay()
            }
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
}
