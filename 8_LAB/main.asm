.386
.model flat, stdcall
option casemap :none    ; отключает автоматическое преобразование регистра


include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
include \masm32\include\msvcrt.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\msvcrt.lib

; Прототипы функций
WinMain proto :DWORD, :DWORD, :DWORD, :DWORD
_errno PROTO C

.data
    ClassName db "MainCLass", 0
    AppName db "8 Лабораторная работа: Возведение в степень", 0
    ButtonClass db "button", 0
    EditClass db "edit", 0
    StaticClass db "static", 0
    
    btnText db "Вычислить", 0
    lblBaseTxt db "Основание (целое):", 0
    lblPowTxt db "Степень (натуральная):", 0

    errNotNum db "Ошибка: введено не числовое значение.", 0
    errPow db "Ошибка: Степень должна быть натуральным числом (>0)", 0
    errOverflow db "Ошибка: переполнениея", 0
    resTitle db "Результат", 0

    formatStr db "Результат: %d", 0
    endPtr  dd 0

.data?  ; bss секция
    hInstance HINSTANCE ?
    hwndBase HWND ?
    hwndPow HWND ?
    hwndBtn HWND ?
    bufferBase db 128 dup(?)
    bufferPow db 128 dup(?)
    bufferRes db 128 dup(?)

.const
    IDC_BTN equ 101
    IDC_BASE equ 102
    IDC_POW equ 103
    ERANGE equ 34

.code
start:
    ; Получаем дескриптор приложения
    invoke GetModuleHandle, NULL
    mov hInstance, eax
    ; Запускаем главный цикл
    invoke WinMain, hInstance, NULL, NULL, SW_SHOWDEFAULT
    invoke ExitProcess, eax

WinMain proc hInst:HINSTANCE, hPrevInst:HINSTANCE, CmdLine:LPSTR, CmdShow:DWORD
    LOCAL wc:WNDCLASSEX
    LOCAL msg:MSG
    LOCAL hwnd:HWND

    ; Регистрация класса окна
    mov wc.cbSize, SIZEOF WNDCLASSEX
    mov wc.style, CS_HREDRAW or CS_VREDRAW
    mov wc.lpfnWndProc, OFFSET WndProc
    mov wc.cbClsExtra, 0
    mov wc.cbWndExtra, 0
    push hInstance
    pop wc.hInstance
    mov wc.hbrBackground, COLOR_BTNFACE + 1
    mov wc.lpszMenuName, NULL
    mov wc.lpszClassName, OFFSET ClassName
    invoke LoadIcon, NULL, IDI_APPLICATION
    mov wc.hIcon, eax
    mov wc.hIconSm, eax
    invoke LoadCursor, NULL, IDC_ARROW
    mov wc.hCursor, eax
    invoke RegisterClassEx, addr wc

    ; Создание главного окна
    invoke CreateWindowEx, WS_EX_CLIENTEDGE, addr ClassName, addr AppName, \
           WS_OVERLAPPED or WS_CAPTION or WS_SYSMENU or WS_MINIMIZEBOX, \
           CW_USEDEFAULT, CW_USEDEFAULT, 500, 300, NULL, NULL, hInst, NULL
    mov hwnd, eax

    invoke ShowWindow, hwnd, SW_SHOWNORMAL
    invoke UpdateWindow, hwnd

    .while TRUE
        invoke GetMessage, addr msg, NULL, 0, 0
        .break .if (!eax)
        invoke TranslateMessage, addr msg
        invoke DispatchMessage, addr msg
    .endw

    mov eax, msg.wParam
    ret
WinMain endp

WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
        .if uMsg == WM_CREATE
         invoke CreateWindowEx, 0, addr StaticClass, addr lblBaseTxt, \
             WS_CHILD or WS_VISIBLE, 20, 20, 160, 20, hWnd, 0, hInstance, NULL
         invoke CreateWindowEx, 0, addr StaticClass, addr lblPowTxt, \
             WS_CHILD or WS_VISIBLE, 20, 60, 160, 20, hWnd, 0, hInstance, NULL

         invoke CreateWindowEx, WS_EX_CLIENTEDGE, addr EditClass, NULL, \
             WS_CHILD or WS_VISIBLE or WS_BORDER or ES_AUTOHSCROLL, \
             280, 20, 100, 20, hWnd, IDC_BASE, hInstance, NULL
         mov hwndBase, eax

         invoke CreateWindowEx, WS_EX_CLIENTEDGE, addr EditClass, NULL, \
             WS_CHILD or WS_VISIBLE or WS_BORDER or ES_AUTOHSCROLL, \
             280, 60, 100, 20, hWnd, IDC_POW, hInstance, NULL
         mov hwndPow, eax

         invoke CreateWindowEx, 0, addr ButtonClass, addr btnText, \
             WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON, \
             150, 110, 120, 30, hWnd, IDC_BTN, hInstance, NULL
         mov hwndBtn, eax

    .elseif uMsg == WM_COMMAND
        mov eax, wParam
        .if ax == IDC_BTN
            invoke GetWindowText, hwndBase, addr bufferBase, sizeof bufferBase
            invoke GetWindowText, hwndPow, addr bufferPow, sizeof bufferPow

            invoke _errno
            mov dword ptr [eax], 0
            invoke crt_strtol, addr bufferBase, addr endPtr, 10
            
            push eax

            invoke _errno
            mov ecx, [eax]
            .if ecx != 0
                pop eax
                jmp overflow_error
            .endif

            mov esi, [endPtr]
            .if esi == OFFSET bufferBase || byte ptr [esi] != 0
                pop eax
                jmp invalid_input_notnum
            .endif

            invoke _errno
            mov dword ptr [eax], 0

            lea edi, bufferPow
            cmp byte ptr [edi], '-'
            je invalid_input

            invoke crt_strtoul, addr bufferPow, addr endPtr, 10
            
            .if eax == 0
                pop eax
                jmp invalid_input
            .endif
            
            push eax

            invoke _errno
            mov ecx, [eax]
            .if ecx != 0
                pop eax
                pop eax
                jmp overflow_error
            .endif

            mov esi, [endPtr]
            .if esi == OFFSET bufferPow || byte ptr [esi] != 0
                pop eax
                pop eax
                jmp invalid_input_notnum
            .endif

            pop edx
            pop ebx

            mov eax, 1
        calc_loop:
            imul eax, ebx
            jo overflow_error
            dec edx
            jnz calc_loop

            ; Форматирование результата в строку
            invoke crt_sprintf, addr bufferRes, addr formatStr, eax
            
            invoke MessageBox, hWnd, addr bufferRes, addr resTitle, MB_OK or MB_ICONINFORMATION
            jmp done_cmd

        invalid_input_notnum:
            invoke MessageBox, hWnd, addr errNotNum, addr resTitle, MB_OK or MB_ICONERROR
            jmp done_cmd

        invalid_input:
            invoke MessageBox, hWnd, addr errPow, addr resTitle, MB_OK or MB_ICONERROR
            jmp done_cmd

        overflow_error:
            invoke MessageBox, hWnd, addr errOverflow, addr resTitle, MB_OK or MB_ICONERROR
            jmp done_cmd

        done_cmd:
        .endif

    .elseif uMsg == WM_DESTROY
        invoke PostQuitMessage, 0
    .else
        invoke DefWindowProc, hWnd, uMsg, wParam, lParam
        ret
    .endif
    xor eax, eax
    ret
WndProc endp
end start
