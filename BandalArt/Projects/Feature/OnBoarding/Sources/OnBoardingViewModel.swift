//
//  OnBoardingViewModel.swift
//  OnBoardingFeature
//
//  Created by Sang hun Lee on 2023/08/18.
//  Copyright © 2023 otani. All rights reserved.
//

import UIKit
import Lottie

public final class OnBoardingViewModel {
  
  let animationView = LottieAnimationView()
  
  private let onBoardingLottieAnimations: [LottieAnimation] = [
    LottieAnimation.named("onboardingPre")!,
    LottieAnimation.named("onboardingPost")!
  ]
  
  private let onBoardingTitles: [String] = [
    "복잡하고 막막한\n만다라트 계획표는 이제 안녕!",
    "이제 반다라트와 함께\n부담 없이 계획을 세워봐요"
  ]
  
  public init() {}
  
  var count: Int {
    return onBoardingLottieAnimations.count
  }
  
  func onBoardingLottieAnimation(at index: Int) -> LottieAnimation {
    return onBoardingLottieAnimations[index]
  }
  
  func onBoardingTitle(at index: Int) -> String {
    return onBoardingTitles[index]
  }
}
