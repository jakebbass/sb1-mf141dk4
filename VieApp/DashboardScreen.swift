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
                // Radial gradient background instead of PNG
                RadialGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "00956A"),
                        Color(hex: "006246"),
                        Color(hex: "003929"),
                        Color(hex: "006246"),
                        Color(hex: "00100B")
                    ]),
                    center: .center,
                    startRadius: 5,
                    endRadius: 500
                )
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
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity, alignment: .top)
            
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

// Extension to create Color from hex string
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct DashboardScreen_Previews: PreviewProvider {
    static var previews: some View {
        DashboardScreen()
    }
}
