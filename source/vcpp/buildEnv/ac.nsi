!include MUI.nsh
!include Sections.nsh

## TOOLS

# Open Browser Window

# Uses $0
Function openLinkNewWindow
  Push $3 
  Push $2
  Push $1
  Push $0
  ReadRegStr $0 HKCR "http\shell\open\command" ""
# Get browser path
    DetailPrint $0
  StrCpy $2 '"'
  StrCpy $1 $0 1
  StrCmp $1 $2 +2 # if path is not enclosed in " look for space as final char
    StrCpy $2 ' '
  StrCpy $3 1
  loop:
    StrCpy $1 $0 1 $3
    DetailPrint $1
    StrCmp $1 $2 found
    StrCmp $1 "" found
    IntOp $3 $3 + 1
    Goto loop
 
  found:
    StrCpy $1 $0 $3
    StrCmp $2 " " +2
      StrCpy $1 '$1"'
 
  Pop $0
  Exec '$1 $0'
  Pop $1
  Pop $2
  Pop $3
FunctionEnd

# Uses $0
Function un.openLinkNewWindow
  Push $3 
  Push $2
  Push $1
  Push $0
  ReadRegStr $0 HKCR "http\shell\open\command" ""
# Get browser path
    DetailPrint $0
  StrCpy $2 '"'
  StrCpy $1 $0 1
  StrCmp $1 $2 +2 # if path is not enclosed in " look for space as final char
    StrCpy $2 ' '
  StrCpy $3 1
  loop:
    StrCpy $1 $0 1 $3
    DetailPrint $1
    StrCmp $1 $2 found
    StrCmp $1 "" found
    IntOp $3 $3 + 1
    Goto loop
 
  found:
    StrCpy $1 $0 $3
    StrCmp $2 " " +2
      StrCpy $1 '$1"'
 
  Pop $0
  Exec '$1 $0'
  Pop $1
  Pop $2
  Pop $3
FunctionEnd


# Test if Visual Studio Redistributables 2005+ SP1 installed

Function CheckVCRedist
    Push $R0
    ClearErrors
    ReadRegDword $R0 HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{7299052b-02a4-4627-81f2-1818da5d550d}" "Version"

    ; if VS 2005+ redist SP1 not installed, install it
    IfErrors 0 VSRedistInstalled
    StrCpy $R0 "-1"
    Goto done

    VSRedistInstalled:
    StrCpy $R0 "1"

    done:
    Exch $R0
    
FunctionEnd

Function SplitFirstStrPart
  Exch $R0
  Exch
  Exch $R1
  Push $R2
  Push $R3
  StrCpy $R3 $R1
  StrLen $R1 $R0
  IntOp $R1 $R1 + 1
  loop:
    IntOp $R1 $R1 - 1
    StrCpy $R2 $R0 1 -$R1
    StrCmp $R1 0 exit0
    StrCmp $R2 $R3 exit1 loop
  exit0:
  StrCpy $R1 ""
  Goto exit2
  exit1:
    IntOp $R1 $R1 - 1
    StrCmp $R1 0 0 +3
     StrCpy $R2 ""
     Goto +2
    StrCpy $R2 $R0 "" -$R1
    IntOp $R1 $R1 + 1
    StrCpy $R0 $R0 -$R1
    StrCpy $R1 $R2
  exit2:
  Pop $R3
  Pop $R2
  Exch $R1 ;rest
  Exch
  Exch $R0 ;first
FunctionEnd


; CONFIGURATION

; general

SetCompressor /SOLID lzma

!define CURPATH "R:\projects\ActionCube\ac\source\vcpp\buildEnv" ; CHANGE ME
!define AC_VERSION "v1.0"
!define AC_SHORTNAME "AssaultCube"
!define AC_FULLNAME "AssaultCube v1.0"
!define AC_FULLNAMESAVE "AssaultCube_v1.0"

Name "AssaultCube"
VAR StartMenuFolder
OutFile "AssaultCube_${AC_VERSION}.exe"
InstallDir "$PROGRAMFILES\${AC_FULLNAMESAVE}"
InstallDirRegKey HKLM "Software\${AC_FULLNAMESAVE}" ""
RequestExecutionLevel admin  ; require admin in vista

; Interface Configuration

!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "${CURPATH}\header.bmp" ; optional

; icon

XPStyle on
Icon "${CURPATH}\icon.ico"
UninstallIcon "${CURPATH}\icon.ico"
!define MUI_ICON "${CURPATH}\icon.ico"
!define MUI_UNICON "${CURPATH}\icon.ico"

; Pages

Page custom WelcomePage
!insertmacro MUI_PAGE_LICENSE "${CURPATH}\License.txt"
Page custom InstallationTypePage
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_STARTMENU Application $StartMenuFolder
!insertmacro MUI_PAGE_INSTFILES
Page custom FinishPage

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "English"


; Custom Welcome Page

!define WS_CHILD            0x40000000
!define WS_VISIBLE          0x10000000
!define WS_DISABLED         0x08000000
!define WS_CLIPSIBLINGS     0x04000000
!define WS_MAXIMIZE         0x01000000
!define WS_VSCROLL          0x00200000
!define WS_HSCROLL          0x00100000
!define WS_GROUP            0x00020000
!define WS_TABSTOP          0x00010000

!define ES_LEFT             0x00000000
!define ES_CENTER           0x00000001
!define ES_RIGHT            0x00000002
!define ES_MULTILINE        0x00000004
!define ES_UPPERCASE        0x00000008
!define ES_LOWERCASE        0x00000010
!define ES_PASSWORD         0x00000020
!define ES_AUTOVSCROLL      0x00000040
!define ES_AUTOHSCROLL      0x00000080
!define ES_NOHIDESEL        0x00000100
!define ES_OEMCONVERT       0x00000400
!define ES_READONLY         0x00000800
!define ES_WANTRETURN       0x00001000
!define ES_NUMBER           0x00002000

!define SS_LEFT             0x00000000
!define SS_CENTER           0x00000001
!define SS_RIGHT            0x00000002
!define SS_ICON             0x00000003
!define SS_BLACKRECT        0x00000004
!define SS_GRAYRECT         0x00000005
!define SS_WHITERECT        0x00000006
!define SS_BLACKFRAME       0x00000007
!define SS_GRAYFRAME        0x00000008
!define SS_WHITEFRAME       0x00000009
!define SS_USERITEM         0x0000000A
!define SS_SIMPLE           0x0000000B
!define SS_LEFTNOWORDWRAP   0x0000000C
!define SS_OWNERDRAW        0x0000000D
!define SS_BITMAP           0x0000000E
!define SS_ENHMETAFILE      0x0000000F
!define SS_ETCHEDHORZ       0x00000010
!define SS_ETCHEDVERT       0x00000011
!define SS_ETCHEDFRAME      0x00000012
!define SS_TYPEMASK         0x0000001F
!define SS_REALSIZECONTROL  0x00000040
!define SS_NOPREFIX         0x00000080
!define SS_NOTIFY           0x00000100
!define SS_CENTERIMAGE      0x00000200
!define SS_RIGHTJUST        0x00000400
!define SS_REALSIZEIMAGE    0x00000800
!define SS_SUNKEN           0x00001000
!define SS_EDITCONTROL      0x00002000
!define SS_ENDELLIPSIS      0x00004000
!define SS_PATHELLIPSIS     0x00008000
!define SS_WORDELLIPSIS     0x0000C000
!define SS_ELLIPSISMASK     0x0000C000

!define BS_PUSHBUTTON       0x00000000
!define BS_DEFPUSHBUTTON    0x00000001
!define BS_CHECKBOX         0x00000002
!define BS_AUTOCHECKBOX     0x00000003
!define BS_RADIOBUTTON      0x00000004
!define BS_3STATE           0x00000005
!define BS_AUTO3STATE       0x00000006
!define BS_GROUPBOX         0x00000007
!define BS_USERBUTTON       0x00000008
!define BS_AUTORADIOBUTTON  0x00000009
!define BS_PUSHBOX          0x0000000A
!define BS_OWNERDRAW        0x0000000B
!define BS_TYPEMASK         0x0000000F
!define BS_LEFTTEXT         0x00000020
!define BS_TEXT             0x00000000
!define BS_ICON             0x00000040
!define BS_BITMAP           0x00000080
!define BS_LEFT             0x00000100
!define BS_RIGHT            0x00000200
!define BS_CENTER           0x00000300
!define BS_TOP              0x00000400
!define BS_BOTTOM           0x00000800
!define BS_VCENTER          0x00000C00
!define BS_PUSHLIKE         0x00001000
!define BS_MULTILINE        0x00002000
!define BS_NOTIFY           0x00004000
!define BS_FLAT             0x00008000
!define BS_RIGHTBUTTON      ${BS_LEFTTEXT}

!define LR_DEFAULTCOLOR     0x0000
!define LR_MONOCHROME       0x0001
!define LR_COLOR            0x0002
!define LR_COPYRETURNORG    0x0004
!define LR_COPYDELETEORG    0x0008
!define LR_LOADFROMFILE     0x0010
!define LR_LOADTRANSPARENT  0x0020
!define LR_DEFAULTSIZE      0x0040
!define LR_VGACOLOR         0x0080
!define LR_LOADMAP3DCOLORS  0x1000
!define LR_CREATEDIBSECTION 0x2000
!define LR_COPYFROMRESOURCE 0x4000
!define LR_SHARED           0x8000

!define IMAGE_BITMAP        0
!define IMAGE_ICON          1
!define IMAGE_CURSOR        2
!define IMAGE_ENHMETAFILE   3

Var DIALOG
Var HEADLINE
Var TEXT
Var HWND
Var IMAGECTL
Var IMAGE

Function .onInit

	InitPluginsDir
	File /oname=$TEMP\welcome.bmp "${CURPATH}\welcome.bmp"
	
	!insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "InstallTypes.ini" "InstallTypes.ini"

FunctionEnd

Function .onInstSuccess

    StrCpy $0 "http://assault.cubers.net/releasenotes/v1.0/"
    Call openLinkNewWindow

FunctionEnd

Function un.onUninstSuccess

    StrCpy $0 "http://assault.cubers.net/uninstallnotes/v1.0/"
    Call un.openLinkNewWindow  

FunctionEnd

Function HideControls

    LockWindow on
    GetDlgItem $0 $HWNDPARENT 1028
    ShowWindow $0 ${SW_HIDE}

    GetDlgItem $0 $HWNDPARENT 1256
    ShowWindow $0 ${SW_HIDE}

    GetDlgItem $0 $HWNDPARENT 1035
    ShowWindow $0 ${SW_HIDE}

    GetDlgItem $0 $HWNDPARENT 1037
    ShowWindow $0 ${SW_HIDE}

    GetDlgItem $0 $HWNDPARENT 1038
    ShowWindow $0 ${SW_HIDE}

    GetDlgItem $0 $HWNDPARENT 1039
    ShowWindow $0 ${SW_HIDE}

    GetDlgItem $0 $HWNDPARENT 1045
    ShowWindow $0 ${SW_NORMAL}
    LockWindow off

FunctionEnd

Function ShowControls

    LockWindow on
    GetDlgItem $0 $HWNDPARENT 1028
    ShowWindow $0 ${SW_NORMAL}

    GetDlgItem $0 $HWNDPARENT 1256
    ShowWindow $0 ${SW_NORMAL}

    GetDlgItem $0 $HWNDPARENT 1035
    ShowWindow $0 ${SW_NORMAL}

    GetDlgItem $0 $HWNDPARENT 1037
    ShowWindow $0 ${SW_NORMAL}

    GetDlgItem $0 $HWNDPARENT 1038
    ShowWindow $0 ${SW_NORMAL}

    GetDlgItem $0 $HWNDPARENT 1039
    ShowWindow $0 ${SW_NORMAL}

    GetDlgItem $0 $HWNDPARENT 1045
    ShowWindow $0 ${SW_HIDE}
    LockWindow off

FunctionEnd

Function WelcomePage

	nsDialogs::Create /NOUNLOAD 1044
	Pop $DIALOG

	nsDialogs::CreateControl /NOUNLOAD STATIC ${WS_VISIBLE}|${WS_CHILD}|${WS_CLIPSIBLINGS}|${SS_BITMAP} 0 0 0 109u 193u ""
	Pop $IMAGECTL

	StrCpy $0 $TEMP\welcome.bmp
	System::Call 'user32::LoadImage(i 0, t r0, i ${IMAGE_BITMAP}, i 0, i 0, i ${LR_LOADFROMFILE}) i.s'
	Pop $IMAGE
	
	SendMessage $IMAGECTL ${STM_SETIMAGE} ${IMAGE_BITMAP} $IMAGE

	nsDialogs::CreateControl /NOUNLOAD STATIC ${WS_VISIBLE}|${WS_CHILD}|${WS_CLIPSIBLINGS} 0 120u 10u -130u 20u "Welcome to the AssaultCube Setup Wizard"
	Pop $HEADLINE

	SendMessage $HEADLINE ${WM_SETFONT} $HEADLINE_FONT 0

	nsDialogs::CreateControl /NOUNLOAD STATIC ${WS_VISIBLE}|${WS_CHILD}|${WS_CLIPSIBLINGS} 0 120u 32u -130u -32u "This wizard will guide you through the installation of AssaultCube.$\r$\n$\r$\nIt is recommended that you close all other applications before starting Setup. This will make it possible to update relevant system files without having to reboot your computer.$\r$\n$\r$\nClick next to continue."
	Pop $TEXT

	SetCtlColors $DIALOG "" 0xffffff
	SetCtlColors $HEADLINE "" 0xffffff
	SetCtlColors $TEXT "" 0xffffff

	Call HideControls

	nsDialogs::Show

	Call ShowControls

	System::Call gdi32::DeleteObject(i$IMAGE)
	
	MessageBox MB_OK "This is a TEST BUILD, do NOT redistribute this file! This is NOT a final release!"

FunctionEnd

Function FinishPage

	nsDialogs::Create /NOUNLOAD 1044
	Pop $DIALOG

	nsDialogs::CreateControl /NOUNLOAD STATIC ${WS_VISIBLE}|${WS_CHILD}|${WS_CLIPSIBLINGS}|${SS_BITMAP} 0 0 0 109u 193u ""
	Pop $IMAGECTL

	StrCpy $0 $TEMP\welcome.bmp
	System::Call 'user32::LoadImage(i 0, t r0, i ${IMAGE_BITMAP}, i 0, i 0, i ${LR_LOADFROMFILE}) i.s'
	Pop $IMAGE
	
	SendMessage $IMAGECTL ${STM_SETIMAGE} ${IMAGE_BITMAP} $IMAGE

	nsDialogs::CreateControl /NOUNLOAD STATIC ${WS_VISIBLE}|${WS_CHILD}|${WS_CLIPSIBLINGS} 0 120u 10u -130u 20u "Completing the AssaultCube Setup Wizard"
	Pop $HEADLINE

	SendMessage $HEADLINE ${WM_SETFONT} $HEADLINE_FONT 0

	nsDialogs::CreateControl /NOUNLOAD STATIC ${WS_VISIBLE}|${WS_CHILD}|${WS_CLIPSIBLINGS} 0 120u 32u -130u -32u "AssaultCube has been installed on your computer.$\r$\n$\r$\nClick Finish to close this wizard."
	Pop $TEXT

	SetCtlColors $DIALOG "" 0xffffff
	SetCtlColors $HEADLINE "" 0xffffff
	SetCtlColors $TEXT "" 0xffffff

	Call HideControls

	nsDialogs::Show

	Call ShowControls

	System::Call gdi32::DeleteObject(i$IMAGE)

FunctionEnd

Function DisableMultiuserOption

        !insertmacro MUI_INSTALLOPTIONS_WRITE "InstallTypes.ini" "Field 2" "Flags" "DISABLED"	
        !insertmacro MUI_INSTALLOPTIONS_WRITE "InstallTypes.ini" "Field 4" "Flags" "DISABLED"
        
        ; fix currently selected option
        !insertmacro MUI_INSTALLOPTIONS_WRITE "InstallTypes.ini" "Field 2" "State" "0"	
        !insertmacro MUI_INSTALLOPTIONS_WRITE "InstallTypes.ini" "Field 1" "State" "1"
        
FunctionEnd


Function InstallationTypePage

    ; check if "my documents" folder is present, might disable 2nd option
    
    ReadRegStr $0 HKCU "Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" "Personal"
    StrCmp $0 "" nohome hashome
    nohome:
    
        Call DisableMultiuserOption ; not present, disable option
        goto homecheckdone
            
    hashome: 
    homecheckdone:
    
    
    ; check installed windows version, might change default option
    
    GetVersion::WindowsVersion
    Pop $R0
    Push "." ; divider char
    Push $R0 ; input string
    Call SplitFirstStrPart
    Pop $R0 ; major version
    Pop $R1 ; minor version
 
    StrCmp $R0 "6" 0 winvercheckdone ; vista
   
        ; suggest multiuser option on vista and later
        !insertmacro MUI_INSTALLOPTIONS_WRITE "InstallTypes.ini" "Field 2" "State" "1"	
        !insertmacro MUI_INSTALLOPTIONS_WRITE "InstallTypes.ini" "Field 1" "State" "0"
    
    winvercheckdone:
    
    
    ; set up GUI
    
	!insertmacro MUI_HEADER_TEXT "Installation Type" "Select the installation type" 
	!insertmacro MUI_INSTALLOPTIONS_DISPLAY "InstallTypes.ini"
    
	Pop $HWND

	GetDlgItem $1 $HWNDPARENT 1
	EnableWindow $1 0

	!insertmacro MUI_INSTALLOPTIONS_SHOW
	Pop $0

FunctionEnd


Function ConfigureWithoutAppdata

    ; remove shortcuts to user data directory

    ; Delete "$SMPROGRAMS\AssaultCube\AssaultCube User Data.lnk"
    ; Delete "$INSTDIR\User Data.lnk"
    
    ; configure ac without home dir
    
    FileOpen $9 "$INSTDIR\AssaultCube.bat" w
    FileWrite $9 "bin_win32\ac_client.exe --init %1 %2 %3 %4 %5$\r$\n"
    FileWrite $9 "pause$\r$\n"
    FileClose $9

FunctionEnd

; Installer Sections

Section "AssaultCube v1.0" AC

    SectionIn RO

    SetOutPath "$INSTDIR"

    File /r ac\*.*

    WriteRegStr HKLM "Software\${AC_FULLNAMESAVE}" "" $INSTDIR

    ; Create uninstaller
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${AC_FULLNAMESAVE}" "DisplayName" "${AC_FULLNAME}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${AC_FULLNAMESAVE}" "UninstallString" '"$INSTDIR\uninstall.exe"'
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${AC_FULLNAMESAVE}" "DisplayIcon" '"$INSTDIR\icon.ico"'

    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${AC_FULLNAMESAVE}" "HelpLink" "http://assault.cubers.net/help.html"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${AC_FULLNAMESAVE}" "URLInfoAbout" "http://assault.cubers.net"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${AC_FULLNAMESAVE}" "URLUpdateInfo" "http://assault.cubers.net/download.html"

    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${AC_FULLNAMESAVE}" "DisplayVersion" "v1.0"
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${AC_FULLNAMESAVE}" "VersionMajor" 1
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${AC_FULLNAMESAVE}" "VersionMinor" 0

    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${AC_FULLNAMESAVE}" "NoModify" 1
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${AC_FULLNAMESAVE}" "NoRepair" 1

    WriteUninstaller "$INSTDIR\Uninstall.exe"
    

    ; create shortcuts
    
    ; CreateShortCut "$INSTDIR\User Data.lnk" "%appdata%\${AC_FULLNAMESAVE}" "" "" 0
      
    !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
       
        SetShellVarContext all

        CreateDirectory "$SMPROGRAMS\$StartMenuFolder"
        CreateShortCut "$SMPROGRAMS\$StartMenuFolder\${AC_SHORTNAME}.lnk" "$INSTDIR\AssaultCube.bat" "" "$INSTDIR\icon.ico" 0 SW_SHOWMINIMIZED
        CreateShortCut "$SMPROGRAMS\$StartMenuFolder\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
        CreateShortCut "$SMPROGRAMS\$StartMenuFolder\README.lnk" "$INSTDIR\README.html" "" "" 0
        ; CreateShortCut "$SMPROGRAMS\AssaultCube\AssaultCube User Data.lnk" "%appdata%\${AC_FULLNAMESAVE}" "" "" 0  

    !insertmacro MUI_STARTMENU_WRITE_END
    

    ; set up ac dir config
    
	!insertmacro MUI_INSTALLOPTIONS_READ $R0 "InstallTypes.ini" "Field 1" "State"
	!insertmacro MUI_INSTALLOPTIONS_READ $R1 "InstallTypes.ini" "Field 2" "State"
	
	StrCmp $R0 "1" 0 appdatadone
	    Call ConfigureWithoutAppdata
	appdatadone:
	

SectionEnd

Section "Visual C++ redistributable runtime" VCPP

    SectionIn RO

    ; Call CheckVCRedist
    ; Pop $R0

    ; IntCmp $R0 -1 noRedist noRedist done

    ; noRedist:

      ; messageBox MB_OK|MB_ICONINFORMATION "It seems the Microsoft Visual C++ 2005 Redistributable Package is not installed on your computer. Setup will now download (~2mb) and install this required component."
      
      ; NSISdl::download "http://download.microsoft.com/download/e/1/c/e1c773de-73ba-494a-a5ba-f24906ecf088/vcredist_x86.exe" "$INSTDIR\bin_win32\vcredist_x86.exe"

      ; Pop $R0
      ; StrCmp $R0 "success" installVc
      ; MessageBox MB_OK|MB_ICONEXCLAMATION "Download failed: $R0$\rPlease download and install the Microsoft Visual C++ 2005 SP1 Redistributable Package (x86) from http://download.microsoft.com after Setup."
      ; Goto done

      ; installVc:
      ExecWait '"$INSTDIR\bin_win32\vcredist_x86.exe" /q'

    ; done:
  
SectionEnd

Section "OpenAL 1.1 redistributable" OAL

    SectionIn RO
    ExecWait '"$INSTDIR\bin_win32\oalinst.exe" -s'

SectionEnd

Section "Desktop Shortcuts" DESKSHORTCUTS

    SetShellVarContext all

    CreateShortCut "$DESKTOP\${AC_SHORTNAME}.lnk" "$INSTDIR\AssaultCube.bat" "" "$INSTDIR\icon.ico" 0 SW_SHOWMINIMIZED

SectionEnd

Section "-Debug Helper Library"

    GetVersion::WindowsVersion
    Pop $R0
    Push "." ; divider char
    Push $R0 ; input string
    Call SplitFirstStrPart
    Pop $R0 ; major version
    Pop $R1 ; minor version
 
    StrCmp $R0 "4" 0 winvercheckdone ; win98
   
        ; make app-specific debug helper library available on win98
        Rename "$INSTDIR\bin_win32\DbgHelp_RemoveThisPartIfOnWin98.DLL" "$INSTDIR\bin_win32\DbgHelp.DLL"
    
    winvercheckdone:

SectionEnd

Section "Uninstall"
  
    SetShellVarContext all

    ; delete reg keys

    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${AC_FULLNAMESAVE}"
    DeleteRegKey HKLM "SOFTWARE\${AC_FULLNAMESAVE}"
    DeleteRegKey /ifempty HKLM "SOFTWARE\${AC_FULLNAMESAVE}"

    ; delete directory

    RMDir /r "$INSTDIR"

    ; delete shortcuts

    Delete "$DESKTOP\AssaultCube.lnk"
    
    !insertmacro MUI_STARTMENU_GETFOLDER Application $StartMenuFolder 
    
    Delete "$SMPROGRAMS\$StartMenuFolder\${AC_SHORTNAME}.lnk"
    Delete "$SMPROGRAMS\$StartMenuFolder\Uninstall.lnk"
    Delete "$SMPROGRAMS\$StartMenuFolder\README.lnk"
    Delete "$SMPROGRAMS\$StartMenuFolder\Firefox Support Forums.lnk"
    Delete "$SMPROGRAMS\$StartMenuFolder\AssaultCube User Data.lnk"
    RmDir  "$SMPROGRAMS\$StartMenuFolder"
    
SectionEnd


; set descriptions

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN

    !insertmacro MUI_DESCRIPTION_TEXT ${AC} "Installs the required AssaultCube core files"
    !insertmacro MUI_DESCRIPTION_TEXT ${VCPP} "Installs the runtime to make AssaultCube run on your computer"
    !insertmacro MUI_DESCRIPTION_TEXT ${OAL} "Installs a sound library for 3D audio"
    !insertmacro MUI_DESCRIPTION_TEXT ${DESKSHORTCUTS} "Creates shortcuts on your Desktop"

!insertmacro MUI_FUNCTION_DESCRIPTION_END
