-- See: https://github.com/k0kubun/rebuild/blob/master/script/click_done.scpt
-- Click Done Button
set timeoutSeconds to 8.0
my doWithTimeout("click UI Element \"完了\" of window 1 of application process \"Install Command Line Developer Tools\"", timeoutSeconds)

on doWithTimeout(uiScript, timeoutSeconds)
  set endDate to (current date) + timeoutSeconds
  repeat
    try
      run script "tell application \"System Events\"
" & uiScript & "
end tell"
      exit repeat
    on error errorMessage
      if ((current date) > endDate) then
        error errorMessage & "; Can not " & uiScript
      end if
    end try
  end repeat
end doWithTimeout
