Script "stack_ScriptTracker_"

/*
# Name: stack "ScriptTracker"
# ID: stack "ScriptTracker"
*/


//>CONSTANTS
constant kCollisionPolicy = "Ask"
constant kDefaultDiffPath = "[[tExportPath]]/diff"
constant kDefaultExportPath = "[[tStackFileName]]_Scripts"
constant kDefaultExtraPath = "[[tExportPath]]/extra"
constant kDiffContext = 3
constant kDigestType = "MD5"
constant kFileMethod = "binfile:"
constant kPropertySet = "bwmScriptTracker"

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
end setPrefsA


command setPref pPref, pValue
   if sPrefsA is empty then loadPrefs
   put pValue into sPrefsA[pPref]
   savePrefs
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
   put kCollisionPolicy into sPrefsA["CollisionPolicy"]
   put kDefaultDiffPath into sPrefsA["DefaultDiffPath"]
   put kDefaultExportPath into sPrefsA["DefaultExportPath"]
   put kDefaultExtraPath into sPrefsA["DefaultExtraPath"]
   put kDiffContext into sPrefsA["DiffContext"]
   put kDigestType into sPrefsA["DigestType"]
   put kFileMethod into sPrefsA["FileMethod"]
   put kPropertySet into sPrefsA["PropertySet"]
   savePrefs
end initializePrefs


function prefsFileName
   return revEnvironmentUserPreferencesPath() & "/bwmScriptTracker.lson"
end prefsFileName
