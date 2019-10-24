#ifndef C_AFCORE_DEBUG_H
#define C_AFCORE_DEBUG_H

#include <stdbool.h>

void debugbreak();
void trap();
bool isDebuggerAttached();

#endif // C_AFCORE_DEBUG_H
