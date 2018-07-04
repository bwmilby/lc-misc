Script "stack_WebDocMaker_button_id_1004"

/*
# Name: button "Copy HTML/CSS/JS Files" of card id 1002 of stack "WebDocMaker"
# ID: button id 1004 of card id 1002 of stack "WebDocMaker"
*/


on mouseUp
   local tDestPath, tDocumentationPath, tSourcePath, tTemplate, tFileRelativePath
   local tDocsCSSFolder, tDocsJSFolder, tDataPath
   local tIDEGuidesFolder, tRepoGuidesFolder

   set the itemdel to "/"
   put item 1 to -2 of the filename of this stack into tDestPath

   put revIDESpecialFolderPath("documentation") into tDocumentationPath
   revCopyFolder tDocumentationPath & slash & "guides", tDestPath

   put tDocumentationPath & slash & "html_viewer" into tSourcePath
   revCopyFolder tSourcePath & slash & "css", tDestPath
   revCopyFolder tSourcePath & slash & "fonts", tDestPath
   revCopyFolder tSourcePath & slash & "js", tDestPath
   create folder tDestPath & slash & "resources"
   revCopyFolder tSourcePath & slash & "resources" & slash & "media", \
         tDestPath & slash & "resources"

   set the itemdel to comma
   repeat for each item tProduct in "commercial,community,communityplus,professional"
      put "/resources/" & tProduct & "/ideSkin/bubble.png" into tFileRelativePath
      create folder tDestPath & slash & "resources" & slash & tProduct
      create folder tDestPath & slash & "resources" & slash & tProduct & slash & "ideSkin"
      revCopyFile tDocumentationPath & "/../Toolset" & tFileRelativePath, \
            tDestPath & tFileRelativePath
   end repeat

   put "." & slash & "css" into tDocsCSSFolder
   put "." & slash & "js" into tDocsJSFolder
   put "." & slash & "guides" into tIDEGuidesFolder
   put revIDESpecialFolderPath("repo guides") into tRepoGuidesFolder

   # create API HTML file
   put url ("binfile:" & tSourcePath & slash & "api.html.template") into tTemplate
   put "." & slash & "built_api.js" into tDataPath
   put merge(tTemplate) into tTemplate
   put tTemplate into url ("binfile:" & tDestPath & slash & "api.html")

   # create Guide HTML file
   put url ("binfile:" & tSourcePath & slash & "guide.html.template") into tTemplate
   put "." & slash & "built_guide.js" into tDataPath
   put merge(tTemplate) into tTemplate
   put tTemplate into url ("binfile:" & tDestPath & slash & "guide.html")

   # update paths in lcdoc.css file
   put url ("binfile:" & tDestPath & "/css/lcdoc.css") into tTemplate
   replace "../../../Toolset/" with "../" in tTemplate
   put tTemplate into url ("binfile:" & tDestPath & "/css/lcdoc.css")
end mouseUp
