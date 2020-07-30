//
//  DocumentBrowserViewController.swift
//  documented image gallery
//
//  Created by Moutaz_Hegazy on 7/3/20.
//  Copyright © 2020 Moutaz_Hegazy. All rights reserved.
//

import UIKit


class DocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        allowsDocumentCreation = false
        allowsPickingMultipleItems = false
        
        templete = try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("Untitled.json")
        
        if templete != nil{
            allowsDocumentCreation = FileManager.default.createFile(atPath: templete!.path, contents: Data())
        }
    }
    
    private var templete : URL?
    
    
    // MARK: UIDocumentBrowserViewControllerDelegate
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
        
        importHandler(templete , .copy)
        
        
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }
        
        // Present the Document View Controller for the first document that was picked.
        // If you support picking multiple items, make sure you handle them all.
        presentDocument(at: sourceURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        // Present the Document View Controller for the new newly created document
        presentDocument(at: destinationURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
        // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
    }
    
    // MARK: Document Presentation
    
    func presentDocument(at documentURL: URL) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let imageGalleryVC = storyBoard.instantiateViewController(withIdentifier: "galleryController")
        
        if let imageCollectionVC = imageGalleryVC.contents as? imageGallaryCollectionViewController
        {
            imageCollectionVC.document = ImageGalleryDocument(fileURL : documentURL)
            print("document loaded")
        }
        
        present(imageGalleryVC,animated: true)
    }
}


extension UIViewController{
    var contents : UIViewController{
        if let navcon = self as? UINavigationController{
            return navcon.visibleViewController ?? navcon
        }else{
            return self
        }
    }
}
