//
//  PrivacyPolicy.swift
//  Akva
//
//  Created by Roland Kajatin on 17/06/2023.
//

import SwiftUI

struct PrivacyPolicy: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Privacy Policy for Akva")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Last updated: 28 June, 2023")
                    .font(.subheadline)
                
                Group {
                    Text("1. Information we collect")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text("When you use our app, we only collect data related to your water intake that you manually enter into the app. This data is used to provide you with insights about your hydration habits and trends.")
                }
                
                Group {
                    Text("2. How we use your information")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text("The data we collect is used solely to provide you with the functionalities of the Akva app. We use your water intake data to track your hydration over time and provide you with daily, weekly, and monthly summaries. This information is also used to provide personalized reminders and recommendations.")
                }
                
                Group {
                    Text("3. Data sharing")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text("We do not share your data with any third parties. The water intake data you provide is stored locally on your device and may be integrated with Apple Health, if you choose to enable this feature. We do not have access to any other health data from your Apple Health account. We only sync the water intake data you have entered in our app with Apple Health.")
                }
                
                Group {
                    Text("4. Data Security")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text("We are committed to ensuring the security of your data. We employ suitable physical, electronic, and managerial procedures to safeguard and secure the data we collect on our app.")
                }
                
                Group {
                    Text("5. Changes to our Privacy Policy")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text("We may update our Privacy Policy from time to time. Therefore, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Privacy Policy on this page. These changes are effective immediately after they are posted on this page.")
                }
                
                Group {
                    Text("6. Contact Us")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text("If you have any questions or suggestions about our Privacy Policy, do not hesitate to contact us at roland.kajatin@gmail.com.")
                }
            }
            .padding()
            .navigationBarTitle("Privacy Policy", displayMode: .inline)
        }
    }
}

#Preview {
    PrivacyPolicy()
}
