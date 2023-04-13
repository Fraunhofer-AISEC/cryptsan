//===-- test-cryptsan.c ---------------------------------------------===//
//
// Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file is a part of CryptSan.
//
// CryptSan Example Violation Detection.
//===----------------------------------------------------------------------===//

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

void test_in_bounds_load()
{
    int *ptr = malloc(20 * sizeof(int));
    ptr[10] = 42;
}

void test_out_of_bounds_load_fail()
{
    int *ptr = malloc(20 * sizeof(int));
    ptr[21] = 42;
}

void test_in_bounds_store()
{
    uint8_t *ptr = malloc(20 * sizeof(uint8_t));
    ptr[10] = 42;
}

void test_out_of_bounds_store_fail()
{
    uint8_t *ptr = malloc(20 * sizeof(uint8_t));
    ptr[21] = 42;
}

void test_use_after_free()
{
    uint8_t *ptr = malloc(12);
    free(ptr);
    ptr[0] = 5;
}

// See if we can construct a pointer to the id and set it to another value
void test_shadow_write_fail()
{
   uint32_t *victim = malloc(4);
   // Set bit to pointer to shadow, then clear pac mask from pointer
   uint32_t *ptr = (uint32_t *)((0x200000000000ULL | (unsigned long)victim) & 0x00002FFFFFFFFFFFULL);
   *ptr = 5;
}

int main(int argc, char *argv[])
{
    int testcase;
    if (argc > 1)
    {
        testcase = argv[1][0] - '0';
    }
    else
    {
        printf("Specify testcase 0-5 \n");
        return 0;
    }
    switch (testcase)
    {
    case 0:
        printf("test_in_bounds_load legal\n");
        test_in_bounds_load();
        break;
    case 1:
        printf("test_out_of_bounds_load illegal\n");
        test_out_of_bounds_load_fail();
        break;
    case 2:
        printf("test_in_bounds_store legal\n");
        test_in_bounds_store();
        break;
    case 3:
        printf("test_out_of_bounds_store illegal\n");
        test_out_of_bounds_store_fail();
        break;
    case 4:
        printf("test_use_after_free illegal\n");
        test_use_after_free();
        break;
    case 5:
        printf("test_shadow_write illegal\n");
        test_shadow_write_fail();
        break;
    }
    return 0;
}
