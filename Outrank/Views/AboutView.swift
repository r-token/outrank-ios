//
//  AboutView.swift
//  Outrank
//
//  Created by Ryan Token on 10/6/21.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 7) {
                Image("Outrank")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("Outrank")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Made with ❤️ by an independent developer")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                    .padding(.bottom, 5)
                    .multilineTextAlignment(.center)
                    .accessibilityLabel("Made with love by an independent developer")
                
                Form {
                    Section {
                        Text("I built Outrank because I needed it. I wanted a quick way to find where my favorite teams stacked up, but couldn't find a service that provided it.")
                        
                        Text("The app is free with no ads. It makes me no money by default. If you enjoy Outrank I'd love it if you left a tip or subscribed :)")
                    }
                    .padding(5)
                    
                    Section(header: Text("Try my other apps")) {
                        Button(action: {
                            openCatchUpAppStoreLink()
                        }) {
                            HStack {
                                Image("CatchUp")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 11))

                                Spacer()
                                    .frame(width: 15)

                                VStack(alignment: .leading, spacing: 3) {
                                    Text("CatchUp – Keep in Touch")
                                        .font(.headline)
                                        .foregroundColor(.primary)

                                    Text("Stay in touch with those who matter most")
                                        .multilineTextAlignment(.leading)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .accessibilityLabel("Try out this developer's other app: CatchUp – Keep in Touch")
                        
                        Button(action: {
                            openHotLocalFoodAppStoreLink()
                        }) {
                            HStack {
                                Image("HLF")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 11))
                                
                                Spacer()
                                    .frame(width: 15)
                                
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("Hot Local Food")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    
                                    Text("Find love, then eat it")
                                        .multilineTextAlignment(.leading)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .accessibilityLabel("Try out this developer's other app: Hot Local Food")
                    }
                }
            }
            
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Done")
                            .bold()
                    }
                }
            }
        }
    }
    
    func openCatchUpAppStoreLink() {
        if let url = URL(string: "itms-apps://apps.apple.com/us/app/catchup-keep-in-touch/id1358023550") {
            UIApplication.shared.open(url)
        }
    }
    
    func openHotLocalFoodAppStoreLink() {
        if let url = URL(string: "itms-apps://apps.apple.com/us/app/hot-local-food/id1621818779") {
            UIApplication.shared.open(url)
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
