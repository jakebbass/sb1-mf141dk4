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
    @Published var liftOffLoanSchedule: [LiftOffLoanEntry] = []
    @Published var accumulationGrowth: [AccumulationEntry] = []
    @Published var customerSpending: [CustomerSpendingEntry] = []
    @Published var assetValue: [AssetValueEntry] = []
    
    // Constants for calculations
    private let initialVieDeposit: Double = 48000.0
    private let liftOffLoanInterestRate: Double = 0.15 // 15%
    private let liftOffLoanTerm: Int = 20 // 20 years
    private let customerSpendingLoanRate: Double = 0.04 // 4%
    
    // Variable crediting rates based on Google Sheets schedule
    private let creditingRates: [String: Double] = [
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
        
        // Generate all projections
        runCalculations()
    }
    
    // Method to set the monthly deposit amount
    func setMonthlyDepositAmount(amount: Double) {
        self.monthlyDepositAmount = amount
        
        // Generate all projections
        runCalculations()
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
        
        // Update projection metrics if available
        if !accumulationGrowth.isEmpty {
            let latestProjection = accumulationGrowth.last!
            dashboardMetrics.projectedBalance = latestProjection.policyCashValue
            dashboardMetrics.totalYears = accumulationGrowth.count - 1 // Exclude YR00
            dashboardMetrics.annualGrowthRate = creditingRates["YR01"] ?? 0.12
            
            // Calculate total customer deposits
            let totalCustomerDeposits = accumulationGrowth.reduce(0) { $0 + $1.customerDeposits }
            dashboardMetrics.totalCustomerDeposits = totalCustomerDeposits
            
            // Calculate total growth
            dashboardMetrics.totalGrowth = latestProjection.policyCashValue - totalCustomerDeposits - initialVieDeposit
        }
    }
    
    // Method to calculate Lift-Off Loan Schedule
    private func calculateLiftOffLoanSchedule() {
        // Clear existing data
        liftOffLoanSchedule.removeAll()
        
        // Initial values
        let initialLoanAmount = monthlyDepositAmount * 24 // 2 years of monthly deposits
        
        // Calculate PMT (payment) for the loan
        func calculatePMT(rate: Double, nper: Int, pv: Double) -> Double {
            if pv <= 0 {
                return 0
            }
            let r = rate
            return pv * r * pow(1 + r, Double(nper)) / (pow(1 + r, Double(nper)) - 1)
        }
        
        // Add initial year (YR00)
        liftOffLoanSchedule.append(LiftOffLoanEntry(
            id: "YR00",
            startingBalance: 0,
            youPaid: 0,
            interest: 0,
            principal: 0,
            endingBalance: initialLoanAmount
        ))
        
        // Generate schedule for 25 years
        for i in 1...25 {
            let yearId = "YR\(String(format: "%02d", i))"
            let previousEntry = liftOffLoanSchedule.last!
            
            // Only calculate if there's a balance
            if previousEntry.endingBalance > 0.0001 {
                let startingBalance = previousEntry.endingBalance
                let payment = calculatePMT(rate: liftOffLoanInterestRate, nper: liftOffLoanTerm, pv: initialLoanAmount)
                let interestAmount = startingBalance * liftOffLoanInterestRate
                let principalAmount = payment - interestAmount
                let endingBalance = max(0, startingBalance - principalAmount)
                
                liftOffLoanSchedule.append(LiftOffLoanEntry(
                    id: yearId,
                    startingBalance: startingBalance,
                    youPaid: payment,
                    interest: interestAmount,
                    principal: principalAmount,
                    endingBalance: endingBalance
                ))
            } else {
                // No balance, just add zeros
                liftOffLoanSchedule.append(LiftOffLoanEntry(
                    id: yearId,
                    startingBalance: 0,
                    youPaid: 0,
                    interest: 0,
                    principal: 0,
                    endingBalance: 0
                ))
            }
        }
    }
    
    // Method to calculate Accumulation/Growth
    private func calculateAccumulationGrowth() {
        // Clear existing data
        accumulationGrowth.removeAll()
        
        // Add initial year (YR00)
        accumulationGrowth.append(AccumulationEntry(
            id: "YR00",
            beginningCashValue: 0,
            vieDeposits: liftOffLoanSchedule.first?.endingBalance ?? 0,
            customerDeposits: 0,
            policyCredit: 0,
            amountCredited: 0,
            policyCashValue: liftOffLoanSchedule.first?.endingBalance ?? 0,
            amountDepositedByCustomer: 0
        ))
        
        // Generate accumulation for 25 years
        for i in 1...25 {
            let yearId = "YR\(String(format: "%02d", i))"
            let previousEntry = accumulationGrowth.last!
            let annualDeposit = monthlyDepositAmount * 12
            let creditRate = creditingRates[yearId] ?? 0.08
            
            let beginningCashValue = previousEntry.policyCashValue
            let vieDeposits = 0.0 // Only initial deposit
            let customerDeposits = annualDeposit
            let amountCredited = beginningCashValue * creditRate
            let policyCashValue = beginningCashValue + vieDeposits + customerDeposits + amountCredited
            let amountDepositedByCustomer = customerDeposits + (accumulationGrowth.first?.amountDepositedByCustomer ?? 0)
            
            accumulationGrowth.append(AccumulationEntry(
                id: yearId,
                beginningCashValue: beginningCashValue,
                vieDeposits: vieDeposits,
                customerDeposits: customerDeposits,
                policyCredit: creditRate,
                amountCredited: amountCredited,
                policyCashValue: policyCashValue,
                amountDepositedByCustomer: amountDepositedByCustomer
            ))
        }
    }
    
    // Method to calculate Customer Spending
    private func calculateCustomerSpending() {
        // Clear existing data
        customerSpending.removeAll()
        
        // Add initial year (YR00)
        customerSpending.append(CustomerSpendingEntry(
            id: "YR00",
            beginningBalance: 0,
            spent: 0,
            loanRate: customerSpendingLoanRate,
            loanInterest: 0,
            endLoanBalance: 0
        ))
        
        // Generate customer spending for 25 years
        for i in 1...25 {
            let yearId = "YR\(String(format: "%02d", i))"
            let previousEntry = customerSpending.last!
            let annualSpending = monthlyDepositAmount * 12
            
            let beginningBalance = previousEntry.endLoanBalance
            let loanInterest = (beginningBalance + annualSpending) * customerSpendingLoanRate
            let endLoanBalance = beginningBalance + annualSpending + loanInterest
            
            customerSpending.append(CustomerSpendingEntry(
                id: yearId,
                beginningBalance: beginningBalance,
                spent: annualSpending,
                loanRate: customerSpendingLoanRate,
                loanInterest: loanInterest,
                endLoanBalance: endLoanBalance
            ))
        }
    }
    
    // Method to calculate Asset Value
    private func calculateAssetValue() {
        // Clear existing data
        assetValue.removeAll()
        
        // Ensure we have the necessary data
        if accumulationGrowth.isEmpty || customerSpending.isEmpty || liftOffLoanSchedule.isEmpty {
            return
        }
        
        // Add entries for each year
        for i in 0...25 {
            let yearId = "YR\(String(format: "%02d", i))"
            
            // Get corresponding entries from other tables
            guard i < accumulationGrowth.count && i < customerSpending.count && i < liftOffLoanSchedule.count else {
                continue
            }
            
            let accumulation = accumulationGrowth[i]
            let spending = customerSpending[i]
            let liftOffLoan = liftOffLoanSchedule[i]
            
            // Calculate asset value
            // Spreadsheet formula: =Accumulation[Policy Cash Value]-Customer_Spending[End Loan Balance]
            let assetValueAmount = accumulation.policyCashValue - spending.endLoanBalance
            
            // Calculate owed on lift-off loan
            var owedOnLiftOffLoan: Double
            if i == 0 {
                owedOnLiftOffLoan = 0
            } else {
                let previousAssetValue = assetValue.last!
                owedOnLiftOffLoan = previousAssetValue.owedOnLiftOffLoan - liftOffLoan.youPaid
            }
            
            // Calculate available for spending
            let availableForSpending = max(0, assetValueAmount - owedOnLiftOffLoan)
            
            assetValue.append(AssetValueEntry(
                id: yearId,
                assetValue: assetValueAmount,
                owedOnLiftOffLoan: owedOnLiftOffLoan,
                availableForManagedInvesting: assetValueAmount,
                availableForSpending: availableForSpending
            ))
        }
    }
    
    // Method to calculate Totals based on the spreadsheet's Totals tab
    func calculateTotals() -> [TotalsEntry] {
        var entries: [TotalsEntry] = []
        
        // Ensure we have the necessary data
        guard !accumulationGrowth.isEmpty && !customerSpending.isEmpty else {
            return entries
        }
        
        // For each year, calculate the cumulative deposits and expenses
        for i in 0..<accumulationGrowth.count {
            let yearId = "YR\(String(format: "%02d", i))"
            
            // Calculate cumulative deposits (SUMIF logic from spreadsheet)
            // =SUMIF(Accumulation[Id], "<=YRxx", Accumulation[Customer Deposits])
            var cumulativeDeposits = 0.0
            for j in 0...i {
                if j < accumulationGrowth.count {
                    cumulativeDeposits += accumulationGrowth[j].customerDeposits
                }
            }
            
            // Calculate cumulative expenses (SUMIF logic from spreadsheet)
            // =SUMIF(Customer_Spending[Id], "<=YRxx", Customer_Spending[Spent])
            var cumulativeExpenses = 0.0
            for j in 0...i {
                if j < customerSpending.count {
                    cumulativeExpenses += customerSpending[j].spent
                }
            }
            
            // Calculate net value (deposits - expenses)
            let netValue = cumulativeDeposits - cumulativeExpenses
            
            entries.append(TotalsEntry(
                id: yearId,
                deposits: cumulativeDeposits,
                expenses: cumulativeExpenses,
                netValue: netValue
            ))
        }
        
        return entries
    }
    
    // Method to generate growth projection (simplified version for dashboard)
    func generateGrowthProjection() {
        // Clear existing projection
        growthProjection.removeAll()
        
        // Use accumulation growth data if available
        if !accumulationGrowth.isEmpty {
            for entry in accumulationGrowth {
                growthProjection.append(YearlyProjection(
                    id: entry.id,
                    year: Int(entry.id.dropFirst(2)) ?? 0,
                    beginningCashValue: entry.policyCashValue,
                    vieDeposit: entry.vieDeposits,
                    customerDeposit: entry.customerDeposits
                ))
            }
        } else {
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
    
    // Method to run all calculations
    func runCalculations() {
        // Calculate Lift-Off Loan Schedule
        calculateLiftOffLoanSchedule()
        
        // Calculate Accumulation/Growth
        calculateAccumulationGrowth()
        
        // Calculate Customer Spending
        calculateCustomerSpending()
        
        // Calculate Asset Value
        calculateAssetValue()
        
        // Generate growth projection for dashboard
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

// Lift-Off Loan Schedule model
struct LiftOffLoanEntry: Identifiable {
    let id: String // YR01, YR02, etc.
    let startingBalance: Double
    let youPaid: Double
    let interest: Double
    let principal: Double
    let endingBalance: Double
}

// Accumulation/Growth model
struct AccumulationEntry: Identifiable {
    let id: String // YR01, YR02, etc.
    let beginningCashValue: Double
    let vieDeposits: Double
    let customerDeposits: Double
    let policyCredit: Double
    let amountCredited: Double
    let policyCashValue: Double
    let amountDepositedByCustomer: Double
}

// Customer Spending model
struct CustomerSpendingEntry: Identifiable {
    let id: String // YR01, YR02, etc.
    let beginningBalance: Double
    let spent: Double
    let loanRate: Double
    let loanInterest: Double
    let endLoanBalance: Double
}

// Asset Value model
struct AssetValueEntry: Identifiable {
    let id: String // YR01, YR02, etc.
    let assetValue: Double
    let owedOnLiftOffLoan: Double
    let availableForManagedInvesting: Double
    let availableForSpending: Double
}

// Totals model
struct TotalsEntry: Identifiable {
    let id: String // YR01, YR02, etc.
    let deposits: Double
    let expenses: Double
    let netValue: Double
}
