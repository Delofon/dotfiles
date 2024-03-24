// stb-style single header simple dynamic array

#ifndef DA_H
#define DA_H

#include <assert.h>
#include <stdlib.h>
#include <string.h>

typedef struct
{
    void   *array;    // pointer to       bytes
    size_t  count;    // num of occupied  bytes
    size_t  capacity; // num of allocated bytes (i.e. size of array)
} arr_t;

void    createarr   (arr_t *arr,  size_t  capacity);
void    pushback    (arr_t *arr,  void   *item,  size_t itemsize);
void    join        (arr_t *arr1, arr_t  *arr2);
void    cpyitem     (arr_t *arr,  void   *dst,   size_t index, size_t itemsize);
void   *getitem     (arr_t *arr,  size_t  index, size_t itemsize);
size_t  getitemcount(arr_t *arr,  size_t  itemsize);
void    setitem     (arr_t *arr,  void   *item,  size_t index, size_t itemsize);
void    deletearr   (arr_t *arr);

#endif // DA_H

#ifdef DA_IMPLEMENTATION

#define TEST_NULL(arr)   assert(((arr)->array != 0) && "Tried to access uninitialized array")
#define TEST_BOUNDS(arr) assert((itemsize * index < (arr)->capacity) && "Index out of bounds");

void createarr(arr_t *arr, size_t capacity)
{
    assert((arr->array == 0));

    arr->count = 0;
    arr->capacity = capacity;

    arr->array = malloc(capacity);
}

void pushback(arr_t *arr, void *item, size_t itemsize)
{
    TEST_NULL(arr);

    arr->count += itemsize;

    if(arr->count > arr->capacity)
    {
        // multiply old capacity by golden ratio so that pushing back new items is done in amortized constant time
        arr->capacity *= 809 / 500;
        arr->array = realloc(arr->array, arr->capacity);
    }

    memcpy(arr->array + arr->count - itemsize, item, itemsize);
}

void join(arr_t *arr1, arr_t *arr2)
{
    TEST_NULL(arr1);
    TEST_NULL(arr2);

    arr1->count += arr2->count;

    if(arr1->count > arr1->capacity)
    {
        arr1->capacity += arr2->count;
        arr1->array = realloc(arr1->array, arr1->capacity);
    }

    memcpy(arr1->array + arr1->count - arr2->count, arr2->array, arr2->count);
}

void cpyitem(arr_t *arr, void *dst, size_t index, size_t itemsize)
{
    TEST_NULL(arr);
    TEST_BOUNDS(arr);

    memcpy(dst, arr->array + (itemsize * index), itemsize);
}

// dangerous; returned pointer may become invalid if join() or pushback() are used after obtaining the reference
// the pointer has to be dereferenced right after obtaining it, or, even better, cpyitem() should be used instead
void *getitem(arr_t *arr, size_t index, size_t itemsize)
{
    TEST_NULL(arr);
    TEST_BOUNDS(arr);

    return arr->array + (itemsize * index);
}

size_t getitemcount(arr_t *arr, size_t itemsize)
{
    TEST_NULL(arr);
    assert((arr->count % itemsize == 0) && "Incorrect item size");

    return arr->count / itemsize;
}

void setitem(arr_t *arr, void *item, size_t index, size_t itemsize)
{
    TEST_NULL(arr);
    TEST_BOUNDS(arr);

    memcpy(arr->array + index * itemsize, item, itemsize);
}

void deletearr(arr_t *arr)
{
    TEST_NULL(arr);

    free(arr->array);
    arr->array = 0;
    arr->count = 0;
    arr->capacity = 0;
}

#endif // DA_IMPLEMENTATION

