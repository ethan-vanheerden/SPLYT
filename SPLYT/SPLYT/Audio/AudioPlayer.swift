//
//  AudioPlayer.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 6/13/24.
//

import Foundation
import AVFoundation

protocol AudioPlayerType {
    func playSound(_ sound: Sound) throws
}

final class AudioPlayer: AudioPlayerType {
    private var audioSession: AVAudioSession
    private var audioPlayer: AVAudioPlayer?
    
    init(audioPlayer: AVAudioPlayer? = nil) {
        self.audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try audioSession.setActive(true)
        } catch { }
        
        self.audioPlayer = audioPlayer
    }
    
    deinit {
        do {
            try audioSession.setActive(false)
        } catch { }
    }
    
    
    func playSound(_ sound: Sound) throws {
        guard let url = Bundle.main.url(forResource: sound.fileName, withExtension: "mp3") else {
            throw AudioError.soundFileNotFound
        }
        
        audioPlayer = try AVAudioPlayer(contentsOf: url)
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()
        
        try audioSession.setActive(false)
    }
}

// MARK: - Errors

enum AudioError: Error {
    case soundFileNotFound
}
