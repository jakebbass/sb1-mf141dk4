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
    
    // Additional model arrays for different projection views
    @Published var liftOffLoanSchedule: [LiftOffLoanEntry] = []
    @Published var accumulationGrowth: [AccumulationEntry] = []
    @Published var customerSpending: [CustomerSpendingEntry] = []
    @Published var assetValue: [AssetValueEntry] = []
    
    // Constants for calculations
    private let initialVieDeposit: Double = 48000.0
    private let annualGrowthRate: Double = 0.12 // 12% annual growth
    
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
        
        // Generate other projections
        generateLiftOffLoanSchedule()
        generateAccumulationGrowth()
        generateCustomerSpending()
        generateAssetValue()
    }
    
    // Method to set the monthly deposit amount
    func setMonthlyDepositAmount(amount: Double) {
        self.monthlyDepositAmount = amount
        
        // Generate growth projection
        generateGrowthProjection()
        
        // Generate other projections
        generateLiftOffLoanSchedule()
        generateAccumulationGrowth()
        generateCustomerSpending()
        generateAssetValue()
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
            // Calculate growth for the year
            let growth = currentBalance * annualGrowthRate
            
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
    
    // Method to generate lift-off loan schedule
    func generateLiftOffLoanSchedule() {
        // Clear existing schedule
        liftOffLoanSchedule.removeAll()
        
        // Initial values
        let loanAmount = 100000.0
        let interestRate = 0.05 // 5% interest rate
        let paymentAmount = 12000.0 // Annual payment
        
        var balance = loanAmount
        let currentYear = Calendar.current.component(.year, from: Date())
        
        // Add initial year (YR00)
        liftOffLoanSchedule.append(LiftOffLoanEntry(
            id: "YR00",
            year: currentYear,
            startingBalance: balance,
            youPaid: 0,
            endingBalance: balance
        ))
        
        // Generate schedule for 10 years
        for i in 1...10 {
            // Calculate interest for the year
            let interest = balance * interestRate
            
            // Add interest to balance
            balance += interest
            
            // Make payment
            let payment = min(paymentAmount, balance)
            balance -= payment
            
            // Add to schedule
            liftOffLoanSchedule.append(LiftOffLoanEntry(
                id: "YR\(String(format: "%02d", i))",
                year: currentYear + i,
                startingBalance: balance + payment,
                youPaid: payment,
                endingBalance: balance
            ))
        }
    }
    
    // Method to generate accumulation growth
    func generateAccumulationGrowth() {
        // Clear existing growth
        accumulationGrowth.removeAll()
        
        // Calculate annual deposit amount
        let annualDepositAmount = monthlyDepositAmount * 12
        
        // Initial values
        var cashValue = accountBalance
        let currentYear = Calendar.current.component(.year, from: Date())
        
        // Add initial year (YR00)
        accumulationGrowth.append(AccumulationEntry(
            id: "YR00",
            year: currentYear,
            policyCredit: 0.0,
            customerDeposits: depositAmount,
            policyCashValue: cashValue
        ))
        
        // Generate growth for 10 years
        for i in 1...10 {
            // Get crediting rate for this year
            let creditingRate = getCreditingRate(for: "YR\(String(format: "%02d", i))")
            
            // Calculate growth for the year
            let growth = cashValue * creditingRate
            
            // Add customer deposit
            cashValue += annualDepositAmount
            
            // Add growth
            cashValue += growth
            
            // Add to growth
            accumulationGrowth.append(AccumulationEntry(
                id: "YR\(String(format: "%02d", i))",
                year: currentYear + i,
                policyCredit: creditingRate,
                customerDeposits: annualDepositAmount,
                policyCashValue: cashValue
            ))
        }
    }
    
    // Method to generate customer spending
    func generateCustomerSpending() {
        // Clear existing spending
        customerSpending.removeAll()
        
        // Initial values
        let loanAmount = 0.0
        let interestRate = 0.05 // 5% interest rate
        let spendingAmount = 10000.0 // Annual spending
        
        var balance = loanAmount
        let currentYear = Calendar.current.component(.year, from: Date())
        
        // Add initial year (YR00)
        customerSpending.append(CustomerSpendingEntry(
            id: "YR00",
            year: currentYear,
            spent: 0,
            loanInterest: 0,
            endLoanBalance: balance
        ))
        
        // Generate spending for 10 years
        for i in 1...10 {
            // Calculate interest for the year
            let interest = balance * interestRate
            
            // Add interest to balance
            balance += interest
            
            // Add spending
            balance += spendingAmount
            
            // Add to spending
            customerSpending.append(CustomerSpendingEntry(
                id: "YR\(String(format: "%02d", i))",
                year: currentYear + i,
                spent: spendingAmount,
                loanInterest: interest,
                endLoanBalance: balance
            ))
        }
    }
    
    // Method to generate asset value
    func generateAssetValue() {
        // Clear existing asset value
        assetValue.removeAll()
        
        // Initial values
        var assetValue = accountBalance
        let availablePercentage = 0.8 // 80% available for spending
        let currentYear = Calendar.current.component(.year, from: Date())
        
        // Add initial year (YR00)
        self.assetValue.append(AssetValueEntry(
            id: "YR00",
            year: currentYear,
            assetValue: assetValue,
            availableForSpending: assetValue * availablePercentage
        ))
        
        // Generate asset value for 10 years
        for i in 1...10 {
            // Get crediting rate for this year
            let creditingRate = getCreditingRate(for: "YR\(String(format: "%02d", i))")
            
            // Calculate growth for the year
            let growth = assetValue * creditingRate
            
            // Add growth
            assetValue += growth
            
            // Add to asset value
            self.assetValue.append(AssetValueEntry(
                id: "YR\(String(format: "%02d", i))",
                year: currentYear + i,
                assetValue: assetValue,
                availableForSpending: assetValue * availablePercentage
            ))
        }
    }
    
    // Method to update dashboard metrics with projection data
    private func updateDashboardMetricsWithProjection() {
        if !growthProjection.isEmpty {
            // Get the latest projection
            let latestProjection = growthProjection.last!
            
            // Update dashboard metrics
            dashboardMetrics.projectedBalance = latestProjection.beginningCashValue
            dashboardMetrics.totalYears = growthProjection.count - 1 // Exclude YR00
            dashboardMetrics.annualGrowthRate = annualGrowthRate
            
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
        
        // Generate other projections
        generateLiftOffLoanSchedule()
        generateAccumulationGrowth()
        generateCustomerSpending()
        generateAssetValue()
        
        // Update dashboard metrics
        updateDashboardMetrics()
    }
    
    // Helper function to get the crediting rate for a specific year
    func getCreditingRate(for yearId: String) -> Double {
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

// Lift-Off Loan Entry model
struct LiftOffLoanEntry: Identifiable {
    let id: String // YR01, YR02, etc.
    let year: Int
    let startingBalance: Double
    let youPaid: Double
    let endingBalance: Double
}

// Accumulation Entry model
struct AccumulationEntry: Identifiable {
    let id: String // YR01, YR02, etc.
    let year: Int
    let policyCredit: Double
    let customerDeposits: Double
    let policyCashValue: Double
}

// Customer Spending Entry model
struct CustomerSpendingEntry: Identifiable {
    let id: String // YR01, YR02, etc.
    let year: Int
    let spent: Double
    let loanInterest: Double
    let endLoanBalance: Double
}

// Asset Value Entry model
struct AssetValueEntry: Identifiable {
    let id: String // YR01, YR02, etc.
    let year: Int
    let assetValue: Double
    let availableForSpending: Double
}
