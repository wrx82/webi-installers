@echo off
pushd "%userprofile%" || goto :error
  IF NOT EXIST .local (
    mkdir .local || goto :error
  )
  IF NOT EXIST .local\bin (
    mkdir .local\bin || goto :error
  )
  IF NOT EXIST .local\opt (
    mkdir .local\opt || goto :error
  )

  pushd .local\bin || goto :error
    if NOT EXIST pathman.exe (
      echo updating PATH management
      powershell $ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest https://webinstall.dev/packages/pathman/pathman.bat -OutFile pathman-setup.bat || goto :error
      call .\pathman-setup.bat || goto :error
      del pathman-setup.bat  || goto :error
      rem TODO there's rumor of a windows tool called 'pathman' that does the same thing?
    )
  popd || goto :error
  .\.local\bin\pathman add ".local\bin" || goto :error

  echo downloading and installing %1
  powershell $ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest https://webinstall.dev/packages/%1/%1.bat -OutFile %1-webinstall.bat || goto :error

  rem TODO only add if it's not in there already
  PATH .local\bin;%PATH%

  call %1-webinstall.bat || goto :error
  del %1-webinstall.bat || goto :error
popd

goto :EOF

:error
echo Failed with error #%errorlevel%.
exit /b %errorlevel%
