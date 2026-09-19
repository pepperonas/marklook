import Cocoa
import WebKit
import MarkLookCore

final class MainViewController: NSViewController, NSTextViewDelegate {
    private var settings = MarkLookSettings.load()
    
    private let segmentedControl = NSSegmentedControl(labels: ["Live Preview", "Extension Status", "Settings", "About"], trackingMode: .selectOne, target: nil, action: nil)
    private let containerView = NSView()
    
    // Pane 0: Live Preview
    private let previewContainer = NSSplitView()
    private let editorTextView = NSTextView()
    private var webView: WKWebView!
    private let presetPopup = NSPopUpButton()
    
    // Pane 1: Status
    private let statusContainer = NSView()
    private let statusIconLabel = NSTextField(labelWithString: "●")
    private let statusTitleLabel = NSTextField(labelWithString: "Checking extension status...")
    private let statusSubtitleLabel = NSTextField(labelWithString: "")
    
    // Pane 2: Settings
    private let settingsContainer = NSView()
    private let appearancePopup = NSPopUpButton()
    private let textSizePopup = NSPopUpButton()
    private let contentWidthPopup = NSPopUpButton()
    private let remoteImagesCheckbox = NSButton(checkboxWithTitle: "Allow Remote Images (HTTP / HTTPS)", target: nil, action: nil)
    private let syntaxHighlightCheckbox = NSButton(checkboxWithTitle: "Enable Syntax Highlighting", target: nil, action: nil)
    
    // Pane 3: About
    private let aboutContainer = NSView()
    
    override func loadView() {
        view = NSView(frame: NSRect(x: 0, y: 0, width: 980, height: 680))
        view.wantsLayer = true
        
        setupTopBar()
        setupContainer()
        setupPreviewPane()
        setupStatusPane()
        setupSettingsPane()
        setupAboutPane()
        
        selectTab(index: 0)
    }
    
    func selectTab(index: Int) {
        segmentedControl.selectedSegment = index
        
        previewContainer.isHidden = (index != 0)
        statusContainer.isHidden = (index != 1)
        settingsContainer.isHidden = (index != 2)
        aboutContainer.isHidden = (index != 3)
        
        if index == 0 {
            updatePreview()
        } else if index == 1 {
            refreshStatus()
        } else if index == 2 {
            loadSettingsIntoUI()
        }
    }
    
    private func setupTopBar() {
        let topBar = NSView()
        topBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topBar)
        
        let titleLabel = NSTextField(labelWithString: "MARKLOOK")
        titleLabel.font = NSFont.systemFont(ofSize: 14, weight: .black)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        topBar.addSubview(titleLabel)
        
        let subtitleLabel = NSTextField(labelWithString: "Markdown Previews for macOS")
        subtitleLabel.font = NSFont.systemFont(ofSize: 11, weight: .regular)
        subtitleLabel.textColor = .secondaryLabelColor
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        topBar.addSubview(subtitleLabel)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.target = self
        segmentedControl.action = #selector(segmentChanged(_:))
        topBar.addSubview(segmentedControl)
        
        let divider = NSBox()
        divider.boxType = .separator
        divider.translatesAutoresizingMaskIntoConstraints = false
        topBar.addSubview(divider)
        
        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 28),
            topBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBar.heightAnchor.constraint(equalToConstant: 48),
            
            titleLabel.leadingAnchor.constraint(equalTo: topBar.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: topBar.topAnchor, constant: 4),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: topBar.leadingAnchor, constant: 20),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            
            segmentedControl.trailingAnchor.constraint(equalTo: topBar.trailingAnchor, constant: -20),
            segmentedControl.centerYAnchor.constraint(equalTo: topBar.centerYAnchor),
            
            divider.leadingAnchor.constraint(equalTo: topBar.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: topBar.trailingAnchor),
            divider.bottomAnchor.constraint(equalTo: topBar.bottomAnchor)
        ])
    }
    
    private func setupContainer() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Pane 0: Live Preview
    private func setupPreviewPane() {
        previewContainer.isVertical = true
        previewContainer.dividerStyle = .thin
        previewContainer.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(previewContainer)
        
        // Left pane: Editor
        let leftView = NSView()
        let topBar = NSView()
        topBar.translatesAutoresizingMaskIntoConstraints = false
        leftView.addSubview(topBar)
        
        let presetLabel = NSTextField(labelWithString: "Presets:")
        presetLabel.font = NSFont.systemFont(ofSize: 11, weight: .medium)
        presetLabel.textColor = .secondaryLabelColor
        presetLabel.translatesAutoresizingMaskIntoConstraints = false
        topBar.addSubview(presetLabel)
        
        presetPopup.addItems(withTitles: ["Overview & Architecture", "Code & Highlighting", "Tables & Task Lists"])
        presetPopup.target = self
        presetPopup.action = #selector(presetChanged(_:))
        presetPopup.translatesAutoresizingMaskIntoConstraints = false
        topBar.addSubview(presetPopup)
        
        let scrollView = NSScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.hasVerticalScroller = true
        editorTextView.font = NSFont.monospacedSystemFont(ofSize: 12, weight: .regular)
        editorTextView.isRichText = false
        editorTextView.isAutomaticQuoteSubstitutionEnabled = false
        editorTextView.isAutomaticDashSubstitutionEnabled = false
        editorTextView.string = defaultSampleMarkdown
        editorTextView.delegate = self
        scrollView.documentView = editorTextView
        leftView.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: leftView.topAnchor),
            topBar.leadingAnchor.constraint(equalTo: leftView.leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: leftView.trailingAnchor),
            topBar.heightAnchor.constraint(equalToConstant: 36),
            
            presetLabel.leadingAnchor.constraint(equalTo: topBar.leadingAnchor, constant: 14),
            presetLabel.centerYAnchor.constraint(equalTo: topBar.centerYAnchor),
            
            presetPopup.leadingAnchor.constraint(equalTo: presetLabel.trailingAnchor, constant: 8),
            presetPopup.centerYAnchor.constraint(equalTo: topBar.centerYAnchor),
            
            scrollView.topAnchor.constraint(equalTo: topBar.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leftView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: leftView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: leftView.bottomAnchor)
        ])
        
        // Right pane: WebKit Preview
        let config = WKWebViewConfiguration()
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = false
        config.defaultWebpagePreferences = prefs
        webView = WKWebView(frame: .zero, configuration: config)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        previewContainer.addArrangedSubview(leftView)
        previewContainer.addArrangedSubview(webView)
        
        NSLayoutConstraint.activate([
            previewContainer.topAnchor.constraint(equalTo: containerView.topAnchor),
            previewContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            previewContainer.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            previewContainer.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        previewContainer.setPosition(420, ofDividerAt: 0)
    }
    
    // MARK: - Pane 1: Status
    private func setupStatusPane() {
        statusContainer.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(statusContainer)
        
        let card = NSBox()
        card.boxType = .custom
        card.cornerRadius = 10
        card.borderColor = .separatorColor
        card.borderWidth = 1
        card.fillColor = .controlBackgroundColor
        card.translatesAutoresizingMaskIntoConstraints = false
        statusContainer.addSubview(card)
        
        statusIconLabel.font = NSFont.systemFont(ofSize: 28)
        statusIconLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(statusIconLabel)
        
        statusTitleLabel.font = NSFont.systemFont(ofSize: 16, weight: .bold)
        statusTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(statusTitleLabel)
        
        statusSubtitleLabel.font = NSFont.systemFont(ofSize: 12)
        statusSubtitleLabel.textColor = .secondaryLabelColor
        statusSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(statusSubtitleLabel)
        
        let checkBtn = NSButton(title: "Check Status", target: self, action: #selector(refreshStatus))
        checkBtn.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(checkBtn)
        
        // Guide Box
        let guideBox = NSBox()
        guideBox.boxType = .custom
        guideBox.cornerRadius = 10
        guideBox.borderColor = .separatorColor
        guideBox.borderWidth = 1
        guideBox.fillColor = .controlBackgroundColor
        guideBox.translatesAutoresizingMaskIntoConstraints = false
        statusContainer.addSubview(guideBox)
        
        let guideTitle = NSTextField(labelWithString: "How to Enable MarkLook in Finder")
        guideTitle.font = NSFont.systemFont(ofSize: 15, weight: .bold)
        guideTitle.translatesAutoresizingMaskIntoConstraints = false
        guideBox.addSubview(guideTitle)
        
        let guideText = """
        1. Ensure MarkLook.app is copied to /Applications.
        2. Open System Settings → Privacy & Security → Extensions.
        3. Click Quick Look and verify MarkLook Preview is checked.
        4. In Finder, highlight any .md or .markdown file and press Space.
        """
        let guideContent = NSTextField(wrappingLabelWithString: guideText)
        guideContent.font = NSFont.systemFont(ofSize: 13)
        guideContent.translatesAutoresizingMaskIntoConstraints = false
        guideBox.addSubview(guideContent)
        
        let openSettingsBtn = NSButton(title: "Open System Settings", target: self, action: #selector(openSystemSettings))
        openSettingsBtn.bezelStyle = .rounded
        openSettingsBtn.translatesAutoresizingMaskIntoConstraints = false
        guideBox.addSubview(openSettingsBtn)
        
        let resetCacheBtn = NSButton(title: "Reset Quick Look Cache", target: self, action: #selector(resetQuickLookCache))
        resetCacheBtn.bezelStyle = .rounded
        resetCacheBtn.translatesAutoresizingMaskIntoConstraints = false
        guideBox.addSubview(resetCacheBtn)
        
        NSLayoutConstraint.activate([
            statusContainer.topAnchor.constraint(equalTo: containerView.topAnchor),
            statusContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            statusContainer.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            statusContainer.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            card.topAnchor.constraint(equalTo: statusContainer.topAnchor, constant: 32),
            card.leadingAnchor.constraint(equalTo: statusContainer.leadingAnchor, constant: 40),
            card.trailingAnchor.constraint(equalTo: statusContainer.trailingAnchor, constant: -40),
            card.heightAnchor.constraint(equalToConstant: 80),
            
            statusIconLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            statusIconLabel.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            
            statusTitleLabel.leadingAnchor.constraint(equalTo: statusIconLabel.trailingAnchor, constant: 14),
            statusTitleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 18),
            
            statusSubtitleLabel.leadingAnchor.constraint(equalTo: statusTitleLabel.leadingAnchor),
            statusSubtitleLabel.topAnchor.constraint(equalTo: statusTitleLabel.bottomAnchor, constant: 4),
            
            checkBtn.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            checkBtn.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            
            guideBox.topAnchor.constraint(equalTo: card.bottomAnchor, constant: 24),
            guideBox.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            guideBox.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            guideBox.heightAnchor.constraint(equalToConstant: 240),
            
            guideTitle.topAnchor.constraint(equalTo: guideBox.topAnchor, constant: 20),
            guideTitle.leadingAnchor.constraint(equalTo: guideBox.leadingAnchor, constant: 20),
            
            guideContent.topAnchor.constraint(equalTo: guideTitle.bottomAnchor, constant: 12),
            guideContent.leadingAnchor.constraint(equalTo: guideTitle.leadingAnchor),
            guideContent.trailingAnchor.constraint(equalTo: guideBox.trailingAnchor, constant: -20),
            
            openSettingsBtn.leadingAnchor.constraint(equalTo: guideTitle.leadingAnchor),
            openSettingsBtn.topAnchor.constraint(equalTo: guideContent.bottomAnchor, constant: 16),
            
            resetCacheBtn.leadingAnchor.constraint(equalTo: openSettingsBtn.trailingAnchor, constant: 12),
            resetCacheBtn.centerYAnchor.constraint(equalTo: openSettingsBtn.centerYAnchor)
        ])
    }
    
    // MARK: - Pane 2: Settings
    private func setupSettingsPane() {
        settingsContainer.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(settingsContainer)
        
        let formBox = NSBox()
        formBox.boxType = .custom
        formBox.cornerRadius = 10
        formBox.borderColor = .separatorColor
        formBox.borderWidth = 1
        formBox.fillColor = .controlBackgroundColor
        formBox.translatesAutoresizingMaskIntoConstraints = false
        settingsContainer.addSubview(formBox)
        
        let titleLabel = NSTextField(labelWithString: "Preview Preferences")
        titleLabel.font = NSFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        formBox.addSubview(titleLabel)
        
        // Appearance
        let appLabel = NSTextField(labelWithString: "Theme Appearance:")
        appLabel.font = NSFont.systemFont(ofSize: 13, weight: .medium)
        appLabel.translatesAutoresizingMaskIntoConstraints = false
        formBox.addSubview(appLabel)
        
        appearancePopup.addItems(withTitles: ["System", "Light", "Dark"])
        appearancePopup.target = self
        appearancePopup.action = #selector(settingsChanged)
        appearancePopup.translatesAutoresizingMaskIntoConstraints = false
        formBox.addSubview(appearancePopup)
        
        // Text Size
        let sizeLabel = NSTextField(labelWithString: "Text Size:")
        sizeLabel.font = NSFont.systemFont(ofSize: 13, weight: .medium)
        sizeLabel.translatesAutoresizingMaskIntoConstraints = false
        formBox.addSubview(sizeLabel)
        
        textSizePopup.addItems(withTitles: ["Small", "Standard", "Large"])
        textSizePopup.target = self
        textSizePopup.action = #selector(settingsChanged)
        textSizePopup.translatesAutoresizingMaskIntoConstraints = false
        formBox.addSubview(textSizePopup)
        
        // Content Width
        let widthLabel = NSTextField(labelWithString: "Content Width:")
        widthLabel.font = NSFont.systemFont(ofSize: 13, weight: .medium)
        widthLabel.translatesAutoresizingMaskIntoConstraints = false
        formBox.addSubview(widthLabel)
        
        contentWidthPopup.addItems(withTitles: ["Compact (680px)", "Standard (840px)", "Wide (1040px)", "Full Width"])
        contentWidthPopup.target = self
        contentWidthPopup.action = #selector(settingsChanged)
        contentWidthPopup.translatesAutoresizingMaskIntoConstraints = false
        formBox.addSubview(contentWidthPopup)
        
        // Toggles
        remoteImagesCheckbox.target = self
        remoteImagesCheckbox.action = #selector(settingsChanged)
        remoteImagesCheckbox.translatesAutoresizingMaskIntoConstraints = false
        formBox.addSubview(remoteImagesCheckbox)
        
        syntaxHighlightCheckbox.target = self
        syntaxHighlightCheckbox.action = #selector(settingsChanged)
        syntaxHighlightCheckbox.translatesAutoresizingMaskIntoConstraints = false
        formBox.addSubview(syntaxHighlightCheckbox)
        
        let resetBtn = NSButton(title: "Reset to Defaults", target: self, action: #selector(resetSettings))
        resetBtn.translatesAutoresizingMaskIntoConstraints = false
        formBox.addSubview(resetBtn)
        
        NSLayoutConstraint.activate([
            settingsContainer.topAnchor.constraint(equalTo: containerView.topAnchor),
            settingsContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            settingsContainer.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            settingsContainer.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            formBox.topAnchor.constraint(equalTo: settingsContainer.topAnchor, constant: 32),
            formBox.leadingAnchor.constraint(equalTo: settingsContainer.leadingAnchor, constant: 40),
            formBox.trailingAnchor.constraint(equalTo: settingsContainer.trailingAnchor, constant: -40),
            formBox.bottomAnchor.constraint(equalTo: settingsContainer.bottomAnchor, constant: -40),
            
            titleLabel.topAnchor.constraint(equalTo: formBox.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: formBox.leadingAnchor, constant: 28),
            
            appLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            appLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            appearancePopup.leadingAnchor.constraint(equalTo: appLabel.trailingAnchor, constant: 20),
            appearancePopup.centerYAnchor.constraint(equalTo: appLabel.centerYAnchor),
            appearancePopup.widthAnchor.constraint(equalToConstant: 180),
            
            sizeLabel.topAnchor.constraint(equalTo: appLabel.bottomAnchor, constant: 18),
            sizeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            textSizePopup.leadingAnchor.constraint(equalTo: appearancePopup.leadingAnchor),
            textSizePopup.centerYAnchor.constraint(equalTo: sizeLabel.centerYAnchor),
            textSizePopup.widthAnchor.constraint(equalToConstant: 180),
            
            widthLabel.topAnchor.constraint(equalTo: sizeLabel.bottomAnchor, constant: 18),
            widthLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            contentWidthPopup.leadingAnchor.constraint(equalTo: appearancePopup.leadingAnchor),
            contentWidthPopup.centerYAnchor.constraint(equalTo: widthLabel.centerYAnchor),
            contentWidthPopup.widthAnchor.constraint(equalToConstant: 180),
            
            remoteImagesCheckbox.topAnchor.constraint(equalTo: widthLabel.bottomAnchor, constant: 24),
            remoteImagesCheckbox.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            syntaxHighlightCheckbox.topAnchor.constraint(equalTo: remoteImagesCheckbox.bottomAnchor, constant: 14),
            syntaxHighlightCheckbox.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            resetBtn.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            resetBtn.topAnchor.constraint(equalTo: syntaxHighlightCheckbox.bottomAnchor, constant: 28)
        ])
    }
    
    // MARK: - Pane 3: About
    private func setupAboutPane() {
        aboutContainer.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(aboutContainer)
        
        let stack = NSStackView()
        stack.orientation = .vertical
        stack.alignment = .centerX
        stack.spacing = 14
        stack.translatesAutoresizingMaskIntoConstraints = false
        aboutContainer.addSubview(stack)
        
        let icon = NSImageView()
        icon.image = NSImage(systemSymbolName: "doc.richtext", accessibilityDescription: "MarkLook")
        icon.contentTintColor = .controlAccentColor
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.heightAnchor.constraint(equalToConstant: 64).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 64).isActive = true
        stack.addArrangedSubview(icon)
        
        let appName = NSTextField(labelWithString: "MarkLook")
        appName.font = NSFont.systemFont(ofSize: 22, weight: .heavy)
        stack.addArrangedSubview(appName)
        
        let version = NSTextField(labelWithString: "Version 0.0.1 (Build 1)")
        version.font = NSFont.systemFont(ofSize: 12)
        version.textColor = .secondaryLabelColor
        stack.addArrangedSubview(version)
        
        let desc = NSTextField(wrappingLabelWithString: "Fast, native Markdown Quick Look previews for macOS.\nEngineered with Apple Swift & native macOS APIs.")
        desc.font = NSFont.systemFont(ofSize: 13)
        desc.alignment = .center
        stack.addArrangedSubview(desc)
        
        let author = NSTextField(labelWithString: "Developed by Martin Pfeffer © 2026 • celox.io")
        author.font = NSFont.systemFont(ofSize: 12, weight: .medium)
        stack.addArrangedSubview(author)
        
        let donateBtn = NSButton(title: "☕ Donate via PayPal (martin.pfeffer@celox.io)", target: self, action: #selector(openDonation))
        donateBtn.bezelStyle = .rounded
        stack.addArrangedSubview(donateBtn)
        
        let githubBtn = NSButton(title: "🐙 GitHub Repository", target: self, action: #selector(openGitHub))
        githubBtn.bezelStyle = .rounded
        stack.addArrangedSubview(githubBtn)
        
        let license = NSTextField(labelWithString: "Released under the MIT License • 100% Native Swift")
        license.font = NSFont.systemFont(ofSize: 11)
        license.textColor = .tertiaryLabelColor
        stack.addArrangedSubview(license)
        
        NSLayoutConstraint.activate([
            aboutContainer.topAnchor.constraint(equalTo: containerView.topAnchor),
            aboutContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            aboutContainer.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            aboutContainer.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            stack.centerXAnchor.constraint(equalTo: aboutContainer.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: aboutContainer.centerYAnchor, constant: -20),
            stack.widthAnchor.constraint(lessThanOrEqualToConstant: 500)
        ])
    }
    
    // MARK: - Actions & Updates
    @objc private func segmentChanged(_ sender: NSSegmentedControl) {
        selectTab(index: sender.selectedSegment)
    }
    
    @objc private func presetChanged(_ sender: NSPopUpButton) {
        switch sender.indexOfSelectedItem {
        case 0: editorTextView.string = defaultSampleMarkdown
        case 1: editorTextView.string = codeSampleMarkdown
        case 2: editorTextView.string = tableSampleMarkdown
        default: break
        }
        updatePreview()
    }
    
    func textDidChange(_ notification: Notification) {
        updatePreview()
    }
    
    private func updatePreview() {
        let renderer = MarkdownRenderer(settings: settings, documentURL: nil)
        let html = renderer.renderHTML(markdown: editorTextView.string, documentTitle: "MarkLook Live Preview")
        webView.loadHTMLString(html, baseURL: nil)
    }
    
    @objc private func refreshStatus() {
        statusIconLabel.textColor = .secondaryLabelColor
        statusTitleLabel.stringValue = "Checking extension status..."
        statusSubtitleLabel.stringValue = "Querying pluginkit..."
        
        DispatchQueue.global(qos: .userInitiated).async {
            let res = ExtensionStatusChecker.checkStatus()
            DispatchQueue.main.async {
                switch res {
                case .active:
                    self.statusIconLabel.textColor = .systemGreen
                    self.statusTitleLabel.stringValue = "Extension is Installed & Active"
                    self.statusSubtitleLabel.stringValue = "MarkLook QuickLook Preview is registered with macOS and ready for Finder."
                case .installed:
                    self.statusIconLabel.textColor = .systemOrange
                    self.statusTitleLabel.stringValue = "Extension Installed but Disabled"
                    self.statusSubtitleLabel.stringValue = "Enable MarkLook in System Settings → Privacy & Security → Extensions → Quick Look."
                case .notInstalled:
                    self.statusIconLabel.textColor = .systemRed
                    self.statusTitleLabel.stringValue = "Extension Not Registered"
                    self.statusSubtitleLabel.stringValue = "Copy MarkLook.app to /Applications and launch it once to register the extension."
                }
            }
        }
    }
    
    private func loadSettingsIntoUI() {
        switch settings.appearance {
        case .system: appearancePopup.selectItem(at: 0)
        case .light: appearancePopup.selectItem(at: 1)
        case .dark: appearancePopup.selectItem(at: 2)
        }
        
        switch settings.textSize {
        case .small: textSizePopup.selectItem(at: 0)
        case .standard: textSizePopup.selectItem(at: 1)
        case .large: textSizePopup.selectItem(at: 2)
        }
        
        switch settings.contentWidth {
        case .compact: contentWidthPopup.selectItem(at: 0)
        case .standard: contentWidthPopup.selectItem(at: 1)
        case .wide: contentWidthPopup.selectItem(at: 2)
        case .full: contentWidthPopup.selectItem(at: 3)
        }
        
        remoteImagesCheckbox.state = settings.allowRemoteImages ? .on : .off
        syntaxHighlightCheckbox.state = settings.enableSyntaxHighlighting ? .on : .off
    }
    
    @objc private func settingsChanged() {
        switch appearancePopup.indexOfSelectedItem {
        case 0: settings.appearance = .system
        case 1: settings.appearance = .light
        case 2: settings.appearance = .dark
        default: break
        }
        
        switch textSizePopup.indexOfSelectedItem {
        case 0: settings.textSize = .small
        case 1: settings.textSize = .standard
        case 2: settings.textSize = .large
        default: break
        }
        
        switch contentWidthPopup.indexOfSelectedItem {
        case 0: settings.contentWidth = .compact
        case 1: settings.contentWidth = .standard
        case 2: settings.contentWidth = .wide
        case 3: settings.contentWidth = .full
        default: break
        }
        
        settings.allowRemoteImages = (remoteImagesCheckbox.state == .on)
        settings.enableSyntaxHighlighting = (syntaxHighlightCheckbox.state == .on)
        
        settings.save()
        updatePreview()
    }
    
    @objc private func resetSettings() {
        settings = MarkLookSettings()
        settings.save()
        loadSettingsIntoUI()
        updatePreview()
    }
    
    @objc private func openSystemSettings() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.ExtensionsPreferences") {
            NSWorkspace.shared.open(url)
        }
    }
    
    @objc private func resetQuickLookCache() {
        let alert = NSAlert()
        alert.messageText = "Quick Look Cache Reset"
        alert.informativeText = "Run the following command in Terminal to reload generators:\n\nqlmanage -r && qlmanage -r cache && killall Finder"
        alert.addButton(withTitle: "Copy Command")
        alert.addButton(withTitle: "Cancel")
        if alert.runModal() == .alertFirstButtonReturn {
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString("qlmanage -r && qlmanage -r cache && killall Finder", forType: .string)
        }
    }
    
    @objc private func openDonation() {
        if let url = URL(string: "https://www.paypal.com/donate/?business=martin.pfeffer%40celox.io&item_name=MarkLook&currency_code=EUR") {
            NSWorkspace.shared.open(url)
        }
    }
    
    @objc private func openGitHub() {
        if let url = URL(string: "https://github.com/pepperonas/marklook") {
            NSWorkspace.shared.open(url)
        }
    }
}

let defaultSampleMarkdown = """
# MarkLook Preview

**MarkLook** provides blazing-fast, native Quick Look previews for Markdown files directly inside Finder.

## Key Features

- **CommonMark & GFM Support**: Headings, lists, blockquotes, tables, and task lists.
- **Native macOS Design**: Follows Apple's Human Interface Guidelines with system typography and adaptive colors.
- **Zero JavaScript Runtime**: Safe and fast server-side HTML generation in pure Swift.
- **Privacy Focused**: No tracking, no telemetry, with remote image blocking by default.

### Architecture Highlights

> "A native macOS component that renders Markdown documents the way Apple would have built it."

- Select any `.md` or `.markdown` file in Finder
- Press `Space`
- Enjoy an instantly rendered native preview!
"""

let codeSampleMarkdown = """
# Syntax Highlighting Example

MarkLook features a pure-Swift syntax highlighter for over 15 programming languages.

### Swift Example
```swift
import Foundation
import QuickLookUI

@objc(PreviewProvider)
public final class PreviewProvider: QLPreviewProvider, QLPreviewingController {
    public func providePreview(for request: QLFilePreviewRequest, completionHandler: @escaping (QLPreviewReply?, Error?) -> Void) {
        let renderer = MarkdownRenderer()
        let html = renderer.renderHTML(markdown: "# Hello")
        let reply = QLPreviewReply(dataOfContentType: .html, contentSize: CGSize(width: 800, height: 600)) { _ in
            return html.data(using: .utf8) ?? Data()
        }
        completionHandler(reply, nil)
    }
}
```

### Rust Example
```rust
pub fn calculate_hash<T: Hash>(t: &T) -> u64 {
    let mut s = DefaultHasher::new();
    t.hash(&mut s);
    s.finish()
}
```

### Python Example
```python
def fibonacci(n: int) -> list[int]:
    sequence = [0, 1]
    while len(sequence) < n:
        sequence.append(sequence[-1] + sequence[-2])
    return sequence
```
"""

let tableSampleMarkdown = """
# Tables & Task Lists

### Feature Checklist

- [x] Native Swift 6.4 Implementation
- [x] Apple Quick Look App Extension (`QLPreviewProvider`)
- [x] CommonMark + GitHub Flavored Markdown
- [x] Syntax Highlighting in pure Swift
- [x] Dark / Light Mode via `@media (prefers-color-scheme)`
- [ ] Custom Plugins (Roadmap)

### Performance Comparison

| Feature | MarkLook | Legacy Generators | Electron Viewers |
| :--- | :---: | :---: | :---: |
| **Startup Time** | < 10 ms | ~ 50 ms | ~ 600 ms |
| **Memory Footprint** | ~ 15 MB | ~ 25 MB | > 150 MB |
| **Dark Mode** | Automatic | Fixed | Variable |
| **Sandboxed** | Yes | Partial | No |
"""
