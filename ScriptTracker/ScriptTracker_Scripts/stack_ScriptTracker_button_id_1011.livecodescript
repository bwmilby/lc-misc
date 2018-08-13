Script "stack_ScriptTracker_button_id_1011"

/*
# Name: button "T" of card "Behaviors" of stack "ScriptTracker"
# ID: button id 1011 of card id 1016 of stack "ScriptTracker"
*/


on mouseUp
   topLevel this stack
   choose browse tool
   if the mode of stack "ScriptTrackerLog" is 4 then
      toplevel stack "ScriptTrackerLog"
   end if
   if the mode of stack "ScriptTrackerPrefs" is 4 then
      toplevel stack "ScriptTrackerPrefs"
   end if
   go card "Tracker"
end mouseUp
