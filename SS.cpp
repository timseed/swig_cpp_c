//
// Created by Timothy H  Seed on 4/22/20.
//

#include "SS.h"
extern "C" int c_sum(int a, int b);


SS::SS() = default;

int SS::Sum(int a, int b) {

    return a+b;
}

int SS::Sum_from_c(int a, int b) {

    return c_sum(a,b);
}
