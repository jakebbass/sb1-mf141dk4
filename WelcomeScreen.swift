import SwiftUI

struct WelcomeScreen: View {
    @State private var monthlyDepositAmount: String = ""
    @State private var navigateToDashboard = false
    @ObservedObject private var financialModel = FinancialModel.shared
    
    // Define the app's primary color (green from the prototype)
    let primaryColor = Color(red: 0, green: 0.5, blue: 0.4)
    
    var body: some View {
        if navigateToDashboard {
            DashboardScreen()
        } else {
            ZStack {
                Color.white.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 30) {
                    // Header with design component
                    Image("header")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 120)
                        .edgesIgnoringSafeArea(.top)
                    
                    // Welcome text
                    Text("Welcome to Vie!")
                        .font(.custom("Inter", size: 24).weight(.bold))
                
                    Spacer()
                
                    // Monthly deposit section with user-input background image
                    VStack(spacing: 10) {
                        Text("How much would you like to deposit monthly?")
                            .font(.custom("Inter", size: 16))
                            .multilineTextAlignment(.center)
                        
                        ZStack {
                            // Background image for input field
                            Image("user-input")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 60)
                            
                            // Input field for monthly deposit
                            TextField("", text: $monthlyDepositAmount)
                                .keyboardType(.decimalPad)
                                .padding()
                                .frame(height: 50)
                                .foregroundColor(.white)
                                .font(.custom("Inter", size: 16))
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.horizontal, 40)
                
                    Spacer()
                    
                    // Discover button
                    Button(action: {
                        // Set a default initial deposit
                        financialModel.setInitialDeposit(amount: 10000)
                        
                        // Convert monthly deposit amount to Double and store in model
                        if let monthlyAmount = Double(monthlyDepositAmount) {
                            financialModel.setMonthlyDepositAmount(amount: monthlyAmount)
                        }
                        
                        self.navigateToDashboard = true
                    }) {
                        Text("Discover")
                            .font(.custom("Inter", size: 16).weight(.semibold))
                            .foregroundColor(.white)
                            .frame(width: 120, height: 40)
                            .background(primaryColor)
                            .cornerRadius(20)
                    }
                    .padding(.bottom, 40)
                }
            }
        }
    }
}

struct WelcomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreen()
    }
}
