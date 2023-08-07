//
//  ManipulateViewModel.swift
//  HomeFeature
//
//  Created by Sang hun Lee on 2023/08/05.
//  Copyright © 2023 Otani. All rights reserved.
//

import Foundation
import UseCase
import Entity
import Network
import Util

import Combine

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}

public final class ManipulateViewModel: ViewModelType {
  private let useCase: BandalArtUseCase
  private var cancellables = Set<AnyCancellable>()
  
  public init(
      useCase: BandalArtUseCase = BandalArtUseCaseImpl(
          repository: BandalArtRepositoryImpl()
      )
  ) {
      self.useCase = useCase
  }
  
  struct Input {
    
  }
  
  struct Output {
    
  }
  
  func transform(input: Input) -> Output {
    
    return Output(
    
    )
  }
}
