#include "string_stack.h"
#include <stdlib.h>
#include <string.h>

#define INITIAL_CAPACITY 16

struct _Stack
{
    char **elements;
    int top;
    int capacity;
};

stack_response create()
{
    stack s = malloc(sizeof(struct _Stack));
    if (s == NULL)
    {
        return (stack_response){.code = out_of_memory, .stack = NULL};
    }
    s->top = 0;
    s->capacity = INITIAL_CAPACITY;
    s->elements = malloc(INITIAL_CAPACITY * sizeof(char *));
    if (s->elements == NULL)
    {
        free(s);
        return (stack_response){.code = out_of_memory, .stack = NULL};
    }
    return (stack_response){.code = success, .stack = s};
}

int size(const stack s)
{
    return s->top;
}

bool is_empty(const stack s)
{
    return size(s) == 0;
}
bool is_full(const stack s)
{
    return size(s) == MAX_CAPACITY;
}

response_code push(stack s, char *item)
{
    if (is_full(s))
    {
        return stack_full;
    }
    if (strlen(item) > MAX_ELEMENT_BYTE_SIZE)
    {
        return stack_element_too_large;
    }
    if (s->top == s->capacity)
    {
        int new_capacity = s->capacity * 2;
        if (new_capacity > MAX_CAPACITY)
        {
            new_capacity = MAX_CAPACITY;
        }
        char **new_elements = realloc(s->elements, new_capacity * sizeof(char *));
        if (new_elements == NULL)
        {
            return out_of_memory;
        }
        s->elements = new_elements;
        s->capacity = new_capacity;
    }
    s->elements[s->top++] = strdup(item);
    return success;
}

string_response pop(stack s)
{
    if (is_empty(s))
    {
        return (string_response){.code = stack_empty, .string = NULL};
    }
    char *popped = s->elements[--s->top];
    int new_capacity = s->capacity / 2;
    if (new_capacity < 1)
    {
        new_capacity = 1;
    }
    char **new_elements = realloc(s->elements, new_capacity * sizeof(char *));
    if (new_elements == NULL)
    {
        return (string_response){.code = out_of_memory, .string = NULL};
    }
    s->elements = new_elements;
    s->capacity = new_capacity;
    return (string_response){.code = success, .string = popped};
}

void destroy(stack *s)
{
    for (int i = 0; i < (*s)->top; i++)
    {
        free((*s)->elements[i]);
    }
    free((*s)->elements);
    free(*s);
    *s = NULL;
}