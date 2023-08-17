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
  let date: PassthroughSubject<Date?, Never>
  let expandButtonTap: PassthroughSubject<Void, Never>
  let resetButtonTap: PassthroughSubject<Void, Never>
}

final class DueDateCell: UICollectionViewCell {
  private var cancellables = Set<AnyCancellable>()
  private var viewModel: DueDateCellViewModel?
  
  lazy var underlineTextField: UnderlineTextField = {
    let underlineTextField = UnderlineTextField()
    underlineTextField.tintColor = .gray400
    underlineTextField.font = .pretendardSemiBold(size: 16.0)
    underlineTextField.setPlaceholder(placeholder: "마감일을 선택해주세요", color: .gray400)
    underlineTextField.setContentHuggingPriority(.defaultHigh, for: .vertical)
    return underlineTextField
  }()
  
  lazy var textFieldCoverButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .clear
    return button
  }()
  
  lazy var datePickerButton: UIButton = {
    let button = UIButton()
    button.setImage(
      UIImage(systemName: "chevron.right"),
      for: .normal
    )
    button.tintColor = .gray400
    button.imageView?.contentMode = .scaleAspectFit
    return button
  }()
  
  lazy var datePicker: UIDatePicker = {
    let datePicker = UIDatePicker()
    datePicker.datePickerMode = .date
    datePicker.preferredDatePickerStyle = .wheels
    datePicker.locale = Locale(identifier: "ko-KR")
    datePicker.timeZone = .autoupdatingCurrent
    let calendar = Calendar.current
    let minDateComponents = DateComponents(year: 2000, month: 1, day: 1)
    let minDate = calendar.date(from: minDateComponents)
    datePicker.minimumDate = minDate
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
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    cancellables.forEach { $0.cancel() }
    cancellables.removeAll()
    bind()
  }
  
  func setupView() {
    [containerView, textFieldCoverButton, datePickerButton, resetButton].forEach {
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
    
    textFieldCoverButton.snp.makeConstraints {
      $0.top.leading.bottom.equalTo(underlineTextField)
      $0.trailing.equalTo(datePickerButton.snp.leading)
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
      $0.height.lessThanOrEqualTo(150.0)
    }
  }
  
  func setupData(item: DueDateItem) {
    underlineTextField.text = item.date?.toString
    let state = item.isOpen
    datePicker.isHidden = !state
    resetButton.isHidden = !state
    if !state {
      datePickerButton.setImage(
        UIImage(systemName: "chevron.right"),
        for: .normal
      )
    } else {
      datePickerButton.setImage(
        UIImage(systemName: "chevron.down"),
        for: .normal
      )
    }
  }
  
  func bind() {
    datePickerButton.tapPublisher
      .merge(with: textFieldCoverButton.tapPublisher)
      .sink { [weak self] _ in
        guard let self = self else { return }
        viewModel?.expandButtonTap.send(Void())
      }
      .store(in: &cancellables)
    
    underlineTextField.publisher(for: \.text)
      .sink { [weak self] text in
        guard let self = self else { return }
        let date = underlineTextField.text?.toDate(format: "yyyy년 MM월 dd일")
        viewModel?.date.send(date)
      }
      .store(in: &cancellables)
    
    datePicker.datePublisher
      .sink { [weak self] date in
        if self?.datePicker.isHidden == false {
          self?.underlineTextField.text = date.toString
        }
      }
      .store(in: &cancellables)
    
    resetButton.tapPublisher
      .sink { [weak self] tap in
        self?.underlineTextField.text = nil
      }
      .store(in: &cancellables)
  }
  
  func configure(with viewModel: DueDateCellViewModel) {
    self.viewModel = viewModel
  }
}


