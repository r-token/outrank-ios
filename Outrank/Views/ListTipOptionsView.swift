//
//  ListTipOptionsView.swift
//  Outrank
//
//  Created by Ryan Token on 10/17/21.
//

import SwiftUI
import StoreKit

struct ListTipOptionsView: View {
    @EnvironmentObject var store: Store
    @State var errorTitle = ""
    @State var isShowingError: Bool = false

    let product: Product
    let purchasingEnabled: Bool

    var emoji: String {
        store.emoji(for: product.id)
    }

    init(product: Product, purchasingEnabled: Bool = true) {
        self.product = product
        self.purchasingEnabled = purchasingEnabled
    }

    var body: some View {
        HStack {
            Text(emoji)
                .font(.system(size: 40))
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .padding(.trailing, 20)
                .accessibility(hidden: true)
            if purchasingEnabled {
                productDetail
                Spacer()
                buyButton
                    .buttonStyle(BuyButtonStyle())
            } else {
                productDetail
            }
        }
        
        .alert(isPresented: $isShowingError, content: {
            Alert(title: Text(errorTitle), message: nil, dismissButton: .default(Text("Okay")))
        })
    }

    @ViewBuilder
    var productDetail: some View {
        if product.type == .autoRenewable {
            VStack(alignment: .leading) {
                Text(product.displayName)
                    .bold()
                Text(product.description)
            }
        } else {
            Text(product.description)
                .frame(alignment: .leading)
        }
    }

    var buyButton: some View {
        Button(action: {
            Task {
                await buy()
            }
        }) {
            Text(convertToWholeNumber(product.displayPrice))
                .foregroundColor(.white)
                .bold()
        }
        .accessibilityLabel("Tip \(product.displayPrice)")
        .onAppear {
            Task {
                try? await store.isPurchased(product.id)
            }
        }
    }

    func buy() async {
        do {
            HapticGenerator.playSuccessHaptic()
            if try await store.purchase(product) != nil {
                print("Purchase was successful")
            }
        } catch StoreError.failedVerification {
            HapticGenerator.playErrorHaptic()
            errorTitle = "Your purchase could not be verified by the App Store."
            isShowingError = true
        } catch {
            HapticGenerator.playErrorHaptic()
            print("Failed purchase for \(product.id): \(error)")
        }
    }
    
    func convertToWholeNumber(_ price: String) -> String {
        switch price {
        case "$0.99":
            return "$1"
        case "$2.99":
            return "$3"
        case "$4.99":
            return "$5"
        case "$9.99":
            return "$10"
        default:
            return "Unknown"
        }
    }
}

extension LosslessStringConvertible {
    var string: String { .init(self) }
}
