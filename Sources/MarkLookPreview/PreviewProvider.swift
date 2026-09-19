import Foundation
import QuickLookUI
import UniformTypeIdentifiers
import MarkLookCore

@objc(PreviewProvider)
public final class PreviewProvider: QLPreviewProvider, QLPreviewingController {
    
    public override init() {
        super.init()
    }
    
    public func providePreview(for request: QLFilePreviewRequest, completionHandler: @escaping (QLPreviewReply?, (any Error)?) -> Void) {
        let fileURL = request.fileURL
        let settings = MarkLookSettings.load()
        
        do {
            // Check file attributes
            let attributes = try FileManager.default.attributesOfItem(atPath: fileURL.path)
            let fileSize = (attributes[.size] as? Int) ?? 0
            
            let data: Data
            if fileSize > settings.maxFileSizeBytes {
                // Read prefix only to prevent memory exhaustion
                let handle = try FileHandle(forReadingFrom: fileURL)
                defer { try? handle.close() }
                data = handle.readData(ofLength: settings.maxFileSizeBytes)
            } else {
                data = try Data(contentsOf: fileURL)
            }
            
            let markdown = String(decoding: data, as: UTF8.self)
            let renderer = MarkdownRenderer(settings: settings, documentURL: fileURL)
            let html = renderer.renderHTML(markdown: markdown, documentTitle: fileURL.lastPathComponent)
            
            let reply = QLPreviewReply(dataOfContentType: .html, contentSize: CGSize(width: 840, height: 640)) { _ in
                return html.data(using: .utf8) ?? Data()
            }
            reply.title = fileURL.lastPathComponent
            completionHandler(reply, nil)
        } catch {
            let fallbackHTML = """
            <!DOCTYPE html>
            <html>
            <head>
                <meta charset="utf-8">
                <style>
                    body {
                        font-family: -apple-system, BlinkMacSystemFont, sans-serif;
                        padding: 32px;
                        color: #ff3b30;
                        background: #ffffff;
                    }
                    @media (prefers-color-scheme: dark) {
                        body { background: #1e1e1e; }
                    }
                    .error-box {
                        border: 1px solid rgba(255, 59, 48, 0.3);
                        padding: 16px;
                        border-radius: 8px;
                        background: rgba(255, 59, 48, 0.05);
                    }
                </style>
            </head>
            <body>
                <div class="error-box">
                    <h3>Unable to Preview Markdown File</h3>
                    <p>\(HTMLSanitizer.escapeHTML(error.localizedDescription))</p>
                </div>
            </body>
            </html>
            """
            let reply = QLPreviewReply(dataOfContentType: .html, contentSize: CGSize(width: 500, height: 300)) { _ in
                return fallbackHTML.data(using: .utf8) ?? Data()
            }
            completionHandler(reply, nil)
        }
    }
}
