Script "stack_PasswordDemo_button_id_1009"

/*
# Name: button "Add Account" of card id 1002 of stack "PasswordDemo"
# ID: button id 1009 of card id 1002 of stack "PasswordDemo"
*/


on mouseUp
   local tAccountInfo, tHash, tPassword, tSalt, tUserName
   
   put field "UserName" into tUserName
   put field "Password" into tPassword
   
   // check to see if the account already exists
   filter the text of field "Accounts" with (tUserName & tab & "*") into tAccountInfo
   if tAccountInfo is not empty then
      put "User name" && tUserName && "already exists." into field "Status"
      exit MouseUp
   end if
   
   // generate a random salt value for each password
   // this is stored with the hash in the database
   put randombytes(8) into tSalt
   
   // generate the password hash using the salt
   put md5digest( tSalt & md5digest( tSalt & tPassword )) into tHash
   
   // store the new user with the salt and hash in the database
   put tUserName & tab & base64encode(tSalt) & tab & base64encode(tHash) & lf \
         after field "Accounts"
   
   put "User" && tUserName && "added" into field "Status"
end mouseUp
