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
rc manifest.rc
cl /O2 /utf-8 /Brepro xtract.c libarchive\lib\archive.lib /link setargv.obj manifest.res /DEFAULTLIB:ucrt.lib /NODEFAULTLIB:libucrt.lib /Brepro
@echo.
@endlocal
@popd
