Script "stack_ScriptTracker_button_id_1010"

/*
# Name: button "P" of card id 1002 of stack "ScriptTracker"
# ID: button id 1010 of card id 1002 of stack "ScriptTracker"
*/


on mouseUp pButtonNumber
   palette this stack
   if the mode of stack "ScriptTrackerLog" is 1 then
      palette stack "ScriptTrackerLog"
   end if
end mouseUp
