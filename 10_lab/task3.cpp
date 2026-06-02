#include <iostream>
#include <iomanip>

double func(double x){
    double res;
    double multiplier = 5;
    __asm{
        fld x
        fld st(0)
        fmul st(0), st(0)

        fld multiplier
        fmulp st(2), st(0)

        faddp st(1), st(0)
        fsin
        fstp res
    }

    return res;
}

double get_mid(double start, double end)
{
    double res = 0;
    __asm{
        fld start
        fld end
        faddp st(1), st(0)

        fld1
        fld1
        faddp st(1), st(0)

        fdivp st(1), st(0)
        fstp res
    }

    return res;
}

double find_root(double start, double end, int iterations, int *flag) {
    double mid = 0.0;
    double f_start = func(start);
    double f_mid = 0.0;
    *flag = 0;
    if (iterations <= 0) {*flag = 1; return start;}
    if (func(end) * f_start > 0) {*flag = 1; std::cout << "Разные знаки на границах\n"; return start;}

    __asm {
        mov ecx, iterations

    LOOP_START:
        push dword ptr [end + 4]
        push dword ptr [end]
        push dword ptr [start + 4]
        push dword ptr [start]
        call get_mid
        add esp, 16
        fstp mid

        push dword ptr [mid + 4]
        push dword ptr [mid]
        call func
        add esp, 8
        fstp f_mid

        fld f_mid
        ftst
        fnstsw ax
        sahf
        fstp st(0)
        jz EXIT_INNER

        fld f_start
        fmul f_mid

        ftst
        fnstsw ax
        sahf
        fstp st(0)

        jb ROOT_ON_LEFT

        fld mid
        fstp start

        fld f_mid
        fstp f_start
        jmp DECREMENT_LOOP

    ROOT_ON_LEFT:
        fld mid
        fstp end

    DECREMENT_LOOP:
        dec ecx
        jnz LOOP_START

    EXIT_INNER:
    }

    return mid;
}

template<typename T>
bool get_value(std::string prompt, T& value)
{
    std::cout << prompt;
    std::cin >> value;

    if (std::cin.fail())
        return false;

    return true;
}

#define ERROR_INPUT 1

int main()
{
    double start{}, end{};
    int it{};
    
    bool rc = get_value<double>("Введите начало отрезка: ", start);
    if (!rc)
    {
        std::cerr << "Ошибка ввода для начала отрезка." << std::endl;
        return ERROR_INPUT;
    }

    rc = get_value<double>("Введите конец отрезка: ", end);
    if (!rc)
    {
        std::cerr << "Ошибка ввода для конца отрезка." << std::endl;
        return ERROR_INPUT;
    }

    if (end <= start)
    {
        std::cerr << "Ошибка: конец отрезка должен быть больше начала." << std::endl;
        return ERROR_INPUT;
    }

    rc = get_value<int>("Введите количество итераций: ", it);

    if (!rc)
    {
        std::cerr << "Ошибка ввода для количества итераций." << std::endl;
        return ERROR_INPUT;
    }

    if (it <= 0)
    {
        std::cerr << "Ошибка: количество итераций должно быть положительным." << std::endl;
        return ERROR_INPUT;
    }

    std::cout << std::fixed << std::setprecision(10);
    int flag = 0;

    double root = find_root(start, end, it, &flag);
    
    if (flag == 0)
        std::cout << "Найденный корень на отрезке [" << start << ", " << end << "]: " << root << std::endl;
    else
        std::cout << "Корень не найден\n";

    return 0;
}
