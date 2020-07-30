//
//  Document.swift
//  documented image gallery
//
//  Created by Moutaz_Hegazy on 7/3/20.
//  Copyright © 2020 Moutaz_Hegazy. All rights reserved.
//

import UIKit

class ImageGalleryDocument: UIDocument {
    
    var imageGallery : ImageGalleryModel?
    
    var thumbnail : UIImage?
    
    override func contents(forType typeName: String) throws -> Any {
        // Encode your document with an instance of NSData or NSFileWrapper
        return imageGallery?.json ?? Data()
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        // Load your document from contents
        if let jsonData = contents as? Data {
            imageGallery = ImageGalleryModel(with: jsonData)
        }
    }
    
    override func fileAttributesToWrite(to url: URL, for saveOperation: UIDocument.SaveOperation) throws -> [AnyHashable : Any] {
        var attributes = try super.fileAttributesToWrite(to: url, for: saveOperation)
        
        if let thumbnail = self.thumbnail{
            
            attributes[URLResourceKey.thumbnailDictionaryKey] = [URLThumbnailDictionaryItem.NSThumbnail1024x1024SizeKey : thumbnail]
            
        }
        
        return attributes
    }
}

