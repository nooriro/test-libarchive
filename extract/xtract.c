#include <stdio.h>
#include <stdlib.h>
#include <locale.h>
#if defined(_WIN32)
# include <windows.h>
#endif
#include "libarchive/include/archive.h"
#include "libarchive/include/archive_entry.h"

/* See https://stackoverflow.com/questions/6932401/elegant-error-checking/6933170#6933170 */
#define CHECK(x) do {                                               \
    r = (x);                                                        \
    if (r < ARCHIVE_OK) {                                           \
        fprintf(stderr, "error: %s returned %s(%d) at %s:%d\n", #x, \
            r == ARCHIVE_RETRY  ? "ARCHIVE_RETRY"  :                \
            r == ARCHIVE_WARN   ? "ARCHIVE_WARN"   :                \
            r == ARCHIVE_FAILED ? "ARCHIVE_FAILED" :                \
            r == ARCHIVE_FATAL  ? "ARCHIVE_FATAL"  : "error",       \
            r, __FILE__, __LINE__);                                 \
        if (r == ARCHIVE_RETRY && ++retry < 30) continue;           \
        if (r == ARCHIVE_RETRY || r < ARCHIVE_WARN) goto cleanup;   \
    }                                                               \
} while ((retry = 0))

static void print_entry_pathname(struct archive_entry *e) {
#if defined(_WIN32)
    /* Do not use wprintf() - Use printf() with converted utf-8 string */
    /* Do not use wcstombs() - Use WideCharToMultiByte(CP_UTF8, ...) */
    const wchar_t *entrypath_w;
    int size;
    char *entrypath;
    
    entrypath_w = archive_entry_pathname_w(e);
    size = WideCharToMultiByte(CP_UTF8, 0, entrypath_w, -1, NULL, 0, NULL, NULL);
    entrypath = malloc(size);
    WideCharToMultiByte(CP_UTF8, 0, entrypath_w, -1, entrypath, size, NULL, NULL);
    printf("%s\n", entrypath);
    free(entrypath);
#else
    printf("%s\n", archive_entry_pathname(e));
#endif
}

static int extract(const char *path) {
    struct archive *a, *aw = NULL;
    struct archive_entry *e;
    int r, retry = 0;
    const void *buff;
    size_t size;
    la_int64_t offset;

    a = archive_read_new();
    archive_read_support_filter_all(a);
    archive_read_support_format_all(a);
    CHECK(archive_read_open_filename(a, path, 10240));

    aw = archive_write_disk_new();
    archive_write_disk_set_options(aw, ARCHIVE_EXTRACT_TIME);

    for (;;) {
        CHECK(archive_read_next_header(a, &e));
        if (r == ARCHIVE_EOF) break;
        print_entry_pathname(e);
        CHECK(archive_write_header(aw, e));
        for (;;) {
            CHECK(archive_read_data_block(a, &buff, &size, &offset));
            if (r == ARCHIVE_EOF) break;
            CHECK(archive_write_data_block(aw, buff, size, offset));
        }
        CHECK(archive_write_finish_entry(aw));  /* Times are set here */
    }

    archive_read_close(a);
    archive_write_close(aw);
    r = 0;
cleanup:
    if (a) archive_read_free(a);
    if (aw) archive_write_free(aw);
    return r == 0 ? 0 : 1;
}

#if defined(_WIN32)
/* See https://entropymine.wordpress.com/2018/11/28/win32-i-o-character-encoding-part-2-chcp-65001/
   and other posts in the series */
static void toggle_cp65001(void) {
    static UINT oldicp, oldocp;

    if (!oldicp && !oldocp) {
        oldicp = GetConsoleCP();
        oldocp = GetConsoleOutputCP();
        SetConsoleCP(CP_UTF8);
        SetConsoleOutputCP(CP_UTF8);
    } else {
        SetConsoleCP(oldicp);
        SetConsoleOutputCP(oldocp);
        oldocp = oldicp = 0;
    }
}

static BOOL WINAPI ctrlhandler(DWORD ctrltype) {
    if (ctrltype == CTRL_C_EVENT || ctrltype == CTRL_BREAK_EVENT)
        toggle_cp65001();
    return FALSE;
}
#endif

int main(int argc, char *argv[]) {
    int i, n;

#if defined(_WIN32)
    toggle_cp65001();
    atexit(toggle_cp65001);
    SetConsoleCtrlHandler(ctrlhandler, TRUE);
    printf("%u %u %u %u\n",
           GetACP(), GetOEMCP(), GetConsoleCP(), GetConsoleOutputCP());
#endif
    /* [Windows 10 22H2] MSVC v143 ucrt:    "Korean_Korea.utf8" */
    /* [Windows 10 22H2] MinGW-w64 msvcrt:  "Korean_Korea.949" */
    /* [WSL1 Ubuntu 20.04.6 LTS] GCC glibc: "C.UTF-8" */
    /* [WSL1 Ubuntu 20.04.6 LTS] MUSL libc: "C.UTF-8" */
    printf("%s\n", setlocale(LC_CTYPE, ""));

    if (argc < 2) {
        fputs("usage: xtract ARCHIVEFILE...\n", stderr);
        return 64;  /* EX_USAGE in sysexits.h */
    }
    for (i = 1, n = 0; i < argc; i++) {
        printf("[%d/%d] Extracting from %s\n", i, argc - 1, argv[i]);
        n |= extract(argv[i]);
    }
    return n;
}
