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
                    "friends" : userData.friends,
                    "groups" : userData.groups,
                    "tasks" : userData.tasks] as [String : Any]
        
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
        let data = ["\(randomName)" : ["title" : task.title,
                    "date" : task.date,
                    "image" : task.image,
                    "under tasks" : task.underTasks] as [String : Any]]
        
        database.document(currentUser.uid).setData(["tasks" : data], merge: true) { error in
            let result = Result {
            }
            
            switch result {
            case .success():
                print("crateTask: GOOD JOB")
                completion(.success(randomName))
            case .failure(let error):
                print("crateTask: BAD RESULT \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func getTasks(completion: @escaping (Result<[Task], Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        database.document(user.uid).getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let userData = document?.data(),
                  let tasks = userData["tasks"] as? [String: [String: Any]] else {
                completion(.failure(ImageLoader.ImageLoaderError.unexpected))
                return
            }
            
            var completionTasks: [Task] = []
            
            tasks.forEach { randomName, task in
                guard let date = task["date"] as? String,
                      let image = task["image"] as? String,
                      let title = task["title"] as? String else {
                    return
                }
                
                completionTasks.append(Task(randomName: randomName, title: title, date: date, image: image))
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
    
    func getTasksCount(completion: @escaping (Result<Int, Error>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        database.document(currentUser.uid).getDocument { document, error in
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
