//
//  SoundEffectService.swift
//  Studium
//
//  Created by Vikram Singh on 8/13/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import AVFoundation

class SoundEffectService {
    private var player: AVAudioPlayer?
    static let shared = SoundEffectService()
    
    private init() { }
    
    func playSuccessSound() {
        guard let path = Bundle.main.path(forResource: "celebration", ofType: "wav") else {
            return
        }
        
        let url = URL(fileURLWithPath: path)
        do {
            self.player = try AVAudioPlayer(contentsOf: url)
            self.player?.play()
        } catch let error {
            Log.e(error)
        }
    }
}
