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
    
    func createDatabase(name: String, surname: String) {
        guard let currentUser = Auth.auth().currentUser else { return }
        let userData = UserDataModel(user: currentUser, name: name, surName: surname)
        let data = ["name" : userData.name,
                    "uid" : userData.uid,
                    "surname" : userData.surName,
                    "email" : userData.email,
                    "avatar" : userData.avatar,
                    "friends" : userData.friends,
                    "groups" : userData.groups,
                    "tasks" : userData.tasks] as [String : Any]
        
        database.document(userData.uid).setData(data)
    }
    
    func createTask(_ count : Int, _ title : String, _ date : String, _ image : String, comletion: @escaping (Result<String, Error>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { return }
        let task = Task(title: title, date: date, image: image)
        let data = ["task \(count + 1)" : ["title" : task.title,
                    "date" : task.date,
                    "image" : task.image,
                    "under tasks" : task.underTasks] as [String : Any]]
        
        database.document(currentUser.uid).setData(["tasks" : data], merge: true) { ( error ) in
            let result = Result {
            }
            
            switch result {
            case .success():
                print("crateTask: GOOD JOB")
                comletion(.success(""))
            case .failure(let error):
                print("crateTask: BAD RESULT \(error)")
                comletion(.failure(error))
            }
        }
    }
    
    func getTasksCount(completion: @escaping (Result<Int, Error>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { return }
        database.document(currentUser.uid).getDocument {
            (document, error) in
            let result = Result {
                document?.get("tasks")
            }
            switch result {
                case .success(let tasks):
                    print("getTasksCount: \(String(describing: (tasks as AnyObject).count))")
                        completion(.success((tasks as AnyObject).count))
                case .failure(let error):
                    print("Error decoding task: \(error)")
                    completion(.failure(error))
                }
        }
        
        
    }
    
}
