//
//  OrfeusSuspense.swift
//  MessageRacer
//
//  Created by Vincent on 7/4/21.
//

import SwiftUI
import Apollo

/// Orfeus Content View to render `AgentState` elegantly
///
/// Naming convention is mimicing React Suspense, thus, loading view is marked as `fallback`
///
/// **Usage**:
///
/// Without fallbacks:
/// ```swift
/// struct ContentView: View {
///     @StateObject
///     var someQuery = QueryAgent(...).load()
///     var body: some View {
///         OrfeusSuspense(state: state) { data in
///             SomeView(data: data)
///         }
///     }
/// }
/// ```
/// With fallbacks (Note; you can omit either loading or error):
/// ```swift
/// struct ContentView: View {
///     @StateObject
///     var someQuery = QueryAgent(...).load()
///     var body: some View {
///         OrfeusSuspense(state: state, fallback: loading, catcher: errorFallback) { data in
///             SomeView(data: data)
///         }
///     }
/// }
/// // Loading fallback
/// var loading: some View {
///     Text("...loading")
/// }
///
/// // Error fallback
/// func errorFallback(_ err: Orfeus.Fault) -> some View {
///     Text("\(err.message)")
/// }
/// ```
public struct OrfeusSuspense<Content, Fallback, Catcher, Data>: View, SuspensingView where Content: View, Fallback: View, Catcher: View {
    public typealias Data = Data
    public typealias LoadingView = Fallback
    public typealias SuccessView = Content
    public typealias FailureView = Catcher
    
    /// State given
    let state: Orfeus.AgentState<Data>
    /// Render function given the data
    let content: (Data) -> Content
    /// Fallback loading view
    let fallback: Fallback
    /// Error Catcher View
    let catcher: (Orfeus.Fault) -> Catcher
    
    public init(
        state data: Orfeus.AgentState<Data>,
        fallback fall: Fallback,
        catcher handler: @escaping (Orfeus.Fault) -> Catcher,
        @ViewBuilder content child: @escaping (Data) -> Content
    ) {
        state = data
        content = child
        fallback = fall
        catcher = handler
    }
    
    public var body: some View {
        view(state: state)
    }
    
    private func errorHandler(_ err: Orfeus.Fault) -> some View {
        print("Error: \(err)")
        return catcher(err)
    }
    
    public var loadingView: Fallback {
        fallback
    }
    
    public func successView(for data: Data) -> Content {
        content(data)
    }
    
    public func faultView(for fault: Orfeus.Fault) -> Catcher {
        catcher(fault)
    }
}

extension OrfeusSuspense where Fallback == EmptyView, Catcher == EmptyView, Content: View {
    public init(state data: Orfeus.AgentState<Data>, @ViewBuilder content child: @escaping (Data) -> Content) {
        state = data
        content = child
        fallback = EmptyView()
        catcher = { _ in EmptyView() }
    }
}

extension OrfeusSuspense where Fallback == EmptyView, Catcher: View, Content: View {
    public init(
        state data: Orfeus.AgentState<Data>,
        catcher handler: @escaping (Orfeus.Fault) -> Catcher,
        @ViewBuilder content child: @escaping (Data) -> Content
    ) {
        state = data
        content = child
        fallback = EmptyView()
        catcher = handler
    }
}

extension OrfeusSuspense where Catcher == EmptyView, Fallback: View, Content: View {
    public init(
        state data: Orfeus.AgentState<Data>,
        fallback fall: Fallback,
        @ViewBuilder content child: @escaping (Data) -> Content
    ) {
        state = data
        content = child
        fallback = fall
        catcher = { _ in EmptyView() }
    }
}
