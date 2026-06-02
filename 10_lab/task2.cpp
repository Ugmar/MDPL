#include <iostream>
#include <iomanip>
#include <cmath>

using namespace std;

double fpu_sin(double val) {
    double res;
    __asm {
        fld val
        fsin
        fstp res
    }
    return res;
}

double fpu_sin_pi(void) {
    double res;
    __asm {
        fldpi
        fsin
        fstp res
    }
    return res;
}

double fpu_sin_half(double val) {
    double res;
    __asm {
        fld val
        fld1
        fld1
        faddp ST(1), ST(0)
        fdivp ST(1), ST(0)
        fsin
        fstp res
    }
    return res;
}

double fpu_sin_half_pi() {
    double res;
    __asm {
        fldpi
        fld1
        fld1
        faddp ST(1), ST(0)
        fdivp ST(1), ST(0)
        fsin
        fstp res
    }
    return res;
}

int main() {
    double pi_1 = 3.14;
    double pi_2 = 3.141596;

    cout << fixed << setprecision(18);
    cout << "--- Сравнение точности вычислений sin(pi) ---" << endl;

    cout << "1. При pi = 3.14:     " << fpu_sin(pi_1) << endl;
    cout << "2. При pi = 3.141596: " << fpu_sin(pi_2) << endl;
    cout << "3. При FPU PI: " << fpu_sin_pi() << endl;

    cout << "\n--- Сравнение точности вычислений sin(pi/2) ---" << endl;

    cout << "1. При pi = 3.14:     " << fpu_sin_half(pi_1) << endl;
    cout << "2. При pi = 3.141596: " << fpu_sin_half(pi_2) << endl;
    cout << "3. При FPU PI: " << fpu_sin_half_pi() << endl;

    return 0;
}
