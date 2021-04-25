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
        database.document(user.uid).collection("tasks").getDocuments() { (querySnapshot, error) in
            
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
                    
                    completionTasks.append(Task(randomName: "\(document.documentID)", title: title, date: date, image: image))
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
        
        database.document(user.uid).collection("tasks").getDocuments() { (querySnapshot, error) in
            
            var resultTask: Task = Task(randomName: "", title: "", date: "", image: "")
            
            if let error = error {
                completion(.failure(error))
                return
            } else {
                for document in querySnapshot!.documents {
                    if document.documentID == taskName {
                        guard let date = document["date"] as? String,
                              let image = document["image"] as? String,
                              let title = document["title"] as? String,
                              let underTask = document["under tasks"] as? [UnderTask] else {
                            return
                        }
                        resultTask = Task(randomName: taskName, title: title, date: date, image: image)
                        print("~~~~~~~~~~~: \(underTask)")
                        resultTask.underTasks.append(contentsOf: underTask)
                        print("```````````````````: \(resultTask)")
                        completion(.success(resultTask))
                    }
                }
            }
        }
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
    
}
