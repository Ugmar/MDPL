#include <stdio.h>

#define N 8

void neon_vector_add(const float *a, const float* b, float *result, int n) {
    if (n <= 0) return;

    __asm__ __volatile__(
        "subs %[n], %[n], #4\n\t"
        "blt 2f\n\t"

        "1:\n\t"
        "ldr q0, [%[a]], #16\n\t"
        "ldr q1, [%[b]], #16\n\t"
        "fadd v2.4s, v0.4s, v1.4s\n\t"
        "str q2, [%[res]], #16\n\t"
        
        "subs %[n], %[n], #4\n\t"
        "bge 1b\n\t"

        "2:\n\t"
        "adds %[n], %[n], #4\n\t"
        "cbz %[n], 4f\n\t"

        "3:\n\t"
        "ldr s0, [%[a]], #4\n\t"
        "ldr s1, [%[b]], #4\n\t"
        "fadd s2, s0, s1\n\t"
        "str s2, [%[res]], #4\n\t"
        
        "subs %[n], %[n], #1\n\t"
        "bne 3b\n\t"

        "4:\n\t"

        : [a] "+r" (a), [b] "+r" (b), [res] "+r" (result), [n] "+r" (n)
        :
        : "v0", "v1", "v2", "cc", "memory"
    );
}

int main(void) {
    float arrayA[N] = {1.0f, 2.5f, 3.0f, 4.2f, 10.0f, 20.0f, 30.0f, 40.0f};
    float arrayB[N] = {0.5f, 1.5f, 2.0f, 0.8f,  5.0f,  5.0f,  5.0f,  5.0f};
    float result[N] = {};

    neon_vector_add(arrayA, arrayB, result, N);

    printf("Vector Addition Result:\n");
    for (int i = 0; i < N; ++i) {
        printf("%.1f + %.1f = %.1f\n", arrayA[i], arrayB[i], result[i]);
    }

    return 0;
}
