import SwiftUI

struct DashboardScreen: View {
    @State private var selectedTab = 0
    @State private var tabChangeAnimation = false
    @ObservedObject private var financialModel = FinancialModel.shared
    
    // Define the app's colors
    let primaryColor = Color(red: 0, green: 0.5, blue: 0.4)
    let secondaryColor = Color(red: 0, green: 0.6, blue: 0.5)
    let darkGreenColor = Color(red: 0, green: 0.3, blue: 0.25)
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            ZStack {
                Image("header")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 140)
                
                // Using only the header image without custom logo
                VStack {
                    Text("Your Capital Account")
                        .font(.custom("Inter", size: 22).weight(.bold))
                        .foregroundColor(.white)
                        .padding(.top, 40)
                    
                    Text("Explained")
                        .font(.custom("Inter", size: 18).weight(.medium))
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.top, 2)
                }
                .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 140)
            
            // Main content area
            ZStack {
                Image("dashboard-background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                
                // Content based on selected tab with transition
                ZStack {
                    switch selectedTab {
                    case 0:
                        HomeTabView()
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                            .id("home-\(tabChangeAnimation)")
                    case 1:
                        PaymentsTabView()
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                            .id("payments-\(tabChangeAnimation)")
                    case 2:
                        RecordsTabView()
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                            .id("records-\(tabChangeAnimation)")
                    case 3:
                        AccountTabView()
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                            .id("account-\(tabChangeAnimation)")
                    default:
                        HomeTabView()
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                            .id("default-\(tabChangeAnimation)")
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: tabChangeAnimation)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Tab bar with glass effect
            HStack(spacing: 0) {
                TabButton(
                    title: "Home",
                    iconName: "huge-icon-interface-outline-home-04",
                    isSelected: selectedTab == 0,
                    action: { 
                        withAnimation {
                            selectedTab = 0
                            tabChangeAnimation.toggle()
                        }
                    }
                )
                
                TabButton(
                    title: "Payments",
                    iconName: "huge-icon-interface-outline-money",
                    isSelected: selectedTab == 1,
                    action: { 
                        withAnimation {
                            selectedTab = 1
                            tabChangeAnimation.toggle()
                        }
                    }
                )
                
                TabButton(
                    title: "Records",
                    iconName: "huge-icon-interface-outline-collection",
                    isSelected: selectedTab == 2,
                    action: { 
                        withAnimation {
                            selectedTab = 2
                            tabChangeAnimation.toggle()
                        }
                    }
                )
                
                TabButton(
                    title: "Account",
                    iconName: "huge-icon-interface-outline-user",
                    isSelected: selectedTab == 3,
                    action: { 
                        withAnimation {
                            selectedTab = 3
                            tabChangeAnimation.toggle()
                        }
                    }
                )
            }
            .frame(height: 70)
            .background(
                ZStack {
                    Color.white
                    
                    // Subtle gradient overlay
                    LinearGradient(
                        gradient: Gradient(colors: [Color.white.opacity(0.9), Color.white]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
            )
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: -4)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

// Tab button component with improved visuals
struct TabButton: View {
    let title: String
    let iconName: String
    let isSelected: Bool
    let action: () -> Void
    
    // Define the app's colors
    let primaryColor = Color(red: 0, green: 0.5, blue: 0.4)
    let secondaryColor = Color(red: 0, green: 0.6, blue: 0.5)
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(iconName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 26, height: 26)
                    .foregroundColor(isSelected ? primaryColor : .gray.opacity(0.6))
                
                Text(title)
                    .font(.custom("Inter", size: 12).weight(isSelected ? .medium : .regular))
                    .foregroundColor(isSelected ? primaryColor : .gray.opacity(0.6))
            }
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .background(
                ZStack {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(primaryColor.opacity(0.1))
                            .frame(width: 70, height: 50)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
            )
        }
        .buttonStyle(TabButtonStyle())
    }
}

// Custom button style for tab buttons
struct TabButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// Tab views with improved content
struct HomeTabView: View {
    @ObservedObject private var financialModel = FinancialModel.shared
    @State private var animateCards = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Account balance card
                VStack(alignment: .leading, spacing: 10) {
                    Text("Current Balance")
                        .font(.custom("Inter", size: 16).weight(.semibold))
                        .foregroundColor(.white)
                    
                    Text("$\(financialModel.accountBalance, specifier: "%.2f")")
                        .font(.custom("Inter", size: 36).weight(.bold))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0, green: 0.45, blue: 0.4),
                            Color(red: 0, green: 0.35, blue: 0.3)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
                .offset(y: animateCards ? 0 : 20)
                .opacity(animateCards ? 1 : 0)
                .animation(Animation.spring(response: 0.5, dampingFraction: 0.8).delay(0.1), value: animateCards)
                
                // Dashboard metrics
                VStack(alignment: .leading, spacing: 15) {
                    Text("Account Summary")
                        .font(.custom("Inter", size: 16).weight(.semibold))
                        .foregroundColor(.white)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Total Deposits")
                                .font(.custom("Inter", size: 14))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("$\(financialModel.dashboardMetrics.totalDeposits, specifier: "%.2f")")
                                .font(.custom("Inter", size: 18).weight(.medium))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text("Total Withdrawals")
                                .font(.custom("Inter", size: 14))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("$\(financialModel.dashboardMetrics.totalWithdrawals, specifier: "%.2f")")
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
                            
                            Text("$\(financialModel.dashboardMetrics.totalInterest, specifier: "%.2f")")
                                .font(.custom("Inter", size: 18).weight(.medium))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text("Fees Paid")
                                .font(.custom("Inter", size: 14))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("$\(financialModel.dashboardMetrics.totalFees, specifier: "%.2f")")
                                .font(.custom("Inter", size: 18).weight(.medium))
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(20)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0, green: 0.4, blue: 0.35),
                            Color(red: 0, green: 0.3, blue: 0.25)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
                .offset(y: animateCards ? 0 : 20)
                .opacity(animateCards ? 1 : 0)
                .animation(Animation.spring(response: 0.5, dampingFraction: 0.8).delay(0.2), value: animateCards)
                
                // Growth projection
                VStack(alignment: .leading, spacing: 15) {
                    Text("Growth Projection")
                        .font(.custom("Inter", size: 16).weight(.semibold))
                        .foregroundColor(.white)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Projected Balance (10 Years)")
                                .font(.custom("Inter", size: 14))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("$\(financialModel.dashboardMetrics.projectedBalance, specifier: "%.2f")")
                                .font(.custom("Inter", size: 18).weight(.medium))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text("Total Growth")
                                .font(.custom("Inter", size: 14))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("$\(financialModel.dashboardMetrics.totalGrowth, specifier: "%.2f")")
                                .font(.custom("Inter", size: 18).weight(.medium))
                                .foregroundColor(.white)
                        }
                    }
                    
                    Divider()
                        .background(Color.white.opacity(0.2))
                        .padding(.vertical, 8)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Annual Growth Rate")
                                .font(.custom("Inter", size: 14))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("\(financialModel.dashboardMetrics.annualGrowthRate * 100, specifier: "%.1f")%")
                                .font(.custom("Inter", size: 18).weight(.medium))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text("Total Customer Deposits")
                                .font(.custom("Inter", size: 14))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("$\(financialModel.dashboardMetrics.totalCustomerDeposits, specifier: "%.2f")")
                                .font(.custom("Inter", size: 18).weight(.medium))
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(20)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0, green: 0.4, blue: 0.35),
                            Color(red: 0, green: 0.3, blue: 0.25)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
                .offset(y: animateCards ? 0 : 20)
                .opacity(animateCards ? 1 : 0)
                .animation(Animation.spring(response: 0.5, dampingFraction: 0.8).delay(0.3), value: animateCards)
                
                // Yearly projection table
                VStack(alignment: .leading, spacing: 15) {
                    Text("Yearly Projection")
                        .font(.custom("Inter", size: 16).weight(.semibold))
                        .foregroundColor(.white)
                        .padding(.bottom, 5)
                    
                    // Table header
                    HStack {
                        Text("Year")
                            .font(.custom("Inter", size: 14).weight(.medium))
                            .foregroundColor(.white.opacity(0.9))
                            .frame(width: 60, alignment: .leading)
                        
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
                                    
                                    Text("$\(projection.beginningCashValue, specifier: "%.2f")")
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
                .padding(20)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0, green: 0.4, blue: 0.35),
                            Color(red: 0, green: 0.3, blue: 0.25)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
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
