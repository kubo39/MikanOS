import uefi;

extern (C) EFI_STATUS EfiMain(EFI_HANDLE ImageHandle, EFI_SYSTEM_TABLE* SystemTable) @nogc nothrow
{
    SystemTable.ConOut.OutputString(SystemTable.ConOut, (cast(wchar[]) "Hello, World!\n"w).ptr);
    while (true) {}
    return EFI_SUCCESS;
}
