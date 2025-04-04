import SwiftUI

struct DashboardScreen: View {
    @State private var selectedTab = 0
    @ObservedObject private var financialModel = FinancialModel.shared
    
    // Define the app's colors
    let primaryColor = Color(red: 0, green: 0.5, blue: 0.4)
    let darkGreenColor = Color(red: 0, green: 0.3, blue: 0.25)
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 10) {
                // Logo
                VStack(spacing: 0) {
                    Text("vie")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
                    
                    // Green smile
                    Image("vectorsmi")
                        .resizable()
                        .frame(width: 40, height: 8)
                        .foregroundColor(.green)
                }
                .padding(.top, 20)
                
                Text("Your Capital Account Explained")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
            }
            .frame(maxWidth: .infinity)
            .background(primaryColor)
            
            // Main content area
            ZStack {
                darkGreenColor.edgesIgnoringSafeArea(.all)
                
                // Content based on selected tab
                VStack {
                    switch selectedTab {
                    case 0:
                        HomeTabView()
                    case 1:
                        PaymentsTabView()
                    case 2:
                        RecordsTabView()
                    case 3:
                        AccountTabView()
                    default:
                        HomeTabView()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Tab bar
            HStack(spacing: 0) {
                TabButton(
                    title: "Home",
                    systemImage: "house.fill",
                    isSelected: selectedTab == 0,
                    action: { selectedTab = 0 }
                )
                
                TabButton(
                    title: "Payments",
                    systemImage: "creditcard.fill",
                    isSelected: selectedTab == 1,
                    action: { selectedTab = 1 }
                )
                
                TabButton(
                    title: "Records",
                    systemImage: "doc.text.fill",
                    isSelected: selectedTab == 2,
                    action: { selectedTab = 2 }
                )
                
                TabButton(
                    title: "Account",
                    systemImage: "person.fill",
                    isSelected: selectedTab == 3,
                    action: { selectedTab = 3 }
                )
            }
            .frame(height: 60)
            .background(Color.white)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

// Tab button component
struct TabButton: View {
    let title: String
    let systemImage: String
    let isSelected: Bool
    let action: () -> Void
    
    // Define the app's primary color
    let primaryColor = Color(red: 0, green: 0.5, blue: 0.4)
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: systemImage)
                    .font(.system(size: 20))
                
                Text(title)
                    .font(.system(size: 12))
            }
            .foregroundColor(isSelected ? primaryColor : .gray)
            .frame(maxWidth: .infinity)
        }
    }
}

// Tab views with actual content
struct HomeTabView: View {
    @ObservedObject private var financialModel = FinancialModel.shared
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Account balance card
                VStack(alignment: .leading, spacing: 10) {
                    Text("Current Balance")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text("$\(financialModel.accountBalance, specifier: "%.2f")")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(red: 0, green: 0.4, blue: 0.35))
                .cornerRadius(10)
                
                // Dashboard metrics
                VStack(alignment: .leading, spacing: 15) {
                    Text("Account Summary")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Total Deposits")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("$\(financialModel.dashboardMetrics.totalDeposits, specifier: "%.2f")")
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text("Total Withdrawals")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("$\(financialModel.dashboardMetrics.totalWithdrawals, specifier: "%.2f")")
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                    }
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Interest Earned")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("$\(financialModel.dashboardMetrics.totalInterest, specifier: "%.2f")")
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text("Fees Paid")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("$\(financialModel.dashboardMetrics.totalFees, specifier: "%.2f")")
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding()
                .background(Color(red: 0, green: 0.4, blue: 0.35))
                .cornerRadius(10)
                
                // Growth projection
                VStack(alignment: .leading, spacing: 15) {
                    Text("Growth Projection")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Projected Balance (10 Years)")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("$\(financialModel.dashboardMetrics.projectedBalance, specifier: "%.2f")")
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text("Total Growth")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("$\(financialModel.dashboardMetrics.totalGrowth, specifier: "%.2f")")
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                    }
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Annual Growth Rate")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("\(financialModel.dashboardMetrics.annualGrowthRate * 100, specifier: "%.1f")%")
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text("Total Customer Deposits")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("$\(financialModel.dashboardMetrics.totalCustomerDeposits, specifier: "%.2f")")
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding()
                .background(Color(red: 0, green: 0.4, blue: 0.35))
                .cornerRadius(10)
                
                // Yearly projection table
                VStack(alignment: .leading, spacing: 15) {
                    Text("Yearly Projection")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.bottom, 5)
                    
                    // Table header
                    HStack {
                        Text("Year")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                            .frame(width: 60, alignment: .leading)
                        
                        Text("Balance")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    
                    // Table rows
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(financialModel.growthProjection) { projection in
                                HStack {
                                    Text(projection.id)
                                        .font(.system(size: 14))
                                        .foregroundColor(.white)
                                        .frame(width: 60, alignment: .leading)
                                    
                                    Text("$\(projection.beginningCashValue, specifier: "%.2f")")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color(red: 0, green: 0.45, blue: 0.4).opacity(0.3))
                                .cornerRadius(5)
                            }
                        }
                    }
                    .frame(height: 200)
                }
                .padding()
                .background(Color(red: 0, green: 0.4, blue: 0.35))
                .cornerRadius(10)
            }
            .padding()
        }
    }
}

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
        let prefix = transaction.type == .deposit || transaction.type == .interest ? "+" : "-"
        return "\(prefix)$\(transaction.amount, specifier: "%.2f")"
    }
}

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
                    
                    HStack {
                        Text("Account Balance:")
                            .foregroundColor(.white.opacity(0.8))
                        Spacer()
                        Text("$\(financialModel.accountBalance, specifier: "%.2f")")
                            .foregroundColor(.white)
                    }
                    
                    HStack {
                        Text("Initial Deposit:")
                            .foregroundColor(.white.opacity(0.8))
                        Spacer()
                        Text("$\(financialModel.depositAmount, specifier: "%.2f")")
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
                .background(Color(red: 0, green: 0.4, blue: 0.35))
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

struct DashboardScreen_Previews: PreviewProvider {
    static var previews: some View {
        DashboardScreen()
    }
}
