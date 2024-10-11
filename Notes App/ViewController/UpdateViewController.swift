import UIKit
import FirebaseFirestore

class UpdateViewController: UIViewController {

    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var deripisionText: UITextField!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var backBtn: UIButton!

    var titleTextValue: String?
    var detailTextValue: String?
    var documentId: String? // Add this line

    private let db = Firestore.firestore() // Initialize Firestore

    override func viewDidLoad() {
        super.viewDidLoad()
        textFeildEdit()
        
        // Populate text fields with passed data
        titleText.text = titleTextValue
        deripisionText.text = detailTextValue
    }
    
    func textFeildEdit() {
        titleText.backgroundColor = UIColor.clear
        titleText.attributedPlaceholder = NSAttributedString(
            string: "Title",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        
        deripisionText.backgroundColor = UIColor.clear
        deripisionText.attributedPlaceholder = NSAttributedString(
            string: "Type Something",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
    }

    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func saveBtnTapped(_ sender: Any) {
        guard let title = titleText.text, !title.isEmpty,
              let details = deripisionText.text, !details.isEmpty,
              let documentId = documentId else { // Ensure documentId is used
            showAlert(message: "Please fill in all fields")
            return
        }

        // Create a dictionary with updated data
        let updatedData: [String: Any] = [
            "title": title,
            "detail": details // Correct key here
        ]

        // Update the document in Firestore
        db.collection("Notes").document(documentId).setData(updatedData, merge: true) { error in
            if let error = error {
                self.showAlert(message: "Error Saving Data: \(error.localizedDescription)")
            } else {
                // Pop view controller after successful update
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
}
