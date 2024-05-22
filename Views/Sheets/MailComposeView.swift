//
//  MailComposeView.swift
//
//  Created by Mathijs Bernson on 08/03/2022.
//  Copyright © 2022 Q42. All rights reserved.
//

import SwiftUI
import MessageUI

/// A view that lets the user compose an email using the Mail app.
struct MailComposeView: UIViewControllerRepresentable {
  let subject: String
  let toRecipients: [String]
  let body: String
  @Environment(\.dismiss) private var dismiss

  static var canSendMail: Bool {
    MFMailComposeViewController.canSendMail()
  }

  func makeUIViewController(context: Context) -> MFMailComposeViewController {
    let controller = MFMailComposeViewController()
    controller.setSubject(subject)
    controller.setToRecipients(toRecipients)
    controller.setMessageBody(body, isHTML: false)
    controller.mailComposeDelegate = context.coordinator
    return controller
  }

  func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {
    // We don't update the MFMailComposeViewController
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(dismiss: dismiss)
  }

  class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
    private var dismiss: DismissAction

    init(dismiss: DismissAction) {
      self.dismiss = dismiss
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
      dismiss()
    }
  }
}
