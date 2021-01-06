//
//  MockUser.swift
//  bizzbrains
//
//  Created by Anques on 05/01/21.
//  Copyright © 2021 Anques Technolabs. All rights reserved.
//

import Foundation
import MessageKit

struct MockUser: SenderType, Equatable {
    var senderId: String
    var displayName: String
}

