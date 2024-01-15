@pushd %~dp0
@REM @if exist filetime_test.7z del filetime_test.7z
@"%ProgramFiles%\7-Zip\7z.exe" a filetime_test.7z filetime_test_?.txt
@popd
