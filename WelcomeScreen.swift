import SwiftUI

struct WelcomeScreen: View {
    @State private var depositAmount: String = ""
    @State private var monthlyDepositAmount: String = ""
    @State private var navigateToDashboard = false
    @ObservedObject private var financialModel = FinancialModel.shared
    
    // Define the app's primary color (green from the prototype)
    let primaryColor = Color(red: 0, green: 0.5, blue: 0.4)
    
    var body: some View {
        if navigateToDashboard {
            DashboardScreen()
        } else {
            VStack(spacing: 40) {
                // Logo at the top
                VStack(spacing: 0) {
                    Text("vie")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(primaryColor)
                    
                    // Green smile
                    Image("vectorsmi")
                        .resizable()
                        .frame(width: 60, height: 12)
                        .foregroundColor(primaryColor)
                }
                .padding(.top, 60)
                
                // Welcome text
                Text("Welcome to Vie!")
                    .font(.system(size: 24, weight: .bold))
                    .padding(.top, 20)
                
                Spacer()
                
                // Deposit amount section
                VStack(spacing: 30) {
                    VStack(spacing: 10) {
                        Text("How much would you like to deposit initially?")
                            .font(.system(size: 16))
                            .multilineTextAlignment(.center)
                        
                        // Input field for initial deposit
                        TextField("", text: $depositAmount)
                            .keyboardType(.decimalPad)
                            .padding()
                            .frame(height: 50)
                            .background(primaryColor)
                            .cornerRadius(25)
                            .foregroundColor(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(primaryColor, lineWidth: 1)
                            )
                    }
                    
                    VStack(spacing: 10) {
                        Text("How much would you like to deposit monthly?")
                            .font(.system(size: 16))
                            .multilineTextAlignment(.center)
                        
                        // Input field for monthly deposit
                        TextField("", text: $monthlyDepositAmount)
                            .keyboardType(.decimalPad)
                            .padding()
                            .frame(height: 50)
                            .background(primaryColor)
                            .cornerRadius(25)
                            .foregroundColor(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(primaryColor, lineWidth: 1)
                            )
                    }
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                // Discover button
                Button(action: {
                    // Convert deposit amounts to Double and store in model
                    if let initialAmount = Double(depositAmount) {
                        financialModel.setInitialDeposit(amount: initialAmount)
                    }
                    
                    if let monthlyAmount = Double(monthlyDepositAmount) {
                        financialModel.setMonthlyDepositAmount(amount: monthlyAmount)
                    }
                    
                    self.navigateToDashboard = true
                }) {
                    Text("Discover")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 120, height: 40)
                        .background(primaryColor)
                        .cornerRadius(20)
                }
                .padding(.bottom, 60)
            }
            .background(Color.white)
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct WelcomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreen()
    }
}
