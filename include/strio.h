/**
 * @file strio.h
 * @author Salvador Z
 * @version 1.0
 * @brief File for handling string to data
 *
 */

#ifndef STRIO_H_
#define STRIO_H_

// Includes
#include "utils_common.h"

/**
 * @brief Get the length of a string (MAX=65.5k)
 *
 * @param s  Pointer to the string.
 *
 * @return  Length of the string
 *          0 if NULL or empty.
 */
uint16_t str_len(char const *s);

#endif /* STRIO_H_ */