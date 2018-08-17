Script "stack_ScriptTrackerPrefs_"

/*
# Name: stack "ScriptTrackerPrefs" of stack "ScriptTracker"
# ID: stack "ScriptTrackerPrefs" of stack "ScriptTracker"
*/


//>LOCALS
local sPrefsA, sStackName


on openCard
   set the hilitedItemNames of widget 1 of group 1 of this card \
         to the short name of this card
end openCard


on checkPref pPref, pValue, @xPrefsA, @xPrefsChanged
   if pValue is empty then exit checkPref
   if pValue is not xPrefsA[pPref] then
      put pValue into xPrefsA[pPref]
      put true into xPrefsChanged
   end if
end checkPref


on preOpenCard
   if the short name of this card is "Stack" then
      put field "StackName" of stack "ScriptTracker" into sStackName
      if there is not a stack sStackName then
         go card "Defaults"
         exit preOpenCard
      end if
      put the customProperties[getPref("PropertySet")] of stack sStackName \
            into sPrefsA
      if sPrefsA is empty then
         reinitializeStackPrefs
         exit preOpenCard
      end if
   else
      put getPrefsA() into sPrefsA
   end if
   displayPrefs
end preOpenCard


on closeCard
   saveUpdatedPrefs
end closeCard


on displayPrefs
   repeat for each item tPref in the uCheckBoxes of this card
      set the hilite of button tPref of this card to sPrefsA[tPref]
   end repeat
   repeat for each item tPref in the uTextFields of this card
      set the text of field tPref of this card to sPrefsA[tPref]
   end repeat
   repeat for each item tPref in the uOptionMenus of this card
      set the label of button tPref of this card to sPrefsA[tPref]
   end repeat
end displayPrefs


on saveUpdatedPrefs
   local tPrefsChanged
   
   repeat for each item tPref in the uCheckBoxes of this card
      checkPref tPref, the hilite of button tPref of this card, \
            sPrefsA, tPrefsChanged
   end repeat
   repeat for each item tPref in the uTextFields of this card
      checkPref tPref, the text of field tPref of this card, \
            sPrefsA, tPrefsChanged
   end repeat
   repeat for each item tPref in the uOptionMenus of this card
      checkPref tPref, the label of button tPref of this card, \
            sPrefsA, tPrefsChanged
   end repeat
   if tPrefsChanged then
      if the short name of this card is "Stack" then
         if there is a stack sStackName then
            set the customProperties[getPref("PropertySet")] of \
                  stack sStackName to sPrefsA
            restartAutoSync
         else
            beep
            answer "Error: Stack" && quote & sStackName & quote && \
                  "is not open. Unable to edit preferences."
         end if
      else
         setPrefsA sPrefsA
      end if
   end if
end saveUpdatedPrefs


on reinitializePrefs
   local tPrefsA, tPrefsChanged
   
   if the short name of this card is "Stack" then
      reinitializeStackPrefs
      exit reinitializePrefs
   end if
   
   put getDefaultPrefsA() into tPrefsA
   repeat for each item tPref in the uCheckBoxes of this card
      checkPref tPref, tPrefsA[tPref], sPrefsA, tPrefsChanged
   end repeat
   repeat for each item tPref in the uTextFields of this card
      checkPref tPref, tPrefsA[tPref], sPrefsA, tPrefsChanged
   end repeat
   repeat for each item tPref in the uOptionMenus of this card
      checkPref tPref, tPrefsA[tPref], sPrefsA, tPrefsChanged
   end repeat
   if tPrefsChanged then
      setPrefsA sPrefsA
   end if
   displayPrefs
end reinitializePrefs


on reinitializeStackPrefs
   local tExportPath, tPrefsA, tStackFileName
   
   // get stack file name without extension
   set the itemdel to "/"
   put item -1 of (char 2 to -2 of word -1 of the long id of \
         stack sStackName) into tStackFileName
   set the itemdel to "."
   delete item -1 of tStackFileName
   
   put getPrefsA() into tPrefsA
   put merge(tPrefsA["ExportPath"]) into tExportPath
   put tExportPath into sPrefsA["ExportPath"]
   put merge(tPrefsA["DiffPath"]) into sPrefsA["DiffPath"]
   put merge(tPrefsA["ExtraPath"]) into sPrefsA["ExtraPath"]
   put tPrefsA["CollisionPolicy"] into sPrefsA["CollisionPolicy"]
   
   set the customProperties[getPref("PropertySet")] of stack sStackName \
         to sPrefsA
   displayPrefs
   restartAutoSync
end reinitializeStackPrefs
