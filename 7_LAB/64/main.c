#include <stdio.h>

size_t Strlen(const char *s)
{
    size_t len = 0;
    __asm {
        mov RDI, s
        xor AL, al 
        mov RCX, -1 
        cld
        repne scasb

        not RCX 
        dec RCX
        mov len, RCX
    }
    return len;
}

extern void Strcpy(char *dst, const char *src, size_t len);

int main()
{
    char tmp[30] = {0};
    char test_len[] = "Hello, World!";
    int len = Strlen(test_len);
    printf("Length of the string: %d\n", len);

    printf("Copied string: %s\n", tmp);
    Strcpy(tmp, test_len, len + 1);
    printf("Copied string: %s\n", tmp);

    return 0;
}
