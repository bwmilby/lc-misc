Script "stack_ScriptTracker_field_id_1007"

/*
# Name: field "StackName" of card "Tracker" of stack "ScriptTracker"
# ID: field id 1007 of card id 1002 of stack "ScriptTracker"
*/


on textChanged
   put empty into field "count" of this card
   set the hilite of button "Automatic" of this card to false
   if the mode of stack "ScriptTrackerPrefs" > 0 then
      lock screen
      go to card "Stack" of stack "ScriptTrackerPrefs"
      send "preOpenCard" to card "Stack" of stack "ScriptTrackerPrefs"
      unlock screen
   end if
end textChanged
