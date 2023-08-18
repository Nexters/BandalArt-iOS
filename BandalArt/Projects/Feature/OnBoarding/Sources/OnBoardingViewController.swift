//
//  OnBoardingViewController.swift
//  ProjectDescriptionHelpers
//
//  Created by Sang hun Lee on 2023/07/21.
//



import UIKit
import HomeFeature
import CommonFeature
import Components
import Util
import SnapKit
import Lottie

public final class OnBoardingViewController: BaseViewController {
  private let scrollView = UIScrollView()
  private let pageControl = UIPageControl()
  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.font = .pretendardBold(size: 22.0)
    label.textAlignment = .center
    label.textColor = .gray900
    return label
  }()
  private lazy var startButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .gray900
    button.setTitle("시작하기", for: .normal)
    button.layer.cornerRadius = 25.0
    button.titleLabel?.font = .pretendardSemiBold(size: 16.0)
    button.clipsToBounds = true
    button.isHidden = true
    return button
  }()
  private var viewModel: OnBoardingViewModel
  
  public init(viewModel: OnBoardingViewModel) {
    self.viewModel = viewModel
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("OnBoardingViewController fatal error")
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupConstraints()
    setupAttributes()
  }
  
  public override func setupView() {
    view.addSubview(scrollView)
    view.addSubview(startButton)
    view.addSubview(pageControl)
    view.addSubview(descriptionLabel)
  }
  
  public override func setupConstraints() {
    
    scrollView.frame = view.bounds
    
    for i in 0..<viewModel.count {
      let scrollContentView = UIView()
      scrollView.addSubview(scrollContentView)
      let xPos = self.view.frame.width * CGFloat(i)
      scrollContentView.frame = CGRect(x: xPos,
                                       y: 0,
                                       width: scrollView.bounds.width,
                                       height: scrollView.bounds.height)
      
      let animationView = LottieAnimationView()
      animationView.animation = viewModel.onBoardingLottieAnimation(at: i)
      animationView.contentMode = .scaleAspectFill
      animationView.loopMode = .loop
      scrollContentView.addSubview(animationView)
      animationView.snp.makeConstraints {
        $0.centerY.equalTo(view.safeAreaLayoutGuide)
        $0.leading.equalToSuperview().offset(16.0)
        $0.trailing.equalToSuperview().offset(-16.0)
        $0.height.equalTo(animationView.snp.width)
      }
      animationView.contentMode = .scaleAspectFill
      animationView.play()
      scrollView.contentSize.width = scrollContentView.frame.width * CGFloat(i + 1)
    }
    
    startButton.snp.makeConstraints {
      $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-33.0)
      $0.leading.equalToSuperview().offset(24.0)
      $0.trailing.equalToSuperview().offset(-24.0)
      $0.height.equalTo(55.0)
    }
    
    pageControl.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(16.0)
      $0.height.equalTo(30)
    }
    
    descriptionLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(pageControl.snp.bottom).offset(50)
      $0.trailing.equalToSuperview().offset(-16.0)
      $0.leading.equalToSuperview().offset(16.0)
    }
  }
  
  private func setupAttributes() {
    view.backgroundColor = .gray50
    startButton.addTarget(self, action: #selector(startButtonTap), for: .touchUpInside)
    scrollView.delegate = self
    scrollView.isPagingEnabled = true
    scrollView.showsHorizontalScrollIndicator = false
    pageControl.numberOfPages = viewModel.count
    pageControl.currentPageIndicatorTintColor = .gray700
    pageControl.pageIndicatorTintColor = .gray300
    
    descriptionLabel.textAlignment = .center
    descriptionLabel.numberOfLines = 0
    descriptionLabel.text = viewModel.onBoardingTitle(at: 0)
  }
  
  @objc private func startButtonTap() {
    // TODO: HomeView로 가도록 구현
    let vc = HomeViewController(viewModel: HomeViewModel())
    let appearance = UINavigationBarAppearance()

    appearance.setBackIndicatorImage(UIImage(named: "chevron.left"), transitionMaskImage: UIImage(named: "chevron.left"))
    appearance.backgroundColor = .systemBackground
    appearance.shadowColor = .clear
    appearance.shadowImage = UIImage(named: "shadow")
    let nav = UINavigationController(rootViewController: vc)
    nav.navigationBar.standardAppearance = appearance
    nav.navigationBar.scrollEdgeAppearance = appearance
    nav.navigationBar.tintColor = .gray900
    nav.navigationItem.backButtonTitle = ""
    nav.navigationItem.backBarButtonItem?.title = ""

    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
    
    // TODO: App 쪽을 모르는데 어떻게 바꾸지..
    let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
    guard let delegate = sceneDelegate else {
      return
    }
    delegate.window?.rootViewController = vc
  }
}

extension OnBoardingViewController: UIScrollViewDelegate {
  public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    let value = targetContentOffset.pointee.x / scrollView.frame.size.width
    let currentPageNumber = Int(value)
    startButton.isHidden = currentPageNumber == 0 ? true : false
    descriptionLabel.text = viewModel.onBoardingTitle(at: currentPageNumber)
    setPageControlSelectedPage(currentPage: currentPageNumber)
  }
  
  private func setPageControlSelectedPage(currentPage: Int) {
    self.pageControl.currentPage = currentPage
  }
}
