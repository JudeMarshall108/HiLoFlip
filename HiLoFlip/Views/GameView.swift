//
//  GameView.swift
//  HiLoFlip
//
//  Created by Jude Burdick on 9/3/26.
//

import SwiftUI


struct GameView: View {
    
    let game: HiLoFlipCardGame
    @State private var discardFrame: CGRect = .zero
    @State private var draggedCard: HiLoGame.Card? = nil
    @State private var dragStartFrame: CGRect = .zero
    @State private var dragTranslation: CGSize = .zero
    private let cardWidth: CGFloat = 80
    @Environment(\.dismiss) private var dismiss
    @State private var showQuitConfirmation = false
    @Namespace private var cardNamespace
    private var quitToolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            quitButton()
        }
    }
    
    private var quitActions: some View {
        Group {
            Button("Quit", role: .destructive) {
                dismiss()
            }
            Button("Cancel") {
                showQuitConfirmation = false
            }
        }
    }
    private var draggedCardValue: Int? {
        draggedCard?.value
    }
    
    var body: some View {
        ZStack {
            Color("GameViewGreen")
                .ignoresSafeArea()
            gameBoard()
        }
        .overlay(alignment: .topLeading) { dragOverlay }
        .coordinateSpace(.named("gameBoard"))
        .navigationBarBackButtonHidden(true)
        .toolbar { quitToolbar }
    }
    
    private func quitButton() -> some View {
        Button("Quit") {
            showQuitConfirmation = true
        }
        .confirmationDialog(
            "Quit this game?",
            isPresented: $showQuitConfirmation,
            titleVisibility: .visible
        ) {
            quitActions
        }
    }
    
    private func playerLabel(_ name: String) -> some View {
        Text(name)
            .font(.subheadline)
            .foregroundStyle(.primary)
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(.regularMaterial, in: Capsule())
    }
    
    private func deckView() -> some View {
        VStack(spacing: 4) {
            drawButton()
            Text(game.canDrawCard ? "Tap to draw" : "\(game.deckCount) cards")
                .font(.caption)
                .foregroundStyle(.white)
        }
    }
    
    private func emptyDiscardView() -> some View {
        RoundedRectangle(cornerRadius: cardWidth * 0.2)
            .stroke(.white, style: StrokeStyle(dash: [6]))
            .frame(width: cardWidth, height: cardWidth * 1.55)
            .overlay {
                Text("Discard")
                    .foregroundStyle(.white)
            }
    }
    
    @ViewBuilder
    private func discardView() -> some View {
        if let card = game.topDiscard {
            CardView(card: card, width: cardWidth)
                .matchedGeometryEffect(id: card.value, in: cardNamespace)
                .transition(.identity)
        } else {
            emptyDiscardView()
        }
    }
    
    private func discardTarget() -> some View {
        discardView()
            .onGeometryChange(for: CGRect.self) { proxy in
                proxy.frame(in: .named("gameBoard"))
            } action: { newFrame in
                discardFrame = newFrame
            }
    }
    
    func topBar() -> some View {
        HStack(spacing: 12) {
            tokenArea()
            HStack(alignment: .top, spacing: 12) {
                deckView()
                discardTarget()
            }
        }
        .padding(.horizontal)
    }
    
    private func updateDrag(_ card: HiLoGame.Card, frame: CGRect, translation: CGSize) {
        if draggedCard == nil {
            draggedCard = card
            dragStartFrame = frame
        }
        dragTranslation = translation
    }
    
    private func clearDrag() {
        draggedCard = nil
        dragStartFrame = .zero
        dragTranslation = .zero
    }
    
    @ViewBuilder
    private var dragOverlay: some View {
        if let card = draggedCard {
            CardView(card: card, width: cardWidth)
                .matchedGeometryEffect(id: card.value, in: cardNamespace)
                .scaleEffect(dragTranslation == .zero ? 1 : 1.10)
                .position(x: dragStartFrame.midX + dragTranslation.width,
                          y: dragStartFrame.midY + dragTranslation.height)
                .allowsHitTesting(false)
                .transition(.identity)
        }
    }
    
    private func tokenButton() -> some View {
        Button {
            withAnimation(.easeInOut) { game.tossToken() }
        } label : {
            TokenView(side: game.isTokenHi ? .hi : .lo, width: cardWidth)
        }
        .buttonStyle(.plain)
        .disabled(!game.canTossToken || draggedCard != nil)
        .accessibilityLabel("Toss the HI or LO token")
    }
    
    private func drawButton() -> some View {
        Button {
            withAnimation(.easeInOut) { game.drawRequiredCard() }
        } label: {
            CardBackView(width: cardWidth)
        }
        .buttonStyle(.plain)
        .disabled(!game.canDrawCard || draggedCard != nil)
        .opacity(game.canDrawCard && draggedCard == nil ? 1 : 0.55)
        .accessibilityLabel("Draw one card")
    }
    
    private func resetPileButton() -> some View {
        Button("Reset Pile") {
            withAnimation(.easeInOut) { game.resetDiscardPile() }
        }
        .font(.caption)
        .buttonStyle(.bordered)
        .controlSize(.small)
        .disabled(draggedCard != nil)
    }
    
    private func tokenArea() -> some View {
        VStack(spacing: 4) {
            tokenButton()
            if game.canResetDiscardPile {
                resetPileButton()
            }
        }
        .frame(width: cardWidth)
    }
    
    private func gameBoard() -> some View {
        VStack(spacing: 4) {
            playerLabel(game.playerOneName)
            cardGrid(0)
            topBar()
            cardGrid(1)
            playerLabel(game.playerTwoName)
        }
    }
    
    private func cardGrid(_ playerIndex: Int) -> some View {
        ScrollView {
            handGrid(playerIndex)
        }
        .scrollDisabled(draggedCard != nil)
    }
    
    private func handGrid(_ playerIndex: Int) -> some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: cardWidth))]) {
            ForEach(game.hand(for: game.players[playerIndex]), id: \.value) { card in
                handCard(card, for: playerIndex)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
    }
    
    private func handCard(_ card: HiLoGame.Card, for playerIndex: Int) -> some View {
        DraggableCardView(
            card: card, width: cardWidth,
            canDrag: canDrag(card, for: playerIndex),
            isDragging: draggedCardValue == card.value,
            cardNamespace: cardNamespace, discardFrame: discardFrame,
            onPlay: { game.play(card) },
            onDragChanged: { frame, movement in updateDrag(card, frame: frame, translation: movement) },
            onDragEnded: clearDrag
        )
    }
    
    private func canDrag(_ card: HiLoGame.Card, for playerIndex: Int) -> Bool {
        playerIndex == game.currentPlayerIndex
            && !game.isRoundOver
            && (draggedCardValue == nil || draggedCardValue == card.value)
    }
    
}

#Preview {
    GameView(game: HiLoFlipCardGame(playerNames: ["Player 1", "Player 2"]))
}
