Script "stack_ScriptTracker_"

/*
# Name: stack "ScriptTracker"
# ID: stack "ScriptTracker"
*/


//>CONSTANTS
constant kAutoExternalEditor = "false"
constant kCollisionPolicy = "Ask"
constant kDefaultDiffPath = "[[tExportPath]]/diff"
constant kDefaultExportPath = "[[tStackFileName]]_Scripts"
constant kDefaultExtraPath = "[[tExportPath]]/extra"
constant kDiffContext = 3
constant kDigestType = "MD5"
constant kFileMethod = "binfile:"
constant kPropertySet = "bwmScriptTracker"
constant kSyncBeforeSave = "false"

//>LOCALS
local sPrefsA


function getPrefsA
   if sPrefsA is empty then loadPrefs
   return sPrefsA
end getPrefsA


function getPref pPref
   if sPrefsA is empty then loadPrefs
   return sPrefsA[pPref]
end getPref


command setPrefsA pPrefsA
   initializePrefs
   repeat for each key tPref in pPrefsA
      put pPrefsA[tPref] into sPrefsA[tPref]
   end repeat
   savePrefs
   restartAutoSync
end setPrefsA


command setPref pPref, pValue
   if sPrefsA is empty then loadPrefs
   put pValue into sPrefsA[pPref]
   savePrefs
   restartAutoSync
end setPref


command loadPrefs
   local tPrefs
   
   put url ("binfile:" & prefsFileName()) into tPrefs
   if tPrefs is empty then
      initializePrefs
   else
      try
         put arrayDecode(tPrefs) into sPrefsA
      catch tError
         put "Error decoding preferences:" && tError & lf after \
               field "log" of stack "ScriptTrackerLog"
         initializePrefs
      end try
   end if
end loadPrefs


command savePrefs
   try
      put arrayEncode(sPrefsA) into url ("binfile:" & prefsFileName())
   catch tError
      put "Error saving preferences:" && tError & lf after \
            field "log" of stack "ScriptTrackerLog"
   end try
end savePrefs


command initializePrefs
   delete variable sPrefsA
   put getDefaultPrefsA() into sPrefsA
   savePrefs
end initializePrefs


function getDefaultPrefsA
   local tPrefsA
   
   put kCollisionPolicy into tPrefsA["CollisionPolicy"]
   put kDefaultDiffPath into tPrefsA["DiffPath"]
   put kDefaultExportPath into tPrefsA["ExportPath"]
   put kDefaultExtraPath into tPrefsA["ExtraPath"]
   put kDiffContext into tPrefsA["DiffContext"]
   put kDigestType into tPrefsA["DigestType"]
   put kFileMethod into tPrefsA["FileMethod"]
   put kPropertySet into tPrefsA["PropertySet"]
   put kSyncBeforeSave into tPrefsA["SyncBeforeSave"]
   put kAutoExternalEditor into tPrefsA["AutoExternalEditor"]
   put revIDEGetPreference("LCB_textEditor") into tPrefsA["Editor"]
   
   return tPrefsA
end getDefaultPrefsA


function prefsFileName
   return revEnvironmentUserPreferencesPath() & "/bwmScriptTracker.lson"
end prefsFileName


on restartAutoSync
   if the hilite of button "Automatic" of card "Tracker" \
         of stack "ScriptTracker" is true then
      send "mouseUp" to button "Automatic" of card "Tracker" \
            of stack "ScriptTracker"
      return "running"
   end if
end restartAutoSync


on stopAutoSync
   if the hilite of button "Automatic" of card "Tracker" \
         of stack "ScriptTracker" is true then
      set the hilite of button "Automatic" of card "Tracker" \
            of stack "ScriptTracker" to false
      send "mouseUp" to button "Automatic" of card "Tracker" \
            of stack "ScriptTracker"
   end if
end stopAutoSync


on mouseDoubleUp pButtonNumber
   go next card
end mouseDoubleUp
