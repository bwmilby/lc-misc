# Script Tracker

The goal of this tool is to expose the scripts of a binary stack in a 
fashion that allows them to be tracked via a version control system like 
GitHub. This repo contains the output of the stack. Even though GitHub 
can't provide useful information about the changes in binary files, each 
time I perform a commit I include the corresponding binary stack. This 
allows easy download of the stack for use but also puts the scripts in a 
convenient place for review online.

Each script in the stack is exported as a valid `.livecodescript` file, 
but the stack is not modified to make it a behavior. A custom property 
set is created for each object to track a hash of the script and the 
modification date/time of the exported file. On each sync, those 
properties are used to determine if the script needs to be exported or 
if the file needs to be imported. Whenever a script changes, a diff file 
is created that contains all of the changes in that particular sync 
operation. If a file is no longer needed (i.e. the script was removed), 
then the extra files are moved to a separate directory and renamed to 
ensure no name collisions. I have a .gitignore file configured to skip 
those files when considering changes.

The stack features an automatic import feature which watches the script 
directory looking for files that change. If a file changes, then a sync 
is performed on that individual file (presumably importing some changes). 
There is a stack level preference to allow a choice of how to handle the 
situation when a change is detected in both the script and the file 
(*stack* {keep stack script/overwrite file}, *file* {import file}, *ask* 
{present options in a dialog}, *skip* {keep stack script, but do not 
update the hash nor overwrite the file}).

If automatic import is enabled, there is also an option to have scripts 
opened in an external editor. When enabled, whenever the IDE wants to 
edit a script it will also get opened in the chosen external editor. If 
an object doesn't have a script yet, then a temporary comment is added 
to create a file for editing.

There is an option is to have a sync performed before saving the stack 
file. This is done with a front script that intercepts the 
_SaveStackRequest_ message to initiate the sync if required.

The system is designed to be non-destructive, so the way to completely 
remove a file is to clear the script in the IDE and perform a sync. 
Deleting a file from the operating system and performing a sync will 
just regenerate the file. If you remove everything after the header, the 
file will get removed on the second sync (the first will import the 
blank script into the IDE, but not remove the file).

The stack currently handles a single mainstack at one time. There is a 
drop down menu with all non-IDE mainstacks to quickly switch between 
different ones. Mode 0 stacks are not included in the list. The alt key
can be used to add IDE stacks to the menu. Mode 0 stacks can be 
specified by typing the stack name in the field.

The Prefs substack provides all of the options available for the 
currently tracked stack and the Script Tracker overall. Changes are 
saved when the tab is changed or the window is closed. The overall 
preferences are saved in the same location as the LiveCode prefs (but in 
a separate file). Stack level preferences are stored in each mainstack 
as a custom property set.

* **Script Tracker**:  Options to sync on save and to use external editor.
* **Options**:  Export method (binfile/file), digest type (MD5/SHA-1), diff
context lines, custom property set name
* **Defaults**:  Initial settings when tracking a stack for the first time.
Paths are relative to the mainstack file.
* **Stack**:  Settings for the stack currently being tracked.  If the locations
are changed, new locations will be used on the next sync operation.

The Log will provide the time taken for an export and list each file 
that was touched. Some error messages will get displayed there.

## Forum Announcement

https://forums.livecode.com/viewtopic.php?f=77&t=31079

## Script Index

[ScriptTracker.md](./ScriptTracker.md)
