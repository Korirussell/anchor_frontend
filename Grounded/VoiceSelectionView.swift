//
//  VoiceSelectionView.swift
//  Grounded
//
//  Created by Kori Russell on 9/26/25.
//

import SwiftUI

struct VoiceSelectionView: View {
    @ObservedObject var crisisManager: CrisisManager
    @State private var selectedVoice: String = "shimmer"
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 10) {
                Text("Voice Selection")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Choose your calming companion")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 20)
            
            // Current Voice Display
            VStack(spacing: 10) {
                Text("Current Voice")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Text(crisisManager.currentOpenAIVoice.capitalized)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(10)
            }
            
            // Voice Options
            ScrollView {
                LazyVStack(spacing: 15) {
                    ForEach(crisisManager.getAvailableVoices(), id: \.0) { voice in
                        VoiceOptionCard(
                            voice: voice,
                            isSelected: selectedVoice == voice.0,
                            onPreview: {
                                crisisManager.previewVoice(voice.0)
                            },
                            onSelect: {
                                selectedVoice = voice.0
                                crisisManager.updateVoiceSelection(voice.0)
                            }
                        )
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
        }
        .onAppear {
            selectedVoice = crisisManager.currentOpenAIVoice
        }
    }
}

struct VoiceOptionCard: View {
    let voice: (String, String, String)
    let isSelected: Bool
    let onPreview: () -> Void
    let onSelect: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            // Voice Name and Description
            VStack(spacing: 8) {
                Text(voice.1)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(voice.2)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // Action Buttons
            HStack(spacing: 15) {
                // Preview Button
                Button(action: onPreview) {
                    HStack {
                        Image(systemName: "play.circle.fill")
                        Text("Preview")
                    }
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(20)
                }
                
                // Select Button
                Button(action: onSelect) {
                    HStack {
                        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        Text(isSelected ? "Selected" : "Select")
                    }
                    .font(.subheadline)
                    .foregroundColor(isSelected ? .white : .green)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(isSelected ? Color.green : Color.green.opacity(0.1))
                    .cornerRadius(20)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 3)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(isSelected ? Color.green : Color.clear, lineWidth: 2)
        )
    }
}

#Preview {
    VoiceSelectionView(crisisManager: CrisisManager())
}