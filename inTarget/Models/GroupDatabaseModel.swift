//
//  GroupDatabaseModel.swift
//  inTarget
//
//  Created by Desta on 27.04.2021.
//

import Foundation
import Firebase

class GroupDatabaseModel {
    let groupDatabase = Firestore.firestore().collection("groups")
    
    func createGroup(_ title: String,
                     _ date: String,
                     _ image: String,
                     completion: @escaping (Result<String, Error>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        let randomName = UUID().uuidString
        var group = Group(randomName: randomName, title: title, date: date, image: image)
        group.members.append(currentUser.uid)
        
        let data = ["title" : group.title,
                    "date" : group.date,
                    "image" : group.image,
                    "members" : group.members,
                    "under tasks" : group.underTasks] as [String : Any]
        
        groupDatabase.document(randomName).setData(data) {
            error in
            let result = Result {
            }
            
            switch result {
            case .success():
                let database = DatabaseModel()
                database.addGroup(groupID: randomName) { result in
                    switch result {
                    case .success(_):
                        print("okko")
                        completion(.success(randomName))
                    case .failure(let error):
                        print("notton")
                        completion(.failure(error))
                    }
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getGroups(completion: @escaping (Result<[Group], Error>) -> Void) {
        
        let database = DatabaseModel()
        var completionGroups: [Group] = []
        database.getGroups() { [weak self] result in
            switch result {
            case .success(let arrGroups):
                print("okko: \(arrGroups)")
                self?.groupDatabase.getDocuments() { [weak self] (querySnapshot, error) in
                    
                    if let error = error {
                        completion(.failure(error))
                        return
                    } else {
                        for document in querySnapshot!.documents {
                            arrGroups.forEach {
                                if $0 == document.documentID {
                                    print("document.documentID: \(document.documentID)")
                                    
                                    guard let date = document["date"] as? String,
                                          let image = document["image"] as? String,
                                          let title = document["title"] as? String,
                                          let members = document["members"] as? [String] else {
                                        return
                                    }
                                    
                                    let rawUnderTask = document["under tasks"] as? [String: [String: Any]]
                                    let underTasks = self?.makeUnderTasks(with: rawUnderTask) ?? []
                                    
                                    var group = Group(randomName: "\(document.documentID)", title: title, date: date, image: image, members: members)
                                    group.underTasks = underTasks
                                    
                                    completionGroups.append(group)
                                }
                            }
                        }
                    }
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd MM yyyy"
                    
                    completionGroups.sort { (first, second) -> Bool in
                        guard let first = formatter.date(from: first.date),
                              let second = formatter.date(from: second.date) else {
                            return true
                        }
                        return first < second
                    }
                    print("completionGroups: \(completionGroups)")
                    completion(.success(completionGroups))
                }
                completion(.success(completionGroups))
            case .failure(let error):
                print("notton")
                completion(.failure(error))
            }
        }
    }
    
    private func makeUnderTasks(with document: [String: [String: Any]]?) -> [GroupUnderTask] {
        guard let document = document else {
            return []
        }
        
        return document.map({ id, params in
            let title: String = params["title"] as? String ?? ""
            let date: String = params["date"] as? String ?? ""
            let isCompleted: Bool = params["isCompleted"] as? Bool ?? false
            
            return GroupUnderTask(randomName: id, title: title, date: date, isCompleted: isCompleted)
        })
    }
    
}
