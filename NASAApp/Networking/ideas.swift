//
//  ideas.swift
//  NASAApp
//
//  Created by Angus Muller on 15/12/2017.
//  Copyright © 2017 Angus Muller. All rights reserved.
//
/*
import Foundation

class PTWPhotoManager {
    
    static func downloadAllPhotos(params: [String : AnyObject], completion: (latestDate: NSDate?, photosCount: NSUInteger, error: NSError?)) {
        Alamofire.request(.GET, FBPath.photos, parameters: params).responseJSON { response in
            guard response.result.error == nil else {
                print("error calling GET on \(FBPath.photos)")
                print(response.result.error!)
                completion(latestDate: nil, photosCount: 0, error: response.result.error)
                return
            }
            if let value = response.result.value {
                let json = JSON(value)
                if let photos = json[FBResult.data].array {
                    let group = dispatch_group_create()
                    var persistablePhotos = [PTWPhoto](capacity: photos.count)
                    let manager = PTWPhotoManager()
                    for result in photos {
                        dispatch_group_enter(group)
                        let request = manager.downloadAndSaveJsonData(result) { photo, error in
                            if let photo = photo {
                                persistablePhotos.add(photo)
                                dispatch_group_leave(group)
                            } else {
                                completion(latestDate: nil, photosCount: 0, error: error!)
                            }
                        }
                    }
                    
                    dispatch_group_notify(group, dispatch_get_main_queue()) {
                        let realm = try! Realm()
                        try! realm.write {
                            realm.add(persistablePhotos)
                        }
                        let latestDate = …
                            completion(latestDate: latestDate, photosCount: persistablePhotos.count, error: nil)
                    }
                }
            }
        }
    }
    
    func downloadAndSaveJsonData(photoJSON: JSON, completion: (PTWPhoto?, NSError?) -> ()) -> Alamofire.Request {
        let source = photoJSON[FBResult.source].string
        let id = photoJSON[FBResult.id].string
        let created_time = photoJSON[FBResult.date.createdTime].string
        let imageURL = NSURL(string: source!)
        
        print("image requested")
        Alamofire.request(.GET, imageURL!).response() { (request, response, data, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil, error)
            } else {
                print("image response")
                let photo = PTWPhoto()
                photo.id = id
                photo.sourceURL = source
                photo.imageData = data
                photo.createdTime = photo.createdTimeAsDate(created_time!)
                completion(photo, nil)
            }
        }
    }
    
}
*/
