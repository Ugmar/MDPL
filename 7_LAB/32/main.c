#include <stdio.h>

int Strlen(const char *s)
{
    __asm {
        mov EDI, s
        xor AL, AL
        mov ECX, 0
        dec ECX

        cld
        repne scasb

        not ECX
        dec ECX
        mov EAX, ECX
    }
}

void Strcpy(char *dst, char *src, int len);

int main(void)
{
    char test_len[] = "Hello, World!";
    int len = Strlen(test_len);
    printf("Length of the string: %d\n", len);

    char tmp[30];
    Strcpy(tmp, test_len, len + 1);
    printf("Copied string: %s\n", tmp);

    return 0;
}
