//
//  HomeDetailPageViewController.swift
//  Phew
//
//  Created by dong eun shin on 4/25/25.
//

import SwiftUI

struct DetailPageView: View {
    let date: Date

    var body: some View {
        VStack {
            Text("selected date: \(date)")
                .font(.title)
                .padding()
            Spacer()
        }
    }
}

struct HomeDetailPageViewController: UIViewControllerRepresentable {
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
        let oldDate = context.coordinator.previousDate
        let newVC = context.coordinator.viewController(for: selectedDate)

        pageViewController.setViewControllers(
            [newVC],
            direction: selectedDate > oldDate ? .forward : .reverse,
            animated: true
        )
        
        context.coordinator.previousDate = selectedDate
    }

    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        var parent: HomeDetailPageViewController
        var previousDate: Date

        init(_ parent: HomeDetailPageViewController) {
            self.parent = parent
            self.previousDate = parent.selectedDate
        }

        func viewController(for date: Date) -> UIViewController {
            let vc = UIHostingController(rootView: DetailPageView(date: date))
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
            
            self.parent.selectedDate = newDate
        }
    }
}
