/*--------------------------------------------------------------------------------------------------------------------------
   File: AppInfo.swift
 AVGNhor: Kevin Messina
Created: June 18, 2015

©2015 Creative App SolVGNions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

// MARK: - *** GLOBAL CONSTANTS ***
/* Assign Custom Classes */

/* Assign Global Variables */
var gBundle:UIStoryboard! = UIStoryboard(name:UIDevice.currentDevice().is_iPad ?"Main_iPad" :"Main_iPhone", bundle:nil)

// MARK: - *** APPINFO CLASS *** -
final class appInfo {
    //TODO: Make sure these are correct before launch.

    let kVEG:Int! = 0
    let kVGN:Int! = 1

    struct DEVELOPER {
        static let Name:String!                     = "Creative App Solutions"
        static let Location:String!                 = "NEW YORK - USA       www.CreativeApps.US"
        static let URL:String!                      = "http://www.CreativeApps.US"
        static let Device_UserName:String!          = "Kevin Messina"
        static let Device_EMail:String!             = "KMWeb@Mac.com"
        static let Device_UDID_iPhone5s:String!     = "761cccf2cbfd07a2f4a7dc4e35f5e1c67711a8e1"
        static let Device_UDID_iPhone6sPlus:String! = "a4eb631086b0a43dac3b3b1faa83ca8339f8ccea"
        static let Device_UDID_iPad3:String!        = "8dbca97d213e2e8ec2309e5f44bb7e81be220ee9"
    }

    struct COPYRIGHT {
        static let Year:String!   = (AppEdition == "VEG") ?EDITION_VEG.Year :
                                                           EDITION_VGN.Year
        static let Rights:String! = "All Rights Reserved."
    }

    struct COMPANY {
        static let Name:String!         = (AppEdition == "VEG") ?EDITION_VEG.CompanyName :
                                                                 EDITION_VGN.CompanyName
        static let Location:String!     = (AppEdition == "VEG") ?EDITION_VEG.Location :
                                                                 EDITION_VGN.Location
        static let Website_URL:String!  = (AppEdition == "VEG") ?EDITION_VEG.Website_URL :
                                                                 EDITION_VGN.Website_URL
        static let YouTube_URL:String!  = (AppEdition == "VEG") ?EDITION_VEG.YouTube_URL :
                                                                  EDITION_VGN.YouTube_URL
        static let FaceBook_URL:String! = (AppEdition == "VEG") ?EDITION_VEG.FaceBook_URL :
                                                                 EDITION_VGN.FaceBook_URL
        static let Twitter_URL:String!  = (AppEdition == "VEG") ?EDITION_VEG.Twitter_URL :
                                                                 EDITION_VGN.Twitter_URL
        static let Support_URL:String!      = "http://www.Veggoagogo.com"
        static let SupportEmail:String!     = "support@agogoapps.com"
        static let Website_VEG_URL:String!  = "http://agogoapps.com/veggoagogo/"
        static let Website_VGN_URL:String!  = "http://agogoapps.com/veganagogo/"
    }

    struct FABRIC {
        static let APIKey:String! = (AppEdition == "VEG") ?EDITION_VEG.FabricAPIKey
                                                          :EDITION_VGN.FabricAPIKey
    }

    struct FLURRY {
        static let TestID:String! = (AppEdition == "VEG") ?EDITION_VEG.TestID :
                                                           EDITION_VGN.TestID
        static let LiveID:String! = (AppEdition == "VEG") ?EDITION_VEG.LiveID :
                                                           EDITION_VGN.LiveID
    }

    struct EDITION {
        static let Revision:String!  = (AppEdition == "VEG") ?EDITION_VEG.Revision :
                                                              EDITION_VGN.Revision
        static let Name:String!      = (AppEdition == "VEG") ?EDITION_VEG.Name :
                                                             EDITION_VGN.Name
        static let FullName:String!  = (AppEdition == "VEG") ?EDITION_VEG.FullName :
                                                              EDITION_VGN.FullName
        static let AppID:String!     = (AppEdition == "VEG") ?EDITION_VEG.AppID :
                                                              EDITION_VGN.AppID
        static let AppIDNum:Int!     = (AppEdition == "VEG") ?EDITION_VEG.AppIDNum :
                                                              EDITION_VGN.AppIDNum
        static let SupportedLanguages:String!   = (AppEdition == "VEG") ?EDITION_VEG.SupportedLanguages :
                                                                         EDITION_VGN.SupportedLanguages
        static let AppStore_URL:String!         = (AppEdition == "VEG") ?EDITION_VEG.AppStore_URL :
                                                                         EDITION_VGN.AppStore_URL
        static let AppStoreExt_URL:String!      = (AppEdition == "VEG") ?EDITION_VEG.AppStoreExt_URL :
                                                                         EDITION_VGN.AppStoreExt_URL
        static let AppStoreAppleID:String!      = (AppEdition == "VEG") ?EDITION_VEG.AppStoreAppleID :
                                                                         EDITION_VGN.AppStoreAppleID
        static let WhatsNewFilename:String!     = (AppEdition == "VEG") ?EDITION_VEG.WhatsNewFilename :
                                                                         EDITION_VGN.WhatsNewFilename
        static let HelpFilename:String!         = (AppEdition == "VEG") ?EDITION_VEG.HelpFilename :
                                                                         EDITION_VGN.HelpFilename
        static let Website_URL:String!          = (AppEdition == "VEG") ?EDITION_VEG.Website_URL :
                                                                         EDITION_VGN.Website_URL
        static let YouTube_URL:String!          = (AppEdition == "VEG") ?EDITION_VEG.YouTube_URL :
                                                                         EDITION_VGN.YouTube_URL
        static let FaceBook_URL:String!         = (AppEdition == "VEG") ?EDITION_VEG.FaceBook_URL :
                                                                         EDITION_VGN.FaceBook_URL
        static let Twitter_URL:String!          = (AppEdition == "VEG") ?EDITION_VEG.Twitter_URL :
                                                                         EDITION_VGN.Twitter_URL
        static let LinkedIn_URL:String!         = (AppEdition == "VEG") ?EDITION_VEG.LinkedIn_URL :
                                                                         EDITION_VGN.LinkedIn_URL
        static let GooglePlus_URL:String!       = (AppEdition == "VEG") ?EDITION_VEG.GooglePlus_URL :
                                                                         EDITION_VGN.GooglePlus_URL
    }

    struct EDITION_VEG {
        static let Revision:String!             = "a"
        static let Name:String!                 = "Veggoagogo"
        static let FullName:String!             = "Veggoagogo"
        static let AppID:String!                = "VEG"
        static let AppIDNum:Int!                = appInfo().kVEG
        static let SupportedLanguages:String!   = "en"
        static let AppStore_URL:String!         = "itms-apps://itunes.com/apps/PaulDodson/veggoagogo"
        static let AppStoreExt_URL:String!      = "http://itunes.com/apps/PaulDodson"
        static let AppStoreAppleID:String!      = "934078560"
        static let WhatsNewFilename:String!     = ""
        static let HelpFilename:String!         = ""
        static let Year:String!                 = "2015"
        static let FabricAPIKey:String!         = "940d5371666d7a1b9fc4f31c09c2d525419ac49a"
        static let TestID:String!               = "JTNBHCDZYVZP2TFS3VPH"
        static let LiveID:String!               = "8V69XSY54XN3J8NVBB84"
        static let CompanyName:String!          = "2Camels Publishing"
        static let Location:String!             = "Helsinki, Finland"
        static let Website_URL:String!          = "http://agogoapps.com"
        static let YouTube_URL:String!          = ""
        static let FaceBook_URL:String!         = "https://www.facebook.com/pages/Veggoagogo-by-Agogo-Apps/1515901902019635"
        static let Twitter_URL:String!          = "https://twitter.com/agogoapps"
        static let LinkedIn_URL:String!         = "https://www.linkedin.com/company/agogo-apps"
        static let GooglePlus_URL:String!       = "https://plus.google.com/+AgogoGuruApps/posts"
    }

    struct EDITION_VGN {
        static let Revision:String!             = "a"
        static let Name:String!                 = "Veganagogo"
        static let FullName:String!             = "Veganagogo"
        static let AppID:String!                = "VGN"
        static let AppIDNum:Int!                = appInfo().kVGN
        static let SupportedLanguages:String!   = "en"
        static let AppStore_URL:String!         = "itms-apps://itunes.com/apps/PaulDodson/veganagogo"
        static let AppStoreExt_URL:String!      = "http://itunes.com/apps/PaulDodson"
        static let AppStoreAppleID:String!      = "992542071"
        static let WhatsNewFilename:String!     = ""
        static let HelpFilename:String!         = ""
        static let Year:String!                 = "2015"
        static let FabricAPIKey:String!         = ""
        static let TestID:String!               = "2SRM2MKKZGH33HGY8V3Q"
        static let LiveID:String!               = "RYVC5FPN3QG7K8FFM3MR"
        static let CompanyName:String!          = "2Camels Publishing"
        static let Location:String!             = "Helsinki, Finland"
        static let Website_URL:String!          = "http://agogoapps.com"
        static let YouTube_URL:String!          = ""
        static let FaceBook_URL:String!         = "https://www.facebook.com/pages/Veggoagogo-by-Agogo-Apps/1515901902019635"
        static let Twitter_URL:String!          = "https://twitter.com/agogoapps"
        static let LinkedIn_URL:String!         = "https://www.linkedin.com/company/agogo-apps"
        static let GooglePlus_URL:String!       = "https://plus.google.com/+AgogoGuruApps/posts"
    }

    struct DB {
        static let DataName:String!         = "data.db"
        static let Data:String!             = sharedFunc.FILES().dirMainBundle(DataName)

        /* Array of all above items for About screens */
        static let arrayOf = [
            ["Application Data",DB.Data,sharedFunc.FILES().dirMainBundle(DB.DataName)]
            ]
    }
    
    struct COLLECTIONS {
        static let Themes:Int!      = 0
        static let Apps:Int!        = 1
        static let Links:Int!       = 2
    }

    struct FONTS {
        static let kFontTitle          = "HelveticaNeue-CondensedBold"
        static let kFontTitleItalic    = "HelveticaNeue-boldItalic"
        static let kFontTitleBold      = "HelveticaNeue-Bold"
        static let kFontBody           = "HelveticaNeue"
        static let kFontBodyItalic     = "HelveticaNeue-BoldItalic"
        static let kFontBodyBold       = "HelveticaNeue-Bold"
        static let kFontBVGNton         = "HelveticaNeue-CondensedBold"
    }
    
    func getEdition() -> String {
        #if TARGET_VEG
            return "VEG"
        #elseif TARGET_VEGAN
            return "VGN"
        #else
            return "VEG"
        #endif
    }
}
