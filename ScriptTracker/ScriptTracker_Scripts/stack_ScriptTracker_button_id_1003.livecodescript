Script "stack_ScriptTracker_button_id_1003"

/*
# Name: button "ScriptTrackerBehavior" of card id 1002 of stack "ScriptTracker"
# ID: button id 1003 of card id 1002 of stack "ScriptTracker"
*/


/*
*
* SCRIPT TRACKER
*
* Automatically keep text file versions of all stack scripts in
* sync with a binary stack, keep diff files for each time a script
* is changed, and allow for editing of scripts outside of the IDE.
*
* Preferences are stored in a custom property set on the main stack.
*   exportPath           Folder path for stack script export (relative)
*   diffPath             Folder path for stack script export diffs (relative)
*   collisionPolicy      How changes to script and file are handled
*
* Variables available for merge with kDefaultDiffPath and kDefaultExportPath
*   [[tExportPath]]      evaluated path for script exports
*   [[tStackFileName]]   root of the file name of the main stack
*
* Constants are set with default values for preference options.
*   kCollisionPolicy     how changes to script and file are handled
*                        options:  Script, File, Skip, Ask
*   kDefaultDiffPath     relative path for diff files, merged
*   kDefaultExportPath   relative path for export files, merged
*   kDiffContext         number of lines on either side of each diff
*   kDigestType          digest algorithm to use, suggest MD5
*   kFileMethod          "binfile:" works for Mac/Linux (LF)
*                        "file:" will convert to/from CRLF for Windows
*   kPropertySet         name of the custom property set to use for tracking
*
*
* xDataA structure:
*    ["mainStack"]            Short name of main stack
*    ["exportPath"]           Folder path for stack script exports
*    ["diffPath"]             Folder path for stack diff export
*    ["collisionPolicy"]      How changes to script and file are handled
*    [stack short name]       Short name of stack/substack
*       ["longID"]            Long ID of stack
*       ["backgroundIDs"]     List of background group IDs
*       ["sharedGroupIDs"]    List of shared group IDs
*       ["cardIDs"]           List of card IDs
*       ["substacks"]         List of substack names
*    ["fileName"]             File name of last script exported
*/


//>CONSTANTS
constant kCollisionPolicy = "Ask"
constant kDefaultDiffPath = "[[tExportPath]]/diff"
constant kDefaultExportPath = "[[tStackFileName]]_Scripts"
constant kDiffContext = 2
constant kDigestType = "MD5"
constant kFileMethod = "binfile:"
constant kPropertySet = "bwmScriptTracker"
constant kPropertySetToDelete = "bwmSmartScriptOld"


command buildMainStackArray \
      pStackName,   /* stack short name            */ \
      @xDataA,      /* export data array           */ \
      pPath         /* path for exports (optional) */
   local tDiffPath, tExportPath, tProps, tStackFileName, tStackPath
   
   // ensure stack exists before proceeding
   if there is not a stack pStackName then
      answer "Stack" && pStackName && "not found."
      exit buildMainStackArray
   end if
   
   // get stack path and file name
   put char 2 to -2 of word -1 of the long id of stack pStackName into tStackPath
   set the itemdel to "/"
   put item -1 of tStackPath into tStackFileName
   delete item -1 of tStackPath
   
   // get stack level preferences
   put the customProperties[kPropertySet] of stack pStackName into tProps
   
   // set path for script exports
   if pPath is empty then
      put tProps["exportPath"] into tExportPath
      if tExportPath is empty then
         set the itemdel to "."
         delete item -1 of tStackFileName
         put merge(kDefaultExportPath) into tExportPath
      end if
      put tStackPath & "/" & tExportPath into pPath
   else
      put pPath into tExportPath
   end if
   if there is not a folder pPath then
      try
         create folder pPath
      catch tError
         answer "Error" && tError && "creating folder" && pPath
         exit buildMainStackArray
      end try
   end if
   put tExportPath into tProps["exportPath"]
   put pPath into xDataA["exportPath"]
   
   // set path for diff exports
   put tProps["diffPath"] into tDiffPath
   if tDiffPath is empty then
      put merge(kDefaultDiffPath) into tDiffPath
   end if
   put tStackPath & "/" & tDiffPath into pPath
   if there is not a folder pPath then
      try
         create folder pPath
      catch tError
         answer "Error" && tError && "creating folder" && pPath
         exit buildMainStackArray
      end try
   end if
   put tDiffPath into tProps["diffPath"]
   put pPath into xDataA["diffPath"]
   
   // set collision policy
   if tProps["collisionPolicy"] is empty then
      put kCollisionPolicy into tProps["collisionPolicy"]
   end if
   put tProps["collisionPolicy"] into xDataA["collisionPolicy"]
   
   // save stack level preferences
   set the customProperties[kPropertySet] of stack pStackName to tProps
   
   put pStackName into xDataA["mainStack"]
   
   // add object ID lists to array (backgrounds, shared groups, cards, substacks)
   buildStackArray pStackName, xDataA
   put the substacks of xDataA[pStackName]["longID"] into xDataA[pStackName]["substacks"]
   repeat for each line tSubstack in xDataA[pStackName]["substacks"]
      buildStackArray tSubstack, xDataA
   end repeat
end buildMainStackArray


command buildStackArray \
      pStackName,   /* stack short name          */ \
      @xDataA       /* export data array         */
   local tStackLongID
   
   put the long id of stack pStackName into tStackLongID
   put tStackLongID into xDataA[pStackName]["longID"]
   put the backgroundIDs of tStackLongID into xDataA[pStackName]["backgroundIDs"]
   put the sharedGroupIDs of tStackLongID into xDataA[pStackName]["sharedGroupIDs"]
   put the cardIDs of tStackLongID into xDataA[pStackName]["cardIDs"]
end buildStackArray


command exportStackScripts \
      pStackName,   /* stack short name          */ \
      @xDataA       /* export data array         */
   local tObjectLongID, tStackLongID
   
   // save the stack script
   put xDataA[pStackName]["longID"] into tStackLongID
   saveScriptFile pStackName, xDataA, tStackLongID
   
   // save background and shared group scripts and objects
   repeat for each line tObjectID in xDataA[pStackName]["sharedGroupIDs"]
      // background/shared groups can provide inconsistent long IDs
      // force a short version that does not use group/card
      put "bkgnd id" && tObjectID && "of" && tStackLongID into tObjectLongID
      saveScriptFile pStackName, xDataA, tObjectLongID
      exportChildContolScripts pStackName, xDataA, tObjectLongID
   end repeat
   
   // save card scripts and objects
   repeat for each line tObjectID in xDataA[pStackName]["cardIDs"]
      put the long id of card ID tObjectID of tStackLongID into tObjectLongID
      saveScriptFile pStackName, xDataA, tObjectLongID
      exportChildContolScripts pStackName, xDataA, tObjectLongID
   end repeat
   
   // save substacks
   repeat for each line tSubstack in xDataA[pStackName]["substacks"]
      exportStackScripts tSubstack, xDataA
   end repeat
   
   // save accumulated diff file
   if pStackName is xDataA["mainStack"] and xDataA["diff"] is not empty then
      put xDataA["diff"] into URL (kFileMethod & xDataA["diffPath"] & "/" & "diff_" & the seconds & ".txt")
   end if
end exportStackScripts


command exportChildContolScripts \
      pStackName,   /* stack short name          */ \
      @xDataA,      /* export data array         */ \
      pObjectLongID /* long ID of parent control */
   local tChildControlIDs, tControlLongID, tSharedGroupIDs, tStackLongID
   
   try
      put the childControlIDs of pObjectLongID into tChildControlIDs
      if tChildControlIDs is empty then exit exportChildContolScripts
   catch tError
      exit exportChildContolScripts
   end try
   
   put xDataA[pStackName]["longID"] into tStackLongID
   put xDataA[pStackName]["sharedGroupIDs"] into tSharedGroupIDs
   
   repeat for each line tControlID in tChildControlIDs
      if tControlID is among the lines of tSharedGroupIDs then next repeat
      put the long id of control ID tControlID of tStackLongID into tControlLongID
      saveScriptFile pStackName, xDataA, tControlLongID
      exportChildContolScripts pStackName, xDataA, tControlLongID
   end repeat
end exportChildContolScripts


command saveScriptFile \
      pStackName,   /* stack short name          */ \
      @xDataA,      /* export data array         */ \
      pObjectLongID /* long ID of control        */
   local tCollisionPolicy, tDiff, tFileMissing, tFileNewer, tFileScript
   local tFullFilePath, tHash, tProps, tPropSets, tScript, tScriptChanged
   
   if pObjectLongID is empty then put xDataA[pStackName]["longID"] into pObjectLongID
   
   put _buildFile(pStackName, xDataA, pObjectLongID) into tScript
   if tScript is empty then exit saveScriptFile
   
   // optional feature to delete custom property set from all objects
   put the customPropertySets of pObjectLongID into tPropSets
   filter tPropSets without kPropertySetToDelete
   set the customPropertySets of pObjectLongID to tPropSets
   
   // check to see if the file needs to be updated
   put the customProperties[kPropertySet] of pObjectLongID into tProps
   put xDataA["exportPath"] & "/" & xDataA["fileName"] into tFullFilePath
   put messageDigest(tScript, kDigestType) into tHash
   
   put there is not a file tFullFilePath into tFileMissing
   put (_getFileSeconds(xDataA) > tProps["fileSeconds"]) into tFileNewer
   put tProps[kDigestType] is not tHash into tScriptChanged
   
   if not (tFileMissing or tFileNewer or tScriptChanged) then
      // no changes
      exit saveScriptFile
   end if
   
   if not tFileMissing then
      put URL (kFileMethod & tFullFilePath) into tFileScript
      replace crlf with lf in tFileScript
      if tFileNewer then
         put diffCompare(tScript,tFileScript,kDiffContext) into tDiff
         put tFullFilePath & lf & pObjectLongID & lf & lf before tDiff
      else if tScriptChanged then
         put diffCompare(tFileScript,tScript,kDiffContext) into tDiff
         put pObjectLongID & lf & tFullFilePath & lf & lf before tDiff
      end if
      put tDiff & lf & lf after xDataA["diff"]
   end if
   
   if tFileNewer and tScriptChanged then
      // changes in both file and IDE
      put xDataA["collisionPolicy"] into tCollisionPolicy
      if tCollisionPolicy is "Ask" then
         answer warning "Changes were found in both the script and" \
               && xDataA["fileName"] & "." & lf & \
               "Which version should be kept?" with "Script" or "File" or "Skip"
         put it into tCollisionPolicy
      end if
      switch tCollisionPolicy
         case "Script"
            put false into tFileNewer
            break
         case "File"
            put false into tScriptChanged
            break
         case "Skip"
            exit saveScriptFile
            break
      end switch
   end if
   
   if tFileNewer then
      put messageDigest(tFileScript, kDigestType) into tProps[kDigestType]
      _removeHeader tFileScript
      addToLog xDataA["fileName"] && "changed outside of IDE"
      try
         set the script of pObjectLongID to tFileScript
      catch tError
         addToLog "Unable to import script... retrying in 500ms"
         send "updateRunningScriptLater pObjectLongID, tFileScript" to this card in 500 milliseconds
      end try
   else if tFileMissing or tScriptChanged then
      put tHash into tProps[kDigestType]
      put tScript into URL (kFileMethod & tFullFilePath)
      addToLog xDataA["fileName"] && "exported"
   end if
   
   put _getFileSeconds(xDataA) into tProps["fileSeconds"]
   set the customProperties[kPropertySet] of pObjectLongID to tProps
end saveScriptFile


command loadScriptFile \
      pFileName,    /* file name to load         */ \
      @xDataA       /* export data array         */
   local tFileScript, tObjectLongID, tOffset, tStackName
   
   put line 1 to 8 of URL ("file:" & pFileName) into tFileScript
   
   put offset("# ID:",tFileScript)+5 into tOffset
   delete char 1 to tOffset of tFileScript
   put line 1 of tFileScript into tObjectLongID
   
   if not exists(tObjectLongID) then
      addToLog "File not valid:" && pFileName & lf \
            & tObjectLongID && "does not exist."
      exit loadScriptFile
   end if
   
   // pull tStackName from long ID
   if word -5 of tObjectLongID is "stack" then
      put char 2 to -2 of word -4 of tObjectLongID into tStackName
   else
      put char 2 to -2 of word -1 of tObjectLongID into tStackName
   end if
   
   saveScriptFile tStackName, xDataA, tObjectLongID
end loadScriptFile


private command _removeHeader \
      @xScript       /* script from file export */
   local tOffset
   
   if xScript begins with "Script" then
      delete line 1 to 2 of xScript
      if xScript begins with "/*" then
         put offset("*/",xScript)+2 into tOffset
         delete char 1 to tOffset of xScript
         delete line 1 to 2 of xScript
      end if
   end if
end _removeHeader


private function _buildFile \
      pStackName,   /* stack short name          */ \
      @xDataA,      /* export data array         */ \
      pObjectLongID /* long ID of control        */
   local tBehavior, tFileName, tHeader, tScript
   
   if pObjectLongID is empty then return empty
   
   if (the script of pObjectLongID is not empty) then
      put the script of pObjectLongID into tScript
   end if
   if (the behavior of pObjectLongID is not empty) then
      put "# Behavior:" && the behavior of pObjectLongID & lf into tBehavior
   end if
   if tScript is empty and tBehavior is empty then
      return empty
   end if
   
   // generate file name
   put "stack_" & replaceText(pStackName, space, "_") & "_" into tFileName
   if word 1 of pObjectLongID is not "stack" then
      put replaceText(word 1 to 3 of pObjectLongID, space, "_") after tFileName
   end if
   put tFileName & ".livecodescript" into xDataA["fileName"]
   
   // build file header
   put "Script" && quote & tFileName & quote & lf & lf into tHeader
   put "/*" & lf after tHeader
   put "# Name:" && _getObjectLongName(pObjectLongID, \
         xDataA[pStackName]["longID"]) & lf after tHeader
   put _q(xDataA["mainStack"]) into word -1 of line -1 of tHeader
   put "# ID:" && pObjectLongID & lf after tHeader
   put _q(xDataA["mainStack"]) into word -1 of line -1 of tHeader
   put tBehavior after tHeader
   put _groupComment(pStackName, xDataA, pObjectLongID) after tHeader
   put "*/" & lf after tHeader
   
   return tHeader & lf & lf & tScript
end _buildFile


private function _groupComment \
      pStackName,   /* stack short name          */ \
      @xDataA,      /* export data array         */ \
      pObjectLongID /* long ID of control        */
   local tComment, tObjectID
   
   if word 1 of pObjectLongID is not "bkgnd" then return empty
   put word 3 of pObjectLongID into tObjectID
   if tObjectID is among the lines of xDataA[pStackName]["backgroundIDs"] then
      put "# Background on card IDs: " into tComment
   else if tObjectID is among the lines of xDataA[pStackName]["sharedGroupIDs"] then
      put "# Shared group on card IDs: " into tComment
   else
      return empty
   end if
   put the cardIDs of group ID tObjectID of stack pStackName after tComment
   put replaceText(tComment, lf, ", ") into tComment
   return lf & tComment & lf
end _groupComment


private function _getFileSeconds @xDataA
   local tFileList
   
   put files(xDataA["exportPath"], "detailed") into tFileList
   filter tFileList with xDataA["fileName"] & "*"
   return item 5 of line 1 of tFileList
end _getFileSeconds


private function _getObjectLongName pObjectLongID, pStackLongID
   local tObjectLongName, tObjectShortName
   
   // background/shared groups can provide inconsistent long names
   // force a short version that does not use group/card
   if word 1 of pObjectLongID is "bkgnd" then
      put the short name of pObjectLongID into tObjectShortName
      if word 2 of tObjectShortName is "id" then
         put pObjectLongID into tObjectLongName
      else
         put "bkgnd" && _q(tObjectShortName) && "of" && pStackLongID into tObjectLongName
      end if
   else
      put the long name of pObjectLongID into tObjectLongName
   end if
   return tObjectLongName
end _getObjectLongName


function _q pText
   return quote & pText & quote
end _q
