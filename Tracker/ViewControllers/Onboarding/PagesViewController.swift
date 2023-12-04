//
//  PagesViewController.swift
//  Tracker
//
//  Created by Dolnik Nikolay on 21.11.2023.
//

import UIKit

final class PagesViewController: UIPageViewController {
    
    var pages: [UIViewController] = []
    private var button = UIButton()
    lazy var pageControl: UIPageControl = {
       let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .blackDayTracker
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        configUI()
    }
    
    func configUI(){
        button = configUIButton(button: button, title: "Вот это технологии!", action: #selector(tapButton))
        view.addSubview(pageControl)
        view.addSubview(button)
        NSLayoutConstraint.activate([
            pageControl.heightAnchor.constraint(equalToConstant: 6),
            pageControl.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -24),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            button.heightAnchor.constraint(equalToConstant: 60),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
        
    }
    
    func config(){
        dataSource = self
        delegate = self

        Page.allCases.forEach{
            pages.append(PageViewController(page: $0))
        }
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true)
        }
        
    }
    
    @objc
    func tapButton(){
        guard
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = windowScene.windows.first else {
            fatalError("Invalid Configuration")
        }
        let tabBarController = TabBarController()
        window.rootViewController = tabBarController
    }
    
}


//MARK: - UIPageViewControllerDataSource

extension PagesViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
                   return nil
               }
               
               let previousIndex = viewControllerIndex - 1
               
               guard previousIndex >= 0 else {
                   return nil
               }
        
               return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
                  return nil
              }
              
              let nextIndex = viewControllerIndex + 1
              
        guard nextIndex < pages.count else {
                  return nil
              }
              
        return pages[nextIndex]
    }

}


//MARK: - UIPageViewControllerDelegate

extension PagesViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
                    pageControl.currentPage = currentIndex
                }
    }
    
}
