//
//  LogInViewController.swift
//  News App
//
//  Created by R88 on 01/10/24.
//

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailIdText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func loginBtnTapped(_ sender: Any) {
        guard let email = emailIdText.text, !email.isEmpty,
              let password = passwordText.text, !password.isEmpty else {
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
        
        Helper.shared.logIn(emailId: email, password: password) { result in
            switch result{
            case .success(let authResult):
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
                self.navigationController?.pushViewController(vc!, animated: true)
                break
            case .failure(let error):
                self.showAlert(message: "Please Enter the Correct Email Id And Password")
                break
            }
        }
    }
    
    @IBAction func signUpBtnTapped(_ sender: Any) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController
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
