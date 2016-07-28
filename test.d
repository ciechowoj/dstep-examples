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

void makeSymbolicLink(string target, string link)
{
    execute(["ln", "-s", target, link]);
}

int main()
{
    string resources = "-I../dstep/resources";

    // fftw3
    ensureDirectoryExists("output/fftw");
    run(["dstep", "fftw3/api/fftw3.h", resources, "-o", "output/fftw/fftw3.d"]);
    execute(["ln", "-s", "../../fftw3/api/fftw3.h", "output/fftw/fftw3.h"]);

    // mathgl
    ensureDirectoryExists("output/mathgl/include/mgl2");
    run([
        "dstep",
        "mathgl/include/mgl2/base_cf.h",
        "mathgl/include/mgl2/canvas_cf.h",
        "mathgl/include/mgl2/datac_cf.h",
        "mathgl/include/mgl2/data_cf.h",
        "mathgl/include/mgl2/mgl_cf.h",
        "mathgl/include/mgl2/abstract.h",
        "--package", "mgl",
        "-Imathgl/include",
        "-std=c99",
        resources,
        "-o", "output",
        "-Wno-typedef-redefinition"]);

    makeSymbolicLink("../../../../mathgl/include/mgl2/base_cf.h", "output/mathgl/include/mgl2/base_cf.h");
    makeSymbolicLink("../../../../mathgl/include/mgl2/canvas_cf.h", "output/mathgl/include/mgl2/canvas_cf.h");
    makeSymbolicLink("../../../../mathgl/include/mgl2/datac_cf.h", "output/mathgl/include/mgl2/datac_cf.h");
    makeSymbolicLink("../../../../mathgl/include/mgl2/data_cf.h", "output/mathgl/include/mgl2/data_cf.h");
    makeSymbolicLink("../../../../mathgl/include/mgl2/mgl_cf.h", "output/mathgl/include/mgl2/mgl_cf.h");
    makeSymbolicLink("../../../../mathgl/include/mgl2/abstract.h", "output/mathgl/include/mgl2/abstract.h");

    // glfw-3.2
    ensureDirectoryExists("output/glfw-3.2/include/GLFW");
    run([
        "dstep",
        "glfw-3.2/include/GLFW/glfw3.h",
        "glfw-3.2/include/GLFW/glfw3native.h",
        "--package", "glfw3",
        "-Iglfw-3.2/include",
        resources,
        "-o", "output"]);

    makeSymbolicLink("../../../../glfw-3.2/include/GLFW/glfw3.h", "output/glfw-3.2/include/GLFW/glfw3.h");
    makeSymbolicLink("../../../../glfw-3.2/include/GLFW/glfw3native.h", "output/glfw-3.2/include/GLFW/glfw3native.h");

    // zlib
    ensureDirectoryExists("output/zlib");
    run([
        "dstep",
        "zlib/zconf.h",
        "zlib/zlib.h",
        "--package", "zlib",
        "-Izlib",
        resources,
        "-o", "output"]);

    makeSymbolicLink("../../zlib/zconf.h", "output/zlib/zconf.h");
    makeSymbolicLink("../../zlib/zlib.h", "output/zlib/zlib.h");

    // libpng
    ensureDirectoryExists("output/libpng");
    run([
        "dstep",
        "libpng/png.h",
        "libpng/pngconf.h",
        "libpng/pnglibconf.h",
        "--package", "libpng",
        "-Ilibpng",
        resources,
        "-o", "output"]);

    makeSymbolicLink("../../libpng/png.h", "output/libpng/png.h");


    return 0;


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

