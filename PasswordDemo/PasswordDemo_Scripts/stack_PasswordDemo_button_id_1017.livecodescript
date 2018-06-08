Script "stack_PasswordDemo_button_id_1017"

/*
# Name: button "Login" of card id 1002 of stack "PasswordDemo"
# ID: button id 1017 of card id 1002 of stack "PasswordDemo"
*/


on mouseUp
   local tAccountInfo, tCheckHash, tCorrectHash, tPassword, tSalt
   local tUserName
   
   put field "UserName" into tUserName
   put field "Password" into tPassword
   
   // make sure the account exists
   // in production, probably would not report this separately
   filter the text of field "Accounts" with (tUserName & tab & "*") into tAccountInfo
   if tAccountInfo is empty then
      put "Account does not exist" into field "Status"
      exit mouseUp
   end if
   
   // pull the correct hash and salt from the database
   set the itemdel to tab
   put base64decode(item 2 of tAccountInfo) into tSalt
   put base64decode(item 3 of tAccountInfo) into tCorrectHash
   
   // generate the hash from the provided password
   put md5digest( tSalt & md5digest( tSalt & tPassword )) into tCheckHash
   
   // check that they match
   if tCorrectHash is tCheckHash then
      put "Login success" into field "Status"
   else
      put "Incorrect login" into field "Status"
   end if
end mouseUp
