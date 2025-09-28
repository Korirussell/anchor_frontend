//
//  ContentView.swift
//  Anchor
//
//  Created by Kori Russell on 9/26/25.
//

import SwiftUI
import AVFoundation

// MARK: - Ocean Storm Inspired Color Palette
extension Color {
    // Ocean/storm theme - deep blues, sea greens, storm grays
    static let oceanDeep = Color(red: 0.05, green: 0.15, blue: 0.35) // #0D2659 - Deep ocean blue
    static let oceanBlue = Color(red: 0.10, green: 0.30, blue: 0.55) // #1A4D8C - Ocean blue
    static let seaGreen = Color(red: 0.15, green: 0.45, blue: 0.50) // #267380 - Ghibli sea green
    static let stormGray = Color(red: 0.25, green: 0.30, blue: 0.35) // #404859 - Storm cloud gray
    static let seafoam = Color(red: 0.70, green: 0.85, blue: 0.80) // #B3D9CC - Light seafoam
    static let anchorSilver = Color(red: 0.85, green: 0.88, blue: 0.90) // #D9E0E6 - Anchor silver
    static let deepCurrent = Color(red: 0.02, green: 0.08, blue: 0.20) // #051433 - Deep current (almost black)
}

struct ContentView: View {
    @StateObject private var crisisManager = CrisisManager()
    @State private var showingVoiceSelection = false
    @State private var showingMenu = false
    @State private var showingARShowcase = false
    @State private var showBreathingOrb = false  // Don't show breathing orb at start
    
    var body: some View {
        ZStack {
            // Ocean storm gradient background
            LinearGradient(
                colors: [.deepCurrent, .oceanDeep, .oceanBlue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Clean header with minimal menu
                HStack {
                    Spacer()
                    Button(action: {
                        showingMenu = true
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .font(.title2)
                            .foregroundColor(.anchorSilver)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                Spacer()
                
                // Main content - Forest app style
                VStack(spacing: 15) {
                // App icon/title - Forest style
                VStack(spacing: 5) {
                        ZStack {
                            // Background glow for visibility
                            // Custom anchor with glow effect
                            CustomAnchorIcon()
                                .frame(width: 64, height: 64)
                                .opacity(0.3)
                                .blur(radius: 8)

                            // Main anchor icon with better contrast
                            CustomAnchorIcon()
                                .frame(width: 60, height: 60)
                                .shadow(color: .seaGreen, radius: 4, x: 0, y: 2)
                        }
                        
                        Text("Anchor")
                            .font(.system(size: 32, weight: .light))
                            .foregroundColor(.oceanDeep)
                    }
                    
                    // Heart rate - clean card design
                    VStack(spacing: 12) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 40))
                            .foregroundColor(crisisManager.isCrisisMode ? Color(red: 0.9, green: 0.3, blue: 0.3) : .seaGreen)
                            .scaleEffect(crisisManager.isCrisisMode ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: crisisManager.isCrisisMode)
                        
                        Text("\(crisisManager.currentHeartRate)")
                            .font(.system(size: 36, weight: .light))
                            .foregroundColor(.anchorSilver)
                        
                        Text("BPM")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.seafoam)
                    }
                    .padding(.vertical, 30)
                    .padding(.horizontal, 40)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.seaGreen.opacity(0.3), lineWidth: 1)
                            )
                            .shadow(color: Color.oceanDeep.opacity(0.3), radius: 15, x: 0, y: 8)
                    )
                    
                    // Action buttons
                    VStack(spacing: 16) {
                        // Breathing orb button
                        Button(action: {
                            showBreathingOrb = true
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "circle.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(.white.opacity(0.9))
                                Text("Ocean Breathing")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white.opacity(0.9))
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 24)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.seaGreen.opacity(0.4), lineWidth: 1)
                                    )
                            )
                        }
                        
                        // Main crisis button
                        Button(action: {
                            crisisManager.initiateCrisisProtocol()
                        }) {
                            Text(crisisManager.isCrisisMode ? "Storm Active" : "Drop Anchor")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                                .padding(.vertical, 16)
                                .padding(.horizontal, 40)
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(crisisManager.isCrisisMode ? 
                                            LinearGradient(
                                                colors: [Color.stormGray, Color.stormGray],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            ) : 
                                            LinearGradient(
                                                colors: [Color.seaGreen, Color.oceanBlue],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .shadow(color: Color.seaGreen.opacity(0.4), radius: 8, x: 0, y: 4)
                                )
                        }
                        .disabled(crisisManager.isCrisisMode)
                    }
                }
                
                Spacer()
                
                // Status indicator - minimal
                if crisisManager.isCrisisMode {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 8, height: 8)
                        Text("Anchor deployed - riding the storm")
                            .font(.system(size: 14))
                            .foregroundColor(.seafoam)
                    }
                    .padding(.bottom, 30)
                }
            }
        }
        .fullScreenCover(isPresented: $crisisManager.showCamera) {
            CameraViewWithOverlay(crisisManager: crisisManager)
        }
        .fullScreenCover(isPresented: $showBreathingOrb) {
            ZStack {
                // Ocean breathing orb as main interface
                // ARKitBreathingAnchor DISABLED to prevent freeze
                // ARKitBreathingAnchor { sceneView in
                //     // Bridge ARSCNView to the 3D ping manager for advanced overlays
                //     crisisManager.ar3DPingManager.setSceneView(sceneView)
                // }
                
                // Simple black background instead of ARKit
                Color.black.ignoresSafeArea()
                
                // Overlay controls
                VStack {
                    HStack {
                        Spacer()
                        .padding()
                    }
                    
                    Spacer()
                    
                    // Main action button overlay
                    Button(action: {
                        showBreathingOrb = false
                        crisisManager.initiateCrisisProtocol()
                    }) {
                        Text("Drop Anchor")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.vertical, 16)
                            .padding(.horizontal, 32)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(LinearGradient(
                                        colors: [.seaGreen, .oceanBlue],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ))
                                    .shadow(color: .seaGreen.opacity(0.4), radius: 12, x: 0, y: 6)
                            )
                    }
                    .padding(.bottom, 100)
                }
            }
        }
        .sheet(isPresented: $showingVoiceSelection) {
            VoiceSelectionView(crisisManager: crisisManager)
        }
        .sheet(isPresented: $showingMenu) {
            MenuView(crisisManager: crisisManager, showingVoiceSelection: $showingVoiceSelection, showingARShowcase: $showingARShowcase)
        }
        .sheet(isPresented: $showingARShowcase) {
            ARGraphicsShowcase()
        }
        .sheet(isPresented: $crisisManager.showingBreathingAnchor) {
            // ARKitBreathingAnchor DISABLED to prevent video freeze
            // ARKitBreathingAnchor { sceneView in
            //     // Bridge ARSCNView to the 3D ping manager for advanced overlays
            //     crisisManager.ar3DPingManager.setSceneView(sceneView)
            // }
            
            // Simple breathing view instead of ARKit
            ZStack {
                Color.black.ignoresSafeArea()
                Text("Breathing Exercise\n(ARKit Disabled)")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

// MARK: - Menu View - Forest Style
struct MenuView: View {
    let crisisManager: CrisisManager
    @Binding var showingVoiceSelection: Bool
    @Binding var showingARShowcase: Bool
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    // Clean header
                    VStack(spacing: 8) {
                        CustomAnchorIcon()
                            .frame(width: 50, height: 50)
                        
                        Text("Navigation")
                            .font(.system(size: 24, weight: .light))
                            .foregroundColor(.anchorSilver)
                    }
                    .padding(.top, 20)
                    
                    // Essential navigation options only
                    VStack(spacing: 20) {
                    MenuButton(
                        icon: "person.wave.2.fill",
                        title: "Voice Selection",
                        action: {
                            showingVoiceSelection = true
                            dismiss()
                        }
                    )
                    
                    MenuButton(
                        icon: "arkit",
                        title: "AR Breathing Orb",
                        action: {
                            crisisManager.testBreathingRing()
                        }
                    )
                }
                
                // Add bottom padding for better scrolling
                Spacer()
                    .frame(height: 50)
                }
                .padding(.horizontal, 20)
            }
            .background(
                LinearGradient(
                    colors: [.deepCurrent.opacity(0.9), .oceanDeep.opacity(0.8)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.seaGreen)
                }
            }
        }
    }
}

// MARK: - Clean Menu Button
struct MenuButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.seaGreen)
                    .frame(width: 30)
                
                Text(title)
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(.anchorSilver)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.seafoam)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.seaGreen.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: Color.oceanDeep.opacity(0.2), radius: 8, x: 0, y: 4)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Custom Anchor Icon
struct CustomAnchorIcon: View {
    var body: some View {
        ZStack {
            // Background glow effect - white illuminating like water droplet
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.white.opacity(0.8),
                            Color.white.opacity(0.4),
                            Color.white.opacity(0.1),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 5,
                        endRadius: 30
                    )
                )
            
            // Anchor shape - white with illuminating effect
            AnchorShape()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.white,
                            Color.white.opacity(0.9),
                            Color.white.opacity(0.7)
                        ],
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: 25
                    )
                )
                .frame(width: 30, height: 40)
                .shadow(color: .white.opacity(0.5), radius: 8, x: 0, y: 0)
        }
    }
}

// MARK: - Anchor Shape
struct AnchorShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        let centerX = width * 0.5
        
        // Anchor ring (top) - larger and more prominent
        let ringCenter = CGPoint(x: centerX, y: height * 0.15)
        let ringOuterRadius = width * 0.12
        let ringInnerRadius = width * 0.08
        
        // Outer ring
        path.addEllipse(in: CGRect(
            x: ringCenter.x - ringOuterRadius,
            y: ringCenter.y - ringOuterRadius,
            width: ringOuterRadius * 2,
            height: ringOuterRadius * 2
        ))
        
        // Inner ring (subtract to create hole)
        path.addEllipse(in: CGRect(
            x: ringCenter.x - ringInnerRadius,
            y: ringCenter.y - ringInnerRadius,
            width: ringInnerRadius * 2,
            height: ringInnerRadius * 2
        ))
        
        // Anchor shank (vertical shaft) - thicker
        let shankWidth = width * 0.04
        let shankRect = CGRect(
            x: centerX - shankWidth/2,
            y: height * 0.27,
            width: shankWidth,
            height: height * 0.45
        )
        path.addRoundedRect(in: shankRect, cornerSize: CGSize(width: shankWidth/2, height: shankWidth/2))
        
        // Anchor arms (crossbar) - thicker and more defined
        let armY = height * 0.72
        let armWidth = width * 0.5
        let armThickness = width * 0.06
        let armRect = CGRect(
            x: centerX - armWidth/2,
            y: armY - armThickness/2,
            width: armWidth,
            height: armThickness
        )
        path.addRoundedRect(in: armRect, cornerSize: CGSize(width: armThickness/2, height: armThickness/2))
        
        // Left fluke (curved hook)
        let leftFlukeCenter = CGPoint(x: centerX - armWidth/2, y: armY)
        let flukeRadius = width * 0.08
        let flukeThickness = width * 0.04
        
        // Left fluke curve
        path.move(to: CGPoint(x: leftFlukeCenter.x, y: leftFlukeCenter.y))
        path.addQuadCurve(
            to: CGPoint(x: leftFlukeCenter.x - flukeRadius, y: leftFlukeCenter.y + flukeRadius),
            control: CGPoint(x: leftFlukeCenter.x - flukeRadius, y: leftFlukeCenter.y)
        )
        path.addQuadCurve(
            to: CGPoint(x: leftFlukeCenter.x - flukeRadius + flukeThickness, y: leftFlukeCenter.y + flukeRadius - flukeThickness),
            control: CGPoint(x: leftFlukeCenter.x - flukeRadius + flukeThickness/2, y: leftFlukeCenter.y + flukeRadius)
        )
        path.addQuadCurve(
            to: CGPoint(x: leftFlukeCenter.x, y: leftFlukeCenter.y),
            control: CGPoint(x: leftFlukeCenter.x - flukeRadius/2, y: leftFlukeCenter.y)
        )
        
        // Right fluke (curved hook)
        let rightFlukeCenter = CGPoint(x: centerX + armWidth/2, y: armY)
        
        path.move(to: CGPoint(x: rightFlukeCenter.x, y: rightFlukeCenter.y))
        path.addQuadCurve(
            to: CGPoint(x: rightFlukeCenter.x + flukeRadius, y: rightFlukeCenter.y + flukeRadius),
            control: CGPoint(x: rightFlukeCenter.x + flukeRadius, y: rightFlukeCenter.y)
        )
        path.addQuadCurve(
            to: CGPoint(x: rightFlukeCenter.x + flukeRadius - flukeThickness, y: rightFlukeCenter.y + flukeRadius - flukeThickness),
            control: CGPoint(x: rightFlukeCenter.x + flukeRadius - flukeThickness/2, y: rightFlukeCenter.y + flukeRadius)
        )
        path.addQuadCurve(
            to: CGPoint(x: rightFlukeCenter.x, y: rightFlukeCenter.y),
            control: CGPoint(x: rightFlukeCenter.x + flukeRadius/2, y: rightFlukeCenter.y)
        )
        
        return path
    }
}

#Preview {
    ContentView()
}