//
//  Connection.swift
//  Guruji Calendar
//
//  Created by Vivek Goswami on 14/02/17.
//  Copyright © 2017 TriSoft Developers. All rights reserved.
//

import Foundation

struct Connection {
    
    struct open {
        
        //static var Service = "http://guruji.krishnapranami.org/web_services/index.php"
        static var Service = "http://guruji.krishnapranami.org/web_services2/index.php"
    }
    struct queue {
        static let utilityQueue = DispatchQueue.global(qos: .utility)
    }

}
