//
//  ListSubscriptionOptionsView.swift
//  Outrank
//
//  Created by Ryan Token on 10/17/21.
//

import SwiftUI
import StoreKit

struct ListSubscriptionOptionsView: View {
    @EnvironmentObject var store: Store
    @State var isPurchased: Bool = false
    @State var errorTitle = ""
    @State var isShowingError: Bool = false

    let product: Product
    let purchasingEnabled: Bool

    init(product: Product, purchasingEnabled: Bool = true) {
        self.product = product
        self.purchasingEnabled = purchasingEnabled
    }

    var body: some View {
        HStack {
            if purchasingEnabled {
                productDetail
                Spacer()
                buyButton
                    .buttonStyle(SubscribeButtonStyle(isPurchased: isPurchased))
                    .disabled(isPurchased)
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
            .accessibilityLabel(product.description)
        } else {
            Text(product.description)
                .frame(alignment: .leading)
        }
    }

    func subscribeButton(_ subscription: Product.SubscriptionInfo) -> some View {
        let unit: String
        
        let plural = 1 < subscription.subscriptionPeriod.value
            switch subscription.subscriptionPeriod.unit {
        case .day:
            unit = plural ? "\(subscription.subscriptionPeriod.value) days" : "day"
        case .week:
            unit = plural ? "\(subscription.subscriptionPeriod.value) weeks" : "week"
        case .month:
            unit = plural ? "\(subscription.subscriptionPeriod.value) months" : "month"
        case .year:
            unit = plural ? "\(subscription.subscriptionPeriod.value) years" : "year"
        @unknown default:
            unit = "period"
        }

        return VStack {
            Text(convertToWholeNumber(product.displayPrice))
                .foregroundColor(.white)
                .bold()
                .padding(EdgeInsets(top: -4.0, leading: 0.0, bottom: -8.0, trailing: 0.0))
            Divider()
                .background(Color.white)
            Text(unit)
                .foregroundColor(.white)
                .font(.system(size: 12))
                .padding(EdgeInsets(top: -8.0, leading: 0.0, bottom: -4.0, trailing: 0.0))
        }
        .accessibilityLabel("\(product.displayPrice) per year")
    }

    var buyButton: some View {
        Button(action: {
            Task {
                await buy()
            }
        }) {
            if isPurchased {
                Text(Image(systemName: "checkmark"))
                    .bold()
                    .foregroundColor(.white)
            } else {
                if let subscription = product.subscription {
                    subscribeButton(subscription)
                } else {
                    Text("product.displayPrice")
                        .foregroundColor(.white)
                        .bold()
                }
            }
        }
        .onAppear {
            Task {
                isPurchased = (try? await store.isPurchased(product.id)) ?? false
            }
        }
        .onChange(of: store.purchasedIdentifiers) { identifiers in
            Task {
                isPurchased = identifiers.contains(product.id)
            }
        }
    }

    func buy() async {
        do {
            if try await store.purchase(product) != nil {
                print("success")
                withAnimation {
                    isPurchased = true
                }
            } else {
                HapticGenerator.playErrorHaptic()
                print("huh?")
            }
        } catch StoreError.failedVerification {
            HapticGenerator.playErrorHaptic()
            errorTitle = "Your purchase could not be verified by the App Store."
            print("failed verification")
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
