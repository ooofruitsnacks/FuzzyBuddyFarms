
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <inttypes.h>

int __isoc23_sscanf(const char *s, const char *fmt, ...) {
    va_list ap; va_start(ap, fmt);
    int r = vsscanf(s, fmt, ap);
    va_end(ap); return r;
}
int __isoc23_fscanf(FILE *f, const char *fmt, ...) {
    va_list ap; va_start(ap, fmt);
    int r = vfscanf(f, fmt, ap);
    va_end(ap); return r;
}
int __isoc23_scanf(const char *fmt, ...) {
    va_list ap; va_start(ap, fmt);
    int r = vscanf(fmt, ap);
    va_end(ap); return r;
}
int __isoc23_vsscanf(const char *s, const char *fmt, va_list ap) {
    return vsscanf(s, fmt, ap);
}
long                __isoc23_strtol   (const char *p, char **e, int b) { return strtol(p, e, b); }
unsigned long       __isoc23_strtoul  (const char *p, char **e, int b) { return strtoul(p, e, b); }
long long           __isoc23_strtoll  (const char *p, char **e, int b) { return strtoll(p, e, b); }
unsigned long long  __isoc23_strtoull (const char *p, char **e, int b) { return strtoull(p, e, b); }
intmax_t            __isoc23_strtoimax(const char *p, char **e, int b) { return strtoimax(p, e, b); }
uintmax_t           __isoc23_strtoumax(const char *p, char **e, int b) { return strtoumax(p, e, b); }

