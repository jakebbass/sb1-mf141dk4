import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            WelcomeScreen()
        } else {
            ZStack {
                // Background image
                Image("splashscreen")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                
                // Logo overlay
                VStack {
                    Text("vie")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(.white)
                    
                    // Green smile
                    Image("vectorsmi")
                        .resizable()
                        .frame(width: 100, height: 20)
                        .foregroundColor(.green)
                }
            }
            .onAppear {
                // Automatically transition to welcome screen after 2 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
