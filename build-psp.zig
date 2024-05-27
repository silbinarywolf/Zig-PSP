const z = @import("std").zig;
const std = @import("std");
const builtin = std.builtin;

pub const PSPBuildInfo = struct {
    //SDK Path
    path_to_sdk: []const u8,
    src_file: []const u8,
    //Title
    title: []const u8,
    //Optional customizations
    icon0: []const u8 = "NULL",
    icon1: []const u8 = "NULL",
    pic0: []const u8 = "NULL",
    pic1: []const u8 = "NULL",
    snd0: []const u8 = "NULL",
};

const append: []const u8 = switch (builtin.os.tag) {
    .windows => ".exe",
    else => "",
};

pub fn build_psp(b: *std.Build, comptime build_info: PSPBuildInfo) !void {
    var feature_set: std.Target.Cpu.Feature.Set = std.Target.Cpu.Feature.Set.empty;
    feature_set.addFeature(@intFromEnum(std.Target.mips.Feature.single_float));

    //PSP-Specific Build Options
    // const target = z.CrossTarget{};
    // const target = b.standardTargetOptions(.{ .whitelist = &.{.{
    // }} });
    const target = b.resolveTargetQuery(.{
        .cpu_arch = .mipsel,
        .os_tag = .freestanding,
        .cpu_model = .{ .explicit = &std.Target.mips.cpu.mips2 },
        .cpu_features_add = feature_set,
    });

    //All of the release modes work
    //Debug Mode can cause issues with trap instructions - use ReleaseSafe for "Debug" builds
    const optimize = builtin.Mode.ReleaseSmall;

    //Build from your main file!
    const exe = b.addExecutable(.{
        .name = "main",
        .root_source_file = b.path(build_info.src_file),
        .target = target,
        .optimize = optimize,
        // .strip = true,
        // .single_threaded = true,
    });

    // NOTE(jae): 2024-05-27
    // commented out to reduce / simplify repro
    // exe.setLinkerScriptPath(b.path(build_info.path_to_sdk ++ "tools/linkfile.ld"));

    // NOTE(jae): 2024-05-27
    // commented out to reduce / simplify repro
    // exe.link_eh_frame_hdr = true;
    // exe.link_emit_relocs = true;

    b.installArtifact(exe);
}
