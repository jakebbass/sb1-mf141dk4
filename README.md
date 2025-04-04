# Vie iOS App

This is an iOS app for financial management based on the Figma prototype. The app allows users to:

1. Set an initial deposit amount
2. View their account balance and financial metrics
3. Add transactions (deposits, withdrawals)
4. Connect to a spreadsheet for advanced calculations

## Project Structure

- `VieApp.swift`: Main app entry point
- `SplashScreen.swift`: Initial splash screen with the Vie logo
- `WelcomeScreen.swift`: Welcome screen with deposit input
- `DashboardScreen.swift`: Main dashboard with tabs (Home, Payments, Records, Account)
- `FinancialModel.swift`: Data model for financial information
- `Assets.xcassets/`: Image assets for the app

## Running the App

To run this app:

1. Open the project in Xcode
2. Build and run the project on an iOS simulator or device

## Financial Calculations

The app includes a built-in calculation engine that performs financial projections based on:

1. Initial deposit amount
2. Monthly deposit amount
3. Annual growth rate (currently set at 12%)

The calculation engine generates a 10-year projection showing:
- Yearly account balances
- Total growth
- Projected final balance

The app also supports connecting to a Google Sheets document for reference, but all calculations are performed locally within the app. This eliminates the need for external services like Supabase, as the app doesn't need to store data externally.

## Future Enhancements

1. Add data visualization with charts for financial growth
2. Implement user authentication
3. Add more transaction types and categories
4. Implement notifications for financial goals
5. Allow customization of growth rate and projection period

## Design

The app follows the design from the Figma prototype, featuring:

- A clean, modern interface with a green color scheme
- A tab-based navigation system
- Clear financial metrics and transaction history
- User-friendly input forms for financial data
