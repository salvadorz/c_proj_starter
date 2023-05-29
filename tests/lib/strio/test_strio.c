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
 * @file test_strio.c
 * @author Salvador Z
 * @date 27 May 2023
 * @brief File for test strio lib
 *
 */

#include "strio.h"
#include "utils_common.h"

#include <stdbool.h>
#include <stdio.h> /*printf*/

typedef struct test_s {
  uint16_t test_case_number;
  uint16_t test_case_failed;
} test_data_t;

test_data_t test_data;

static void test_check(uint16_t expected, uint16_t actual) {

  bool test_result = EXPECTED_VAL(expected, actual);

  if (test_result) {
    printf("[%s] Test #%d -PASSED-\n", (const char *)PASSED_MARK, ++test_data.test_case_number);
  } else {
    printf("[%s] Test #%d -FAILED- Expected value: %d vs result:%d\n", (const char *)FAILED_MARK,
           ++test_data.test_case_number, expected, actual);
    ++test_data.test_case_failed;
  }
}

int main() {

  uint16_t length = 0U;
  char const no_terminator[4U] = {'B', 'U', 'N', 'A'};
  test_data.test_case_failed = 0U;
  test_data.test_case_number = 0U;

  /* Test case simple */
  length = str_len("1234567890");
  test_check(10U, length);

  /* Test case empty string */
  length = str_len("");
  test_check(0U, length);

  /* Test case with spaces on both sides */
  length = str_len(" Hola ");
  test_check(6U, length);

  /* Test case no null terminator */
  length = str_len(no_terminator);
  test_check(4U, length);

  /* Test case NULL case */
  length = str_len(((void *)0));
  test_check(0U, length);

  if (0U != test_data.test_case_failed) {
    printf("-%s- Test Cases Failed: %d\n", (const char *)FAILED_MARK, test_data.test_case_failed);
    // exit(1);
  } else {
    printf("[OK] All tests were successful--\n");
  }

  return 0;
}