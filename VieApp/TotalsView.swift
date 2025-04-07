import SwiftUI

// Totals View - Displays data from the Totals tab of the spreadsheet
struct TotalsView: View {
    @ObservedObject private var financialModel = FinancialModel.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Table header
            HStack {
                Text("Year")
                    .font(.custom("Inter", size: 12).weight(.medium))
                    .foregroundColor(.white.opacity(0.9))
                    .frame(width: 40, alignment: .leading)
                
                Text("Deposits")
                    .font(.custom("Inter", size: 12).weight(.medium))
                    .foregroundColor(.white.opacity(0.9))
                    .frame(width: 80, alignment: .trailing)
                
                Text("Expenses")
                    .font(.custom("Inter", size: 12).weight(.medium))
                    .foregroundColor(.white.opacity(0.9))
                    .frame(width: 80, alignment: .trailing)
                
                Text("Net Value")
                    .font(.custom("Inter", size: 12).weight(.medium))
                    .foregroundColor(.white.opacity(0.9))
                    .frame(width: 80, alignment: .trailing)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(Color.white.opacity(0.1))
            .cornerRadius(8)
            
            // Table rows
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(calculateTotals()) { entry in
                        HStack {
                            Text(entry.id)
                                .font(.custom("Inter", size: 12))
                                .foregroundColor(.white)
                                .frame(width: 40, alignment: .leading)
                            
                            Text(formatCurrency(entry.deposits))
                                .font(.custom("Inter", size: 12))
                                .foregroundColor(.white)
                                .frame(width: 80, alignment: .trailing)
                            
                            Text(formatCurrency(entry.expenses))
                                .font(.custom("Inter", size: 12))
                                .foregroundColor(.white)
                                .frame(width: 80, alignment: .trailing)
                            
                            Text(formatCurrency(entry.netValue))
                                .font(.custom("Inter", size: 12))
                                .foregroundColor(.white)
                                .frame(width: 80, alignment: .trailing)
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
    
    // Get totals from the financial model
    private func calculateTotals() -> [TotalsEntry] {
        return financialModel.calculateTotals()
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

// Note: TotalsEntry model is now defined in FinancialModel.swift
