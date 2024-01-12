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
@REM Dynamically link UCRT (excluding VCRUNTIME) since it is included with Windows 10+.
@REM Benefit: smaller exe size (179 KiB to 30 KiB)
@REM See https://users.rust-lang.org/t/static-vcruntime-distribute-windows-msvc-binaries-without-needing-to-deploy-vcruntime-dll/57599
@REM and https://www.google.com/search?q=%22%2FDEFAULTLIB%3Aucrt.lib%22+%22%2FNODEFAULTLIB%3Alibucrt.lib%22&newwindow=1
cl /O2 /utf-8 /Brepro xtract.c libarchive\lib\archive.lib /link setargv.obj manifest.res /DEFAULTLIB:ucrt.lib /NODEFAULTLIB:libucrt.lib /Brepro
@REM mt -manifest manifest.xml -outputresource:xtract.exe;1
@echo.
@endlocal
@popd
