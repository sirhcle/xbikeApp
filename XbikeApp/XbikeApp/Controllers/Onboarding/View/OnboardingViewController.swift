//
//  OnboardingViewController.swift
//  XbikeApp
//
//  Created by christian hernandez rivera on 23/08/22.
//

import UIKit

class OnboardingViewController: UIPageViewController {
    
    var pages = [UIViewController]()
    let pageControl = UIPageControl()
    let initialPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        self.style()
        self.layout()
    }

}

extension OnboardingViewController {
    
    func setup() {
        self.dataSource = self
        self.delegate = self
        
        self.pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
        
        let modelPage1 = OBControllerModel(image: "easy-filled", title: "Extremely simple to \nuse")
        let modelPage2 = OBControllerModel(image: "chronometer", title: "Track your time and \ndistance")
        let modelPage3 = OBControllerModel(image: "progress", title: "See your progress \nand challenge \nyourself!", buttonTitle: "Aceptar")
        
        let page1 = OBControllerViewController(model: modelPage1)
        let page2 = OBControllerViewController(model: modelPage2)
        let page3 = OBControllerViewController(model: modelPage3)
        page3.delegate = self
        
        self.pages.append(page1)
        self.pages.append(page2)
        self.pages.append(page3)
        
        setViewControllers([pages[initialPage]], direction: .forward, animated: true)
    }
    
    func style() {
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.pageControl.currentPageIndicatorTintColor = .black
        self.pageControl.pageIndicatorTintColor = .systemGray
        self.pageControl.numberOfPages = pages.count
        self.pageControl.currentPage = initialPage
    }
    
    func layout() {
        view.addSubview(self.pageControl)
        
        NSLayoutConstraint.activate([
            self.pageControl.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            self.pageControl.heightAnchor.constraint(equalToConstant: 20),
            self.view.bottomAnchor.constraint(equalToSystemSpacingBelow: self.pageControl.bottomAnchor, multiplier: 2.0)
        ])
    }
}

extension OnboardingViewController {
    @objc func pageControlTapped(_ sender: UIPageControl) {
        setViewControllers([pages[sender.currentPage]], direction: .forward, animated: true, completion: nil)
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
                
        if currentIndex == 0 {
            return pages.last
        } else {
            return pages[currentIndex - 1]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }

        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1]
        } else {
            return pages.first
        }
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = pages.firstIndex(of: viewControllers[0]) else { return }
        
        pageControl.currentPage = currentIndex
    }
}

extension OnboardingViewController: OBControllerDelegate {
    func dismissOB() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.loadTabBar()
    }
}


