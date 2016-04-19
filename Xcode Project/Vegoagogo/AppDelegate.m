/*----------------------------------------------------------------------
     File: AppDelegate.m
   Author: Kevin Messina - Creative App Solutions, LLC - New York, USA
 Modifier:
  Created: April 8, 2014
 
 ©2014 Creative App Solutions, LLC. USA - All Rights Reserved
 ----------------------------------------------------------------------*/

#pragma mark - *** IMPORTS ***


@implementation AppDelegate


#pragma mark - *** INITIALIZE ***
-(void)initializeApp{
    /* Determine if database in docs dir is same version as in bundle otherwise needs updating. */
//    BOOL bUpdateDBisNeeded =[DVM_SF SQL_DoesDatabaseNamedNeedUpdating:kDB_DataName];
//    [DVM_SF SQL_UpdateIfNeededDatabaseNamed:kDB_DataName];
//    
//    if (bUpdateDBisNeeded) {
//        [self updateDB:kDB_DataName];
//    }
    
    NSUserDefaults *uDef = [NSUserDefaults standardUserDefaults];
    
    /* Is App Version Outdated */
    long iMajor =[uDef integerForKey:@"App_Version_Major"];
    long iMinor =[uDef integerForKey:@"App_Version_Minor"];
    long iBuild =[uDef integerForKey:@"App_Version_Build"];
    BOOL bAppNeedsUpdating =[DVM_SF APP_ReturnAppNeedsUpdating_Maj:(int)iMajor Min:(int)iMinor Build:(int)iBuild];
    if (bAppNeedsUpdating){
        NSDictionary *dictVersion =[DVM_SF APP_ReturnVersion];
        [uDef setObject:[NSString stringWithFormat:@"%@ (%@)",kAppVersionFull,kAppRevision] forKey:@"App_Version"];
        [uDef setInteger:[dictVersion[@"MajorNum"] intValue] forKey:@"App_Version_Major"];
        [uDef setInteger:[dictVersion[@"MinorNum"] intValue] forKey:@"App_Version_Minor"];
        [uDef setInteger:[dictVersion[@"BuildNum"] intValue] forKey:@"App_Version_Build"];
        [uDef synchronize];
    }
    
    BOOL bNotFirstLaunch =[[DVM_SF DEFAULTS_GetString:@"App_NotFirstLaunch" defaultVal:nil] isEqualToString:@"YES"];
    BOOL bForceInitialization =[DVM_SF DEFAULTS_GetBool:@"App_ForceFirstLaunch" defaultVal:NO testVal:YES];
    
    if (!bNotFirstLaunch || bForceInitialization){
        /* Set Initial UserDefaults Values */
        
        /* App */
        [uDef setObject:@"YES" forKey:@"App_NotFirstLaunch"];
        [uDef setBool:NO forKey:@"App_ForceFirstLaunch"];
        
        /* Settings */
        [uDef setBool:NO forKey:@"displayLogo"];
        [uDef setFloat:14.0f forKey:@"fontSize"];
        [uDef setBool:YES forKey:@"DisplayDark"];
        [uDef setObject:@"English" forKey:@"UserLanguage"];
        [uDef setObject:@"English" forKey:@"TranslationLanguage"];
        [uDef setInteger:0 forKey:@"SelectedQuestion"];
        [uDef setInteger:0 forKey:@"SelectedLanguage_Row"];
        [uDef setInteger:0 forKey:@"SelectedLanguage_Section"];

        /* Colors */
        NSDictionary *dictInfo;
        UIColor *topColor,*bottomColor;
        if (kAppIDNum == kVEG) {
            dictInfo =[DVM_SF SQL_Query:@"SELECT * FROM tblThemes where IsDefault=1;" db:kDB_Data].firstObject;
            [uDef setInteger:[self SQL_returnIndexForDefaultTheme] forKey:@"SelectedTheme"];
        }else{
            dictInfo =[DVM_SF SQL_Query:@"SELECT * FROM tblThemes where Name='Red Rock Canyon';" db:kDB_Data].firstObject;
            [uDef setInteger:[dictInfo[@"Indx"] intValue] forKey:@"SelectedTheme"];
        }

        NSArray *arrRGBA =[dictInfo[@"TopColor_RGBA"] componentsSeparatedByString:@","];
        topColor =[UIColor colorWithRed:([arrRGBA[0] floatValue] /255)
                                  green:([arrRGBA[1] floatValue] /255)
                                   blue:([arrRGBA[2] floatValue] /255)
                                  alpha:[arrRGBA[3] floatValue]];
        arrRGBA =[dictInfo[@"BottomColor_RGBA"] componentsSeparatedByString:@","];
        bottomColor =[UIColor colorWithRed:([arrRGBA[0] floatValue] /255)
                                     green:([arrRGBA[1] floatValue] /255)
                                      blue:([arrRGBA[2] floatValue] /255)
                                     alpha:[arrRGBA[3] floatValue]];
        
        NSData *fromColorData = [NSKeyedArchiver archivedDataWithRootObject:topColor];
        NSData *toColorData = [NSKeyedArchiver archivedDataWithRootObject:bottomColor];
        [uDef setObject:fromColorData forKey:@"fromColor"];
        [uDef setObject:toColorData forKey:@"toColor"];
        [uDef setBool:[dictInfo[@"TopColorIsLightColor"] boolValue] forKey:@"TopColorIsLightColor"];

        [uDef synchronize];
    }

    /* Set Update any missing defaults regardless of version */
    [self updateNewDefaultsIfNeeded];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"notification_UpdateBackground" object:nil];
    
    /* Set Appearance Proxies */
    [self setAppearanceProxies];
    
    /* Log Status Flags */
    if (bAppNeedsUpdating) [Flurry logEvent:@"App Needs Updating"];
    if (bNotFirstLaunch) [Flurry logEvent:@"App First Launch"];
    if (bForceInitialization) [Flurry logEvent:@"App Force First Launch"];
    
    /* Is Anything NEW in this version? */
//    if (bAppNeedsUpdating) [self ShowWhatsNew];
    
    // ToDo: Comment out for production */
//    [self ShowWhatsNew];
}

-(void)updateNewDefaultsIfNeeded{
    NSUserDefaults *uDef =[NSUserDefaults standardUserDefaults];

    if ([uDef objectForKey:@"fontSize"] ==nil) [uDef setFloat:14.0f forKey:@"fontSize"];
    if ([uDef objectForKey:@"DisplayDark"] ==nil) [uDef setBool:YES forKey:@"DisplayDark"];
    if ([uDef objectForKey:@"UserLanguage"] ==nil) [uDef setObject:@"English" forKey:@"UserLanguage"];
    if ([uDef objectForKey:@"TranslationLanguage"] ==nil) [uDef setObject:@"English" forKey:@"TranslationLanguage"];
    if ([uDef objectForKey:@"SelectedQuestion"] ==nil) [uDef setInteger:0 forKey:@"SelectedQuestion"];
    if ([uDef objectForKey:@"SelectedTheme"] ==nil) [uDef setInteger:[self SQL_returnIndexForDefaultTheme] forKey:@"SelectedTheme"];
    if ([uDef objectForKey:@"SelectedLanguage_Row"] ==nil) [uDef setInteger:0 forKey:@"SelectedLanguage_Row"];
    if ([uDef objectForKey:@"SelectedLanguage_Section"] ==nil) [uDef setInteger:0 forKey:@"SelectedLanguage_Section"];

    /* Colors */
    NSDictionary *dictInfo =[DVM_SF SQL_Query:@"SELECT * FROM tblThemes where IsDefault=1;" db:kDB_Data].firstObject;
    NSArray *arrRGBA =[dictInfo[@"TopColor_RGBA"] componentsSeparatedByString:@","];
        CGFloat red =([arrRGBA[0] floatValue] /255);
        CGFloat green =([arrRGBA[1] floatValue] /255);
        CGFloat blue =([arrRGBA[2] floatValue] /255);
        CGFloat alpha =[arrRGBA[3] floatValue];
    UIColor *topColor =[UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    
    arrRGBA =[dictInfo[@"BottomColor_RGBA"] componentsSeparatedByString:@","];
        red =([arrRGBA[0] floatValue] /255);
        green =([arrRGBA[1] floatValue] /255);
        blue =([arrRGBA[2] floatValue] /255);
        alpha =[arrRGBA[3] floatValue];
    UIColor *bottomColor =[UIColor colorWithRed:red green:green blue:blue alpha:alpha];

    NSData *fromColorData = [NSKeyedArchiver archivedDataWithRootObject:topColor];
    NSData *toColorData = [NSKeyedArchiver archivedDataWithRootObject:bottomColor];
    if ([uDef objectForKey:@"fromColor"] ==nil) [uDef setObject:fromColorData forKey:@"fromColor"];
    if ([uDef objectForKey:@"toColor"] ==nil) [uDef setObject:toColorData forKey:@"toColor"];
    if ([uDef objectForKey:@"displayLogo"] ==nil) [uDef setBool:NO forKey:@"displayLogo"];
    
    [uDef synchronize];
}

-(void)updateDB:(NSString*)sDB{
    //    NSNumberFormatter *numformat =[NSNumberFormatter new];
    //        numformat.positiveFormat =@"###.##";
    
    /* Get Current DB version */
    //    NSArray *arrCurrentDB =[DVM_SF SQL_Query:@"SELECT * FROM tblVersion ORDER BY version_Date DESC; "
    //                                          db:[DVM_SF FILES_ReturnDocumentsPath:sDB]];
    //    NSNumber *CurrentVersion =[numformat numberFromString:[arrCurrentDB.firstObject objectForKey:@"version_Name"]];
    
    /* Hard coded manual db updating */
    //    NSString *sDBFilePath =[DVM_SF FILES_ReturnDocumentsPath:kDB_Data];
    //    if ([CurrentVersion compare:[NSNumber numberWithDouble:2.11]] ==NSOrderedSame){ // a == b
    //        /* Make sure all KPI Names are NOT flagged as "Errors" EXCEPT for actual Errors */
    //        NSArray *arrInfo =[DVM_SF SQL_Query:@"SELECT * FROM tblKPI_Names"
    //                                         db:sDBFilePath];
    //
    //        NSString *sColumnName,*sQuery;
    //        BOOL bSuccess =YES;
    //        BOOL bThereWasAnError =NO;
    //
    //        for (int i=0; i <arrInfo.count; i++){
    //            sColumnName =[arrInfo[i] objectForKey:@"kpiNames_GroupName"];
    //            if ([sColumnName isEqualToString:@"Errors"]){
    //                sQuery =[NSString stringWithFormat:@"UPDATE tblKPI_Names SET kpiNames_IsError=%i, kpiNames_CanBeDeleted=%i "
    //                                                    "WHERE kpiNames_GroupName='%@';",
    //                                                    [[NSNumber numberWithBool:YES] intValue],
    //                                                    [[NSNumber numberWithBool:NO] intValue],
    //                                                    sColumnName];
    //            }else{
    //                sQuery =[NSString stringWithFormat:@"UPDATE tblKPI_Names SET kpiNames_IsError=%i, kpiNames_CanBeDeleted=%i "
    //                                                    "WHERE kpiNames_GroupName='%@';",
    //                                                    [[NSNumber numberWithBool:NO] intValue],
    //                                                    [[NSNumber numberWithBool:YES] intValue],
    //                                                    sColumnName];
    //            }
    //
    //            bSuccess =[DVM_SF SQL_NonQueryDB:sDBFilePath Query:sQuery arguments:nil];
    //            if (!bSuccess){
    //                bThereWasAnError =YES;
    //            }
    //        }
    //
    //        NSString *sMsg =(bThereWasAnError) ?@"There was a critical error configuring the new database, contact technical support."
    //                                           :@"Configuration completed successfully.";
    //
    //        [DVM_SF showAlertWithTitle:@"Database Settings" message:sMsg btnText:@"OK"];
    //    }
}


#pragma mark - *** CODING METHODS ***
-(void)setAppearanceProxies{
/* Switches */
    [[UISwitch appearance] setOnTintColor:kColor_SwitchOnGreen];
    [[UISwitch appearance] setTintColor:kColor_SwitchOffRed];

/* Search Bar */
    [[UILabel appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:kAppColor_Clouds];
    [[UILabel appearanceWhenContainedIn:[UISearchBar class], nil] setTintColor:kAppColor_Clouds];
}

-(void)ShowWhatsNew{
//    NSData *fromColorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"fromColor"];
//    UIColor *fromColor = [NSKeyedUnarchiver unarchiveObjectWithData:fromColorData];
//    NSData *toColorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"toColor"];
//    UIColor *toColor = [NSKeyedUnarchiver unarchiveObjectWithData:toColorData];
//
//    UIStoryboard *mainStoryboard =[UIStoryboard storyboardWithName:@"WhatsNew" bundle:nil];
//    VC_WhatsNew *vc =[mainStoryboard instantiateViewControllerWithIdentifier:@"WhatsNew"];
//        vc.fromColor =fromColor;
//        vc.toColor =toColor;
//        vc.textColor =[UIColor whiteColor];
//
//    [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
//
//    [Flurry logEvent:@"Whats New Displayed"];
}

-(void)copyFilesAppNeeds{
    /* SQL Database */
//    [DVM_SF FILES_copyFromMainBundleToDocsDirectoryFileNamed:kDB_Data];

    /* Create Folders */
//    BOOL bFolderExists =[DVM_SF FILES_DoesDirectoryExistNamed:@"Receipts" inDocuments:YES inLibraryCaches:NO inTemp:NO];
//    if (!bFolderExists){
//        BOOL bFolderCreated =[DVM_SF FILES_CreateNewDirectoryNamed:@"Receipts" inDocuments:YES inLibraryCaches:NO inTemp:NO];
//        if (!bFolderCreated){
//            [AppDelegate showAlert:@"FILE ERROR" style:AlertFailure btnText:@"OK" msg:@"Could not create Receipts Folder."];
//        }
//    }
}

-(void)setup_FlurryAnalytics{
    [Flurry startSession:(kAppTestMode ?kFlurryTestIDNum :kFlurryProdIDNum)];
    
    [DVM_SF DEBUG_ShowTitle: YES
                  titleText: (kAppTestMode ?[NSString stringWithFormat:@"Flurry Analytics: TEST ID: %@",kFlurryTestIDNum]
                              :[NSString stringWithFormat:@"Flurry Analytics: PROD ID: %@",kFlurryProdIDNum])
             showEndingLine: YES];
    
    [Flurry setSessionReportsOnCloseEnabled:YES];
}


-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
}


#pragma mark - *** SQL METHODS ***
-(int)SQL_returnIndexForDefaultTheme{
    NSArray *arrInfo =[DVM_SF SQL_Query:@"SELECT * FROM tblThemes WHERE IsDefault=1;" db:kDB_Data];
    
    if (arrInfo.count >0){
        return [[arrInfo.firstObject objectForKey:@"Indx"] intValue];
    }else{
        return 0;
    }
}


#pragma mark - *** EXTERNAL CODING METHODS ***
+(BOOL)SQL_GetLanguageAlignmentFor:(NSString*)sSearchFor{
    if (sSearchFor.length <1 || sSearchFor ==nil){
        sSearchFor =@"English";
    }

    NSString *sQuery =[NSString stringWithFormat:@"SELECT * FROM tblLanguages WHERE Name='%@'; ",sSearchFor];
    
    NSArray *arrInfo =[DVM_SF SQL_Query:sQuery db:kDB_Data];
    if (arrInfo.count >0) {
        return [[arrInfo.firstObject objectForKey:@"IsRightToLeft"] boolValue];
    }else{
        return NO;
    }
}

+(NSString*)SQL_GetLanguageForCode:(NSString*)sSearchFor{
    NSString *sUserDeviceLanguage =@"en";
    if (sSearchFor.length <1 || sSearchFor ==nil){
        sSearchFor =@"en";
    }
    
    sSearchFor =[sSearchFor substringWithRange:NSMakeRange(0,2)];
    
    NSArray *arrAppSupportedLanguages =[kSupportedLanguages componentsSeparatedByString:@","];
    for (NSString *sLangCode in arrAppSupportedLanguages){
        if ([sLangCode isEqualToString:sSearchFor]){
            sUserDeviceLanguage =sLangCode;
            break;
        }
    }

    NSString *sQuery =[NSString stringWithFormat:@"SELECT * FROM tblLanguages WHERE LanguageCode='%@';",sUserDeviceLanguage];

    NSArray *arrInfo =[DVM_SF SQL_Query:sQuery db:kDB_Data];
    if (arrInfo.count >0){
        sUserDeviceLanguage =[arrInfo.firstObject objectForKey:@"Name"];
        if (sUserDeviceLanguage.length <1 || sUserDeviceLanguage ==nil){
            sUserDeviceLanguage =@"English";
        }

        return sUserDeviceLanguage;
    }else{
        return @"English";
    }
}

+(AMSmoothAlertView*)showAlert:(NSString*)sTitle
                         style:(NSInteger)iStyle
                           btn:(NSString*)sText
                        cancel:(NSString*)sCancel
                           msg:(NSString*)sMsg{
    
    /* Outline the text for better legibility */
    NSMutableAttributedString *attributedString_Default =[[NSMutableAttributedString alloc] initWithString:sText];
        [attributedString_Default addAttribute:NSStrokeWidthAttributeName value:@-2.0f range:NSMakeRange(0,sText.length)];
        [attributedString_Default addAttribute:NSStrokeColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,sText.length)];
        [attributedString_Default addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,sText.length)];
    
    NSMutableAttributedString *attributedString_Cancel =[[NSMutableAttributedString alloc] initWithString:sCancel];
        [attributedString_Cancel addAttribute:NSStrokeWidthAttributeName value:@-2.0f range:NSMakeRange(0,sCancel.length)];
        [attributedString_Cancel addAttribute:NSStrokeColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,sCancel.length)];
        [attributedString_Cancel addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,sCancel.length)];

    NSData *toColorData =[[NSUserDefaults standardUserDefaults] objectForKey:@"toColor"];
    UIColor *toColor =[NSKeyedUnarchiver unarchiveObjectWithData:toColorData];
    
    AMSmoothAlertView *alert =[[AMSmoothAlertView alloc] initDropAlertWithTitle:sTitle
                                                                        andText:sMsg
                                                                andCancelButton:YES
                                                                   forAlertType:iStyle
                                                                       andColor:toColor];
    
    [alert.defaultButton setAttributedTitle:attributedString_Default forState:UIControlStateNormal];
    [alert.cancelButton setAttributedTitle:attributedString_Cancel forState:UIControlStateNormal];
    [alert show];
    
    return alert;
}

+(void)showAlert:(NSString*)sTitle style:(NSInteger)iStyle btnText:(NSString*)sText msg:(NSString*)sMsg{
    AMSmoothAlertView *alert =[[AMSmoothAlertView alloc] initDropAlertWithTitle:sTitle
                                                                        andText:sMsg
                                                                andCancelButton:NO
                                                                   forAlertType:iStyle];
    [alert.defaultButton setTitle:sText forState:UIControlStateNormal];
    [alert show];
}


#pragma mark - *** APP LIFECYCLE ***
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
-(NSUInteger)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return UIInterfaceOrientationMaskAll;
}
#else
-(UIInterfaceOrientationMask)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return UIInterfaceOrientationMaskPortrait;
}
#endif

-(BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
//    [self copyFilesAppNeeds];
    
    /* Splash screen delay */
    if ([DVM_SF DEVICE_IsSimulator] == true) {
        [DVM_SF DEBUG_ShowAppInfoInDebug]; //--- Show initialization info in console.
        [DVM_SF SQL_returnDatabaseVersionFor:kDB_DataName filePath:kDB_Data displayToLog:YES];
        NSLog(@"\n");
        [DVM_SF LIB_ReturnSFVersion];
        /* Use path copied form Console, open new Finder window, select >Go >Folder & paste. */
        NSLog(@"\n\nSandobx Documents Directory:\n----------------------------\n%@\n\n",[DVM_SF FILES_ReturnDocumentsPath:@""]);
    }else{
        [NSThread sleepForTimeInterval:1.5f];
    }
    
    /* Launch Flurry Analytics */
    [self setup_FlurryAnalytics];
    [Flurry logEvent:@"Application: New Launch"];
    
    /* Launch AppiRater */
    [DVM_SF APPIRATER_SetupWithID:kAppleIDNum Days:1 Uses:10 Events:-1 Remind:2 setDebug:NO]; // ToDo: Make sure this is NO
    if ([kAppID isEqualToString:@"VEG"]){//Use to override default app name when using multiple editions.
        [DVM_SF APPIRATER_SetupAppName:NSLocalizedString(@"APPIRATOR_AppFullName_VEG",nil)];
    }else if ([kAppID isEqualToString:@"VGN"]){
        [DVM_SF APPIRATER_SetupAppName:NSLocalizedString(@"APPIRATOR_AppFullName_VGN",nil)];
    }
    [DVM_SF APPIRATER_SetDebug:false]; //To Test Edition Names
    
    /* Launch Crashlytics */
    if ([DVM_SF DEVICE_IsSimulator] == false){ //Uncomment to register new Edition or Target in app with Crashlytics.
        [Crashlytics startWithAPIKey:@"940d5371666d7a1b9fc4f31c09c2d525419ac49a"]; // APIKey: Company Identifier
        [[Crashlytics sharedInstance] setDebugMode:(YES)];
        [Fabric with:@[CrashlyticsKit]];
        /* CAS */
        [[Crashlytics sharedInstance] setUserIdentifier:@"761cccf2cbfd07a2f4a7dc4e35f5e1c67711a8e1"];
        [[Crashlytics sharedInstance] setUserName:@"Kevin Messina (iPhone 5s)"];
        [[Crashlytics sharedInstance] setUserEmail:@"KMWeb@Mac.com"];
        /* Client */
        [[Crashlytics sharedInstance] setUserIdentifier:@"5ddbfb626e0bf10e5aaa8ad9213e2fda6657dbae"];
        [[Crashlytics sharedInstance] setUserName:@"Paul Dodson (iPhone 4)"];
        [[Crashlytics sharedInstance] setUserEmail:@"editor@2camels.com"];
    }
    
    /* Initialize App */
    [self initializeApp];
    
    /* Setup Window */
    self.window.frame =[UIScreen mainScreen].bounds;
    self.window.backgroundColor =[UIColor blackColor];
    self.window.opaque =kOPAQUE;
    [self.window makeKeyAndVisible];

    /* Is app current version? */
    NSString *sURL =[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",kAppleIDNum];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[[NSURL alloc] initWithString:sURL]]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
       if (!error) {
            NSError* parseError;
            id appMetadataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseError];
            if (appMetadataDictionary) {
                // compare version with your apps local version
                NSArray *arrInfo =[appMetadataDictionary objectForKey:@"results"];
                NSDictionary *dictInfo =[arrInfo firstObject];
                NSString *iTunesVersion = [dictInfo objectForKey:@"version"];
                NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)@"CFBundleShortVersionString"];
                float iTunesVer = iTunesVersion.floatValue;
                float appVer = appVersion.floatValue;
                if (iTunesVer > appVer) { // new version exists
                    AMSmoothAlertView *alert =[AppDelegate showAlert:@"New Version Available"
                                                               style:AlertInfo
                                                                 btn:@"Update"
                                                              cancel:@"Skip"
                                                                 msg:@"Update to install new features and/or fixes."];
                    alert.completionBlock = ^void (AMSmoothAlertView *alertObj,UIButton *button) {
                        if(button ==alertObj.cancelButton) {
                            [Flurry logEvent:@"NEW APP VERSION: User selected SKIP"];
                        }else{
                            [Flurry logEvent:@"NEW APP VERSION: User selected UPDATE"];
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppStoreUpdateURL]];
                        }
                    };
               }
           }
       }else{
           // error occurred with http(s) request
           NSLog(@"error occurred communicating with iTunes");
       }
   }];

    /* Setup Main RootViewController first view to display */
    self.window.rootViewController =[[UIStoryboard storyboardWithName:@"Main_iPhone"
                                                               bundle:nil]
                              instantiateViewControllerWithIdentifier:@"VC_Main"];
    
    return YES;
}

-(void)applicationWillResignActive:(UIApplication *)application{
}

-(void)applicationDidEnterBackground:(UIApplication *)application{
}

-(void)applicationWillEnterForeground:(UIApplication *)application{
    [DVM_SF APPIRATER_AppEnteredForeground];
}

-(void)applicationDidBecomeActive:(UIApplication *)application{
    /* If user left app before Initialization was completed, then they should skip all other code */
    if (([DVM_SF DEFAULTS_GetString:@"App_NotFirstLaunch" defaultVal:nil] == nil) ||
        ([DVM_SF DEFAULTS_GetBool:@"App_ForceFirstLaunch" defaultVal:NO testVal:YES] == YES)) {
        [self initializeApp];
    }

    /* If testmode, set defaults */
    if (kAppTestMode ==YES){
//        NSUserDefaults *uDef = [NSUserDefaults standardUserDefaults];
//            [uDef setBool:YES forKey:@"IAP_ClientPack"];
//        [uDef synchronize];
    }
}

-(void)applicationWillTerminate:(UIApplication *)application{
}

-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    [Flurry logEvent:@"Application: Received LOW Memory Warning From O/S."];
    NSLog(@"Memory Warning Issued");
}


@end
