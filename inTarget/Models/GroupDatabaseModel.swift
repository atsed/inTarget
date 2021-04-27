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
    
    func getGroups(completion: @escaping (Result<[Task], Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            return
        }
        groupDatabase.document(user.uid).collection("tasks").getDocuments() { [weak self] (querySnapshot, error) in
            
            var completionTasks: [Task] = []
            
            if let error = error {
                completion(.failure(error))
                return
            } else {
                for document in querySnapshot!.documents {
                    guard let date = document["date"] as? String,
                          let image = document["image"] as? String,
                          let title = document["title"] as? String else {
                        return
                    }
                    
                    let rawUnderTask = document["under tasks"] as? [String: [String: Any]]
                    let underTasks = self?.makeUnderTasks(with: rawUnderTask) ?? []
                    
                    var task = Task(randomName: "\(document.documentID)", title: title, date: date, image: image)
                    task.underTasks = underTasks
                    
                    completionTasks.append(task)
                }
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MM yyyy"
            
            completionTasks.sort { (first, second) -> Bool in
                guard let first = formatter.date(from: first.date),
                      let second = formatter.date(from: second.date) else {
                    return true
                }
                return first < second
            }
            completion(.success(completionTasks))
        }
    }
    
    private func makeUnderTasks(with document: [String: [String: Any]]?) -> [UnderTask] {
        guard let document = document else {
            return []
        }
        
        return document.map({ id, params in
            let title: String = params["title"] as? String ?? ""
            let date: String = params["date"] as? String ?? ""
            let isCompleted: Bool = params["isCompleted"] as? Bool ?? false
            
            return UnderTask(randomName: id, title: title, date: date, isCompleted: isCompleted)
        })
    }
    
}
