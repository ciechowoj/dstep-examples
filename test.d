import std.file;
import std.process;

void run(in char[][] args)
{
    import std.process;
    import std.stdio;
    import std.array;

    writeln();
    writeln(join(args, " "));
    auto result = execute(args);
    writeln(result.status);
    writeln(result.output);
}

void ensureDirectoryExists(string path)
{
    if (!exists(path))
        mkdirRecurse(path);
}

int main()
{
    string resources = "-I../dstep/resources";

    // fftw3
    ensureDirectoryExists("output/fftw");
    run(["dstep", "fftw3/api/fftw3.h", resources, "-o", "output/fftw/fftw3.d"]);
    execute(["ln", "-s", "../../fftw3/api/fftw3.h", "output/fftw/fftw3.h"]);


    return 0;

    // glfw3
    run(["dstep", "glfw/include/GLFW/glfw3.h", resources, "-Iglfw/include", "-o", "glfw3.d"]);
    run(["dstep", "glfw/include/GLFW/glfw3native.h", resources, "-Iglfw/include", "-o", "glfw3native.d"]);

    // jpeg-9b
    run(["dstep", "jpeg-9b/jpeglib.h", "-Ijpeg-9b", "-o jpeglib.d", "-include", "/usr/include/stdio.h"]);

    // libpng
    run(["dstep", "libpng-1.6.23/png.h", resources, "-Ilibpng-1.6.23", "-I/usr/include", "-o", "png.d"]);

    // sqlite3
    run(["dstep", "sqlite-autoconf-3130000/sqlite3.h", resources, "-Isqlite-autoconf-3130000", "-o", "sqlite3.d"]);

    // dvb
    run(["dstep", "v4l-utils-1.10.1/include/linux/dvb/frontend.h", resources, "-o", "dvb/frontend.d"]);


    return 0;
}

