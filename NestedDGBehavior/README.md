# Nested Data Grid Behavior Demo

This sample stack will replace a function in the Data Grid Library with
one that will support having a user behavior script placed between the
Data Grid group and the library.  This will allow adjustment of the
handlers for a specific data grid instead of attaching it to the end of
the chain where it would impact all data grids in the application.

![Stack Image](./nestedDgBehavior.png)

In the stack pictured above, the `InlineDGBehavior` button script is
placed between the data grid on the left and the library code.  All it
currently does is place a `doubleMouseUp` handler that displays some
information in the message box.

The updated function is displayed in the text field.  That is the actual
code that is inserted into the library when the stack opens.  The code
is only available until LiveCode is quit since IDE stacks are not saved.

The `Show DG Script` button will open the library script to the position
where the code was inserted.

Here's the thread where this idea originated:
https://www.mail-archive.com/use-livecode@lists.runrev.com/msg95868.html

PR submitted to include a fix in the production version of the IDE:
https://github.com/livecode/livecode-ide/pull/1987

## Stack Scripts

[Stack Script](./NestedDGBehavior_Scripts/stack_NestedDGBehavior_.livecodescript)

["InlineDGBehavior" Script](./NestedDGBehavior_Scripts/stack_NestedDGBehavior_button_id_1047.livecodescript)

["Show DG Script" Script](./NestedDGBehavior_Scripts/stack_NestedDGBehavior_button_id_1048.livecodescript)