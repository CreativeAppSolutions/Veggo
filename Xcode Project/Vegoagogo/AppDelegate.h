/*----------------------------------------------------------------------
     File: AppDelegate.h
   Author: Kevin Messina - Creative App Solutions, LLC - New York, USA
 Modifier:
  Created: April 8, 2014
 
 ©2014 Creative App Solutions, LLC. USA - All Rights Reserved
 ----------------------------------------------------------------------*/

/* ToDo: - Disable NSZombies debugger setting before production.
 - Turn off TestMode - make default on intialize OFF
 - Remove R&D Settings from Settings.Bundle
 */

#pragma mark - *** DEFINITIONS ***
    #define kAppStoreUpdateURL   @"itms-apps://itunes.com/apps/PaulDodson/veggoagogo"//TODO: Update
    #define kAppStoreExtURL      @"http://itunes.com/apps/PaulDodson" // Set App Store URL to App
    #define kAppWebsite_URL      @"http://www.Veggoagogo.com" //TODO: Make sure these are correct before launch.
    #define kAppSupport_URL      @"http://www.Veggoagogo.com"//TODO: Make sure these are correct before launch.
    #define kAppSupport_Email    @"support@agogoapps.com"
    #define kAppPhoneNum         @"tel://"
    #define kCopyright_Statement @"All Rights Reserved."
    #define kCopyright_Company   @"2Camels Publishing"
    #define kCopyright_Co_Loc    @"2Camels Publishing (Helsinki, Finland)"
    #define kDev_Name            @"Creative App Solutions"
    #define kDev_Name_Loc        @"Creative App Solutions (New York, USA)"
    #define kDev_URL             @"www.CreativeApps.us"
    #define kYouTubeURL          @""
    #define kFaceBookURL         @""
    #define kTwitterURL          @""

/* App Specific Definitions */

/* Database Definitions */
    #define kDB_DataName        @"data.db"
    #define kDB_Data            [DVM_SF FILES_ReturnMainBundlePath:kDB_DataName fileType:@""]

/* Custom Colors */
    #define kAppColor_MidnightBlue   [UIColor colorWithRed:0.145 green:0.184 blue:0.239 alpha:1.000]
    #define kAppColor_PeterRiver     [UIColor colorWithRed:0.282 green:0.514 blue:0.796 alpha:1.000]
    #define kAppColor_Emerald        [UIColor colorWithRed:0.365 green:0.733 blue:0.373 alpha:1.000]
    #define kAppColor_Clouds         [UIColor colorWithRed:0.914 green:0.929 blue:0.933 alpha:1.000]
    #define kAppColor_Silver         [UIColor colorWithRed:0.694 green:0.710 blue:0.733 alpha:1.000]
    #define kAppColor_Amethyst       [UIColor colorWithRed:0.486 green:0.286 blue:0.647 alpha:1.000]


#pragma mark - *** CLASS DELEGATES ***
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;

#pragma mark - *** GLOBAL ACTIONS ***
+(BOOL)SQL_GetLanguageAlignmentFor:(NSString*)sSearchFor;
+(NSString*)SQL_GetLanguageForCode:(NSString*)sSearchFor;
+(void)showAlert:(NSString*)sTitle style:(NSInteger)iStyle btnText:(NSString*)sText msg:(NSString*)sMsg;
+(AMSmoothAlertView*)showAlert:(NSString*)sTitle
                         style:(NSInteger)iStyle
                           btn:(NSString*)sText
                        cancel:(NSString*)sCancel
                           msg:(NSString*)sMsg;

@end
