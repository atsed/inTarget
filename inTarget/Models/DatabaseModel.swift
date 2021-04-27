//
//  DatabaseModel.swift
//  inTarget
//
//  Created by Desta on 12.04.2021.
//

import Foundation
import Firebase

class DatabaseModel {
    let database = Firestore.firestore().collection("users")
    
    func createDatabase(name: String, surname: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        let userData = UserDataModel(user: currentUser, name: name, surName: surname)
        let data = ["name" : userData.name,
                    "uid" : userData.uid,
                    "surname" : userData.surName,
                    "email" : userData.email,
                    "avatar" : userData.avatar,
                    "groups" : userData.groups] as [String : Any]
        
        database.document(currentUser.uid).setData(data) { error in
            let result = Result {
            }
            switch result {
            case .success():
                completion(.success(""))
            case .failure(let error):
                completion(.failure(error))
            }
            
        }
    }
    
    func createTask(_ title: String,
                    _ date: String,
                    _ image: String,
                    completion: @escaping (Result<String, Error>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        let randomName = UUID().uuidString
        let task = Task(randomName: randomName, title: title, date: date, image: image)
        let data = ["title" : task.title,
                    "date" : task.date,
                    "image" : task.image,
                    "under tasks" : task.underTasks] as [String : Any]
        
        database.document(currentUser.uid).collection("tasks").document("\(randomName)").setData(data) {
            error in
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
    
    func getTasks(completion: @escaping (Result<[Task], Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            return
        }
        database.document(user.uid).collection("tasks").getDocuments() { [weak self] (querySnapshot, error) in
            
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
    
    func getTask(taskName : String, completion: @escaping (Result<Task, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        database.document(user.uid).collection("tasks").getDocuments() { [weak self] (querySnapshot, error) in
            
            var resultTask: Task = Task(randomName: "", title: "", date: "", image: "")
            
            if let error = error {
                completion(.failure(error))
                return
            } else {
                for document in querySnapshot!.documents {
                    if document.documentID == taskName {
                        guard let date = document["date"] as? String,
                              let image = document["image"] as? String,
                              let title = document["title"] as? String else {
                            completion(.failure(ImageLoader.ImageLoaderError.unexpected))
                            return
                        }
                        let rawUnderTask = document["under tasks"] as? [String: [String: Any]]
                        let underTask = self?.makeUnderTasks(with: rawUnderTask) ?? []
                        resultTask = Task(randomName: taskName, title: title, date: date, image: image)
                        resultTask.underTasks.append(contentsOf: underTask)
                        completion(.success(resultTask))
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
    
    func createUnderTask(_ randomTaskName : String,
                         _ title: String,
                         _ date: String,
                         completion: @escaping (Result<String, Error>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        let randomName = UUID().uuidString
        let underTask = UnderTask(randomName: randomName, title: title, date: date)
        let data = ["\(randomName)" : ["title" : underTask.title,
                                       "date" : underTask.date,
                                       "isCompleted" : underTask.isCompleted] as [String : Any]]
        
        database.document(currentUser.uid).collection("tasks").document("\(randomTaskName)").setData(["under tasks" : data], merge: true) { error in
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
    
    func selctCheckmark(taskID : String,
                        underTaskID : String,
                        isCompleted : Bool,
                        completion: @escaping (Result<String, Error>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        let data = ["\(underTaskID)" : ["isCompleted" : isCompleted] as [String : Any]]
        
        database.document(currentUser.uid).collection("tasks").document("\(taskID)").setData(["under tasks" : data], merge: true) { error in
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
    
    func getGroups(completion: @escaping (Result<[String], Error>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        var groups : [String] = []
        database.document(currentUser.uid).getDocument { (document, error) in
            if let document = document, document.exists {
                groups = document.get("groups") as? [String] ?? []
                print("GROUPS: \(groups)")
                completion(.success(groups))
            } else {
                print("Document does not exist")
                completion(.failure(error ?? ImageLoader.ImageLoaderError.invalidInput))
            }
        }
        
        //database.document(<#T##documentPath: String##String#>)
        //database.document(currentUser.uid).
    }
    
    func addGroup(groupID : String,
                  completion: @escaping (Result<String, Error>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        getGroups() { result in
            switch result {
            case .success(let arrayOfGroups):
                var groups = arrayOfGroups
                groups.append(groupID)
                self.database.document(currentUser.uid).setData(["groups" : groups], merge: true) { error in
                    let result = Result {
                    }
                    
                    switch result {
                    case .success():
                        completion(.success("ok"))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
                print(arrayOfGroups)
            case .failure(_):
                print("error")
            }
            
        }
    }
    
}
