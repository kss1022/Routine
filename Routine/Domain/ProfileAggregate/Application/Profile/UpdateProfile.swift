//
//  UpdateProfile.swift
//  Routine
//
//  Created by 한현규 on 11/23/23.
//

import Foundation



struct UpdateProfile: Command{
    let profileId: UUID
    let name: String
    let description: String
    let imageType: String
    let imageValue: String
    let topColor: String
    let bottomColor: String
}
