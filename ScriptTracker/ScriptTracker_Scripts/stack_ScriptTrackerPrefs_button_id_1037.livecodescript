Script "stack_ScriptTrackerPrefs_button_id_1037"

/*
# Name: button "AutoExternalEditor" of card "ScriptTracker" of stack "ScriptTrackerPrefs" of stack "ScriptTracker"
# ID: button id 1037 of card id 1034 of stack "ScriptTrackerPrefs" of stack "ScriptTracker"
*/


on editScript pObject, pAt
   if the hilite of button "AutoExternalEditor" of card "ScriptTracker" \
         of stack "ScriptTrackerPrefs" of stack "ScriptTracker" \
         and not __debuggerActivated() then
      send "ideEditScript pObject" to button "Automatic" of card "Tracker" \
            of stack "ScriptTracker"
      if the result is "pass" then
         pass editScript
      end if
   else
      pass editScript
   end if
end editScript


private function __debuggerActivated
   local tContext
   put the executionContexts into tContext
   return ("remotedebugger.livecode" is in tContext) or \
         ("revdebuggerlibrary.livecodescript" is in tContext)
end __debuggerActivated


on revIDEEditScriptOfObject pObject
   if the hilite of button "AutoExternalEditor" of card "ScriptTracker" \
         of stack "ScriptTrackerPrefs" of stack "ScriptTracker" \
         and __contextMenuPick() then
      send "ideEditScript pObject" to button "Automatic" of card "Tracker" \
            of stack "ScriptTracker"
      if the result is "pass" then
         pass revIDEEditScriptOfObject
      end if
   else
      pass revIDEEditScriptOfObject
   end if
end revIDEEditScriptOfObject


private function __contextMenuPick
   local tContext
   put the executionContexts into tContext
   return ("revMenubarContextMenuPick" is in tContext)
end __contextMenuPick
