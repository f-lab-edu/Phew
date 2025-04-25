//
//  SelectedDateDetailPageViewController.swift
//  Phew
//
//  Created by dong eun shin on 4/25/25.
//

import SwiftUI

struct SelectedDateDetailPageViewController: UIViewControllerRepresentable {
    @Binding var selectedDate: Date
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIPageViewController {
        let pvc = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        let initialVC = context.coordinator.viewController(for: selectedDate)

        pvc.setViewControllers([initialVC], direction: .forward, animated: false)
        pvc.dataSource = context.coordinator
        pvc.delegate = context.coordinator
        
        return pvc
    }

    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        let previousDate = context.coordinator.previousDate
        let newVC = context.coordinator.viewController(for: selectedDate)
        
        guard !Calendar.current.isDate(selectedDate, inSameDayAs: previousDate) else {
            return
        }
        
        pageViewController.setViewControllers(
            [newVC],
            direction: selectedDate > previousDate ? .forward : .reverse,
            animated: context.coordinator.isUserInteraction ? false : true
        )
        
        context.coordinator.previousDate = selectedDate
        context.coordinator.isUserInteraction = false
    }

    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        var parent: SelectedDateDetailPageViewController
        var previousDate: Date
        var isUserInteraction = false


        init(_ parent: SelectedDateDetailPageViewController) {
            self.parent = parent
            self.previousDate = parent.selectedDate
        }

        func viewController(for date: Date) -> UIViewController {
            let vc = UIHostingController(rootView: SelectedDateDetailPageView(date: date))
            vc.view.tag = Int(date.timeIntervalSince1970)
            
            return vc
        }

        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            let currentDate = Date(timeIntervalSince1970: TimeInterval(viewController.view.tag))
            
            guard let previous = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) else { return nil }
            
            return self.viewController(for: previous)
        }

        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            let currentDate = Date(timeIntervalSince1970: TimeInterval(viewController.view.tag))
            
            guard let next = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) else { return nil }
            
            return self.viewController(for: next)
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            guard
                completed,
                let currentVC = pageViewController.viewControllers?.first
            else { return }

            let newDate = Date(timeIntervalSince1970: TimeInterval(currentVC.view.tag))
            
            if !Calendar.current.isDate(newDate, inSameDayAs: parent.selectedDate) {
                self.parent.selectedDate = newDate
            }
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
            isUserInteraction = true
        }
    }
}
