Script "stack_SignVerify_button_id_1011"

/*
# Name: button "GenerateSignature" of card id 1002 of stack "SignVerify"
# ID: button id 1011 of card id 1002 of stack "SignVerify"
*/


on mouseUp
   local tFile, tHash, tKey
   
   put field "FileToSign" into tFile
   if there is not a file tFile then
      answer "File does not exist."
      exit mouseUp
   end if
   
   put url ("binfile:" & field "PrivateKeyFile") into tKey
   if tKey is empty then
      answer "Private key not found."
      exit mouseUp
   end if
   
   put messageDigest(url ("binfile:"&tFile), "SHA3-256") into tHash
   encrypt tHash using rsa with private key tKey
   put base64Encode(it) into field "Signature"
end mouseUp
