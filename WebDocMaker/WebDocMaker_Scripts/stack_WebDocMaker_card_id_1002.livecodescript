Script "stack_WebDocMaker_card_id_1002"

/*
# Name: card id 1002 of stack "WebDocMaker"
# ID: card id 1002 of stack "WebDocMaker"
*/


on test
   put revIDESpecialFolderPath("api")
   put revIDESpecialFolderPath("guide")
   put revIDESpecialFolderPath("documentation")
   
   local tDestPath
   set the itemdel to "/"
   put item 1 to -2 of the filename of this stack into tDestPath
   
   local tSourcePath
   put revIDESpecialFolderPath("documentation cache") into tSourcePath
   
end test
