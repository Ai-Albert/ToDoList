import Foundation

struct ToDoItemModel {
    
    var name: String
    var details: String
    var startDate: Date
    var completionDate: Date
    var isComplete: Bool
    
    init(name: String, details: String, completionDate: Date) {
        self.name = name
        self.details = details
        self.completionDate = completionDate
        self.isComplete = false
        self.startDate = Date()
    }
}
