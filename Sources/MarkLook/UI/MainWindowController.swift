import Cocoa
import MarkLookCore

final class MainWindowController: NSWindowController {
    private let mainViewController = MainViewController()
    
    init() {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 980, height: 680),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        window.title = "MarkLook"
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .visible
        window.minSize = NSSize(width: 860, height: 580)
        window.center()
        window.setFrameAutosaveName("MarkLookMainWindow")
        
        super.init(window: window)
        window.contentViewController = mainViewController
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selectTab(index: Int) {
        mainViewController.selectTab(index: index)
    }
}
