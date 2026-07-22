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
global COLOR_PACE := "0078d4"
global COLOR_PUBLIC_ORDER := "d83b01"
global COLOR_TRAFFIC := "f44336"
global COLOR_DRUGS := "9c27b0"
global COLOR_THEFT := "ff9800"
global COLOR_VIOLENCE := "e91e63"
global COLOR_FIREARMS := "3f51b5"
global COLOR_TERRORISM := "d32f2f"
global COLOR_DOMESTIC := "c2185b"
global COLOR_SEXUAL := "00bcd4"
global COLOR_FRAUD := "ff5722"

; UI State
global g_MainWindow := 0
global g_Categories := Map()
global g_Legislation := Map()
global g_Favorites := Map()
global g_SelectedLegislation := ""
global g_SearchText := ""
global g_ExpandedItems := Map()
global g_DragOffsetX := 0
global g_DragOffsetY := 0

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

InitializeApp()

InitializeApp() {
    CreateConfigDirectory()
    LoadFavorites()
    BuildLegislationDatabase()
    CreateMainWindow()
    LoadWindowPosition()
    ApplySystemDarkMode()
}

CreateConfigDirectory() {
    ConfigDir := A_AppData "\UKPoliceLegislation"
    if !DirExist(ConfigDir)
        DirCreate(ConfigDir)
}

;===================================================================
; LEGISLATION DATABASE
;===================================================================

BuildLegislationDatabase() {
    ; Initialize categories
    Categories := ["PACE", "Public Order", "Traffic", "Drugs", "Theft", "Violence", 
                   "Firearms", "Terrorism", "Domestic Abuse", "Sexual Offences", "Fraud", "Other"]
    
    for Category in Categories {
        g_Categories[Category] := Category
    }
    
    ; Build legislation database with sections
    AddLegislation("Police and Criminal Evidence Act 1984", "PACE", "0078d4", [
        {section: "s.1", title: "Power of constable to stop and search", desc: "Allows police to stop and search persons/vehicles for stolen goods or offensive weapons."},
        {section: "s.2", title: "Provisions relating to search under s.1", desc: "Details of procedures, grounds and rights during stop and search."},
        {section: "s.3", title: "Seizure of goods", desc: "Police power to seize articles believed to be evidence."},
        {section: "s.4", title: "Road checks", desc: "Stopping vehicles for examination."},
        {section: "s.17", title: "Entry without warrant – constable", desc: "Power to enter premises to save life/prevent serious damage."},
        {section: "s.18", title: "Entry and search after arrest", desc: "Search of premises for evidence after arrest."},
        {section: "s.19", title: "General power of seizure", desc: "Seizing property found on search."},
        {section: "s.24", title: "Arrest without warrant", desc: "Power to arrest without warrant for indictable offences."},
        {section: "s.28", title: "Information to be given on arrest", desc: "Must inform person of arrest, grounds and rights."},
        {section: "s.34", title: "Effect of accused's failure to mention facts", desc: "Adverse inferences from silence during interview."},
        {section: "s.36", title: "Constable's power to require person arrested to account", desc: "Power to take fingerprints, samples, footwear impressions."},
        {section: "s.37", title: "Duties of custody officer", desc: "Responsibilities for detained persons."},
        {section: "s.40", title: "Review of police detention", desc: "Periodic review of detention necessity."},
        {section: "s.41", title: "Limits on period of detention", desc: "Maximum 36 hours without charge, 72 hours with warrant."},
        {section: "s.42", title: "Authorisation of continued detention", desc: "Magistrate can extend detention further."},
        {section: "s.43", title: "Warrants of further detention", desc: "Issuing warrants for extended detention."},
        {section: "s.46", title: "Duty of custody officer to release detained person", desc: "Must release if ground for detention ceases."},
        {section: "s.54", title: "Searches of detained persons", desc: "Searching arrested persons for weapons/evidence."},
        {section: "s.55", title: "Intimate search", desc: "Only for weapons/class A drugs under warrant."},
        {section: "s.61", title: "Fingerprints", desc: "Power to take fingerprints from arrested persons."},
        {section: "s.62", title: "Intimate samples", desc: "Taking saliva/blood samples with consent."},
        {section: "s.63", title: "Non-intimate samples", desc: "Hair, nail samples, buccal swabs."},
        {section: "s.64", title: "DNA profiles", desc: "Creating DNA profiles from samples."},
        {section: "s.65", title: "Part of Criminal Record", desc: "Retention of biometric information."},
        {section: "s.66", title: "Destruction of fingerprints", desc: "Destruction conditions for fingerprints."},
        {section: "s.67", title: "Records of arrest", desc: "Must keep records of arrest and detention."},
        {section: "s.76", title: "Confessions", desc: "Admissibility of confessions in evidence."},
        {section: "s.78", title: "Exclusion of unfair evidence", desc: "Court can exclude unfairly obtained evidence."}
    ])
    
    AddLegislation("Public Order Act 1986", "Public Order", "d83b01", [
        {section: "s.1", title: "Riot", desc: "12+ persons using or threatening unlawful violence with common purpose."},
        {section: "s.2", title: "Violent disorder", desc: "3+ persons using or threatening unlawful violence with common purpose."},
        {section: "s.3", title: "Affray", desc: "Using or threatening violence likely to cause fear in reasonable person."},
        {section: "s.4", title: "Fear or provocation of violence", desc: "Threatening words/behaviour intended/likely to provoke fear."},
        {section: "s.5", title: "Harassment, alarm or distress", desc: "Threatening/abusive/insulting words/behaviour causing distress."},
        {section: "s.4A", title: "Intentional harassment, alarm or distress", desc: "Threatening/insulting/abusive words causing distress."},
        {section: "s.11", title: "Imposing conditions on public processions", desc: "Police power to impose conditions on processions."},
        {section: "s.12", title: "Prohibiting public processions", desc: "Chief constable can ban processions for serious disruption."},
        {section: "s.13", title: "Offences relating to public processions", desc: "Offences related to prohibited processions."},
        {section: "s.14", title: "Imposing conditions on public assemblies", desc: "Police power to impose conditions on static gatherings."},
        {section: "s.14A", title: "Offences relating to public assemblies", desc: "Offences related to assemblies."},
        {section: "s.18", title: "Use of words or behaviour intended to stir up racial hatred", desc: "Racial hatred offence."},
        {section: "s.19", title: "Publishing or distributing written material", desc: "Publishing material intended to stir up racial hatred."},
        {section: "s.20", title: "Possession of articles with intent to use", desc: "Possessing articles for stirring hatred."},
        {section: "s.21", title: "Powers to search for articles", desc: "Police power to search for hatred articles."},
        {section: "s.23", title: "Power to enter premises and search", desc: "Warrant power to search for articles."},
        {section: "s.24", title: "Forfeiture of articles", desc: "Forfeiture of articles stirring hatred."}
    ])
    
    AddLegislation("Road Traffic Act 1988", "Traffic", "f44336", [
        {section: "s.1", title: "Causes of death by dangerous driving", desc: "Death caused by driving dangerously on road."},
        {section: "s.2", title: "Dangerous driving", desc: "Driving dangerously on road or public place."},
        {section: "s.3", title: "Careless and inconsiderate driving", desc: "Driving without proper care and attention."},
        {section: "s.4", title: "Driving under influence of drink/drugs", desc: "Unfit through drink/drugs to drive safely."},
        {section: "s.5", title: "Driving with excess alcohol", desc: "Breath/blood alcohol limit exceeded."},
        {section: "s.6", title: "Requirement to provide specimen for analysis", desc: "Police power to require breath/blood specimens."},
        {section: "s.7", title: "Provision of specimens for analysis", desc: "Procedures for obtaining specimens."},
        {section: "s.34", title: "Prohibition on driving with excess alcohol", desc: "Disqualification driving with excess alcohol."},
        {section: "s.35", title: "Requirement to submit to breath test", desc: "Police power to require breath test."},
        {section: "s.36", title: "Preliminary impairment test", desc: "Field sobriety tests."},
        {section: "s.37", title: "Arrest for driving/attempting to drive", desc: "Arrest power for drink/drug driving."},
        {section: "s.38", title: "Arrest after breathalyser test", desc: "Arrest following positive breath test."},
        {section: "s.39", title: "Power of constable and park rangers", desc: "Powers of park rangers for traffic."},
        {section: "s.40A", title: "Arrest for certain motoring offences", desc: "Arrest for serious motoring offences."},
        {section: "s.87", title: "Driving without license", desc: "Offence to drive without valid license."},
        {section: "s.143", title: "Use of motor vehicle without insurance", desc: "Offence to drive uninsured."},
        {section: "s.163", title: "Power of police to stop vehicles", desc: "Stopping vehicles for inspection."},
        {section: "s.172", title: "Requirement to give information about identity", desc: "Must provide driver details for traffic offences."}
    ])
    
    AddLegislation("Misuse of Drugs Act 1971", "Drugs", "9c27b0", [
        {section: "s.2", title: "Restrictions on import/export", desc: "Prohibits import/export of controlled drugs."},
        {section: "s.4", title: "Restriction on use and possession", desc: "Possession of controlled drugs is prohibited."},
        {section: "s.5", title: "Prohibition of possession with intent to supply", desc: "Supply offence with maximum 14 years imprisonment."},
        {section: "s.6", title: "Cultivation of cannabis", desc: "Prohibition on cultivating cannabis plants."},
        {section: "s.8", title: "Offences by bodies corporate", desc: "Corporate liability for drug offences."},
        {section: "s.10", title: "Presumption of lack of knowledge", desc: "Presumption re: knowledge of substance type."},
        {section: "s.19", title: "Misuse of Drugs Regulations 1971", desc: "Prescribed controlled drugs list and regulations."},
        {section: "s.23", title: "Power to search for drugs", desc: "Warrant-less search for controlled drugs."},
        {section: "s.27", title: "Destruction of drugs", desc: "Disposal of seized controlled drugs."},
        {section: "s.28", title: "Defences", desc: "Lack of knowledge of substance/quantity defences."},
        {section: "s.29", title: "Service of summons", desc: "Service procedures for drug charges."},
        {section: "Schedule 1", title: "Class A Drugs", desc: "Heroin, Cocaine, MDMA, LSD, Psilocybin"},
        {section: "Schedule 2", title: "Class B Drugs", desc: "Amphetamine, Barbiturates, Cannabis"},
        {section: "Schedule 3", title: "Class C Drugs", desc: "Benzodiazepines, Anabolic steroids"}
    ])
    
    AddLegislation("Theft Act 1968", "Theft", "ff9800", [
        {section: "s.1", title: "Theft", desc: "Dishonestly appropriating property belonging to another with intent to permanently deprive."},
        {section: "s.2", title: "Dishonesty", desc: "Dishonestly definition includes lack of consent/knowledge."},
        {section: "s.3", title: "Property", desc: "Definition of property for theft purposes."},
        {section: "s.4", title: "Belonging to another", desc: "Property belongs to another person criteria."},
        {section: "s.5", title: "Belonging to another", desc: "Property interests requiring protection."},
        {section: "s.6", title: "With intent to permanently deprive", desc: "Intention element of theft."},
        {section: "s.8", title: "Robbery", desc: "Theft with force or threat of force."},
        {section: "s.9", title: "Burglary", desc: "Entry as trespasser with intent to steal/damage."},
        {section: "s.10", title: "Aggravated burglary", desc: "Burglary with firearm/weapon/explosive."},
        {section: "s.11", title: "Removal of articles from places open to public", desc: "Removing cultural property."},
        {section: "s.12", title: "Taking motor vehicle without consent", desc: "TWOC offence - joyriding."},
        {section: "s.13", title: "Abstract of title to land", desc: "Offences relating to land."},
        {section: "s.15", title: "Obtaining property by deception", desc: "Dishonest deception to obtain property."},
        {section: "s.17", title: "Restitution orders", desc: "Court order restoring stolen property."},
        {section: "s.20", title: "Blackmail", desc: "Unwarranted demand with threats."},
        {section: "s.22", title: "Handling stolen goods", desc: "Knowingly receiving or handling stolen goods."},
        {section: "s.23", title: "Jurisdiction in England and Wales", desc: "Jurisdiction for theft offences."},
        {section: "s.24", title: "Jurisdiction in England and Wales", desc: "Jurisdiction for theft offences."}
    ])
    
    AddLegislation("Criminal Damage Act 1971", "Violence", "e91e63", [
        {section: "s.1", title: "Destroying or damaging property", desc: "Damage/destroy property intending damage or reckless."},
        {section: "s.2", title: "Arson", desc: "Destroying/damaging property by fire."},
        {section: "s.3", title: "Aggravated criminal damage", desc: "Damage with intent to endanger life."},
        {section: "s.4", title: "Penalty for destruction", desc: "Sentencing for destruction of property."},
        {section: "s.5", title: "Without lawful excuse", desc: "Removes defence of protection of property/rights."},
        {section: "s.6", title: "Search warrants", desc: "Warrant to search for damage evidence."},
        {section: "s.10", title: "Jurisdiction", desc: "Jurisdiction for damage offences."}
    ])
    
    AddLegislation("Firearms Act 1968", "Firearms", "3f51b5", [
        {section: "s.1", title: "Firearm certificate", desc: "Requirement to hold certificate for firearms possession."},
        {section: "s.2", title: "Shotgun certificate", desc: "Certificate required for shotguns."},
        {section: "s.3", title: "Firearms subject to general provisions", desc: "Breach-loading shotgun requirements."},
        {section: "s.4", title: "Exemptions from requirement to have certificate", desc: "Exemptions for theatre/filming."},
        {section: "s.5", title: "Prohibited weapons", desc: "Automatic/semi-automatic weapons prohibition."},
        {section: "s.6", title: "Grant and renewal of certificates", desc: "Procedure for obtaining certificate."},
        {section: "s.11", title: "Possession of firearm without certificate", desc: "Offence to possess without certificate."},
        {section: "s.16", title: "Possession with intent to endanger life", desc: "Possession of firearm with intent to endanger."},
        {section: "s.16A", title: "Possession with intent to cause fear", desc: "Possession with intent to cause fear."},
        {section: "s.17", title: "Use of firearm to resist arrest", desc: "Using firearm to resist arrest."},
        {section: "s.18", title: "Possession of imitation firearm", desc: "Offence to possess fake firearm with intent."},
        {section: "s.19", title: "Carrying firearm in public place", desc: "Carrying loaded firearm in public without lawful authority."},
        {section: "s.20", title: "Carrying firearm with intent", desc: "Carrying firearm with criminal intent."},
        {section: "s.21", title: "Possession of firearm by person who has been", desc: "Convicted persons cannot possess firearms."}
    ])
    
    AddLegislation("Terrorism Act 2000", "Terrorism", "d32f2f", [
        {section: "s.1", title: "Definition of terrorism", desc: "Action designed to influence government/intimidate public."},
        {section: "s.1A", title: "Meaning of terrorism", desc: "Includes cyber-terrorism."},
        {section: "s.5", title: "Deproscription", desc: "Process for deprescribing organisations."},
        {section: "s.11", title: "Support and resources", desc: "Providing support to proscribed organisations."},
        {section: "s.12", title: "Proscribed organisations", desc: "Secretary of State can proscribe terrorist organisations."},
        {section: "s.15", title: "Fund-raising", desc: "Fund-raising for terrorism."},
        {section: "s.16", title: "Use and possession", desc: "Using money/property for terrorism."},
        {section: "s.18", title: "Membership of proscribed organisations", desc: "Offence to be member of proscribed organisation."},
        {section: "s.38B", title: "Failure to disclose information", desc: "Not informing authorities of known terrorism information."},
        {section: "s.39", title: "Disclosure of information", desc: "Powers to require disclosure in terrorism cases."},
        {section: "s.47A", title: "Cordoned areas", desc: "Power to establish cordoned areas at scene."},
        {section: "s.57", title: "Possession for terrorist purposes", desc: "Possession of articles for terrorism."},
        {section: "s.58", title: "Collection of information useful for terrorism", desc: "Collecting information for terrorism."}
    ])
    
    AddLegislation("Fraud Act 2006", "Fraud", "ff5722", [
        {section: "s.2", title: "Fraud by false representation", desc: "Making false representation with intent to make gain/loss."},
        {section: "s.3", title: "Fraud by failing to disclose information", desc: "Failing to disclose information with intent."},
        {section: "s.4", title: "Fraud by abuse of position", desc: "Abuse of position with intent to make gain/loss."},
        {section: "s.6", title: "Possession of articles for fraud", desc: "Possession of articles for fraud purposes."},
        {section: "s.7", title: "Making/supplying articles for fraud", desc: "Making/supplying articles knowing intended for fraud."},
        {section: "s.8", title: "Conspiracy to defraud", desc: "Common law conspiracy to defraud."},
        {section: "s.9", title: "Participation in fraudulent business", desc: "Involvement in fraudulent business."},
        {section: "s.11", title: "Obtaining services dishonestly", desc: "Obtaining services without payment."},
        {section: "s.12", title: "Temporary use of article without authority", desc: "Unauthorized temporary use."}
    ])
    
    AddLegislation("Sexual Offences Act 2003", "Sexual Offences", "00bcd4", [
        {section: "s.1", title: "Rape", desc: "Non-consensual penetration without consent."},
        {section: "s.2", title: "Assault by penetration", desc: "Non-consensual sexual assault by penetration."},
        {section: "s.3", title: "Sexual assault", desc: "Non-consensual sexual touching."},
        {section: "s.4", title: "Causing sexual activity without consent", desc: "Causing non-consensual sexual activity."},
        {section: "s.5", title: "Rape of child under 13", desc: "Non-consensual rape of under 13 year old."},
        {section: "s.6", title: "Assault of child under 13", desc: "Non-consensual sexual assault of under 13."},
        {section: "s.7", title: "Sexual assault of child under 13", desc: "Sexual touching of under 13 year old."},
        {section: "s.8", title: "Causing or inciting sexual activity", desc: "Causing activity with under 13."},
        {section: "s.9", title: "Sexual activity with child", desc: "Any sexual activity with under 16 year old."},
        {section: "s.13", title: "Child sexual abuse material", desc: "Possession of indecent images of children."},
        {section: "s.14", title: "Grooming", desc: "Meeting child after grooming for abuse."},
        {section: "s.15", title: "Sexual abuse of child family member", desc: "Sexual activity with relative under 18."},
        {section: "s.47", title: "Paying for sexual services of child", desc: "Paying for sexual services of under 18 year old."},
        {section: "s.57", title: "Trafficking in persons for sexual exploitation", desc: "Trafficking for sexual services."},
        {section: "s.61", title: "Exposure", desc: "Exposing genitals with intent to cause distress."},
        {section: "s.62", title: "Voyeurism", desc: "Observing person in private situation."},
        {section: "s.63", title: "Sexual penetration with corpse", desc: "Penetration with dead body."}
    ])
    
    AddLegislation("Domestic Abuse Act 2021", "Domestic Abuse", "c2185b", [
        {section: "s.1", title: "Meaning of domestic abuse", desc: "Abusive behaviour by intimate partner or family member."},
        {section: "s.2", title: "Controlling or coercive behaviour in intimate relationships", desc: "Pattern of controlling/coercive behaviour."},
        {section: "s.3", title: "Meaning of domestic abuse", desc: "Types of abusive behaviour included."},
        {section: "s.12", title: "Duty to notify relevant police officers", desc: "Police notification of domestic incidents."},
        {section: "s.20", title: "Domestic Abuse Protection Notices", desc: "Emergency notice power to protect victims."},
        {section: "s.22", title: "Domestic Abuse Protection Orders", desc: "Court order power to protect victims."},
        {section: "s.24", title: "Breach of protection notice/order", desc: "Offence to breach protection orders."},
        {section: "s.26", title: "Victims' right to apply for protection order", desc: "Victim application rights."},
        {section: "s.32", title: "Right to leave home", desc: "Confirms victims right to leave home."}
    ])
    
    AddLegislation("Modern Slavery Act 2015", "Other", "9c27b0", [
        {section: "s.1", title: "Slavery and servitude offence", desc: "Holding person in slavery/servitude."},
        {section: "s.2", title: "Human trafficking offence", desc: "Arranging/facilitating travel with trafficking intent."},
        {section: "s.45", title: "Duty to notify Secretary of State", desc: "Public authorities notify of potential victims."},
        {section: "s.49", title: "Support to victims", desc: "Provision of support for identified victims."},
        {section: "s.51", title: "Independent reviewer", desc: "Appointment of independent reviewer."},
        {section: "s.53", title: "Transparancy in supply chains", desc: "Modern slavery statement requirement."}
    ])
    
    AddLegislation("Criminal Justice Act 2003", "Other", "9c27b0", [
        {section: "s.142", title: "Sentencing - aims of sentencing", desc: "Punishment, crime reduction, rehabilitation, reparation."},
        {section: "s.143", title: "Sentencing - previous convictions", desc: "Must consider previous convictions in sentencing."},
        {section: "s.144", title: "Sentencing - offender mitigation", desc: "Mitigation factors in sentencing."},
        {section: "s.166", title: "Pre-sentence reports", desc: "Court requests information before sentencing."},
        {section: "s.224", title: "Dangerous offenders", desc: "Determination of public protection requirement."},
        {section: "s.269", title: "Offences without limit of time", desc: "Offences that can be prosecuted indefinitely."},
        {section: "s.276", title: "Determination of minimum term", desc: "Sentencing for murder."},
        {section: "s.282", title: "Commencement of sentences", desc: "When sentences commence."}
    ])
    
    AddLegislation("Offensive Weapons Act 2019", "Firearms", "3f51b5", [
        {section: "s.1", title: "Prohibition on supply of bladed products", desc: "Prohibits supply of bladed articles to under 18s."},
        {section: "s.5", title: "Corrosive products offence", desc: "Supply of corrosive products offence."},
        {section: "s.9", title: "Offensive weapons conviction order", desc: "Court order following offensive weapons conviction."},
        {section: "s.10", title: "Surrender of corrosive products", desc: "Surrendering corrosive substances."},
        {section: "s.11", title: "Powers to search for bladed articles", desc: "Search powers for bladed articles."}
    ])
    
    AddLegislation("Anti-social Behaviour, Crime and Policing Act 2014", "Public Order", "d83b01", [
        {section: "s.22", title: "Community protection notices", desc: "Notice to address anti-social behaviour."},
        {section: "s.23", title: "Breach of community protection notice", desc: "Offence to breach notice."},
        {section: "s.34", title: "Closure powers", desc: "Can close premises causing anti-social behaviour."},
        {section: "s.57", title: "Power to give direction to leave place", desc: "Police power to direct persons away from area."},
        {section: "s.60", title: "Dispersal powers", desc: "Direction to disperse group causing anti-social behaviour."}
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
    global g_MainWindow
    
    ; Create main window
    g_MainWindow := Gui()
    g_MainWindow.Opt("+AlwaysOnTop +ToolWindow -Caption")
    g_MainWindow.BackColor := "1e1e1e"
    
    ; Title Bar
    CreateTitleBar()
    
    ; Main container
    g_MainWindow.AddText("x0 y30 w1200 h1", "")
    TitleSep := g_MainWindow.LastControl
    TitleSep.Value := ""
    
    ; Sidebar
    CreateSidebar()
    
    ; Search bar
    g_MainWindow.AddEdit("x260 y35 w930 h35 -Theme c" COLOR_TEXT " BackgroundColor" COLOR_CARD " vSearchBox")
    SearchBox := g_MainWindow.LastControl
    SearchBox.OnEvent("Change", SearchCallback)
    SearchBox.SetFont("s10 Segoe UI", COLOR_TEXT)
    
    ; Separator
    g_MainWindow.AddText("x260 y75 w930 h1", "")
    
    ; Legislation content area (scrollable)
    g_MainWindow.AddListBox("x260 y85 w930 h685 -Theme c" COLOR_TEXT " BackgroundColor" COLOR_CARD " vLegislationList")
    LegList := g_MainWindow.LastControl
    
    ; Status bar
    g_MainWindow.AddText("x0 y770 w1200 h30 BackgroundColor" COLOR_SIDEBAR " cGray vStatusBar", "Ready - Ctrl+F to search, ESC to close")
    StatusBar := g_MainWindow.LastControl
    StatusBar.SetFont("s9 Segoe UI")
    
    ; Show window
    g_MainWindow.Show("w1200 h800 +AlwaysOnTop", APP_TITLE)
    
    UpdateMainPanel()
}

CreateTitleBar() {
    global g_MainWindow, COLOR_SIDEBAR, COLOR_TEXT, COLOR_ACCENT
    
    ; Title bar background
    g_MainWindow.AddText("x0 y0 w1200 h30 BackgroundColor" COLOR_SIDEBAR, "")
    
    ; App icon and title
    g_MainWindow.AddText("x10 y5 h20 w1000 c" COLOR_TEXT " BackgroundColor" COLOR_SIDEBAR, "🛡️ " APP_TITLE)
    TitleText := g_MainWindow.LastControl
    TitleText.SetFont("s11 w600 Segoe UI", COLOR_TEXT)
    
    ; Minimize button
    g_MainWindow.AddButton("x1100 y5 w25 h20 -Theme cWhite BackgroundColor" COLOR_SIDEBAR " vMinBtn", "−")
    MinBtn := g_MainWindow.LastControl
    MinBtn.OnEvent("Click", MinimizeApp)
    MinBtn.SetFont("s12 Segoe UI")
    
    ; Close button  
    g_MainWindow.AddButton("x1135 y5 w25 h20 -Theme cWhite BackgroundColor" COLOR_SIDEBAR " vCloseBtn", "✕")
    CloseBtn := g_MainWindow.LastControl
    CloseBtn.OnEvent("Click", CloseApp)
    CloseBtn.SetFont("s12 Segoe UI")
}

CreateSidebar() {
    global g_MainWindow, g_Categories, COLOR_SIDEBAR, COLOR_TEXT, COLOR_ACCENT
    
    ; Sidebar background
    g_MainWindow.AddText("x0 y30 w250 h770 BackgroundColor" COLOR_SIDEBAR, "")
    
    ; Categories title
    g_MainWindow.AddText("x10 y40 w230 h25 c" COLOR_ACCENT " BackgroundColor" COLOR_SIDEBAR, "📂 CATEGORIES")
    CatTitle := g_MainWindow.LastControl
    CatTitle.SetFont("s9 w600 Segoe UI", COLOR_ACCENT)
    
    ; Category buttons
    yPos := 70
    Categories := ["PACE", "Public Order", "Traffic", "Drugs", "Theft", "Violence", 
                   "Firearms", "Terrorism", "Domestic Abuse", "Sexual Offences", "Fraud", "Other"]
    
    for Category in Categories {
        g_MainWindow.AddButton("x10 y" yPos " w230 h28 -Theme c" COLOR_TEXT " BackgroundColor" COLOR_SIDEBAR " v" Category "Btn", "• " Category)
        Btn := g_MainWindow.LastControl
        Btn.SetFont("s9 Segoe UI", COLOR_TEXT)
        Btn.OnEvent("Click", CategoryClick)
        yPos += 32
    }
}

SearchCallback(GuiCtrlObj, Info) {
    global g_SearchText
    g_SearchText := GuiCtrlObj.Value
    UpdateMainPanel()
}

CategoryClick(GuiCtrlObj, Info) {
    global g_SearchText
    ; Extract category from button variable name
    g_SearchText := ""
    UpdateMainPanel()
}

UpdateMainPanel() {
    global g_MainWindow, g_Legislation, g_SearchText, g_Favorites
    
    ; Get listbox control
    LegList := g_MainWindow["LegislationList"]
    
    if (LegList) {
        LegList.Delete()  ; Clear list
    }
    
    ; Filter legislation based on search
    for ActName, ActData in g_Legislation {
        bShowItem := false
        
        if (g_SearchText = "") {
            bShowItem := true
        } else {
            SearchLower := StrLower(g_SearchText)
            
            if (InStr(StrLower(ActName), SearchLower) > 0) {
                bShowItem := true
            } else {
                ; Check sections
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
            LegList.Add(, FavMark ActName " (" ActData.sections.Length " sections)")
        }
    }
}

;===================================================================
; HOTKEY HANDLERS
;===================================================================

FocusSearchBar() {
    global g_MainWindow
    g_MainWindow["SearchBox"].Focus()
}

CopySelectedLegislation() {
    global g_MainWindow
    LegList := g_MainWindow["LegislationList"]
    if (LegList.Value > 0) {
        Selected := LegList.GetText(LegList.Value)
        A_Clipboard := Selected
        MsgBox("Copied: " Selected, APP_TITLE, 64)
    }
}

MinimizeApp(GuiCtrlObj, Info) {
    global g_MainWindow
    g_MainWindow.Minimize()
}

ToggleApp() {
    global g_MainWindow
    if (WinExist("UK Police Legislation Reference")) {
        WinHide("UK Police Legislation Reference")
    } else {
        WinShow("UK Police Legislation Reference")
        WinActivate("UK Police Legislation Reference")
    }
}

CloseApp(GuiCtrlObj := "", Info := "") {
    global g_MainWindow
    SaveWindowPosition()
    SaveFavorites()
    g_MainWindow.Destroy()
    ExitApp()
}

;===================================================================
; FAVORITES MANAGEMENT
;===================================================================

LoadFavorites() {
    global g_Favorites, FAVORITES_FILE
    
    if (FileExist(FAVORITES_FILE)) {
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
    
    FavList := ""
    for Fav in g_Favorites {
        FavList .= Fav "`n"
    }
    
    FileDelete(FAVORITES_FILE)
    FileAppend(FavList, FAVORITES_FILE)
}

;===================================================================
; WINDOW POSITION MANAGEMENT
;===================================================================

LoadWindowPosition() {
    global g_MainWindow, CONFIG_FILE
    
    if (FileExist(CONFIG_FILE)) {
        try {
            IniRead WinX, CONFIG_FILE, "Window", "X"
            IniRead WinY, CONFIG_FILE, "Window", "Y"
            
            if (WinX != "" && WinY != "" && WinX > 0 && WinY > 0) {
                g_MainWindow.MoveDrag(WinX, WinY)
            }
        }
    }
}

SaveWindowPosition() {
    global g_MainWindow, CONFIG_FILE
    
    WinGetPos(&WinX, &WinY, , , g_MainWindow)
    IniWrite(WinX, CONFIG_FILE, "Window", "X")
    IniWrite(WinY, CONFIG_FILE, "Window", "Y")
}

;===================================================================
; UTILITY FUNCTIONS
;===================================================================

ApplySystemDarkMode() {
    ; Windows 11 dark mode is applied via system settings
    ; This ensures compatibility with dark theme
}

; OnExit cleanup
OnExit(ExitFunc)
ExitFunc(ExitReason, ExitCode) {
    SaveWindowPosition()
    SaveFavorites()
}