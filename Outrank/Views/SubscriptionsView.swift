//
//  SubscriptionsView.swift
//  Outrank
//
//  Created by Ryan Token on 10/17/21.
//

import SwiftUI
import StoreKit

struct SubscriptionsView: View {
    @EnvironmentObject var store: Store
    
    @State var currentSubscription: Product?
    @State var status: Product.SubscriptionInfo.Status?
    
    var body: some View {
        List {
            Group {
                if let currentSubscription = currentSubscription {
                    Section(header: Text("My Subscription")) {
                       ListSubscriptionOptionsView(product: currentSubscription, purchasingEnabled: false)

                        if let status = status {
                            StatusInfoView(product: currentSubscription,
                                            status: status)
                        }
                    }
                }

                Section(header: Text("Subscription Options")) {
                    ForEach(store.subscriptions, id: \.id) { subscription in
                        ListSubscriptionOptionsView(product: subscription)
                    }
                }
                
                Section {
                    Text("Outrank is free with no ads. If you find it useful, please consider supporting development by tipping annually.")
                        .foregroundColor(.gray)
                }
            }
            .task {
                //When this view appears, get the latest subscription status.
                await updateSubscriptionStatus()
            }
            .onChange(of: store.purchasedIdentifiers) { _ in
                Task {
                    //When `purchasedIdentifiers` changes, get the latest subscription status.
                    await updateSubscriptionStatus()
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        
        .navigationTitle("Subscriptions")
        
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Restore Purchases") {
                    restorePurchases()
                }
            }
        }
    }
    
    @MainActor
    func updateSubscriptionStatus() async {
        do {
            //This app has only one subscription group so products in the subscriptions
            //array all belong to the same group. The statuses returned by
            //`product.subscription.status` apply to the entire subscription group.
            guard let product = store.subscriptions.first,
                  let statuses = try await product.subscription?.status else {
                return
            }

            var highestStatus: Product.SubscriptionInfo.Status? = nil
            var highestProduct: Product? = nil

            //Iterate through `statuses` for this subscription group and find
            //the `Status` with the highest level of service which isn't
            //expired or revoked.
            for status in statuses {
                switch status.state {
                case .expired, .revoked:
                    continue
                default:
                    let renewalInfo = try store.checkVerified(status.renewalInfo)

                    guard let newSubscription = store.subscriptions.first(where: { $0.id == renewalInfo.currentProductID }) else {
                        continue
                    }

                    guard let currentProduct = highestProduct else {
                        highestStatus = status
                        highestProduct = newSubscription
                        continue
                    }

                    let highestTier = store.tier(for: currentProduct.id)
                    let newTier = store.tier(for: renewalInfo.currentProductID)

                    if newTier > highestTier {
                        highestStatus = status
                        highestProduct = newSubscription
                    }
                }
            }

            status = highestStatus
            currentSubscription = highestProduct
        } catch {
            print("Could not update subscription status \(error)")
        }
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}
