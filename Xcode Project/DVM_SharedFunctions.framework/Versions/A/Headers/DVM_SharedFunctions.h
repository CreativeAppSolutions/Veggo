/*--------------------------------------------------------------------------------------------------------------------------
 
 Filename: SharedFunctions.h
 Library: DVM_SharedFunctions.a
 Devices: Apple UNIVERSAL
 Author: Kevin Messina
 
 REQUIRES THE FOLLOWING FRAMEWORK HEADERS TO BE INCLUDED IN PROJECT: (Note: netinet is not a framework)
 <QuartzCore/QuartzCore.h>
 <SystemConfiguration/SystemConfiguration.h>
 <AVFoundation>
 <sqlite3.h>
 <Accelerate Framework"
 
 (These should already be in standard project)
 <Foundation/Foundation.h>
 <netinet/in.h>
 <UIKit/UIKit.h>
 <float.h>
 
 
 ©2009-2014 DVMagic Studios, Inc. - All Rights Reserved.
 --------------------------------------------------------------------------------------------------------------------------*/

#pragma mark ------ SHARED FUNCTIONS ------
#pragma mark - *** IMPORT FILES ***
@import UIKit;
@import Foundation;
@import AVFoundation;
@import QuartzCore;
@import SystemConfiguration;
@import Accelerate;
#import <netinet/in.h>
#import <float.h>
#import "SQLite3.h"


@interface DVM_SF: NSObject {}

#pragma mark - *** REUSABLE FUNCTIONS ***
#define RECTLOG(rect) (NSLog(@"" #rect @" x:%0.0f y:%0.0f w:%0.0f h:%0.0f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height));
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

+(void)fadeVisible:(UIView*)itemToFade Duration:(float)fDuration MaxAlpha:(float)fMaxAlpha;
+(void)showAlertWithTitle:(NSString*)sTitle message:(NSString*)sMessage btnText:(NSString*)btnText;
+(NSString*) LIB_ReturnSFVersion;
+(NSDictionary*)APP_ReturnVersion;
+(BOOL)APP_ReturnAppNeedsUpdating_Maj:(int)iSavedVer_Major Min:(int)iSavedVer_Minor Build:(int)iSavedVer_Build;


#pragma mark - *** FORMATTING FUNCTIONS ***
+(NSDateFormatter*)FORMAT_setDate:(NSString*)sFormat;
+(NSDateFormatter*)FORMAT_setSQLDate;
+(NSNumberFormatter*)FORMAT_setCurrency;
+(NSNumberFormatter*)FORMAT_setNUMBER:(NSString*)sPos negFormat:(NSString*)sNeg;


#pragma mark - *** NOTIFICATIONS FUNCTIONS ***
+(void)setNotification:(NSString*)name observer:(id)theObserver;

    
#pragma mark - *** GESTURE FUNCTIONS ***
+(UITapGestureRecognizer*)GESTURE_returnTap:(NSString*)selector delegate:(id)theDelegate numTaps:(int)iNumTaps;
+(UISwipeGestureRecognizer*)GESTURE_returnswipe:(NSString*)selector delegate:(id)theDelegate direction:(int)iDirection;


#pragma mark - *** POPOVER FUNCTIONS ***
+(void)showPopover:(UIPopoverController*)popOver storyboard:(UIStoryboard*)sb named:(NSString*)vcName
              from:(UIView*)from inView:(UIView*)vw vc:(UIViewController*)vc arrow:(int)arrow borderColor:(UIColor*)bColor;
+(void)showPopover:(UIPopoverController*)popOver storyboard:(UIStoryboard*)sb named:(NSString*)vcName
            button:(UIBarButtonItem*)from vc:(UIViewController*)vc arrow:(int)arrow borderColor:(UIColor*)bColor;


#pragma mark - *** ZIP FUNCTIONS ***
+(BOOL)createZipFileAtPath:(NSString*)sArchiveFilePath withFilesAtPaths:arrPaths;


#pragma mark - *** ERROR FUNCTIONS ***
+(void)logError:(NSString*)sError withMessage:(NSString*)sMessage;


#pragma mark - *** APPIRATER FUNCTIONS ***
+(void)APPIRATER_SetDebug:(BOOL)bDebug;
+(void)APPIRATER_SetupAppName:(NSString*)sAppName;
+(void)APPIRATER_AppEnteredForeground;
+(BOOL)APPIRATER_SetupWithID:(NSString*)sID
                        Days:(int)iDays
                        Uses:(int)iUses
                      Events:(int)iEvents
                      Remind:(int)iRemind
                    setDebug:(BOOL)bDebug;

#pragma mark - *** JSON FUNCTIONS ***
+(NSMutableData*)appendData:(NSMutableData*)body withName:(NSString*)name withStringValue:(NSString*)value;
+(NSMutableData*)appendData:(NSMutableData*)body withName:(NSString*)name withIntegerValue:(int)value;
+(NSMutableData*)appendData:(NSMutableData*)body withName:(NSString*)name withFloatValue:(float)value;
+(NSMutableData*)appendData:(NSMutableData*)body withName:(NSString*)name withDoubleValue:(double)value;
+(NSMutableData*)closeData:(NSMutableData*)body;
+(NSMutableURLRequest*)returnPostRequestWithBody:(NSMutableData*)body remoteServer:(NSString*)sServer;

#pragma mark - *** SQL FUNCTIONS ***
+(NSString*)SQL_returnDBVersionStringFor:(NSString*)sFilename filePath:(NSString*)sFilePath;
+(float)SQL_returnDatabaseVersionFor:(NSString*)sFilename filePath:(NSString*)sFilePath displayToLog:(BOOL)bLog;
+(BOOL)SQL_IsDatabaseNamedInDocsPath:(NSString*)sDB LessThanVersionString:(NSString*)sVersion;
+(BOOL)SQL_DoesDatabaseNamedNeedUpdating:(NSString*)sDB;
+(void)SQL_UpdateIfNeededDatabaseNamed:(NSString*)sDB;
+(BOOL)SQL_NonQueryDB:(NSString*)sDB Query:(NSString*)sQuery arguments:(NSArray*)arrArguments;
+(NSArray*)SQL_Query:(NSString*)sQuery db:(NSString*)sDB;
+(NSArray*)SQL_Query:(NSString*)sQuery db:(NSString*)sDB arguments:(NSArray*)arrArguments;

#pragma mark - *** Text-To-Speech REUSABLE FUNCTIONS ***
+(void)SpeakText:(NSString*)sStringToSpeak inLanguage:(NSString*)sLanguageWithRegion atRate:(float)fRate atVolume:(float)fVolume;
+(NSArray*)Speak_ListAllLanguagesAndRegionsWithLog:(BOOL)bLog;


#pragma mark - *** LOCALIZATION REUSABLE FUNCTIONS ***
+(NSString*)getLocalizedLanguage_SupportedLanguages:(NSString*)sSuportedLanguages;
+(NSBundle*)setLocalizedLanguage:(NSString*)lang SupportedLanguages:(NSString*)sSuportedLanguages;
+(NSString*)localizeKey:(NSString*)key inBundle:(NSBundle*)bundle;


#pragma mark - *** USER DEFAULTS FUNCTIONS ***
+(double)    DEFAULTS_GetDouble:(NSString*)key minVal:(double)minVal defaultVal:(double)defaultVal testVal:(BOOL)bTestVal;
+(int)       DEFAULTS_GetInteger:(NSString*)key minVal:(int)minVal defaultVal:(int)defaultVal testVal:(BOOL)bTestVal;
+(float)     DEFAULTS_GetFloat:(NSString*)key minVal:(float)minVal defaultVal:(float)defaultVal testVal:(BOOL)bTestVal;
+(BOOL)      DEFAULTS_GetBool:(NSString*)key defaultVal:(BOOL)defaultVal testVal:(BOOL)bTestVal;
+(NSString*) DEFAULTS_GetString:(NSString*)key defaultVal:(NSString*)defaultVal;
+(NSDate*)   DEFAULTS_GetDate:(NSString*)key defaultVal:(NSDate*)defaultVal;
+(NSObject*) DEFAULTS_GetObject:(NSString*)key;

#pragma mark - *** DATE FORMATTING REUSABLE FUNCTIONS ***
+(BOOL)DATE_Date:(NSDate*)date1 isBeforeDate:(NSDate*)date2;
+(BOOL)DATE_Date:(NSDate*)date1 isAfterDate:(NSDate*)date2;
+(BOOL)DATE_Date:(NSDate*)date1 isSameDate:(NSDate*)date2;
+(long)DATE_numDaysBetweenDate:(NSDate*)Date1 andDate2:(NSDate*)Date2;
+(BOOL)DATE_isDate1LaterThanDate2:(NSDate*)Date1 Date2:(NSDate*)Date2;
+(BOOL)DATE_isDate1EarlierThanDate2:(NSDate*)Date1 Date2:(NSDate*)Date2;
+(BOOL)DATE_isDate1EqualToDate2:(NSDate*)Date1 Date2:(NSDate*)Date2;

+(NSDate*)returnDateFromString:(NSString*)sDateString includeTime:(BOOL)bIncludeTime;
+(void)DATE_SetLocaleForCountryCodeUsingDateFormatter:(NSDateFormatter*)dateFormatter US:(BOOL)US
                                                   UK:(BOOL)UK
                                            Australia:(BOOL)AU
                                               France:(BOOL)FR
                                                Italy:(BOOL)IT
                                                Japan:(BOOL)JA
                                                Spain:(BOOL)ES
                                               Russia:(BOOL)RU;
+(NSString*) DATE_ReturnMonthName:(int)iMonth abbrev:(BOOL)abbrev;
+(int)       DATE_ReturnMonthNumber:(NSString*)sMonth;
+(BOOL)      DATE_IsDeviceTime24h;
+(int)       DATE_ReturnDaysInMonth:(NSDate*)theDate;


#pragma mark - *** TAB BAR REUSABLE FUNCTIONS ***
+(UIViewController*)TABBAR_ReturnTabBarViewControllerForTabNamed:(NSString*)tabNameToLookFor
                                            tabBarControllerName:(UITabBarController*)tabBarControllerName;
+(int)TABBAR_ReturnTabBarIndexForTabNamed:(NSString*)tabNameToLookFor
                     tabBarControllerName:(UITabBarController*)tabBarControllerName;
+(void)TABBAR_HideTabBar:(UITabBarController*)tabbarcontroller;
+(void)TABBAR_ShowTabBar:(UITabBarController*)tabbarcontroller;


#pragma mark - *** FILE FUNCTIONS ***
+(BOOL)FILES_copyFromMainBundleToDocsDirectoryAndUnzipFilename:(NSString*)sFilename subDirectoryName:(NSString*)sDirName;
+(BOOL)FILES_copyFromMainBundleToDocsDirectoryFileNamed:(NSString*)sFilename;
+(BOOL)FILES_CopyFile:(NSString*)fileName fromPath:(NSString*)sourcePath toPath:(NSString*)destinationPath;
+(BOOL)      FILES_DownloadFileIfUpdatedOnServer:(NSString*)sURL
                                        fileName:(NSString*)sFileName
                                     inDocuments:(BOOL)inDocuments
                                 inLibraryCaches:(BOOL)inLibrary
                                          inTemp:(BOOL)inTemp
                                            Path:(NSString*)path;
+(BOOL)FILES_DoesFileExistInDocuments:(NSString*)sFileName;
+(BOOL)FILES_DoesFileExist:(NSString*)sFileName inPath:(NSString*)path;
+(BOOL)     FILES_DoesFileExist:(NSString*)sFileName
                   inMainBundle:(BOOL)inMainBundle
                    inDocuments:(BOOL)inDocuments
                inLibraryCaches:(BOOL)inLibraryCaches
                         inTemp:(BOOL)inTemp
                           Path:(NSString*)path;
+(BOOL)FILES_MoveFile:(NSString*)fileName fromPath:(NSString*)sourcePath toPath:(NSString*)destinationPath;
+(BOOL)FILES_DuplicateFile:(NSString*)fileName toName:(NSString*)toFilename inPath:(NSString*)sourcePath;
+(BOOL)FILES_RenameFileFrom:(NSString*)fromFileName To:(NSString*)toFileName inPath:(NSString*)inPath;
+(BOOL)FILES_DeleteFile:(NSString*)fileName inPath:(NSString*)inPath;
+(NSString*) FILES_ReturnCustomPathForFile:(NSString*)newFileName InPath:(NSString*)sInPath;
+(NSString*) FILES_ReturnDocumentsPath:(NSString*)newFileName;
+(NSString*)FILES_ReturnLibraryPreferencesPath:(NSString*)newFileName;
+(NSString*) FILES_ReturnLibraryCachesPath:(NSString*)newFileName;
+(NSString*) FILES_ReturnMainBundlePath:(NSString*)fileName fileType:(NSString*)fileType;
+(long long)FILES_ReturnUsedDiskSpaceInBytes:(BOOL)returnBytes returnKB:(BOOL)returnKB returnMB:(BOOL)returnMB returnGB:(BOOL)returnGB;
+(long long) FILES_ReturnTotalDiskSpaceInBytes:(BOOL)returnBytes returnKB:(BOOL)returnKB returnMB:(BOOL)returnMB returnGB:(BOOL)returnGB;
+(long long) FILES_ReturnFreeDiskSpaceInBytes:(BOOL)returnBytes returnKB:(BOOL)returnKB returnMB:(BOOL)returnMB returnGB:(BOOL)returnGB;
+(BOOL)      FILES_CreateNewDirectoryNamed:(NSString*)sDirectoryName
                               inDocuments:(BOOL)inDocuments
                           inLibraryCaches:(BOOL)inLibraryCaches
                                    inTemp:(BOOL)inTemp;
+(BOOL)      FILES_DeleteDirectoryNamed: (NSString*)sDirectoryToDelete
                            inDocuments: (BOOL)inDocuments
                        inLibraryCaches: (BOOL)inLibraryCaches
                                 inTemp: (BOOL)inTemp;
+(NSArray*)FILES_ReturnAllFilesInDirectory:(NSString*)sDirectory filterFileType:(NSString*)sFilter;
+(BOOL)      FILES_AddSkipBackupAttributeToItemAtURL:(NSURL*)URL;
+(BOOL)      FILES_DoesDirectoryExistNamed:(NSString*)sDirectoryName
                               inDocuments:(BOOL)inDocuments
                           inLibraryCaches:(BOOL)inLibraryCaches
                                    inTemp:(BOOL)inTemp;
+(NSString*) FILES_ReturnFileSizeOnServerString:(NSString*)sURL fileName:(NSString*)sFileName;
+(int)       FILES_ReturnFileSizeOnServer:(NSString*)sURL fileName:(NSString*)sFileName;
+(NSString*)FILES_ReturnFormattedFileSizeFromNumber:(unsigned long long)fileSize numDecPlaces:(int)iNumDecPlaces;
+(NSString*)FILES_ReturnFileSizeString:(NSString*)sFileName;
+(unsigned long long)FILES_ReturnFileSize:(NSString*)sFileName;
+(BOOL)FILES_ReturnIsFileNewerOnServer:(NSString*)sURL
                              fileName:(NSString*)sFileName
                           inDocuments:(BOOL)inDocuments
                             inLibrary:(BOOL)inLibrary
                                inPath:(BOOL)inPath
                                  Path:(NSString*)path;


#pragma mark - *** IMAGE FUNCTIONS ***
+(UIImage*)imageWithColor:(UIColor*)color1 image:(UIImage*)img;
+(UIImage*)IMAGE_MakeGrayscale:(UIImage*)img;
+(CGFloat)      IMAGE_DegreesToRadians:(CGFloat)degrees;
+(UIImageView*) IMAGE_RotateView90Degrees:(UIImageView*)viewToRotate;
+(UIImage*)IMAGE_RotateImage90Degrees:(UIImage*)imgToRotate;
+(UIImage*)IMAGE_RotateImage180Degrees:(UIImage*)imgToRotate;
+(UIImage*)IMAGE_RotateImage270Degrees:(UIImage*)imgToRotate;
+(UIImage*)     IMAGE_ScaleImage:(UIImage *)image toSize:(CGSize)newSize;
+(UIImage*)     IMAGE_ResizeImage:(UIImage*)imgToResize toSize:(CGSize)rectResize ignoreScale:(BOOL)bIgnoreScale
                             save:(BOOL)bSave toFileName:(NSString*)fileName;
+(UIImage*)     IMAGE_CropImage:(UIImage*)imgToCrop toRect:(CGRect)rectCrop scale:(float)fScale save:(BOOL)bSave
                     toFileName:(NSString*)fileName;
+(UIImage*)     IMAGE_GrabScreen:(UIView*)grabFromView useLayer:(BOOL)useLayer rectSize:(CGSize)rectSize opaque:(BOOL)opaque
                           scale:(CGFloat)scale isPortrait:(BOOL)isPortrait fileName:(NSString*)fileName crop:(BOOL)crop
                        cropRect:(CGRect)cropRect save:(BOOL)save;


#pragma mark - *** COLOR FUNCTIONS ***
+(NSArray*)COLORS_ReturnRGBColor:(UIColor*)color;
+(UIColor*)COLORS_ReturnUIColor:(NSString*)colorName;
+(UIColor*)COLORS_colorOfPoint:(CGPoint)point onView:(UIView*)view Log:(BOOL)bLog;
+(NSArray*)COLORS_returnTestPointsofscreenForAverageUnderControlIsLight:(UIView*)viewForPosition
                                                             viewToTest:(UIView*)viewToTest
                                                    luminosityThreshold:(float)fMaxLuminosity;
+(BOOL)COLORS_testPointsofscreenForAverageUnderControlIsLight:(UIView*)viewForPosition
                                                   viewToTest:(UIView*)viewToTest
                                          luminosityThreshold:(float)fMaxLuminosity;
+(BOOL)COLORS_isLightColor:(UIColor*)colorToTest luminosityThreshold:(float)fMaxLuminosity;

#pragma mark - *** DRAWING FUNCTIONS ***
+(UIView*)DRAW_addShadowToView:(UIView*)view
                    OffsetSize:(CGSize)offset
                        Radius:(CGFloat)radius
                       Opacity:(CGFloat)opacity;
+(UIImage*)DRAW_returnImageOfView:(UIView*)view;
+(UIImage*)DRAW_BlurLayerForView:(UIView*)vw
                    inMasterView:(UIView*)vwMaster
                          inRect:(CGRect)rect
                      fullScreen:(BOOL)bFullScreen
                          effect:(int)iEffect
                            tint:(UIColor*)colorTint
                      blurRadius:(int)iBlurRadius;
+(void)     DRAW_RoundLayer:(UIView*)view Radius:(CGFloat)radius borderColor:(UIColor*)borderColor borderWidth:(CGFloat)borderWidth;
+(void)DRAW_colorizeButton:(UIButton*)btn
                background:(UIColor*)backColor
                    radius:(CGFloat)fRadius
                    border:(UIColor*)borderColor
                     width:(CGFloat)fWidth;
+(void)     DRAW_RoundCornersWithRadius:(float)fRadius Layer:(CALayer*)layerName;
+(void)     DRAW_StrokeBorder:(CALayer*)thisLayer Color:(UIColor*)colorBorder Width:(float)widthBorder;
+(void)     DRAW_MakeGlossy:(UIView*)view;
+(void)     DRAW_SetColorsForButton: (UIButton*)buttonName
                         TitleColor: (UIColor*)colorTitle
                     HighlightColor: (UIColor*)colorHighlight
                    BackgroundColor: (UIColor*)colorBackground;
+(void)     DRAW_RemoveSubLayers:(UIView*)theView;
+(void)     DRAW_AddSubLayerGradientToLayer:(CALayer*)layerName fromColor:(UIColor*)fromColor toColor:(UIColor*)toColor;
+(UIImage*)DRAW_setImageAlpha:(UIImage*)image withAlpha:(CGFloat)alpha;


#pragma mark - *** HTML FORMATTING METHODS ***
+(NSString*)addHTMLtitle:(NSString*)HTMLtitle Color:(NSString*)HTMLcolor Size:(float)HTMLsize;
+(NSString*)addHTMLobject:(NSString*)HTMLtitle WidthPercent:(int)wide1
              HTMLsubject:(NSString*)HTMLsubject Color:(NSString*)HTMLcolor WidthPercent:(int)wide2;
+(NSAttributedString*)loadCustomFormattedText:(NSString*)sFileToUse
                                     inBundle:(NSBundle*)bundle
                                     fontName:(NSString*)fontName
                                 fontBoldName:(NSString*)fontBoldName
                                    keyOfText:(NSString*)keyOfText
                                   titleColor:(UIColor*)titleColor
                                    bodyColor:(UIColor*)bodyColor
                                     fontSize:(float)fFontSize
                                fontSizeTitle:(float)fFontSizeTitle
                                    underline:(BOOL)bUnderline;


#pragma mark - *** STRING FORMATTING REUSABLE FUNCTIONS ***
+(NSString*)STRING_FormatZip:(NSString*)currentString country:(NSString*)sCountry;
+(NSString*)STRING_FormatPhoneNum:(NSString*)currentString;
+(NSString*)STRING_FormatSSN:(NSString*)currentString country:(NSString*)sCountry;
+(NSString*)STRING_ReverseString:(NSString*)sStringToReverse;
+(NSArray*)STRING_returnTableIndexArrayFromStringOfCharacters:(NSString*)sChars;
+(int)STRING_returnWordCountForString:(NSString*)string;
+(NSString*)STRING_buildAddress_Name:(NSString*)sName
                               Addr1:(NSString*)sAddr1
                               Addr2:(NSString*)sAddr2
                                City:(NSString*)sCity
                               State:(NSString*)sState
                                 Zip:(NSString*)sZip
                             Country:(NSString*)sCountry
                           MultiLine:(BOOL)bMultiLine;
+(int)STRING_stripCommas:(NSString*)string;
+(int)STRING_returnTextAlignment:(NSString*)fontAlignment;
+(NSString*)STRING_stripLeadingAndTrailingSpaces:(NSString*)sTrimString;
+(NSString*)STRING_stripQuotes:(NSString*)sTrimString;
+(NSString*)STRING_stripDoubleApostrophes:(NSString*)sString;
+(NSString*)STRING_replaceApostrophesWithQuotes:(NSString*)sString;
+(NSString*)STRING_returnASCII:(NSString*)sString;
+(NSString*)STRING_containsBannedWords:(NSString*)sString;
+(BOOL)STRING_containsInvalidCharacters:(NSString*)string charSet:(NSString*)characters;


#pragma mark - *** FONTS FUNCTIONS ***
+(float)FONTS_CalculateLargestFontForLabel:(UILabel*)lblName tryingFontSize:(float)fNewFontSize
                             withFontNamed:(NSString*)sFontName minFontSize:(float)minFontSize;
+(NSMutableArray*)FONTS_ReturnAllFontNamesWithLog:(BOOL)bLog;
+(NSMutableArray*)FONTS_ReturnAllFormattedFontNamesWithLog:(BOOL)bLog;
+(NSMutableDictionary*)FONTS_ReturnAllFontFamiliesWithLog:(BOOL)bLog;

#pragma mark - *** DEBUG FUNCTIONS ***
+(void) DEBUG_ShowTitle:(BOOL)showStartingLine titleText:(NSString*)titleText showEndingLine:(BOOL)showEndingLine;
+(void) DEBUG_ShowTextLine:(NSString*)titleText;
+(void) DEBUG_ShowSeparator:(BOOL)addLineReturns;
+(void) DEBUG_ShowAppInfoInDebug;
+(void) DEBUG_ShowPhotoInfo:(int)imgOrientation mediaType:(NSString*)mediaType imgHeight:(int)imgHt imgWidth:(int)imgWd;
+(void) DEBUG_ShowArrayContents:(NSString*)arrayNameString arrayName:(NSArray*)arrayName fromIndex:(int)fromIndex toIndex:(int)toIndex;
+(void) DEBUG_ShowSetContents:(NSString*)setNameString setName:(NSSet*)setName fromIndex:(int)fromIndex toIndex:(int)toIndex;
+(void) DEBUG_ShowDictionaryContents:(NSString*)dictionaryNameString dictionaryName:(NSDictionary*)dictionaryName fromIndex:(int)fromIndex toIndex:(int)toIndex;


#pragma mark - *** PHOTO FUNCTIONS ***
+(NSString*) PHOTOS_ReturnPhotoOrientation:(int)imgOrientation;
+(UIImage*)  PHOTOS_ReturnConvertedImageToGrayScale:(UIImage*)img;


#pragma mark - *** NETWORK FUNCTIONS ***
+(BOOL) NETWORK_NetworkAvailable;


#pragma mark - *** DEVICE FUNCTIONS ***
+(NSDictionary*)DEVICE_returnFreeMemoryInMB;
+(NSDictionary*) DEVICE_ReturnListOfDevicesByInterfaceIdiom:(NSString*)sInterface;
+(NSString*)     DEVICE_ReturnDeviceModelName:(NSString*)sDevice;
+(NSString*)     DEVICE_ReturnImageFilenameForDevice:(NSString*)sDevice color:(NSString*)sColor;
+(NSString*)     DEVICE_ReturnDeviceModel;
+(BOOL)          DEVICE_IsSimulator;
+(BOOL)          DEVICE_IsDisplayRetina;
+(BOOL)          DEVICE_IsIpad;
+(int)DEVICE_ScreenScale;
+(BOOL)          DEVICE_Is4InchScreen;
+(BOOL)DEVICE_IsMin_iOS7;

#pragma mark
#pragma mark ------ SHARED CONSTANTS ------
#pragma mark - *** APPLICATION CONSTANTS ***
//------------------------------------------------------------------------------------------------------
#define kAppVersionBuild    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define kAppVersion         [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define kAppVersionFull     [NSString stringWithFormat:@"%@.%@",kAppVersion,kAppVersionBuild]
#define kAppName            [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]
#define kAppDisplayName     [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]


#pragma mark - *** CHARACTER SET CONSTANTS ***
//------------------------------------------------------------------------------------------------------
#define VALID_CHARS                 @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 '-/:;()$&@.,?![]{}#%^*+=_|~<>\""
#define VALID_CHARS_Alpha           @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define VALID_CHARS_Numeric         @"0123456789.,"
#define VALID_CHARS_NumberPad       @"0123456789."
#define VALID_CHARS_AlphaNumeric    @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define VALID_CHARS_TableIndex      @"*0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define VALID_TITLES_Alpha          @"ABCDEFGHIJKLMNOPQRSTUVWXYZ"
#define VALID_TITLES_Alphanumeric   @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
#define VALID_TITLES_TableIndex     @"*0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"


#pragma mark - *** JSON CONSTANTS ***
//------------------------------------------------------------------------------------------------------
#define boundary @"---------------------------14737809831466499882746641449"

#pragma mark - *** AUDIO MUSIC CONSTANTS ***
//------------------------------------------------------------------------------------------------------
#define isMusic(x)        (x & MPMediaTypeMusic)
#define isPodCast(x)      (x & MPMediaTypePodCAst)
#define isAudioBooks(x)   (x & MPMediaTypeAudioBook)


#pragma mark - *** COLOR CONSTANTS ***
//------------------------------------------------------------------------------------------------------
// To Calculate decimal RGB values, take RGB Value and DIVIDE by 255.
//------------------------------------------------------------------------------------------------------
#define kColor_Cayenne      [UIColor colorWithRed:0.50 green:0.00 blue:0.00 alpha:1.00]
#define kColor_Mocha        [UIColor colorWithRed:0.50 green:0.25 blue:0.00 alpha:1.00]
#define kColor_Maraschino   [UIColor colorWithRed:1.00 green:0.00 blue:0.00 alpha:1.00]
#define kColor_Tangerine    [UIColor colorWithRed:1.00 green:0.50 blue:0.00 alpha:1.00]
#define kColor_Salmon       [UIColor colorWithRed:1.00 green:0.40 blue:0.40 alpha:1.00]
#define kColor_Cantaloupe   [UIColor colorWithRed:1.00 green:0.80 blue:0.40 alpha:1.00]
#define kColor_Asparagus    [UIColor colorWithRed:0.50 green:0.50 blue:0.00 alpha:1.00]
#define kColor_Lemon        [UIColor colorWithRed:1.00 green:1.00 blue:0.00 alpha:1.00]
#define kColor_Lime         [UIColor colorWithRed:0.50 green:1.00 blue:0.00 alpha:1.00]
#define kColor_Banana       [UIColor colorWithRed:1.00 green:1.00 blue:0.40 alpha:1.00]
#define kColor_Honeydew     [UIColor colorWithRed:0.80 green:1.00 blue:0.40 alpha:1.00]
#define kColor_Clover       [UIColor colorWithRed:0.00 green:0.50 blue:0.00 alpha:1.00]
#define kColor_Moss         [UIColor colorWithRed:0.00 green:0.50 blue:0.25 alpha:1.00]
#define kColor_Spring       [UIColor colorWithRed:0.00 green:1.00 blue:0.00 alpha:1.00]
#define kColor_SeaFoam      [UIColor colorWithRed:0.00 green:1.00 blue:0.50 alpha:1.00]
#define kColor_Flora        [UIColor colorWithRed:0.40 green:1.00 blue:0.40 alpha:1.00]
#define kColor_Spindrift    [UIColor colorWithRed:0.40 green:1.00 blue:0.80 alpha:1.00]
#define kColor_Teal         [UIColor colorWithRed:0.00 green:0.50 blue:0.50 alpha:1.00]
#define kColor_Ocean        [UIColor colorWithRed:0.00 green:0.25 blue:0.50 alpha:1.00]
#define kColor_Turquoise    [UIColor colorWithRed:0.00 green:1.00 blue:1.00 alpha:1.00]
#define kColor_Aqua         [UIColor colorWithRed:0.00 green:0.50 blue:1.00 alpha:1.00]
#define kColor_Ice          [UIColor colorWithRed:0.40 green:1.00 blue:1.00 alpha:1.00]
#define kColor_Sky          [UIColor colorWithRed:0.40 green:0.80 blue:1.00 alpha:1.00]
#define kColor_Midnight     [UIColor colorWithRed:0.00 green:0.00 blue:0.50 alpha:1.00]
#define kColor_Eggplant     [UIColor colorWithRed:0.25 green:0.00 blue:0.50 alpha:1.00]
#define kColor_Blueberry    [UIColor colorWithRed:0.00 green:0.00 blue:1.00 alpha:1.00]
#define kColor_Grape        [UIColor colorWithRed:0.50 green:0.00 blue:1.00 alpha:1.00]
#define kColor_Orchid       [UIColor colorWithRed:0.40 green:0.40 blue:1.00 alpha:1.00]
#define kColor_Lavender     [UIColor colorWithRed:0.80 green:0.40 blue:1.00 alpha:1.00]
#define kColor_Plum         [UIColor colorWithRed:0.50 green:0.00 blue:0.50 alpha:1.00]
#define kColor_Tin          [UIColor colorWithRed:0.49 green:0.49 blue:0.49 alpha:1.00]
#define kColor_Nickel       [UIColor colorWithRed:0.50 green:0.50 blue:0.50 alpha:1.00]
#define kColor_Maroon       [UIColor colorWithRed:0.50 green:0.00 blue:0.25 alpha:1.00]
#define kColor_Steel        [UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.00]
#define kColor_Aluminum     [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1.00]
#define kColor_Magenta      [UIColor colorWithRed:1.00 green:0.00 blue:1.00 alpha:1.00]
#define kColor_Iron         [UIColor colorWithRed:0.29 green:0.29 blue:0.29 alpha:1.00]
#define kColor_Silver       [UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1.00]
#define kColor_Magnesium    [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1.00]
#define kColor_Tungsten     [UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1.00]
#define kColor_Strawberry   [UIColor colorWithRed:1.00 green:0.00 blue:0.50 alpha:1.00]
#define kColor_Bubblegum    [UIColor colorWithRed:1.00 green:0.40 blue:1.00 alpha:1.00]
#define kColor_Lead         [UIColor colorWithRed:0.09 green:0.09 blue:0.09 alpha:1.00]
#define kColor_Mercury      [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00]
#define kColor_Carnation    [UIColor colorWithRed:1.00 green:0.44 blue:0.81 alpha:1.00]
#define kColor_Snow         [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:1.00]
#define kColor_Licorice     [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.00]
#define kColor_Clear        [UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:0.00]

#pragma mark - *** CUSTOM COLOR CONSTANTS ***
//------------------------------------------------------------------------------------------------------
#define kColor_Gold              [UIColor colorWithRed:0.80 green:0.62 blue:0.00 alpha:1.00]
#define kColor_Rust              [UIColor colorWithRed:0.62 green:0.25 blue:0.00 alpha:1.00]
#define kColor_PopoverBlue       [UIColor colorWithRed:0.0196 green:0.0901 blue:0.2352 alpha:1.00]
#define kColor_Darkbrown         [UIColor colorWithRed:.24 green:.1 blue:0 alpha:1.0]

#pragma mark - *** CUSTOM BUTTON CONSTANTS ***
//------------------------------------------------------------------------------------------------------
#define kColor_btnBlue           [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0]
#define kColor_btnGreen          [UIColor colorWithRed:0.0 green:.69 blue:0.0 alpha:1.0]
#define kColor_btnGreen_Disabled [UIColor colorWithRed:0.0 green:.29 blue:0.0 alpha:1.0]
#define kColor_btnRed            [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]
#define kColor_btnDefault        [UIColor colorWithRed:0.0 green:.28 blue:1.0 alpha:1.0]

#pragma mark - *** iOS7 CONTROL COLORS ***
//------------------------------------------------------------------------------------------------------
#define kColor_SwitchOnGreen        [UIColor colorWithRed:0.259 green:0.839 blue:0.318 alpha:1.000]
#define kColor_SwitchOffRed         [UIColor colorWithRed:0.835 green:0.157 blue:0.220 alpha:1.000]
#define kColor_Glyph_BLUE           [UIColor colorWithRed:0.039 green:0.373 blue:1.000 alpha:1.000]
#define kColor_Glyph_BLUE_Disabled  [UIColor colorWithRed:0.176 green:0.333 blue:0.984 alpha:0.500]
#define kColor_Apple_Red            [UIColor colorWithRed:0.914 green:0.082 blue:0.169 alpha:1.000]
#define kColor_Apple_Orange         [UIColor colorWithRed:0.933 green:0.510 blue:0.102 alpha:1.000]
#define kColor_Apple_Yellow         [UIColor colorWithRed:0.957 green:0.776 blue:0.122 alpha:1.000]
#define kColor_Apple_Green          [UIColor colorWithRed:0.314 green:0.859 blue:0.329 alpha:1.000]
#define kColor_Apple_LightBlue      [UIColor colorWithRed:0.251 green:0.596 blue:0.820 alpha:1.000]
#define kColor_Apple_DarkBlue       [UIColor colorWithRed:0.196 green:0.337 blue:0.984 alpha:1.000]
#define kColor_Apple_Purple         [UIColor colorWithRed:0.298 green:0.188 blue:0.788 alpha:1.000]
#define kColor_Apple_Pink           [UIColor colorWithRed:0.914 green:0.000 blue:0.275 alpha:1.000]
#define kColor_Apple_DarkGray       [UIColor colorWithRed:0.482 green:0.482 blue:0.506 alpha:1.000]
#define kColor_Apple_LightGray      [UIColor colorWithRed:0.733 green:0.733 blue:0.757 alpha:1.000]

#pragma mark - *** MAPING CONSTANTS ***
//------------------------------------------------------------------------------------------------------
#define MAPTYPE_STANDARD  0
#define MAPTYPE_SATELLITE 1
#define MAPTYPE_HYBRID    2
#define ZOOM_TO_PIN      0.0025
#define ZOOM_TO_AREA     0.05
#define ZOOM_TO_REGION   0.9
#define ZOOM_TO_COUNTRY  35.0

#pragma mark - *** OPACITY CONSTANTS ***
//------------------------------------------------------------------------------------------------------
#define kCLEAR         0.0f
#define kSEMI_DARK     0.25f
#define kSEMI_CLEAR    0.5f
#define kSEMI_LIGHT    0.75f
#define kOPAQUE        1.0f

#pragma mark - *** IMAGE FILTER CONSTANTS ***
//------------------------------------------------------------------------------------------------------
#define kFilter_BLOOM       @"CIBloom"
#define kFilter_BLUR        @"CIGaussianBlur"
#define kFilter_BRIGHTNESS  @"Brightness"
#define kFilter_BUMP        @"CIBumpDistortion"
#define kFilter_CONTROLS    @"CIColorControls"
#define kFilter_EXPOSURE    @"CIExposureAdjust"
#define kFilter_HIGHLIGHT   @"CIHighlightShadowAdjust"
#define kFilter_GAMMA       @"CIGammaAdjust"
#define kFilter_GLOOM       @"CIGloom"
#define kFilter_HUE         @"CIHueAdjust"
#define kFilter_LUMINOSITY  @"CISharpenLuminance"
#define kFilter_PIXELLATE   @"CIPixellate"
#define kFilter_POSTERIZE   @"CIColorPosterize"
#define kFilter_SEPIA       @"CISepiaTone"
#define kFilter_SHARPEN     @"CIUnsharpMask"
#define kFilter_VIBRANCE    @"CIVibrance"
#define kFilter_VIGNETTE    @"CIVignette"
#define kFilter_WHITEPOINT  @"CIWhitePointAdjust"

#pragma mark - *** BLUR-EFFECT CONSTANTS ***
//------------------------------------------------------------------------------------------------------
#define kEFFECT_LIGHT           0
#define kEFFECT_EXTRALIGHT      1
#define kEFFECT_DARK            2
#define kEFFECT_TINT            3
#define kEFFECT_SUBLTLELIGHT    4
#define kEFFECT_SUBLTLEDARK     5
#define kEFFECT_EXTRADARK       6
#define kEFFECT_VERYDARK        7

#pragma mark - *** BLUR-EFFECT CONSTANTS ***
//------------------------------------------------------------------------------------------------------
#define kScreenSize3_5Inch        1
#define kScreenSize4Inch          2
#define kScreenSize4_7Inch        3
#define kScreenSize5_5Inch        4

#pragma mark - *** MEASUREMENT CONSTANTS ***
//------------------------------------------------------------------------------------------------------
#define METERS_TO_FEET 3.280839895

@end


#pragma mark
#pragma mark ------ MACHINE FUNCTIONS ------
#pragma mark - *** UIDEVICE(machine) ***
@interface UIDevice(machine){
}

-(NSString*)machine;

@end


#pragma mark
#pragma mark ------ REACHABILITY FUNCTIONS ------

#define kReachabilityChangedNotification @"kNetworkReachabilityChangedNotification"

typedef enum {
    NotReachable = 0,
    ReachableViaWiFi,
    ReachableViaWWAN
} NetworkStatus;

@interface netReachability: NSObject{
    BOOL localWiFiRef;
    SCNetworkReachabilityRef reachabilityRef;
}

+(netReachability*) reachabilityWithHostName: (NSString*) hostName;
+(netReachability*) reachabilityWithAddress: (const struct sockaddr_in*) hostAddress;
+(netReachability*) reachabilityForInternetConnection;
+(netReachability*) reachabilityForLocalWiFi;

-(BOOL) startNotifier;
-(void) stopNotifier;
-(NetworkStatus) currentReachabilityStatus;
-(BOOL) connectionRequired;

@end


#pragma mark
#pragma mark ------ BLUR-EFFECT FUNCTIONS ------

@interface UIImage (ImageEffects)

-(UIImage*)applySubtleLightEffect:(int)iBlurRadius;
-(UIImage*)applySubtleDarkEffect:(int)iBlurRadius;
-(UIImage*)applyExtraDarkEffect:(int)iBlurRadius;
-(UIImage*)applyLightEffect:(int)iBlurRadius;
-(UIImage*)applyExtraLightEffect:(int)iBlurRadius;
-(UIImage*)applyDarkEffect:(int)iBlurRadius;
-(UIImage*)applyVeryDarkEffect:(int)iBlurRadius;
-(UIImage*)applyTintEffectWithColor:(UIColor *)tintColor;
-(UIImage*)applyBlurWithRadius:(CGFloat)blurRadius
                     tintColor:(UIColor *)tintColor
         saturationDeltaFactor:(CGFloat)saturationDeltaFactor
                     maskImage:(UIImage *)maskImage;

@end

#pragma mark
#pragma mark - UIBezierPath CLASS
@interface UIBezierPath (IOS7RoundedRect)
+(UIBezierPath*)bezierPathWithIOS7RoundedRect:(CGRect)rect cornerRadius:(CGFloat)radius;
@end

#pragma mark
#pragma mark - UIWebViewWithoutMenu CLASS
@interface UIWebViewWithoutMenu: UIWebView{}
@end

#pragma mark
#pragma mark - UITextViewWithoutMenu CLASS
@interface UITextViewWithoutMenu: UITextView {}
@end

#pragma mark
#pragma mark - OFFSET LABEL CLASS
@interface OffsetLabel: UILabel{}
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@end

#pragma mark
#pragma mark - VERTICAL ALIGNMENT LABEL CLASS
@interface VALabel: UILabel
@property (nonatomic, assign) UIControlContentVerticalAlignment verticalAlignment;
@end

#pragma mark
#pragma mark - OFFSET TEXTFIELD CLASS
@interface OffsetTextField: UITextField{}
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@end

#pragma mark
#pragma mark - SQLite EXTENSION CLASS
@interface Sqlite : NSObject {
	NSInteger busyRetryTimeout;
	NSString *filePath;
	sqlite3 *_db;
}

@property (readwrite) NSInteger busyRetryTimeout;
@property (readonly) NSString *filePath;

+ (NSString *)version;
- (id)initWithFile:(NSString *)filePath;
- (BOOL)open:(NSString *)filePath;
- (void)close;
- (NSInteger)errorCode;
- (NSString *)errorMessage;
- (NSArray *)executeQuery:(NSString *)sql, ...;
- (NSArray *)executeQuery:(NSString *)sql arguments:(NSArray *)args;
- (BOOL)executeNonQuery:(NSString *)sql, ...;
- (BOOL)executeNonQuery:(NSString *)sql arguments:(NSArray *)args;
- (BOOL)commit;
- (BOOL)rollback;
- (BOOL)beginTransaction;
- (BOOL)beginDeferredTransaction;

@end
