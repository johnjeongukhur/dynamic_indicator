//
//  ContentView.swift
//  ViewBuilder
//
//  Created by John Hur on 2022/06/19.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View {
    
    // colors as Tabs
    // use your own tabs here
    var colors: [Color] = [.red, .blue, .pink, .purple]
    
    @State var offset: CGFloat = 0
    @State var currentInd: Int = 0
    
    var body: some View {
        
        ScrollView(.init()) {
            TabView(selection: $currentInd.animation()) {
                
                ForEach(colors.indices, id: \.self) { index in
                    
                        colors[index]
                            .overlay(
                                Group {
                                    // Geometry Reader for getting offset...
                                    GeometryReader { proxy -> Color in
                                        
                                        let minX = proxy.frame(in: .global).minX
                                        
                                        DispatchQueue.main.async {
                                            withAnimation(.default) {
                                                self.offset = -minX
                                            }
                                        }
                                        
                                        return Color.clear
                                        
                                    }
                                    .frame(width: 0, height: 0)
                                    
                                }, alignment: .leading
                            )
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .overlay(
                
                // Animated Indicators...
                HStack(spacing: 15) {
                    
                    ForEach(colors.indices, id: \.self) { index in
                        
                        Capsule()
//                            .fill(currentInd < index ? .gray : .white)
                            .fill(.white)
                            .frame(width: currentInd == index ? 25 : 7, height: 7)
                    }
                }
                // Smooth Sliding Effect...
                    .overlay(
                        Capsule()
                            .fill(.white)
                            .frame(width: 25, height: 7)
                            .offset(x: getOffset())
                        , alignment: .leading
                    
                    )
                    .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
                    .padding(.bottom, 10)
                ,alignment: .bottom
            )
        }
        .ignoresSafeArea()
    }
    // getting Index...
    func getIndex() -> Int {
        let index = Int(round(Double(offset / getWidth())))
        return index
    }
    // getting Offset for Capsule Shape
    func getOffset() -> CGFloat {
        // spacing = 15
        // Circle Width = 7
        // so total = 22
        let progress = offset / getWidth()
        
        return CGFloat(22 * currentInd) + progress * 22
    }
    
}

extension View {
    func getWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
}
