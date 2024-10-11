import Foundation
import FirebaseAuth

class Helper {
    
    static let shared = Helper()
    
    func createUser(emailId: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        Auth.auth().createUser(withEmail: emailId, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let authResult = authResult {
                completion(.success(authResult))
            }
        }
    }
    
    func logIn(emailId: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        Auth.auth().signIn(withEmail: emailId, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let authResult = authResult {
                completion(.success(authResult))
            }
        }
    }
    
    func checkUserSignedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
}
