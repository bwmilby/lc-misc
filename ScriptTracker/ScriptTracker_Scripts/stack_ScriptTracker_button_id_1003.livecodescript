Script "stack_ScriptTracker_button_id_1003"

/*
# Name: button "ScriptTrackerBehavior" of card "Behaviors" of stack "ScriptTracker"
# ID: button id 1003 of card id 1016 of stack "ScriptTracker"
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
*   CollisionPolicy      How changes to script and file are handled
*   DiffPath             Folder path for stack script export diffs (relative)
*   ExportPath           Folder path for stack script export (relative)
*   ExtraPath            Folder path for extra files (relative)
*
* Variables available for merge with Default DiffPath and Default ExportPath
*   [[tExportPath]]      evaluated path for script exports
*   [[tStackFileName]]   root of the file name of the main stack
*
* Preferences that are used in this script
*   CollisionPolicy     choose which version of the script is retained when a
*                       change is noticed in both the file and stack
*                       options:  Stack, File, Skip, Ask
*                          (Skip makes no changes to the file but the diff is
*                          included; Stack or File will keep that version and
*                          update the file to match)
*   DiffPath            relative path for diff files, merged
*   ExportPath          relative path for export files, merged
*   ExtraPath           relative path for extra files, merged
*   DiffContext         number of lines on either side of each diff
*   DigestType          digest algorithm to use, suggest MD5
*   FileMethod          "binfile:" works for Mac/Linux (LF)
*                       "file:" will convert to CRLF for Windows
*                       "file:" is always used for importing scripts
*   PropertySet         name of the custom property set to use for tracking
*                       where the hash and file time stamp are kept for each
*                       object and stack level preferences are stored
*
*
* xDataA structure:
*    ["mainStack"]            Short name of main stack
*    ["mainStackFile"]        File name of main stack
*    ["ExportPath"]           Folder path for stack script exports
*    ["DiffPath"]             Folder path for stack diff export
*    ["ExtraPath"]            Folder path for extra files
*    ["CollisionPolicy"]      How changes to script and file are handled
*    [stack short name]       Short name of stack/substack
*       ["longID"]            Long ID of stack
*       ["backgroundIDs"]     List of background group IDs
*       ["sharedGroupIDs"]    List of shared group IDs
*       ["cardIDs"]           List of card IDs
*       ["substacks"]         List of substack names
*    ["files"]                Array of files to track removed scripts
*       [file name]           Modification time of file
*    ["fileName"]             File name of last script exported
*/


//>CONSTANTS
constant kPropertySetToDelete = "bwmSmartScriptOld"

//>LOCALS
local sDiffContext, sDigestType, sFileMethod, sPrefsA, sPropertySet


command initializePrefs
   put getPrefsA() into sPrefsA
   put sPrefsA["DiffContext"] into sDiffContext
   put sPrefsA["DigestType"] into sDigestType
   put sPrefsA["FileMethod"] into sFileMethod
   put sPrefsA["PropertySet"] into sPropertySet
end initializePrefs


command buildMainStackArray \
      pStackName,   /* stack short name            */ \
      @xDataA,      /* export data array           */ \
      pPath         /* path for exports (optional) */
   local tBasePath, tExportPath, tProps, tStackFileName
   
   // ensure stack exists before proceeding
   if there is not a stack pStackName then
      answer "Stack" && pStackName && "not found."
      exit buildMainStackArray
   end if
   
   // get the current preferences
   initializePrefs
   
   put pStackName into xDataA["mainStack"]
   put char 2 to -2 of word -1 of the long id of stack pStackName \
         into xDataA["mainStackFile"]
   
   // get stack path
   set the itemdel to "/"
   put item 1 to -2 of xDataA["mainStackFile"] into tBasePath
   
   // get stack file name without extension
   put item -1 of xDataA["mainStackFile"] into tStackFileName
   set the itemdel to "."
   if item 1 to -2 of tStackFileName is not empty then
      delete item -1 of tStackFileName
   end if
   put tStackFileName into xDataA["stackFileName"]
   
   // if pPath provided, use it as the base path
   if pPath is not empty then
      put pPath into tBasePath
   end if
   if char -1 of tBasePath is not "/" then put "/" after tBasePath
   
   // get stack level preferences
   put the customProperties[sPropertySet] of stack pStackName into tProps
   
   // set path for script exports
   ensureDirectoryExists tBasePath, merge(sPrefsA["ExportPath"]), \
         xDataA["ExportPath"], tProps["ExportPath"]
   if the result is "error" then exit buildMainStackArray
   put tProps["ExportPath"] into tExportPath
   put tExportPath into xDataA["ExportFolder"]
   
   // set path for diff exports
   ensureDirectoryExists tBasePath, merge(sPrefsA["DiffPath"]), \
         xDataA["DiffPath"], tProps["DiffPath"]
   if the result is "error" then exit buildMainStackArray
   
   // set path for extra files
   ensureDirectoryExists tBasePath, merge(sPrefsA["ExtraPath"]), \
         xDataA["ExtraPath"], tProps["ExtraPath"]
   if the result is "error" then exit buildMainStackArray
   
   // set collision policy
   if tProps["CollisionPolicy"] is empty then
      put sPrefsA["CollisionPolicy"] into tProps["CollisionPolicy"]
   end if
   put tProps["CollisionPolicy"] into xDataA["CollisionPolicy"]
   
   // save stack level preferences
   set the customProperties[sPropertySet] of stack pStackName to tProps
   
   // add object ID lists to array (backgrounds, shared groups, cards, substacks)
   buildStackArray pStackName, xDataA
   put the substacks of xDataA[pStackName]["longID"] into \
         xDataA[pStackName]["substacks"]
   repeat for each line tSubstack in xDataA[pStackName]["substacks"]
      buildStackArray tSubstack, xDataA
   end repeat
   
   // ensure list of files is reset
   delete variable xDataA["files"]
end buildMainStackArray


command ensureDirectoryExists \
      pBasePath,     /* base path for export folders     */ \
      pMergePath,    /* default relative path for folder */ \
      @rFullPath,    /* full path for folder             */ \
      @xRelativePath /* relative path for folder         */
   local tFullPath
   
   if xRelativePath is empty then
      put pMergePath into xRelativePath
   end if
   put pBasePath & xRelativePath into tFullPath
   if there is not a folder tFullPath then
      try
         create folder tFullPath
      catch tError
         answer "Error" && tError && "creating folder" && tFullPath
         return "error" for error
         exit ensureDirectoryExists
      end try
   end if
   if char -1 of tFullPath is not "/" then put "/" after tFullPath
   put tFullPath into rFullPath
end ensureDirectoryExists


command buildStackArray \
      pStackName,   /* stack short name          */ \
      @xDataA       /* export data array         */
   local tStackLongID
   
   put "stack" && _q(pStackName) into tStackLongID
   if pStackName is not xDataA["mainStack"] then
      put " of stack" && _q(xDataA["mainStack"]) after tStackLongID
   end if
   
   // ensure group-editing mode is disabled
   // cardIDs are not properly returned if enabled
   try
      set the editBackground of stack pStackName to false
   end try
   
   put tStackLongID into xDataA[pStackName]["longID"]
   put the backgroundIDs of tStackLongID into xDataA[pStackName]["backgroundIDs"]
   put the sharedGroupIDs of tStackLongID into xDataA[pStackName]["sharedGroupIDs"]
   put the cardIDs of tStackLongID into xDataA[pStackName]["cardIDs"]
end buildStackArray


command exportMainStackScripts \
      pStackName,   /* stack short name          */ \
      @xDataA       /* export data array         */
   // clear script index file
   put "# " & xDataA["mainStack"] & lf into url (sFileMethod & \
         xDataA["ExportPath"] & "../" & xDataA["stackFileName"] & ".md")

   // save main stack
   exportStackScripts pStackName, xDataA
   
   // save substacks
   repeat for each line tSubstack in xDataA[pStackName]["substacks"]
      exportStackScripts tSubstack, xDataA
   end repeat
   
   // save accumulated diff file
   if xDataA["diff"] is not empty then
      saveDiffFile xDataA
   end if
   
   // remove any extra files for objects that no longer exist
   _removeExtraFiles xDataA
end exportMainStackScripts


command exportStackScripts \
      pStackName,   /* stack short name          */ \
      @xDataA       /* export data array         */
   local tObjectLongID, tObjectLongName, tStackLongID
   
   // save the stack script
   put xDataA[pStackName]["longID"] into tStackLongID
   _saveScriptFile pStackName, xDataA, tStackLongID, tStackLongID
   
   // ensure group-editing mode is disabled
   // object long IDs are not properly returned if enabled
   try
      set the editBackground of stack pStackName to false
   end try
   
   // Manually build all long IDs so that the short stack name is used
   // and to ensure that references do not change based on whether a
   // card has been visited and which card is currently selected
   
   // save background and shared group scripts and objects
   repeat for each line tObjectID in xDataA[pStackName]["sharedGroupIDs"]
      // background/shared groups can provide inconsistent long IDs
      // force a short version that does not use group/card
      put "bkgnd id" && tObjectID && "of" && tStackLongID into tObjectLongID
      put _longName(tObjectLongID, tStackLongID) into tObjectLongName
      put "bkgnd" into word 1 of tObjectLongName
      _saveScriptFile pStackName, xDataA, tObjectLongID, tObjectLongName
      _exportChildContolScripts pStackName, xDataA, tObjectLongID, tObjectLongName
   end repeat
   
   // save card scripts and objects
   repeat for each line tObjectID in xDataA[pStackName]["cardIDs"]
      put "card id" && tObjectID && "of" && tStackLongID into tObjectLongID
      put _longName(tObjectLongID, tStackLongID) into tObjectLongName
      _saveScriptFile pStackName, xDataA, tObjectLongID, tObjectLongName
      _exportChildContolScripts pStackName, xDataA, tObjectLongID, tObjectLongName
   end repeat
end exportStackScripts


command saveDiffFile @xDataA
   put textEncode(xDataA["diff"], "UTF-8") into URL (sFileMethod & \
         xDataA["DiffPath"] & "diff_" & the seconds & ".txt")
   delete variable xDataA["diff"]
end saveDiffFile


private command _removeExtraFiles @xDataA
   local tFiles
   
   put files(xDataA["ExportPath"]) into tFiles
   filter tFiles with "stack*"
   repeat for each line tFile in tFiles
      if xDataA["files"][tFile] is empty then
         rename file xDataA["ExportPath"] & tFile to \
               xDataA["ExtraPath"] & the seconds & "_" & tFile
      end if
   end repeat
end _removeExtraFiles


private command _exportChildContolScripts \
      pStackName,     /* stack short name            */ \
      @xDataA,        /* export data array           */ \
      pObjectLongID,  /* long ID of parent control   */ \
      pObjectLongName /* long name of parent control */
   local tChildControlIDs, tControlLongID, tControlLongName, tSharedGroupIDs
   local tStackLongID
   
   if the dgProps["Control Type"] of pObjectLongID is "Data Grid" then
      // do not export the automatically generated dgGrid groups and controls
      exit _exportChildContolScripts
   end if
   
   try
      put the childControlIDs of pObjectLongID into tChildControlIDs
      if tChildControlIDs is empty then exit _exportChildContolScripts
   catch tError
      exit _exportChildContolScripts
   end try
   
   put xDataA[pStackName]["longID"] into tStackLongID
   put xDataA[pStackName]["sharedGroupIDs"] into tSharedGroupIDs
   
   repeat for each line tControlID in tChildControlIDs
      if tControlID is among the lines of tSharedGroupIDs then next repeat
      put the abbreviated id of control id tControlID of tStackLongID && "of" \
            && pObjectLongID into tControlLongID
      put _longName(tControlLongID, pObjectLongName) into tControlLongName
      _saveScriptFile pStackName, xDataA, tControlLongID, tControlLongName
      _exportChildContolScripts pStackName, xDataA, tControlLongID, tControlLongName
   end repeat
end _exportChildContolScripts


private command _saveScriptFile \
      pStackName,     /* stack short name          */ \
      @xDataA,        /* export data array         */ \
      pObjectLongID,  /* long ID of control        */ \
      pObjectLongName /* long name of control      */
   local tCollisionPolicy, tDiff, tFileHash, tFileMissing, tFileNewer
   local tFileScript, tFullFilePath, tHash, tProps, tPropSets
   local tScript, tScriptChanged
   
   if pObjectLongID is empty then
      put xDataA[pStackName]["longID"] into pObjectLongID
   end if
   
   put _buildFile(pStackName, xDataA, pObjectLongID, pObjectLongName) into tScript
   if tScript is empty then exit _saveScriptFile
   addToCount
   
   // optional feature to delete custom property set from all objects
   put the customPropertySets of pObjectLongID into tPropSets
   filter tPropSets without kPropertySetToDelete
   set the customPropertySets of pObjectLongID to tPropSets
   
   // check to see if the file needs to be updated
   put the customProperties[sPropertySet] of pObjectLongID into tProps
   put tProps["fileSeconds"] into xDataA["files"][xDataA["fileName"]]
   put xDataA["ExportPath"] & xDataA["fileName"] into tFullFilePath
   put messageDigest(tScript, sDigestType) into tHash
   
   put there is not a file tFullFilePath into tFileMissing
   put (_getFileSeconds(xDataA) > tProps["fileSeconds"]) into tFileNewer
   put tProps[sDigestType] is not tHash into tScriptChanged
   
   if not (tFileMissing or tFileNewer or tScriptChanged) then
      // no changes
      exit _saveScriptFile
   end if
   
   if not tFileMissing then
      put textDecode(URL ("file:" & tFullFilePath), "UTF-8") into tFileScript
      if tFileNewer then
         put messageDigest(tFileScript, sDigestType) into tFileHash
         if tHash is tFileHash then put false into tFileNewer
      end if
      if tFileNewer then
         put diffCompare(tScript,tFileScript,sDiffContext) into tDiff
         put tFullFilePath & lf & pObjectLongID & lf & lf before tDiff
      else if tScriptChanged then
         put diffCompare(tFileScript,tScript,sDiffContext) into tDiff
         put pObjectLongID & lf & tFullFilePath & lf & lf before tDiff
      end if
      if tDiff is not empty then put tDiff & lf & lf after xDataA["diff"]
   end if
   
   if tFileNewer and tScriptChanged then
      // changes in both file and IDE
      put xDataA["CollisionPolicy"] into tCollisionPolicy
      if tCollisionPolicy is "Ask" then
         answer warning "Changes were found in both the stack script and" \
               && xDataA["fileName"] & "." & lf & \
               "Which version should be kept?" with "Stack" or "File" or "Skip"
         put it into tCollisionPolicy
      end if
      switch tCollisionPolicy
         case "Script"
         case "Stack"
            put false into tFileNewer
            break
         case "File"
            put false into tScriptChanged
            break
         case "Skip"
            addToLog xDataA["fileName"] && \
                  "skipped - changes in file and IDE"
            exit _saveScriptFile
            break
      end switch
   end if
   
   if tFileNewer then
      put tFileHash into tProps[sDigestType]
      _removeHeader tFileScript
      try
         set the script of pObjectLongID to tFileScript
      catch tError
         addToLog "   Unable to import script... retrying in 500ms"
         send "updateRunningScriptLater pObjectLongID, tFileScript" \
               to this card in 500 milliseconds
      end try
      addToLog xDataA["fileName"] && "changed outside of IDE"
   else if tFileMissing or tScriptChanged then
      put tHash into tProps[sDigestType]
      put textEncode(tScript, "UTF-8") into URL (sFileMethod & tFullFilePath)
      addToLog xDataA["fileName"] && "exported"
   end if
   
   put _getFileSeconds(xDataA) into tProps["fileSeconds"]
   set the customProperties[sPropertySet] of pObjectLongID to tProps
   put tProps["fileSeconds"] into xDataA["files"][xDataA["fileName"]]
end _saveScriptFile


command loadScriptFile \
      pFileName,    /* file name to load         */ \
      @xDataA       /* export data array         */
   local tFileScript, tObjectLongID, tObjectLongName, tOffset
   local tStackName
   
   put textDecode(line 1 to 8 of URL ("file:" & pFileName), "UTF-8") \
         into tFileScript
   
   put offset("# Name:",tFileScript)+7 into tOffset
   delete char 1 to tOffset of tFileScript
   put line 1 of tFileScript into tObjectLongName
   put offset("# ID:",tFileScript)+5 into tOffset
   delete char 1 to tOffset of tFileScript
   put line 1 of tFileScript into tObjectLongID
   
   if not exists(tObjectLongID) then
      addToLog "File not valid:" && pFileName & lf \
            & tObjectLongID && "does not exist."
      exit loadScriptFile
   end if
   if sDigestType is empty then initializePrefs
   
   // pull tStackName from long ID
   if word -5 of tObjectLongID is "stack" then
      put char 2 to -2 of word -4 of tObjectLongID into tStackName
   else
      put char 2 to -2 of word -1 of tObjectLongID into tStackName
   end if
   
   _saveScriptFile tStackName, xDataA, tObjectLongID, tObjectLongName
end loadScriptFile


command editScriptFile \
      pObjectLongID, /* file name to load         */ \
      @xDataA        /* export data array         */
   local tBackgroundCheck, tEditor, tFullFilePath, tObjectLongName
   local tResult, tStackName
   
   // verify that mainstack is being tracked
   put the short name of (word -2 to -1 of pObjectLongID) into tStackName
   if tStackName is not xDataA["mainstack"] then
      return "pass"
   end if
   
   // check to see if object is actually in a substack
   if word -5 of pObjectLongID is "stack" then
      put char 2 to -2 of word -4 of pObjectLongID into tStackName
      put -13 into tBackgroundCheck
   else
      put -10 into tBackgroundCheck
   end if
   
   // ensure group-editing mode is disabled
   // object long IDs are not properly returned if enabled
   try
      set the editBackground of stack tStackName to false
   end try
   
   // shorten mainstack name
   put the long id of pObjectLongID into pObjectLongID
   put the long name of pObjectLongID into tObjectLongName
   put _q(xDataA["mainstack"]) into word -1 of pObjectLongID
   put _q(xDataA["mainstack"]) into word -1 of tObjectLongName
   
   // shared group check
   if word tBackgroundCheck of pObjectLongID is "group" and \
         word (tBackgroundCheck + 2) of pObjectLongID is among the lines of \
         xDataA[tStackName]["sharedGroupIDs"] then
      put "bkgnd" into word tBackgroundCheck of pObjectLongID
      delete word (tBackgroundCheck + 3) to (tBackgroundCheck + 6) of pObjectLongID
      delete char offset("of card",tObjectLongName) to \
            offset("of stack",tObjectLongName) - 1 of tObjectLongName
      if word tBackgroundCheck + 4 of tObjectLongName is "group" then
         put "bkgnd" into word tBackgroundCheck + 4 of tObjectLongName
      else
         put "bkgnd" into word tBackgroundCheck + 5 of tObjectLongName
      end if
   end if
   
   // ensure the script contains something to generate a file
   if the script of pObjectLongID is empty then
      set the script of pObjectLongID to "# new script starts here..."
   end if
   
   // ensure file contains the latest version of the script
   _saveScriptFile tStackName, xDataA, pObjectLongID, tObjectLongName
   
   // try to open in external editor
   put getPref("Editor") into tEditor
   if tEditor is not empty then
      put xDataA["ExportPath"] & xDataA["fileName"] into tFullFilePath
      launch tFullFilePath with tEditor
      put the result into tResult
      if tResult is not empty and tResult is not tEditor then
         addToLog "Error opening" && xDataA["fileName"] && "with" && \
               tEditor & ":" && tResult
         return "pass"
      end if
   end if
end editScriptFile


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
      pStackName,     /* stack short name          */ \
      @xDataA,        /* export data array         */ \
      pObjectLongID,  /* long ID of control        */ \
      pObjectLongName /* long name of control      */
   local tBehavior, tFileName, tHeader, tIndex, tScript
   
   if pObjectLongID is empty then return empty
   
   if (the script of pObjectLongID is not empty) then
      put the script of pObjectLongID into tScript
   end if
   if (the behavior of pObjectLongID is not empty) then
      put "# Behavior:" && the behavior of pObjectLongID & lf into tBehavior
   end if
   // add behavior indexing here
   if tScript is empty then
      return empty
   end if
   
   // generate file name
   put "stack_" & replaceText(pStackName, space, "_") & "_" into tFileName
   if word 1 of pObjectLongID is not "stack" then
      put replaceText(word 1 to 3 of pObjectLongID, space, "_") after tFileName
   end if
   put tFileName & ".livecodescript" into xDataA["fileName"]
   
   // build file header
   put "Script" && _q(tFileName) & lf & lf into tHeader
   put "/*" & lf after tHeader
   put "# Name:" && pObjectLongName & lf after tHeader
   put "# ID:" && pObjectLongID & lf after tHeader
   if word 1 of pObjectLongID is "widget" then
      put "# Widget Kind:" && the kind of pObjectLongID & lf after tHeader
   end if
   put tBehavior after tHeader
   put _groupComment(pStackName, xDataA, pObjectLongID) after tHeader
   put "*/" & lf after tHeader
   
   // build script index entry from header
   put line 4 to -2 of tHeader into tIndex
   put "**" after line 1 of tIndex
   replace "# Name: " with "**" in tIndex
   replace lf & "#" with lf & "*" in tIndex
   put lf & "* [" & tFileName & "](./" & xDataA["ExportFolder"] & \
         "/" & xDataA["fileName"] & ")" & lf & lf after tIndex
   put tIndex after url (sFileMethod & xDataA["ExportPath"] & "../" & \
         xDataA["stackFileName"] & ".md")
   
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
   
   put files(xDataA["ExportPath"], "detailed") into tFileList
   filter tFileList with xDataA["fileName"] & "*"
   return item 5 of line 1 of tFileList
end _getFileSeconds


private function _longName pObjectLongID, pParentLongName
   return the abbreviated name of pObjectLongID && "of" && pParentLongName
end _longName


function _q pText
   return quote & pText & quote
end _q


on mouseup
   // enable easy access to this script from the behavior button
   edit script of me
end mouseup
