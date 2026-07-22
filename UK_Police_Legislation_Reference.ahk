;===================================================================
; UK POLICE LEGISLATION REFERENCE
; A comprehensive AutoHotkey v2 application for police legislation
; Features: Search, favorites, keyboard shortcuts, modern UI
;===================================================================

#Requires AutoHotkey v2.0
#SingleInstance Force
SetWorkingDir A_ScriptDir

;===================================================================
; GLOBAL CONFIGURATION
;===================================================================
global APP_VERSION := "1.0.0"
global APP_TITLE := "UK Police Legislation Reference"
global CONFIG_FILE := A_AppData "\UKPoliceLegislation\config.ini"
global FAVORITES_FILE := A_AppData "\UKPoliceLegislation\favorites.ini"
global WINDOW_WIDTH := 1200
global WINDOW_HEIGHT := 800
global SIDEBAR_WIDTH := 250
global MAIN_PANEL_WIDTH := WINDOW_WIDTH - SIDEBAR_WIDTH

; Colors (Windows 11 Dark Theme)
global COLOR_BG := "1e1e1e"
global COLOR_SIDEBAR := "252526"
global COLOR_CARD := "2d2d30"
global COLOR_TEXT := "e8e8e8"
global COLOR_TEXT_SECONDARY := "a0a0a0"
global COLOR_ACCENT := "007acc"
global COLOR_HOVER := "3e3e42"

; UI State
global g_MainWindow := 0
global g_Legislation := Map()
global g_Favorites := Map()
global g_SearchText := ""

;===================================================================
; ENTRY POINT & HOTKEYS
;===================================================================

Esc::CloseApp()
^!p::ToggleApp()
^f::FocusSearchBar()
^c::CopySelectedLegislation()

;===================================================================
; INITIALIZATION
;===================================================================

CreateConfigDirectory()
LoadFavorites()
BuildLegislationDatabase()
CreateMainWindow()
LoadWindowPosition()

CreateConfigDirectory() {
    ConfigDir := A_AppData "\UKPoliceLegislation"
    if !DirExist(ConfigDir)
        DirCreate(ConfigDir)
}

;===================================================================
; LEGISLATION DATABASE
;===================================================================

BuildLegislationDatabase() {
    ; Police and Criminal Evidence Act 1984
    AddLegislation("Police and Criminal Evidence Act 1984", "PACE", "0078d4", [
        {section: "s.1", title: "Power of constable to stop and search", desc: "Stop and search persons/vehicles for stolen goods or weapons"},
        {section: "s.2", title: "Provisions relating to search under s.1", desc: "Procedures, grounds and rights during stop and search"},
        {section: "s.3", title: "Seizure of goods", desc: "Police power to seize articles believed to be evidence"},
        {section: "s.4", title: "Road checks", desc: "Stopping vehicles for examination"},
        {section: "s.17", title: "Entry without warrant – constable", desc: "Enter premises to save life/prevent serious damage"},
        {section: "s.18", title: "Entry and search after arrest", desc: "Search of premises for evidence after arrest"},
        {section: "s.19", title: "General power of seizure", desc: "Seizing property found on search"},
        {section: "s.24", title: "Arrest without warrant", desc: "Power to arrest without warrant for indictable offences"},
        {section: "s.28", title: "Information to be given on arrest", desc: "Inform person of arrest, grounds and rights"},
        {section: "s.34", title: "Effect of accused's failure to mention facts", desc: "Adverse inferences from silence during interview"},
        {section: "s.36", title: "Constable's power to require person arrested", desc: "Take fingerprints, samples, footwear impressions"},
        {section: "s.37", title: "Duties of custody officer", desc: "Responsibilities for detained persons"},
        {section: "s.40", title: "Review of police detention", desc: "Periodic review of detention necessity"},
        {section: "s.41", title: "Limits on period of detention", desc: "Maximum 36 hours without charge, 72 with warrant"},
        {section: "s.42", title: "Authorisation of continued detention", desc: "Magistrate can extend detention further"},
        {section: "s.43", title: "Warrants of further detention", desc: "Issuing warrants for extended detention"},
        {section: "s.46", title: "Duty of custody officer to release", desc: "Must release if ground for detention ceases"},
        {section: "s.54", title: "Searches of detained persons", desc: "Searching arrested persons for weapons/evidence"},
        {section: "s.55", title: "Intimate search", desc: "Only for weapons/class A drugs under warrant"},
        {section: "s.61", title: "Fingerprints", desc: "Power to take fingerprints from arrested persons"},
        {section: "s.62", title: "Intimate samples", desc: "Taking saliva/blood samples with consent"},
        {section: "s.63", title: "Non-intimate samples", desc: "Hair, nail samples, buccal swabs"},
        {section: "s.64", title: "DNA profiles", desc: "Creating DNA profiles from samples"},
        {section: "s.76", title: "Confessions", desc: "Admissibility of confessions in evidence"},
        {section: "s.78", title: "Exclusion of unfair evidence", desc: "Court can exclude unfairly obtained evidence"}
    ])
    
    ; Public Order Act 1986
    AddLegislation("Public Order Act 1986", "Public Order", "d83b01", [
        {section: "s.1", title: "Riot", desc: "12+ persons using unlawful violence with common purpose"},
        {section: "s.2", title: "Violent disorder", desc: "3+ persons using unlawful violence with common purpose"},
        {section: "s.3", title: "Affray", desc: "Using/threatening violence likely to cause fear"},
        {section: "s.4", title: "Fear or provocation of violence", desc: "Threatening words/behaviour intended to provoke"},
        {section: "s.5", title: "Harassment, alarm or distress", desc: "Threatening/abusive words/behaviour causing distress"},
        {section: "s.4A", title: "Intentional harassment, alarm or distress", desc: "Threatening/insulting/abusive words causing distress"},
        {section: "s.11", title: "Imposing conditions on processions", desc: "Police power to impose conditions on processions"},
        {section: "s.12", title: "Prohibiting public processions", desc: "Chief constable can ban processions"},
        {section: "s.14", title: "Imposing conditions on assemblies", desc: "Police power to impose conditions on gatherings"},
        {section: "s.18", title: "Stir up racial hatred", desc: "Use of words/behaviour intended to stir up racial hatred"},
        {section: "s.19", title: "Publishing written material", desc: "Publishing material intended to stir up hatred"},
        {section: "s.20", title: "Possession of articles with intent", desc: "Possessing articles for stirring hatred"}
    ])
    
    ; Road Traffic Act 1988
    AddLegislation("Road Traffic Act 1988", "Traffic", "f44336", [
        {section: "s.1", title: "Causing death by dangerous driving", desc: "Death caused by dangerous driving"},
        {section: "s.2", title: "Dangerous driving", desc: "Driving dangerously on road/public place"},
        {section: "s.3", title: "Careless and inconsiderate driving", desc: "Driving without proper care/attention"},
        {section: "s.4", title: "Driving under influence", desc: "Unfit through drink/drugs to drive safely"},
        {section: "s.5", title: "Driving with excess alcohol", desc: "Breath/blood alcohol limit exceeded"},
        {section: "s.6", title: "Requirement to provide specimen", desc: "Police power to require breath/blood specimens"},
        {section: "s.7", title: "Provision of specimens for analysis", desc: "Procedures for obtaining specimens"},
        {section: "s.35", title: "Requirement to submit to breath test", desc: "Police power to require breath test"},
        {section: "s.37", title: "Arrest for drink/drug driving", desc: "Arrest power for drink/drug driving"},
        {section: "s.87", title: "Driving without license", desc: "Offence to drive without valid license"},
        {section: "s.143", title: "Use of motor vehicle without insurance", desc: "Offence to drive uninsured"},
        {section: "s.163", title: "Power of police to stop vehicles", desc: "Stopping vehicles for inspection"},
        {section: "s.172", title: "Requirement to give information", desc: "Must provide driver details for offences"}
    ])
    
    ; Misuse of Drugs Act 1971
    AddLegislation("Misuse of Drugs Act 1971", "Drugs", "9c27b0", [
        {section: "s.2", title: "Restrictions on import/export", desc: "Prohibits import/export of controlled drugs"},
        {section: "s.4", title: "Restriction on possession", desc: "Possession of controlled drugs prohibited"},
        {section: "s.5", title: "Possession with intent to supply", desc: "Supply offence - maximum 14 years"},
        {section: "s.6", title: "Cultivation of cannabis", desc: "Prohibition on cultivating cannabis plants"},
        {section: "s.23", title: "Power to search for drugs", desc: "Warrant-less search for controlled drugs"},
        {section: "s.28", title: "Defences", desc: "Lack of knowledge of substance/quantity defences"},
        {section: "Schedule 1", title: "Class A Drugs", desc: "Heroin, Cocaine, MDMA, LSD, Psilocybin"},
        {section: "Schedule 2", title: "Class B Drugs", desc: "Amphetamine, Barbiturates, Cannabis"},
        {section: "Schedule 3", title: "Class C Drugs", desc: "Benzodiazepines, Anabolic steroids"}
    ])
    
    ; Theft Act 1968
    AddLegislation("Theft Act 1968", "Theft", "ff9800", [
        {section: "s.1", title: "Theft", desc: "Dishonestly appropriating property belonging to another"},
        {section: "s.2", title: "Dishonesty", desc: "Dishonestly definition including lack of consent"},
        {section: "s.3", title: "Property", desc: "Definition of property for theft purposes"},
        {section: "s.4", title: "Belonging to another", desc: "Property belonging to another person criteria"},
        {section: "s.8", title: "Robbery", desc: "Theft with force or threat of force"},
        {section: "s.9", title: "Burglary", desc: "Entry as trespasser with intent to steal/damage"},
        {section: "s.10", title: "Aggravated burglary", desc: "Burglary with firearm/weapon/explosive"},
        {section: "s.12", title: "Taking motor vehicle without consent", desc: "TWOC offence - joyriding"},
        {section: "s.20", title: "Blackmail", desc: "Unwarranted demand with threats"},
        {section: "s.22", title: "Handling stolen goods", desc: "Receiving or handling stolen goods"}
    ])
    
    ; Criminal Damage Act 1971
    AddLegislation("Criminal Damage Act 1971", "Violence", "e91e63", [
        {section: "s.1", title: "Destroying or damaging property", desc: "Damage/destroy property intending damage"},
        {section: "s.2", title: "Arson", desc: "Destroying/damaging property by fire"},
        {section: "s.3", title: "Aggravated criminal damage", desc: "Damage with intent to endanger life"},
        {section: "s.5", title: "Without lawful excuse", desc: "Defence of protection of property removed"},
        {section: "s.6", title: "Search warrants", desc: "Warrant to search for damage evidence"}
    ])
    
    ; Firearms Act 1968
    AddLegislation("Firearms Act 1968", "Firearms", "3f51b5", [
        {section: "s.1", title: "Firearm certificate", desc: "Requirement to hold certificate for possession"},
        {section: "s.2", title: "Shotgun certificate", desc: "Certificate required for shotguns"},
        {section: "s.5", title: "Prohibited weapons", desc: "Automatic/semi-automatic weapons prohibition"},
        {section: "s.11", title: "Possession without certificate", desc: "Offence to possess without certificate"},
        {section: "s.16", title: "Possession with intent to endanger", desc: "Possession of firearm with intent to endanger"},
        {section: "s.17", title: "Use of firearm to resist arrest", desc: "Using firearm to resist arrest"},
        {section: "s.19", title: "Carrying firearm in public place", desc: "Carrying loaded firearm without lawful authority"},
        {section: "s.21", title: "Convicted person possess firearm", desc: "Convicted persons cannot possess firearms"}
    ])
    
    ; Terrorism Act 2000
    AddLegislation("Terrorism Act 2000", "Terrorism", "d32f2f", [
        {section: "s.1", title: "Definition of terrorism", desc: "Action designed to influence government/public"},
        {section: "s.12", title: "Proscribed organisations", desc: "Secretary of State can proscribe organisations"},
        {section: "s.18", title: "Membership of proscribed organisations", desc: "Offence to be member of proscribed org"},
        {section: "s.38B", title: "Failure to disclose information", desc: "Not informing authorities of terrorism info"},
        {section: "s.57", title: "Possession for terrorist purposes", desc: "Possession of articles for terrorism"},
        {section: "s.58", title: "Collection of information for terrorism", desc: "Collecting information for terrorism"}
    ])
    
    ; Fraud Act 2006
    AddLegislation("Fraud Act 2006", "Fraud", "ff5722", [
        {section: "s.2", title: "Fraud by false representation", desc: "Making false representation with intent"},
        {section: "s.3", title: "Fraud by failing to disclose", desc: "Failing to disclose information with intent"},
        {section: "s.4", title: "Fraud by abuse of position", desc: "Abuse of position with intent to gain"},
        {section: "s.6", title: "Possession of articles for fraud", desc: "Possession of articles for fraud purposes"},
        {section: "s.7", title: "Making articles for fraud", desc: "Making/supplying articles for fraud"}
    ])
    
    ; Sexual Offences Act 2003
    AddLegislation("Sexual Offences Act 2003", "Sexual Offences", "00bcd4", [
        {section: "s.1", title: "Rape", desc: "Non-consensual penetration without consent"},
        {section: "s.2", title: "Assault by penetration", desc: "Non-consensual sexual assault by penetration"},
        {section: "s.3", title: "Sexual assault", desc: "Non-consensual sexual touching"},
        {section: "s.4", title: "Causing sexual activity without consent", desc: "Causing non-consensual sexual activity"},
        {section: "s.9", title: "Sexual activity with child", desc: "Any sexual activity with under 16 year old"},
        {section: "s.13", title: "Child sexual abuse material", desc: "Possession of indecent images"},
        {section: "s.14", title: "Grooming", desc: "Meeting child after grooming for abuse"},
        {section: "s.47", title: "Paying for sexual services of child", desc: "Paying for sexual services of under 18"}
    ])
    
    ; Domestic Abuse Act 2021
    AddLegislation("Domestic Abuse Act 2021", "Domestic Abuse", "c2185b", [
        {section: "s.1", title: "Meaning of domestic abuse", desc: "Abusive behaviour by partner/family member"},
        {section: "s.2", title: "Controlling or coercive behaviour", desc: "Pattern of controlling/coercive behaviour"},
        {section: "s.20", title: "Domestic Abuse Protection Notices", desc: "Emergency notice power to protect victims"},
        {section: "s.22", title: "Domestic Abuse Protection Orders", desc: "Court order power to protect victims"},
        {section: "s.24", title: "Breach of protection order", desc: "Offence to breach protection orders"},
        {section: "s.32", title: "Right to leave home", desc: "Confirms victims right to leave home"}
    ])
    
    ; Modern Slavery Act 2015
    AddLegislation("Modern Slavery Act 2015", "Other", "9c27b0", [
        {section: "s.1", title: "Slavery and servitude offence", desc: "Holding person in slavery/servitude"},
        {section: "s.2", title: "Human trafficking offence", desc: "Arranging/facilitating travel with intent"},
        {section: "s.45", title: "Duty to notify Secretary of State", desc: "Authorities notify of potential victims"},
        {section: "s.49", title: "Support to victims", desc: "Provision of support for identified victims"},
        {section: "s.53", title: "Transparency in supply chains", desc: "Modern slavery statement requirement"}
    ])
    
    ; Criminal Justice Act 2003
    AddLegislation("Criminal Justice Act 2003", "Other", "9c27b0", [
        {section: "s.142", title: "Aims of sentencing", desc: "Punishment, crime reduction, rehabilitation"},
        {section: "s.143", title: "Previous convictions", desc: "Must consider previous convictions in sentencing"},
        {section: "s.166", title: "Pre-sentence reports", desc: "Court requests information before sentencing"},
        {section: "s.224", title: "Dangerous offenders", desc: "Determination of public protection requirement"},
        {section: "s.269", title: "Offences without limit of time", desc: "Offences can be prosecuted indefinitely"},
        {section: "s.276", title: "Determination of minimum term", desc: "Sentencing for murder"}
    ])
    
    ; Offensive Weapons Act 2019
    AddLegislation("Offensive Weapons Act 2019", "Firearms", "3f51b5", [
        {section: "s.1", title: "Prohibition on supply of bladed products", desc: "Prohibits supply to under 18s"},
        {section: "s.5", title: "Corrosive products offence", desc: "Supply of corrosive products offence"},
        {section: "s.9", title: "Offensive weapons conviction order", desc: "Court order following conviction"},
        {section: "s.10", title: "Surrender of corrosive products", desc: "Surrendering corrosive substances"}
    ])
    
    ; Anti-social Behaviour Act 2014
    AddLegislation("Anti-social Behaviour, Crime and Policing Act 2014", "Public Order", "d83b01", [
        {section: "s.22", title: "Community protection notices", desc: "Notice to address anti-social behaviour"},
        {section: "s.23", title: "Breach of notice", desc: "Offence to breach notice"},
        {section: "s.34", title: "Closure powers", desc: "Can close premises causing anti-social behaviour"},
        {section: "s.60", title: "Dispersal powers", desc: "Direction to disperse group causing issues"}
    ])
}

AddLegislation(ActName, Category, Color, Sections) {
    g_Legislation[ActName] := {
        name: ActName,
        category: Category,
        color: Color,
        sections: Sections,
        expanded: false,
        favorite: false
    }
}

;===================================================================
; MAIN WINDOW CREATION
;===================================================================

CreateMainWindow() {
    global g_MainWindow, COLOR_BG, COLOR_SIDEBAR, COLOR_CARD, COLOR_TEXT, COLOR_TEXT_SECONDARY, COLOR_ACCENT
    
    ; Create main window
    g_MainWindow := Gui()
    g_MainWindow.Opt("+AlwaysOnTop +ToolWindow -Caption")
    g_MainWindow.BackColor := COLOR_BG
    
    ; Title Bar
    g_MainWindow.AddText("x0 y0 w1200 h30 BackgroundColor" COLOR_SIDEBAR, "")
    g_MainWindow.AddText("x10 y5 w1000 h20 c" COLOR_TEXT " BackgroundColor" COLOR_SIDEBAR, "🛡️ UK Police Legislation Reference")
    TitleText := g_MainWindow.LastControl
    TitleText.SetFont("s11 w600 Segoe UI")
    
    ; Minimize button
    g_MainWindow.AddButton("x1100 y5 w25 h20 -Theme cWhite BackgroundColor" COLOR_SIDEBAR, "−")
    MinBtn := g_MainWindow.LastControl
    MinBtn.OnEvent("Click", MinimizeApp)
    MinBtn.SetFont("s12")
    
    ; Close button  
    g_MainWindow.AddButton("x1135 y5 w25 h20 -Theme cWhite BackgroundColor" COLOR_SIDEBAR, "✕")
    CloseBtn := g_MainWindow.LastControl
    CloseBtn.OnEvent("Click", CloseApp)
    CloseBtn.SetFont("s12")
    
    ; Separator
    g_MainWindow.AddText("x0 y30 w1200 h1", "")
    
    ; Sidebar background
    g_MainWindow.AddText("x0 y31 w250 h769 BackgroundColor" COLOR_SIDEBAR, "")
    
    ; Categories title
    g_MainWindow.AddText("x10 y40 w230 h25 c" COLOR_ACCENT " BackgroundColor" COLOR_SIDEBAR, "📂 CATEGORIES")
    CatTitle := g_MainWindow.LastControl
    CatTitle.SetFont("s9 w600 Segoe UI")
    
    ; Search bar
    g_MainWindow.AddEdit("x260 y35 w930 h35 c" COLOR_TEXT " BackgroundColor" COLOR_CARD " vSearchBox", "")
    SearchBox := g_MainWindow.LastControl
    SearchBox.OnEvent("Change", SearchCallback)
    SearchBox.SetFont("s10 Segoe UI")
    
    ; Legislation content area
    g_MainWindow.AddListBox("x260 y85 w930 h685 c" COLOR_TEXT " BackgroundColor" COLOR_CARD " vLegislationList", "")
    LegList := g_MainWindow.LastControl
    LegList.SetFont("s9 Segoe UI")
    
    ; Status bar
    g_MainWindow.AddText("x0 y770 w1200 h30 BackgroundColor" COLOR_SIDEBAR " cGray vStatusBar", "Ready - Ctrl+F search | Ctrl+Alt+P toggle | ESC close")
    StatusBar := g_MainWindow.LastControl
    StatusBar.SetFont("s8 Segoe UI")
    
    ; Show window
    g_MainWindow.Show("w1200 h800 +AlwaysOnTop", APP_TITLE)
    
    UpdateMainPanel()
}

SearchCallback(GuiCtrlObj, Info) {
    global g_SearchText
    g_SearchText := GuiCtrlObj.Value
    UpdateMainPanel()
}

UpdateMainPanel() {
    global g_MainWindow, g_Legislation, g_SearchText, g_Favorites
    
    LegList := g_MainWindow["LegislationList"]
    if !IsObject(LegList)
        return
    
    LegList.Delete()
    
    for ActName, ActData in g_Legislation {
        bShowItem := false
        
        if (g_SearchText = "") {
            bShowItem := true
        } else {
            SearchLower := StrLower(g_SearchText)
            
            if (InStr(StrLower(ActName), SearchLower) > 0) {
                bShowItem := true
            } else {
                for Section in ActData.sections {
                    if (InStr(StrLower(Section.section), SearchLower) > 0 
                        || InStr(StrLower(Section.title), SearchLower) > 0
                        || InStr(StrLower(Section.desc), SearchLower) > 0) {
                        bShowItem := true
                        break
                    }
                }
            }
        }
        
        if (bShowItem) {
            FavMark := g_Favorites.Has(ActName) ? "♥ " : "♡ "
            LegList.Add(, FavMark . ActName " (" . ActData.sections.Length " sections)")
        }
    }
}

;===================================================================
; HOTKEY HANDLERS
;===================================================================

FocusSearchBar() {
    global g_MainWindow
    try {
        g_MainWindow["SearchBox"].Focus()
    }
}

CopySelectedLegislation() {
    global g_MainWindow
    try {
        LegList := g_MainWindow["LegislationList"]
        if (LegList.Value > 0) {
            Selected := LegList.GetText(LegList.Value)
            A_Clipboard := Selected
            MsgBox("Copied: " Selected, APP_TITLE, 64)
        }
    }
}

MinimizeApp(GuiCtrlObj, Info) {
    global g_MainWindow
    try {
        g_MainWindow.Minimize()
    }
}

ToggleApp() {
    global g_MainWindow
    try {
        if WinExist(APP_TITLE) {
            WinHide(APP_TITLE)
        } else {
            WinShow(APP_TITLE)
            WinActivate(APP_TITLE)
        }
    }
}

CloseApp(GuiCtrlObj := "", Info := "") {
    global g_MainWindow
    try {
        SaveWindowPosition()
        SaveFavorites()
        if IsObject(g_MainWindow)
            g_MainWindow.Destroy()
    }
    ExitApp()
}

;===================================================================
; FAVORITES MANAGEMENT
;===================================================================

LoadFavorites() {
    global g_Favorites, FAVORITES_FILE
    
    if FileExist(FAVORITES_FILE) {
        try {
            Lines := FileRead(FAVORITES_FILE)
            Loop Parse Lines, "`n" {
                if (A_LoopField != "") {
                    g_Favorites[A_LoopField] := true
                }
            }
        }
    }
}

SaveFavorites() {
    global g_Favorites, FAVORITES_FILE
    
    try {
        FavList := ""
        for Fav in g_Favorites {
            FavList .= Fav "`n"
        }
        
        if FileExist(FAVORITES_FILE)
            FileDelete(FAVORITES_FILE)
        if (FavList != "")
            FileAppend(FavList, FAVORITES_FILE)
    }
}

;===================================================================
; WINDOW POSITION MANAGEMENT
;===================================================================

LoadWindowPosition() {
    global g_MainWindow, CONFIG_FILE
    
    if FileExist(CONFIG_FILE) {
        try {
            WinX := IniRead(CONFIG_FILE, "Window", "X", "")
            WinY := IniRead(CONFIG_FILE, "Window", "Y", "")
            
            if (WinX != "" && WinY != "" && WinX > 0 && WinY > 0) {
                WinMove(WinX, WinY, , , APP_TITLE)
            }
        }
    }
}

SaveWindowPosition() {
    global g_MainWindow, CONFIG_FILE
    
    try {
        WinGetPos(&WinX, &WinY, , , APP_TITLE)
        IniWrite(WinX, CONFIG_FILE, "Window", "X")
        IniWrite(WinY, CONFIG_FILE, "Window", "Y")
    }
}

;===================================================================
; Application Exit Handler
;===================================================================

OnExit(CloseApp)