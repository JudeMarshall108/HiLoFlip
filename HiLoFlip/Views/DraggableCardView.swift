//
//  DraggableCardView.swift
//  HiLoFlip
//
//  Created by Jude Burdick on 11/3/26.
//

import SwiftUI

struct DraggableCardView: View {
    let card: HiLoGame.Card
    let width: CGFloat
    let canDrag: Bool
    let isDragging: Bool
    let cardNamespace: Namespace.ID
    let discardFrame: CGRect
    let onPlay: () -> Bool
    let onDragChanged: (CGRect, CGSize) -> Void
    let onDragEnded: () -> Void
    @State private var isReturning = false
    @State private var cardFrame: CGRect = .zero
    
    var body: some View {
        ZStack {
            cardImage
        }
        .onGeometryChange(for: CGRect.self) { proxy in
            proxy.frame(in: .named("gameBoard"))
        } action: { newFrame in
            cardFrame = newFrame
        }
        .contentShape(Rectangle())
        .gesture(dragGesture, including: canDrag && !isReturning ? .all : .none)
    }
    
    @ViewBuilder
    private var cardImage: some View {
        if isDragging {
            Color.clear
                .frame(width: width, height: width * 1.55)
        } else {
            CardView(card: card, width: width)
                .matchedGeometryEffect(id: card.value, in: cardNamespace)
                .transition(.identity)
        }
    }
    
    private var dragGesture: some Gesture {
        DragGesture(coordinateSpace: .named("gameBoard"))
            .onChanged { value in
                onDragChanged(cardFrame, value.translation)
            }
            .onEnded { value in
                finishDrag(at: value.location)
            }
    }
    
    private func finishDrag(at location: CGPoint) {
        var played = false
        withAnimation(.easeInOut) {
            played = canDrag && discardFrame.contains(location) && onPlay()
            if played { onDragEnded() }
        }
        if !played { returnCard() }
    }
    
    private func returnCard() {
        isReturning = true
        withAnimation(.easeInOut, completionCriteria: .removed) {
            onDragChanged(cardFrame, .zero)
        } completion: {
            onDragEnded()
            isReturning = false
        }
    }
    
}
