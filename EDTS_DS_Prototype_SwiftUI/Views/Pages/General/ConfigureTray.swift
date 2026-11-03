//
//  ConfigureTray.swift
//  EDTS_DS_Prototype_SwiftUI
//
//  Created by Rizka Ghinna Auliya on 03/11/26.
//

import SwiftUI

// MARK: - Style

enum ConfigureStyle {
    static let accent = Color(red: 0.07, green: 0.47, blue: 0.84)
    static let border = Color.gray.opacity(0.35)

    static let defaultColors: [Color] = [
        Color(red: 0.07, green: 0.35, blue: 0.67),
        Color(red: 1.00, green: 0.67, blue: 0.00),
        Color(red: 1.00, green: 0.18, blue: 0.18),
        Color(red: 0.08, green: 0.62, blue: 0.40),
        Color(red: 0.10, green: 0.64, blue: 0.96),
        Color(red: 0.94, green: 0.38, blue: 0.58),
        .black,
        .white
    ]
}

// MARK: - Tray container

struct ConfigureTray<Content: View>: View {

    let title: String
    @ViewBuilder var content: () -> Content

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    content()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
        }
    }

    private var header: some View {
        HStack {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
            Spacer()
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
        .padding(.bottom, 16)
    }
}

// MARK: - Section

struct ConfigureSection<Content: View>: View {

    let title: String
    var showsDivider: Bool = true
    @ViewBuilder var content: () -> Content

    init(_ title: String, showsDivider: Bool = true, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.showsDivider = showsDivider
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                content()
            }

            if showsDivider {
                Divider()
            }
        }
    }
}

struct ConfigureCaption: View {

    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .font(.system(size: 13))
            .foregroundColor(.secondary)
    }
}

// MARK: - Chips

struct ConfigureChipRow<Item>: View {

    let items: [Item]
    let title: (Item) -> String
    let isSelected: (Item) -> Bool
    let onSelect: (Item) -> Void

    init(
        _ items: [Item],
        title: @escaping (Item) -> String,
        isSelected: @escaping (Item) -> Bool,
        onSelect: @escaping (Item) -> Void
    ) {
        self.items = items
        self.title = title
        self.isSelected = isSelected
        self.onSelect = onSelect
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                    chip(for: item)
                }
            }
            .padding(.vertical, 2)
        }
    }

    private func chip(for item: Item) -> some View {
        let selected = isSelected(item)

        return Button {
            onSelect(item)
        } label: {
            Text(title(item))
                .font(.system(size: 15))
                .foregroundColor(selected ? .white : .primary.opacity(0.7))
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(Capsule().fill(selected ? ConfigureStyle.accent : .clear))
                .overlay(
                    Capsule().stroke(selected ? ConfigureStyle.accent : ConfigureStyle.border, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Text field

struct ConfigureTextField: View {

    let label: String
    var placeholder: String?
    @Binding var text: String

    init(_ label: String, placeholder: String? = nil, text: Binding<String>) {
        self.label = label
        self.placeholder = placeholder
        self._text = text
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.secondary)

            field
                .font(.system(size: 17))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .overlay(
            RoundedRectangle(cornerRadius: 8).stroke(ConfigureStyle.border, lineWidth: 1)
        )
    }

    @ViewBuilder
    private var field: some View {
        if #available(iOS 16.0, *) {
            TextField(placeholder ?? label, text: $text, axis: .vertical)
                .lineLimit(1...4)
        } else {
            TextField(placeholder ?? label, text: $text)
        }
    }
}

// MARK: - Toggle

struct ConfigureToggle: View {

    let title: String
    @Binding var isOn: Bool

    init(_ title: String, isOn: Binding<Bool>) {
        self.title = title
        self._isOn = isOn
    }

    var body: some View {
        Toggle(title, isOn: $isOn)
            .font(.system(size: 15))
    }
}

// MARK: - Slider

struct ConfigureSlider: View {

    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    var step: Double = 1
    var decimals: Int = 0

    init(
        _ title: String,
        value: Binding<Double>,
        range: ClosedRange<Double>,
        step: Double = 1,
        decimals: Int = 0
    ) {
        self.title = title
        self._value = value
        self.range = range
        self.step = step
        self.decimals = decimals
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title)
                    .font(.system(size: 15))
                Spacer()
                Text(String(format: "%.\(decimals)f", value))
                    .font(.system(size: 13, weight: .bold))
            }
            Slider(value: $value, in: range, step: step)
        }
    }
}

// MARK: - Color

struct ConfigureColorRow: View {

    let title: String
    @Binding var selection: Color?
    var colors: [Color] = ConfigureStyle.defaultColors

    init(_ title: String, selection: Binding<Color?>, colors: [Color] = ConfigureStyle.defaultColors) {
        self.title = title
        self._selection = selection
        self.colors = colors
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 15))

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    Button {
                        selection = nil
                    } label: {
                        Image(systemName: "slash.circle")
                            .font(.system(size: 22))
                            .foregroundColor(.secondary)
                            .frame(width: 32, height: 32)
                            .overlay(selectionRing(selection == nil))
                    }
                    .buttonStyle(.plain)

                    ForEach(Array(colors.enumerated()), id: \.offset) { _, color in
                        Button {
                            selection = color
                        } label: {
                            Circle()
                                .fill(color)
                                .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1))
                                .frame(width: 32, height: 32)
                                .overlay(selectionRing(selection == color))
                        }
                        .buttonStyle(.plain)
                    }

                    ColorPicker("", selection: Binding(
                        get: { selection ?? .gray },
                        set: { selection = $0 }
                    ), supportsOpacity: false)
                    .labelsHidden()
                }
                .padding(6)
            }
        }
    }

    private func selectionRing(_ isSelected: Bool) -> some View {
        Circle()
            .stroke(Color.primary.opacity(isSelected ? 0.8 : 0), lineWidth: 2)
            .padding(-4)
    }
}

// MARK: - Button

struct ConfigureButton: View {

    let title: String
    let action: () -> Void

    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 15, weight: .medium))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .overlay(
                    RoundedRectangle(cornerRadius: 8).stroke(ConfigureStyle.border, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Sheet style

extension View {
    @ViewBuilder
    func configureTraySheetStyle() -> some View {
        if #available(iOS 16.4, *) {
            self
                .presentationDetents([.fraction(0.5), .large])
                .presentationBackgroundInteraction(.enabled(upThrough: .fraction(0.5)))
        } else if #available(iOS 16.0, *) {
            self.presentationDetents([.fraction(0.5), .large])
        } else {
            self
        }
    }
}
