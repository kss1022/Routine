//
//  ProfileDao.swift
//  Routine
//
//  Created by 한현규 on 11/23/23.
//

import Foundation



protocol ProfileDao{
    func save(dto: ProfileDto) throws
    func update(dto: ProfileDto) throws
    func find() throws -> ProfileDto?
}
