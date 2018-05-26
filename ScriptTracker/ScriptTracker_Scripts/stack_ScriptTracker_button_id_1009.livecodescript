Script "stack_ScriptTracker_button_id_1009"

/*
# Name: button "Automatic" of card "Tracker" of stack "ScriptTracker"
# ID: button id 1009 of card id 1002 of stack "ScriptTracker"
# Behavior: button id 1003 of stack "ScriptTracker"
*/


//>CONSTANTS
constant kScrollToBottom = "yes"

//>LOCALS
local sDataA, sFiles, sFolderToWatch, sLastDirContentsMD5


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
      addToLog "Elapsed time:" && (the milliseconds - tStartMS) && "ms", kScrollToBottom
      
      -- Start watching:
      put sDataA["ExportPath"] into sFolderToWatch
      WatchFolder "UpdateScripts"
   else
      -- Stop watching:
      put empty into sFolderToWatch
      put empty into sLastDirContentsMD5
   end if
end mouseUp


on WatchFolder pCallbackHandlerName
   local tDirContentsMD5
   
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
   end if
end WatchFolder


on UpdateScripts
   local tFile, tStackName, tStart, tStartMS, tStartTime, tTime
   
   clearLog
   
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
      addToLog "Elapsed time:" && (the milliseconds - tStartMS) && "ms", kScrollToBottom
   end if
   
   send "WatchFolder" && _q("UpdateScripts") to me in 1000 millisecs
end UpdateScripts


on ExternalEditScript pObject
   local tEditor, tFileName, tObjectID, tResult, tStackName
   
   // verify that mainstack is being tracked
   put the short name of (word -2 to -1 of pObject) into tStackName
   if tStackName is not sDataA["mainstack"] then exit ExternalEditScript
   
   // check to see if object is actually in a substack
   if word -5 of pObject is "stack" then
      put char 2 to -2 of word -4 of pObject into tStackName
   end if
   
   // objects in a background/shared group are named differently
   put word 1 to 3 of pObject into tObjectID
   if word 1 of tObjectID is "group" and \
         word 3 of tObjectID is among the lines of \
         sDataA[tStackName]["sharedGroupIDs"] then
      put "bkgnd" into word 1 of tObjectID
   end if
   
   // generate file name
   put sDataA["ExportPath"] & "stack_" & \
         replaceText(tStackName, space, "_") & "_" into tFileName
   if word 1 of pObject is not "stack" then
      put replaceText(tObjectID, space, "_") after tFileName
   end if
   put ".livecodescript" after tFileName
   
   // try to open in external editor
   put getPref("Editor") into tEditor
   if tEditor is not empty then
      launch tFileName with tEditor
      put the result into tResult
      if tResult is not empty and tResult is not tEditor then
         addToLog "Error opening" && tFileName && "with" && tEditor & ":" && tResult
      end if
   end if
   
   // not currently able to prevent SE from opening
end ExternalEditScript
