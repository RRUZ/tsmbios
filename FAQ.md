Q : What's means the number in the remarks section of the documentation of the source code ?


```
   TCacheInfo = packed record
    Header: TSmBiosTableHeader;
    {$REGION 'Documentation'}
    ///	<summary>
    ///	  String Number for Reference Designation EXAMPLE: CACHE1, 0
    ///	</summary>
    ///	<remarks>
    ///	  2.0+
    ///	</remarks>
    {$ENDREGION}
    SocketDesignation: Byte;
```


A: The number in the remarks section indicates the SMBIOS version where the property was introduced.