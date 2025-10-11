//
//  MainViewControllerAVAudioDelegate.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 7/26/25.
//
import UIKit
import AVFoundation



extension MainViewController:AVAudioRecorderDelegate, DeleteSectionFromCollectionView{
   
    func deleteRecording(id:UUID) {
        print("mvc delegat called")
        do{
            try self.dreamsRecordingViewModel.removeDreamFromArray(id: id)//removeDreamByIDFromArray(id:id)//removeDreamFromArray(id: dream.id)
        
        }catch let err{
            print("an error occured whilst removing dream from collection view in dreamRecordingViewController: \(err)")
        }
    }
    

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
}

