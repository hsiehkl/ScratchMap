//
//  PostProvider.swift
//  ScratchMap
//
//  Created by Cheng-Shan Hsieh on 2018/1/13.
//  Copyright © 2018年 HsinTing Hsieh. All rights reserved.
//

import Foundation
import Firebase

protocol PostProviderDelegate: class {
    func didReceivePost(_ provider: PostProvider, posts: [Post])
}

class PostProvider {
    
    weak var delegate: PostProviderDelegate?
    
    var posts = [Post]()
    
    func requestData() {
        
        let user = Auth.auth().currentUser
        
        guard let userId = user?.uid else {
            print("No current user id")
            return
        }
        
        let ref = Database.database().reference()
        
        ref.child("users").child(userId).child("posts").observe(.value) { (snapshot) in
            
            guard let dataValue = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            print(dataValue)
            
            for data in dataValue {
                
                if let post = data.value as? [String: String] {
                    
                    print("post: \(post)")
                    
                    guard
                        let content = post[Post.Schema.content],
                        let title = post[Post.Schema.title],
                        let imageUrl = post[Post.Schema.imageUrl],
                        let date = post[Post.Schema.date]
                        
                        else {
                            return
                    }
                    
                    self.posts.append(Post(title: title, content: content, imageUrl: imageUrl, date: date))
                }
            }
            self.delegate?.didReceivePost(self, posts: self.posts)
            print("data is here \(self.posts)")
        }
    }
}
