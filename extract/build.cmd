@pushd %~dp0
@setlocal
@for %%x in (
    "%ProgramFiles(x86)%\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat"
    "%ProgramFiles%\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"
    "%ProgramFiles%\Microsoft Visual Studio\2022\Professional\VC\Auxiliary\Build\vcvars64.bat"
    "%ProgramFiles%\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvars64.bat"
) do @if exist %%x set "VCVARS64=%%x" & goto :found
@>&2 echo Please install Visual Studio Build Tools 2022 or Visual Studio 2022
@>&2 echo and run this again.
@endlocal
@popd
@exit /b 1
:found
call %VCVARS64% x64 & echo on
@REM To use UTF-8 argv and UTF-8 win32 apis, activeCodePage manifest is needed.
rc manifest.rc
cl /O2 /Ob2 /utf-8 xtract.c libarchive\lib\archive.lib /link setargv.obj manifest.res /Brepro
@REM mt -manifest manifest.xml -outputresource:xtract.exe;1
@echo.
@endlocal
@popd
