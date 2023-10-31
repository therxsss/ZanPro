//
//  Typealias.swift
//  ZanPro
//
//  Created by Magametov Rakhman on 31.07.2023.
//

import Foundation
import Combine

public typealias VoidCallback = () -> Void
public typealias Callback<T> = (T) -> Void
public typealias Bag = Set<AnyCancellable>
