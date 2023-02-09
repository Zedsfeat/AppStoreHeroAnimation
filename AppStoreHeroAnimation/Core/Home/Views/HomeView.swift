//
//  HomeView.swift
//  AppStoreHeroAnimation
//
//  Created by zedsbook on 09.02.2023.
//

import SwiftUI

struct HomeView: View {
    
    @State var currentItem: Today?
    @State var showDetailPage: Bool = false
    
    @Namespace var animation
    
    @State var animateView: Bool = false
    @State var animateContent: Bool = false
    @State var scrollOffset: CGFloat = 0
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("THURSDAY 9 FEBRUARY")
                            .font(.callout)
                            .foregroundColor(.gray)
                        Text("Today")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "person.crop.circle")
                            .font(.largeTitle)
                    }

                }
                .padding(.horizontal)
                .opacity(showDetailPage ? 0 : 1)
                
                ForEach(todayItems) { item in
                    Button {
                        withAnimation(.interactiveSpring(response: 0.6,
                                                         dampingFraction: 0.7,
                                                         blendDuration: 0.7).speed(2)) {
                            currentItem = item
                            showDetailPage = true
                        }
                    } label: {
                        CardView(item: item)
                            .padding(.horizontal, 10)
                            .scaleEffect(currentItem?.id == item.id && showDetailPage ? 1 : 0.96)
                    }
                    .buttonStyle(ScaledButtonStyle())
                    .opacity(showDetailPage ? (currentItem?.id == item.id ? 1 : 0) : 1)
                }
            }
            .padding(.vertical)
        }
        .overlay {
            if let currentItem, showDetailPage {
                DetailView(item: currentItem)
                    .edgesIgnoringSafeArea(.top)
            }
        }
        .background(alignment: .top) {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(Color("BackgroundColor"))
                .frame(height: animateView ? nil : 350, alignment: .top)
                .opacity(animateView ? 1 : 0)
                .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    func CardView(item: Today) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            ZStack(alignment: .topLeading) {
                
                GeometryReader { proxy in
                    let size = proxy.size
                    
                    Image(item.artwork)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .clipShape(CustomCorner(corners: [.topLeft, .topRight], radius: 15))
                }
                .frame(height: 400)
                
                LinearGradient(
                    colors: [
                        .black.opacity(0.5),
                        .black.opacity(0.2),
                        .clear
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(item.platformTitle.uppercased())
                        .font(.callout)
                        .fontWeight(.semibold)
                    
                    Text(item.bannerTitle)
                        .multilineTextAlignment(.leading)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                .foregroundColor(.primary)
                .padding()
                .offset(y: currentItem?.id == item.id && animateView ? safeArea().top : 0)
            }
            
            HStack(spacing: 12) {
                Image(item.appLogo)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.platformTitle.uppercased())
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text(item.appName)
                        .foregroundColor(.primary)
                        .fontWeight(.bold)
                    
                    Text(item.appDescription)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Button {
                    
                } label: {
                    Text("Get")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 11)
                        .background {
                            Capsule()
                                .fill(.ultraThinMaterial)
                        }
                }
            }
            .padding([.horizontal, .bottom])
        }
        .background {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(Color("BackgroundColor"))
        }
        .matchedGeometryEffect(id: item.id, in: animation)
    }
    
    func DetailView(item: Today) -> some View {
        ScrollView(.vertical) {
            VStack {
                CardView(item: item)
                    .scaleEffect(animateView ? 1 : 0.96)
                
                VStack(spacing: 15) {
                    Text(dummyText)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(10)
                        .padding(.top, -15)
                        
                    Button {
                    } label: {
                        Label {
                            Text("Share Story")
                        } icon: {
                            Image(systemName: "square.and.arrow.up.fill")
                        }
                        .foregroundColor(.primary)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 25)
                        .background {
                            RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(.ultraThinMaterial)
                        }

                    }

                }
                .padding(.horizontal)
                .offset(y: scrollOffset > 0 ? scrollOffset : 0)
                .opacity(animateContent ? 1 : 0)
                .scaleEffect(animateView ? 1 : 0, anchor: .top)
            }
            .offset(y: scrollOffset > 0 ? -scrollOffset : 0)
            .offset(offset: $scrollOffset)
        }
        .coordinateSpace(name: "SCROLL")
        .overlay(alignment: .topTrailing, content: {
            Button {
                withAnimation(.interactiveSpring(response: 0.6,
                                                 dampingFraction: 0.7,
                                                 blendDuration: 0.7).speed(2)) {
                    animateView = false
                    animateContent = false
                }
                
                withAnimation(.interactiveSpring(response: 0.6,
                                                 dampingFraction: 0.7,
                                                 blendDuration: 0.7).speed(2).delay(0.05)) {
                    currentItem = nil
                    showDetailPage = false
                }
                
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .foregroundColor(.white)
            }
            .padding()
            .offset(y: -10)
            .padding(.top, safeArea().top)
            .opacity(animateView ? 1 : 0)

        })
        .onAppear {
            withAnimation(.interactiveSpring(response: 0.6,
                                             dampingFraction: 0.7,
                                             blendDuration: 0.7).speed(2)) {
                animateView = true
            }
            
            withAnimation(.interactiveSpring(response: 0.6,
                                             dampingFraction: 0.7,
                                             blendDuration: 0.7).speed(2).delay(0.01)) {
                animateContent = true
            }
        }
        .transition(.identity)
        
        
    }
    
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .preferredColorScheme(.dark)
    }
}


struct ScaledButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.spring().speed(3), value: configuration.isPressed)
    }
}

extension View {
    func safeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return .zero }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else { return .zero }
        
        return safeArea
    }
    
    func offset(offset: Binding<CGFloat>) -> some View {
        return self
            .overlay {
                GeometryReader { proxy in
                    let minY = proxy.frame(in: .named("SCROLL")).minY
                    
                    Color.clear
                        .preference(key: OffsetKey.self, value: minY)
                }
                .onPreferenceChange(OffsetKey.self) { value in
                    offset.wrappedValue = value
                }
            }
    }
}


struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
