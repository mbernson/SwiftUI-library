//
//  MailDemoView.swift
//  SwiftUILibrary
//
//  Created by Mathijs Bernson on 14/07/2023.
//

import SwiftUI

struct MailDemoView: View {
    @State var emailRecipient = "info@q42.nl"
    @State var emailSubject = "This is the subject"
    @State var emailBody = "This is the body"

    @State var isPresentingMailSheet = false

    var body: some View {
        if MailComposeView.canSendMail {
            Button("Send us an email") {
                isPresentingMailSheet = true
            }
            .sheet(isPresented: $isPresentingMailSheet) {
                MailComposeView(
                    subject: emailSubject,
                    toRecipients: [emailRecipient],
                    body: emailBody
                )
            }
        } else {
            Text("This device cannot send mail or the Mail app is not configured.")
        }
    }
}

struct MailDemoView_Previews: PreviewProvider {
    static var previews: some View {
        MailDemoView()
    }
}
