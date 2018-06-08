Script "stack_PasswordDemo_button_id_1016"

/*
# Name: button "Change PW" of card id 1002 of stack "PasswordDemo"
# ID: button id 1016 of card id 1002 of stack "PasswordDemo"
*/


on mouseUp
   local tAccountInfo, tAccounts, tCheckHash, tCorrectHash, tHash
   local tNewPassword, tPassword, tSalt, tUserName
   
   // first ensure that the new passwords math
   put field "NewPassword1" into tNewPassword
   if tNewPassword is not field "NewPassword2" then
      put "Passwords do not match" into field "Status"
      exit mouseUp
   end if
   
   put field "UserName" into tUserName
   put field "Password" into tPassword
   
   // next make sure the account exists
   filter the text of field "Accounts" with (tUserName & tab & "*") into tAccountInfo
   if tAccountInfo is empty then
      put "Account does not exist" into field "Status"
      exit mouseUp
   end if
   
   // need to verify the old password matches next
   set the itemdel to tab
   put base64decode(item 2 of tAccountInfo) into tSalt
   put base64decode(item 3 of tAccountInfo) into tCorrectHash
   
   put md5digest( tSalt & md5digest( tSalt & tPassword )) into tCheckHash
   
   if tCorrectHash is not tCheckHash then
      put "Old password incorrect" into field "Status"
      exit mouseUp
   end if
   
   // store the new password
   filter the text of field "Accounts" without (tUserName & tab & "*") into tAccounts
   put randombytes(8) into tSalt
   put md5digest( tSalt & md5digest( tSalt & tNewPassword )) into tHash
   put tUserName & tab & base64encode(tSalt) & tab & base64encode(tHash) & lf \
         after tAccounts
   set the text of field "Accounts" to tAccounts
   
   put "Password changed" into field "Status"
end mouseUp
