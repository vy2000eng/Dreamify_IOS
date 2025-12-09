//
//  EditDreamViewController.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 11/22/25.
//

import UIKit
class EditDreamViewController:UIViewController {
    var editDreamView:EditDreamView
    var dream:DreamViewModel
    var editDreamRecordingViewModel: EditDreamRecordingViewModel
    
    
    
    
    init( dream: DreamViewModel) {
        self.dream = dream
        self.editDreamView = EditDreamView(frame: .zero,dream: dream)
        self.editDreamRecordingViewModel = EditDreamRecordingViewModel(dream: dream)
        super.init(nibName: nil, bundle: nil)
        
        
        
    }
    var onSaveButtomTapped: (() throws -> Void)?

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupView()
        
        
        
        
        
    }
    func setupView(){
        view.addSubview(editDreamView)
        editDreamView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            editDreamView.topAnchor.constraint(equalTo: view.topAnchor),
            editDreamView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            editDreamView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            editDreamView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        setupNavigationBar()
        setupTextFieldDelegates()
        
        
        
        
    }
    private func setupNavigationBar() {
        title = "Edit Dream"
        
        // Cancel button (left)
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelButtonTapped)
        )
        
        // Save button (right)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(saveButtonTapped)
        )
        
        // Style the navigation bar
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    private func setupTextFieldDelegates() {
         editDreamView.dreamTitleTextView.delegate = self
         editDreamView.descriptionTextView.delegate = self
     }
     
     // MARK: - Actions
     
     @objc private func saveButtonTapped() {
         guard let newTitle = editDreamView.dreamTitleTextView.text, !newTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
             showError(message: "Please enter a title")
             return
         }
         
         let  tag = editDreamView.tagButton.currentTitle!//titleLabel!.text
         
         let newDescription = editDreamView.descriptionTextView.text ?? ""
         if tag == "No Tag"{
             editDreamRecordingViewModel.updateDream(dreamTitle: newTitle, dreamTranscription:  newDescription, tag: nil)

             
         }else{
             editDreamRecordingViewModel.updateDream(dreamTitle: newTitle, dreamTranscription:  newDescription, tag: tag)

             
         }
         do{
             try onSaveButtomTapped?()
             

             
         }catch let err as NSError {
             print("\(err)")
         }
         
         dismiss(animated: true)

     }
     
     @objc private func cancelButtonTapped() {
         // Check if there are unsaved changes
         let hasChanges = editDreamView.dreamTitleTextView.text != dream.title ||
                         editDreamView.descriptionTextView.text != (dream.transcribedText ?? "")
         
         if hasChanges {
             let alert = UIAlertController(
                 title: "Discard Changes?",
                 message: "You have unsaved changes. Are you sure you want to discard them?",
                 preferredStyle: .alert
             )
             
             alert.addAction(UIAlertAction(title: "Keep Editing", style: .cancel))
             alert.addAction(UIAlertAction(title: "Discard", style: .destructive) { [weak self] _ in
                 self?.dismiss(animated: true)
             })
             
             present(alert, animated: true)
         } else {
             dismiss(animated: true)
         }
     }
     
     private func showError(message: String) {
         let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "OK", style: .default))
         present(alert, animated: true)
     }
 }
    
    
    
    
    
    
    
    
    
    
    
    
    
extension EditDreamViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        // Auto-resize text view
        let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: .infinity))
        textView.invalidateIntrinsicContentSize()
    }
}
