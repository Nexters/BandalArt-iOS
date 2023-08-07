//
//  MainGoalDueDateCell.swift
//  HomeFeature
//
//  Created by Sang hun Lee on 2023/08/02.
//  Copyright © 2023 Otani. All rights reserved.
//

import UIKit
import SnapKit
import Components

final class DueDateCell: UICollectionViewCell {
  static let identifier = "DueDateCell"
  weak var delegate: DatePickerCallDelegate?
  
  lazy var underlineTextField: UnderlineTextField = {
    let underlineTextField = UnderlineTextField()
    underlineTextField.tintColor = .gray400
    underlineTextField.placeholder = "마감일을 선택해주세요"
    underlineTextField.placeholderString = "마감일을 선택해주세요"
    underlineTextField.isUserInteractionEnabled = false
    return underlineTextField
  }()
  
  lazy var datePickerButton: UIButton = {
    let button = UIButton()
    button.setImage(
      UIImage(named: "chevron.right")?.resize(withWidthScale: 1.5),
      for: .normal
    )
    button.addTarget(self, action: #selector(datePickerButtonTapped), for: .touchUpInside)
    return button
  }()
  
  lazy var datePicker: UIDatePicker = {
    let datePicker = UIDatePicker()
    datePicker.datePickerMode = .date
    datePicker.preferredDatePickerStyle = .wheels
    datePicker.locale = Locale(identifier: "ko-KR")
    datePicker.timeZone = .autoupdatingCurrent
    datePicker.addTarget(self, action: #selector(handleDatePicker(_:)), for: .valueChanged)
    datePicker.isHidden = true
    return datePicker
  }()
  
  lazy var containerView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.addArrangedSubview(underlineTextField)
    stackView.addArrangedSubview(datePicker)
    stackView.alignment = .fill
    stackView.distribution = .fill
    stackView.spacing = 15.0
    stackView.contentMode = .scaleToFill
    underlineTextField.setContentHuggingPriority(.defaultHigh, for: .vertical)
    underlineTextField.setContentCompressionResistancePriority(.required, for: .vertical)
    
    return stackView
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
    [containerView, datePickerButton].forEach {
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
    
    // underlineTextField.snp.makeConstraints {
//      $0.top.equalToSuperview()
//      $0.leading.equalToSuperview().offset(4.0)
//      $0.trailing.equalToSuperview().offset(-4.0)
      // $0.height.equalTo(44.0)
    //}
    
    datePickerButton.snp.makeConstraints {
      $0.width.height.equalTo(44.0)
      $0.centerY.equalTo(underlineTextField)
      $0.trailing.equalToSuperview()
    }
    
//    datePicker.snp.makeConstraints {
//      $0.top.equalTo(underlineTextField.snp.bottom).offset(16.0)
//      $0.leading.equalToSuperview().offset(4.0)
//      $0.trailing.equalToSuperview().offset(-4.0)
//      $0.bottom.equalToSuperview()
//      $0.height.equalTo(150.0)
//    }
  }
  
  func setupData(item: DueDateItem) {
    // TODO: 임시로 String 기반이지만 Date 다루는 로직으로 구성 필요
  }
  
  @objc func datePickerButtonTapped() {
    datePicker.isHidden.toggle()
    if datePicker.isHidden {
      datePickerButton.setImage(
        UIImage(named: "chevron.right")?.resize(withWidthScale: 1.5),
        for: .normal
      )
    } else {
      datePickerButton.setImage(
        UIImage(named: "chevron.down")?.resize(withWidthScale: 0.5),
        for: .normal
      )
    }
    delegate?.datePickerButtonTapped(in: self, isOpen: datePicker.isHidden)
  }
  
  @objc func handleDatePicker(_ sender: UIDatePicker) {
    print(sender.date)
  }
}


