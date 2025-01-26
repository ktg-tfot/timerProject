//
//  ContentView.swift
//  timerProject
//
//  Created by 김태건 on 1/24/25.
//

import SwiftUI
import AVFoundation

struct AlwaysOnTopView: NSViewRepresentable
{
    let window: NSWindow
    let isAlwaysOnTop: Bool
    
    func makeNSView(context: Context) -> NSView
    {
        let view = NSView()
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context)
    {
        if (isAlwaysOnTop)
        {
            window.level = .floating
        }
        else
        {
            window.level = .normal
        }
    }
}

//Not Used
//class SoundManager
//{
//    static let instance = SoundManager()
//    var player: AVAudioPlayer?
//    
//    func playSound()
//    {
//        guard let url = Bundle.main.url(forResource: "Beep", withExtension: "mov")
//        else
//        {
//            return
//        }
//        
//        do
//        {
//            player = try AVAudioPlayer(contentsOf: url)
//            player?.play()
//        }
//        catch let error
//        {
//            print("[Error]\(error.localizedDescription)")
//        }
//    }
//}

struct ContentView: View
{
    @State private var timerPlaying = false
    @State private var timerTimeS = 0
    @State private var isOnTop = true
    @State var nowTime = Date.now
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

#if DEBUG
    @State var debugIndex = 0
#endif
    
    var body: some View
    {
        ZStack
        {
            //시계 이미지
            Image(systemName: "watchface.applewatch.case")
                .resizable()
                .frame(width: 170.0, height: 200.0)
            
            //시계 안쪽 이미지
            RoundedRectangle(cornerRadius: 25)
                .frame(width: 120.0, height: 156.0)
                .offset(x:-7, y:-2) //-7, -2 ofset 기준 시계 안쪽의 중심.
                .foregroundStyle(.black)
            
            //현재 시간
            Text(nowTime, format: .dateTime.hour().minute())
                .offset(x:-7, y:-68)
                .foregroundStyle(Color.white)
            
            //타이머 링 이미지
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 8, dash:[CGFloat(2), CGFloat(5)]))
                .frame(width: 100.0, height: 100.0)
                .offset(x:-7, y:-2)
                .foregroundStyle(Color.orange)
            
            //타이머 시간
            Text("\(String(format: "%02d", timerTimeS / 60)):\(String(format: "%02d", timerTimeS % 60))")
                .offset(x:-7, y:-2)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(timerPlaying ? Color.white : Color.gray)
            
            //시작&일시정지 버튼
            Button()
            {
                timerPlaying.toggle()
#if DEBUG
                debugIndex+=1
                print("[D]timerPlaying \(timerPlaying) \(debugIndex)")
#endif
            }
            label:
            {
                Image(systemName: timerPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .resizable()
                    .frame(width: 20.0, height: 20.0)
                    .position(x: 135, y: 155)
                    .foregroundColor(Color.orange)
            }
            .buttonStyle(.plain)
            
            //타이머 시간 변경 버튼
            Button()
            {
                timerTimeS = timerTimeS + 5
#if DEBUG
                debugIndex+=1
                print("[D]plus \(debugIndex)")
#endif
            }
            label:
            {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 20.0, height: 20.0)
                    .position(x: 185, y: 35)
                    .foregroundColor(timerPlaying ? Color.gray : Color.orange)
            }
            .buttonStyle(.plain)
            
            Button()
            {
                timerTimeS = timerTimeS - 5
#if DEBUG
                debugIndex+=1
                print("[D]minus \(debugIndex)")
#endif
            }
            label:
            {
                Image(systemName: "minus.circle.fill")
                    .resizable()
                    .frame(width: 20.0, height: 20.0)
                    .position(x: 185, y: 98)
                    .foregroundColor(timerPlaying ? Color.gray : Color.orange)
            }
            .buttonStyle(.plain)
        }
        .frame(width: 200, height: 200)
        .padding()
        .onChange(of: timerPlaying) {
            isOnTop = timerPlaying
        }
        .background(AlwaysOnTopView(window: NSApplication.shared.windows.first!, isAlwaysOnTop: isOnTop))
        .onReceive(timer)
        {
            _ in
            if(timerPlaying && timerTimeS > 0)
            {
                timerTimeS = timerTimeS - 1
                
                if(timerTimeS <= 5)
                {
                    NSSound.beep()
                }
                else
                {
                    
                }
            }
            else
            {
                timerPlaying = false
            }
        }
    }
}

#Preview
{
    ContentView()
}
