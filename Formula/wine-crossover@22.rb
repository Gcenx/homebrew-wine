  homepage "https://www.codeweavers.com"
  bottle do
    root_url "https://github.com/Gcenx/homebrew-wine/releases/download/wine-crossover@22-22.1.1"
    sha256 monterey: "05bf09d8f693706a8647009b08a221ad64ff4951cd02098ffded2b19251322c8"
  end

diff --git a/include/distversion.h b/include/distversion.h
+++ b/include/distversion.h
diff --git a/loader/preloader_mac.c b/loader/preloader_mac.c
index 4e91128c575..97830dd8d6a 100644
--- a/loader/preloader_mac.c
+++ b/loader/preloader_mac.c
@@ -312,6 +312,9 @@ void *wld_munmap( void *start, size_t len );
 SYSCALL_FUNC( wld_munmap, 73 /* SYS_munmap */ );
 
 static intptr_t (*p_dyld_get_image_slide)( const struct target_mach_header* mh );
+#ifdef __x86_64__
+static void (*p_dyld_make_delayed_module_initializer_calls)( void );
+#endif
 
 #define MAKE_FUNCPTR(f) static typeof(f) * p##f
 MAKE_FUNCPTR(dlopen);
@@ -680,6 +683,9 @@ void *wld_start( void *stack, int *is_unix_thread )
     LOAD_POSIX_DYLD_FUNC( dlsym );
     LOAD_POSIX_DYLD_FUNC( dladdr );
     LOAD_MACHO_DYLD_FUNC( _dyld_get_image_slide );
+#ifdef __x86_64__
+    LOAD_MACHO_DYLD_FUNC( _dyld_make_delayed_module_initializer_calls );
+#endif
 
     /* reserve memory that Wine needs */
     if (reserve) preload_reserve( reserve );
@@ -695,6 +701,10 @@ void *wld_start( void *stack, int *is_unix_thread )
     if (!map_region( &builtin_dlls ))
         builtin_dlls.size = 0;
 
+#ifdef __x86_64__
+    p_dyld_make_delayed_module_initializer_calls();
+#endif
+
     /* load the main binary */
     if (!(mod = pdlopen( argv[1], RTLD_NOW )))
         fatal_error( "%s: could not load binary\n", argv[1] );