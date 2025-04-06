import SwiftUI

// Records Tab View
struct RecordsTabView: View {
    @ObservedObject private var financialModel = FinancialModel.shared
    
    var body: some View {
        VStack {
            // All transactions
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    Text("All Transactions")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.top, 20)
                    
                    ForEach(financialModel.transactions) { transaction in
                        TransactionRow(transaction: transaction)
                    }
                    
                    if financialModel.transactions.isEmpty {
                        Text("No transactions yet")
                            .foregroundColor(.white.opacity(0.7))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    }
                }
                .padding(.vertical)
            }
        }
    }
}

// Account Tab View
struct AccountTabView: View {
    @ObservedObject private var financialModel = FinancialModel.shared
    @State private var spreadsheetURL = ""
    @State private var showingConnectSheet = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Account info
                VStack(alignment: .leading, spacing: 15) {
                    Text("Account Information")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    
                    HStack {
                        Text("Account Balance:")
                            .foregroundColor(.white.opacity(0.8))
                        Spacer()
                        Text("$" + String(format: "%.2f", financialModel.accountBalance))
                            .foregroundColor(.white)
                    }
                    
                    HStack {
                        Text("Initial Deposit:")
                            .foregroundColor(.white.opacity(0.8))
                        Spacer()
                        Text("$" + String(format: "%.2f", financialModel.depositAmount))
                            .foregroundColor(.white)
                    }
                    
                    HStack {
                        Text("Total Transactions:")
                            .foregroundColor(.white.opacity(0.8))
                        Spacer()
                        Text("\(financialModel.transactions.count)")
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.05))
                .cornerRadius(10)
                
                // Connect to spreadsheet button
                Button(action: {
                    showingConnectSheet = true
                }) {
                    Text("Connect to Spreadsheet")
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
            .padding()
        }
        .sheet(isPresented: $showingConnectSheet) {
            // Connect to spreadsheet sheet
            VStack(spacing: 20) {
                Text("Connect to Spreadsheet")
                    .font(.title)
                    .bold()
                
                TextField("Spreadsheet URL", text: $spreadsheetURL)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                
                HStack {
                    Button("Cancel") {
                        showingConnectSheet = false
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    
                    Button("Connect") {
                        if !spreadsheetURL.isEmpty {
                            financialModel.connectToSpreadsheet(url: spreadsheetURL)
                            financialModel.runCalculations()
                            spreadsheetURL = ""
                            showingConnectSheet = false
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

// Complete the TransactionRow view
extension TransactionRow {
    func formattedAmount(_ transaction: Transaction) -> String {
        let prefix = transaction.type == .deposit || transaction.type == .interest ? "+" : "-"
        return "\(prefix)$" + String(format: "%.2f", transaction.amount)
    }
}
