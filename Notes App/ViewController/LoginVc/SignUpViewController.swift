import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var emailIdTxt: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func signUpBtnTapped(_ sender: Any) {
        guard let email = emailIdTxt.text, !email.isEmpty,
              let password = passwordTxt.text, !password.isEmpty else {
            showAlert(message: "Please enter both email and password.")
            return
        }
        
        if !isValidEmail(email) {
              showAlert(message: "Please enter a valid email address (must contain '@' and '.com').")
              return
          }

          // Validate password strength
          if !isValidPassword(password) {
              showAlert(message: "Password must be at least 8 characters long and contain a mix of letters, numbers, and special characters.")
              return
          }
        
        Helper.shared.createUser(emailId: email, password: password) { result in
            switch result {
            case .success(let authResult):
                print("User signed UP: \(authResult.user.uid)")
                
                self.navigationController?.popViewController(animated: false)
                
            case .failure(let error):
                self.showAlert(message: error.localizedDescription)
            }
        }
    }

    @IBAction func logInBtnTapped(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LogInViewController") as? LogInViewController
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
    // Function to validate email format
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.com$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }

    // Function to validate password strength
    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*]).{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }
}
