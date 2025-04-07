import SwiftUI

// Home Tab View
struct HomeTabView: View {
    @ObservedObject private var financialModel = FinancialModel.shared
    @State private var animateCards = false
    @State private var selectedProjectionType = 0 // 0: Summary, 1: Totals, 2: Lift-Off Loan, 3: Accumulation, 4: Customer Spending, 5: Asset Value
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Account balance card
                VStack(alignment: .leading, spacing: 10) {
                    Text("Current Balance")
                        .font(.custom("Inter", size: 20).weight(.semibold))
                        .foregroundColor(.white)
                    
                    Text(formatCurrency(financialModel.accountBalance))
                        .font(.custom("Inter", size: 36).weight(.bold))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
                .background(
                    Color.white.opacity(0.05)
                )
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
                .offset(y: animateCards ? 0 : 20)
                .opacity(animateCards ? 1 : 0)
                .animation(Animation.spring(response: 0.5, dampingFraction: 0.8).delay(0.1), value: animateCards)
                
                // Dashboard metrics
                VStack(alignment: .leading, spacing: 15) {
                    Text("Account Summary")
                        .font(.custom("Inter", size: 20).weight(.semibold))
                        .foregroundColor(.white)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Total Deposits")
                                .font(.custom("Inter", size: 14))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text(formatCurrency(financialModel.dashboardMetrics.totalDeposits))
                                .font(.custom("Inter", size: 18).weight(.medium))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("Total Withdrawals")
                                .font(.custom("Inter", size: 14))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text(formatCurrency(financialModel.dashboardMetrics.totalWithdrawals))
                                .font(.custom("Inter", size: 18).weight(.medium))
                                .foregroundColor(.white)
                        }
                    }
                    
                    Divider()
                        .background(Color.white.opacity(0.2))
                        .padding(.vertical, 8)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Interest Earned")
                                .font(.custom("Inter", size: 14))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text(formatCurrency(financialModel.dashboardMetrics.totalInterest))
                                .font(.custom("Inter", size: 18).weight(.medium))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("Fees Paid")
                                .font(.custom("Inter", size: 14))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text(formatCurrency(financialModel.dashboardMetrics.totalFees))
                                .font(.custom("Inter", size: 18).weight(.medium))
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(20)
                .background(
                    Color.white.opacity(0.05)
                )
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
                .offset(y: animateCards ? 0 : 20)
                .opacity(animateCards ? 1 : 0)
                .animation(Animation.spring(response: 0.5, dampingFraction: 0.8).delay(0.2), value: animateCards)
                
                // Growth projection
                VStack(alignment: .leading, spacing: 15) {
                    Text("Growth Projection")
                        .font(.custom("Inter", size: 20).weight(.semibold))
                        .foregroundColor(.white)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Projected Balance (10 Years)")
                                .font(.custom("Inter", size: 14))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text(formatCurrency(financialModel.dashboardMetrics.projectedBalance))
                                .font(.custom("Inter", size: 18).weight(.medium))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("Total Growth")
                                .font(.custom("Inter", size: 14))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text(formatCurrency(financialModel.dashboardMetrics.totalGrowth))
                                .font(.custom("Inter", size: 18).weight(.medium))
                                .foregroundColor(.white)
                        }
                    }
                    
                    Divider()
                        .background(Color.white.opacity(0.2))
                        .padding(.vertical, 8)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Crediting Rate (Year 1)")
                                .font(.custom("Inter", size: 14))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("\(Int(financialModel.dashboardMetrics.annualGrowthRate * 100))%")
                                .font(.custom("Inter", size: 18).weight(.medium))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("Total Customer Deposits")
                                .font(.custom("Inter", size: 14))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text(formatCurrency(financialModel.dashboardMetrics.totalCustomerDeposits))
                                .font(.custom("Inter", size: 18).weight(.medium))
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(20)
                .background(
                    Color.white.opacity(0.05)
                )
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
                .offset(y: animateCards ? 0 : 20)
                .opacity(animateCards ? 1 : 0)
                .animation(Animation.spring(response: 0.5, dampingFraction: 0.8).delay(0.3), value: animateCards)
                
                // Projection type selector
                VStack(alignment: .leading, spacing: 15) {
                    Text("Projection Details")
                        .font(.custom("Inter", size: 20).weight(.semibold))
                        .foregroundColor(.white)
                    
                    // Segmented control for projection type
                    Picker("Projection Type", selection: $selectedProjectionType) {
                        Text("Summary").tag(0)
                        Text("Totals").tag(1)
                        Text("Lift-Off").tag(2)
                        Text("Accumulation").tag(3)
                        Text("Spending").tag(4)
                        Text("Asset Value").tag(5)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.bottom, 10)
                    
                    // Display the selected projection type
                    switch selectedProjectionType {
                    case 1:
                        TotalsView()
                    case 2:
                        LiftOffLoanView()
                    case 3:
                        AccumulationView()
                    case 4:
                        CustomerSpendingView()
                    case 5:
                        AssetValueView()
                    default:
                        YearlyProjectionView()
                    }
                }
                .padding(20)
                .background(
                    Color.white.opacity(0.05)
                )
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
                .offset(y: animateCards ? 0 : 20)
                .opacity(animateCards ? 1 : 0)
                .animation(Animation.spring(response: 0.5, dampingFraction: 0.8).delay(0.4), value: animateCards)
            }
            .padding(16)
        }
        .onAppear {
            // Trigger animations when view appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                animateCards = true
            }
        }
        .onDisappear {
            // Reset animation state when view disappears
            animateCards = false
        }
    }
    
    // Helper function to format currency with commas and rounded to nearest dollar
    private func formatCurrency(_ value: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = 0
        numberFormatter.minimumFractionDigits = 0
        
        // Round to nearest dollar
        let roundedValue = round(value)
        
        return numberFormatter.string(from: NSNumber(value: roundedValue)) ?? "$0"
    }
}
