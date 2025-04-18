import SwiftUI

// Yearly Projection View (Summary)
struct YearlyProjectionView: View {
    @ObservedObject private var financialModel = FinancialModel.shared
    @State private var showDetailedView = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Toggle for detailed view
            Toggle("Show Detailed View", isOn: $showDetailedView)
                .foregroundColor(.white)
                .padding(.horizontal, 15)
                .padding(.bottom, 5)
            
            // Table header
            if showDetailedView {
                HStack {
                    Text("Year")
                        .font(.custom("Inter", size: 12).weight(.medium))
                        .foregroundColor(.white.opacity(0.9))
                        .frame(width: 40, alignment: .leading)
                    
                    Text("Rate")
                        .font(.custom("Inter", size: 12).weight(.medium))
                        .foregroundColor(.white.opacity(0.9))
                        .frame(width: 40, alignment: .center)
                    
                    Text("Vie Deposit")
                        .font(.custom("Inter", size: 12).weight(.medium))
                        .foregroundColor(.white.opacity(0.9))
                        .frame(width: 70, alignment: .trailing)
                    
                    Text("Your Deposit")
                        .font(.custom("Inter", size: 12).weight(.medium))
                        .foregroundColor(.white.opacity(0.9))
                        .frame(width: 70, alignment: .trailing)
                    
                    Text("Balance")
                        .font(.custom("Inter", size: 12).weight(.medium))
                        .foregroundColor(.white.opacity(0.9))
                        .frame(width: 80, alignment: .trailing)
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .background(Color.white.opacity(0.1))
                .cornerRadius(8)
            } else {
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
            }
            
            // Table rows
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(financialModel.growthProjection) { projection in
                        if showDetailedView {
                            HStack {
                                Text(projection.id)
                                    .font(.custom("Inter", size: 12))
                                    .foregroundColor(.white)
                                    .frame(width: 40, alignment: .leading)
                                
                                Text("\(Int(projection.creditingRate * 100))%")
                                    .font(.custom("Inter", size: 12))
                                    .foregroundColor(.white)
                                    .frame(width: 40, alignment: .center)
                                
                                Text(formatCurrency(projection.vieDeposit))
                                    .font(.custom("Inter", size: 12))
                                    .foregroundColor(.white)
                                    .frame(width: 70, alignment: .trailing)
                                
                                Text(formatCurrency(projection.customerDeposit))
                                    .font(.custom("Inter", size: 12))
                                    .foregroundColor(.white)
                                    .frame(width: 70, alignment: .trailing)
                                
                                Text(formatCurrency(projection.beginningCashValue))
                                    .font(.custom("Inter", size: 12))
                                    .foregroundColor(.white)
                                    .frame(width: 80, alignment: .trailing)
                            }
                            .padding(.horizontal, 15)
                            .padding(.vertical, 12)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(8)
                        } else {
                            HStack {
                                Text(projection.id)
                                    .font(.custom("Inter", size: 14))
                                    .foregroundColor(.white)
                                    .frame(width: 60, alignment: .leading)
                                
                                // Use the crediting rate from the projection
                                Text("\(Int(projection.creditingRate * 100))%")
                                    .font(.custom("Inter", size: 14))
                                    .foregroundColor(.white)
                                    .frame(width: 60, alignment: .center)
                                
                                Text(formatCurrency(projection.beginningCashValue))
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

// Lift-Off Loan View
struct LiftOffLoanView: View {
    @ObservedObject private var financialModel = FinancialModel.shared
    @State private var showDetailedView = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Toggle for detailed view
            Toggle("Show Detailed View", isOn: $showDetailedView)
                .foregroundColor(.white)
                .padding(.horizontal, 15)
                .padding(.bottom, 5)
            
            // Table header
            if showDetailedView {
                HStack {
                    Text("Year")
                        .font(.custom("Inter", size: 10).weight(.medium))
                        .foregroundColor(.white.opacity(0.9))
                        .frame(width: 30, alignment: .leading)
                    
                    Text("Start Bal")
                        .font(.custom("Inter", size: 10).weight(.medium))
                        .foregroundColor(.white.opacity(0.9))
                        .frame(width: 55, alignment: .trailing)
                    
                    Text("Interest")
                        .font(.custom("Inter", size: 10).weight(.medium))
                        .foregroundColor(.white.opacity(0.9))
                        .frame(width: 50, alignment: .trailing)
                    
                    Text("Principal")
                        .font(.custom("Inter", size: 10).weight(.medium))
                        .foregroundColor(.white.opacity(0.9))
                        .frame(width: 50, alignment: .trailing)
                    
                    Text("Payment")
                        .font(.custom("Inter", size: 10).weight(.medium))
                        .foregroundColor(.white.opacity(0.9))
                        .frame(width: 50, alignment: .trailing)
                    
                    Text("Fee")
                        .font(.custom("Inter", size: 10).weight(.medium))
                        .foregroundColor(.white.opacity(0.9))
                        .frame(width: 40, alignment: .trailing)
                    
                    Text("End Bal")
                        .font(.custom("Inter", size: 10).weight(.medium))
                        .foregroundColor(.white.opacity(0.9))
                        .frame(width: 55, alignment: .trailing)
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .background(Color.white.opacity(0.1))
                .cornerRadius(8)
            } else {
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
            }
            
            // Table rows
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(financialModel.liftOffLoanSchedule) { entry in
                        if showDetailedView {
                            HStack {
                                Text(entry.id)
                                    .font(.custom("Inter", size: 10))
                                    .foregroundColor(.white)
                                    .frame(width: 30, alignment: .leading)
                                
                                Text(formatCurrency(entry.startingBalance))
                                    .font(.custom("Inter", size: 10))
                                    .foregroundColor(.white)
                                    .frame(width: 55, alignment: .trailing)
                                
                                Text(formatCurrency(entry.interestPayment))
                                    .font(.custom("Inter", size: 10))
                                    .foregroundColor(.white)
                                    .frame(width: 50, alignment: .trailing)
                                
                                Text(formatCurrency(entry.principalPayment))
                                    .font(.custom("Inter", size: 10))
                                    .foregroundColor(.white)
                                    .frame(width: 50, alignment: .trailing)
                                
                                Text(formatCurrency(entry.youPaid))
                                    .font(.custom("Inter", size: 10))
                                    .foregroundColor(.white)
                                    .frame(width: 50, alignment: .trailing)
                                
                                Text(formatCurrency(entry.financeCharge))
                                    .font(.custom("Inter", size: 10))
                                    .foregroundColor(.white)
                                    .frame(width: 40, alignment: .trailing)
                                
                                Text(formatCurrency(entry.endingBalance))
                                    .font(.custom("Inter", size: 10))
                                    .foregroundColor(.white)
                                    .frame(width: 55, alignment: .trailing)
                            }
                            .padding(.horizontal, 15)
                            .padding(.vertical, 12)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(8)
                        } else {
                            HStack {
                                Text(entry.id)
                                    .font(.custom("Inter", size: 12))
                                    .foregroundColor(.white)
                                    .frame(width: 40, alignment: .leading)
                                
                                Text(formatCurrency(entry.startingBalance))
                                    .font(.custom("Inter", size: 12))
                                    .foregroundColor(.white)
                                    .frame(width: 70, alignment: .trailing)
                                
                                Text(formatCurrency(entry.youPaid))
                                    .font(.custom("Inter", size: 12))
                                    .foregroundColor(.white)
                                    .frame(width: 70, alignment: .trailing)
                                
                                Text(formatCurrency(entry.endingBalance))
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
            }
            .frame(height: 220)
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

// Accumulation View
struct AccumulationView: View {
    @ObservedObject private var financialModel = FinancialModel.shared
    @State private var showDetailedView = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Toggle for detailed view
            Toggle("Show Detailed View", isOn: $showDetailedView)
                .foregroundColor(.white)
                .padding(.horizontal, 15)
                .padding(.bottom, 5)
            
            // Table header
            if showDetailedView {
                HStack {
                    Text("Year")
                        .font(.custom("Inter", size: 10).weight(.medium))
                        .foregroundColor(.white.opacity(0.9))
                        .frame(width: 30, alignment: .leading)
                    
                    Text("Begin Bal")
                        .font(.custom("Inter", size: 10).weight(.medium))
                        .foregroundColor(.white.opacity(0.9))
                        .frame(width: 55, alignment: .trailing)
                    
                    Text("Rate")
                        .font(.custom("Inter", size: 10).weight(.medium))
                        .foregroundColor(.white.opacity(0.9))
                        .frame(width: 35, alignment: .center)
                    
                    Text("Credited")
                        .font(.custom("Inter", size: 10).weight(.medium))
                        .foregroundColor(.white.opacity(0.9))
                        .frame(width: 55, alignment: .trailing)
                    
                    Text("Deposits")
                        .font(.custom("Inter", size: 10).weight(.medium))
                        .foregroundColor(.white.opacity(0.9))
                        .frame(width: 55, alignment: .trailing)
                    
                    Text("Cash Value")
                        .font(.custom("Inter", size: 10).weight(.medium))
                        .foregroundColor(.white.opacity(0.9))
                        .frame(width: 60, alignment: .trailing)
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .background(Color.white.opacity(0.1))
                .cornerRadius(8)
            } else {
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
            }
            
            // Table rows
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(financialModel.accumulationGrowth) { entry in
                        if showDetailedView {
                            HStack {
                                Text(entry.id)
                                    .font(.custom("Inter", size: 10))
                                    .foregroundColor(.white)
                                    .frame(width: 30, alignment: .leading)
                                
                                Text(formatCurrency(entry.beginningCashValue))
                                    .font(.custom("Inter", size: 10))
                                    .foregroundColor(.white)
                                    .frame(width: 55, alignment: .trailing)
                                
                                Text("\(Int(entry.policyCredit * 100))%")
                                    .font(.custom("Inter", size: 10))
                                    .foregroundColor(.white)
                                    .frame(width: 35, alignment: .center)
                                
                                Text(formatCurrency(entry.amountCredited))
                                    .font(.custom("Inter", size: 10))
                                    .foregroundColor(.white)
                                    .frame(width: 55, alignment: .trailing)
                                
                                Text(formatCurrency(entry.customerDeposits + entry.vieDeposit))
                                    .font(.custom("Inter", size: 10))
                                    .foregroundColor(.white)
                                    .frame(width: 55, alignment: .trailing)
                                
                                Text(formatCurrency(entry.policyCashValue))
                                    .font(.custom("Inter", size: 10))
                                    .foregroundColor(.white)
                                    .frame(width: 60, alignment: .trailing)
                            }
                            .padding(.horizontal, 15)
                            .padding(.vertical, 12)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(8)
                        } else {
                            HStack {
                                Text(entry.id)
                                    .font(.custom("Inter", size: 12))
                                    .foregroundColor(.white)
                                    .frame(width: 40, alignment: .leading)
                                
                                Text("\(Int(entry.policyCredit * 100))%")
                                    .font(.custom("Inter", size: 12))
                                    .foregroundColor(.white)
                                    .frame(width: 40, alignment: .center)
                                
                                Text(formatCurrency(entry.customerDeposits + (entry.id == "YR00" ? entry.vieDeposit : 0)))
                                    .font(.custom("Inter", size: 12))
                                    .foregroundColor(.white)
                                    .frame(width: 70, alignment: .trailing)
                                
                                Text(formatCurrency(entry.policyCashValue))
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
            }
            .frame(height: 220)
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

// Customer Spending View
struct CustomerSpendingView: View {
    @ObservedObject private var financialModel = FinancialModel.shared
    @State private var showDetailedView = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Toggle for detailed view
            Toggle("Show Detailed View", isOn: $showDetailedView)
                .foregroundColor(.white)
                .padding(.horizontal, 15)
                .padding(.bottom, 5)
            
            // Table header
            if showDetailedView {
                HStack {
                    Text("Year")
                        .font(.custom("Inter", size: 10).weight(.medium))
                        .foregroundColor(.white.opacity(0.9))
                        .frame(width: 30, alignment: .leading)
                    
                    Text("Begin Bal")
                        .font(.custom("Inter", size: 10).weight(.medium))
                        .foregroundColor(.white.opacity(0.9))
                        .frame(width: 55, alignment: .trailing)
                    
                    Text("Spent")
                        .font(.custom("Inter", size: 10).weight(.medium))
                        .foregroundColor(.white.opacity(0.9))
                        .frame(width: 45, alignment: .trailing)
                    
                    Text("Interest")
                        .font(.custom("Inter", size: 10).weight(.medium))
                        .foregroundColor(.white.opacity(0.9))
                        .frame(width: 45, alignment: .trailing)
                    
                    Text("Payment")
                        .font(.custom("Inter", size: 10).weight(.medium))
                        .foregroundColor(.white.opacity(0.9))
                        .frame(width: 50, alignment: .trailing)
                    
                    Text("End Bal")
                        .font(.custom("Inter", size: 10).weight(.medium))
                        .foregroundColor(.white.opacity(0.9))
                        .frame(width: 55, alignment: .trailing)
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .background(Color.white.opacity(0.1))
                .cornerRadius(8)
            } else {
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
            }
            
            // Table rows
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(financialModel.customerSpending) { entry in
                        if showDetailedView {
                            HStack {
                                Text(entry.id)
                                    .font(.custom("Inter", size: 10))
                                    .foregroundColor(.white)
                                    .frame(width: 30, alignment: .leading)
                                
                                Text(formatCurrency(entry.beginningLoanBalance))
                                    .font(.custom("Inter", size: 10))
                                    .foregroundColor(.white)
                                    .frame(width: 55, alignment: .trailing)
                                
                                Text(formatCurrency(entry.spent))
                                    .font(.custom("Inter", size: 10))
                                    .foregroundColor(.white)
                                    .frame(width: 45, alignment: .trailing)
                                
                                Text(formatCurrency(entry.loanInterest))
                                    .font(.custom("Inter", size: 10))
                                    .foregroundColor(.white)
                                    .frame(width: 45, alignment: .trailing)
                                
                                Text(formatCurrency(entry.totalLoanPayment))
                                    .font(.custom("Inter", size: 10))
                                    .foregroundColor(.white)
                                    .frame(width: 50, alignment: .trailing)
                                
                                Text(formatCurrency(entry.endLoanBalance))
                                    .font(.custom("Inter", size: 10))
                                    .foregroundColor(.white)
                                    .frame(width: 55, alignment: .trailing)
                            }
                            .padding(.horizontal, 15)
                            .padding(.vertical, 12)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(8)
                        } else {
                            HStack {
                                Text(entry.id)
                                    .font(.custom("Inter", size: 12))
                                    .foregroundColor(.white)
                                    .frame(width: 40, alignment: .leading)
                                
                                Text(formatCurrency(entry.spent))
                                    .font(.custom("Inter", size: 12))
                                    .foregroundColor(.white)
                                    .frame(width: 70, alignment: .trailing)
                                
                                Text(formatCurrency(entry.loanInterest))
                                    .font(.custom("Inter", size: 12))
                                    .foregroundColor(.white)
                                    .frame(width: 70, alignment: .trailing)
                                
                                Text(formatCurrency(entry.endLoanBalance))
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
            }
            .frame(height: 220)
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
