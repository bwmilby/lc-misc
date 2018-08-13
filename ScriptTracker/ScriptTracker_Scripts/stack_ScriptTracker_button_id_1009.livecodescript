Script "stack_ScriptTracker_button_id_1009"

/*
# Name: button "Automatic" of card "Tracker" of stack "ScriptTracker"
# ID: button id 1009 of card id 1002 of stack "ScriptTracker"
# Behavior: button id 1003 of stack "ScriptTracker"
*/


//>LOCALS
local sDataA, sFiles, sFolderToWatch, sLastDirContentsMD5, sMessage


on mouseUp
   local tStackName, tStartMS, tStartTime
   
   if the hilite of me is true then
      -- Verify that stack exists
      put field "StackName" of this card into tStackName
      if there is not a stack tStackName then
         anwswer "Stack not found: " & _q(tStackName)
         set the hilite of me to false
         exit mouseUp
      end if
      
      -- Do an initial sync:
      put the milliseconds into tStartMS
      put the long time into tStartTime
      clearLog
      buildMainStackArray tStackName, sDataA
      exportMainStackScripts tStackName, sDataA
      addToLog "Start time:" && tStartTime && "Finish time:" && the long time
      addToLog "Elapsed time:" && (the milliseconds - tStartMS) && "ms"
      
      -- Subscribe to edit script messages
      ideSubscribe "ideEditScript"
      insert the script of button "AutoExternalEditor" of card "ScriptTracker" \
            of stack "ScriptTrackerPrefs" of stack "ScriptTracker" into front
      
      -- Start watching:
      put sDataA["ExportPath"] into sFolderToWatch
      WatchFolder "UpdateScripts"
   else
      -- Stop watching:
      put empty into sFolderToWatch
      put empty into sLastDirContentsMD5
      revIDEUnsubscribe "ideEditScript"
      remove the script of button "AutoExternalEditor" of card "ScriptTracker" \
            of stack "ScriptTrackerPrefs" of stack "ScriptTracker" from front
   end if
end mouseUp


on WatchFolder pCallbackHandlerName
   local tDirContentsMD5, tMessages
   
   -- Make sure there are not additional messages queued
   if sMessage is not empty then
      cancel sMessage
      put empty into sMessage
   end if

   if sFolderToWatch is empty then
      set the hilite of me to false
      exit WatchFolder
   end if
   
   if there is not a folder sFolderToWatch then
      anwswer "Folder does not exist: " & _q(sFolderToWatch)
      set the hilite of me to false
      exit WatchFolder
   end if
   
   -- Get file list:
   put files(sFolderToWatch,"detailed") into sFiles
   
   -- Put MD5 digest of file list into tmp, comparing it to old one:
   put md5Digest(sFiles) into tDirContentsMD5
   
   if sLastDirContentsMD5 is not empty \
         and tDirContentsMD5 <> sLastDirContentsMD5 then
      send pCallbackHandlerName
   else
      put tDirContentsMD5 into sLastDirContentsMD5
      send "WatchFolder "&pCallbackHandlerName to me in 500 millisecs
      put the result into sMessage
   end if
end WatchFolder


on UpdateScripts
   local tFile, tStackName, tStart, tStartMS, tStartTime, tTime
   
   clearLog
   
   -- Make sure there are not additional messages queued
   if sMessage is not empty then
      cancel sMessage
      put empty into sMessage
   end if
   
   put empty into sLastDirContentsMD5
   put the milliseconds into tStartMS
   put the long time into tStartTime
   
   put field "StackName" of this card into tStackName
   
   filter sFiles with "stack*"
   repeat for each line tLine in sFiles
      put item 1 of tLine into tFile
      put item 5 of tLine into tTime
      if tTime > sDataA["files"][tFile] then
         loadScriptFile sFolderToWatch & tFile, sDataA
      end if
   end repeat
   if sDataA["diff"] is not empty then
      saveDiffFile sDataA
   end if
   
   if the text of field "log" of stack "ScriptTrackerLog" is empty then
      restoreLog
   else
      addToLog "Start time:" && tStartTime && "Finish time:" && the long time
      addToLog "Elapsed time:" && (the milliseconds - tStartMS) && "ms"
   end if
   
   send "WatchFolder" && _q("UpdateScripts") to me in 1000 millisecs
   put the result into sMessage
end UpdateScripts


constant kEditScriptButton = "button id 1037 of card id 1034"
on ideEditScript pObject
   local tContext, tOpenExternalEditor
   put the executionContexts into tContext
   -- attempt to avoid externally editing a script if it is being opened
   -- for the debugger, if in browse mode then request should come from
   -- the "AutoExternalEditor" button script that is placed in front
   put (word 1 of the tool is "pointer") or \
         (kEditScriptButton is in tContext) into tOpenExternalEditor
   if the hilite of button "AutoExternalEditor" of card "ScriptTracker" \
         of stack "ScriptTrackerPrefs" of stack "ScriptTracker" \
         and tOpenExternalEditor then
      editScriptFile pObject, sDataA
      return the result
   end if
end ideEditScript
