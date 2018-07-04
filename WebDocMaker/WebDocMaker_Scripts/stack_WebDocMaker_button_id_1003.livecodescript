Script "stack_WebDocMaker_button_id_1003"

/*
# Name: button "Copy Dictionary Data" of card id 1002 of stack "WebDocMaker"
# ID: button id 1003 of card id 1002 of stack "WebDocMaker"
*/


on mouseUp
   local tDestPath, tSourcePath
   
   set the itemdel to "/"
   put item 1 to -2 of the filename of this stack into tDestPath
   
   put revIDESpecialFolderPath("documentation cache") into tSourcePath
   
   revDeleteFile tDestPath & slash & "built_api.js"
   revDeleteFile tDestPath & slash & "built_guide.js"
   
   revCopyFile tSourcePath & slash & "built_api.js", tDestPath
   revCopyFile tSourcePath & slash & "built_guide.js", tDestPath
end mouseUp
