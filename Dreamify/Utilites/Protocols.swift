//
//  Protocols.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 9/20/25.
//


import UIKit
import Foundation
protocol PresentErrIfAnalysisFails:AnyObject{
    func presentUiAlertErr(title:String, errMessage:String) -> Void
}

protocol AddNewRecordingToCollectionView:AnyObject{
    func updateCollection(controllerMangedByDataSource:ControllerManagedByAudioPlayerClass) throws -> Void
}

protocol RetrieveCurrentlySelectedDate: AnyObject{
    
    func retrieveCurrentlySelectedDate() -> Date
    
}

protocol DeleteSectionFromCollectionView:AnyObject{
    func deleteRecording(id:UUID) throws -> Void
}

protocol UserIsLoggedInChangeAccountMAnagementOptions:AnyObject{
    func userIsLoggedInChangeAccountMAnagementOptions() ->Void
    
}

protocol UpdateDreamTitleAndTranscription:AnyObject{
    func updateTitleAndDescriptionInCollection() throws -> Void
}
