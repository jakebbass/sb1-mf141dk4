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
    @Published var totalsEntries: [TotalsEntry] = []
    
    // Constants for calculations
    private let liftOffLoanInterestRate: Double = 0.15 // 15% annual interest for Lift-Off Loan
    private let liftOffLoanTerm: Int = 20 // 20-year term for Lift-Off Loan
    private let policyLoanInterestRate: Double = 0.03 // 3% annual interest for policy loans
    private let financeChargeRate: Double = 0.02 // 2% finance charge
    private let spendableGrowthThreshold: Double = 1000.0 // $1,000 threshold for spendable growth
    private let spendableGrowthLTV: Double = 0.25 // 25% LTV for spendable growth
    
    // Singleton instance for easy access throughout the app
    static let shared = FinancialModel()
    
    private init() {
        // Initialize with sample data
        self.accountBalance = 0.0
    }
    
    // Method to set the initial deposit
    func setInitialDeposit(amount: Double) {
        self.depositAmount = amount
        
        // Calculate initial Vie deposit based on monthly deposit
        let initialVieDeposit = monthlyDepositAmount * 24
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
        
        // Generate projections
        runCalculations()
    }
    
    // Method to set the monthly deposit amount
    func setMonthlyDepositAmount(amount: Double) {
        self.monthlyDepositAmount = amount
        
        // Run all calculations
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
    }
    
    // Method to generate growth projection
    func generateGrowthProjection() {
        // Clear existing projection
        growthProjection.removeAll()
        
        // Calculate annual deposit amount
        let annualDepositAmount = monthlyDepositAmount * 12
        
        // Initial values
        let initialVieDeposit = monthlyDepositAmount * 24
        var currentBalance = depositAmount + initialVieDeposit
        let currentYear = Calendar.current.component(.year, from: Date())
        
        // Add initial year (YR00)
        growthProjection.append(YearlyProjection(
            id: "YR00",
            year: currentYear,
            beginningCashValue: currentBalance,
            vieDeposit: initialVieDeposit,
            customerDeposit: depositAmount
        ))
        
        // Generate projection for 25 years
        for i in 1...25 {
            // Get crediting rate for this year
            let creditingRate = getCreditingRate(for: "YR\(String(format: "%02d", i))")
            
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
                customerDeposit: annualDepositAmount,
                creditingRate: creditingRate
            ))
        }
        
        // Update dashboard metrics with projection data
        updateDashboardMetricsWithProjection()
    }
    
    // Method to generate lift-off loan schedule
    func generateLiftOffLoanSchedule() {
        // Clear existing schedule
        liftOffLoanSchedule.removeAll()
        
        // Initial loan balance (YR00) = Planned Monthly Deposit * 2 * 12
        let initialLoanBalance = monthlyDepositAmount * 2 * 12
        
        // Calculate annual loan payment using PMT formula
        let annualLoanPayment = calculatePMT(rate: liftOffLoanInterestRate, nper: liftOffLoanTerm, pv: initialLoanBalance)
        
        let currentYear = Calendar.current.component(.year, from: Date())
        
        // Add initial year (YR00)
        liftOffLoanSchedule.append(LiftOffLoanEntry(
            id: "YR00",
            year: currentYear,
            startingBalance: initialLoanBalance,
            interestPayment: 0,
            principalPayment: 0,
            youPaid: 0,
            financeCharge: 0,
            endingBalance: initialLoanBalance
        ))
        
        // Generate schedule for 20 years (loan term)
        var balance = initialLoanBalance
        
        for i in 1...liftOffLoanTerm {
            // Calculate interest for the year
            let interestPayment = balance * liftOffLoanInterestRate
            
            // Calculate principal payment
            let principalPayment = annualLoanPayment - interestPayment
            
            // Calculate finance charge (2% of beginning balance)
            let financeCharge = balance * financeChargeRate
            
            // Update balance
            balance -= principalPayment
            
            // Add to schedule
            liftOffLoanSchedule.append(LiftOffLoanEntry(
                id: "YR\(String(format: "%02d", i))",
                year: currentYear + i,
                startingBalance: balance + principalPayment,
                interestPayment: interestPayment,
                principalPayment: principalPayment,
                youPaid: annualLoanPayment,
                financeCharge: financeCharge,
                endingBalance: balance
            ))
        }
        
        // Add remaining years up to 25 if needed
        if liftOffLoanTerm < 25 {
            for i in (liftOffLoanTerm + 1)...25 {
                liftOffLoanSchedule.append(LiftOffLoanEntry(
                    id: "YR\(String(format: "%02d", i))",
                    year: currentYear + i,
                    startingBalance: 0,
                    interestPayment: 0,
                    principalPayment: 0,
                    youPaid: 0,
                    financeCharge: 0,
                    endingBalance: 0
                ))
            }
        }
    }
    
    // Method to generate accumulation growth
    func generateAccumulationGrowth() {
        // Clear existing growth
        accumulationGrowth.removeAll()
        
        // Calculate annual deposit amount
        let annualDepositAmount = monthlyDepositAmount * 12
        
        // Initial values
        let initialVieDeposit = monthlyDepositAmount * 24
        var beginningCashValue = depositAmount + initialVieDeposit
        let currentYear = Calendar.current.component(.year, from: Date())
        
        // Add initial year (YR00)
        accumulationGrowth.append(AccumulationEntry(
            id: "YR00",
            year: currentYear,
            beginningCashValue: beginningCashValue,
            policyCredit: 0.0,
            amountCredited: 0.0,
            customerDeposits: depositAmount,
            vieDeposit: initialVieDeposit,
            policyCashValue: beginningCashValue
        ))
        
        // Generate growth for 25 years
        for i in 1...25 {
            // Get crediting rate for this year
            let creditingRate = getCreditingRate(for: "YR\(String(format: "%02d", i))")
            
            // Calculate amount credited (policy credit)
            let amountCredited = beginningCashValue * creditingRate
            
            // Add customer deposit
            let totalDeposited = annualDepositAmount
            
            // Calculate new policy cash value
            let newPolicyCashValue = beginningCashValue + amountCredited + totalDeposited
            
            // Add to growth
            accumulationGrowth.append(AccumulationEntry(
                id: "YR\(String(format: "%02d", i))",
                year: currentYear + i,
                beginningCashValue: beginningCashValue,
                policyCredit: creditingRate,
                amountCredited: amountCredited,
                customerDeposits: annualDepositAmount,
                vieDeposit: 0, // Only initial deposit
                policyCashValue: newPolicyCashValue
            ))
            
            // Update beginning cash value for next year
            beginningCashValue = newPolicyCashValue
        }
    }
    
    // Method to generate customer spending
    func generateCustomerSpending() {
        // Clear existing spending
        customerSpending.removeAll()
        
        // Calculate annual spending amount (equal to annualized monthly deposit)
        let annualSpendingAmount = monthlyDepositAmount * 12
        
        // Initial values
        var beginningLoanBalance = 0.0
        let currentYear = Calendar.current.component(.year, from: Date())
        
        // Add initial year (YR00)
        customerSpending.append(CustomerSpendingEntry(
            id: "YR00",
            year: currentYear,
            beginningLoanBalance: beginningLoanBalance,
            spent: 0,
            loanInterest: 0,
            liftOffLoanPayment: 0,
            financeCharge: 0,
            totalLoanPayment: 0,
            endLoanBalance: beginningLoanBalance
        ))
        
        // Generate spending for 25 years
        for i in 1...25 {
            // Calculate interest on loan
            let loanInterest = beginningLoanBalance * policyLoanInterestRate
            
            // Get lift-off loan payment for this year
            let liftOffLoanPayment = i <= liftOffLoanSchedule.count ? liftOffLoanSchedule[i].youPaid : 0
            
            // Get finance charge for this year
            let financeCharge = i <= liftOffLoanSchedule.count ? liftOffLoanSchedule[i].financeCharge : 0
            
            // Calculate total loan payment
            let totalLoanPayment = liftOffLoanPayment + financeCharge
            
            // Calculate end loan balance
            let endLoanBalance = beginningLoanBalance + loanInterest + annualSpendingAmount - totalLoanPayment
            
            // Add to spending
            customerSpending.append(CustomerSpendingEntry(
                id: "YR\(String(format: "%02d", i))",
                year: currentYear + i,
                beginningLoanBalance: beginningLoanBalance,
                spent: annualSpendingAmount,
                loanInterest: loanInterest,
                liftOffLoanPayment: liftOffLoanPayment,
                financeCharge: financeCharge,
                totalLoanPayment: totalLoanPayment,
                endLoanBalance: endLoanBalance
            ))
            
            // Update beginning loan balance for next year
            beginningLoanBalance = endLoanBalance
        }
    }
    
    // Method to generate asset value
    func generateAssetValue() {
        // Clear existing asset value
        assetValue.removeAll()
        
        let currentYear = Calendar.current.component(.year, from: Date())
        
        // Generate asset value for 25 years
        for i in 0...25 {
            let yearId = "YR\(String(format: "%02d", i))"
            
            // Get policy value from accumulation growth
            let policyValue = i < accumulationGrowth.count ? accumulationGrowth[i].policyCashValue : 0
            
            // Get outstanding loans from customer spending
            let outstandingLoans = i < customerSpending.count ? customerSpending[i].endLoanBalance : 0
            
            // Calculate asset value
            let calculatedAssetValue = policyValue - outstandingLoans
            
            // Get owed on lift-off loan
            let owedOnLiftOffLoan = i < liftOffLoanSchedule.count ? liftOffLoanSchedule[i].endingBalance : 0
            
            // Calculate available for spending (growth)
            var availableForSpending = 0.0
            if calculatedAssetValue - owedOnLiftOffLoan > spendableGrowthThreshold {
                availableForSpending = spendableGrowthLTV * (calculatedAssetValue - owedOnLiftOffLoan - spendableGrowthThreshold)
            }
            
            // Add to asset value
            self.assetValue.append(AssetValueEntry(
                id: yearId,
                year: currentYear + i,
                policyValue: policyValue,
                outstandingLoans: outstandingLoans,
                assetValue: calculatedAssetValue,
                owedOnLiftOffLoan: owedOnLiftOffLoan,
                availableForSpending: availableForSpending
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
            
            // Use the first year's crediting rate as the annual growth rate
            if growthProjection.count > 1 {
                dashboardMetrics.annualGrowthRate = growthProjection[1].creditingRate
            }
            
            // Calculate total customer deposits
            let totalCustomerDeposits = growthProjection.reduce(0) { $0 + $1.customerDeposit }
            dashboardMetrics.totalCustomerDeposits = totalCustomerDeposits
            
            // Calculate initial Vie deposit
            let initialVieDeposit = monthlyDepositAmount * 24
            
            // Calculate total growth
            dashboardMetrics.totalGrowth = latestProjection.beginningCashValue - totalCustomerDeposits - initialVieDeposit
        }
    }
    
    // Method to calculate totals
    func calculateTotals() -> [TotalsEntry] {
        // Clear existing totals
        totalsEntries.removeAll()
        
        let currentYear = Calendar.current.component(.year, from: Date())
        
        // Generate totals for 25 years
        for i in 0...25 {
            let yearId = "YR\(String(format: "%02d", i))"
            
            // Get customer deposits from accumulation growth
            let deposits = i < accumulationGrowth.count ? 
                (i == 0 ? accumulationGrowth[i].customerDeposits + accumulationGrowth[i].vieDeposit : accumulationGrowth[i].customerDeposits) : 0
            
            // Get expenses (loan payments) from customer spending
            let expenses = i < customerSpending.count ? customerSpending[i].totalLoanPayment : 0
            
            // Get asset value
            let netValue = i < assetValue.count ? assetValue[i].assetValue : 0
            
            // Add to totals
            totalsEntries.append(TotalsEntry(
                id: yearId,
                year: currentYear + i,
                deposits: deposits,
                expenses: expenses,
                netValue: netValue
            ))
        }
        
        return totalsEntries
    }
    
    // Method to run all calculations
    func runCalculations() {
        // Generate growth projection
        generateGrowthProjection()
        
        // Generate lift-off loan schedule
        generateLiftOffLoanSchedule()
        
        // Generate accumulation growth
        generateAccumulationGrowth()
        
        // Generate customer spending
        generateCustomerSpending()
        
        // Generate asset value
        generateAssetValue()
        
        // Calculate totals
        calculateTotals()
        
        // Update dashboard metrics
        updateDashboardMetrics()
        updateDashboardMetricsWithProjection()
    }
    
    // Helper function to calculate PMT (payment for a loan)
    private func calculatePMT(rate: Double, nper: Int, pv: Double) -> Double {
        // PMT formula: PMT = (PV * r * (1 + r)^n) / ((1 + r)^n - 1)
        let r = rate
        let n = Double(nper)
        
        let numerator = pv * r * pow(1 + r, n)
        let denominator = pow(1 + r, n) - 1
        
        return numerator / denominator
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
    var creditingRate: Double = 0.0
}

// Lift-Off Loan Entry model
struct LiftOffLoanEntry: Identifiable {
    let id: String // YR01, YR02, etc.
    let year: Int
    let startingBalance: Double
    let interestPayment: Double
    let principalPayment: Double
    let youPaid: Double
    let financeCharge: Double
    let endingBalance: Double
}

// Accumulation Entry model
struct AccumulationEntry: Identifiable {
    let id: String // YR01, YR02, etc.
    let year: Int
    let beginningCashValue: Double
    let policyCredit: Double
    let amountCredited: Double
    let customerDeposits: Double
    let vieDeposit: Double
    let policyCashValue: Double
}

// Customer Spending Entry model
struct CustomerSpendingEntry: Identifiable {
    let id: String // YR01, YR02, etc.
    let year: Int
    let beginningLoanBalance: Double
    let spent: Double
    let loanInterest: Double
    let liftOffLoanPayment: Double
    let financeCharge: Double
    let totalLoanPayment: Double
    let endLoanBalance: Double
}

// Asset Value Entry model
struct AssetValueEntry: Identifiable {
    let id: String // YR01, YR02, etc.
    let year: Int
    let policyValue: Double
    let outstandingLoans: Double
    let assetValue: Double
    let owedOnLiftOffLoan: Double
    let availableForSpending: Double
}

// Totals Entry model
struct TotalsEntry: Identifiable {
    let id: String // YR01, YR02, etc.
    let year: Int
    let deposits: Double
    let expenses: Double
    let netValue: Double
}
