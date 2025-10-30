//
//  Structs.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 9/20/25.
//

struct PlayPauseController{
    var dream:DreamViewModel?
    var isPlaying:Bool
    var indexThatIsCurrentlyPlaying:Int?

        
}
enum ControllerManagedByAudioPlayerClass:Int{
    
   case DreamViewController
   case  CalendarViewController
}
