#include <stdio.h>
#include <time.h>

static long long now_us(void) {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (long long)ts.tv_sec * 1000000LL + ts.tv_nsec / 1000;
}

void benchmark(const char* label, void (*func)()) {
    const long long start = now_us();
    func();
    const long long end = now_us();
    printf("%s: %lld us\n", label, end - start);
}

void cpp_float_sum_test() {
    volatile float a = 1.234f, b = 5.678f, res;
    for (int i = 0; i < 1000000; ++i) {
        res = a + b;
    }
}

void cpp_double_sum_test() {
    volatile double a = 1.234, b = 5.678, res;
    for (int i = 0; i < 1000000; ++i) {
        res = a + b;
    }
}

void cpp_float_mul_test() {
    volatile float a = 1.234f, b = 5.678f, res;
    for (int i = 0; i < 1000000; ++i) {
        res = a * b;
    }
}

void cpp_double_mul_test() {
    volatile double a = 1.234, b = 5.678, res;
    for (int i = 0; i < 1000000; ++i) {
        res = a * b;
    }
}

void asm_float_sum_test() {
    float a = 1.234f, b = 5.678f, res;
    for (int i = 0; i < 1000000; ++i) {
        __asm {
            fld a
            fadd b
            fstp res
        }
    }
}

void asm_double_sum_test() {
    double a = 1.234, b = 5.678, res;
    for (int i = 0; i < 1000000; ++i) {
        __asm {
            fld a
            fadd b
            fstp res       
        }
    }
}

void asm_float_mul_test() {
    float a = 1.234f, b = 5.678f, res;
    for (int i = 0; i < 1000000; ++i) {
        __asm {
            fld a
            fmul b
            fstp res
        }
    }
}

void asm_double_mul_test() {
    double a = 1.234, b = 5.678, res;
    for (int i = 0; i < 1000000; ++i) {
        __asm {
            fld a
            fmul b
            fstp res       
        }
    }
}

int main() {
    printf("--- Сравнение скорости (1 млн итераций) ---\n");
    
    benchmark("C Float sum (32-bit)", cpp_float_sum_test);
    benchmark("C Double sum (64-bit)", cpp_double_sum_test);
    benchmark("C Float mul (32-bit)", cpp_float_mul_test);
    benchmark("C Double mul (64-bit)", cpp_double_mul_test);

    printf("\n--- Использование сопроцессора (x87 ASM) ---\n");
    
    benchmark("ASM Float sum (32-bit)", asm_float_sum_test);
    benchmark("ASM Double sum (64-bit)", asm_double_sum_test);
    benchmark("ASM Float mul (32-bit)", asm_float_mul_test);
    benchmark("ASM Double mul (64-bit)", asm_double_mul_test);

    return 0;
}
