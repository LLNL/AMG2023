#ifndef AMG_BUILD_ARGS_H
#define AMG_BUILD_ARGS_H

#define _build_arg_xstr(s) _build_arg_str(s)
#define _build_arg_str(s) #s

#ifdef AMG_COMPILER_NAME
#define AMG_COMPILER_NAME_STR _build_arg_xstr(AMG_COMPILER_NAME)
#else
#define AMG_COMPILER_NAME_STR "UNKNOWN"
#endif

#endif
