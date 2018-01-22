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
    
//    var countryPosts = [Post]()
    
    let userId = Auth.auth().currentUser?.uid
    
    let ref = Database.database().reference()
    
    func requestData() {
        
        print("self.allPosts.count0000 \(self.allPosts.count)")
        
        guard let id = userId else { return }
        
        ref.child("users").child(id).child("posts").observe(.value) { (snapshot) in
            
            guard let dataValue = snapshot.children.allObjects as? [DataSnapshot] else { print("dataValue"); return }
            
            
            self.allPosts.removeAll()
            
            for data in dataValue {
                
                let countryId = data.key
                
                if let post = data.value as? [String: Any] {
                    
                    for (key, value) in post {
                        
                        guard let singlePost = value as? [String: String] else { print("我錯了"); return }
                        
                        guard
                            let location = singlePost[Post.Schema.location],
                            let content = singlePost[Post.Schema.content],
                            let title = singlePost[Post.Schema.title],
                            let imageUrl = singlePost[Post.Schema.imageUrl],
                            let date = singlePost[Post.Schema.date]
                        
                        else {
                            return
                        }
                        
                        self.allPosts.append(Post(title: title, location: location, content: content, imageUrl: imageUrl, date: date, postId: key, countryId: countryId))
                    }
                    
//                    for postdetail in post.values {
//
//                        guard let singlePost = postdetail as? [String: String] else { print("我錯了"); return }
//
//                        guard
//                            let location = singlePost[Post.Schema.location],
//                            let content = singlePost[Post.Schema.content],
//                            let title = singlePost[Post.Schema.title],
//                            let imageUrl = singlePost[Post.Schema.imageUrl],
//                            let date = singlePost[Post.Schema.date]
//
//                            else {
//                                return
//                        }
//
//                        self.allPosts.append(Post(title: title, location: location, content: content, imageUrl: imageUrl, date: date))
//                    }
                }
            }
            self.delegate?.didReceivePost(self, posts: self.allPosts)
            print("self.allPosts.count33333 \(self.allPosts.count)")
        }
        
    
//    func requestData() {
//
//        guard let id = userId else { return }
//
//        ref.child("users").child(id).child("posts").observe(.childAdded) { (snapshot) in
//
//            guard let dataValue = snapshot.children.allObjects as? [DataSnapshot] else { return }
//
//            print(dataValue)
//
//            self.allPosts.removeAll()
//
//            for data in dataValue {
//
//                if let post = data.value as? [String: String] {
//
//                    print("post: \(post)")
//
//                    guard
//                        let content = post[Post.Schema.content],
//                        let title = post[Post.Schema.title],
//                        let imageUrl = post[Post.Schema.imageUrl],
//                        let date = post[Post.Schema.date]
//
//                        else {
//                            return
//                    }
//
//                    self.allPosts.append(Post(title: title, content: content, imageUrl: imageUrl, date: date))
//                }
//            }
//            self.delegate?.didReceivePost(self, posts: self.allPosts)
//            print("data is here \(self.allPosts)")
//        }
    }
    
//    func requestCountryData(countryId: String) {
//
//        guard let id = userId else { return }
//
//        ref.child("users").child(id).child("posts").child("\(countryId)").observe(.value) { (snapshot) in
//
//            guard let dataValue = snapshot.children.allObjects as? [DataSnapshot] else { return }
//
//            print(dataValue)
//
//            self.countryPosts = []
//
//            for data in dataValue {
//
//                if let post = data.value as? [String: String] {
//
//                    print("post: \(post)")
//
//                    guard
//                        let content = post[Post.Schema.content],
//                        let title = post[Post.Schema.title],
//                        let imageUrl = post[Post.Schema.imageUrl],
//                        let date = post[Post.Schema.date]
//
//                        else {
//                            return
//                    }
//
//                    self.countryPosts.append(Post(title: title, content: content, imageUrl: imageUrl, date: date))
//                }
//            }
//            self.delegate?.didReceivePost(self, posts: self.countryPosts)
//            print("data is here \(self.countryPosts)")
//        }
//    }
}
