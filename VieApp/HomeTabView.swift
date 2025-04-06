import SwiftUI

// Home Tab View
struct HomeTabView: View {
    @ObservedObject private var financialModel = FinancialModel.shared
    @State private var animateCards = false
    @State private var selectedProjectionType = 0 // 0: Summary, 1: Lift-Off Loan, 2: Accumulation, 3: Customer Spending, 4: Asset Value
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Account balance card
                VStack(alignment: .leading, spacing: 10) {
                    Text("Current Balance")
                        .font(.custom("Inter", size: 20).weight(.semibold))
                        .foregroundColor(.white)
                    
                    Text("$" + String(format: "%.2f", financialModel.accountBalance))
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
                            
                            Text("$" + String(format: "%.2f", financialModel.dashboardMetrics.totalDeposits))
                                .font(.custom("Inter", size: 18).weight(.medium))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("Total Withdrawals")
                                .font(.custom("Inter", size: 14))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("$" + String(format: "%.2f", financialModel.dashboardMetrics.totalWithdrawals))
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
                            
                            Text("$" + String(format: "%.2f", financialModel.dashboardMetrics.totalInterest))
                                .font(.custom("Inter", size: 18).weight(.medium))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("Fees Paid")
                                .font(.custom("Inter", size: 14))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("$" + String(format: "%.2f", financialModel.dashboardMetrics.totalFees))
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
                            
                            Text("$" + String(format: "%.2f", financialModel.dashboardMetrics.projectedBalance))
                                .font(.custom("Inter", size: 18).weight(.medium))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("Total Growth")
                                .font(.custom("Inter", size: 14))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("$" + String(format: "%.2f", financialModel.dashboardMetrics.totalGrowth))
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
                            
                            Text("$" + String(format: "%.2f", financialModel.dashboardMetrics.totalCustomerDeposits))
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
                        Text("Lift-Off Loan").tag(1)
                        Text("Accumulation").tag(2)
                        Text("Spending").tag(3)
                        Text("Asset Value").tag(4)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.bottom, 10)
                    
                    // Display the selected projection type
                    switch selectedProjectionType {
                    case 1:
                        LiftOffLoanView()
                    case 2:
                        AccumulationView()
                    case 3:
                        CustomerSpendingView()
                    case 4:
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
}
