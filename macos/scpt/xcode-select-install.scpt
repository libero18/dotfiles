-- See: https://gist.github.com/chuckg/4a83fe0f37a3d8c69044
-- See current: sudo sqlite3 /Library/Application\ Support/com.apple.TCC/TCC.db "SELECT * from access"
-- Reset all: tccutil reset Accessibility

 
-- Allow assistive device access for this app.
do shell script "sudo sqlite3 /Library/Application\\ Support/com.apple.TCC/TCC.db \"INSERT or REPLACE INTO access VALUES('kTCCServiceAccessibility','com.apple.Terminal',0,1,1,NULL)\"" with administrator privileges
do shell script "sudo sqlite3 /Library/Application\\ Support/com.apple.TCC/TCC.db \"INSERT or REPLACE INTO access VALUES('kTCCServiceAccessibility','com.googlecode.iterm2',0,1,1,NULL)\"" with administrator privileges
do shell script "sudo sqlite3 /Library/Application\\ Support/com.apple.TCC/TCC.db \"INSERT or REPLACE INTO access VALUES('kTCCServiceAccessibility','com.apple.ScriptEditor.id.xcode-select-install',0,1,1,NULL)\"" with administrator privileges

 
do shell script "xcode-select --install"
do shell script "sleep 1"
 
tell application "System Events"
  tell process "Install Command Line Developer Tools"
    keystroke return
    delay 5
--    click button "Agree" of window "License Agreement"
    click button "同意する" of window "使用許諾契約"
  end tell
end tell

 
-- Remove assistive device access for this app.
-- do shell script "sudo sqlite3 /Library/Application\\ Support/com.apple.TCC/TCC.db \"DELETE from access where client='com.apple.Terminal'\"" with administrator privileges
-- do shell script "sudo sqlite3 /Library/Application\\ Support/com.apple.TCC/TCC.db \"DELETE from access where client='com.googlecode.iterm2'\"" with administrator privileges
-- do shell script "sudo sqlite3 /Library/Application\\ Support/com.apple.TCC/TCC.db \"DELETE from access where client='com.apple.ScriptEditor.id.xcode-select-install'\"" with administrator privileges

