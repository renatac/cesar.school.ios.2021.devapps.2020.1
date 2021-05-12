//
//  ConsolesTableViewController.swift
//  MyGames
//
//  Created by Douglas Frari on 4/27/21.
//

import UIKit
import CoreData

class ConsolesTableViewController: UITableViewController {
    
    var fetchedResultController: NSFetchedResultsController<Console>!
    
    lazy var label : UILabel = {
        let label = UILabel()
        //Mensagem default
        label.text = "Você não tem plataformas cadastradas"
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadConsoles()
        tableView.allowsSelection = true
        tableView.reloadData()
    }
    
    func loadConsoles() {
        ConsolesManager.shared.loadConsoles(with: context)
        tableView.reloadData()

        let fetchRequest: NSFetchRequest<Console> = Console.fetchRequest()
        let consoleSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [consoleSortDescriptor]
        
        // possui
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        
        do {
            try fetchedResultController.performFetch()
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // ISSSO NAO DEVE SER DEIXADO RETORNANDO ZERO
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Devemos obter os dados do COREDATA aqui ou qualquer estrutura que contem os dados de origem
        let count = fetchedResultController?.fetchedObjects?.count ?? 0
        tableView.backgroundView = count == 0 ? label : nil
        return count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ConsoleTableViewCell
        
        guard let consoleOk = fetchedResultController.fetchedObjects?[indexPath.row] else {
            return cell
        }
        // setando o campo nome e a imagem da célula
        cell.prepareConsole(with: consoleOk)
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            ConsolesManager.shared.deleteConsole(index: indexPath.row, context: context)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier! == "consoleVisualizationSegue" {
            
            let vc = segue.destination as! ConsoleViewController
            
            if let consoles = fetchedResultController.fetchedObjects {
                vc.console = consoles[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
} // fim da classe

extension ConsolesTableViewController: NSFetchedResultsControllerDelegate {
    
    // sempre que algum objeto for modificado esse metodo sera notificado
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        tableView.reloadData()
    }
}
