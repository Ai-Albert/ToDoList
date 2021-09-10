import UIKit

class ToDoDetailsViewController: UIViewController {
    
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var taskDetailsTextView: UITextView!
    @IBOutlet weak var taskCompletionButton: UIButton!
    @IBOutlet weak var taskCompletionDate: UILabel!
    
    var toDoIndex: Int!
    var toDoItem: ToDoItemModel!
    weak var delegate: ToDoListDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskTitleLabel.text = toDoItem.name
        taskDetailsTextView.text = toDoItem.details
        
        if toDoItem.isComplete {
            disableButton()
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy hh:mm"
        taskCompletionDate.text = formatter.string(from: toDoItem.completionDate)
    }
    
    func disableButton() {
        taskCompletionButton.backgroundColor = UIColor.gray
        taskCompletionButton.isEnabled = false
    }
    
    @IBAction func taskDidComplete(_ sender: Any) {
        toDoItem.isComplete = true
        delegate?.update(task: toDoItem, index: toDoIndex)
        disableButton()
    }
}
