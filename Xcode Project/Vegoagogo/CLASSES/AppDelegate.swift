/*--------------------------------------------------------------------------------------------------------------------------
   File: AppDelegate.swift
 Author: Kevin Messina
Created: October 24, 2013

©2015 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES: Converted to Swift Jun 18, 2015
--------------------------------------------------------------------------------------------------------------------------*/

// MARK: - *** GLOBAL CONSTANTS ***
var window: UIWindow?
var LowMemorySave:Bool! = false
let AppEdition:String! = appInfo().getEdition()


// MARK: - *** APPLICATION ***


// ToDo: Uncomment UIApplicationMain and remove 2 from class name below

//@UIApplicationMain
class AppDelegate2: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

// MARK: - *** INITIALIZATION ***
    func setup_InitializeApp() -> Void {
        /* Initialize Globals */
        gBundle = UIStoryboard(name:UIDevice.currentDevice().is_iPad ?"Main_iPad" :"Main_iPhone", bundle:nil)

        /* Initialize Defaults */
        let uDef:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        /* Is App Version Outdated */
        let iMajor:Int32! = Int32(uDef.integerForKey("App_Version_Major"))
        let iMinor:Int32! = Int32(uDef.integerForKey("App_Version_Minor"))
        let iBuild:Int32! = Int32(uDef.integerForKey("App_Version_Build"))
        let bAppNeedsUpdating:Bool! = DVM_SF.APP_ReturnAppNeedsUpdating_Maj(iMajor, min: iMinor, build: iBuild)

        if (bAppNeedsUpdating == true) {
            let dictVersion:NSDictionary! = DVM_SF.APP_ReturnVersion() as NSDictionary
            uDef.setObject("\(sharedFunc.APP().fullVersion) (\(appInfo.EDITION.Revision))", forKey:"App_Version")
            uDef.setInteger(dictVersion["MajorNum"] as? Int ?? 0, forKey:"App_Version_Major")
            uDef.setInteger(dictVersion["MinorNum"] as? Int ?? 0, forKey:"App_Version_Minor")
            uDef.setInteger(dictVersion["BuildNum"] as? Int ?? 0, forKey:"App_Version_Build")
            uDef.synchronize()
        }
        
        let bNotFirstLaunch:Bool! = (sharedFunc.DEFAULTS().getString(key: "App_NotFirstLaunch", defaultValue: nil) == "YES")
        let bForceInitialization:Bool! = sharedFunc.DEFAULTS().getBool(key: "App_ForceFirstLaunch", defaultValue: false)
        
        if ((bNotFirstLaunch == false) || (bForceInitialization == true)){
            /* Initialization */
            uDef.setObject("YES", forKey:"App_NotFirstLaunch")
            uDef.setBool(false, forKey:"App_ForceFirstLaunch")

            /* App Defaults */
            uDef.setBool(false, forKey:"displayLogo")
            uDef.setBool(false, forKey:"DisplayDark")
            uDef.setFloat(14.0, forKey:"fontSize")
            uDef.setInteger(0, forKey: "SelectedQuestion")
            uDef.setInteger(0, forKey: "SelectedLanguage_Row")
            uDef.setInteger(0, forKey: "SelectedLanguage_Section")
            uDef.setObject("English", forKey:"UserLanguage")
            uDef.setObject("English", forKey:"TranslationLanguage")

            /* Theme/Color Defaults */
            var info:NSDictionary!
            if appInfo.EDITION.AppID == "VEG" {
                let query:String! = "SELECT * FROM tblThemes WHERE IsDefault=1;"
                info = DVM_SF.SQL_Query(query, db: appInfo.DB.Data).first as? NSDictionary ?? nil
                uDef.setInteger(SQL_returnIndexForDefaultTheme(), forKey: "SelectedTheme")
            }else{
                let query = "SELECT * FROM tblThemes where Name='Red Rock Canyon';"
                info = DVM_SF.SQL_Query(query, db: appInfo.DB.Data).first as? NSDictionary ?? nil
                uDef.setInteger(info.objectForKey("Indx") as! Int, forKey: "SelectedTheme")
            }

            var topColor,bottomColor:UIColor!
            var arrRGBA:NSArray! = (info.objectForKey("TopColor_RGBA") as! String).componentsSeparatedByString(",")
            topColor = UIColor(red: CGFloat(arrRGBA[0].floatValue / 255), green: CGFloat(arrRGBA[1].floatValue / 255), blue: CGFloat(arrRGBA[2].floatValue / 255), alpha: CGFloat(arrRGBA[3].floatValue))
            arrRGBA = (info.objectForKey("BottomColor_RGBA") as! String).componentsSeparatedByString(",")
            bottomColor = UIColor(red: CGFloat(arrRGBA[0].floatValue / 255), green: CGFloat(arrRGBA[1].floatValue / 255), blue: CGFloat(arrRGBA[2].floatValue / 255), alpha: CGFloat(arrRGBA[3].floatValue))
            
            uDef.setObject(NSKeyedArchiver.archivedDataWithRootObject(topColor), forKey:"fromColor")
            uDef.setObject(NSKeyedArchiver.archivedDataWithRootObject(bottomColor), forKey:"toColor")
            uDef.setBool(info.objectForKey("TopColorIsLightColor") as! Bool, forKey:"TopColorIsLightColor")
            
            uDef.synchronize()
        }

        /* Set Appearance Proxies */
        setup_AppearanceProxies()
        
        /* Log Status Flags */
        if (bAppNeedsUpdating == true) { Flurry.logEvent("App Needs Updating") }
        if (bNotFirstLaunch == true) { Flurry.logEvent("App First Launch") }
        if (bForceInitialization == true) { Flurry.logEvent("App Force First Launch") }
    }
    

// MARK: - *** APPEARANCE ***
    func setup_AppearanceProxies() -> Void {
        /* Switches */
        UISwitch.appearance().onTintColor = Color.Controls.SwitchOnGreen
        UISwitch.appearance().tintColor = Color.Controls.SwitchOnGreen
    }

    
// MARK: - *** FUNCTIONS ***
    
    
// MARK: - *** SQL METHODS ***
    func SQL_returnIndexForDefaultTheme() -> Int {
        let query = "SELECT * FROM tblThemes WHERE IsDefault=1;"
        let info:NSDictionary! = DVM_SF.SQL_Query(query, db: appInfo.DB.Data).first as? NSDictionary ?? nil
    
        return (info != nil) ? info.objectForKey("Indx") as? Int ?? 0 :0
    }


// MARK: - *** LIFECYCLE ***
    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
        let orientation:UIInterfaceOrientationMask = [UIInterfaceOrientationMask.All]
        return orientation
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        /* Splash screen delay */
        if UIDevice.currentDevice().is_Simulator {
            sharedFunc.APP().showInfo()
//            sleep(1)
        }else{
            sleep(1)
        }

        /* FLURRY */
        Flurry.startSession(sharedFunc.APP().isTestMode() ?appInfo.FLURRY.TestID :appInfo.FLURRY.LiveID)
        Flurry.setSessionReportsOnCloseEnabled(true)
        Flurry.logEvent("Application: New Launch")

        /* APPIRATER */
        DVM_SF.APPIRATER_SetupWithID(String(appInfo.EDITION.AppIDNum), days: 1, uses: 10, events: -1, remind: 2, setDebug: false)
        switch appInfo.EDITION.AppID {
            case "VEG": DVM_SF.APPIRATER_SetupAppName(NSLocalizedString("APPIRATOR_AppFullName_VEG", comment: ""))
            case "VGN": DVM_SF.APPIRATER_SetupAppName(NSLocalizedString("APPIRATOR_AppFullName_VGN", comment: ""))
            default: ()
        }
        // ToDo: Make sure this is false for production
        DVM_SF.APPIRATER_SetDebug(false) //To Test Edition Names

        /* CRASHLYTICS */
        /* Configure Fabric, Crashlytics & Answers */
        if sharedFunc.APP().isTestAndBetaMode() == false {
            sharedFunc.FABRIC().SetupCrashlytics()
            sharedFunc.FABRIC().setDeveloperDevices(name: appInfo.DEVELOPER.Device_UserName,email: appInfo.DEVELOPER.Device_EMail,
                iPhone5s: true,iPhone6sPlus: true,iPad3: false, iPadAir2: false)
            sharedFunc.FABRIC().setAnswers_UserInfo()
            sharedFunc.FABRIC().SetupUser(name:"Paul Dodson",device:"iPhone 4",email:"editor@2camels.com",UDID:"5ddbfb626e0bf10e5aaa8ad9213e2fda6657dbae")
        }

        /* Set Window */
        let frame = UIScreen.mainScreen().bounds
        window = UIWindow(frame: frame)
        window?.makeKeyAndVisible()
        
        /* Is app current version in App Store? */
        sharedFunc.APP().newerVersionOnItunes()
        
        /* Set View Controller */
        let vc = gBundle.instantiateViewControllerWithIdentifier("Main") as! VC_Main
        self.window!.rootViewController = vc
        
        setup_InitializeApp()
        setup_AppearanceProxies()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
        DVM_SF.APPIRATER_AppEnteredForeground()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        DVM_SF.APPIRATER_AppEnteredForeground()
    }

    func applicationDidBecomeActive(application: UIApplication) {
        /* If user left app before Initialization was completed, then they should skip all other code */
        let isFirstLaunch:String! = sharedFunc.DEFAULTS().getString(key: "App_NotFirstLaunch", defaultValue: nil)
        let forceFirstLaunch:Bool! = sharedFunc.DEFAULTS().getBool(key: "App_ForceFirstLaunch", defaultValue: false)
        
        if ((isFirstLaunch == nil) || (forceFirstLaunch == true)) {
            setup_InitializeApp()
        }
    }

    func applicationWillTerminate(application: UIApplication) {
    }

    func applicationDidReceiveMemoryWarning(application: UIApplication) {
        LowMemorySave = true
        
        Flurry.logEvent("Application: Received LOW Memory Warning From O/S.")
        NSLog("Memory Warning Issued")
    }
}

