import UIKit
import FirebaseCore
import FirebaseFirestore

class DataAddViewController: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var detailText: UITextField!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    
    let db = Firestore.firestore()
      
    override func viewDidLoad() {
        super.viewDidLoad()

        textFeildEdit()
        hideKeyboardWhenTappedAround()
    }
    
    func textFeildEdit(){
        titleText.backgroundColor = UIColor.clear
        
        titleText.attributedPlaceholder = NSAttributedString(
            string: "Title",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        
        detailText.backgroundColor = UIColor.clear
        
        detailText.attributedPlaceholder = NSAttributedString(
            string: "Type Something",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
    }
  //0123456789
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func saveBtnTapped(_ sender: Any) {
        guard let title = titleText.text, !title.isEmpty,
              let detail = detailText.text, !detail.isEmpty else {
            showAlert(message: "Please fill all fields")
            return
        }
        
        let data: [String: Any] = [
            "title": title,
            "detail": detail
        ]
        
        db.collection("Notes").addDocument(data: data) { error in
            if let error = error {
                self.showAlert(message: "Error Saving Data: \(error.localizedDescription)")
            } else {
                self.titleText.text = ""
                self.detailText.text = ""
                self.showAlert(message: "Data Saved Successfully") {
                    // Navigate back after alert dismisses
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Data Save it", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true, completion: nil)
    }
}
