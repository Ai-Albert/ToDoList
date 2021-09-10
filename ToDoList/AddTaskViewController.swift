import UIKit

class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var taskDetailsTextView: UITextView!
    @IBOutlet weak var taskCompletionDatePicker: UIDatePicker!
    @IBOutlet weak var scrollView: UIScrollView!
    lazy var touchView: UIView = {
        let _touchView = UIView()
        _touchView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
        let touchViewTapped = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        _touchView.addGestureRecognizer(touchViewTapped)
        _touchView.isUserInteractionEnabled = true
        _touchView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        return _touchView
    }()
    
    let toolBarDone = UIToolbar.init()
    var activeTextField: UITextField?
    var activeTextView: UITextView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotification()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Cancel button in nav bar
        let navigationItem = UINavigationItem(title: "Add Task")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonDidTouch))
        navigationBar.items = [navigationItem]
        
        // taskDetails border
        taskDetailsTextView.layer.borderColor = UIColor.lightGray.cgColor
        taskDetailsTextView.layer.borderWidth = CGFloat(1)
        taskDetailsTextView.layer.cornerRadius = CGFloat(5)
        
        // keyboard disappear toolbar
        toolBarDone.sizeToFit()
        toolBarDone.barTintColor = UIColor.red
        toolBarDone.isTranslucent = true
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let barBtnDone = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
        barBtnDone.setTitleTextAttributes(
            [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17),
                NSAttributedString.Key.foregroundColor: UIColor.white
            ],
            for: .normal)
        toolBarDone.items = [flexSpace, barBtnDone, flexSpace]
        taskNameTextField.inputAccessoryView = toolBarDone
        taskNameTextField.delegate = self
        taskDetailsTextView.inputAccessoryView = toolBarDone
        taskDetailsTextView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        deregisterFromKeyboardNotification()
    }
    
    @objc func cancelButtonDidTouch() {
        dismiss(animated: true, completion: nil)
    }
    
    func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        view.addSubview(touchView)
        
        let info: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: (keyboardSize!.height + toolBarDone.frame.size.height + 10), right: 0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect: CGRect = UIScreen.main.bounds
        aRect.size.height -= keyboardSize!.height
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        touchView.removeFromSuperview()
    }
    
    func deregisterFromKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func addTaskDidTouch(_ sender: Any) {
        
    }
}


// Ensures that we know which text field is being edited and when
extension AddTaskViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
}

// Ensures that we know which text view is being edited and when
extension AddTaskViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        activeTextView = textView
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        activeTextView = nil
    }
}
