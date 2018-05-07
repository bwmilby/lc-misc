Script "stack_ScriptTracker_button_id_1009"

/*
# Name: button "Automatic" of card id 1002 of stack "ScriptTracker"
# ID: button id 1009 of card id 1002 of stack "ScriptTracker"
# Behavior: button id 1003 of stack "ScriptTracker"
*/


//>LOCALS
local sFolderToWatch, sLastDirContentsMD5


on mouseUp
   local tDataA, tStackName
   
   if the hilite of me is true then
      -- Do an initial sync:
      put field "StackName" of this card into tStackName
      buildMainStackArray tStackName, tDataA
      exportStackScripts tStackName, tDataA
      
      -- Start watching:
      put tDataA["exportPath"] into sFolderToWatch
      WatchFolder "UpdateScripts"
   else
      -- Stop watching:
      put empty into sFolderToWatch
      put empty into sLastDirContentsMD5
   end if
end mouseUp


on WatchFolder pCallbackHandlerName
   local tDirContentsMD5, tFiles
   
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
   put files(sFolderToWatch,"detailed") into tFiles
   // TODO:  need to delete item 6 of detailed files...
   //        don't want to do this based on access time
   
   -- Put MD5 digest of file list into tmp, comparing it to old one:
   put md5Digest(tFiles) into tDirContentsMD5
   if sLastDirContentsMD5 is not empty \
         and tDirContentsMD5 <> sLastDirContentsMD5 then
      send pCallbackHandlerName
   else
      put tDirContentsMD5 into sLastDirContentsMD5
      send "WatchFolder "&pCallbackHandlerName to me in 500 millisecs
   end if
end WatchFolder


on UpdateScripts
   local tStackName, tStart, tStartMS, tStartTime
   
   addToLog "Folder changed! " & the short date && the long time
   lock screen
   clearLog
   
   put empty into sLastDirContentsMD5
   put the milliseconds into tStartMS
   put the long time into tStartTime
   
   put field "StackName" of this card into tStackName
   buildMainStackArray tStackName, sDataA
   exportStackScripts tStackName, sDataA
   
   restoreLog
   addToLog "Start time:" && tStartTime && "Finish time:" && the long time
   addToLog "Elapsed time:" && (the milliseconds - tStartMS) && "ms"
   unlock screen
   
   send "WatchFolder" && _q("UpdateScripts") to me in 500 millisecs
end UpdateScripts
