//
//  FilterView.swift
//  NextToGoRacesApp
//
//  Created by Clifton Baggerman on 10/02/2025.
//

import SwiftUI

/// This view displays filter buttons for different race categories using SF Symbols.
///
/// Each button displays a unique icon representing the race type (horse, harness, or greyhound)
/// and allows users to toggle filtering for that category. Selected categories are highlighted
/// with a blue accent color and border.
///
/// The view uses SF Symbols with consistent sizing and spacing:
/// - Horse racing: figure.equestrian.sports
/// - Harness racing: figure.equestrian.sports.circle (distinguishes from horse racing)
/// - Greyhound racing: hare (represents racing)
///
/// Buttons have a minimum size to ensure consistent layout and tappable areas.
/// Selection changes are animated with a spring animation for better user feedback.
///
/// - Properties:
///   - selectedFilters: A binding to a set of `RaceCategory` values that tracks which filters are active.
struct FilterView: View {
    @Binding var selectedFilters: Set<RaceCategory>
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(RaceCategory.allCases, id: \.self) { category in
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        if selectedFilters.contains(category) {
                            selectedFilters.remove(category)
                        } else {
                            selectedFilters.insert(category)
                        }
                    }
                } label: {
                    VStack(alignment: .center, spacing: 4) {
                        Image(systemName: category.sfSymbol)
                            .imageScale(.large)
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(selectedFilters.contains(category) ? .blue : .primary)
                            .frame(width: 32)
                        
                        Text(category.displayName)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(selectedFilters.contains(category) ? .blue : .primary)
                    }
                    .frame(minWidth: 80, minHeight: 80)  // Added minimum height
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.1))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(selectedFilters.contains(category) ? Color.blue : Color.clear, lineWidth: 2)
                    )
                }
                .accessibilityLabel("\(category.displayName) filter")
            }
        }
        .padding()
    }
}

#if DEBUG
// MARK: - Previews

#Preview {
    VStack(spacing: 20) {
        FilterView(selectedFilters: .constant([]))
        FilterView(selectedFilters: .constant([.horse]))
        FilterView(selectedFilters: .constant([.horse, .greyhound]))
    }
}

#endif
