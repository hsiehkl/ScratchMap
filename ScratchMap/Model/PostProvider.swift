//
//  PostProvider.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2018/1/19.
//  Copyright © 2018年 HsinTing Hsieh. All rights reserved.
//

import Foundation
import Firebase

protocol PostProviderDelegate: class {
    func didReceivePost(_ provider: PostProvider, posts: [Post])
}

class PostProvider {
    
    weak var delegate: PostProviderDelegate?
    
    var allPosts = [Post]()
    
    let userId = Auth.auth().currentUser?.uid
    
    let ref = Database.database().reference()
    
    func requestData() {
        
        guard let id = userId else { return }
        
        ref.child("users").child(id).child("posts").queryOrdered(byChild: "date").observe(.value) { (snapshot) in
        
                guard let dataValue = snapshot.children.allObjects as? [DataSnapshot] else { return }
        
                self.allPosts = []
        
                for data in dataValue {
        
                    if let post = data.value as? [String: String] {
        
                        guard
                            let location = post[Post.Schema.location],
                            let content = post[Post.Schema.content],
                            let title = post[Post.Schema.title],
                            let imageUrl = post[Post.Schema.imageUrl],
                            let date = post[Post.Schema.date]
        
                        else {
                            return
                        }
        
                    self.allPosts.append(Post(title: title, location: location, content: content, imageUrl: imageUrl, date: date))
                    }
                }
            self.allPosts.reverse()
            self.delegate?.didReceivePost(self, posts: self.allPosts)
        }
    }
}

