//
//  AlertboxView.swift
//  EDTS_DS_Prototype_SwiftUI
//
//  Created by Rizka Ghinna Auliya on 29/10/26.
//

import SwiftUI
import EDTS_DS_SwiftUI

// MARK: - Config

private enum AlertboxProduct: String, CaseIterable, Identifiable {
    case klik = "Klik"
    case poinku = "Poinku"

    var id: String { rawValue }

    var theme: EDTSColorTheme {
        switch self {
        case .klik: return .klikIDM
        case .poinku: return .poinku
        }
    }

    init(theme: EDTSColorTheme) {
        self = (theme == .poinku) ? .poinku : .klik
    }
}

private let previewSampleText = "This is an example of long text, please make sure that it'll be shown in two lines."

private struct AlertboxConfig: Equatable {
    var product: AlertboxProduct
    var state: EDTSAlertboxState

    var text: String = ""
    var textColor: Color? = nil

    var fontName: String
    var fontSize: Double
    var fontWeight: String?

    var iconTintColor: Color? = nil
    var iconSize: Double

    var showClose: Bool
    var btnCloseTintColor: Color? = nil
    var btnCloseSize: Double

    var showButton: Bool
    var isButtonAtRight: Bool
    var buttonText: String

    var isRibbon: Bool
    var bgColor: Color? = nil
    var borderWidth: Double
    var borderColor: Color? = nil
    var cornerRadius: Double

    var useCustomPadding: Bool = false
    var paddingTop: Double
    var paddingBottom: Double
    var paddingLeading: Double
    var paddingTrailing: Double

    var shadowOpacity: Double
    var shadowRadius: Double
    var shadowOffsetX: Double
    var shadowOffsetY: Double
    var shadowColor: Color? = nil

    init() {
        let library = EDTSAlertbox()
        let padding = EDTSAlertbox.defaultPadding

        product = AlertboxProduct(theme: EDTSColor.theme)
        state = library.state
        fontName = library.fontName
        fontSize = library.fontSize
        fontWeight = library.fontWeight
        iconSize = library.iconSize
        showClose = !library.isBtnCloseHide
        btnCloseSize = library.btnCloseSize
        showButton = !library.isBtnHide
        isButtonAtRight = library.isBtnAtRightSide
        buttonText = library.buttonText ?? ""
        isRibbon = library.isRibbonStyle
        borderWidth = library.borderWidth
        cornerRadius = library.cornerRadius
        paddingTop = padding
        paddingBottom = padding
        paddingLeading = padding
        paddingTrailing = padding
        shadowOpacity = library.shadowOpacity
        shadowRadius = library.shadowRadius
        shadowOffsetX = library.shadowOffset.width
        shadowOffsetY = library.shadowOffset.height
    }

    mutating func syncThemeDefaults() {
        showButton = !EDTSAlertbox().isBtnHide

        if !useCustomPadding {
            let padding = EDTSAlertbox.defaultPadding
            paddingTop = padding
            paddingBottom = padding
            paddingLeading = padding
            paddingTrailing = padding
        }
    }
}

private let stateOptions: [(title: String, value: EDTSAlertboxState)] = [
    ("Default", .default),
    ("Info", .info),
    ("Success", .success),
    ("Error", .error),
    ("Warning", .warning)
]

private let fontWeightOptions: [(title: String, value: String?)] = [
    ("Default", nil),
    ("Regular", "regular"),
    ("Medium", "medium"),
    ("Semibold", "semibold"),
    ("Bold", "bold")
]

// MARK: - Screen

struct AlertboxView: View {

    @State private var config = AlertboxConfig()
    @State private var showConfig = false
    @State private var reloadID = UUID()

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                alertbox
                    .id(reloadID)
                    .padding(config.isRibbon ? 0 : 16)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 24)
            }
        }
        .navigationTitle("Alertbox")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showConfig = true
                } label: {
                    Image(systemName: "gearshape.fill")
                        .foregroundColor(.primary)
                }
            }
        }
        .sheet(isPresented: $showConfig) {
            AlertboxConfigTray(config: $config)
                .configureTraySheetStyle()
        }
        .onChange(of: config) { _ in reloadID = UUID() }
    }

    private var alertbox: some View {
        EDTSAlertbox(
            state: config.state,
            text: config.text.isEmpty ? previewSampleText : config.text,
            textColor: config.textColor,
            fontName: config.fontName,
            fontSize: config.fontSize,
            fontWeight: config.fontWeight,
            iconTintColor: config.iconTintColor,
            iconSize: config.iconSize,
            btnCloseTintColor: config.btnCloseTintColor,
            btnCloseSize: config.btnCloseSize,
            buttonText: config.buttonText.isEmpty ? nil : config.buttonText,
            bgColor: config.bgColor,
            borderWidth: config.borderWidth,
            borderColor: config.borderColor,
            cornerRadius: config.cornerRadius,
            paddingTop: config.useCustomPadding ? config.paddingTop : nil,
            paddingBottom: config.useCustomPadding ? config.paddingBottom : nil,
            paddingLeading: config.useCustomPadding ? config.paddingLeading : nil,
            paddingTrailing: config.useCustomPadding ? config.paddingTrailing : nil,
            shadowOpacity: config.shadowOpacity,
            shadowRadius: config.shadowRadius,
            shadowOffset: CGSize(width: config.shadowOffsetX, height: config.shadowOffsetY),
            shadowColor: config.shadowColor,
            isBtnCloseHide: !config.showClose,
            isBtnHide: !config.showButton,
            isBtnAtRightSide: config.isButtonAtRight,
            isRibbonStyle: config.isRibbon,
            onClose: { print("Alertbox closed") },
            onButtonTap: { print("Alertbox button tapped") }
        )
    }
}

// MARK: - Config Tray

private struct AlertboxConfigTray: View {

    @Binding var config: AlertboxConfig

    var body: some View {
        ConfigureTray(title: "Configure Alertbox") {
            ConfigureSection("Theme") {
                ConfigureChipRow(
                    AlertboxProduct.allCases,
                    title: { $0.rawValue },
                    isSelected: { $0 == config.product }
                ) { product in
                    EDTSColor.theme = product.theme
                    
                    config.product = product
                    config.syncThemeDefaults()
                }
            }

            ConfigureSection("State") {
                ConfigureChipRow(
                    stateOptions,
                    title: { $0.title },
                    isSelected: { $0.value == config.state }
                ) { option in
                    config.state = option.value
                }
            }

            ConfigureSection("Text") {
                ConfigureTextField("Text", placeholder: previewSampleText, text: $config.text)
                ConfigureColorRow("Text Color", selection: $config.textColor)
            }

            ConfigureSection("Font") {
                ConfigureTextField("Font name", text: $config.fontName)
                ConfigureSlider("Font Size (0 = default)", value: $config.fontSize, range: 0...32)
                ConfigureCaption("Font Weight")
                ConfigureChipRow(
                    fontWeightOptions,
                    title: { $0.title },
                    isSelected: { $0.value == config.fontWeight }
                ) { option in
                    config.fontWeight = option.value
                }
            }

            ConfigureSection("Icon") {
                ConfigureColorRow("Icon Tint Color", selection: $config.iconTintColor)
                ConfigureSlider("Icon Size", value: $config.iconSize, range: 8...48)
            }

            ConfigureSection("Button") {
                ConfigureToggle("Show Button", isOn: $config.showButton)
                ConfigureToggle("Button at Right Side", isOn: $config.isButtonAtRight)
                    .disabled(!config.showButton || config.isRibbon)
                ConfigureTextField("Button text", placeholder: "Button", text: $config.buttonText)
                    .disabled(!config.showButton)
            }

            ConfigureSection("Close Button") {
                ConfigureToggle("Close Button Visible", isOn: $config.showClose)
                ConfigureColorRow("Close Tint Color", selection: $config.btnCloseTintColor)
                ConfigureSlider("Close Size", value: $config.btnCloseSize, range: 8...48)
            }

            ConfigureSection("Container") {
                ConfigureToggle("Ribbon Style", isOn: $config.isRibbon)
                ConfigureColorRow("Background Color", selection: $config.bgColor)
                ConfigureColorRow("Border Color", selection: $config.borderColor)
                ConfigureSlider("Border Width", value: $config.borderWidth, range: 0...8)
                ConfigureSlider("Corner Radius", value: $config.cornerRadius, range: 0...32)
            }

            ConfigureSection("Padding") {
                ConfigureToggle("Custom Padding", isOn: $config.useCustomPadding)
                Group {
                    ConfigureSlider("Top", value: $config.paddingTop, range: 0...48)
                    ConfigureSlider("Bottom", value: $config.paddingBottom, range: 0...48)
                    ConfigureSlider("Leading", value: $config.paddingLeading, range: 0...48)
                    ConfigureSlider("Trailing", value: $config.paddingTrailing, range: 0...48)
                }
                .disabled(!config.useCustomPadding)
                .opacity(config.useCustomPadding ? 1 : 0.4)
            }

            ConfigureSection("Shadow") {
                ConfigureSlider("Opacity", value: $config.shadowOpacity, range: 0...1, step: 0.05, decimals: 2)
                ConfigureSlider("Radius", value: $config.shadowRadius, range: 0...30)
                ConfigureSlider("Offset X", value: $config.shadowOffsetX, range: -20...20)
                ConfigureSlider("Offset Y", value: $config.shadowOffsetY, range: -20...20)
                ConfigureColorRow("Shadow Color", selection: $config.shadowColor)
            }

            ConfigureButton("Reset to default") {
                config = AlertboxConfig()
            }
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationView {
        AlertboxView()
    }
    .navigationViewStyle(.stack)
}
