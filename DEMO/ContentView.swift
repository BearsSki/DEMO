import SwiftUI
import AVKit
import Combine

// Color extension
extension Color {
    static let appBackground = Color(red: 17 / 255, green: 26 / 255, blue: 37 / 255)
}

// Main ContentView with Tab Bar
struct ContentView: View {
    @State private var selectedTab = 1

    var body: some View {
        ZStack {
            Color.appBackground.edgesIgnoringSafeArea(.all)

            // Switching Views Based on Selected Tab
            switch selectedTab {
            case 0:
                VenueView()
            case 1:
                MyPassesView()
            case 2:
                FeedView()
            case 3:
                AccountView()
            default:
                EmptyView()
            }

            // Custom Tab Bar
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .preferredColorScheme(.dark)
    }
}

// Custom Tab Bar
struct CustomTabBar: View {
    @Binding var selectedTab: Int

    var body: some View {
        VStack(spacing: 0) { // Ensure there is no space between the divider and the tabs
            Divider()
                .background(Color.white)
                .cornerRadius(15)
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
                .edgesIgnoringSafeArea(.bottom) // This should allow the tab bar to be on top
            
            HStack {
                TabBarButton(iconName: "Venues", tabName: "Venues", selectedTab: $selectedTab, tag: 0)
                TabBarButton(iconName: "MyPasses", tabName: "My Passes", selectedTab: $selectedTab, tag: 1)
                TabBarButton(iconName: "Feed", tabName: "Feed", selectedTab: $selectedTab, tag: 2)
                TabBarButton(iconName: "Account", tabName: "Account", selectedTab: $selectedTab, tag: 3)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.appBackground) // Use the custom background color
            .cornerRadius(15)
            // You can remove the shadow if you want a clean look similar to the image provided
            //.shadow(radius: 10)
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

// TabBarButton Component
struct TabBarButton: View {
    var iconName: String
    var tabName: String
    @Binding var selectedTab: Int
    var tag: Int

    var body: some View {
        Button(action: {
            self.selectedTab = tag
        }) {
            VStack(spacing: 0) { // Reduced or remove spacing
                Image(iconName) // Using the custom image by its name
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30) // Adjust size as needed
                    .foregroundColor(selectedTab == tag ? .white : .gray)

                Text(tabName)
                    .font(.caption)
                    .foregroundColor(selectedTab == tag ? .white : .gray)
                    .padding(.top, 2) // You can adjust this padding to bring the text closer or further away
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// FullWidthButtonStyle
struct BartenderButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding() // Add padding around the label
            .font(.system(size: 14)) // Adjust the size to your liking
            .fontWeight(.bold)
            .frame(maxWidth: .infinity) // Ensure the button stretches to full width
            .frame(height: 80) // Set a fixed height for the button
            .background(configuration.isPressed ? .gray : Color(red: 56 / 255, green: 68 / 255, blue: 92 / 255)) // Set the background color to white
            .foregroundColor(Color.white) // Set the text color to the RGB values provided
            .cornerRadius(10) // Apply rounded corners
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke((Color.white), lineWidth: 0.8) // Apply a blue border with the RGB values provided
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0) // Scale effect on press
            .animation(.easeOut, value: configuration.isPressed)
            .padding(.horizontal) // Add padding on the sides if you want to reduce the button width
    }
}

struct RedeemButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.system(size: 14)) // Adjust the size to your liking
            .fontWeight(.bold)
            .frame(maxWidth: .infinity)
            .frame(height: 80) // Set a fixed height for the button
           // .padding(.vertical, 35) // Increase the top and bottom padding by 1.25 times
            .background(configuration.isPressed ? Color.blue.opacity(0.5) : Color.blue) // Use the exact blue color if you have the RGB values
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeOut, value: configuration.isPressed)
    }
}

struct MyPassesView: View {
    @State private var showingRedemptionView = false
    @State private var redemptionInstructionsView = false
    @State private var selectedTab = 0
 

    var body: some View {
        ZStack {
            Color.appBackground.edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                // Title
                HStack {
                    Text("My Passes")
                        .font(.system(size: 19))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.leading, 16)
                    Spacer()
                }
                .padding(.top, 30)
                
                Spacer(minLength: 10) // Space between title and cards

                // Pass Cards
                TabView(selection: $selectedTab) {
                    ForEach(0..<2, id: \.self) { index in
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 0) {
                                ZStack {
                                    // Card Background
                                    let image = index == 0 ? Image("Green") : Image("Pink")
                                    let logoImage = index == 0 ? Image("LLGreen") : Image("Pink")

                                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                                        .frame(height: 180)
                                        .foregroundColor(.clear) // Makes the RoundedRectangle transparent, so the image can show through
                                        .background(
                                            image
                                                .resizable() // Make the image resizable
                                                .aspectRatio(contentMode: .fill) // Fill the frame of the RoundedRectangle, may crop the image
                                        )
                                        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous)) // Clip the image with the same rounded rectangle shape
                                        .shadow(radius: 10)

                                    // Card Content
                                    VStack(alignment: .leading, spacing: 0) {
                                        Text("Kollege Klub Dinkytown")
                                            .font(.system(size: 24))
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)

                                        Text(index == 0 ? "Friday Pass (8am-2am) Qty: 1" : "Leap Pass                             Qty: 1")
                                            .font(.system(size: 23))
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .padding(.vertical, 4)

                                        Spacer()

                                        HStack {
                                            VStack(alignment: .leading) {
                                                Text("Passholder")
                                                    .fontWeight(.medium)
                                                    .foregroundColor(.white.opacity(0.7))
                                                    .font(.system(size: 11))
                                                Text(index == 0 ? "Bodie Brice" : "Bodie Brice") // This should be dynamic based on actual passholder data.
                                                    .fontWeight(.medium)
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 15))
                                            }
                                            Spacer()
                                            VStack(alignment: .trailing) {
                                                Text("Expires at                                     ")
                                                    .fontWeight(.medium)
                                                    .foregroundColor(.white.opacity(0.7))
                                                    .font(.system(size: 11))
                                                Text(index == 0 ? "May 22, 2:00 AM             " : "May 22, 2:00 AM             ") // This should be dynamic based on actual expiration data.
                                                    .fontWeight(.medium)
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 15))
                                            }
                                        }
                                    }
                                    
                                    .padding()

                                    // Logo Overlay (adjusted)
                                    logoImage
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30) // Adjust the size as needed
                                        .position(x: UIScreen.main.bounds.width - 60, y: 150) // Adjust the position as needed
                                }
                                .padding(.horizontal)
                            }
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always)) // Set to always to show the dots
                
                // Instructions and Buttons
                VStack(spacing: 10) {
                    Divider()
                        .background(Color.white)
                        .padding(.horizontal, -20)
                    
                    HStack {
                        Text("Show bartender pass to redeem.\nOnly bartender should redeem.")
                            .bold()
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                            .padding(.leading)
                        Spacer()
                    }

                    Button("I am the bartender or venue staff") {
                        showingRedemptionView = true
                    }
                    .buttonStyle(BartenderButtonStyle())

                    Button("How to redeem this pass") {
                        redemptionInstructionsView = true
                    }
                    .buttonStyle(RedeemButtonStyle())
                }
                .padding(.bottom, 70)
            }
        }
        .sheet(isPresented: $showingRedemptionView) {
            RedemptionView()
        }
        
        .sheet(isPresented: $redemptionInstructionsView) {
            RedemptionInstructionsView()
        }
        
        .preferredColorScheme(.dark)
    }
}

struct VenueView: View {
    var body: some View {
        Image("VenuesView") // Replace "AccountView" with the actual name of your image file
            .resizable()
            .scaledToFit()
            .edgesIgnoringSafeArea(.all) // If you want the image to fill the entire view
    }
}

struct AccountView: View {
    var body: some View {
        Image("AccountView") // Replace "AccountView" with the actual name of your image file
            .resizable()
            .scaledToFit()
            .edgesIgnoringSafeArea(.all) // If you want the image to fill the entire view
    }
}

struct FeedView: View {
    var body: some View {
        Image("FeedView") // Replace "FeedView" with the actual name of your image file
            .resizable()
            .scaledToFit()
            .edgesIgnoringSafeArea(.all) // If you want the image to fill the entire view
    }
}
struct RedemptionInstructionsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showingVideoPlayer = false

    var body: some View {
        VStack {
            Text("How to Redeem")
                .font(.largeTitle)
                .fontWeight(.bold)
                .italic()
                .foregroundColor(.orange)
                .padding(.top, 40)
                .frame(maxWidth: .infinity)
                .background(Image("RedeemTop")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .edgesIgnoringSafeArea(.all))
            
            Image("How_to_Redeem")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .clipped()
            
            Spacer().frame(height: 20) // Control the space above the Stop text
                        
            Spacer().frame(height: 0) // Control the space above the Redeem Pass button
           
            Button("Got it") {
                presentationMode.wrappedValue.dismiss()
            }
            .buttonStyle(RedeemButtonStyle())
            .padding(.horizontal)
            
            Spacer() // Adjust the spacer at the bottom as needed
        }
        .background(Image("RedeemPass")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all))
    }
}

struct RedemptionView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showingVideoPlayer = false

    var body: some View {
        VStack {
            Text("Redeem Pass?")
                .font(.largeTitle)
                .fontWeight(.bold)
                .italic()
                .foregroundColor(.orange)
                .padding(.top, 40)
                .frame(maxWidth: .infinity)
                .background(Image("RedeemTop")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .edgesIgnoringSafeArea(.all))
            
            Image("RedeemImage")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .clipped()
            
            Spacer().frame(height: 20) // Control the space above the Stop text
            
            Text("Stop!\nOnly redeem if you are bartender!")
                .fontWeight(.bold)
                .font(.system(size: 20))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.vertical, 10) // Reduced vertical padding to move the text up
                .frame(maxWidth: .infinity)
                .background(Image("RedeemPass")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .edgesIgnoringSafeArea(.all))
                .cornerRadius(10)
            
            Spacer().frame(height: 0) // Control the space above the Redeem Pass button
            
            Button(action: {
                print("Redeem Pass button was tapped")
                showingVideoPlayer = true
            }) {
                Text("Redeem Pass")
                    .fontWeight(.bold)
                    .font(.system(size: 21))
                    .foregroundColor(.black)
                    .padding()
                    .frame(height: 78)
                    .frame(maxWidth: .infinity)
                    .background(Image("Redeem")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .edgesIgnoringSafeArea(.all))
                    .cornerRadius(10)
            }
            .fullScreenCover(isPresented: $showingVideoPlayer) {
                VideoPlayerView()
            }
            .padding(.horizontal)
            
            Spacer().frame(height: 10) // Control the space above the Cancel button
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Cancel")
                    .fontWeight(.bold)
                    .font(.system(size: 22))
                    .foregroundColor(.white)
                    .padding()
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Image("RedeemPass")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .edgesIgnoringSafeArea(.all))
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Spacer() // Adjust the spacer at the bottom as needed
        }
        .background(Image("RedeemPass")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all))
    }
}

struct VideoPlayerView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var currentImageIndex = 0
    @State private var timerSubscription: AnyCancellable?
    let images: [String]

    init() {
        var tempImages = [String]()
        for i in 1243...1308 {
            tempImages.append("IMG_\(i)")
        }
        self.images = tempImages
    }

    var body: some View {
        VStack {
                Spacer()
            if !images.isEmpty {
                Image(images[currentImageIndex])
                    .resizable()
                    .scaledToFit()
                    .onAppear {
                        timerSubscription = Timer.publish(every: 3.0 / Double(images.count), on: .main, in: .common).autoconnect().sink { _ in
                            currentImageIndex = (currentImageIndex + 1) % images.count
                        }
                    }
                    .onDisappear {
                        timerSubscription?.cancel()
                    }
            }
            Spacer()
        }
        .background(Image("BackgroundImage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

    

