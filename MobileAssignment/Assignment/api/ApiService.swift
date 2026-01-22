//
//  ApiService.swift
//  Assignment
//
//  Created by Kunal on 10/01/25.
//

import Foundation

class ApiService  {
    private let baseUrl = ""
    
    private let sourcesURL = URL(string: "https://api.restful-api.dev/objects")!
    
    func fetchDeviceDetails(completion : @escaping (Result<[DeviceData], Error>) -> Void) {
        URLSession.shared.dataTask(with: sourcesURL) { data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                DispatchQueue.main.async{
                    completion(.failure(error))
                }
                // Return an empty array on network failure
                return
            }
            
            
            guard let data = data else {
                DispatchQueue.main.async{
                    completion(.success([]))
                    
                }
                return
            }
            do {
                let devices = try JSONDecoder().decode([DeviceData].self, from: data)
                DispatchQueue.main.async{
                    completion(.success(devices))
                }
            } catch{
                print("decode error")
                DispatchQueue.main.async{
                    completion(.failure(error))
                    //                    let jsonDecoder = JSONDecoder()
                    //                    let empData = try! jsonDecoder.decode([DeviceData].self, from: data)
                    //                    if (empData.isEmpty) {
                    //                        completion([])
                    //                        // Error
                    //                    }}
                }
            }
        }  .resume()
        
    }
}
