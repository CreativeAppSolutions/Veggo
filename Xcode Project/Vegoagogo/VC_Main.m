/*----------------------------------------------------------------------
     File: VC_Main.m
   Author: Kevin Messina - Creative App Solutions, LLC - New York, USA
 Modifier:
  Created: September 20, 2014
 
 ©2014 Creative App Solutions, LLC. USA - All Rights Reserved
 ----------------------------------------------------------------------*/

#pragma mark - *** IMPORTS ***
#import "VC_Main.h"
#import "Cell_Questions.h"
#import "VC_Translation.h"


#pragma mark - *** INTERFACE ***
@interface VC_Main () <UITableViewDataSource,UITableViewDelegate>
@end


#pragma mark - *** IMPLEMENTATION ***
@implementation VC_Main{
    IBOutlet UIImageView *imgCountry,*imgAnimal;
    IBOutlet UIBarButtonItem *btnLanguage;
    IBOutlet UIView *background;
    IBOutlet UITableView *table;
    IBOutlet UILabel *lblStatement;
    IBOutlet UIImageView *imgLogo;
    IBOutlet UINavigationBar *navBar;
    IBOutlet UIToolbar *toolBar;
    
    NSArray *arrQuestions,*arrItems_White,*arrItems_Red;
    NSTimer *timer;
    NSString *sLanguage;
    int iTableSelectedRow;
}


#pragma mark - *** CLASS VARIABLES ***
int iImgNum =0;

#pragma mark - *** INIIALIZATION ***
-(void)setupInterface{
    iTableSelectedRow =0;
    
    NSString *sUserDeviceLanguage =[AppDelegate SQL_GetLanguageForCode:[NSLocale preferredLanguages].firstObject];
    BOOL bIsRightToLeft =[AppDelegate SQL_GetLanguageAlignmentFor:sUserDeviceLanguage];
    
    UIBarButtonItem *btn1 =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Settings"]
                                                            style:UIBarButtonItemStylePlain
                                                           target:self
                                                           action:@selector(showSettings:)];

    UIBarButtonItem *btn3 =[[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Translate"]
                                                                   imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                                                            style:UIBarButtonItemStylePlain
                                                           target:self
                                                           action:@selector(showTranslation:)];

    btnLanguage =[[UIBarButtonItem alloc] initWithTitle:@"English"
                                                  style:UIBarButtonItemStylePlain
                                                 target:self
                                                 action:@selector(showLanguages:)];

    UIBarButtonItem *flexBtn =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                            target:self
                                                                            action:nil];

    UIBarButtonItem *fixedBtn =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                             target:self
                                                                             action:nil];
    fixedBtn.width =47;

    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
        if (bIsRightToLeft){
            navBar.topItem.leftBarButtonItem =btn1;
            [toolBar setItems:@[btn3,flexBtn,btnLanguage,fixedBtn]];
        }else{
            [toolBar setItems:@[fixedBtn,btnLanguage,flexBtn,btn3]];
            navBar.topItem.rightBarButtonItem =btn1;
        }
    }else{
        [toolBar setItems:@[fixedBtn,btnLanguage,flexBtn,btn3]];
        navBar.topItem.rightBarButtonItem =btn1;
    }

    lblStatement.textAlignment = NSTextAlignmentNatural;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notification_UpdateLanguage:)
                                                 name:@"notification_UpdateLanguage"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notification_UpdateBackground:)
                                                 name:@"notification_UpdateBackground"
                                               object:nil];
    
    [self updateLanguage];
}

-(void)loadDefaults{
    /* Localize */
    sLanguage =[AppDelegate SQL_GetLanguageForCode:[NSLocale preferredLanguages].firstObject];

    lblStatement.text =[self SQL_getPrimaryStatement:sLanguage];
    arrQuestions =[self SQL_getAllQuestionsForLanguage:sLanguage];

    if (arrQuestions.count >0) {
        int iSelectedQuestion =[DVM_SF DEFAULTS_GetInteger:@"SelectedQuestion" minVal:0 defaultVal:0 testVal:YES];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:iSelectedQuestion inSection:0];
        [table selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
        [self tableView:table didSelectRowAtIndexPath:indexPath];
    }

    [self loadItems];
}


#pragma mark - *** CODING METHODS ***
-(void)loadItems {
    NSString *sQuery;
    switch (kAppIDNum) {
        case kVEG:
            sQuery = @"SELECT * FROM tblImages_Small WHERE Grouping='Animals' ORDER BY DisplayOrder1 ASC;";
            break;
        case kVGN:
            sQuery = @"SELECT * FROM tblImages_Small WHERE Grouping='AnimalProducts' OR Grouping='Animals' ORDER BY DisplayOrder2 ASC;";
            break;
    }

    NSArray *temp = [DVM_SF SQL_Query:sQuery db:kDB_Data];
    NSMutableArray *marrTemp_White = [NSMutableArray new];
    NSMutableArray *marrTemp_Red = [NSMutableArray new];
    NSString *sWhite,*sRed;

    for (int i=0; i <temp.count; i++) {
        sWhite = [temp[i] objectForKey:@"White_Img"];
        sRed = [temp[i] objectForKey:@"Red_Img"];
        [marrTemp_White addObject:sWhite];
        [marrTemp_Red addObject:sRed];
    }
    
    arrItems_White = marrTemp_White.copy;
    arrItems_Red = marrTemp_Red.copy;
}

-(void)updateTimerDisplay:(NSTimer*)theTimer{
    int iMaxNumItems = (int)arrItems_White.count -1;
    
    iImgNum ++;
    if (iImgNum > iMaxNumItems){
        iImgNum =0;
    }

    UIImage *img;
    NSString *sImgName = arrItems_White[iImgNum];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
        img = [UIImage imageNamed:arrItems_White[iImgNum]];
    }else{
        if ([sImgName.uppercaseString rangeOfString:@"MILK"].location != NSNotFound) {
            img = [UIImage imageNamed:sImgName];
        }else{
            img = [UIImage imageNamed:sImgName].imageFlippedForRightToLeftLayoutDirection;
        }
    }

    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
         animations:^{
             imgAnimal.alpha =0.0;
         }
         completion:^(BOOL finished){
            imgAnimal.image =img;
            [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                 animations:^{
                    imgAnimal.alpha =1.0;
                 }
                 completion:^(BOOL finished){
                 }];
         }];
}

-(void)updateBackground{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
        imgAnimal.image = [UIImage imageNamed:arrItems_White[iImgNum]];
    }else{
        imgAnimal.image = [UIImage imageNamed:arrItems_White[iImgNum]].imageFlippedForRightToLeftLayoutDirection;
    }

    NSData *fromColorData =[[NSUserDefaults standardUserDefaults] objectForKey:@"fromColor"];
    NSData *toColorData =[[NSUserDefaults standardUserDefaults] objectForKey:@"toColor"];
    UIColor *fromColor =[NSKeyedUnarchiver unarchiveObjectWithData:fromColorData];
    UIColor *toColor =[NSKeyedUnarchiver unarchiveObjectWithData:toColorData];

    for (CALayer *layer in background.layer.sublayers) {
        [layer removeFromSuperlayer];
    }

    [DVM_SF DRAW_AddSubLayerGradientToLayer:background.layer fromColor:fromColor toColor:toColor];
    navBar.tintColor =fromColor;
    navBar.titleTextAttributes = @{NSForegroundColorAttributeName:fromColor};
    toolBar.tintColor =toColor;

    /* Display Logo */
//    imgLogo.hidden =![[NSUserDefaults standardUserDefaults] boolForKey:@"displayLogo"];
    imgLogo.hidden =YES;
}

-(void)updateLanguage{
    NSString *sTranslationLanguage =[DVM_SF DEFAULTS_GetString:@"TranslationLanguage" defaultVal:@"English"];
    NSArray *arrInfo =[self SQL_GetLanguageNamed:sTranslationLanguage];
    NSDictionary *dictInfo =arrInfo.firstObject;

    btnLanguage.title =dictInfo[@"Name"];
    imgCountry.image =[UIImage imageNamed:dictInfo[@"FlagFilename"]];
}


#pragma mark - *** ACTIONS ***
-(IBAction)showSettings:(id)sender{
    UIViewController *vc =[self.storyboard instantiateViewControllerWithIdentifier:@"VC_About"];
        vc.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
        vc.modalPresentationStyle =UIModalPresentationFullScreen;
    
    [self presentViewController:vc animated:YES completion:nil];
    
    [Flurry logEvent:@"Settings Displayed"];
}

-(IBAction)showTranslation:(id)sender{
    UIViewController *vc =[self.storyboard instantiateViewControllerWithIdentifier:@"Translation"];
        vc.modalTransitionStyle =UIModalTransitionStyleFlipHorizontal;
        vc.modalPresentationStyle =UIModalPresentationFullScreen;
    
    [self presentViewController:vc animated:YES completion:nil];
    
    [Flurry logEvent:@"Translation Displayed"];
}

-(IBAction)showLanguages:(id)sender{
    UIViewController *vc =[self.storyboard instantiateViewControllerWithIdentifier:@"Languages"];
        vc.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
        vc.modalPresentationStyle =UIModalPresentationFullScreen;
    
    [self presentViewController:vc animated:YES completion:nil];
    
    [Flurry logEvent:@"Languages Displayed"];
}


#pragma mark - *** TABLEVIEW METHODS ***
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return arrQuestions.count;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    /* Initialize custom cells */
    static NSString *cellID =@"cellQuestions";

    Cell_Questions *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    
    cell.selectedBackgroundView =[UIView new];
    cell.lblText.textColor =kAppColor_Clouds;
    cell.lblText.highlightedTextColor =kAppColor_Clouds;
    cell.lblText.textAlignment =NSTextAlignmentNatural;
    cell.backgroundColor =[UIColor clearColor];
    cell.opaque =NO;
    cell.indentationLevel =0;
    cell.imgIcon.tintColor =kAppColor_Clouds;
    
    /* Fill out fields */
    NSDictionary *dictInfo;
    dictInfo =arrQuestions[indexPath.row];

    NSData *data =dictInfo[@"Question"];
    NSString *sData =[NSKeyedUnarchiver unarchiveObjectWithData:data];
    cell.lblText.text =sData;
    
    NSString *sImgName = ((int)indexPath.row == iTableSelectedRow) ?@"Selected" :@"Unselected";
    
    cell.imgIcon.image =[[UIImage imageNamed:sImgName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    return cell;
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath{
    NSArray *arrCells =tableView.visibleCells;
    for (Cell_Questions *cell in arrCells){
        cell.imgIcon.image =[[UIImage imageNamed:@"Unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }

    Cell_Questions *cell =(Cell_Questions*)[tableView cellForRowAtIndexPath:indexPath];
    cell.imgIcon.image =[[UIImage imageNamed:@"Selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    iTableSelectedRow =(int)indexPath.row;
    
    [[NSUserDefaults standardUserDefaults] setInteger:indexPath.row forKey:@"SelectedQuestion"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)tableView:(UITableView*)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    Cell_Questions *cell =(Cell_Questions*)[tableView cellForRowAtIndexPath:indexPath];
    cell.imgIcon.image =[[UIImage imageNamed:@"Unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}


#pragma mark - *** SQL METHODS ***
-(NSArray*)SQL_GetLanguageNamed:(NSString*)sSearchFor{
    NSString *sQuery =[NSString stringWithFormat:@"SELECT * FROM tblLanguages WHERE Name='%@';",sSearchFor];

    return [DVM_SF SQL_Query:sQuery db:kDB_Data];
}

-(NSString*)SQL_getPrimaryStatement:(NSString*)sSearchFor{
    NSString *sQuery =[NSString stringWithFormat:@"SELECT * FROM tblQuestions "
                                                  "WHERE IsPrimary=1 AND Language='%@' AND AppEdition='%@';",
                                                  sSearchFor,kAppEdition];
    
    NSArray *arrInfo =[DVM_SF SQL_Query:sQuery db:kDB_Data];
    if (arrInfo.count >0){
        NSData *data =[arrInfo.firstObject objectForKey:@"Question"];
        NSString *sData =[NSKeyedUnarchiver unarchiveObjectWithData:data];
        return sData;
    }else{
        return @"";
    }
}

-(NSArray*)SQL_getAllQuestionsForLanguage:(NSString*)sSearchFor{
    NSString *sQuery =[NSString stringWithFormat:@"SELECT * FROM tblQuestions "
                       "WHERE IsPrimary=0 AND Language='%@' AND AppEdition='%@' AND Question!='' "
                       "ORDER BY QuestionNum ASC;",
                       sSearchFor,kAppEdition];
    return [DVM_SF SQL_Query:sQuery db:kDB_Data];
}


#pragma mark - *** NOTIFICATIONS ***
-(void)notification_UpdateLanguage:(NSNotification*)notification{
    [self updateLanguage];
}

-(void)notification_UpdateBackground:(NSNotification*)notification{
    [self updateBackground];
}


#pragma mark - *** LIFECYCLE ***
-(BOOL)prefersStatusBarHidden{
    return NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 80000
-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
#else
-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
#endif

-(BOOL)shouldAutorotate {
    return YES;
}

-(void)viewDidLoad {
    [super viewDidLoad];

    NSString *sUserDeviceLanguage =[AppDelegate SQL_GetLanguageForCode:[NSLocale preferredLanguages].firstObject];
    BOOL bIsRightToLeft =[AppDelegate SQL_GetLanguageAlignmentFor:sUserDeviceLanguage];

    /* Create virtual Flag & App Edition images ontop of UI */
    UIImageView *imgAppEdition;
    int imgHt = 42;
    int imgW = 173;
    if (bIsRightToLeft == true){
        imgCountry =[[UIImageView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width -58),(toolBar.frame.origin.y +5),48,31)];
        imgAppEdition =[[UIImageView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width -(imgW -3)),navBar.frame.origin.y,imgW,imgHt)];
    }else{
        imgCountry =[[UIImageView alloc] initWithFrame:CGRectMake(10,(toolBar.frame.origin.y +5),48,31)];
        imgAppEdition =[[UIImageView alloc] initWithFrame:CGRectMake(3,navBar.frame.origin.y,imgW,imgHt)];
    }
    
    /* Draw Flag image on UI */
    imgCountry.translatesAutoresizingMaskIntoConstraints =YES;
    [DVM_SF DRAW_RoundCornersWithRadius:3.0 Layer:imgCountry.layer];
    [self.view addSubview:imgCountry];
    
    /* Draw App Edition Logo image on UI */
    imgAppEdition.contentMode =UIViewContentModeScaleAspectFit;
    switch (kAppIDNum) {
        case kVEG: imgAppEdition.image =[UIImage imageNamed:@"Veggoagogo-logo"]; break;
        case kVGN: imgAppEdition.image =[UIImage imageNamed:@"Veganagogo-logo"]; break;
    }
    
    [self.view addSubview:imgAppEdition];

    [self setupInterface];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
        
    if (timer || [timer isValid]){
        [timer invalidate];
        timer =nil;
    }

    if (!timer || ![timer isValid]){
        timer =[NSTimer scheduledTimerWithTimeInterval:7.0f
                                                target:self
                                              selector:@selector(updateTimerDisplay:)
                                              userInfo:nil
                                               repeats:YES];
    }

    [self loadDefaults];
    [table reloadData];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];

    [self updateBackground];
    CGRect rect =imgCountry.frame;
        rect.origin.y =(toolBar.frame.origin.y +5);
    imgCountry.frame =rect;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    if (timer || [timer isValid]){
        [timer invalidate];
        timer =nil;
    }
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
