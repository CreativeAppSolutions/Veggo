/*----------------------------------------------------------------------
     File: Languages.m
   Author: Kevin Messina - Creative App Solutions, LLC - New York, USA
 Modifier:
  Created: September 20, 2014
 
 ©2014 Creative App Solutions, LLC. USA - All Rights Reserved
 ----------------------------------------------------------------------*/

#pragma mark - *** IMPORTS ***
#import "VC_Languages.h"
#import "cell_Countries.h"


#pragma mark - *** INTERFACE ***
@interface VC_Languages () <UITableViewDataSource,UITableViewDelegate>

@end


#pragma mark - *** IMPLEMENTATION ***
@implementation VC_Languages{
    IBOutlet UITableView *table;
    IBOutlet UIImageView *imgLogo;
    IBOutlet UIView *background;
    IBOutlet UINavigationBar *navBar;
    IBOutlet UILabel *lblTranslate;

    NSArray *arrLanguages,*arrAllLanguages,*arrIndexTitles;
    int iTableSelectedRow,iTableSelectedSection;
    
}


#pragma mark - *** CLASS VARIABLES ***
BOOL bSearchActive =NO;

#pragma mark - *** INITIALIZE ***
-(void)initialize{
    iTableSelectedRow =0;
    iTableSelectedSection =0;
    
    NSString *sUserDeviceLanguage =[AppDelegate SQL_GetLanguageForCode:[NSLocale preferredLanguages].firstObject];
    BOOL bIsRightToLeft =[AppDelegate SQL_GetLanguageAlignmentFor:sUserDeviceLanguage];
    
    UIBarButtonItem *btn1 =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Close"]
                                                            style:UIBarButtonItemStylePlain
                                                           target:self
                                                           action:@selector(action_Close:)];

    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
        if (bIsRightToLeft){
            navBar.topItem.leftBarButtonItem =btn1;
        }else{
            navBar.topItem.rightBarButtonItem =btn1;
        }
    }else{
        navBar.topItem.rightBarButtonItem =btn1;
    }
    
    lblTranslate.textAlignment =NSTextAlignmentNatural;

    NSData *fromColorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"fromColor"];
    NSData *toColorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"toColor"];
    UIColor *fromColor = [NSKeyedUnarchiver unarchiveObjectWithData:fromColorData];
    UIColor *toColor = [NSKeyedUnarchiver unarchiveObjectWithData:toColorData];

    for (CALayer *layer in background.layer.sublayers) {
        [layer removeFromSuperlayer];
    }

    [DVM_SF DRAW_AddSubLayerGradientToLayer:background.layer fromColor:fromColor toColor:toColor];
    navBar.tintColor =fromColor;
    navBar.titleTextAttributes =@{NSForegroundColorAttributeName:fromColor};

    /* Display Logo */
//    imgLogo.hidden =![[NSUserDefaults standardUserDefaults] boolForKey:@"displayLogo"];
    imgLogo.hidden =YES;

    arrAllLanguages =[self SQL_GetAllLanguages];
    
    /* Setup Table */
    table.backgroundColor = [UIColor clearColor];
    table.opaque =NO;
    table.sectionIndexColor =kAppColor_Clouds;
    table.sectionIndexBackgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0.25];
    table.sectionIndexTrackingBackgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0.55];
    table.sectionIndexMinimumDisplayRowCount =9;
    [table setSeparatorInset:UIEdgeInsetsZero];

    /* Set table Index Titles to matching items */
    arrIndexTitles =[DVM_SF STRING_returnTableIndexArrayFromStringOfCharacters:VALID_TITLES_Alpha];
    NSMutableArray *marrItems =[NSMutableArray new];
    for (int i=0; i < arrIndexTitles.count; i++){
        if ([self SQL_GetLanguagesStartingWith:arrIndexTitles[i]].count >0){
            [marrItems addObject:arrIndexTitles[i]];
        }
    }
    arrIndexTitles =[NSArray arrayWithArray:marrItems];

    [table reloadData];

    /* Localize text */
    navBar.topItem.title =NSLocalizedString(@"Language_Title",nil);
    lblTranslate.text =NSLocalizedString(@"Language_Translate",nil);
}

-(void)loadDefaults{
    /* Preselect and highlight row from last session */
    int iRow =[DVM_SF DEFAULTS_GetInteger:@"SelectedLanguage_Row" minVal:0 defaultVal:0 testVal:YES];
    int iSection =[DVM_SF DEFAULTS_GetInteger:@"SelectedLanguage_Section" minVal:0 defaultVal:0 testVal:YES];
    
    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:iRow inSection:iSection];
    [table selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    [self tableView:table didSelectRowAtIndexPath:indexPath];
}


#pragma mark - *** CODING METHODS ***


#pragma mark - *** ACTIONS ***
-(IBAction)action_Close:(UIBarButtonItem*)btn{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notification_UpdateLanguage" object:nil];
    [Flurry logEvent:@"Language Updated"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)showHelp:(id)sender{
    UIStoryboard *mainStoryboard =[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    UIViewController *vc =[mainStoryboard instantiateViewControllerWithIdentifier:@"Help"];
        vc.modalTransitionStyle =UIModalTransitionStyleCoverVertical;
        vc.modalPresentationStyle =UIModalPresentationFullScreen;

    [self presentViewController:vc animated:YES completion:nil];
    
    [Flurry logEvent:@"Help Displayed"];
}


#pragma mark - *** TABLEVIEW METHODS ***
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return arrIndexTitles.count;
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    arrLanguages =[self SQL_GetLanguagesStartingWith:arrIndexTitles[section]];
    
    return arrLanguages.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return arrIndexTitles;
}

-(NSInteger)tableView:(UITableView*)tableView sectionForSectionIndexTitle:(NSString*)title atIndex:(NSInteger)index{
    return [arrIndexTitles indexOfObject:title];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    /* Initialize custom cells */
    static NSString *cellID =@"cellCountry";

    Cell_Countries *cellCountries =[tableView dequeueReusableCellWithIdentifier:cellID];

    cellCountries.lblCountryName.textColor =kAppColor_Clouds;
    cellCountries.lblCountryName.highlightedTextColor =kAppColor_Clouds;
    cellCountries.lblCountryName.textAlignment =NSTextAlignmentNatural;
    
    /* Fill out fields */
    NSDictionary *dictInfo;
    arrLanguages =[self SQL_GetLanguagesStartingWith:arrIndexTitles[indexPath.section]];
    dictInfo =arrLanguages[indexPath.row];

    cellCountries.lblCountryName.text =dictInfo[@"Name"];

    cellCountries.imgFlag.image =nil;
    if (((int)indexPath.row == iTableSelectedRow) && ((int)indexPath.section == iTableSelectedSection)){
        cellCountries.imgFlag.image =[[UIImage imageNamed:@"Selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }else{
        cellCountries.imgFlag.image =[UIImage imageNamed:dictInfo[@"FlagFilename"]];
    }
    [DVM_SF DRAW_RoundLayer:cellCountries.imgFlag Radius:18.0 borderColor:kAppColor_Clouds borderWidth:1.25];
    
    return cellCountries;
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    NSString *sNewLanguage,*sSearchFor;
    int iSection =(int)indexPath.section;
    int iRow =(int)indexPath.row;

    sSearchFor =arrIndexTitles[iSection];
    arrLanguages =[self SQL_GetLanguagesStartingWith:sSearchFor];
    sNewLanguage =[arrLanguages[iRow] objectForKey:@"Name"];
    
    iTableSelectedRow =(int)indexPath.row;
    iTableSelectedSection =(int)indexPath.section;
    
    NSUserDefaults *uDef =[NSUserDefaults standardUserDefaults];
        [uDef setObject:sNewLanguage forKey:@"TranslationLanguage"];
        [uDef setInteger:indexPath.row forKey:@"SelectedLanguage_Row"];
        [uDef setInteger:indexPath.section forKey:@"SelectedLanguage_Section"];
    [uDef synchronize];

    NSArray *arrCells =tableView.visibleCells;
    for (Cell_Countries *cell in arrCells){
        cell.imgFlag.image =[UIImage imageNamed:[self SQL_GetFlagForCountry:cell.lblCountryName.text]];
    }

    Cell_Countries *cell =(Cell_Countries*)[tableView cellForRowAtIndexPath:indexPath];
        cell.imgFlag.image =[[UIImage imageNamed:@"Selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

-(void)tableView:(UITableView*)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    arrLanguages =[self SQL_GetLanguagesStartingWith:arrIndexTitles[indexPath.section]];
    NSDictionary *dictInfo =arrLanguages[indexPath.row];

    Cell_Countries *cell =(Cell_Countries*)[tableView cellForRowAtIndexPath:indexPath];
        cell.imgFlag.image =[UIImage imageNamed:dictInfo[@"FlagFilename"]];
}


#pragma mark - *** SQL METHODS ***
-(NSArray*)SQL_GetLanguagesStartingWith:(NSString*)sSearchFor{
    NSString *sQuery =[NSString stringWithFormat:@"SELECT * FROM tblLanguages WHERE UPPER(substr(Name,1,1))=UPPER('%@') "
                                                  "ORDER BY UPPER(Name) ASC;",sSearchFor];
    
    return [DVM_SF SQL_Query:sQuery db:kDB_Data];
}

-(NSArray*)SQL_GetLanguageNamed:(NSString*)sSearchFor{
    NSString *sQuery =[NSString stringWithFormat:@"SELECT * FROM tblLanguages WHERE Name='%@' ORDER BY UPPER(Name) ASC; ",sSearchFor];
    return [DVM_SF SQL_Query:sQuery db:kDB_Data];
}

-(NSString*)SQL_GetFlagForCountry:(NSString*)sSearchFor{
    NSString *sQuery =[NSString stringWithFormat:@"SELECT * FROM tblLanguages WHERE Name='%@' ORDER BY UPPER(Name) ASC; ",sSearchFor];
    NSArray *arrInfo =[DVM_SF SQL_Query:sQuery db:kDB_Data];
    if (arrInfo.count >0){
        return [arrInfo.firstObject objectForKey:@"FlagFilename"];
    }else{
        return @"";
    }
}

-(NSArray*)SQL_GetAllLanguages{
    NSArray *arrInfo =[DVM_SF SQL_Query:@"SELECT DISTINCT Name FROM tblLanguages ORDER BY UPPER(Name) ASC; " db:kDB_Data];
    
    NSMutableArray *marrTemp =[NSMutableArray new];
    for (int i=0; i <arrInfo.count; i++){
        [marrTemp addObject:[arrInfo[i] objectForKey:@"Name"]];
    }

    return [marrTemp copy];
}


#pragma mark - *** VIEW LIFECYCLE ***
-(BOOL)prefersStatusBarHidden{
    return NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
#endif
    return UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotate {
    return YES;
}

-(void)viewDidLoad{
    [super viewDidLoad];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    [self initialize];
    [self loadDefaults];
}

@end
