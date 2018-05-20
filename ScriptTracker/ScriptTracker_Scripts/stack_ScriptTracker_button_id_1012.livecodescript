Script "stack_ScriptTracker_button_id_1012"

/*
# Name: button "Log" of card "Tracker" of stack "ScriptTracker"
# ID: button id 1012 of card id 1002 of stack "ScriptTracker"
*/


on mouseUp
   palette stack "ScriptTrackerLog"
   set the vscroll of field "log" of stack "ScriptTrackerLog" to \
         the formattedHeight of field "log" of stack "ScriptTrackerLog"
end mouseUp
