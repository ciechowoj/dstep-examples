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
    makeSymbolicLink("../../libpng/pngconf.h", "output/libpng/pngconf.h");
    makeSymbolicLink("../../libpng/pnglibconf.h", "output/libpng/pnglibconf.h");

    // jpeg-9b
    ensureDirectoryExists("output/jpeg-9b");
    run([
        "dstep",
        "jpeg-9b/jconfig.h",
        "jpeg-9b/jpeglib.h",
        "--package", "jpeg-9b",
        "-Ijpeg-9b",
        resources,
        "-o", "output"]);

    makeSymbolicLink("../../jpeg-9b/jconfig.h", "output/jpeg-9b/jconfig.h");
    makeSymbolicLink("../../jpeg-9b/jpeglib.h", "output/jpeg-9b/jpeglib.h");

    // v4l-utils
    ensureDirectoryExists("output/v4l-utils");
    run([
        "dstep",
        "v4l-utils/include/gettext.h",
        "v4l-utils/include/linux/compiler.h",
        "v4l-utils/include/linux/fb.h",
        "v4l-utils/include/linux/ivtv.h",
        "v4l-utils/include/linux/media-bus-format.h",
        "v4l-utils/include/linux/media.h",
        "v4l-utils/include/linux/v4l2-common.h",
        "v4l-utils/include/linux/v4l2-controls.h",
        "v4l-utils/include/linux/v4l2-mediabus.h",
        "v4l-utils/include/linux/v4l2-subdev.h",
        "v4l-utils/include/linux/videodev2.h",
        "v4l-utils/include/linux/dvb/audio.h",
        "v4l-utils/include/linux/dvb/dmx.h",
        "v4l-utils/include/linux/dvb/frontend.h",
        "v4l-utils/include/linux/dvb/video.h",
        "--package", "v4l",
        "-Iv4l-utils/include",
        resources,
        "-o", "output"]);

    makeSymbolicLink("../../../v4l-utils/include/gettext.h", "output/v4l-utils/include/gettext.h");
    makeSymbolicLink("../../../../v4l-utils/include/linux/compiler.h", "output/v4l-utils/include/linux/compiler.h");
    makeSymbolicLink("../../../../v4l-utils/include/linux/fb.h", "output/v4l-utils/include/linux/fb.h");
    makeSymbolicLink("../../../../v4l-utils/include/linux/ivtv.h", "output/v4l-utils/include/linux/ivtv.h");
    makeSymbolicLink("../../../../v4l-utils/include/linux/media-bus-format.h", "output/v4l-utils/include/linux/media-bus-format.h");
    makeSymbolicLink("../../../../v4l-utils/include/linux/media.h", "output/v4l-utils/include/linux/media.h");
    makeSymbolicLink("../../../../v4l-utils/include/linux/v4l2-common.h", "output/v4l-utils/include/linux/v4l2-common.h");
    makeSymbolicLink("../../../../v4l-utils/include/linux/v4l2-controls.h", "output/v4l-utils/include/linux/v4l2-controls.h");
    makeSymbolicLink("../../../../v4l-utils/include/linux/v4l2-mediabus.h", "output/v4l-utils/include/linux/v4l2-mediabus.h");
    makeSymbolicLink("../../../../v4l-utils/include/linux/v4l2-subdev.h", "output/v4l-utils/include/linux/v4l2-subdev.h");
    makeSymbolicLink("../../../../v4l-utils/include/linux/videodev2.h", "output/v4l-utils/include/linux/videodev2.h");
    makeSymbolicLink("../../../../../v4l-utils/include/linux/dvb/audio.h", "output/v4l-utils/include/linux/dvb/audio.h");
    makeSymbolicLink("../../../../../v4l-utils/include/linux/dvb/dmx.h", "output/v4l-utils/include/linux/dvb/dmx.h");
    makeSymbolicLink("../../../../../v4l-utils/include/linux/dvb/frontend.h", "output/v4l-utils/include/linux/dvb/frontend.h");
    makeSymbolicLink("../../../../../v4l-utils/include/linux/dvb/video.h", "output/v4l-utils/include/linux/dvb/video.h");

    return 0;
}

