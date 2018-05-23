Script "stack_SignVerify_button_id_1013"

/*
# Name: button "ValidateSignature" of card id 1002 of stack "SignVerify"
# ID: button id 1013 of card id 1002 of stack "SignVerify"
*/


on mouseUp
   local tFile, tHash, tKey
   
   put field "FileToSign" into tFile
   if there is not a file tFile then
      answer "File does not exist."
      exit mouseUp
   end if
   
   put url ("binfile:" & field "PublicKeyFile") into tKey
   if tKey is empty then
      answer "Public key not found."
      exit mouseUp
   end if
   
   put base64Decode(field "Signature") into tHash
   decrypt tHash using rsa with public key tKey
   if it is messageDigest(url ("binfile:"&tFile), "SHA3-256") then
      answer "The signature matches, file has not changed."
   else
      answer "The signature does not match."
   end if
end mouseUp
