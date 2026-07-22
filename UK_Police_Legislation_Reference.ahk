;===================================================================
; UK POLICE LEGISLATION REFERENCE - SIMPLIFIED
; Basic AutoHotkey v2 application for police legislation
; Dark theme with essential features
;===================================================================

#Requires AutoHotkey v2.0
#SingleInstance Force

;===================================================================
; GLOBAL CONFIGURATION
;===================================================================

global APP_TITLE := "UK Police Legislation Reference"
global COLOR_BG := "1e1e1e"
global COLOR_SIDEBAR := "252526"
global COLOR_CARD := "2d2d30"
global COLOR_TEXT := "e8e8e8"
global COLOR_ACCENT := "007acc"

global g_MainWindow := 0
global g_Legislation := Map()
global g_SearchText := ""

;===================================================================
; HOTKEYS
;===================================================================

Esc::CloseApp()
^f::FocusSearchBar()

;===================================================================
; INITIALIZATION
;===================================================================

BuildLegislationDatabase()
CreateMainWindow()

;===================================================================
; LEGISLATION DATABASE (SIMPLIFIED)
;===================================================================

BuildLegislationDatabase() {
    ; Police and Criminal Evidence Act 1984
    AddLegislation("Police and Criminal Evidence Act 1984", "0078d4", [
        {section: "s.1", title: "Stop and search", desc: "Power to stop and search for stolen goods or weapons."},
        {section: "s.24", title: "Arrest without warrant", desc: "Power to arrest without warrant for indictable offences."},
        {section: "s.28", title: "Information on arrest", desc: "Must inform person of arrest, grounds and rights."},
        {section: "s.34", title: "Effect of silence", desc: "Adverse inferences from silence during interview."},
        {section: "s.76", title: "Confessions", desc: "Admissibility of confessions in evidence."}
    ])
    
    ; Public Order Act 1986
    AddLegislation("Public Order Act 1986", "d83b01", [
        {section: "s.1", title: "Riot", desc: "12+ persons using unlawful violence with common purpose."},
        {section: "s.2", title: "Violent disorder", desc: "3+ persons using unlawful violence."},
        {section: "s.4", title: "Fear or provocation", desc: "Threatening words/behaviour likely to provoke fear."},
        {section: "s.5", title: "Harassment or distress", desc: "Threatening/abusive/insulting words/behaviour."}
    ])
    
    ; Road Traffic Act 1988
    AddLegislation("Road Traffic Act 1988", "f44336", [
        {section: "s.4", title: "Drink/drug driving", desc: "Unfit through drink/drugs to drive safely."},
        {section: "s.5", title: "Excess alcohol", desc: "Breath/blood alcohol limit exceeded."},
        {section: "s.87", title: "Driving without license", desc: "Offence to drive without valid license."},
        {section: "s.143", title: "No insurance", desc: "Offence to drive uninsured."}
    ])
    
    ; Theft Act 1968
    AddLegislation("Theft Act 1968", "ff9800", [
        {section: "s.1", title: "Theft", desc: "Dishonestly appropriating property with intent to permanently deprive."},
        {section: "s.8", title: "Robbery", desc: "Theft with force or threat of force."},
        {section: "s.9", title: "Burglary", desc: "Entry as trespasser with intent to steal/damage."},
        {section: "s.22", title: "Handling stolen goods", desc: "Knowingly receiving or handling stolen goods."}
    ])
    
    ; Misuse of Drugs Act 1971
    AddLegislation("Misuse of Drugs Act 1971", "9c27b0", [
        {section: "s.4", title: "Possession", desc: "Possession of controlled drugs is prohibited."},
        {section: "s.5", title: "Supply", desc: "Supply offence with maximum 14 years imprisonment."},
        {section: "s.6", title: "Cannabis cultivation", desc: "Prohibition on cultivating cannabis plants."},
        {section: "s.23", title: "Search powers", desc: "Police search power for controlled drugs."}
    ])
    
    ; Criminal Damage Act 1971
    AddLegislation("Criminal Damage Act 1971", "e91e63", [
        {section: "s.1", title: "Destroying property", desc: "Damage/destroy property intending damage or reckless."},
        {section: "s.2", title: "Arson", desc: "Destroying/damaging property by fire."},
        {section: "s.3", title: "Aggravated criminal damage", desc: "Damage with intent to endanger life."}
    ])
}

AddLegislation(ActName, Color, Sections) {
    g_Legislation[ActName] := {
        name: ActName,
        color: Color,
        sections: Sections
    }
}

;===================================================================
; MAIN WINDOW CREATION
;===================================================================

CreateMainWindow() {
    global g_MainWindow, COLOR_BG, COLOR_SIDEBAR, COLOR_CARD, COLOR_TEXT, COLOR_ACCENT
    
    g_MainWindow := Gui()
    g_MainWindow.BackColor := COLOR_BG
    
    ; Title Bar
    g_MainWindow.AddText("x0 y0 w800 h40 BackgroundColor" COLOR_SIDEBAR, "")
    g_MainWindow.AddText("x10 y10 w750 h25 c" COLOR_TEXT " BackgroundColor" COLOR_SIDEBAR, "🛡️  UK Police Legislation Reference")
    TitleText := g_MainWindow.LastControl
    TitleText.SetFont("s12 w600 Segoe UI")
    
    ; Close button
    g_MainWindow.AddButton("x750 y10 w30 h25 -Theme c" COLOR_TEXT " BackgroundColor" COLOR_SIDEBAR, "✕")
    CloseBtn := g_MainWindow.LastControl
    CloseBtn.OnEvent("Click", CloseApp)
    CloseBtn.SetFont("s11")
    
    ; Search bar
    g_MainWindow.AddText("x10 y50 w780 h20 c" COLOR_TEXT " BackgroundColor" COLOR_BG, "Search:")
    g_MainWindow.AddEdit("x10 y75 w780 h30 c" COLOR_TEXT " BackgroundColor" COLOR_CARD " vSearchBox", "")
    SearchBox := g_MainWindow.LastControl
    SearchBox.OnEvent("Change", SearchCallback)
    SearchBox.SetFont("s10 Segoe UI")
    
    ; Results list
    g_MainWindow.AddListBox("x10 y115 w780 h500 c" COLOR_TEXT " BackgroundColor" COLOR_CARD " vLegislationList", "")
    LegList := g_MainWindow.LastControl
    LegList.SetFont("s9 Segoe UI")
    
    ; Status bar
    g_MainWindow.AddText("x0 y620 w800 h30 BackgroundColor" COLOR_SIDEBAR " c" COLOR_TEXT " vStatusBar", "  Ctrl+F search | ESC close")
    StatusBar := g_MainWindow.LastControl
    StatusBar.SetFont("s8 Segoe UI")
    
    g_MainWindow.Show("w800 h650", APP_TITLE)
    UpdateMainPanel()
}

SearchCallback(GuiCtrlObj, Info) {
    global g_SearchText
    g_SearchText := GuiCtrlObj.Value
    UpdateMainPanel()
}

UpdateMainPanel() {
    global g_MainWindow, g_Legislation, g_SearchText
    
    LegList := g_MainWindow["LegislationList"]
    LegList.Delete()
    
    for ActName, ActData in g_Legislation {
        bShowItem := false
        
        if (g_SearchText = "") {
            bShowItem := true
        } else {
            SearchLower := StrLower(g_SearchText)
            
            if InStr(StrLower(ActName), SearchLower) {
                bShowItem := true
            } else {
                for Section in ActData.sections {
                    if (InStr(StrLower(Section.section), SearchLower) 
                        || InStr(StrLower(Section.title), SearchLower)
                        || InStr(StrLower(Section.desc), SearchLower)) {
                        bShowItem := true
                        break
                    }
                }
            }
        }
        
        if (bShowItem) {
            LegList.Add(, ActName " (" ActData.sections.Length " sections)")
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

CloseApp(GuiCtrlObj := "", Info := "") {
    global g_MainWindow
    if IsObject(g_MainWindow)
        g_MainWindow.Destroy()
    ExitApp()
}

OnExit(CloseApp)
