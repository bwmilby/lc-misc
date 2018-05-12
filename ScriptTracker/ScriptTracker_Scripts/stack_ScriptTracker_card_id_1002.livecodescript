Script "stack_ScriptTracker_card_id_1002"

/*
# Name: card id 1002 of stack "ScriptTracker"
# ID: card id 1002 of stack "ScriptTracker"
*/


//>CONSTANTS
constant kScrollToBottom = "yes"

//>LOCALS
local sCount, sLogBackup


on openStack
   set the hilite of button "Automatic" of me to false
   put empty into field "log" of stack "ScriptTrackerLog"
   put empty into field "count"
end openStack


on resumeStack
   local tStacks
   
   repeat for each line tStack in IDEUserMainstacks()
      if the mode of stack tStack > 0 then
         put tStack & lf after tStacks
      end if
   end repeat
   delete char -1 of tStacks
   set the text of button "StackMenu" to tStacks
end resumeStack


on saveStackRequest
   put empty into field "log" of stack "ScriptTrackerLog"
   put empty into field "count"
   set the text of button "StackMenu" to empty
   pass saveStackRequest
end saveStackRequest


command addToLog pText, pScrollToBottom
   put pText & lf after field "log" of stack "ScriptTrackerLog"
   if pScrollToBottom is not empty then
      set the vscroll of field "log" of stack "ScriptTrackerLog" to \
            the formattedHeight of field "log" of stack "ScriptTrackerLog"
   end if
end addToLog


command addCharToLog pChar
   if pChar is empty then
      put "*" after field "log" of stack "ScriptTrackerLog"
   else
      put pChar after field "log" of stack "ScriptTrackerLog"
   end if
end addCharToLog


command clearLog
   put 0 into sCount
   put the text of field "log" of stack "ScriptTrackerLog" into sLogBackup
   put empty into field "log" of stack "ScriptTrackerLog"
end clearLog


command restoreLog
   if the text of field "log" of stack "ScriptTrackerLog" is empty then
      set the text of field "log" of stack "ScriptTrackerLog" to sLogBackup
   end if
end restoreLog


command addToCount
   add 1 to sCount
   put sCount into field "count"
end addToCount


command clearCount
   put 0 into sCount
   put sCount into field "count"
end clearCount


command updateRunningScriptLater \
      pObjectLongID, /* long ID of object  */ \
      pScript        /* replacement script */
   addToLog "Trying to set script of" && pObjectLongID, kScrollToBottom
   set the script of pObjectLongID to pScript
end updateRunningScriptLater
