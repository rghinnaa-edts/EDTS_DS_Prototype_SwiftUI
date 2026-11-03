//
//  ContentView.swift
//  EDTS_DS_Prototype_SwiftUI
//
//  Created by Rizka Ghinna Auliya on 08/10/26.
//

import SwiftUI

// MARK: - Home

struct ContentView: View {

    var body: some View {
        NavigationView {
            ZStack {
                Color.blueEDTS.ignoresSafeArea()

                VStack(spacing: 0) {
                    header

                    productsPanel
                        .padding(.top, 16)
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
    }

    // MARK: Header

    private var header: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Welcome to")
                    .font(.system(size: 14))
                    .foregroundColor(.white)

                Text("EDTS Mobile Components Design System")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.top, 24)

            Spacer(minLength: 0)

            Image("edts_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 128, height: 128)
        }
        .padding(.leading, 24)
        .padding(.trailing, 24)
    }

    // MARK: Products panel

    private var productsPanel: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Our Products")
                .font(.system(size: 17))
                .foregroundColor(.primary)

            VStack(spacing: 12) {
                ProductCard(
                    title: "General Components",
                    image: "ic_favorite",
                    tint: .redEDTS
                ) {
                    ComponentListView(title: "General Components", items: [
                        ComponentItem(name: "Alertbox", destination: AnyView(AlertboxView()))
                    ])
                }

                ProductCard(
                    title: "Klik Indomaret Apps",
                    image: "klik_logo"
                ) {
                    ComponentListView(title: "Klik Indomaret Apps", items: [])
                }

                ProductCard(
                    title: "Poinku Apps",
                    image: "poinku_logo"
                ) {
                    ComponentListView(title: "Poinku Apps", items: [])
                }
            }
            .padding(.top, 24)

            Spacer(minLength: 0)
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.white.ignoresSafeArea(edges: .bottom))
    }
}

// MARK: - Product Card

private struct ProductCard<Destination: View>: View {

    let title: String
    let image: String
    var tint: Color? = nil
    @ViewBuilder var destination: () -> Destination

    var body: some View {
        NavigationLink(destination: destination()) {
            HStack(spacing: 16) {
                icon

                Text(title)
                    .font(.system(size: 17))
                    .foregroundColor(.primary)

                Spacer(minLength: 0)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 2)
            )
            .contentShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var icon: some View {
        if let tint {
            Image(image)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(tint)
        } else {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
        }
    }
}

// MARK: - Component List (destination for each product)

private struct ComponentItem: Identifiable {
    let id = UUID()
    let name: String
    let destination: AnyView
}

private struct ComponentListView: View {

    let title: String
    let items: [ComponentItem]

    var body: some View {
        Group {
            if items.isEmpty {
                Text("Coming soon")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(items) { item in
                    NavigationLink(item.name, destination: item.destination)
                }
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ContentView()
}
