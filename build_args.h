<<<<<<< HEAD
#ifdef AMG_BUILD_ARGS_H
=======
#ifndef AMG_BUILD_ARGS_H
>>>>>>> 117002e9db27dfe4efe13cdbfcc6bae71d970471
#define AMG_BUILD_ARGS_H

#define _build_arg_xstr(s) _build_arg_str(s)
#define _build_arg_str(s) #s

#ifdef AMG_COMPILER_NAME
#define AMG_COMPILER_NAME_STR _build_arg_xstr(AMG_COMPILER_NAME)
#else
#define AMG_COMPILER_NAME_STR "UNKNOWN"
#endif

<<<<<<< HEAD
#endif
=======
#endif
>>>>>>> 117002e9db27dfe4efe13cdbfcc6bae71d970471
