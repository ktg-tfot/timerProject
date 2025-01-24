//
//  ContentView.swift
//  timerProject
//
//  Created by 김태건 on 1/24/25.
//

import SwiftUI
import AVFoundation

struct AlwaysOnTopView: NSViewRepresentable {
    let window: NSWindow
    let isAlwaysOnTop: Bool
    
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        if isAlwaysOnTop {
            window.level = .floating
        } else {
            window.level = .normal
        }
    }
}

class SoundManager {
    static let instance = SoundManager()
    var player: AVAudioPlayer?
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "Beep", withExtension: "mov") else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print("재생 오류. \(error.localizedDescription)")
        }
    }
}

struct ContentView: View {
    @State private var isRunning = false
    @State private var timeRemaining = 0
    @State private var isOnTop = true
    @State private var startTime = 0
    @State var completionDate = Date.now
    //    @State var widthValue: CGFloat = 100
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            //            Spacer()
            //            HStack(alignment: .top){
            //                Button(){
            //                    isOnTop.toggle()
            //                } label: {
            //                    Image(systemName: isOnTop ? "pin.fill" : "pin.slash")
            //                }.buttonStyle(PlainButtonStyle())
            //                Button(){
            //                    isRunning.toggle()
            //                    withAnimation(.easeInOut(duration: TimeInterval(startTime))) {
            //                    }
            //                } label: {
            //                    Image(systemName: isRunning ? "pause" : "play.fill")
            //                }.buttonStyle(PlainButtonStyle())
            //                Button(){
            //                    isRunning.toggle()
            //                    timeRemaining = startTime
            //                    widthValue = 100
            //                    updateCompletionDate(remainTime: Double(timeRemaining))
            //                } label: {
            //                    if isRunning {
            //                        Image(systemName: "repeat")
            //                    }
            //                }.buttonStyle(PlainButtonStyle())
            //            }
   
            ZStack {
                //                HStack{
                Image(systemName: "watchface.applewatch.case")
                    .resizable()
                    .foregroundColor(.black)
                
                RoundedRectangle(cornerRadius: 25)
//                                        .fill(widthValue <= 30 ? Color.red : widthValue <= 50 ? Color.yellow :Color.green)
//                                        .frame(height: 50)
//                                        .animation(.easeInOut(duration: 0.5), value: widthValue)
//                                        .frame(width: widthValue)
//                                        .frame(maxWidth:.infinity, alignment: .leading)
//                                        .offset(CGSize(width: 4, height: -1))
                    .fill(Color.black)
                    .padding(.top, -4.0)
                    .padding(.trailing, -0.5)
                    .padding(.leading, -15.0)
                    .frame(height: 160.0)
                    .frame(width: 112.0)
                //                }
                //                Image(systemName: "battery.0percent")
                //                    .resizable()
                //                    .frame(width: 120, height: 60)
                //                    .foregroundColor(.black)

                Text(completionDate, format: .dateTime.hour().minute())
                    .foregroundColor(Color.white)
                    .padding(.bottom, 150.0)
                    .padding(.trailing, 12.0)
                
//                RoundedRectangle(cornerRadius: 25)
//                    .fill(Color.green)
//                    .padding(.top, -4.0)
//                    .padding(.trailing, -0.5)
//                    .padding(.leading, -15.0)
//                    .frame(height: 80.0)
//                    .frame(width: 56.0)
                
                Circle()
//                    .stroke(style: StrokeStyle(lineWidth: 8, dash:[CGFloat(2), CGFloat(10)]))
                    .stroke(style: StrokeStyle(lineWidth: 8, dash:[CGFloat(2), CGFloat(5)]))
                    .fill(Color.orange)
                    .padding(.top, -4.0)
                    .padding(.trailing, -0.5)
                    .padding(.leading, -15.0)
                    .frame(height: 110.0)
                    .frame(width: 110.0)
                
                Text("\(timeRemaining / 60):\(String(format: "%02d", timeRemaining % 60))")
                    .font(.system(size: 20, weight: .bold))
                    .padding(.leading, -10.0)
                    .foregroundStyle(isRunning ? Color.white : Color.gray)
                
                Button(){
                    isRunning.toggle()
                    withAnimation(.easeInOut(duration: TimeInterval(startTime))) {
                    }
                } label: {
                    Image(systemName: isRunning ? "pause.circle.fill" : "play.circle.fill")
                        .resizable()
                        .frame(height: 20.0)
                        .frame(width: 20.0)
                        .padding(.top, 110.0)
                        .padding(.bottom, 5.0)
                        .padding(.trailing, 0.0)
                        .padding(.leading, 95.0)
                        .foregroundColor(Color.orange)
                }.buttonStyle(PlainButtonStyle())
            }
        }
        .frame(width: 170, height: 200)
        .padding()
//                .onChange(of: isRunning) {
//                    isOnTop = isRunning
//                    updateCompletionDate(remainTime: Double(timeRemaining))
//                }
        .background(AlwaysOnTopView(window: NSApplication.shared.windows.first!, isAlwaysOnTop: isOnTop))
        .onReceive(timer) { _ in
            if isRunning && timeRemaining > 0 {
                timeRemaining -= 1
//                if widthValue > 0 && startTime > 0 {
//                    widthValue -= 100 / CGFloat(startTime)
//                }
                if timeRemaining <= 5 {
                    NSSound.beep()
                }
            } else if isRunning {
                isRunning = false
                timeRemaining = startTime
            }
        }
    }
    
    func updateCompletionDate(remainTime: Double) {
        completionDate = Date.now.addingTimeInterval(remainTime)
    }
}

#Preview {
    ContentView()
}
