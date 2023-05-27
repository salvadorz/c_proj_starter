/**
 * @file utils_common.h
 * @author Salvador Z
 * @version 1.0
 * @brief File for Variable types and common macros
 *
 */

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

#ifndef UTILS_COMMON_H_
#define UTILS_COMMON_H_

// Includes
// #include <stddef.h>
#include <stdio.h> /*printf*/

#define PRINT_DEBUG (1U)
#define SEND()                                                                 \
  fflush(stdin);                                                               \
  fflush(stdout)
#define FLUSH_AFTER_PRINTF()                                                   \
  setvbuf(stdout, 0, _IONBF, 0);                                               \
  setvbuf(stdin, 0, _IONBF, 0)

#if PRINT_DEBUG
#define DEBUG_LOG(msg, ...)                                                    \
  printf("DEBUG: " msg "\n", ##__VA_ARGS__);                                   \
  SEND()
#define ERROR_LOG(msg, ...)                                                    \
  printf("ERROR:\n " msg "\n", ##__VA_ARGS__);                                 \
  SEND()
#else
#define DEBUG_LOG(msg, ...)
#define ERROR_LOG(msg, ...)
#endif

// clang-format off
typedef volatile unsigned char      vuint8_t;   /*unsigned  8 bit definition */
typedef volatile unsigned short     vuint16_t;  /*unsigned 16 bit definition */
typedef volatile unsigned int       vuint32_t;  /*unsigned 32 bit definition */
typedef volatile unsigned long long vuint64_t;  /*unsigned 64 bit definition */

typedef volatile signed char        vint8_t;   /*signed  8 bit definition */
typedef volatile signed short       vint16_t;  /*signed 16 bit definition */
typedef volatile signed int         vint32_t;  /*signed 32 bit definition */
typedef volatile signed long long   vint64_t;  /*signed 64 bit definition */

typedef unsigned char               uint8_t;   /*unsigned  8 bit definition */
typedef unsigned short              uint16_t;  /*unsigned 16 bit definition */
typedef unsigned int                uint32_t;  /*unsigned 32 bit definition */
typedef unsigned long int           uint64_t;  /*unsigned 64 bit definition */

typedef signed char                 int8_t;    /*signed  8 bit definition */
typedef signed short                int16_t;   /*signed 16 bit definition */
typedef signed int                  int32_t;   /*signed 32 bit definition */
typedef signed long int             int64_t;   /*signed 64 bit definition */

typedef float       float32_t;
typedef double      float64_t;
typedef long double float128_t;

typedef uint8_t     base_t;

typedef enum BITS_e {
  BIT0 = 0u,
  BIT1,
  BIT2,
  BIT3,
  BIT4,
  BIT5,
  BIT6,
  BIT7,
} BITS_t;

#define ROTATE_R_SHIFT(var, bit_size) (((var) >> 1) | ((var) << (bit_size - 1)))
#define ROTATE_L_SHIFT(var, bit_size) (((var) << 1) | ((var) >> (bit_size - 1)))

#define ROTATE_BYTE_R_POS(var, n_pos)                                          \
  (((var) >> ((n_pos) % 8U)) | ((var) << (8U - ((n_pos) % 8U))))
#define ROTATE_BYTE_L_POS(var, n_pos)                                          \
  (((var) << ((n_pos) % 8U)) | ((var) >> (8U - ((n_pos) % 8U))))

#define ROTATE_WORD_R_POS(var, n_pos)                                          \
  (((var) >> ((n_pos) % 32U)) | ((var) << (32U - ((n_pos) % 32U))))
#define ROTATE_WORD_L_POS(var, n_pos)                                          \
  (((var) << ((n_pos) % 32U)) | ((var) >> (32U - ((n_pos) % 32U))))

/*****************************************************************************************************
 * Definition of module wide MACROs / #DEFINE-CONSTANTs
 *****************************************************************************************************/

/* Common Constants */
#ifndef    ON
  #define  ON        (1u)
#endif

#ifndef    OFF
  #define  OFF       (0u)
#endif

#ifndef    OK
  #define  OK        (0u)
#endif

#ifndef    NOT_OK
  #define  NOT_OK    (1u)
#endif

#ifndef    BUSY_W
  #define  BUSY_W    (2u)
#endif

#ifndef    ERROR
  #define  ERROR     (0xFFU)    /* UINT8_MAX - Error for base_t type*/
#endif

#ifndef    TRUE
  #define  TRUE      (1u)
#endif

#ifndef    FALSE
  #define  FALSE     (0u)
#endif

#ifndef    PASS
  #define  PASS      (0u)
#endif

#ifndef    FAIL
  #define  FAIL      (1u)
#endif

#ifndef    SET
  #define  SET       (1u)
#endif

#ifndef    CLEAR
  #define  CLEAR     (0u)
#endif

#ifndef    YES
  #define  YES       (1u)
#endif

#ifndef    NO
  #define  NO        (0u)
#endif

#ifndef    DISABLED
  #define  DISABLED  (0u)
#endif

#ifndef    ENABLE
  #define  ENABLE    (1u)
#endif

#ifndef NULL
#define NULL ((void *)0)
#endif

#if !defined(PASSED) && !defined(FAILED)
#define PASSED( x )               ( PASS == (x) )
#define FAILED( x )               ( PASS != (x) )
#define EXPECTED_VAL( tst , x )   ( (tst) == (x) )
#endif

#define PASSED_MARK (u8"\u2713")
#define FAILED_MARK (u8"\u2717")
// clang-format on

#endif /* UTILS_COMMON_H_ */