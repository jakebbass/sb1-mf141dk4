import SwiftUI

struct WelcomeScreen: View {
    @State private var monthlyDepositAmount: String = ""
    @State private var navigateToDashboard = false
    @State private var isInputActive = false
    @ObservedObject private var financialModel = FinancialModel.shared
    
    // Define the app's colors
    let primaryColor = Color(red: 0, green: 0.5, blue: 0.4)
    let secondaryColor = Color(red: 0, green: 0.6, blue: 0.5)
    
    var body: some View {
        if navigateToDashboard {
            DashboardScreen()
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
        } else {
            ZStack {
                Color.white.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Header with design component
                    Image("header")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 140)
                        .edgesIgnoringSafeArea(.top)
                    
                    // Main content
                    VStack(spacing: 40) {
                        // Welcome text with shadow for better readability
                        Text("Welcome to Vie!")
                            .font(.custom("Inter", size: 28).weight(.bold))
                            .foregroundColor(.black)
                            .padding(.top, 30)
                            .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                    
                        // Monthly deposit section with user-input background image
                        VStack(spacing: 16) {
                            Text("How much would you like to deposit monthly?")
                                .font(.custom("Inter", size: 18))
                                .foregroundColor(.black.opacity(0.8))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            ZStack {
                                // Background image for input field
                                Image("user-input")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 70)
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                                
                                // Input field for monthly deposit
                                TextField("", text: $monthlyDepositAmount)
                                    .keyboardType(.decimalPad)
                                    .padding()
                                    .frame(height: 50)
                                    .foregroundColor(.white)
                                    .font(.custom("Inter", size: 20).weight(.medium))
                                    .multilineTextAlignment(.center)
                                    .scaleEffect(isInputActive ? 1.05 : 1.0)
                                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isInputActive)
                                    .onTapGesture {
                                        isInputActive = true
                                    }
                                    .onSubmit {
                                        isInputActive = false
                                    }
                                
                                // Dollar sign prefix
                                if monthlyDepositAmount.isEmpty {
                                    Text("$")
                                        .font(.custom("Inter", size: 20).weight(.medium))
                                        .foregroundColor(.white.opacity(0.7))
                                }
                            }
                            .padding(.top, 10)
                        }
                        .padding(.horizontal, 30)
                        .padding(.vertical, 20)
                        
                        Spacer()
                        
                        // Discover button with animation
                        Button(action: {
                            // Haptic feedback
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                            
                            // Set a default initial deposit
                            financialModel.setInitialDeposit(amount: 10000)
                            
                            // Convert monthly deposit amount to Double and store in model
                            if let monthlyAmount = Double(monthlyDepositAmount.replacingOccurrences(of: ",", with: "")) {
                                financialModel.setMonthlyDepositAmount(amount: monthlyAmount)
                            }
                            
                            withAnimation(.easeInOut(duration: 0.5)) {
                                self.navigateToDashboard = true
                            }
                        }) {
                            Text("Discover")
                                .font(.custom("Inter", size: 18).weight(.semibold))
                                .foregroundColor(.white)
                                .frame(width: 160, height: 50)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [primaryColor, secondaryColor]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(25)
                                .shadow(color: primaryColor.opacity(0.4), radius: 8, x: 0, y: 4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                        }
                        .buttonStyle(ScaleButtonStyle())
                        .padding(.bottom, 60)
                    }
                    .padding(.horizontal)
                }
            }
            .onTapGesture {
                // Dismiss keyboard when tapping outside
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                isInputActive = false
            }
        }
    }
}

// Custom button style for scale animation
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

struct WelcomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreen()
    }
}
