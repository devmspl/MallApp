//
//  AddProductModel.swift
//  TheMallApp
//
//  Created by M1 on 11/04/22.
//

import Foundation

struct AddProductModel: Encodable{
    let description: String?
    let name: String?
    let masterPrice: Int?
    let productUrl: String?
    let storeId: String?
    let size: sizeA?
    let colors: colors?
    let features:feature?
}

struct sizeA: Encodable{
    let value: String?
    let price: Int?
}

struct colors: Encodable{
    let name: String?
    let price: Int?
}

struct feature: Encodable{
    let key: String?
    let value: String?
}
