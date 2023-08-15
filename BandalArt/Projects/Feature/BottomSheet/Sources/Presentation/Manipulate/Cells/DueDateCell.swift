//
//  MainGoalDueDateCell.swift
//  HomeFeature
//
//  Created by Sang hun Lee on 2023/08/02.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit
import SnapKit
import Combine
import Components

struct DueDateCellViewModel {
  let date: PassthroughSubject<Date, Never>
  let resetButtonTap: PassthroughSubject<Void, Never>
}

final class DueDateCell: UICollectionViewCell {
  static let identifier = "DueDateCell"
  weak var delegate: DatePickerCallDelegate?
  private var cancellables = Set<AnyCancellable>()
  
  lazy var underlineTextField: UnderlineTextField = {
    let underlineTextField = UnderlineTextField()
    underlineTextField.tintColor = .gray400
    underlineTextField.placeholder = "마감일을 선택해주세요"
    underlineTextField.placeholderString = "마감일을 선택해주세요"
    underlineTextField.isUserInteractionEnabled = false
    underlineTextField.setContentHuggingPriority(.defaultHigh, for: .vertical)
    return underlineTextField
  }()
  
  lazy var datePickerButton: UIButton = {
    let button = UIButton()
    button.setImage(
      UIImage(named: "chevron.right")?.resize(24.0),
      for: .normal
    )
    button.imageView?.contentMode = .scaleAspectFit
    button.addTarget(self, action: #selector(datePickerButtonTapped), for: .touchUpInside)
    return button
  }()
  
  lazy var datePicker: UIDatePicker = {
    let datePicker = UIDatePicker()
    datePicker.datePickerMode = .date
    datePicker.preferredDatePickerStyle = .wheels
    datePicker.locale = Locale(identifier: "ko-KR")
    datePicker.timeZone = .autoupdatingCurrent
    datePicker.isHidden = true
    datePicker.setContentHuggingPriority(.defaultLow, for: .vertical)
    return datePicker
  }()
  
  lazy var containerView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.addArrangedSubview(underlineTextField)
    stackView.addArrangedSubview(datePicker)
    stackView.alignment = .fill
    stackView.distribution = .fill
    stackView.spacing = 8.0
    stackView.contentMode = .scaleAspectFit

    return stackView
  }()
  
  lazy var resetButton: UIButton = {
    let button = UIButton()
    button.setImage(
      UIImage(systemName: "clock.arrow.2.circlepath"),
      for: .normal
    )
    button.tintColor = .gray400
    button.isUserInteractionEnabled = true
    button.isHidden = true
    return button
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
    [containerView, datePickerButton, resetButton].forEach {
      contentView.addSubview($0)
    }
  }
  
  func setupConstraints() {
    containerView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview().offset(4.0)
      $0.trailing.equalToSuperview().offset(-4.0)
      $0.bottom.lessThanOrEqualToSuperview()
    }
    
    underlineTextField.snp.makeConstraints {
       $0.height.equalTo(44.0)
    }
    
    datePickerButton.snp.makeConstraints {
      $0.width.height.equalTo(44.0)
      $0.centerY.equalTo(underlineTextField)
      $0.trailing.equalToSuperview()
    }
    
    resetButton.snp.makeConstraints {
      $0.width.height.equalTo(44.0)
      $0.top.equalTo(datePicker.snp.top)
      $0.trailing.equalTo(datePicker.snp.trailing)
    }
    
    datePicker.snp.makeConstraints {
//      $0.top.equalTo(underlineTextField.snp.bottom).offset(16.0)
//      $0.leading.equalToSuperview().offset(4.0)
//      $0.trailing.equalToSuperview().offset(-4.0)
//      $0.bottom.equalToSuperview()
      $0.height.lessThanOrEqualTo(150.0)
    }
  }
  
  func setupData(item: DueDateItem) {
    underlineTextField.text = item.date?.toStringWithKoreanFormat()
  }
  
  @objc func datePickerButtonTapped() {
    datePicker.isHidden.toggle()
    resetButton.isHidden.toggle()
    if datePicker.isHidden {
      datePickerButton.setImage(
        UIImage(named: "chevron.right")?.resize(24.0),
        for: .normal
      )
    } else {
      datePickerButton.setImage(
        UIImage(named: "chevron.down")?.resize(24.0),
        for: .normal
      )
    }
    delegate?.datePickerButtonTapped(in: self, isOpen: datePicker.isHidden)
  }
  
  func configure(with viewModel: DueDateCellViewModel) {
    datePicker.datePublisher
      .sink { [weak self] date in
        guard let self = self else { return }
        viewModel.date.send(date)
        self.underlineTextField.text = date.toStringWithKoreanFormat()
      }
      .store(in: &cancellables)
    
    resetButton.tapPublisher
      .sink { tap in
        viewModel.resetButtonTap.send(tap)
      }
      .store(in: &cancellables)
    
 
  }
}


