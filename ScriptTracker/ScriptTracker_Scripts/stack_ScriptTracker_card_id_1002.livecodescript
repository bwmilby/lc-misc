Script "stack_ScriptTracker_card_id_1002"

/*
# Name: card id 1002 of stack "ScriptTracker"
# ID: card id 1002 of stack "ScriptTracker"
*/


//>LOCALS
local sLog


on openStack
   set the hilite of button "Automatic" of me to false
   put empty into field "log"
end openStack


on resumeStack
   set the text of button "StackMenu" to IDEUserMainstacks()
end resumeStack


command addToLog pText
   put pText & lf after field "log"
   set the vscroll of field "log" to the formattedHeight of field "log"
end addToLog


command clearLog
   put the text of field "log" into sLog
   put empty into field "log"
end clearLog


command restoreLog
   if the text of field "log" is empty then
      set the text of field "log" to sLog
   end if
end restoreLog


on saveStackRequest
   put empty into field "log"
   set the text of button "StackMenu" to empty
   pass saveStackRequest
end saveStackRequest
