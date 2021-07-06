//
//  SuspensingView.swift
//  MessageRacer
//
//  Created by Vincent on 7/4/21.
//

import Foundation
import SwiftUI
import Apollo

/// Suspensing View is any view that can handle rendering `AgentState<Data>`
///
/// **Implementing on any view:**
/// ```swift
/// struct ContentView: View {
///     @StateObject
///     var someQuery = QueryAgent(...).load()
///     var body: some View {
///         view(state: someQuery.state)
///     }
/// }
///
/// extension ContentView: SuspensingView {
///     var loadingView: some View {
///         Text("...loading")
///     }
///
///     func successView(for data: SomeQuery.Data) -> some View {
///         Text("\(data.some)")
///     }
///
///     func faultView(for fault: Orfeus.Fault) -> some View {
///         Text("\(fault.message)")
///     }
/// }
/// ```
public protocol SuspensingView {
    /// GraphQL Data
    associatedtype Data
    /// Loading Fallback View
    associatedtype LoadingView: View
    /// Success Content View
    associatedtype SuccessView: View
    /// Success Content View
    associatedtype FailureView: View
    
    /// Loading Fallback View
    var loadingView: LoadingView { get }
    /// Success Content View
    func successView(for data: Data) -> SuccessView
    /// Success Content View
    func faultView(for fault: Orfeus.Fault) -> FailureView
}

extension SuspensingView {
    /// View Builder for any `SuspensingView` given the `AgentState`
    @ViewBuilder public func view(state: Orfeus.AgentState<Data>) -> some View {
        if #available(iOS 14, *) {
            switchView(state: state)
        } else {
            regularView(state: state)
        }
    }
    
    @ViewBuilder private func switchView(state: Orfeus.AgentState<Data>) -> some View {
        switch state {
        case .idle, .loading: loadingView
        case .succeed(let data): successView(for: data)
        case .failed(let fault): faultView(for: fault)
        }
    }
    
    @ViewBuilder private func regularView(state: Orfeus.AgentState<Data>) -> some View {
        if case let .succeed(data) = state {
            successView(for: data)
        } else if case let .failed(fault) = state {
            faultView(for: fault)
        } else {
            loadingView
        }
    }
}
