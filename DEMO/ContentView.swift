import SwiftUI
import AVKit
import Combine

extension Color {
    static let appBackground = Color(red: 17 / 255, green: 26 / 255, blue: 37 / 255)
}

// Main ContentView with Tab Bar
struct ContentView: View {
    @State private var selectedTab = 1
    @StateObject private var viewModel = AccountViewModel()

    var body: some View {
        ZStack {
            Color.appBackground.edgesIgnoringSafeArea(.all)

            // Content based on the selected tab
            VStack {
                Spacer() // Pushes the content to the bottom
                switch selectedTab {
                case 0:
                    VenueView()
                case 1:
                    MyPassesView(viewModel: viewModel)
                case 2:
                    FeedView()
                case 3:
                    AccountView() // This view should now have access to the viewModel through the environment
                default:
                    EmptyView()
                }
            }
            
            // This should be within the outer ZStack to overlay on top of the content views.
            VStack {
                Spacer() // This Spacer pushes the tab bar to the bottom
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .environmentObject(viewModel) // Injecting the viewModel into the environment
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
    @ObservedObject var viewModel: AccountViewModel
    
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
                                    let logoImage = index == 0 ? Image("LLGreen") : Image("LLPink")
                                    //what pass
                                    let pass = index == 0 ? (viewModel.leapPass) : (viewModel.drinkPass)

                                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                                        .frame(height: 180)
                                        .foregroundColor(.clear)
                                        .background(
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                        )
                                        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                                        .shadow(radius: 10)

                                    // Card Content
                                    VStack(alignment: .leading, spacing: 0) {
                                        Text(viewModel.venueName)
                                            .font(.system(size: 24))
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)

                                        // Replace the placeholder text below with your actual pass details
                                        Text(pass)
                                            .font(.system(size: 23))
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .padding(.vertical, 4)

                                        Spacer()

                                        // Replace placeholder texts with actual dynamic data
                                        HStack {
                                            VStack(alignment: .leading) {
                                                Text("Passholder")
                                                    .fontWeight(.medium)
                                                    .foregroundColor(.white.opacity(0.7))
                                                    .font(.system(size: 11))
                                                Text(viewModel.passHolderName)
                                                    .fontWeight(.medium)
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 15))
                                            }

                                            Spacer()

                                            // Change alignment to leading for the VStack that contains "Expires at"
                                            VStack(alignment: .leading) {
                                                Text("Expires at")
                                                    .fontWeight(.medium)
                                                    .foregroundColor(.white.opacity(0.7))
                                                    .font(.system(size: 11))
                                                Text(viewModel.expirationDate)
                                                    .fontWeight(.medium)
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 15))
                                            }
                                        }
                                        
                                        .padding(.leading, 5)
                                        .padding(.trailing, 30)
                                    }
                                    .padding()

                                    // Logo Overlay (adjusted)
                                    logoImage
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)
                                        .position(x: UIScreen.main.bounds.width - 60, y: 150)
                                }
                                .padding(.horizontal)
                            }
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                
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
class AccountViewModel: ObservableObject {
    @Published var venueName: String
    @Published var leapPass: String
    @Published var drinkPass: String
    @Published var passHolderName: String
    @Published var expirationDate: String

    init() {
        // Load saved data or use default values
        self.venueName = UserDefaults.standard.string(forKey: "venueName") ?? "Kollege Klub Dinkytown"
        self.leapPass = UserDefaults.standard.string(forKey: "leapPass") ?? "Tuesday Pass (8pm-2am) Qty: 1"
        self.drinkPass = UserDefaults.standard.string(forKey: "drinkPass") ?? "Drink Pass (8pm-2am) Qty: 1"
        self.passHolderName = UserDefaults.standard.string(forKey: "passHolderName") ?? "Sean Smythe"
        self.expirationDate = UserDefaults.standard.string(forKey: "expirationDate") ?? "April 9, 2:00 AM"
    }

    func saveChanges() {
        UserDefaults.standard.set(venueName, forKey: "venueName")
        UserDefaults.standard.set(leapPass, forKey: "leapPass")
        UserDefaults.standard.set(drinkPass, forKey: "drinkPass")
        UserDefaults.standard.set(passHolderName, forKey: "passHolderName")
        UserDefaults.standard.set(expirationDate, forKey: "expirationDate")
    }
}

struct AccountView: View {
    @EnvironmentObject var viewModel: AccountViewModel
    @State private var showEditFields = false

    var body: some View {
        ZStack {
            Image("AccountView") // Your existing content, e.g., a static image
                .resizable()
                .scaledToFit()
                .edgesIgnoringSafeArea(.all)
            
            Color.clear
                .contentShape(Rectangle())
                .gesture(
                    TapGesture(count: 2)
                        .onEnded { _ in
                            withAnimation {
                                self.showEditFields.toggle()
                            }
                        }
                )
            
            if showEditFields {
                EditableView(viewModel: viewModel)
                    .transition(.move(edge: .bottom))
            }
        }
    }
}

struct EditableView: View {
    @ObservedObject var viewModel: AccountViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            TextField("Venue Name", text: $viewModel.venueName)
            TextField("leap Pass text", text: $viewModel.leapPass)
            TextField("leap Pass text", text: $viewModel.drinkPass)
            TextField("Pass Holder Name", text: $viewModel.passHolderName)
            TextField("Expiration Date", text: $viewModel.expirationDate)

            Button("Save Changes", action: viewModel.saveChanges)
        }
        .padding()
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .background(Color(UIColor.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 10)
        .padding()
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView().environmentObject(AccountViewModel())
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
