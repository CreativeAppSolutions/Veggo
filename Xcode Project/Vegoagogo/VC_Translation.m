/*----------------------------------------------------------------------
     File: Translation.m
   Author: Kevin Messina - Creative App Solutions, LLC - New York, USA
 Modifier:
  Created: September 20, 2014
 
 ©2014 Creative App Solutions, LLC. USA - All Rights Reserved
 ----------------------------------------------------------------------*/

#pragma mark - *** IMPORTS ***
#import "VC_Translation.h"
#import "iCarousel.h"
#import "Cell_Animals.h"

@interface VC_Translation () <UIGestureRecognizerDelegate,iCarouselDataSource,iCarouselDelegate,
                              UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@end

@implementation VC_Translation{
    IBOutlet UIButton *btnClose,*btnDark,*btnCloseLarge;
    IBOutlet UILabel *lblStatement,*lblQuestion,*lblLine;
    IBOutlet UIImageView *imgLogo,*imgLargeIcon,*imgLeftArrow,*imgRightArrow;
    IBOutlet UICollectionView *collection;
    IBOutlet UIView *rightFade,*leftFade;

    IBOutlet iCarousel *carousel;
    
    NSArray *arrQuestions,*arrLanguage,*arrItems_White,*arrItems_Red,*arrItems_White_Large,*arrItems_Red_Large;
    NSTimer *timer;
    int iImgNum,showImageNum;
    BOOL bPauseTimer,bIsRightToLeft;
    float fDefaultScreenBrightness;
    BOOL bIsDisplayDark;
    BOOL bWaitingForBackgroundColorChange;
    CAGradientLayer *maskLayer;
}


#pragma mark - *** INITIALIZE ***
-(void)initialize{
// ToDo: Only use this method when loading the database with new translations, it is a utility method to NSArchive info.
//    [self SQL_UpdateQuestions];
//    exit(0); //abort(0) //abort()
    
    bWaitingForBackgroundColorChange = false;
    
    /* Setup iCarousel items*/
    [self loadImages];

    carousel.type =iCarouselTypeLinear;
    carousel.decelerationRate =0.25; //0.95 standard
    
    /* Setup Collection View images */
    collection.backgroundColor = [UIColor clearColor];
    collection.opaque = false;

    [self addFadeGradientsToCollection];
    
    /* Display Dark? */
    bIsDisplayDark = [DVM_SF DEFAULTS_GetBool:@"DisplayDark" defaultVal:YES testVal:YES];
    [self setColors:bIsDisplayDark];
    
    /* Get Language to Display */
    NSString *sTranslationLanguage =[DVM_SF DEFAULTS_GetString:@"TranslationLanguage" defaultVal:@"English"];

    /* Get Statement */
    lblStatement.text =[self SQL_getPrimaryStatement:sTranslationLanguage];

    /* Get Question */
    int iSelectedQuestion =[DVM_SF DEFAULTS_GetInteger:@"SelectedQuestion" minVal:0 defaultVal:0 testVal:YES];
    iSelectedQuestion ++;
    arrQuestions =[self SQL_getQuestionNum:iSelectedQuestion forLanguage:sTranslationLanguage];
    NSData *data =[arrQuestions.firstObject objectForKey:@"Question"];
    NSString *sData =[NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (sData == nil) sData = @"";
    lblQuestion.text =sData;
    
    /* Set TextAlignments */
    lblStatement.textAlignment =NSTextAlignmentCenter;
    lblQuestion.textAlignment =NSTextAlignmentCenter;
    
    /* Is This a Thank-You type of Question? */
    BOOL bIsThankYou =[[arrQuestions.firstObject objectForKey:@"IsThankYou"] boolValue];
    collection.hidden =bIsThankYou;
    imgLogo.hidden =!bIsThankYou;
    lblStatement.hidden =bIsThankYou;
    imgLogo.image =[[UIImage imageNamed:@"LogoLarge"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    imgLogo.alpha =1.0;

    /* Add items to Carousel view */
    CGSize scrn = [UIScreen mainScreen].bounds.size;
    float xRightPos = (scrn.width -55);
    float xYPos =(scrn.height -31);
    float xLeftPos = 15;
    CGRect rightArrowRect = CGRectMake((bIsRightToLeft) ?xLeftPos :xRightPos,xYPos,40,21);
    CGRect leftArrowRect = CGRectMake((bIsRightToLeft) ?xRightPos :xLeftPos,xYPos,40,21);

    // NOTE: This is a hack fix for iPhone 4 screen in iOS 7.1 which doesn't know the screen was rotated.
    if (scrn.width == 320) { // assume this is an iPhone 4
        xRightPos =(scrn.height -55);
        xYPos =(scrn.width -31);
        rightArrowRect = CGRectMake((bIsRightToLeft) ?xLeftPos :xRightPos,xYPos,40,21);
        leftArrowRect = CGRectMake((bIsRightToLeft) ?xRightPos :xLeftPos,xYPos,40,21);
//        xRightPos =(scrn.height -58);
    }
    
    btnCloseLarge =[[UIButton alloc] initWithFrame:btnClose.frame];
    btnCloseLarge.backgroundColor =[UIColor clearColor];
    btnCloseLarge.opaque =NO;
    btnCloseLarge.tintColor =bIsDisplayDark ?[UIColor darkGrayColor] :[UIColor grayColor];
    [btnCloseLarge setImage:[[UIImage imageNamed:@"Close"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                   forState:UIControlStateNormal];
    [btnCloseLarge addTarget:self action:@selector(action_Close:) forControlEvents:UIControlEventTouchUpInside];
    [carousel addSubview:btnCloseLarge];
    
    imgLeftArrow =[[UIImageView alloc] initWithFrame:leftArrowRect];
    imgLeftArrow.image =[[UIImage imageNamed:(bIsRightToLeft) ?@"RightArrow" :@"LeftArrow"]
                      imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [carousel addSubview:imgLeftArrow];

    imgRightArrow =[[UIImageView alloc] initWithFrame:rightArrowRect];
    imgRightArrow.image =[[UIImage imageNamed:(bIsRightToLeft) ?@"LeftArrow" :@"RightArrow"]
                       imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [carousel addSubview:imgRightArrow];
}


#pragma mark - *** CODING METHODS ***
-(void)addFadeGradientsToCollection{
    NSArray *arrColors = bIsDisplayDark ?@[(id)[UIColor blackColor].CGColor, (id)[UIColor clearColor].CGColor]
                                        :@[(id)[UIColor whiteColor].CGColor, (id)[[UIColor whiteColor] colorWithAlphaComponent:0.01].CGColor];
    
    if (bIsRightToLeft == true) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
            collection.transform = CGAffineTransformMakeScale(-1, 1);
        }
        arrColors = [[arrColors reverseObjectEnumerator] allObjects];
    }
    
    leftFade.layer.sublayers = nil;
    CAGradientLayer *leftShadow = [CAGradientLayer layer];
        leftShadow.frame = CGRectMake(0, 0, leftFade.frame.size.width, leftFade.frame.size.height);
        leftShadow.startPoint = CGPointMake(0, 0.5);
        leftShadow.endPoint = CGPointMake(1.0, 0.5);
        leftShadow.colors = arrColors;
    [leftFade.layer addSublayer:leftShadow];

    rightFade.layer.sublayers = nil;
    CAGradientLayer *rightShadow = [CAGradientLayer layer];
        rightShadow.frame = CGRectMake(0, 0, rightFade.frame.size.width, rightFade.frame.size.height);
        rightShadow.startPoint = CGPointMake(1.0, 0.5);
        rightShadow.endPoint = CGPointMake(0, 0.5);
        rightShadow.colors = arrColors;
    [rightFade.layer addSublayer:rightShadow];
}

-(void)loadImages {
    NSString *sQuery1,*sQuery2;
    
    switch (kAppIDNum) {
        case kVEG:
            sQuery1 = @"SELECT * FROM tblImages_Small WHERE Grouping='Animals' ORDER BY DisplayOrder1 ASC;";
            sQuery2 = @"SELECT * FROM tblImages_Large WHERE Grouping='Animals' ORDER BY DisplayOrder1 ASC;";
            break;
        case kVGN:
            sQuery1 = @"SELECT * FROM tblImages_Small WHERE Grouping='AnimalProducts' OR Grouping='Animals' ORDER BY DisplayOrder2 ASC;";
            sQuery2 = @"SELECT * FROM tblImages_Large WHERE Grouping='AnimalProducts' OR Grouping='Animals' ORDER BY DisplayOrder2 ASC;";
            break;
    }

    NSArray *temp = [DVM_SF SQL_Query:sQuery1 db:kDB_Data];
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

    temp = [DVM_SF SQL_Query:sQuery2 db:kDB_Data];
    marrTemp_White = [NSMutableArray new];
    marrTemp_Red = [NSMutableArray new];

    for (int i=0; i <temp.count; i++) {
        sWhite = [temp[i] objectForKey:@"White_Img"];
        sRed = [temp[i] objectForKey:@"Red_Img"];
        [marrTemp_White addObject:sWhite];
        [marrTemp_Red addObject:sRed];
    }
    
    arrItems_White_Large = marrTemp_White.copy;
    arrItems_Red_Large = marrTemp_Red.copy;

    [collection reloadData];
}

-(void)setColors:(BOOL)bDisplayDark{
    bPauseTimer = true;
    
    btnClose.tintColor =bDisplayDark ?[UIColor darkGrayColor] :[UIColor grayColor];
    btnCloseLarge.tintColor =bDisplayDark ?[UIColor darkGrayColor] :[UIColor grayColor];
    btnDark.tintColor =bDisplayDark ?[UIColor darkGrayColor] :[UIColor grayColor];
    lblStatement.textColor =bDisplayDark ?[UIColor grayColor] :[UIColor darkGrayColor];
    lblQuestion.textColor =bDisplayDark ?kAppColor_Clouds :[UIColor darkGrayColor];
    lblLine.backgroundColor =[bDisplayDark ?[UIColor darkGrayColor] :[UIColor grayColor] colorWithAlphaComponent:0.75];

    leftFade.alpha = 0.0;
    rightFade.alpha = 0.0;
    [self addFadeGradientsToCollection];
    
    /* Animate Background Color */
    float __block startAlpha =bDisplayDark ?0.0 :1.0;

    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
         animations:^{
             self.view.backgroundColor =[UIColor colorWithWhite:startAlpha alpha:1.0];
             startAlpha =bDisplayDark ?(startAlpha +.1) :(startAlpha -.1);
         }
         completion:^(BOOL finished){
         }
     ];

    [btnDark setImage:[[btnDark imageForState:UIControlStateNormal] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
             forState:UIControlStateNormal];
    
    [btnClose setImage:[[btnClose imageForState:UIControlStateNormal] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
             forState:UIControlStateNormal];
    
    bPauseTimer = false;

    leftFade.alpha = 1.0;
    rightFade.alpha = 1.0;
}

-(void)updateTimerDisplay:(NSTimer*)theTimer{
    if (bPauseTimer) {
        [self setColors:bIsDisplayDark];

        [collection reloadData];

        bWaitingForBackgroundColorChange = false;

        [Flurry logEvent:@"Day/Night toggled"];

        return;
    }

    /* Determine only the visible rows in the collection */
    NSArray *arrVisibleRows = collection.indexPathsForVisibleItems;
    NSMutableArray *arrTemp = [NSMutableArray new];
    for (NSIndexPath *path in arrVisibleRows) {
        [arrTemp addObject:@(path.row)];
    }
    
    NSArray *arrSorted = [arrTemp sortedArrayUsingSelector:@selector(compare:)];
    int iFromRow = [[arrSorted firstObject] intValue];
    int iToRow = [[arrSorted lastObject] intValue];
    if (iImgNum >=iToRow) iImgNum =iToRow;
    if (iImgNum <=iFromRow) iImgNum =iFromRow;

    /* get the last animated number determine if its in range or not */
    NSIndexPath *indexPath;
    Cell_Animals *cell;
    BOOL isPointInsideView;
    do {
        if (iImgNum >iToRow) iImgNum =iFromRow;
        if (iImgNum <iFromRow) iImgNum =iToRow;
        
        /* get the visible cell to animate the image upon */
        indexPath = [NSIndexPath indexPathForRow:iImgNum inSection:0];
        cell =(Cell_Animals*)[collection cellForItemAtIndexPath:indexPath];
        
        /* If cell is positioned into gradient area, don't animate it */
        CGRect visibleRect = collection.bounds;
        float restrictedArea = leftFade.frame.size.width;
        CGRect reducedRect = CGRectMake(visibleRect.origin.x +restrictedArea -20,
                                        visibleRect.origin.y,
                                        visibleRect.size.width -(restrictedArea *2) +20,
                                        visibleRect.size.height);
        CGPoint aPoint = cell.frame.origin;
        isPointInsideView = CGRectContainsPoint(reducedRect, aPoint);
        if (isPointInsideView == false) {
            iImgNum ++;
        }
    } while (isPointInsideView == false);
    
    cell.translatesAutoresizingMaskIntoConstraints = true;
    cell.imgIcon.translatesAutoresizingMaskIntoConstraints = true;
    
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
         animations:^{
             cell.frame = CGRectMake(cell.frame.origin.x -15,cell.frame.origin.y -15,80,80);
             cell.imgIcon.frame = CGRectMake(cell.imgIcon.frame.origin.x,cell.imgIcon.frame.origin.y,80,80);
             cell.imgIcon.alpha = 1.0;
         }
         completion:^(BOOL finished){
             [UIView animateWithDuration:0.1 delay:0.8 options:UIViewAnimationOptionCurveEaseOut
                  animations:^{
                      cell.frame = CGRectMake(cell.frame.origin.x +15,cell.frame.origin.y +15,50,50);
                      cell.imgIcon.frame = CGRectMake(cell.imgIcon.frame.origin.x,cell.imgIcon.frame.origin.y,50,50);
                      cell.imgIcon.alpha = 0.5;
                  }
                  completion:^(BOOL finished){
                  }];
     }];
    
    iImgNum ++;
    if (iImgNum >iToRow){
        iImgNum =iFromRow;
    }
}


#pragma mark - *** ACTIONS ***
-(IBAction)action_Close:(id)sender{
    bPauseTimer = true;
    if (carousel.alpha == 0){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
             animations:^{
                 carousel.alpha = 0;
                 collection.alpha = 1;
             }
             completion:^(BOOL finished){
                 bPauseTimer =NO;
             }
        ];
    }
}

-(IBAction)action_ChangeBackground:(id)sender{
    bIsDisplayDark = !bIsDisplayDark;
    [[NSUserDefaults standardUserDefaults] setBool:bIsDisplayDark forKey:@"DisplayDark"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    bWaitingForBackgroundColorChange = true;
    bPauseTimer = true;
}


#pragma mark - *** SQL METHODS ***
-(NSArray*)SQL_GetLanguageInfoFor:(NSString*)sSearchFor{
    NSString *sQuery =[NSString stringWithFormat:@"SELECT * FROM tblLanguages WHERE Name='%@'; ",sSearchFor];
    
    return [DVM_SF SQL_Query:sQuery db:kDB_Data];
}

-(void)SQL_UpdateQuestions{
/*  This is a developer method that is used to load the database with NSArchived data to handle languages and
    charactersets that would normally not store well as text in an SQLite database. The idea is to set the Language, 
    AppEdition and the Questions in each language. Place a breakpoint at the end of the method and press the translate
    button. The database is copied to \Docs and this is the modified database needed to be placed in the main bundle.
    This is needed as you cannot write to a main bundle file. 
 */
    BOOL bFileExists =[DVM_SF FILES_DoesFileExist:[DVM_SF FILES_ReturnDocumentsPath:kDB_DataName]
                                     inMainBundle:NO inDocuments:YES inLibraryCaches:NO inTemp:NO Path:@""];
    if (!bFileExists){
        [DVM_SF FILES_copyFromMainBundleToDocsDirectoryFileNamed:kDB_DataName];
    }
    
    NSData *data;
    NSNumber *nIsPrimary,*nIsThankYou;
    NSString *sEdition = [NSString stringWithFormat:@"%@",kAppEdition];
    
// Enter LANGUAGE NAME here
    NSString *sLanguage =@"Dutch";
    NSArray *arrTempQuestions =@[
/*Statement*/  @"",
/*Answer 1*/   @"",
/*Answer 2*/   @"",
/*Answer 3*/   @"",
/*Answer 4*/   @"",
/*Answer 5*/   @"",
/*Commentary*/ @"",
/*Thank You*/  @""
   ];
  
      /* This is just a quick copyable set of blank items */
///*Statement*/  @"",
///*Answer 1*/   @"",
///*Answer 2*/   @"",
///*Answer 3*/   @"",
///*Answer 4*/   @"",
///*Answer 5*/   @"",
///*Commentary*/ @"",
///*Thank You*/  @""
    
    NSArray *arrArgs;
    for (int i=0; i <arrTempQuestions.count; i++) {
        nIsPrimary =[NSNumber numberWithInteger:(i==0) ?1 :0];
        nIsThankYou =[NSNumber numberWithInteger:((i==6) || (i==7)) ?1 :0];
        if ([arrTempQuestions[i] isEqualToString:@""]) {
            arrArgs =@[[NSNumber numberWithInteger:i],nIsPrimary,sLanguage,@"",sEdition,nIsThankYou];
        }else{
            data =[NSKeyedArchiver archivedDataWithRootObject:arrTempQuestions[i]];
            arrArgs =@[[NSNumber numberWithInteger:i],nIsPrimary,sLanguage,data,sEdition,nIsThankYou];
        }
        [DVM_SF SQL_NonQueryDB:[DVM_SF FILES_ReturnDocumentsPath:kDB_DataName]
                         Query:@"INSERT INTO tblQuestions (QuestionNum,IsPrimary,Language,Question,AppEdition,IsThankYou) "
                                "values (?,?,?,?,?,?);"
                     arguments:arrArgs];
    }

    NSLog(@"'%@' Language Added to Database.",sLanguage);
}

-(NSString*)SQL_getPrimaryStatement:(NSString*)sLanguage{
    NSString *sQuery =[NSString stringWithFormat:@"SELECT * FROM tblQuestions "
                                                  "WHERE IsPrimary=1 AND Language='%@' AND AppEdition='%@';",
                                                  sLanguage,kAppEdition];
    
    NSArray *arrInfo =[DVM_SF SQL_Query:sQuery db:kDB_Data];
    if (arrInfo.count >0){
        NSData *data =[arrInfo.firstObject objectForKey:@"Question"];
        NSString *sData =[NSKeyedUnarchiver unarchiveObjectWithData:data];
        return sData;
    }else{
        return @"";
    }
}

-(NSArray*)SQL_getQuestionNum:(int)iNum forLanguage:(NSString*)sLanguage{
    NSString *sQuery =[NSString stringWithFormat:@"SELECT * FROM tblQuestions "
                                                  "WHERE QuestionNum=%i AND Language='%@' AND AppEdition='%@';",
                                                  iNum,sLanguage,kAppEdition];
    return [DVM_SF SQL_Query:sQuery db:kDB_Data];
}


#pragma mark - *** GESTURE METHODS ***
-(void)doGesture_singleTap_ShowLarge:(UITapGestureRecognizer*)sender{
    bPauseTimer =YES;
    
    showImageNum =(int)sender.view.tag;
    
    carousel.backgroundColor =bIsDisplayDark ?[UIColor blackColor] :[UIColor clearColor];

    imgRightArrow.tintColor =bIsDisplayDark ?[UIColor darkGrayColor] :[UIColor grayColor];
    imgLeftArrow.tintColor =bIsDisplayDark ?[UIColor darkGrayColor] :[UIColor grayColor];
    imgLeftArrow.alpha =bIsDisplayDark ?0.75 :0.5;
    imgRightArrow.alpha =bIsDisplayDark ?0.75 :0.5;
    imgLeftArrow.image =[[UIImage imageNamed:(bIsRightToLeft) ?@"RightArrow" :@"LeftArrow"]
                      imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imgRightArrow.image =[[UIImage imageNamed:(bIsRightToLeft) ?@"LeftArrow" :@"RightArrow"]
                          imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    [carousel reloadData];
    carousel.currentItemIndex =showImageNum;

    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
         animations:^{
             carousel.alpha =kOPAQUE;
             collection.alpha =kOPAQUE;
         }
         completion:^(BOOL finished){
         }
    ];
    
    [Flurry logEvent:@"Show Large displayed"];
}


#pragma mark - *** COLLECTION VIEW METHODS ***
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // Adds inset to the collection view if there are not enough cells to fill the width.
    CGFloat cellSpacing = ((UICollectionViewFlowLayout *) collectionViewLayout).minimumLineSpacing;
    CGFloat cellWidth = ((UICollectionViewFlowLayout *) collectionViewLayout).itemSize.width;
    NSInteger cellCount = [collectionView numberOfItemsInSection:section];
    CGFloat inset = (collectionView.bounds.size.width - (cellCount * (cellWidth + cellSpacing))) * 0.5;
    inset = MAX(inset, 0.0);
    return UIEdgeInsetsMake(0.0, inset, 0.0, 0.0);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return arrItems_White_Large.count;
}

-(void)selectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UICollectionViewScrollPosition)scrollPosition{
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger iRow =indexPath.row;
    
    Cell_Animals *cell =(Cell_Animals*)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell_Animals" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        cell.opaque = false;
        cell.tag = iRow;
    
    NSString *sImgName = bIsDisplayDark ?arrItems_White[iRow] :arrItems_Red[iRow];
    UIImage *img = [UIImage imageNamed:sImgName];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
        if (bIsRightToLeft == true) {
            if ([sImgName.uppercaseString rangeOfString:@"MILK"].location != NSNotFound) {
                cell.transform = CGAffineTransformMakeScale(-1, 1);
            }
        }
        cell.imgIcon.image = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }else{
        if ([sImgName.uppercaseString rangeOfString:@"MILK"].location != NSNotFound) {
            cell.imgIcon.image = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }else{
            cell.imgIcon.image = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal].imageFlippedForRightToLeftLayoutDirection;
        }
    }

    cell.imgIcon.alpha = 0.5;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    bPauseTimer =YES;
    
    showImageNum = (int)indexPath.row;
    
    carousel.backgroundColor =bIsDisplayDark ?[UIColor blackColor] :[UIColor whiteColor];

    imgRightArrow.tintColor =bIsDisplayDark ?[UIColor darkGrayColor] :[UIColor grayColor];
    imgLeftArrow.tintColor =bIsDisplayDark ?[UIColor darkGrayColor] :[UIColor grayColor];
    imgLeftArrow.alpha =bIsDisplayDark ?0.75 :0.5;
    imgRightArrow.alpha =bIsDisplayDark ?0.75 :0.5;
    imgLeftArrow.image =[[UIImage imageNamed:(bIsRightToLeft) ?@"RightArrow" :@"LeftArrow"]
                      imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imgRightArrow.image =[[UIImage imageNamed:(bIsRightToLeft) ?@"LeftArrow" :@"RightArrow"]
                          imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    [carousel reloadData];
    carousel.currentItemIndex =showImageNum;

    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
         animations:^{
             carousel.alpha =kOPAQUE;
             collection.alpha =kOPAQUE;
         }
         completion:^(BOOL finished){
         }
    ];
    
    [Flurry logEvent:@"Show Large displayed"];
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
}


#pragma mark - *** iCAROUSEL METHODS ***
-(NSInteger)numberOfItemsInCarousel:(iCarousel*)carousel{
    return bIsDisplayDark ?arrItems_White_Large.count :arrItems_Red_Large.count;
}

-(UIView*)carousel:(iCarousel*)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView*)theView{
    if (theView ==nil){
        float fWidth =(self.view.bounds.size.height -20);
        theView =[[UIImageView alloc] initWithFrame:CGRectMake(0,25,fWidth,fWidth)];
        theView.contentMode =UIViewContentModeScaleAspectFit;
    }
    
    // set item label
    // remember to always set any properties of your carousel item views outside of the `if (view == nil) {...}` check
    // otherwise you'll get weird issues with carousel item content appearing in the wrong place in the carousel

    NSString *imageName =(bIsDisplayDark) ?arrItems_White_Large[index] :arrItems_Red_Large[index];
    UIImage *image = [UIImage imageNamed:imageName];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
        image = [UIImage imageNamed:imageName];
    }else{
        if ([imageName.uppercaseString rangeOfString:@"MILK"].location != NSNotFound) {
            image = [UIImage imageNamed:imageName];
        }else{
            image = [UIImage imageNamed:imageName].imageFlippedForRightToLeftLayoutDirection;
        }
    }

    ((UIImageView*)theView).image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    return theView;
}

-(CGFloat)carousel:(__unused iCarousel*)thecarousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value{
    //customize carousel display
    switch (option){
        case iCarouselOptionWrap:{ //normally you would hard-code this to YES or NO
            return YES;
        }
        case iCarouselOptionSpacing:{ //add a bit of spacing between the item views
//            return value * 1.05f;
            return (value *([UIScreen mainScreen].scale +.6));
        }
        case iCarouselOptionFadeMax:{
            if (thecarousel.type == iCarouselTypeCustom){
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:{
            return value;
        }
    }
}

-(NSInteger)numberOfPlaceholdersInCarousel:(__unused iCarousel*)carousel{
    //note: placeholder views are only displayed on some carousels if wrapping is disabled
    return 2;
}

-(UIView*)carousel:(__unused iCarousel*)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(UIView*)view{
// Remember to always set any properties of your carousel item views outside of the `if (view == nil) {...}` check otherwise
// you'll get weird issues with carousel item content appearing in the wrong place in the carousel.
    
    if (view ==nil){
        view =[[UIImageView alloc] initWithFrame:CGRectMake(0,0,200.0f,200.0f)];
        view.contentMode =UIViewContentModeScaleAspectFit;
    }else{
    }
    
    return view;
}

-(CATransform3D)carousel:(__unused iCarousel*)thecarousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, (float)(M_PI / 8.0f), 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * thecarousel.itemWidth);
}

-(void)carousel:(__unused iCarousel*)carousel didSelectItemAtIndex:(NSInteger)index{
//    NSNumber *item = (self.items)[(NSUInteger)index];
//    NSLog(@"Tapped view number: %@", item);
}

-(void)carouselCurrentItemIndexDidChange:(__unused iCarousel*)carousel{
//    NSLog(@"Index: %@", @(self.carousel.currentItemIndex));
}


#pragma mark - *** VIEW LIFECYCLE ***
-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeLeft;
}

-(void)viewDidLoad{
    [super viewDidLoad];

    NSString *sUserDeviceLanguage =[AppDelegate SQL_GetLanguageForCode:[NSLocale preferredLanguages].firstObject];
    bIsRightToLeft = [AppDelegate SQL_GetLanguageAlignmentFor:sUserDeviceLanguage];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:NO];

    if (timer || [timer isValid]){
        [timer invalidate];
        timer =nil;
    }

    iImgNum =0;

    bPauseTimer =NO;
    carousel.alpha =kCLEAR;
    
    if (!timer || ![timer isValid]){
        timer =[NSTimer scheduledTimerWithTimeInterval:1.0f
                                                target:self
                                              selector:@selector(updateTimerDisplay:)
                                              userInfo:nil
                                               repeats:YES];
    }

    collection.alpha =kCLEAR;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];

    [self initialize];
    [carousel reloadData];

    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         collection.alpha =kOPAQUE;
                     }
                     completion:^(BOOL finished){
                     }
     ];

    fDefaultScreenBrightness =[UIScreen mainScreen].brightness;
    [UIScreen mainScreen].brightness =1.0;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    if (timer || [timer isValid]){
        [timer invalidate];
        timer =nil;
    }

    [UIScreen mainScreen].brightness =fDefaultScreenBrightness;
}

@end
