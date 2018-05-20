Script "stack_ScriptTracker_button_id_1008"

/*
# Name: button "StackMenu" of card "Tracker" of stack "ScriptTracker"
# ID: button id 1008 of card id 1002 of stack "ScriptTracker"
*/


on menuPick pItemName
   put pItemName into field "StackName" of this card
   set the hilite of button "Automatic" of this card to false
   if the mode of stack "ScriptTrackerPrefs" > 0 then
      lock screen
      go to card 3 of stack "ScriptTrackerPrefs"
      send "preOpenCard" to card 3 of stack "ScriptTrackerPrefs"
      unlock screen
   end if
end menuPick
