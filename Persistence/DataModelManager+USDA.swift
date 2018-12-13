//
//  DataModelManager+USDA.swift
//  Food
//
//  Created by Yuansheng Lu on 2018-12-03.
//  Copyright © 2018 SICT. All rights reserved.
//

import Foundation

extension DataModelManager {
    func foodItem_Search(_ searchTerms: String) {
        
        // create a request object
        let request = WebApiRequest()
        
        // Send the request, and write a completion method to pass to the request
        request.sendRequest(toUrlPath: searchTerms,completion: {
            (result: NdbSearchPackage) in
            
            // Save the result in the manager property
            self.ndbSearchPackage = result
            
            // Post a notification so that observers (listeners) know when the response is received
            NotificationCenter.default.post(name: Notification.Name("WebApiDataIsReady"), object: nil)
        })
    }
}
