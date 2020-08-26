usingnamespace @import("constants.zig");
usingnamespace @import("../sys/pspge.zig");
usingnamespace @import("../sys/pspdisplay.zig");
usingnamespace @import("../sys/pspstdio.zig");
usingnamespace @import("../sys/pspiofilemgr.zig");
usingnamespace @import("../sys/pspthreadman.zig");
usingnamespace @import("../sys/psploadexec.zig");
usingnamespace @import("../sys/psprtc.zig");
const builtin = @import("builtin");

//Internal variables for the screen
var x : u8 = 0;
var y : u8 = 0;
var vram_off: i32 = 0;
var vram_base: ?[*]u32 = null;

//Gets your "cursor" X position
pub fn screenGetX() u8 {
    return x;
}

//Gets your "cursor" Y position
pub fn screenGetY() u8 {
    return y;
}

//Sets the "cursor" position
pub fn screenSetXY(sX : u8, sY : u8) void{
    x = sX;
    y = sY;
}

//Clears the screen to the clear color (default is black)
pub fn screenClear() void{
    var i: usize = 0;
    while (i < SCR_BUF_WIDTH * SCREEN_HEIGHT) : (i += 1) {
        vram_base.?[i] = cl_col;
    }
}

//Color variables
var cl_col : u32 = 0xFF000000;
var bg_col : u32 = 0x00000000;
var fg_col : u32 = 0xFFFFFFFF;

//Set the background color
pub fn screenSetClearColor(color: u32) void{
    cl_col = color;
}

var back_col_enable : bool = false;

//Enable text highlight
pub fn screenEnableBackColor() void {
    back_col_enable = true;
}

//Disable text highlight
pub fn screenDisableBackColor() void {
    back_col_enable = false;
}

//Set highlight color
pub fn screenSetBackColor(color: u32) void{
    bg_col = color;
}

//Set text color
pub fn screenSetFrontColor(color: u32) void{
    fg_col = color;
}

//Initialize the screen
pub fn screenInit() void {
    x = 0;
    y = 0;
    vram_off = 0;

    vram_base = @intToPtr(?[*]u32, 0x40000000 | @ptrToInt(sceGeEdramGetAddr()));
    
    var stat: i32 = 0;
    stat = sceDisplaySetMode(0, SCREEN_WIDTH, SCREEN_HEIGHT);
    stat = sceDisplaySetFrameBuf(vram_base, SCR_BUF_WIDTH, @enumToInt(PspDisplayPixelFormats.Format8888), 1);

    screenClear();
}

//Print out a constant string
pub fn print(text: []const u8) void {
    var i : usize = 0;
    while(i < text.len) : (i += 1){
        
        if(text[i] == '\n'){
            y += 1;
            x = 0;
        }else if(text[i] == '\t'){
            x += 4;
        }else{
            internal_putchar(@as(u32,x) * 8, @as(u32,y) * 8, text[i]);
            x += 1;
        }

        if(x > 60){
            x = 0;
            y += 1;
            if(y > 34){
                y = 0;
                screenClear();
            }
        }
    }
}

usingnamespace @import("utils.zig");
const std = @import("std");

//Print with formatting via the default PSP allocator
pub fn printFormat(comptime fmt: []const u8, args: var) !void {
    var psp_allocator = &PSPAllocator.init().allocator;

    var string = try std.fmt.allocPrint(psp_allocator, fmt, args);
    defer psp_allocator.free(string);
    
    print(string);
}

//Our font
const msxFont = @embedFile("./msxfont.bin");

//Puts a character to screen
fn internal_putchar(cx: u32, cy: u32, ch: u8) void{
    var off : usize = cx + (cy * SCR_BUF_WIDTH);
    
    var i : usize = 0;
    while (i < 8) : (i += 1){
        
        var j: usize = 0;

        while(j < 8) : (j += 1){

            const mask : u32 = 128;

            var idx : u32 = @as(u32, ch) * 8 + i;
            var glyph : u8 = msxFont[idx];
            
            if( (glyph & (mask >> @intCast(@import("std").math.Log2Int(c_int), j))) != 0 ){
                vram_base.?[j + i * SCR_BUF_WIDTH + off] = fg_col;
            }else if(back_col_enable){
                vram_base.?[j + i * SCR_BUF_WIDTH + off] = bg_col;
            }

        }
    }

}

usingnamespace @import("module.zig");


//Meme panic
pub var pancakeMode : bool = false;

//Panic handler
//Import this in main to use!
pub fn panic(message: []const u8, stack_trace: ?*builtin.StackTrace) noreturn {
    screenInit();
    
    if(pancakeMode){
        //For @mrneo240
        print("!!! PSP HAS PANCAKED !!!\n");
    }else{
        print("!!! PSP HAS PANICKED !!!\n");
    }
    
    print("REASON: ");
    print(message);
    print("\nZig-PSP doesn't support stack traces - yet.\n");
    print("Exiting in 10 seconds...");
    
    exitErr();
    while(true){}
}

//ADD MORE STUFF HERE LIKE BENCHMARKING, CPU PROFILING, ETC.


var current_time : u64 = 0;
var tickRate : u32 = 0;

//Starts a benchmark
pub fn benchmark_start() void {
    tickRate = sceRtcGetTickResolution();
    _ = sceRtcGetCurrentTick(&current_time);
}

//Ends the benchmark and reports ticks & time
pub fn benchmark_end() !u64{
    var oldTime = current_time;
    _ = sceRtcGetCurrentTick(&current_time);

    var delta = current_time - oldTime;

    var deltaF = @intToFloat(f64, delta);
    var tickRF = @intToFloat(f32, tickRate);

    try printFormat("Method took {} ticks. ({d} ms)\n", .{delta, deltaF / tickRF * 1000});


    return delta;
}