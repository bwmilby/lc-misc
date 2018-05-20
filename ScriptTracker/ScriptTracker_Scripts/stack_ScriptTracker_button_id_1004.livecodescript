Script "stack_ScriptTracker_button_id_1004"

/*
# Name: button "SyncScripts" of card "Tracker" of stack "ScriptTracker"
# ID: button id 1004 of card id 1002 of stack "ScriptTracker"
# Behavior: button id 1003 of stack "ScriptTracker"
*/


//>CONSTANTS
constant kScrollToBottom = "yes"


on mouseUp
   local tDataA, tStackName, tStart, tStartMS, tStartTime
   
   if the hilite of button "Automatic" of this card is true then
      send "mouseUp" to button "Automatic" of this card
      exit mouseUp
   end if
   
   clearLog
   put the milliseconds into tStartMS
   put the long time into tStartTime
   
   put field "StackName" of this card into tStackName
   
   buildMainStackArray tStackName, tDataA
   exportMainStackScripts tStackName, tDataA
   addToLog "Start time:" && tStartTime && "Finish time:" && the long time
   addToLog "Elapsed time:" && (the milliseconds - tStartMS) && "ms", kScrollToBottom
end mouseUp
