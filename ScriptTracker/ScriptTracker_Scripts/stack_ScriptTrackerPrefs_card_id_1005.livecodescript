Script "stack_ScriptTrackerPrefs_card_id_1005"

/*
# Name: card "Stack" of stack "ScriptTrackerPrefs" of stack "ScriptTracker"
# ID: card id 1005 of stack "ScriptTrackerPrefs" of stack "ScriptTracker"
*/


//>LOCALS
local sPrefsA, sStackName


on preOpenCard
   put field "StackName" of stack "ScriptTracker" into sStackName
   put the customProperties[getPref(PropertySet)] of stack sStackName into sPrefsA
   if sPrefsA is empty then reinitializePrefs
   
   repeat for each item tPref in "diffPath,exportPath,extraPath"
      set the text of field tPref to sPrefsA[tPref]
   end repeat
   set the label of button "collisionPolicy" to sPrefsA["collisionPolicy"]
end preOpenCard


on closeCard
   local tPrefsChanged
   
   repeat for each item tPref in "diffPath,exportPath,extraPath"
      checkPref tPref, the text of field tPref, sPrefsA, tPrefsChanged
   end repeat
   checkPref "collisionPolicy", the label of button "collisionPolicy", \
         sPrefsA, tPrefsChanged
   if tPrefsChanged then
      set the customProperties[getPref(PropertySet)] of stack sStackName to sPrefsA
   end if
end closeCard


on reinitializePrefs
   local tBasePath, tExportPath, tPrefsA, tStackFileName
   
   // get stack file name without extension
   set the itemdel to "/"
   put item -1 of (char 2 to -2 of word -1 of the long id of stack sStackName) into tStackFileName
   set the itemdel to "."
   delete item -1 of tStackFileName
   
   put getPrefsA() into tPrefsA
   put merge(tPrefsA["DefaultExportPath"]) into tExportPath
   put tExportPath into sPrefsA["exportPath"]
   put merge(tPrefsA["DefaultDiffPath"]) into sPrefsA["diffPath"]
   put merge(tPrefsA["DefaultExtraPath"]) into sPrefsA["extraPath"]
   put tPrefsA["collisionPolicy"] into sPrefsA["collisionPolicy"]
   
   set the customProperties[getPref(PropertySet)] of stack sStackName to sPrefsA
   preOpenCard
end reinitializePrefs
