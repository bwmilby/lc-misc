Script "stack_SignVerify_button_id_1003"

/*
# Name: button "GererateKeys" of card id 1002 of stack "SignVerify"
# ID: button id 1003 of card id 1002 of stack "SignVerify"
*/


on mouseUp
   local tGenPrivate, tGenPublic, tPath, tPrivateFile, tPublicFile
   
   put char 2 to -2 of word -1 of the long id of me into tPath
   set the itemdel to slash
   delete item -1 of tPath
   if there is not a folder tPath then
      answer "Stack needs to be saved to a file first."
      exit mouseUp
   end if
   
   put tPath & slash & "private_key.pem" into tPrivateFile
   put tPath & slash & "public_key.pem" into tPublicFile
   
   if there is a file tPrivateFile then
      answer warning "Private file already exists.  Overwrite?" with "Yes" or "No"
      if it is "No" then exit mouseUp
   end if
   
   put "openssl genrsa -out" && tPrivateFile && "512" into tGenPrivate
   put "openssl rsa -pubout -in" && tPrivateFile && "-out" && tPublicFile into tGenPublic
   get shell(tGenPrivate)
   get shell(tGenPublic)
   
   if there is a file tPrivateFile then
      put tPrivateFile into field "PrivateKeyFile"
   end if
   if there is a file tPublicFile then
      put tPublicFile into field "PublicKeyFile"
   end if
end mouseUp
