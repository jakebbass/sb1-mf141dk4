import Foundation
import Combine

class FinancialModel: ObservableObject {
    // Published properties will automatically notify observers of changes
    @Published var depositAmount: Double = 0.0
    @Published var monthlyDepositAmount: Double = 0.0
    @Published var accountBalance: Double = 0.0
    @Published var transactions: [Transaction] = []
    @Published var dashboardMetrics: DashboardMetrics = DashboardMetrics()
    @Published var growthProjection: [YearlyProjection] = []
    
    // Constants for calculations
    private let initialVieDeposit: Double = 48000.0
    
    // Variable crediting rates based on Google Sheets schedule
    private let creditingRates: [String: Double] = [
        "YR00": 0.0,
        "YR01": 0.12, // 12%
        "YR02": 0.08, // 8%
        "YR03": 0.04, // 4%
        "YR04": 0.0,  // 0%
        "YR05": 0.08, // 8%
        "YR06": 0.08, // 8%
        "YR07": 0.08, // 8%
        "YR08": 0.08, // 8%
        "YR09": 0.08, // 8%
        "YR10": 0.08  // 8%
    ]
    
    // Singleton instance for easy access throughout the app
    static let shared = FinancialModel()
    
    private init() {
        // Initialize with sample data
        self.accountBalance = 0.0
    }
    
    // Method to set the initial deposit
    func setInitialDeposit(amount: Double) {
        self.depositAmount = amount
        self.accountBalance = amount + initialVieDeposit
        
        // Add the deposit as a transaction
        let transaction = Transaction(
            id: UUID().uuidString,
            date: Date(),
            description: "Initial Deposit",
            amount: amount,
            type: .deposit
        )
        
        // Add the Vie deposit as a transaction
        let vieTransaction = Transaction(
            id: UUID().uuidString,
            date: Date(),
            description: "Vie Initial Deposit",
            amount: initialVieDeposit,
            type: .deposit
        )
        
        self.transactions.append(transaction)
        self.transactions.append(vieTransaction)
        
        // Update dashboard metrics
        updateDashboardMetrics()
        
        // Generate growth projection
        generateGrowthProjection()
    }
    
    // Method to set the monthly deposit amount
    func setMonthlyDepositAmount(amount: Double) {
        self.monthlyDepositAmount = amount
        
        // Generate growth projection
        generateGrowthProjection()
    }
    
    // Method to add a new transaction
    func addTransaction(description: String, amount: Double, type: TransactionType) {
        let transaction = Transaction(
            id: UUID().uuidString,
            date: Date(),
            description: description,
            amount: amount,
            type: type
        )
        
        self.transactions.append(transaction)
        
        // Update account balance
        switch type {
        case .deposit:
            self.accountBalance += amount
        case .withdrawal:
            self.accountBalance -= amount
        case .interest:
            self.accountBalance += amount
        case .fee:
            self.accountBalance -= amount
        }
        
        // Update dashboard metrics
        updateDashboardMetrics()
    }
    
    // Method to update dashboard metrics
    private func updateDashboardMetrics() {
        // Calculate total deposits
        let totalDeposits = transactions
            .filter { $0.type == .deposit }
            .reduce(0) { $0 + $1.amount }
        
        // Calculate total withdrawals
        let totalWithdrawals = transactions
            .filter { $0.type == .withdrawal }
            .reduce(0) { $0 + $1.amount }
        
        // Calculate total interest
        let totalInterest = transactions
            .filter { $0.type == .interest }
            .reduce(0) { $0 + $1.amount }
        
        // Calculate total fees
        let totalFees = transactions
            .filter { $0.type == .fee }
            .reduce(0) { $0 + $1.amount }
        
        // Update dashboard metrics
        dashboardMetrics = DashboardMetrics(
            totalDeposits: totalDeposits,
            totalWithdrawals: totalWithdrawals,
            totalInterest: totalInterest,
            totalFees: totalFees,
            currentBalance: accountBalance
        )
    }
    
    // Method to generate growth projection
    func generateGrowthProjection() {
        // Clear existing projection
        growthProjection.removeAll()
        
        // Calculate annual deposit amount
        let annualDepositAmount = monthlyDepositAmount * 12
        
        // Initial values
        var currentBalance = accountBalance
        let currentYear = Calendar.current.component(.year, from: Date())
        
        // Add initial year (YR00)
        growthProjection.append(YearlyProjection(
            id: "YR00",
            year: currentYear,
            beginningCashValue: currentBalance,
            vieDeposit: initialVieDeposit,
            customerDeposit: depositAmount
        ))
        
        // Generate projection for 10 years
        for i in 1...10 {
            // Get the crediting rate for the current year
            let yearKey = "YR\(String(format: "%02d", i))"
            let creditingRate = creditingRates[yearKey] ?? 0.08 // Default to 8% if not found
            
            // Calculate growth for the year
            let growth = currentBalance * creditingRate
            
            // Add customer deposit
            currentBalance += annualDepositAmount
            
            // Add growth
            currentBalance += growth
            
            // Add to projection
            growthProjection.append(YearlyProjection(
                id: "YR\(String(format: "%02d", i))",
                year: currentYear + i,
                beginningCashValue: currentBalance,
                vieDeposit: 0, // Only initial deposit
                customerDeposit: annualDepositAmount
            ))
        }
        
        // Update dashboard metrics with projection data
        updateDashboardMetricsWithProjection()
    }
    
    // Method to update dashboard metrics with projection data
    private func updateDashboardMetricsWithProjection() {
        if !growthProjection.isEmpty {
            // Get the latest projection
            let latestProjection = growthProjection.last!
            
            // Update dashboard metrics
            dashboardMetrics.projectedBalance = latestProjection.beginningCashValue
            dashboardMetrics.totalYears = growthProjection.count - 1 // Exclude YR00
            // Use the first year's crediting rate for display
            dashboardMetrics.annualGrowthRate = creditingRates["YR01"] ?? 0.12
            
            // Calculate total customer deposits
            let totalCustomerDeposits = growthProjection.reduce(0) { $0 + $1.customerDeposit }
            dashboardMetrics.totalCustomerDeposits = totalCustomerDeposits
            
            // Calculate total growth
            dashboardMetrics.totalGrowth = latestProjection.beginningCashValue - totalCustomerDeposits - initialVieDeposit
        }
    }
    
    // Method to connect to a spreadsheet (now implemented locally)
    func connectToSpreadsheet(url: String) {
        // Parse the Google Sheets URL to extract the spreadsheet ID
        if let spreadsheetId = extractSpreadsheetId(from: url) {
            print("Using spreadsheet ID: \(spreadsheetId) for local calculations")
            
            // Run calculations
            runCalculations()
        } else {
            print("Invalid Google Sheets URL")
        }
    }
    
    // Method to extract spreadsheet ID from Google Sheets URL
    private func extractSpreadsheetId(from url: String) -> String? {
        // Example URL: https://docs.google.com/spreadsheets/d/19fGZzSkW8HVPenz27QAcM-YNDyCdytaK_nxKN0a_VHc/edit
        let pattern = "spreadsheets/d/([a-zA-Z0-9-_]+)"
        
        if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
            let nsString = url as NSString
            let matches = regex.matches(in: url, options: [], range: NSRange(location: 0, length: nsString.length))
            
            if let match = matches.first {
                let range = match.range(at: 1)
                return nsString.substring(with: range)
            }
        }
        
        return nil
    }
    
    // Method to run calculations (now implemented locally)
    func runCalculations() {
        // Generate growth projection
        generateGrowthProjection()
        
        // Update dashboard metrics
        updateDashboardMetrics()
    }
}

// Transaction model
struct Transaction: Identifiable {
    let id: String
    let date: Date
    let description: String
    let amount: Double
    let type: TransactionType
}

// Transaction type enum
enum TransactionType {
    case deposit
    case withdrawal
    case interest
    case fee
}

// Dashboard metrics model
struct DashboardMetrics {
    var totalDeposits: Double = 0.0
    var totalWithdrawals: Double = 0.0
    var totalInterest: Double = 0.0
    var totalFees: Double = 0.0
    var currentBalance: Double = 0.0
    
    // Projection metrics
    var projectedBalance: Double = 0.0
    var totalCustomerDeposits: Double = 0.0
    var totalGrowth: Double = 0.0
    var totalYears: Int = 0
    var annualGrowthRate: Double = 0.0
}

// Yearly projection model
struct YearlyProjection: Identifiable {
    let id: String // YR01, YR02, etc.
    let year: Int
    let beginningCashValue: Double
    let vieDeposit: Double
    let customerDeposit: Double
}
