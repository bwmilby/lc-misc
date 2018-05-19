Script "stack_ScriptTrackerPrefs_"

/*
# Name: stack "ScriptTrackerPrefs" of stack "ScriptTracker"
# ID: stack "ScriptTrackerPrefs" of stack "ScriptTracker"
*/


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

