//
//  Instagram.swift
//  jakuSNS
//
//  Created by 中村優介 on 2025/03/31.
//
import SwiftUI
import WebKit

// CoordinatorでURLを監視してリールへの遷移を検出・ブロック
class InstagramWebViewCoordinator: NSObject, WKNavigationDelegate, ObservableObject {
    var webView: WKWebView?
    var timer: Timer?

    func startMonitoring() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self, let webView = self.webView else { return }
            if let url = webView.url?.absoluteString {
                if url.contains("/reels/") {
                    print("🔒 リールを検出！戻ります: \(url)")
                    webView.goBack()
                }
            }
        }
    }

    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }
}

// Instagram用 WebView
struct InstagramWKView: UIViewRepresentable {
    let url: URL
    let webView: WKWebView
    @ObservedObject var coordinator: InstagramWebViewCoordinator

    func makeCoordinator() -> InstagramWebViewCoordinator {
        coordinator.webView = webView
        coordinator.startMonitoring()
        return coordinator
    }

    func makeUIView(context: Context) -> WKWebView {
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // reload不要
    }
}

// InstagramView画面
struct InstagramView: View {
    @State private var webView = WKWebView()
    @StateObject private var coordinator = InstagramWebViewCoordinator()

    var body: some View {
        VStack(spacing: 0) {
            InstagramWKView(
                url: URL(string: "https://instagram.com/")!,
                webView: webView,
                coordinator: coordinator
            )
            Divider()
            HStack {
                Button(action: {
                    webView.goBack()
                }, label: {
                    Image(systemName: "chevron.backward")
                })
                Spacer().frame(width: 40)
                Button(action: {
                    webView.goForward()
                }, label: {
                    Image(systemName: "chevron.forward")
                })
                Spacer()
            }
            .padding(.leading, 40)
            .padding(.top, 10)
            .padding(.bottom, 7)
            .frame(maxWidth: .infinity)
        }
        .onDisappear {
            coordinator.stopMonitoring()
        }
    }
}

#Preview {
    InstagramView()
}

