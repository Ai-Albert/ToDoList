import UIKit

protocol ToDoListDelegate: AnyObject {
    func update(task: ToDoItemModel, index: Int)
}

class ToDoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ToDoListDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var toDoItems: [ToDoItemModel] = [ToDoItemModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        // Navigation bar
        title = "To Do List"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
        
        var testItem = ToDoItemModel(name: "Test Item", details: "Test Details", completionDate: Date())
        testItem.isComplete = true
        self.toDoItems.append(testItem)
        let testItem2 = ToDoItemModel(name: "Test Item 2", details: "Test Details 2", completionDate: Date())
        self.toDoItems.append(testItem2)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tableView.setEditing(false, animated: false)
    }
    
    /* NAVIGATION */
    
    @objc func addTapped() {
        performSegue(withIdentifier: "AddTaskSegue", sender: nil)
    }
    
    @objc func editTapped() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        if tableView.isEditing {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editTapped))
        }
        else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (UITableViewRowAction, indexPath) in
            self.toDoItems.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = toDoItems[indexPath.row]
        let toDoTuple = (indexPath.row, selectedItem)
        performSegue(withIdentifier: "TaskDetailsSegue", sender: toDoTuple)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TaskDetailsSegue" {
            guard let destinationVC = segue.destination as? ToDoDetailsViewController else {
                return
            }
            guard let toDoTuple = sender as? (Int, ToDoItemModel) else {
                return
            }
            destinationVC.toDoIndex = toDoTuple.0
            destinationVC.toDoItem = toDoTuple.1
            destinationVC.delegate = self
        }
    }
    
    func update(task: ToDoItemModel, index: Int) {
        toDoItems[index] = task
        tableView.reloadData()
    }
    
    /* TABLE VIEW */

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let toDoItem = toDoItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItem")!
        
        cell.textLabel?.text = toDoItem.name
        cell.detailTextLabel?.text = toDoItem.isComplete ? "Complete" : "Incomplete"
        
        return cell
    }
}
