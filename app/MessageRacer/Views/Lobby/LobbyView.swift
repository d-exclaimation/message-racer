//
//  LobbyView.swift
//  MessageRacer
//
//  Created by Vincent on 6/29/21.
//

import SwiftUI
import Apollo
import ActivityIndicatorView


public struct LobbyView: View {
    @EnvironmentObject var user: User
    let color: Color
    let navigate: (MainRoute) -> Void
    
    @State
    var showForm: Bool = false
    @State
    var errorMessage: String? = nil
    @State
    var roomID: GraphQLID? = nil
    
    /// Room Feed  Agent
    @StateObject
    var roomAgent = Orfeus.agent(
        query: AvailableRoomsQuery(),
        fallback: AvailableRoomsQuery.Data(availableRooms: [])
    )
    
    /// Join Agent Mutation
    @StateObject
    var joinAgent = Orfeus.agent(
        mutation: JoinRoomMutation.self
    )
    
    public var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(color)
                .ignoresSafeArea(.all)
            
            OrfeusSuspense(state: roomAgent.state, fallback: loading) { data in
                ScrollView {
                    LazyVStack {
                        ForEach(data.availableRooms) { room in
                            Button {
                                roomID = room.id
                                showForm = true
                            } label: {
                                RoomPreview(room: room)
                            }
                            .disabled(room.players.count >= 4)
                        }
                    }
                }
                .padding(.top, 15)
                .transition(.scale(scale: 0.3).combined(with: .opacity))
                .sheet(
                    isPresented: $showForm,
                    onDismiss: { showForm = false }
                ) {
                    UserInfoView(isShowing: $showForm, errorMessage: $errorMessage, isLoading: joinAgent.isLoading, onSubmit: onFormSubmit)
                }
            }
        }
    }
    
    private var loading: some View {
        ActivityIndicatorView(isVisible: Binding.constant(true), type: .rotatingDots)
            .frame(maxWidth: 50, maxHeight: 50)
            .foregroundColor(Color(UIColor.darkPurple))
            .transition(.opacity)
    }
    
    private func onFormSubmit(_ username: String) -> Void {
        guard let roomID = roomID else { return }
        joinAgent.mutate(
            variables: JoinRoomMutation(id: roomID, username: username),
            onCompleted: handleSuccess(data:),
            onFailure: { errorMessage = $0.message }
        )
        user.login(username: username)
    }
    
    private func handleSuccess(data: JoinRoomMutation.Data) -> Void {
        guard let roomID = UUID(uuidString: roomID ?? "") else { return }
        roomAgent.invalidate()
        navigate(.room(id: roomID))
    }
    
    private let foreground: Color = .white
}

struct LobbyView_Previews: PreviewProvider {
    static var previews: some View {
        LobbyView(color: .black, navigate: { _ in print("a") })
    }
}
