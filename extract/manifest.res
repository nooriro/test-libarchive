        ��  ��                  �      �� ��     0           <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<assembly xmlns="urn:schemas-microsoft-com:asm.v1" manifestVersion="1.0">
  <!-- Visual Style -->
  <dependency>
    <dependentAssembly>
      <assemblyIdentity type="win32"
                        name="Microsoft.Windows.Common-Controls"
                        version="6.0.0.0"
                        processorArchitecture="*"
                        publicKeyToken="6595b64144ccf1df"
                        language="*" />
    </dependentAssembly>
  </dependency>
  <!-- end of Visual Style -->
  <application xmlns="urn:schemas-microsoft-com:asm.v3">
    <windowsSettings>
      <!-- HiDPI -->
      <dpiAware xmlns="http://schemas.microsoft.com/SMI/2005/WindowsSettings">true/pm</dpiAware>
      <dpiAwareness xmlns="http://schemas.microsoft.com/SMI/2016/WindowsSettings">PerMonitorV2</dpiAwareness>
      <!-- Set the process's ACP("ANSI" code page) and OEMCP("OEM" code page) to 65001(CP_UTF8)
           Only works on Windows 10 Version 1903 (aka 19H1, 18362, May 2019 Update) or higher
           NOTE: This setting DOES NOT AFFECT ConsoleCP and ConsoleOutputCP
           See https://entropymine.wordpress.com/2023/03/25/win32-i-o-character-encoding-supplement-3-utf-8-manifest/ and others -->
      <activeCodePage xmlns="http://schemas.microsoft.com/SMI/2019/WindowsSettings">UTF-8</activeCodePage> 
    </windowsSettings>
  </application>
</assembly>
 