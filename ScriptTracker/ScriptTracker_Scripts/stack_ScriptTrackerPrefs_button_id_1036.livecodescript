Script "stack_ScriptTrackerPrefs_button_id_1036"

/*
# Name: button "SyncBeforeSave" of card "ScriptTracker" of stack "ScriptTrackerPrefs" of stack "ScriptTracker"
# ID: button id 1036 of card id 1034 of stack "ScriptTrackerPrefs" of stack "ScriptTracker"
*/


on SaveStackRequest
   local tSyncStack, tTarget
   
   if the hilite of button "SyncBeforeSave" of card "ScriptTracker" \
         of stack "ScriptTrackerPrefs" of stack "ScriptTracker" then
      put the text of field "StackName" of card "Tracker" of \
            stack "ScriptTracker" into tSyncStack
      put the short name of (word -2 to -1 of the long id of the target) into tTarget
      if tSyncStack is tTarget then
         send "mouseUp" to button "SyncScripts" of card "Tracker" of \
               stack "ScriptTracker"
      end if
   end if
   pass SaveStackRequest
end SaveStackRequest
