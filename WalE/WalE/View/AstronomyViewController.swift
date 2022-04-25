//
//  AstronomyViewController.swift
//  SampleApp
//
//  Created by Pooja Soni on 25/04/22.
//

import UIKit

class AstronomyViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionlbl: UILabel!
    @IBOutlet weak var loadinglbl: UILabel!
    
    lazy var viewModel = {
        AstronomyViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        viewModel.isNetworkReachable {[weak self] (success) in
            guard let self = self else {return}
            if success && self.viewModel.isUserEnteredFirstTimeForTheDay(){
                self.loadData()
            }else {
                self.loadFromCache()
            }
        }
    }
    
    private func loadData(){
        // Activity Indicator
            viewModel.fetchPost {[weak self] (error) in
                DispatchQueue.main.async {
                    guard let self = self
                    else { return }
                    self.loadinglbl.isHidden = true
                    if let error = error {
                        self.showError(error)
                    } else {
                        self.upadetUI()
                    }
                }
            }
    }
    
    private func loadFromCache(){
        //Load it from the saved data if there
        viewModel.getSavedResponse { [weak self](error) in
            DispatchQueue.main.async {
                guard let self = self
                else { return }
                self.loadinglbl.isHidden = true
                if let error = error {
                    self.showError(error)
                } else {
                    if let currentDate = UserDefaults.standard.object(forKey: "currentDate") as? Date{
                        //compare the date to show Toast message
                        if Calendar.current.compare(Date(), to: currentDate, toGranularity: .day) != .orderedSame{
                            self.showToast("We are not connected to the internet, showing you the last image we have.")
                        }
                    }
                    self.upadetUI()
                }
            }
        }
    }
    
    private func upadetUI() {
        self.navigationItem.title = viewModel.astronomy?.title
        descriptionlbl.text = viewModel.astronomy?.description
        //When the image is saved to userDefaults it shows the stored Image else it downloads the image each time
        getDownlaodedImage()
    }
    
    private func getDownlaodedImage(){
        if let imageData = UserDefaults.standard.object(forKey: "imageDownloaded") as? Data,
           let image = UIImage(data: imageData) {
            self.imageView.image = image
        }else {
            if let imageURL = viewModel.astronomy?.imageURL, let data = try? Data(contentsOf: imageURL) {
                let image = UIImage(data: data)
                self.imageView.image = image
                UserDefaults.standard.set(image?.jpegData(compressionQuality: .greatestFiniteMagnitude), forKey: "imageDownloaded")
            }
        }
    }
    
    private func showError(_ errorMsg: String) {
        let alertVC = UIAlertController(title: "Error!", message: errorMsg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alertVC.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
    }

}

extension AstronomyViewController {
    static let DELAY_SHORT = 1.5
    static let DELAY_LONG = 3.0
    
    func showToast(_ text: String, delay: TimeInterval = DELAY_LONG) {
        let label = ToastLabel()
        label.backgroundColor = #colorLiteral(red: 0.737254902, green: 0.1294117647, blue: 0.2941176471, alpha: 1)
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        label.alpha = 0
        label.text = text
        label.clipsToBounds = true
        label.layer.cornerRadius = 20
        label.numberOfLines = 0
        label.textInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        let saveArea = view.safeAreaLayoutGuide
        label.centerXAnchor.constraint(equalTo: saveArea.centerXAnchor, constant: 0).isActive = true
        label.leadingAnchor.constraint(greaterThanOrEqualTo: saveArea.leadingAnchor, constant: 15).isActive = true
        label.trailingAnchor.constraint(lessThanOrEqualTo: saveArea.trailingAnchor, constant: -15).isActive = true
        label.bottomAnchor.constraint(equalTo: saveArea.bottomAnchor, constant: -30).isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            label.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: delay, options: .curveEaseOut, animations: {
                label.alpha = 0
            }, completion: {_ in
                label.removeFromSuperview()
            })
        })
    }
}

