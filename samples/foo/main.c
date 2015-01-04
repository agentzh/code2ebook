/* Copyright (C) Yichun Zhang */

#include <stdio.h>
#define COUNT  32

typedef struct {
    int              i;
    const char      *s;
} foo_t;

/* function foo()
 * TODO: make it better.
 */ 
static void foo()
{
    int    i;
    foo_t  var[COUNT];  // define a variable

    for (i = 0; i < COUNT; i++) {
        var[i].i = i;
        var[i].s = "hello world\n";
    }
}

int main()
{
    foo();
    printf("done.\n");
    return 0;
}
