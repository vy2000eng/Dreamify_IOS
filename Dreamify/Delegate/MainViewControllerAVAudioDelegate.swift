//
//  MainViewControllerAVAudioDelegate.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 7/26/25.
//
import UIKit
import AVFoundation



extension MainViewController:AVAudioRecorderDelegate{
   
    

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
}

