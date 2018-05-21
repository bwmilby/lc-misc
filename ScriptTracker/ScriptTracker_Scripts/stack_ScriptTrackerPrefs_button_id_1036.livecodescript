Script "stack_ScriptTrackerPrefs_button_id_1036"

/*
# Name: button "SyncBeforeSave" of card "ScriptTracker" of stack "ScriptTrackerPrefs" of stack "ScriptTracker"
# ID: button id 1036 of card id 1034 of stack "ScriptTrackerPrefs" of stack "ScriptTracker"
*/


on SaveStackRequest
   local tStack, tTarget
   
   if the hilite of button "SyncBeforeSave" of card "ScriptTracker" \
         of stack "ScriptTrackerPrefs" of stack "ScriptTracker" then
      put the text of field "StackName" of card "Tracker" of stack "ScriptTracker" into tStack
      put char 2 to -2 of word 2 of the owner of the target into tTarget
      if tStack is tTarget then
         send "mouseUp" to button "SyncScripts" of card "Tracker" of stack "ScriptTracker"
      end if
   end if
   pass SaveStackRequest
end SaveStackRequest
