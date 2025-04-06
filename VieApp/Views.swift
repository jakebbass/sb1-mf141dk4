import SwiftUI

// This file imports and re-exports all the views used in the app
// to make them available to other files without having to import each one individually

// Re-export HomeTabView
@_exported import struct VieApp.HomeTabView

// Re-export TabViews
@_exported import struct VieApp.PaymentsTabView
@_exported import struct VieApp.RecordsTabView
@_exported import struct VieApp.AccountTabView
@_exported import struct VieApp.TransactionRow

// Re-export ProjectionViews
@_exported import struct VieApp.YearlyProjectionView
@_exported import struct VieApp.LiftOffLoanView
@_exported import struct VieApp.AccumulationView
@_exported import struct VieApp.CustomerSpendingView

// Re-export AssetValueView
@_exported import struct VieApp.AssetValueView
