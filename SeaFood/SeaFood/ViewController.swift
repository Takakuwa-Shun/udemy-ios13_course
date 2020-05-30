//
//  ViewController.swift
//  SeaFood
//
//  Created by 高桑駿 on 2020/04/25.
//  Copyright © 2020 高桑駿. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func detect(image: CIImage) -> Void {
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading CoreML Model Failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("model failed to process image")
            }
            
            if let firstResult = results.first {
                print(firstResult)
                self.label.text = firstResult.confidence.description
                if firstResult.identifier.contains("hotdog") {
                    self.navigationItem.title = "Hot Dog"
                    
                } else {
                    self.navigationItem.title = firstResult.identifier
                }
                
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }

    }
    
}

//MARK: - UIImagePickerControllerDelegate

extension ViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickImage = info[.originalImage] as? UIImage {
            imageView.image = userPickImage
            
            guard let ciImage = CIImage(image: userPickImage) else {
                fatalError("we could not convert uiimage to ciimage")
            }
            detect(image: ciImage)
        }

        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - UINavigationControllerDelegate

extension ViewController: UINavigationControllerDelegate {
    
}

