/*******************************************************************************
 * Copyright (C) 2023 by Salvador Z                                            *
 *                                                                             *
 * This file is part of UTILS_C                                                *
 *                                                                             *
 *   Permission is hereby granted, free of charge, to any person obtaining a   *
 *   copy of this software and associated documentation files (the Software)   *
 *   to deal in the Software without restriction including without limitation  *
 *   the rights to use, copy, modify, merge, publish, distribute, sublicense,  *
 *   and/or sell copies ot the Software, and to permit persons to whom the     *
 *   Software is furnished to do so, subject to the following conditions:      *
 *                                                                             *
 *   The above copyright notice and this permission notice shall be included   *
 *   in all copies or substantial portions of the Software.                    *
 *                                                                             *
 *   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS   *
 *   OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARANTIES OF MERCHANTABILITY *
 *   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL   *
 *   THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR      *
 *   OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,     *
 *   ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE        *
 *   OR OTHER DEALINGS IN THE SOFTWARE.                                        *
 ******************************************************************************/

/**
 * @file main.c
 * @author Salvador Z
 * @date 26 May 2023
 * @brief File for main
 *
 */

#include "strio.h"
#include "utils_common.h"
#include <stdbool.h>
#include <stdio.h> /*printf*/

int test_case_number = 0;

static void test_check(bool result) {

  printf("%s Test #%d\n", (result) ? (const char *)PASSED_MARK : (const char *)FAILED_MARK,
         ++test_case_number);
}

int main() {

  int length = 0;
  const char empty_str[0u];

  /* Test case simple */
  length = str_len("1234567890");
  test_check(EXPECTED_VAL(10u, length));
  /* Test case with spaces on both sides */
  length = str_len(" Hola ");
  test_check(EXPECTED_VAL(6u, length));
  /* Test case empty string */
  length = str_len(empty_str);
  test_check(EXPECTED_VAL(0u, length));
  /* Test case NULL case */
  length = str_len(((void *)0));
  test_check(EXPECTED_VAL(0u, length));

  return 0;
}
