Script "stack_ScriptTrackerPrefs_card_id_1002"

/*
# Name: card "ScriptTracker" of stack "ScriptTrackerPrefs" of stack "ScriptTracker"
# ID: card id 1002 of stack "ScriptTrackerPrefs" of stack "ScriptTracker"
*/


//>LOCALS
local sPrefsA


on preOpenCard
   put getPrefsA() into sPrefsA
   repeat for each item tPref in "DiffContext,PropertySet"
      set the text of field tPref to sPrefsA[tPref]
   end repeat
   repeat for each item tPref in "DigestType,FileMethod"
      set the label of button tPref to sPrefsA[tPref]
   end repeat
end preOpenCard


on closeCard
   local tPrefsChanged
   
   repeat for each item tPref in "DiffContext,PropertySet"
      checkPref tPref, the text of field tPref, sPrefsA, tPrefsChanged
   end repeat
   repeat for each item tPref in "DigestType,FileMethod"
      checkPref tPref, the label of button tPref, sPrefsA, tPrefsChanged
   end repeat
   if tPrefsChanged then
      setPrefsA sPrefsA
   end if
end closeCard
