Script "stack_ScriptTrackerPrefs_card_id_1004"

/*
# Name: card "Defaults" of stack "ScriptTrackerPrefs" of stack "ScriptTracker"
# ID: card id 1004 of stack "ScriptTrackerPrefs" of stack "ScriptTracker"
*/


//>LOCALS
local sPrefsA


on preOpenCard
   put getPrefsA() into sPrefsA
   repeat for each item tPref in "DiffPath,ExportPath,ExtraPath"
      set the text of field tPref to sPrefsA[tPref]
   end repeat
   set the label of button "CollisionPolicy" to sPrefsA["CollisionPolicy"]
end preOpenCard


on closeCard
   local tPrefsChanged
   
   repeat for each item tPref in "DiffPath,ExportPath,ExtraPath"
      checkPref tPref, the text of field tPref, sPrefsA, tPrefsChanged
   end repeat
   checkPref "CollisionPolicy", the label of button "CollisionPolicy", \
         sPrefsA, tPrefsChanged
   if tPrefsChanged then
      setPrefsA sPrefsA
   end if
end closeCard
