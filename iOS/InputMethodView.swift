//
//  InputMethodView.swift
//  iOS
//
//  Created by Jeong YunWon on 8/3/14.
//  Copyright (c) 2014 youknowone.org. All rights reserved.
//

import UIKit

class InputMethodViewController: UIViewController, UIGestureRecognizerDelegate, UIScrollViewDelegate {
    var layouts: [KeyboardLayout] = []
    @IBOutlet var logTextView: UITextView!

    @IBOutlet var leftSwipeRecognizer: UIGestureRecognizer!
    @IBOutlet var rightSwipeRecognizer: UIGestureRecognizer!

    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!)  {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    var inputMethodView: InputMethodView! {
    get {
        return self.view as InputMethodView!
    }
    }

    func keyboardLayoutForLayoutName(name: String, frame: CGRect) -> KeyboardLayout {
        switch name {
        case "qwerty":
            return QwertyKeyboardLayout()
        default:
            return NoKeyboardLayout()
        }
    }

    override func viewDidLoad()  {
        super.viewDidLoad()
        self.loadFromPreferences()
    }

    func loadFromPreferences() {
        let layoutsView = self.inputMethodView.layoutsView
        for view in layoutsView.subviews {
            view.removeFromSuperview()
        }

        self.layouts.removeAll(keepCapacity: true)
        let layoutNames = preferences.layouts
        for (i, name) in enumerate(layoutNames) {
            let layout = self.keyboardLayoutForLayoutName(name, frame: self.view.bounds)
            self.layouts.append(layout)
            layout.view.frame.origin.x = CGFloat(i) * self.view.frame.width
            layoutsView.addSubview(layout.view)
        }

        layoutsView.contentSize = CGSizeMake(self.inputMethodView.frame.width * CGFloat(self.layouts.count), 0)
        self.inputMethodView.pageControl.numberOfPages = layouts.count
        self.selectLayoutByIndex(preferences.defaultLayoutIndex, animated: false)
    }

    var selectedLayoutIndex: Int {
    get {
        let layoutsView = self.inputMethodView.layoutsView
        var page = Int(layoutsView.contentOffset.x / layoutsView.frame.size.width + 0.5)
        if page < 0 {
            page = 0
        }
        else if page >= self.inputMethodView.pageControl.numberOfPages {
            page = self.layouts.count - 1
        }
        return page
    }
    }

    func selectLayoutByIndex(index: Int, animated: Bool) {
        assert(self.inputMethodView.pageControl)
        assert(self.inputMethodView.layoutsView)
        self.inputMethodView.pageControl.currentPage = index
        let offset = CGPointMake(CGFloat(index) * self.inputMethodView.layoutsView.frame.width, 0)
        self.inputMethodView.layoutsView.setContentOffset(offset, animated: animated)
    }

    @IBAction func leftForSwipeRecognizer(recognizer: UISwipeGestureRecognizer!) {
        let index = self.selectedLayoutIndex
        if index > 0 {
            self.selectLayoutByIndex(index - 1, animated: true)
        }
    }

    @IBAction func rightForSwipeRecognizer(recognizer: UISwipeGestureRecognizer!) {
        let index = self.selectedLayoutIndex
        if index < self.layouts.count - 1 {
            self.selectLayoutByIndex(index + 1, animated: true)
        }
    }

    func scrollViewWillBeginDragging(scrollView: UIScrollView!) {
        self.inputMethodView.pageControl.alpha = 1.0
    }

    func scrollViewDidScroll(scrollView: UIScrollView!) {
        self.inputMethodView.pageControl.currentPage = self.selectedLayoutIndex
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView!) {
        UIView.animateWithDuration(0.36, animations: { self.inputMethodView.pageControl.alpha = 0.0 })
    }

}

class InputMethodView: UIView {
    @IBOutlet var layoutsView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!

}
