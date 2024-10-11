import UIKit
import FirebaseFirestore

class MainViewController: UIViewController {

    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!

    var items: [(id: String, title: String, details: String)] = [] // Store document ID as well
    let db = Firestore.firestore()
    var age: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchData()
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData() // Reload data when the view appears
    }

    func fetchData() {
        db.collection("Notes").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching documents: \(error)")
                return
            }

            self.items = []
            if let documents = snapshot?.documents {
                for document in documents {
                    let data = document.data()
                    if let title = data["title"] as? String, let details = data["detail"] as? String { // Corrected here
                        self.items.append((id: document.documentID, title: title, details: details))
                    }
                }
            }

            self.tableView.reloadData()
        }
    }

    @IBAction func addBtnTapped(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DataAddViewController") as? DataAddViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    

    func randomColor() -> UIColor {
        let red = CGFloat(arc4random_uniform(128) + 128) / 255.0 // Range 128-255
        let green = CGFloat(arc4random_uniform(128) + 128) / 255.0 // Range 128-255
        let blue = CGFloat(arc4random_uniform(128) + 128) / 255.0 // Range 128-255
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ItemDisplayTableViewCell else {
            fatalError("The dequeued cell is not an instance of ItemDisplayTableViewCell.")
        }

 
        
         cell.bgView.layer.cornerRadius = 20
         cell.bgView.layer.masksToBounds = true
         cell.bgView.backgroundColor = randomColor()
        
        let item = items[indexPath.row]
        cell.title.text = item.title
        cell.typeSomething.text = item.details
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        // Get the selected item
        let selectedItem = items[indexPath.row]

        // Instantiate UpdateViewController
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UpdateViewController") as! UpdateViewController
        
        // Pass the title, details, and document ID to UpdateViewController
        detailVC.titleTextValue = selectedItem.title
        detailVC.detailTextValue = selectedItem.details
        detailVC.documentId = selectedItem.id // Make sure to pass the document ID

        // Navigate to UpdateViewController
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let itemToDelete = items[indexPath.row]
            db.collection("Notes").document(itemToDelete.id).delete { error in
                if let error = error {
                    print("Error deleting document: \(error)")
                } else {
                    self.items.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
    }
}
