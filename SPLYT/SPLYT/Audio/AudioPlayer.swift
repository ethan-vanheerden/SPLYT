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
    private var audioPlayer: AVAudioPlayer?
    
    func playSound(_ sound: Sound) throws {
        guard let url = Bundle.main.url(forResource: sound.fileName, withExtension: "mp3") else {
            throw AudioError.soundFileNotFound
        }
        
        audioPlayer = try AVAudioPlayer(contentsOf: url)
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()
    }
}

// MARK: - Errors

enum AudioError: Error {
    case soundFileNotFound
}
