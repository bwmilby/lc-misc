Script "stack_ScriptTracker_card_id_1002"

/*
# Name: card "Tracker" of stack "ScriptTracker"
# ID: card id 1002 of stack "ScriptTracker"
*/


//>LOCALS
local sCount, sLog, sLogBackup, sLogMessage


on openCard
   set the showBorder of button "StackMenu" of me to (the platform is not "Linux")
   set the hilite of button "Automatic" of me to false
   put empty into field "log" of stack "ScriptTrackerLog"
   put empty into field "count"
   loadPrefs
   insert the script of button "SyncBeforeSave" of card "ScriptTracker" \
         of stack "ScriptTrackerPrefs" of stack "ScriptTracker" into front
end openCard


on saveStackRequest
   put empty into field "log" of stack "ScriptTrackerLog"
   put empty into field "count"
   set the text of button "StackMenu" to empty
   pass saveStackRequest
end saveStackRequest


on closeCard
   set the hilite of button "Automatic" of me to false
end closeCard


on closeStackRequest
   revIDEUnsubscribe "ideEditScript"
   remove the script of button "SyncBeforeSave" of card "ScriptTracker" \
         of stack "ScriptTrackerPrefs" of stack "ScriptTracker" from front
   remove the script of button "AutoExternalEditor" of card "ScriptTracker" \
         of stack "ScriptTrackerPrefs" of stack "ScriptTracker" from front
   pass closeStackRequest
end closeStackRequest


// Logging handlers


command addToLog pText
   put pText & lf before sLog
   if sLogMessage is empty then
      send "displayLog" to me in 500 milliseconds
      put the result into sLogMessage
   end if
end addToLog


command displayLog
   if sLogMessage is not empty then
      cancel sLogMessage
      put empty into sLogMessage
   end if
   set the text of field "log" of stack "ScriptTrackerLog" to sLog
end displayLog


command clearLog
   put 0 into sCount
   put sLog into sLogBackup
   put empty into sLog
   displayLog
end clearLog


command restoreLog
   if sLog is empty then
      put sLogBackup into sLog
   end if
   displayLog
end restoreLog


command addToCount
   add 1 to sCount
   put sCount into field "count"
end addToCount


command clearCount
   put 0 into sCount
   put sCount into field "count"
end clearCount


// Delayed update handler


command updateRunningScriptLater \
      pObjectLongID, /* long ID of object  */ \
      pScript        /* replacement script */
   try
      set the script of pObjectLongID to pScript
      addToLog "Successfully set the script of" && pObjectLongID
   catch tError
      addToLog "Unable to set script of" && pObjectLongID
   end try
end updateRunningScriptLater
