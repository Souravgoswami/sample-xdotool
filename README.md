# sample-xdotool
Xdotool is a handy automation tool for linux. This can facilitates you clicking on a certain portion of the screen and typing out from your keyboards.

This XdoTool is a module that you can import and use for writing a quick Ruby automated system.
This uses xdotool binary under the hood, and this application is specially meant for a GNU/Linux system.

**Installation:**

  *Arch Linux:*
  
      # pacman -S xdotool
      
  *Debian/Ubuntu/Linux Mint and most of the Debian derivatives:*
  
      # apt install xdotool
      
Usage:

**Requiring xdotool.rb:**

  `require_relative 'xdotool.rb'`
  
**Getting the Display Resolution:**

  `p XdoTool.getdisplaygeometry`
  
**Getting the Mouse x and y Position:**

  `print XdoTool.getmousexy`

**Moving the Mouse (example to 5, 5):**

  `XdoTool.mousemove(x: 5, y: 5)`

  or

  `XdoTool.setmousexy(x: 5, y: 5)`


**Clicking at a Pixel:**

  `XdoTool.click(repeat: 5, delay: 0, button: 'right')`

    {:repeat => n} will click on the button n times.
    {:delay => n} will sleep n milliseconds between each clicks.
    {:button => 'left'/'middle'/'right'/'wheel up' or 'scroll up'/'wheel down' or 'scroll down'} will click the given button.

**Moving the Cursor And Clicking at a Location (example, move to 5, 5, and click):**

  `XdoTool.clickat(x: 5, y: 5, sleep: 0.1, delay: 0, button: 'left')`

    {:x => n} move the mouse to n pixel right.
    {:y => n} move the mouse to n pixel down.
    {:sleep => n} sleep for n seconds after moving the mouse but before clicking.
    {:repeat => n} will click on the button n times.
    {:delay => n} will sleep n milliseconds between each clicks.
    {:button => 'left'/'middle'/'right'/'wheel up' or 'scroll up'/'wheel down' or 'scroll down'} will click the given button.

**Hold Mouse Button:**

  `XdoTool.mousedown(button: 'left', window: n, clearmodifiers: Bool)`

        {:button => 'left'/'middle'/'right'/'wheel up' or 'scroll up'/'wheel down' or 'scroll down'} will click and hold the given  mouse button.
        {:window => n} give the window as Integer. If not given, it will use the active window.
        {:clearmodifiers => true/false} reset active modifiers (alt, etc) while typing.
        
 
**Release Mouse Button:**
 
   `XdoTool.mouseup(button: 'left', window: n, clearmodifiers: Bool)`

              {:button => 'left'/'middle'/'right'/'wheel up' or 'scroll up'/'wheel down' or 'scroll down'} will release the given mouse button.
        {:window => n} give the window as Integer. If not given, it will use the active window.
        {:clearmodifiers => true/false} reset active modifiers (alt, etc) while typing.

**Press a Key:**

   `XdoTool.keypress(repeat: n, delay: n, key: 'a-z/0-9/signs')`
    
      or
      
   `XdoTool.press(repeat: n, delay: n, key: 'a-z/0-9/signs')`
    
     Note: To send Enter or Return use "\n"
    
**Type a Text:**

   `XdoTool.type(str)`
   
     Note: Typing differs from runnign a loop and calling the keypress(key: x). It works faster, and it should work with
       any characters, and emojis.

**Hold a Key:**

   `XdoTool.keydown(repeat: n, delay: n, clearmodifiers: Bool, key: 'a-z/0-9/signs')`

**Release a Key:**

   `XdoTool.keyup(repeat: n, delay: n, clearmodifiers: Bool, key: 'a-z/0-9/signs')`
    
**Get the Active Window:**

   `puts XdoTool.getactivewindow`
    
      or
     
   `puts XdoTool.currentwindow`
    
**Minimize a Window:**

   `XdoTool.windowminimize(window=n)`
    
      If no argument is passed, it will call getactivewindow() and minimize the currently active window.
      
**Kill a Window:**

   `XdoTool.windowkill(window=n)`
    
      Beware of this. This action will destroy the window and kill the client controlling it.
        If no argument is passed, it will call the getactivewindow() and kill the currently active window.
      
**Close a Window:**

   `XdoTool.windowclose(window=n)`
    
      If no argument is passed, it will call getactivewindow() and close the currently active window.

**Raise a Window:**

   `XdoTool.windowraise(window=n)`

      If no argument is passed, it will call getactivewindow() and raise the currently active window.
      
**Select a Window:**

   `puts XdoTool.selectwindow`
  
      This will give you a cursor to select a window.
      
**Resize a Window:**

   `XdoTool.windowsize(x: n, y: n, window: n, sync: Bool, usehints: Bool)`

        or
        
   `XdoTool.windowsize(x: n, y: n, window: n, sync: Bool, usehints: Bool)`

**Move a Window:**

   `XdoTool.windowmove(x: n, y: n, window: n)`
    
      or
      
   `XdoTool.setwindowxy(x: n, y: n, window: n)`


      x, y is mandatory. If no window is passed, it will call getactivewindow() and move the currently active window.
      
**Hide a Window:**

   `XdoTool.windowunmap(window=n)`
    
      or
      
   `XdoTool.hidewindow(window=n)`
    
       Beware of this method. This method will hide a window, making it no longer appear on your screen.
        If no argument is passed, it will call getactivewindow() and hide the currently active window.
       
**Unhide a Window:**

   `XdoTool.windowmap(window=n)`
    
     or
      
   `XdoTool.unhidewindow(window=n)`
    
        This will unmap the given window. This method has no effect if your window is not already hidden.
         If no argument is passed, it will call getactivewindow() and unhide the currently active window.
         
**Get Window Name Along With The Cursor Position:**

   `puts XdoTool.getwinmousexy`
   
**Get the Name of the Focused Window:**

   `puts XdoTool.getwindowfocus`
   
**Get the Name of the Active Window:**

  `puts XdoTool.getwindowname(window=n)`
  
    If no argument is passed, this method will call getactivewindow, and print the name of the currently active window.
 
 
 Constants:
  BIN
  EXEC
  
This program requires a GNU/Linux system with xdotool installed.
