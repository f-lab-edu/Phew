//
//  SelectedDateDetailPageViewController.swift
//  Phew
//
//  Created by dong eun shin on 4/25/25.
//

import ComposableArchitecture
import SwiftUI

struct SelectedDateDetailPageViewController: UIViewControllerRepresentable {
    let store: StoreOf<HomeFeature>

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIPageViewController {
        let pvc = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        let initialVC = context.coordinator.viewController(for: store.state.selectedDate)

        pvc.setViewControllers([initialVC], direction: .forward, animated: false)
        pvc.dataSource = context.coordinator
        pvc.delegate = context.coordinator

        return pvc
    }

    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        let selectedDate = store.state.selectedDate
        let previousDate = context.coordinator.previousDate
        let newVC = context.coordinator.viewController(for: selectedDate)

        guard !Calendar.current.isDate(store.state.selectedDate, inSameDayAs: previousDate) else {
            return
        }

        pageViewController.setViewControllers(
            [newVC],
            direction: store.state.selectedDate > previousDate ? .forward : .reverse,
            animated: context.coordinator.isUserInteraction ? false : true
        )

        context.coordinator.previousDate = selectedDate
        context.coordinator.isUserInteraction = false
    }

    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        var parent: SelectedDateDetailPageViewController
        var previousDate: Date
        var isUserInteraction = false
        let store: StoreOf<HomeFeature>

        init(_ parent: SelectedDateDetailPageViewController) {
            self.parent = parent
            previousDate = parent.store.state.selectedDate
            store = parent.store
        }

        func viewController(for date: Date) -> UIViewController {
            let state = HomeFeature.State(
                selectedDate: date,
                currentWeekStartDate: Calendar.current.dateInterval(of: .weekOfYear, for: date)?.start ?? date
            )
            let newStore: StoreOf<HomeFeature> = .init(initialState: state) {
                HomeFeature()
            }
            let vc = UIHostingController(
                rootView: SelectedDateDetailPageView(
                    store: newStore,
                    date: date
                )
            )
            vc.view.tag = Int(date.timeIntervalSince1970)

            return vc
        }

        func pageViewController(_: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            let currentDate = Date(timeIntervalSince1970: TimeInterval(viewController.view.tag))

            guard let previous = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) else { return nil }

            return self.viewController(for: previous)
        }

        func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            let currentDate = Date(timeIntervalSince1970: TimeInterval(viewController.view.tag))

            guard let next = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) else { return nil }

            return self.viewController(for: next)
        }

        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating _: Bool, previousViewControllers _: [UIViewController], transitionCompleted completed: Bool) {
            guard
                completed,
                let currentVC = pageViewController.viewControllers?.first
            else { return }

            let newDate = Date(timeIntervalSince1970: TimeInterval(currentVC.view.tag))

            if !Calendar.current.isDate(newDate, inSameDayAs: parent.store.state.selectedDate) {
                store.send(.selectedDate(newDate))
                if
                    let weekStartDate = Calendar.current.dateInterval(of: .weekOfYear, for: newDate)?.start,
                    !Calendar.current.isDate(weekStartDate, inSameDayAs: parent.store.state.currentWeekStartDate)
                {
                    store.send(.setSwipeDirection(newDate > parent.store.selectedDate ? .forward : .reverse))
                    store.send(.setCurrentWeekStartDate(weekStartDate))
                }
            }
        }

        func pageViewController(_: UIPageViewController, willTransitionTo _: [UIViewController]) {
            isUserInteraction = true
        }
    }
}
