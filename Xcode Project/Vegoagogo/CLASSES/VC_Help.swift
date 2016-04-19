/*--------------------------------------------------------------------------------------------------------------------------
   File: VC_Help.swift
 Author: Kevin Messina
Created: June 10, 2015

©2015 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

// MARK: - *** CLASS DEFINITIONS *** -
class VC_Help: UIViewController {
    @IBOutlet var txt_HELP:UITextView!
    @IBOutlet var slider_FontSize:UISlider!
    @IBOutlet var toolbar_Top:UINavigationBar!
    @IBOutlet var toolbar_Bottom:UIToolbar!
    @IBOutlet var imgAppEdition:UIImageView!
    
    var paraCentered_Wrap = NSMutableParagraphStyle(),paraLeft_Wrap = NSMutableParagraphStyle()
    var attr_Header,attr_Title,attr_SubHeader,attr_Body,attr_Links,attr_SpacerLine:[String:AnyObject]!
    var textSize,titleSize,subHeaderSize,headerSize:Float!
    var headerColor,titleColor,subHeaderColor,bodyColor:UIColor!
    var verbiage,verbiage_plural,indent:String!
    var allText:NSMutableAttributedString!
    
    
// MARK: - *** FUNCTIONS *** -
    func loopHelpText( key key:String!,startIndx:Int!,endIndx:Int!,attribs:String!) -> Void {
        let edition = "\(appInfo.EDITION.Name)"
        let term = "\(verbiage)"
        let terms = "\(verbiage_plural)"
        let twitter = "\(appInfo.EDITION.Twitter_URL)"
        let website = "\(appInfo.EDITION.Website_URL)"
        
        for i in startIndx...endIndx {
            var text = NSLocalizedString("\(key)\(i)", comment: "")
                text = (text as NSString).stringByReplacingOccurrencesOfString("(verbiage)", withString: NSLocalizedString(term, comment: ""))
                text = (text as NSString).stringByReplacingOccurrencesOfString("(verbiage_plural)", withString: NSLocalizedString(terms, comment: ""))
                text = (text as NSString).stringByReplacingOccurrencesOfString("(appInfo.EDITION.Name)", withString: edition)
                text = (text as NSString).stringByReplacingOccurrencesOfString("(appInfo.EDITION.Website_URL)", withString: website)
                text = (text as NSString).stringByReplacingOccurrencesOfString("(appInfo.EDITION.Twitter_URL)", withString: twitter)
            
            if attribs == "Body" {
                allText.appendAttributedString(NSAttributedString(string:"\(indent)\(text)\n\n",attributes:attr_Body))
            }else if attribs == "Title" {
                allText.appendAttributedString(NSAttributedString(string:"\(text)\n",attributes:attr_Title))
                allText.appendAttributedString(NSAttributedString(string:"\n",attributes:attr_SpacerLine))
            }else if attribs == "SubHeader" {
                allText.appendAttributedString(NSAttributedString(string:"\n\(text)\n",attributes:attr_SubHeader))
            }
        }
    }
    
    func setFontSizes() -> Void {
        headerSize = (textSize + 12)
        subHeaderSize = (textSize + 2)
        titleSize = (textSize + 3)

        attr_Header = [NSParagraphStyleAttributeName:paraLeft_Wrap,
                       NSFontAttributeName:UIFont(name: "HelveticaNeue-Medium", size: CGFloat(headerSize))!,
                       NSForegroundColorAttributeName:headerColor]
        attr_SubHeader = [NSParagraphStyleAttributeName:paraLeft_Wrap,
                          NSFontAttributeName:UIFont(name: "HelveticaNeue-Thin", size: CGFloat(subHeaderSize))!,
                          NSForegroundColorAttributeName:subHeaderColor]
        attr_Title = [NSParagraphStyleAttributeName:paraLeft_Wrap,
                      NSFontAttributeName:UIFont(name: "HelveticaNeue-Medium", size: CGFloat(titleSize))!,
                      NSForegroundColorAttributeName:titleColor,
                      /*NSUnderlineStyleAttributeName:NSUnderlineStyle.StyleSingle.rawValue*/]
        attr_Body = [NSParagraphStyleAttributeName:paraLeft_Wrap,
                     NSFontAttributeName:UIFont(name: "HelveticaNeue-Light", size: CGFloat(textSize))!,
                     NSForegroundColorAttributeName:bodyColor]
        attr_Links = [NSForegroundColorAttributeName: Color.Crayon.Silver,
                      NSUnderlineColorAttributeName: Color.Crayon.Silver,
                      NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.hashValue]
        attr_SpacerLine = [NSFontAttributeName:UIFont(name: "HelveticaNeue-Light", size: CGFloat(textSize/3))!]
    }
    
// MARK: - *** ACTIONS *** -
    @IBAction func action_ChangeFontSize(slider:UISlider) -> Void {
        textSize = slider.value
        setFontSizes()

        NSUserDefaults.standardUserDefaults().setFloat(textSize, forKey:"fontSize")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        allText = NSMutableAttributedString()
        verbiage = (appInfo.EDITION.AppID == "VEG") ?NSLocalizedString("Help_Vegetarian_verbiage", comment: "")
                                                    :NSLocalizedString("Help_Vegan_verbiage", comment: "")
        verbiage_plural = (appInfo.EDITION.AppID == "VEG") ?NSLocalizedString("Help_Vegetarian_verbiage_plural", comment: "")
                                                           :NSLocalizedString("Help_Vegan_verbiage_plural", comment: "")
        indent = ""

        /* Set HEADER */
        var text:String!
        text = "\(appInfo.EDITION.FullName)"
        allText.appendAttributedString(NSAttributedString(string:"\(text)\n",attributes:attr_Header))
        
        text = "by \(appInfo.COMPANY.Name)\n" + "\(appInfo.COMPANY.Location)"
        allText.appendAttributedString(NSAttributedString(string:"\(text)\n\n",attributes:attr_SubHeader))

        /* Set OVERVIEW */
        loopHelpText(key:"Help_Overview_",startIndx:1,endIndx:1,attribs:"Title")
        loopHelpText(key:"Help_Overview_",startIndx:2,endIndx:4,attribs:"Body")
        
        /* Set USING */
        loopHelpText(key:"Help_Using_",startIndx:1,endIndx:1,attribs:"Title")
        loopHelpText(key:"Help_Using_",startIndx:2,endIndx:7,attribs:"Body")
        
        /* Set LANGUAGE */
        loopHelpText(key:"Help_Languages_",startIndx:1,endIndx:1,attribs:"Title")
        loopHelpText(key:"Help_Languages_",startIndx:2,endIndx:4,attribs:"Body")
        
        /* Set QUESTIONS */
        loopHelpText(key:"Help_Questions_",startIndx:1,endIndx:1,attribs:"Title")
        loopHelpText(key:"Help_Questions_",startIndx:2,endIndx:4,attribs:"Body")
        
        /* Set SETTINGS */
        loopHelpText(key:"Help_Settings_",startIndx:1,endIndx:1,attribs:"Title")
        loopHelpText(key:"Help_Settings_",startIndx:2,endIndx:3,attribs:"Body")
        
        /* Set HELP */
        loopHelpText(key:"Help_Help_",startIndx:1,endIndx:1,attribs:"Title")
        loopHelpText(key:"Help_Help_",startIndx:2,endIndx:2,attribs:"Body")
        
        /* Set THANKS */
        loopHelpText(key:"Help_Thanks_",startIndx:1,endIndx:1,attribs:"Title")
        loopHelpText(key:"Help_Thanks_",startIndx:2,endIndx:3,attribs:"Body")
        
        /* Set Conclusion */
//        loopHelpText(key:"Help_Conclusion_",startIndx:1,endIndx:1,attribs:"SubHeader")
//        
//        text = "\(appInfo.EDITION.Name)"
//        allText.appendAttributedString(NSAttributedString(string:"\(text)\n\n",attributes:attr_Body))
        
        loopHelpText(key:"Help_Conclusion_",startIndx:3,endIndx:3,attribs:"Body")

        text = "Bon voyage & bon appétit."
        allText.appendAttributedString(NSAttributedString(string:"\(text)\n",attributes:attr_Body))
        
//        /* Set Links to be bolded in text */
        allText.setAsLink(textToFind: appInfo.EDITION.Twitter_URL,linkURL: appInfo.EDITION.Twitter_URL,
            font:UIFont(name: "HelveticaNeue", size: CGFloat(textSize))!, activateLink: false)
        allText.setAsLink(textToFind: appInfo.COMPANY.Website_URL,linkURL: appInfo.COMPANY.Website_URL,
            font:UIFont(name: "HelveticaNeue", size: CGFloat(textSize))!, activateLink: false)
        allText.setAsLink(textToFind: kDev_URL,linkURL: kDev_URL,
            font:UIFont(name: "HelveticaNeue", size: CGFloat(textSize))!, activateLink: false)
        allText.setAsLink(textToFind: "Translated.net",linkURL: "Translated.net",
            font:UIFont(name: "HelveticaNeue", size: CGFloat(textSize))!, activateLink: false)
        allText.setAsLink(textToFind: "www.CatMacInnes.com",linkURL: "www.CatMacInnes.com",
            font:UIFont(name: "HelveticaNeue", size: CGFloat(textSize))!, activateLink: false)
        allText.setAsLink(textToFind: "iTunes App Store",linkURL: appInfo.EDITION.AppStore_URL,
            font:UIFont(name: "HelveticaNeue", size: CGFloat(textSize))!, activateLink: true)

        /* Set TextView Link Appearance NOTE: Font can't be changed from LinkTextAttributes */
        txt_HELP.linkTextAttributes = attr_Links

        txt_HELP.attributedText = allText
    }

    @IBAction func action_Close(btn:UIBarButtonItem) -> Void {
        NSUserDefaults.standardUserDefaults().setBool(true, forKey:"UserHasAcceptedTerms")
        NSUserDefaults.standardUserDefaults().synchronize()

        dismissViewControllerAnimated(true, completion: nil)
    }
   
    
// MARK: - *** LIFECYCLE *** -
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if appInfo.EDITION.AppID == "VEG" {
            imgAppEdition.image = UIImage(named: "Veggoagogo-logo")
        }else{
            imgAppEdition.image = UIImage(named: "Veganagogo-logo")
        }
        
        let fromColorData:NSData! = NSUserDefaults.standardUserDefaults().objectForKey("fromColor") as! NSData
        let toColorData:NSData! = NSUserDefaults.standardUserDefaults().objectForKey("toColor") as! NSData
        var fromColor:UIColor! = NSKeyedUnarchiver.unarchiveObjectWithData(fromColorData) as? UIColor ?? Color.TCP.Clouds
        let toColor:UIColor! = NSKeyedUnarchiver.unarchiveObjectWithData(toColorData) as? UIColor ?? Color.TCP.MidnightBlue
        sharedFunc.DRAW().gradient(view: self.view, startColor: fromColor, endColor: toColor)
        
        /* Initialize */
        txt_HELP.textContainerInset = UIDevice.currentDevice().is_iPad ?UIEdgeInsetsMake(15.0,15.0,15.0,15.0)
                                                                       :UIEdgeInsetsMake(5.0,5.0,5.0,5.0)

        /* Set Paragraph Stlye */
        paraCentered_Wrap.lineBreakMode = .ByWordWrapping
        paraCentered_Wrap.alignment = .Center
        paraLeft_Wrap.lineBreakMode = .ByWordWrapping
        paraLeft_Wrap.alignment = .Left
        
        /* Set Colors */
        // Is color too dark and use white instead?
        let selectedTheme:Int! = sharedFunc.DEFAULTS().getInt(key: "SelectedTheme")
        let info = DVM_SF.SQL_Query("SELECT * FROM tblThemes WHERE Indx=\(selectedTheme);", db: appInfo.DB.Data).first as? NSDictionary ?? nil
        if info != nil {
            let useWhiteColor:Bool! = info?.objectForKey("useWhiteAsLightColor") as? Bool ?? false
            if useWhiteColor == true { fromColor = Color.Crayon.Magnesium }
        }
        
        headerColor = Color.Crayon.Snow
        subHeaderColor = Color.Crayon.Snow
        titleColor = Color.Crayon.Snow
        bodyColor = Color.Crayon.Snow

        sharedFunc.DRAW().roundCorner(view: txt_HELP, radius: 10)
        toolbar_Top.tintColor = fromColor
        toolbar_Bottom.tintColor = toColor
        slider_FontSize.tintColor = toColor
        
        /* Set initial HELP font size */
        slider_FontSize.minimumTrackTintColor = Color.Crayon.Maraschino
        slider_FontSize.maximumTrackTintColor = Color.Crayon.Iron
        slider_FontSize.minimumValueImage = UIImage(named:"Font_Small")!.imageWithRenderingMode(.AlwaysTemplate)
        slider_FontSize.maximumValueImage = UIImage(named:"Font_Large")!.imageWithRenderingMode(.AlwaysTemplate)
        slider_FontSize.minimumValue = UIDevice.currentDevice().is_iPad ?18 :12
        slider_FontSize.maximumValue = UIDevice.currentDevice().is_iPad ?36 :22
        textSize = sharedFunc.DEFAULTS().getFloat(key:"fontSize",minValue:slider_FontSize.minimumValue,
                                                                 maxValue:slider_FontSize.maximumValue)
        setFontSizes()
        slider_FontSize.value = textSize
        action_ChangeFontSize(slider_FontSize)
        
        let sUserDeviceLanguage:String! = AppDelegate.SQL_GetLanguageForCode(NSLocale.preferredLanguages().first ?? "English")
        let bIsRightToLeft = AppDelegate.SQL_GetLanguageAlignmentFor(sUserDeviceLanguage)
        let btnClose:UIBarButtonItem! = UIBarButtonItem(image: UIImage(named: "Close")?.imageWithRenderingMode(.AlwaysTemplate), style: .Plain, target: self, action: "action_Close:")

        if Float(UIDevice.currentDevice().systemVersion) < 9.0 {
            if (bIsRightToLeft){
                toolbar_Top.topItem!.leftBarButtonItem = btnClose
            }else{
                toolbar_Top.topItem!.rightBarButtonItem = btnClose
            }
        }else{
            toolbar_Top.topItem!.rightBarButtonItem = btnClose
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        /* Reset text view scroll area to always go to top */
        txt_HELP.setContentOffset(CGPointZero, animated: false)
    }
}

