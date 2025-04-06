import SwiftUI

// This file contains all the views used in the app

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
    
    // Helper function to get the crediting rate for a specific year
    private func getCreditingRate(for yearId: String) -> Double {
        let creditingRates: [String: Double] = [
            "YR00": 0.0,
            "YR01": 0.12, // 12%
            "YR02": 0.08, // 8%
            "YR03": 0.04, // 4%
            "YR04": 0.0,  // 0%
            "YR05": 0.08, // 8%
            "YR06": 0.12, // 12%
            "YR07": 0.12, // 12%
            "YR08": 0.0,  // 0%
            "YR09": 0.08, // 8%
            "YR10": 0.08, // 8%
            "YR11": 0.12, // 12%
            "YR12": 0.08, // 8%
            "YR13": 0.0,  // 0%
            "YR14": 0.08, // 8%
            "YR15": 0.12, // 12%
            "YR16": 0.08, // 8%
            "YR17": 0.12, // 12%
            "YR18": 0.04, // 4%
            "YR19": 0.08, // 8%
            "YR20": 0.12, // 12%
            "YR21": 0.0,  // 0%
            "YR22": 0.12, // 12%
            "YR23": 0.08, // 8%
            "YR24": 0.0,  // 0%
            "YR25": 0.12  // 12%
        ]
        
        return creditingRates[yearId] ?? 0.08 // Default to 8% if not found
    }
}

// Yearly Projection View (Summary)
struct YearlyProjectionView: View {
    @ObservedObject private var financialModel = FinancialModel.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Table header
            HStack {
                Text("Year")
                    .font(.custom("Inter", size: 14).weight(.medium))
                    .foregroundColor(.white.opacity(0.9))
                    .frame(width: 60, alignment: .leading)
                
                Text("Rate")
                    .font(.custom("Inter", size: 14).weight(.medium))
                    .foregroundColor(.white.opacity(0.9))
                    .frame(width: 60, alignment: .center)
                
                Text("Balance")
                    .font(.custom("Inter", size: 14).weight(.medium))
                    .foregroundColor(.white.opacity(0.9))
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(Color.white.opacity(0.1))
            .cornerRadius(8)
            
            // Table rows
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(financialModel.growthProjection) { projection in
                        HStack {
                            Text(projection.id)
                                .font(.custom("Inter", size: 14))
                                .foregroundColor(.white)
                                .frame(width: 60, alignment: .leading)
                            
                            // Get the crediting rate for this year
                            let yearRate = getCreditingRate(for: projection.id)
                            Text("\(Int(yearRate * 100))%")
                                .font(.custom("Inter", size: 14))
                                .foregroundColor(.white)
                                .frame(width: 60, alignment: .center)
                            
                            Text("$" + String(format: "%.2f", projection.beginningCashValue))
                                .font(.custom("Inter", size: 14))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 12)
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(8)
                    }
                }
            }
            .frame(height: 220)
        }
    }
    
    // Helper function to get the crediting rate for a specific year
    private func getCreditingRate(for yearId: String) -> Double {
        let creditingRates: [String: Double] = [
            "YR00": 0.0,
            "YR01": 0.12, // 12%
            "YR02": 0.08, // 8%
            "YR03": 0.04, // 4%
            "YR04": 0.0,  // 0%
            "YR05": 0.08, // 8%
            "YR06": 0.12, // 12%
            "YR07": 0.12, // 12%
            "YR08": 0.0,  // 0%
            "YR09": 0.08, // 8%
            "YR10": 0.08, // 8%
            "YR11": 0.12, // 12%
            "YR12": 0.08, // 8%
            "YR13": 0.0,  // 0%
            "YR14": 0.08, // 8%
            "YR15": 0.12, // 12%
            "YR16": 0.08, // 8%
            "YR17": 0.12, // 12%
            "YR18": 0.04, // 4%
            "YR19": 0.08, // 8%
            "YR20": 0.12, // 12%
            "YR21": 0.0,  // 0%
            "YR22": 0.12, // 12%
            "YR23": 0.08, // 8%
            "YR24": 0.0,  // 0%
            "YR25": 0.12  // 12%
        ]
        
        return creditingRates[yearId] ?? 0.08 // Default to 8% if not found
    }
}

// Lift-Off Loan View
struct LiftOffLoanView: View {
    @ObservedObject private var financialModel = FinancialModel.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Table header
            HStack {
                Text("Year")
                    .font(.custom("Inter", size: 12).weight(.medium))
                    .foregroundColor(.white.opacity(0.9))
                    .frame(width: 40, alignment: .leading)
                
                Text("Start Bal")
                    .font(.custom("Inter", size: 12).weight(.medium))
                    .foregroundColor(.white.opacity(0.9))
                    .frame(width: 70, alignment: .trailing)
                
                Text("Payment")
                    .font(.custom("Inter", size: 12).weight(.medium))
                    .foregroundColor(.white.opacity(0.9))
                    .frame(width: 70, alignment: .trailing)
                
                Text("End Bal")
                    .font(.custom("Inter", size: 12).weight(.medium))
                    .foregroundColor(.white.opacity(0.9))
                    .frame(width: 70, alignment: .trailing)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(Color.white.opacity(0.1))
            .cornerRadius(8)
            
            // Table rows
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(financialModel.liftOffLoanSchedule) { entry in
                        HStack {
                            Text(entry.id)
                                .font(.custom("Inter", size: 12))
                                .foregroundColor(.white)
                                .frame(width: 40, alignment: .leading)
                            
                            Text("$" + String(format: "%.0f", entry.startingBalance))
                                .font(.custom("Inter", size: 12))
                                .foregroundColor(.white)
                                .frame(width: 70, alignment: .trailing)
                            
                            Text("$" + String(format: "%.0f", entry.youPaid))
                                .font(.custom("Inter", size: 12))
                                .foregroundColor(.white)
                                .frame(width: 70, alignment: .trailing)
                            
                            Text("$" + String(format: "%.0f", entry.endingBalance))
                                .font(.custom("Inter", size: 12))
                                .foregroundColor(.white)
                                .frame(width: 70, alignment: .trailing)
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 12)
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(8)
                    }
                }
            }
            .frame(height: 220)
        }
    }
}

// Accumulation View
struct AccumulationView: View {
    @ObservedObject private var financialModel = FinancialModel.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Table header
            HStack {
                Text("Year")
                    .font(.custom("Inter", size: 12).weight(.medium))
                    .foregroundColor(.white.opacity(0.9))
                    .frame(width: 40, alignment: .leading)
                
                Text("Rate")
                    .font(.custom("Inter", size: 12).weight(.medium))
                    .foregroundColor(.white.opacity(0.9))
                    .frame(width: 40, alignment: .center)
                
                Text("Deposits")
                    .font(.custom("Inter", size: 12).weight(.medium))
                    .foregroundColor(.white.opacity(0.9))
                    .frame(width: 70, alignment: .trailing)
                
                Text("Cash Value")
                    .font(.custom("Inter", size: 12).weight(.medium))
                    .foregroundColor(.white.opacity(0.9))
                    .frame(width: 90, alignment: .trailing)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(Color.white.opacity(0.1))
            .cornerRadius(8)
            
            // Table rows
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(financialModel.accumulationGrowth) { entry in
                        HStack {
                            Text(entry.id)
                                .font(.custom("Inter", size: 12))
                                .foregroundColor(.white)
                                .frame(width: 40, alignment: .leading)
                            
                            Text("\(Int(entry.policyCredit * 100))%")
                                .font(.custom("Inter", size: 12))
                                .foregroundColor(.white)
                                .frame(width: 40, alignment: .center)
                            
                            Text("$" + String(format: "%.0f", entry.customerDeposits))
                                .font(.custom("Inter", size: 12))
                                .foregroundColor(.white)
                                .frame(width: 70, alignment: .trailing)
                            
                            Text("$" + String(format: "%.0f", entry.policyCashValue))
                                .font(.custom("Inter", size: 12))
                                .foregroundColor(.white)
                                .frame(width: 90, alignment: .trailing)
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 12)
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(8)
                    }
                }
            }
            .frame(height: 220)
        }
    }
}

// Customer Spending View
struct CustomerSpendingView: View {
    @ObservedObject private var financialModel = FinancialModel.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Table header
            HStack {
                Text("Year")
                    .font(.custom("Inter", size: 12).weight(.medium))
                    .foregroundColor(.white.opacity(0.9))
                    .frame(width: 40, alignment: .leading)
                
                Text("Spent")
                    .font(.custom("Inter", size: 12).weight(.medium))
                    .foregroundColor(.white.opacity(0.9))
                    .frame(width: 70, alignment: .trailing)
                
                Text("Interest")
                    .font(.custom("Inter", size: 12).weight(.medium))
                    .foregroundColor(.white.opacity(0.9))
                    .frame(width: 70, alignment: .trailing)
                
                Text("End Balance")
                    .font(.custom("Inter", size: 12).weight(.medium))
                    .foregroundColor(.white.opacity(0.9))
                    .frame(width: 90, alignment: .trailing)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(Color.white.opacity(0.1))
            .cornerRadius(8)
            
            // Table rows
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(financialModel.customerSpending) { entry in
                        HStack {
                            Text(entry.id)
                                .font(.custom("Inter", size: 12))
                                .foregroundColor(.white)
                                .frame(width: 40, alignment: .leading)
                            
                            Text("$" + String(format: "%.0f", entry.spent))
                                .font(.custom("Inter", size: 12))
                                .foregroundColor(.white)
                                .frame(width: 70, alignment: .trailing)
                            
                            Text("$" + String(format: "%.0f", entry.loanInterest))
                                .font(.custom("Inter", size: 12))
                                .foregroundColor(.white)
                                .frame(width: 70, alignment: .trailing)
                            
                            Text("$" + String(format: "%.0f", entry.endLoanBalance))
                                .font(.custom("Inter", size: 12))
                                .foregroundColor(.white)
                                .frame(width: 90, alignment: .trailing)
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 12)
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(8)
                    }
                }
            }
            .frame(height: 220)
        }
    }
}

// Asset Value View
struct AssetValueView: View {
    @ObservedObject private var financialModel = FinancialModel.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Table header
            HStack {
                Text("Year")
                    .font(.custom("Inter", size: 12).weight(.medium))
                    .foregroundColor(.white.opacity(0.9))
                    .frame(width: 40, alignment: .leading)
                
                Text("Asset Value")
                    .font(.custom("Inter", size: 12).weight(.medium))
                    .foregroundColor(.white.opacity(0.9))
                    .frame(width: 80, alignment: .trailing)
                
                Text("Avail. Spending")
                    .font(.custom("Inter", size: 12).weight(.medium))
                    .foregroundColor(.white.opacity(0.9))
                    .frame(width: 100, alignment: .trailing)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(Color.white.opacity(0.1))
            .cornerRadius(8)
            
            // Table rows
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(financialModel.assetValue) { entry in
                        HStack {
                            Text(entry.id)
                                .font(.custom("Inter", size: 12))
                                .foregroundColor(.white)
                                .frame(width: 40, alignment: .leading)
                            
                            Text("$" + String(format: "%.0f", entry.assetValue))
                                .font(.custom("Inter", size: 12))
                                .foregroundColor(.white)
                                .frame(width: 80, alignment: .trailing)
                            
                            Text("$" + String(format: "%.0f", entry.availableForSpending))
                                .font(.custom("Inter", size: 12))
                                .foregroundColor(.white)
                                .frame(width: 100, alignment: .trailing)
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 12)
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(8)
                    }
                }
            }
            .frame(height: 220)
        }
    }
}

// Payments Tab View
struct PaymentsTabView: View {
    @ObservedObject private var financialModel = FinancialModel.shared
    @State private var showingAddPayment = false
    @State private var paymentAmount = ""
    @State private var paymentDescription = ""
    
    var body: some View {
        VStack {
            // Payment history
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    Text("Recent Transactions")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.top, 20)
                    
                    ForEach(financialModel.transactions.filter { $0.type == .deposit || $0.type == .withdrawal }) { transaction in
                        TransactionRow(transaction: transaction)
                    }
                    
                    if financialModel.transactions.filter({ $0.type == .deposit || $0.type == .withdrawal }).isEmpty {
                        Text("No payment transactions yet")
                            .foregroundColor(.white.opacity(0.7))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    }
                }
                .padding(.vertical)
            }
            
            // Add payment button
            Button(action: {
                showingAddPayment = true
            }) {
                Text("Add Payment")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0, green: 0.5, blue: 0.4))
                    .cornerRadius(25)
                    .padding(.horizontal)
            }
            .padding(.bottom)
        }
        .sheet(isPresented: $showingAddPayment) {
            // Add payment sheet
            VStack(spacing: 20) {
                Text("Add Payment")
                    .font(.title)
                    .bold()
                
                TextField("Amount", text: $paymentAmount)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                
                TextField("Description", text: $paymentDescription)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                
                HStack {
                    Button("Cancel") {
                        showingAddPayment = false
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    
                    Button("Add") {
                        if let amount = Double(paymentAmount), !paymentDescription.isEmpty {
                            financialModel.addTransaction(
                                description: paymentDescription,
                                amount: amount,
                                type: .deposit
                            )
                            paymentAmount = ""
                            paymentDescription = ""
                            showingAddPayment = false
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 0, green: 0.5, blue: 0.4))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}

// Transaction Row
struct TransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(transaction.description)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(formattedDate(transaction.date))
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            Text(formattedAmount(transaction))
                .font(.headline)
                .foregroundColor(transaction.type == .deposit || transaction.type == .interest ? .green : .red)
        }
        .padding()
        .background(Color(red: 0, green: 0.4, blue: 0.35))
        .cornerRadius(10)
        .padding(.horizontal)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func formattedAmount(_ transaction: Transaction) -> String {
        let prefix = transaction.type == .deposit || transaction.type ==
