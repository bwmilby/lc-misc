Script "stack_ScriptTracker_field_id_1007"

/*
# Name: field "StackName" of card "Tracker" of stack "ScriptTracker"
# ID: field id 1007 of card id 1002 of stack "ScriptTracker"
*/


on textChanged
   local tAutomatic, tPrefsA, tStackName
   
   put empty into field "count" of this card
   put the hilite of button "Automatic" of this card into tAutomatic
   stopAutoSync
   put the text of me into tStackName
   if there is not a stack tStackName then
      put false into tAutomatic
   else
      put the customProperties[getPref("PropertySet")] of stack tStackName \
            into tPrefsA
      if tPrefsA is empty then
         put false into tAutomatic
      end if
   end if
   if the mode of stack "ScriptTrackerPrefs" > 0 then
      lock screen
      go to card "Stack" of stack "ScriptTrackerPrefs"
      send "preOpenCard" to card "Stack" of stack "ScriptTrackerPrefs"
      unlock screen
   end if
   set the hilite of button "Automatic" of this card to tAutomatic
   restartAutoSync
end textChanged
