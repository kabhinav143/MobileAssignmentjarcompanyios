//
//  ContentViewModel.swift
//  Assignment
//
//  Created by Kunal on 10/01/25.
//

import Foundation


class ContentViewModel {
    
    private let apiService = ApiService()
//    @Published var navigateDetail: DeviceData? = nil
//    var data: [DeviceData]? = []
    private var devices: [DeviceData] = []

    
    func fetchDevices(completion:@escaping ([DeviceData]) -> Void){
        apiService.fetchDeviceDetails{ result in
            switch result {
            case.success(let devices):
                completion(devices)
            case .failure(let error):
                print("error",error.localizedDescription)
                completion([])
            }
        }
        }
    }

//    func navigateToDetail(navigateDetail: DeviceData) {
//        self.navigateDetail = navigateDetail
//    }

