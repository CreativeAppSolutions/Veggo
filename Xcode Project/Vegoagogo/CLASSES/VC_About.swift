/*--------------------------------------------------------------------------------------------------------------------------
   File: VC_About.swift
 Author: Kevin Messina
Created: June 8, 2015

©2015 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import StoreKit

// MARK: - *** CLASS DEFINITIONS *** -
class VC_About: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,SKStoreProductViewControllerDelegate,
                UITableViewDelegate,MFMailComposeViewControllerDelegate{
    @IBOutlet var collThemes:UICollectionView!
    @IBOutlet var collApps:UICollectionView!
    @IBOutlet var collLinks:UICollectionView!
    @IBOutlet var lbl_Title_Themes:UILabel!
    @IBOutlet var lbl_Title_Apps:UILabel!
    @IBOutlet var lbl_Title_About:UILabel!
    @IBOutlet var txt_AboutTxt:UITextView!
    @IBOutlet var img_AppEditionLogo:UIImageView!
    @IBOutlet var img_appLogo:UIImageView!
    @IBOutlet var navBar:UINavigationBar!
    @IBOutlet var vw_background1:UIView!
    @IBOutlet var vw_background2:UIView!
    @IBOutlet var vw_About:UIView!
    @IBOutlet var btn_ShowStats:UIButton!
    @IBOutlet var btn_Email:UIButton!
    @IBOutlet var table:UITableView!
    
    var arrThemes,arrApps,arrLinks:NSArray!
    var arrSections:[String]! = [],arrApplication:[[String!]]! = [],arrDatabases:[[String!]]! = [],arrLibraries:[[String!]]! = [],
        arrDevice:[[String!]]! = [],arrExtLibraries:[[String!]]! = []
    var selectedItem_Themes:NSIndexPath! = NSIndexPath(forRow: 0, inSection: 0)
    var bIsRightToLeft:Bool! = false
    var scalingTransform : CGAffineTransform!
    var fromColorData,toColorData:NSData!
    var fromColor,toColor:UIColor!
    var verbiage,verbiage_plural:String!
    
    let cellID_Color:String! = "cellColor"
    let cellID_Apps:String! = "cellApps"
    let cellID_Links:String! = "cellLinks"
    let CellID_About:String! = "cell_About"
    let CellID_Header:String! = "cell_AboutHeader"
    
    
// MARK: - *** FUNCTIONS *** -
    func setupAboutText() ->Void {
//        let term = "\(verbiage)"
//        let terms = "\(verbiage_plural)"
//
//        var text = NSLocalizedString("About_Blurb", comment: "")
//            text = (text as NSString).stringByReplacingOccurrencesOfString("(verbiage)", withString: NSLocalizedString(term, comment: ""))
//            text = (text as NSString).stringByReplacingOccurrencesOfString("(verbiage_plural)", withString: NSLocalizedString(terms, comment: ""))
        
        var text:String!
        if appInfo.EDITION.AppID == "VEG" {
            text = NSLocalizedString("About_Blurb_Veggo", comment: "")
        }else{
            text = NSLocalizedString("About_Blurb_Vegan", comment: "")
        }
        
        txt_AboutTxt.text = text
    }
    
// MARK: - *** ACTIONS *** -
    @IBAction func showStats(btn:UIButton) -> Void {
        let txt = btn_ShowStats.titleForState(.Normal)
        if txt == NSLocalizedString("About_Show_Stats", comment: "") {
            btn_ShowStats.setTitle(NSLocalizedString("About_Show_About", comment: ""), forState: .Normal)
            txt_AboutTxt.hidden = true
        }else{
            btn_ShowStats.setTitle(NSLocalizedString("About_Show_Stats", comment: ""), forState: .Normal)
            txt_AboutTxt.hidden = false
        }

        table.hidden = !txt_AboutTxt.hidden
    }
    
    @IBAction func showHelp(btn:UIBarButtonItem) -> Void {
        let vc = gBundle.instantiateViewControllerWithIdentifier("VC_Help") as! VC_Help
        presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func close(sender:UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func Email(sender:UIButton) {
        sharedFunc.MAIL().contactUs(delegate:self,viewController:self,titleColor:"darkblue",bannerColor:"darkblue",arrDBs:arrDatabases)
    }
    

    // MARK: - *** TABLEVIEW METHODS ***
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return arrSections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0){ return arrApplication.count
        }else if (section == 1){ return arrDevice.count
        }else if (section == 2){ return arrDatabases.count
        }else if (section == 3){ return arrLibraries.count
        }else if (section == 4){ return arrExtLibraries.count
        }else{ return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 22
    }

    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellID_Header) as! cell_AboutHeader
            cell.backgroundColor = Color.Crayon.Clear
            cell.opaque = false
            sharedFunc.DRAW().roundCorner(view: cell, radius: 5)
        
        cell.title?.text = arrSections[section] ?? "n/a"
        
        return cell
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        enum sectionsInTable:Int { case APP,DEVICE,DBs,FRs,LIBs }
        
        let row = indexPath.row
        let section = indexPath.section
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CellID_About, forIndexPath: indexPath) as! cell_About
        cell.backgroundColor = UIColor.clearColor()
        cell.opaque = false
        
        var arrInfo:[String!] = []
        
        if let lbl = sectionsInTable(rawValue: section) {
            switch lbl {
                //MARK: ---> APP
            case .APP:
                if arrApplication.count > 0 {
                    arrInfo = arrApplication[row]
                    cell.icon?.image = UIImage(named: "About_Apps")
                    let name = arrInfo[0] ?? "N/A"
                    cell.item?.text = name
                    cell.version?.text = (name.uppercaseString == "VERSION") ? "\(arrInfo[1])(\(arrInfo[2]))"
                        : "\(arrInfo[1])"
                }
                //MARK: ---> DEVICE
            case .DEVICE:
                if arrDevice.count > 0 {
                    arrInfo = arrDevice[row]
                    let iPad:Bool = UIDevice.currentDevice().is_iPad
                    switch row {
                    case 0,1: cell.icon?.image = UIImage(named: iPad ?"About_iPad" :"About_iPhone")
                    case 2,3,4: cell.icon?.image = UIImage(named: iPad ?"About_iPad_RAM" :"About_iPhone_RAM")
                    case 5,6,7: cell.icon?.image = UIImage(named: iPad ?"About_iPad_HDD" :"About_iPhone_HDD")
                    default: cell.icon?.image = UIImage(named: iPad ?"About_iPad" :"About_iPhone")
                    }
                    cell.item?.text = arrInfo[0] ?? "N/A"
                    cell.version?.text = "\(arrInfo[1])"
                }
                //MARK: ---> DATABASES
            case .DBs:
                if arrDatabases.count > 0 {
                    arrInfo = arrDatabases[row]
                    cell.icon?.image = UIImage(named: "About_Databases")
                    cell.item?.text = arrInfo[0] ?? "N/A"
                    cell.version?.text = "\(arrInfo[1])"
                }
                //MARK: ---> LIBRARIES
            case .FRs:
                if arrLibraries.count > 0 {
                    arrInfo = arrLibraries[row]
                    cell.icon?.image = UIImage(named: "About_Frameworks")
                    cell.item?.text = arrInfo[0] ?? "N/A"
                    cell.version?.text = "\(arrInfo[1])"
                }
                //MARK: ---> 3rd PARTY LIBRARIES
            case .LIBs:
                if arrExtLibraries.count > 0 {
                    arrInfo = arrExtLibraries[row]
                    cell.icon?.image = UIImage(named: "About_Libraries")
                    cell.item?.text = arrInfo[0] ?? "N/A"
                    cell.version?.text = "\(arrInfo[1])"
                }
            }
        }
        
        return cell
    }

    
// MARK: - *** COLLECTION METHODS *** -
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
            case appInfo.COLLECTIONS.Themes: return arrThemes.count
            case appInfo.COLLECTIONS.Apps: return arrApps.count
            case appInfo.COLLECTIONS.Links: return arrLinks.count
            default: return 0
        }
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellColor:cell_Color!
        let cellApps:cell_Apps!
        let cellLinks:cell_Links!

        switch collectionView.tag {
            case appInfo.COLLECTIONS.Themes: ()
                cellColor = collectionView.dequeueReusableCellWithReuseIdentifier(cellID_Color, forIndexPath: indexPath) as! cell_Color

                let info = arrThemes[indexPath.row] as? NSDictionary ?? nil
                if info != nil {
                    cellColor.lbl_Name.text = info!.objectForKey("Name") as? String ?? "n/a"
                    
                    // get colors for gradiant
                    sharedFunc.DRAW().removeSubLayers(view: cellColor.img_Color)
                    var fromColor,toColor:UIColor!
                    var arrRGBA:NSArray! = (info!.objectForKey("TopColor_RGBA") as! String).componentsSeparatedByString(",")
                    fromColor = UIColor(red: CGFloat(arrRGBA[0].floatValue / 255), green: CGFloat(arrRGBA[1].floatValue / 255), blue: CGFloat(arrRGBA[2].floatValue / 255), alpha: CGFloat(arrRGBA[3].floatValue))
                    arrRGBA = (info!.objectForKey("BottomColor_RGBA") as! String).componentsSeparatedByString(",")
                    toColor = UIColor(red: CGFloat(arrRGBA[0].floatValue / 255), green: CGFloat(arrRGBA[1].floatValue / 255), blue: CGFloat(arrRGBA[2].floatValue / 255), alpha: CGFloat(arrRGBA[3].floatValue))
                    // Create an image of a gradiant view
                    let img:UIImageView! = UIImageView(frame: CGRectMake(0,0,40,40))
                    sharedFunc.DRAW().gradient(view: img, startColor: fromColor, endColor: toColor)
                    cellColor.img_Color.image = DVM_SF.DRAW_returnImageOfView(img)
                    
                    // Highlight Selected Cell or not
                    if indexPath == selectedItem_Themes {
                        sharedFunc.DRAW().roundCorner(view: cellColor.img_Color, radius: 20, color: Color.Crayon.Snow.colorWithAlphaComponent(0.75), width: 2)
                    }else{
                        sharedFunc.DRAW().roundCorner(view: cellColor.img_Color, radius: 20, color: Color.Crayon.Clear, width: 0.0)
                    }
                }
                
                if Float(UIDevice.currentDevice().systemVersion) < 9.0 {
                    if bIsRightToLeft == true { cellColor.transform = scalingTransform }
                }
            
                return cellColor
            case appInfo.COLLECTIONS.Apps: ()
                cellApps = collectionView.dequeueReusableCellWithReuseIdentifier(cellID_Apps, forIndexPath: indexPath) as! cell_Apps

                let info = arrApps[indexPath.row] as? NSDictionary ?? nil
                if info != nil {
                    cellApps.img_Icon.image = UIImage(named:info!.objectForKey("appsImageFilename") as? String ?? "")
                        sharedFunc.DRAW().roundCorner(view:cellApps.img_Icon, radius: 7)

                    cellApps.lbl_Name.text = info!.objectForKey("appsName") as? String ?? ""
                }

                if Float(UIDevice.currentDevice().systemVersion) < 9.0 {
                    if bIsRightToLeft == true { cellApps.transform = scalingTransform }
                }
            
                return cellApps
            case appInfo.COLLECTIONS.Links: ()
                cellLinks = collectionView.dequeueReusableCellWithReuseIdentifier(cellID_Links, forIndexPath: indexPath) as! cell_Links
                    sharedFunc.DRAW().roundCorner(view: cellLinks.img_Icon, radius: 15)
                    cellLinks.img_Icon.backgroundColor = UIColor.clearColor() // Color.Crayon.Snow

                let imgName = arrLinks[indexPath.row].objectForKey("IMG") as? String ?? ""
                cellLinks.img_Icon.image = UIImage(named: imgName)

                let linkName = arrLinks[indexPath.row].objectForKey("Name") as? String ?? ""
                cellLinks.lbl_Link.text = "\(linkName)"
            
                if Float(UIDevice.currentDevice().systemVersion) < 9.0 {
                    if bIsRightToLeft == true { cellLinks.transform = scalingTransform }
                }

                return cellLinks
            default: return UICollectionViewCell()
        }
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        switch collectionView.tag {
            case appInfo.COLLECTIONS.Themes:
                selectedItem_Themes = indexPath

                let info = arrThemes[indexPath.row] as? NSDictionary ?? nil
                if info != nil {
                    /* set secondary background to primary background to keep current colors. */
                    vw_background2.layer.sublayers = vw_background1.layer.sublayers
                    vw_background2.alpha = kAlpha.opaque

                    /* get new colors */
                    var arrRGBA:NSArray! = (info!.objectForKey("TopColor_RGBA") as! String).componentsSeparatedByString(",")
                    fromColor = UIColor(red: CGFloat(arrRGBA[0].floatValue / 255), green: CGFloat(arrRGBA[1].floatValue / 255), blue: CGFloat(arrRGBA[2].floatValue / 255), alpha: CGFloat(arrRGBA[3].floatValue))
                    arrRGBA = (info!.objectForKey("BottomColor_RGBA") as! String).componentsSeparatedByString(",")
                    toColor = UIColor(red: CGFloat(arrRGBA[0].floatValue / 255), green: CGFloat(arrRGBA[1].floatValue / 255), blue: CGFloat(arrRGBA[2].floatValue / 255), alpha: CGFloat(arrRGBA[3].floatValue))
                    
                    /* redraw primary background to newly selected colors. */
                    sharedFunc.DRAW().removeSubLayers(view: vw_background1)
                    sharedFunc.DRAW().gradient(view: vw_background1, startColor: fromColor, endColor: toColor)

                    /* animate transition via a fade to transparent revealing the new primary background colors */
                    UIView.animateWithDuration(Double(0.5), animations: {
                        self.vw_background2.alpha = kAlpha.transparent
                    }, completion: { finished in
                        /* set navbar tintcolor to the new color */
                        self.navBar.tintColor = self.fromColor
                    })
                    
                    /* save new colors */
                    let themeIndex:Int! = info!.objectForKey("Indx") as? Int ?? 1
                    let TopColorIsLightColor:Bool! = info!.objectForKey("TopColorIsLightColor") as? Bool ?? false
                    let uDef:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                        uDef.setObject(NSKeyedArchiver.archivedDataWithRootObject(fromColor), forKey:"fromColor")
                        uDef.setObject(NSKeyedArchiver.archivedDataWithRootObject(toColor), forKey:"toColor")
                        uDef.setBool(TopColorIsLightColor, forKey: "TopColorIsLightColor")
                        uDef.setInteger(themeIndex, forKey: "SelectedTheme")
                    uDef.synchronize()
                }
                
                /* reload collection view visible cells to show new selection */
                collThemes.reloadData()

                /* reload table to refresh colors from theme */
                table.reloadData()
            case appInfo.COLLECTIONS.Apps: ()
                if (sharedFunc.NETWORK().available() == true) && (UIDevice.currentDevice().is_Simulator == false) {
                    var appStoreID:Int! = 0
                    let info = arrApps[indexPath.row] as? NSDictionary ?? nil
                    if info != nil {
                        appStoreID = info!.objectForKey("appsAppStoreID") as? Int ?? 0
                    }
                    
                    if appStoreID != 0 {
                        let parameters = [SKStoreProductParameterITunesItemIdentifier: NSNumber(integer: appStoreID)]
                        let storeViewController = SKStoreProductViewController()
                            storeViewController.delegate = self
                    
                        storeViewController.loadProductWithParameters(parameters, completionBlock: { success, error in
                            if error != nil {
                                sharedFunc.ALERT().show(title: "APP STORE", style: AlertType.Failure, btnText: "OK",
                                        msg: "An error occured accessing the App Store.")
                            }
                            
                            if success == true {
                                self.presentViewController(storeViewController,animated: true, completion: nil)
                            }else{
                                sharedFunc.ALERT().show(title: "APP STORE", style: AlertType.Failure, btnText: "OK",
                                        msg: "Could not find the app.")
                            }
                        })
                    }else{
                        sharedFunc.ALERT().show(title: "APP STORE", style: AlertType.Failure, btnText: "OK",
                            msg: "Could not find the app.")
                    }
                }else{
                    sharedFunc.ALERT().show(title: "No Internet", style: AlertType.Warning, btnText: "OK",
                        msg: "You must be connected to the internet to view this page.")
                }
            case appInfo.COLLECTIONS.Links: ()
                let linkURL = arrLinks[indexPath.row].objectForKey("URL") as? String ?? ""
                if sharedFunc.NETWORK().available() {
                    if linkURL == appInfo.COMPANY.SupportEmail {
                        Email(btn_Email)
                    }else{
                        UIApplication.sharedApplication().openURL(NSURL(string: linkURL)!)
                    }
                }else{
                    sharedFunc.ALERT().show(title: "No Internet", style: AlertType.Warning, btnText: "OK",
                        msg: "You must be connected to the internet to view this page.")
                }
            default: ()
        }
    }

    
    // MARK: - *** MAILCOMPOSER *** -
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        sharedFunc.MAIL().uponCompletion(controller: controller, result: result, error: error)
        dismissViewControllerAnimated(true, completion: nil)
    }

    
// MARK: - *** STORE KIT *** -
    func productViewControllerDidFinish(viewController: SKStoreProductViewController) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
    

// MARK: - *** LIFECYCLE *** -
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        let orientation:UIInterfaceOrientationMask = [UIInterfaceOrientationMask.Portrait]
        return orientation
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /* Appearance */
        self.view.backgroundColor = Color.Crayon.Licorice
        fromColorData = NSUserDefaults.standardUserDefaults().objectForKey("fromColor") as! NSData
        toColorData = NSUserDefaults.standardUserDefaults().objectForKey("toColor") as! NSData
        fromColor = NSKeyedUnarchiver.unarchiveObjectWithData(fromColorData) as? UIColor ?? Color.TCP.Clouds
        toColor = NSKeyedUnarchiver.unarchiveObjectWithData(toColorData) as? UIColor ?? Color.TCP.MidnightBlue
        self.vw_background2.alpha = kAlpha.transparent
        navBar.tintColor = fromColor

        sharedFunc.DRAW().roundCorner(view: img_AppEditionLogo, radius: 8)
        sharedFunc.DRAW().roundCorner(view: vw_About, radius: 5)
        sharedFunc.DRAW().roundCorner(view: btn_ShowStats, radius: 5, color: Color.Crayon.Snow.colorWithAlphaComponent(0.5), width: 1)
        
        verbiage = (appInfo.EDITION.AppID == "VEG") ?NSLocalizedString("Help_Vegetarian_verbiage", comment: "")
                                                    :NSLocalizedString("Help_Vegan_verbiage", comment: "")
        verbiage_plural = (appInfo.EDITION.AppID == "VEG") ?NSLocalizedString("Help_Vegetarian_verbiage_plural", comment: "")
                                                           :NSLocalizedString("Help_Vegan_verbiage_plural", comment: "")
        setupAboutText()

        if appInfo.EDITION.AppID == "VEG" {
            img_appLogo.image = UIImage(named: "Veggoagogo-logo")
            img_AppEditionLogo.image = UIImage(named: "Icon-Veggo")
        }else{
            img_appLogo.image = UIImage(named: "Veganagogo-logo")
            img_AppEditionLogo.image = UIImage(named: "Icon-Vegan")
        }
        
        var fontSize:Float!
        switch UIDevice.currentDevice().modelScreen().size {
            case kSCREEN_SIZE.inch_3_5: fontSize = 13.0
            case kSCREEN_SIZE.inch_4: fontSize = 16.0
            case kSCREEN_SIZE.inch_4_7: fontSize = 18.0
            case kSCREEN_SIZE.inch_5_5: fontSize = 20.0
            default: fontSize = 13.0
        }
        
        txt_AboutTxt.font = UIFont(name: "HelveticaNeue-Thin", size: CGFloat(fontSize))
        txt_AboutTxt.textColor = UIColor.whiteColor()

        btn_ShowStats.setTitle(NSLocalizedString("About_Show_Stats", comment: ""), forState: .Normal)
        table.hidden = true
        txt_AboutTxt.hidden = false
        
        /* Add Navbar buttons according to language direction (R2L?) */
        let sUserDeviceLanguage:String! = AppDelegate.SQL_GetLanguageForCode(NSLocale.preferredLanguages().first ?? "English")
        bIsRightToLeft = AppDelegate.SQL_GetLanguageAlignmentFor(sUserDeviceLanguage)
        let btn_Help:UIBarButtonItem! = UIBarButtonItem(image: UIImage(named: "Help")?.imageWithRenderingMode(.AlwaysTemplate), style: .Plain, target: self, action: #selector(VC_About.showHelp(_:)))
        let btn_Close:UIBarButtonItem! = UIBarButtonItem(image: UIImage(named: "Close")?.imageWithRenderingMode(.AlwaysTemplate), style: .Plain, target: self, action: #selector(VC_About.close(_:)))

        if sUserDeviceLanguage.uppercaseString == "ENGLISH" {
            if Float(UIDevice.currentDevice().systemVersion) < 9.0 {
                navBar.topItem!.leftBarButtonItem = (bIsRightToLeft == true) ?btn_Close :btn_Help
                navBar.topItem!.rightBarButtonItem = (bIsRightToLeft == true) ?btn_Help :btn_Close
            }else{
                navBar.topItem!.leftBarButtonItem = btn_Help
                navBar.topItem!.rightBarButtonItem = btn_Close
            }
        }else{
            if Float(UIDevice.currentDevice().systemVersion) < 9.0 {
                if bIsRightToLeft == true {
                    navBar.topItem!.leftBarButtonItem = btn_Close
                }else{
                    navBar.topItem!.rightBarButtonItem = btn_Close
                }
            }else{
                navBar.topItem!.rightBarButtonItem = btn_Close
            }
        }
        
        // Setup localized language titles
        lbl_Title_Themes.textAlignment = .Natural
        lbl_Title_Apps.textAlignment = .Natural
        lbl_Title_About.textAlignment = .Natural
        lbl_Title_Themes.text = NSLocalizedString("About_Title_Themes", comment: "")
        lbl_Title_Apps.text = NSLocalizedString("About_Title_Apps", comment: "")
        lbl_Title_About.text = NSLocalizedString("About_Title_About", comment: "")

        if bIsRightToLeft == true { // Reverses the entire collection view into a mirror display. Must be undone in cells.
            scalingTransform = CGAffineTransformMakeScale(-1, 1)
            if Float(UIDevice.currentDevice().systemVersion) < 9.0 {
                collThemes.transform = scalingTransform
                collApps.transform = scalingTransform
                collLinks.transform = scalingTransform
            }
        }

        /* Initialize Defaults */
        arrThemes = DVM_SF.SQL_Query("SELECT * FROM tblThemes ORDER BY Indx ASC;",db:appInfo.DB.Data)
        let lowestIndex:Int! = arrThemes.firstObject?.objectForKey("Indx") as! Int
        let highestIndex:Int! = arrThemes.lastObject?.objectForKey("Indx") as! Int

        arrThemes = DVM_SF.SQL_Query("SELECT * FROM tblThemes ORDER BY UPPER(Name) ASC;",db:appInfo.DB.Data)
        collThemes.reloadData()

        // Get previously selected theme
        let selectedTheme:Int! = sharedFunc.DEFAULTS().getInt(key: "SelectedTheme", minValue: lowestIndex, maxValue: highestIndex)
        var iSelectedThemeIndex:Int! = 0
        for i in 0..<arrThemes.count {
            if arrThemes[i].objectForKey("Indx") as! Int == selectedTheme {
                iSelectedThemeIndex = i
                break
            }
        }
        selectedItem_Themes = NSIndexPath(forRow: iSelectedThemeIndex, inSection: 0)
        
        btn_Email.tintColor = UIColor.whiteColor()
        btn_Email.setImage(UIImage(named: "Settings_Email")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        
        // Setup Apps Collection
        arrApps = DVM_SF.SQL_Query("SELECT * FROM tblApps ORDER BY appsName ASC;",db:appInfo.DB.Data)
        collApps.reloadData()

        // Setup Links Collection
        let arrTemp:NSMutableArray! = NSMutableArray()
        if appInfo.COMPANY.SupportEmail.trimSpaces != "" { arrTemp.addObject(["URL":"\(appInfo.COMPANY.SupportEmail)",
                                                                             "IMG":"EMail","Name":"Contact Us"]) }
        if appInfo.EDITION.Website_URL.trimSpaces != "" { arrTemp.addObject(["URL":"\(appInfo.EDITION.Website_URL)",
                                                                             "IMG":"AgogoLogo","Name":"Agogo Apps"]) }
        if appInfo.COMPANY.Website_VEG_URL.trimSpaces != "" { arrTemp.addObject(["URL":"\(appInfo.COMPANY.Website_VEG_URL)",
                                                                                 "IMG":"Veggo","Name":"Veggoagogo"]) }
        if appInfo.COMPANY.Website_VGN_URL.trimSpaces != "" { arrTemp.addObject(["URL":"\(appInfo.COMPANY.Website_VGN_URL)",
                                                                                 "IMG":"Vegan","Name":"Veganagogo"]) }
        if appInfo.EDITION.YouTube_URL.trimSpaces != "" { arrTemp.addObject(["URL":"\(appInfo.EDITION.YouTube_URL)",
                                                                             "IMG":"YouTube","Name":"YouTube"]) }
        if appInfo.EDITION.FaceBook_URL.trimSpaces != "" { arrTemp.addObject(["URL":"\(appInfo.EDITION.FaceBook_URL)",
                                                                              "IMG":"Facebook","Name":"Facebook"]) }
        if appInfo.EDITION.Twitter_URL.trimSpaces != "" { arrTemp.addObject(["URL":"\(appInfo.EDITION.Twitter_URL)",
                                                                             "IMG":"Twitter","Name":"Twitter"]) }
        if appInfo.EDITION.GooglePlus_URL.trimSpaces != "" { arrTemp.addObject(["URL":"\(appInfo.EDITION.GooglePlus_URL)",
                                                                                "IMG":"Google+","Name":"Google+"]) }
        if appInfo.EDITION.LinkedIn_URL.trimSpaces != "" { arrTemp.addObject(["URL":"\(appInfo.EDITION.LinkedIn_URL)",
                                                                              "IMG":"LinkedIn","Name":"LinkedIn"]) }

        arrLinks = arrTemp
        collLinks.reloadData()
        
        // Setup ABOUT information
        arrSections = sharedFunc.APP().about_sectionNames
        arrDevice = sharedFunc.APP().about_deviceInfo
        arrApplication = sharedFunc.APP().about_appInfo
        arrDatabases = sharedFunc.APP().about_databaseInfo
        arrExtLibraries = Constants().getFabricVersion().NamesAndVersions
        arrLibraries = Constants().getLibraryVersions().NamesAndVersions

        /* Add Optional Libraries */
        
        table.reloadData()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sharedFunc.DRAW().gradient(view: vw_background1, startColor: fromColor, endColor: toColor)

        collThemes.scrollToItemAtIndexPath(selectedItem_Themes, atScrollPosition: .CenteredHorizontally, animated: false)
        collApps.scrollToItemAtIndexPath(NSIndexPath(forItem:0,inSection:0),atScrollPosition:.CenteredHorizontally,animated:false)
        collLinks.scrollToItemAtIndexPath(NSIndexPath(forItem:0,inSection:0),atScrollPosition:.CenteredHorizontally,animated:false)

        /* Reset text view scroll area to always go to top */
        txt_AboutTxt.setContentOffset(CGPointZero, animated: false)
    }
}

