#include <stdio.h>
#include <stddef.h>

size_t asm_strlen(const char* str) {
    size_t length = 0;

    __asm__ __volatile__(
        "mov x0, %[str]\n\t"
        "mov x1, #0\n\t"
        
        "1:\n\t"
        "ldrb w2, [x0], #1\n\t"
        "cbz w2, 2f\n\t"
        "add x1, x1, #1\n\t"
        "b 1b\n\t"
        
        "2:\n\t"
        "mov %[length], x1\n\t" 
        
        : [length] "=r" (length)
        : [str] "r" (str)
        : "x0", "x1", "w2", "cc", "memory"
    );

    return length;
}

int main(void) {
    const char* my_string = "Hello world!";
    
    printf("String: %s \n", my_string);
    printf("Length: %zu bytes\n", asm_strlen(my_string));
    
    return 0;
}

