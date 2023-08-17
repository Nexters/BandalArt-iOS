//
//  CompletionCell.swift
//  HomeFeature
//
//  Created by Sang hun Lee on 2023/08/05.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit
import SnapKit
import Combine
import Components

struct CompletionCellViewModel {
  let completion: PassthroughSubject<Bool?, Never>
}

final class CompletionCell: UICollectionViewCell {
  static let identifier = "CompletionCell"
  private var cancellables = Set<AnyCancellable>()
  
  private lazy var titleLabel = DefaultLabel(
    title: "미달성",
    font: .pretendardSemiBold(size: 16.0),
    textColor: .gray900,
    textAlignment: .left
  )
  
  lazy var customSwitch: CustomSwitch = {
    let customSwitch = CustomSwitch()
    customSwitch.translatesAutoresizingMaskIntoConstraints = false
    customSwitch.onTintColor = UIColor.darkGray
    customSwitch.offTintColor = UIColor.lightGray
    customSwitch.cornerRadius = 14
    customSwitch.padding = 3.0
    customSwitch.thumbSize = CGSize(width: 20, height: 20)
    customSwitch.thumbCornerRadius = 10
    customSwitch.thumbTintColor = UIColor.white
    customSwitch.animationDuration = 0.25
    return customSwitch
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupView() {
    [titleLabel, customSwitch].forEach {
      contentView.addSubview($0)
    }
  }
  
  func setupConstraints() {
    titleLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(4.0)
      $0.width.greaterThanOrEqualTo(80.0)
    }
    
    customSwitch.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().offset(-4.0)
      $0.width.equalTo(52.0)
      $0.height.equalTo(28.0)
    }
  }
  
  func setupData(item: CompletionItem) {
    customSwitch.isOn = item.isCompleted ?? false
    titleLabel.text = item.isCompleted! ? "달성" : "미달성"
  }
  
  func configure(with viewModel: CompletionCellViewModel) {
    customSwitch.$isOn
      .sink { [weak self] completion in
        viewModel.completion.send(completion)
      }
      .store(in: &cancellables)
    
    viewModel.completion
      .sink { [weak self] completion in
        guard let completion = completion else { return }
        self?.titleLabel.text = completion ? "달성" : "미달성"
      }
      .store(in: &cancellables)
  }
}
