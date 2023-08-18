//
//  ViewController.swift
//  GetFoxPhoto
//
//  Created by Burak Gül on 17.08.2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    var pickerView = UIPickerView()
    var dataSource = [
        "Fox" : 953,
        "Curious" : 40,
        "Happy" : 25,
        "Scary" : 34,
        "Sleeping" : 48
    ]
    var baseURL = "https://img.foxes.cool/"
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPicker))
        view.addGestureRecognizer(tapGesture)
        textField.inputView = pickerView
        createToolBar()
        setupConstraint()
    }
    func createToolBar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ViewController.dismissPicker))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        pickerView.selectRow(0, inComponent: 0, animated: false)
    }
    
    @objc func dismissPicker(){
        view.endEditing(true)
    }
    func setupConstraint() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            imageView.heightAnchor.constraint(equalToConstant: 50),
            textField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 50),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
    }
    
    func getImage(from urlString : String)  {
        // step 1 create a url
        if let url = URL(string: urlString) {
            // step 2 create a urlSession
            let session = URLSession(configuration: .default)
            // step 3 give a task to session
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                }
                if let safeData = data {
                    DispatchQueue.main.async {
                        let image = UIImage(data: safeData)
                        self.imageView.image = image
                    }
                }
            }
            // step 4 start the task
            task.resume()
        }
    }
}

//MARK: - UIPickerViewsortedDataSource

extension ViewController : UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
}

//MARK: - UIPickerViewDelegate

extension ViewController : UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array(dataSource)[row].key
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedFox = Array(dataSource)[row].key
        self.textField.text = selectedFox
        if let selectedFoxMaxValue = dataSource["\(selectedFox)"] {
            let selectedFoxValue = Int.random(in: 0..<selectedFoxMaxValue)
            let url = "\(baseURL)\(selectedFox)/\(selectedFoxValue).jpg?width=150&height=150"
            getImage(from: url)
        }
    }
}



