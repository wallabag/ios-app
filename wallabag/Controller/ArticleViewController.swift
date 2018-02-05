//
//  ArticleViewController.swift
//  wallabag
//
//  Created by maxime marinel on 23/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit
import TUSafariActivity
import WallabagKit
import AVFoundation

final class ArticleViewController: UIViewController {

    lazy var speechSynthetizer: AVSpeechSynthesizer = AVSpeechSynthesizer()

    var entry: Entry! {
        didSet {
            updateUi()
        }
    }

    var deleteHandler: ((_ entry: Entry) -> Void)?
    var readHandler: ((_ entry: Entry) -> Void)?
    var starHandler: ((_ entry: Entry) -> Void)?
    var addHandler: (() -> Void)?

    @IBOutlet weak var contentWeb: UIWebView!
    @IBOutlet weak var readButton: UIBarButtonItem!
    @IBOutlet weak var starButton: UIBarButtonItem!
    @IBOutlet weak var speechButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!

    @IBAction func add(_ sender: Any) {
        addHandler?()
    }

    @IBAction func read(_ sender: Any) {
        readHandler?(entry)
        _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func star(_ sender: Any) {
        starHandler?(entry)
        updateUi()
    }

    @IBAction func speech(_ sender: Any) {
        if !speechSynthetizer.isSpeaking {
            let utterance = AVSpeechUtterance(string: entry.content!.withoutHTML)
            utterance.rate = Setting.getSpeechRate()
            utterance.voice = Setting.getSpeechVoice()
            speechSynthetizer.speak(utterance)
            speechButton.image = #imageLiteral(resourceName: "lipsfilled")
        } else {
            speechSynthetizer.stopSpeaking(at: .word)
            speechButton.image = #imageLiteral(resourceName: "lips")
        }
    }

    @IBAction func shareMenu(_ sender: UIBarButtonItem) {
        let shareController = UIActivityViewController(activityItems: [URL(string: entry.url!) as Any], applicationActivities: [TUSafariActivity()])
        shareController.excludedActivityTypes = [.airDrop, .addToReadingList, .copyToPasteboard]
        shareController.popoverPresentationController?.barButtonItem = sender

        present(shareController, animated: true)
    }

    @IBAction func deleteArticle(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Delete".localized, message: "Are you sure?".localized, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete".localized, style: .destructive, handler: { _ in
            self.deleteHandler?(self.entry)
            _ = self.navigationController?.popToRootViewController(animated: true)
        })
        alert.addAction(deleteAction)
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel))
        alert.popoverPresentationController?.barButtonItem = sender

        present(alert, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = entry.title
        updateUi()
        setupAccessibilityLabel()
        loadArticleContent()
        contentWeb.scrollView.delegate = self
        contentWeb.backgroundColor = ThemeManager.manager.getBackgroundColor()

        UIApplication.shared.isIdleTimerDisabled = true

        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        speechSynthetizer.stopSpeaking(at: .immediate)
        UIApplication.shared.isIdleTimerDisabled = false
    }

    private func loadArticleContent() {
        DispatchQueue.main.async { [unowned self] in
            self.contentWeb.loadHTMLString(self.contentForWebView(self.entry), baseURL: Bundle.main.bundleURL)
        }
    }

    func contentForWebView(_ entry: Entry) -> String {
        do {
            let html = try String(contentsOfFile: Bundle.main.path(forResource: "article", ofType: "html")!)
            let justify = Setting.isJustifyArticle() ? "justify.css" : ""

            return String(format: html, arguments: [justify, Setting.getTheme(), entry.title!, entry.content!])
        } catch {
            fatalError("Unable to load article view")
        }
    }

    private func updateUi() {
        readButton?.image = entry.is_archived ? #imageLiteral(resourceName: "readed") : #imageLiteral(resourceName: "unreaded")
        starButton?.image = entry.is_starred ? #imageLiteral(resourceName: "starred") : #imageLiteral(resourceName: "unstarred")
    }
}

extension ArticleViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.scrollView.setContentOffset(CGPoint(x: 0.0, y: Double(self.entry.screen_position)), animated: true)
    }
}

extension ArticleViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        entry.screen_position = Float(scrollView.contentOffset.y)
    }
}

extension ArticleViewController {
    private func setupAccessibilityLabel() {
        readButton.accessibilityLabel = "Read".localized
        starButton.accessibilityLabel = "Star".localized
        speechButton.accessibilityLabel = "Speech".localized
        deleteButton.accessibilityLabel = "Delete".localized
    }
}
