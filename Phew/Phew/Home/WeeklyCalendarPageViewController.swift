//
//  WeeklyCalendarPageViewController.swift
//  Phew
//
//  Created by dong eun shin on 4/26/25.
//

import SwiftUI

class WeeklyHostingController: UIHostingController<WeeklyCalendarPageView> {
    let week: [Date]

    init(week: [Date]) {
        self.week = week
        super.init(rootView: WeeklyCalendarPageView(week: week))
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct WeeklyCalendarPageViewController: UIViewControllerRepresentable {
    @Environment(HomeViewModel.self) var viewModel
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIPageViewController {
        let pvc = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        let initialVC = context.coordinator.viewController(for: viewModel.currentWeekStartDate.generateWeek())

        pvc.setViewControllers([initialVC], direction: .forward, animated: false)
        pvc.dataSource = context.coordinator
        pvc.delegate = context.coordinator
        
        return pvc
    }

    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        let coordinator = context.coordinator
        
        let previousWeekStartDate = coordinator.previousWeekStartDate
        let newWeekStartDate = viewModel.currentWeekStartDate
        
        guard !Calendar.current.isDate(previousWeekStartDate, inSameDayAs: newWeekStartDate) else {
            return
        }
        
        guard !coordinator.isUserInteraction else {
            coordinator.previousWeekStartDate = newWeekStartDate
            coordinator.isUserInteraction = false
            return
        }
        
        let newVC = coordinator.viewController(for: newWeekStartDate.generateWeek())
        
        pageViewController.setViewControllers(
            [newVC],
            direction: newWeekStartDate > previousWeekStartDate ? .forward : .reverse,
            animated: true
        )
        
        coordinator.previousWeekStartDate = newWeekStartDate
    }


    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        var parent: WeeklyCalendarPageViewController
        var viewModel: HomeViewModel
        var previousWeekStartDate: Date
        var isUserInteraction = false

        init(_ parent: WeeklyCalendarPageViewController) {
            self.parent = parent
            self.viewModel = parent.viewModel
            self.previousWeekStartDate = parent.viewModel.currentWeekStartDate
        }

        func viewController(for week: [Date]) -> WeeklyHostingController {
            WeeklyHostingController(week: week)
        }

        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            
            guard let currentVC = viewController as? WeeklyHostingController else { return nil }
            
            guard
                let startOfWeek = currentVC.week.first,
                let previousWeek = Calendar.current.date(byAdding: .day, value: -7, to: startOfWeek)
            else { return nil }
            
            return self.viewController(for: previousWeek.generateWeek())
        }

        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let currentVC = viewController as? WeeklyHostingController else { return nil }
            
            guard
                let startOfWeek = currentVC.week.first,
                let nextWeek = Calendar.current.date(byAdding: .day, value: 7, to: startOfWeek)
            else { return nil }
            
            return self.viewController(for: nextWeek.generateWeek())
        }

        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            guard
                completed,
                let currentVC = pageViewController.viewControllers?.first as? WeeklyHostingController
            else { return }

            if
                let newWeekStartDate = currentVC.week.first,
                !Calendar.current.isDate(newWeekStartDate, inSameDayAs: viewModel.currentWeekStartDate)
            {
                viewModel.currentWeekStartDate = newWeekStartDate
            }
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
            isUserInteraction = true
        }
    }
}
