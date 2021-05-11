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
                database.addGroup(groupID: randomName, userUID: currentUser.uid) { result in
                    switch result {
                    case .success(_):
                        completion(.success(randomName))
                    case .failure(let error):
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
                self?.groupDatabase.getDocuments() { [weak self] (querySnapshot, error) in
                    
                    if let error = error {
                        completion(.failure(error))
                        return
                    } else {
                        for document in querySnapshot!.documents {
                            arrGroups.forEach {
                                if $0 == document.documentID {
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
                                    
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "dd MM yyyy"
                                    group.underTasks.sort { (first, second) -> Bool in
                                        guard let first = formatter.date(from: first.date),
                                              let second = formatter.date(from: second.date) else {
                                            return true
                                        }
                                        return first < second
                                    }
                                    
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
                    completion(.success(completionGroups))
                }
                completion(.success(completionGroups))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getGroup(groupID : String, completion: @escaping (Result<Group, Error>) -> Void) {

        groupDatabase.getDocuments() { [weak self] (querySnapshot, error) in
            
            var resultGroup: Group = Group(randomName: "", title: "", date: "", image: "")
            
            if let error = error {
                completion(.failure(error))
                return
            } else {
                for document in querySnapshot!.documents {
                    if document.documentID == groupID {
                        guard let date = document["date"] as? String,
                              let image = document["image"] as? String,
                              let title = document["title"] as? String,
                              let members = document["members"] as? [String] else {
                            completion(.failure(ImageLoader.ImageLoaderError.unexpected))
                            return
                        }
                        let rawUnderTask = document["under tasks"] as? [String: [String: Any]]
                        let underTask = self?.makeUnderTasks(with: rawUnderTask) ?? []
                        resultGroup = Group(randomName: groupID, title: title, date: date, image: image)
                        
                        resultGroup.underTasks.append(contentsOf: underTask)
                        
                        let formatter = DateFormatter()
                        formatter.dateFormat = "dd MM yyyy"
                        resultGroup.underTasks.sort { (first, second) -> Bool in
                            guard let first = formatter.date(from: first.date),
                                  let second = formatter.date(from: second.date) else {
                                return true
                            }
                            return first < second
                        }
                        
                        resultGroup.members = members
                        
                        resultGroup.members.sort { (first, second) -> Bool in
                            guard let first = formatter.date(from: first),
                                  let second = formatter.date(from: second) else {
                                return true
                            }
                            return first < second
                        }
                        
                        completion(.success(resultGroup))
                    }
                }
            }
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
    
    func addMember(groupID : String, userUID : String, completion: @escaping (Result<String, Error>) -> Void) {
        guard !groupID.isEmpty, !userUID.isEmpty else {
            completion(.failure(ImageLoader.ImageLoaderError.unexpected))
            return
        }

        var members : [String] = []
        
        getGroup(groupID: groupID) { result in
            switch result {
            case .success(let group):
                members = group.members
                members.append(userUID)
                let setMembers = Array(Set(members))
                self.groupDatabase.document(groupID).setData(["members" : setMembers], merge: true) { error in
                    let result = Result {
                    }
                    switch result {
                    case .success():
                        completion(.success("ok"))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(_):
                return
            }
            
        }
    }
    
    func createUnderTask(_ randomGroupName : String,
                         _ title: String,
                         _ date: String,
                         completion: @escaping (Result<String, Error>) -> Void) {

        let randomName = UUID().uuidString
        let underTask = UnderTask(randomName: randomName, title: title, date: date)
        let data = ["\(randomName)" : ["title" : underTask.title,
                                       "date" : underTask.date,
                                       "isCompleted" : underTask.isCompleted] as [String : Any]]
        
        groupDatabase.document(randomGroupName).setData(["under tasks" : data], merge: true) { error in
            let result = Result {
            }
            
            switch result {
            case .success():
                completion(.success(randomName))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func selctCheckmark(groupID : String,
                        underTaskID : String,
                        isCompleted : Bool,
                        completion: @escaping (Result<String, Error>) -> Void) {
        
        let data = ["\(underTaskID)" : ["isCompleted" : isCompleted] as [String : Any]]
        
        groupDatabase.document(groupID).setData(["under tasks" : data], merge: true) { error in
            let result = Result {
            }
            
            switch result {
            case .success():
                completion(.success("ok"))
            case .failure(let error):
                completion(.failure(error))
            }
            
        }
    }
    
}
