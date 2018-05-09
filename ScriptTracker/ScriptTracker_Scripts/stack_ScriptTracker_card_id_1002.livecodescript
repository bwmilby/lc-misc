Script "stack_ScriptTracker_card_id_1002"

/*
# Name: card id 1002 of stack "ScriptTracker"
# ID: card id 1002 of stack "ScriptTracker"
*/


//>LOCALS
local sLog


on openStack
   set the hilite of button "Automatic" of me to false
   put empty into field "log" of stack "ScriptTrackerLog"
end openStack


on resumeStack
   set the text of button "StackMenu" to IDEUserMainstacks()
end resumeStack


on saveStackRequest
   put empty into field "log" of stack "ScriptTrackerLog"
   set the text of button "StackMenu" to empty
   pass saveStackRequest
end saveStackRequest


command addToLog pText
   put pText & lf after field "log" of stack "ScriptTrackerLog"
   set the vscroll of field "log" of stack "ScriptTrackerLog" to \
         the formattedHeight of field "log" of stack "ScriptTrackerLog"
end addToLog


command clearLog
   put the text of field "log" of stack "ScriptTrackerLog" into sLog
   put empty into field "log" of stack "ScriptTrackerLog"
end clearLog


command restoreLog
   if the text of field "log" of stack "ScriptTrackerLog" is empty then
      set the text of field "log" of stack "ScriptTrackerLog" to sLog
   end if
end restoreLog


command updateRunningScriptLater \
      pObjectLongID, /* long ID of object  */ \
      pScript        /* replacement script */
   addToLog "Trying to set script of" && pObjectLongID
   set the script of pObjectLongID to pScript
end updateRunningScriptLater
