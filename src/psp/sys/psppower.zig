usingnamespace @import("psptypes.zig");

pub const powerCallback_t = ?fn (c_int, c_int) callconv(.C) void;
pub extern fn scePowerRegisterCallback(slot: c_int, cbid: SceUID) c_int;
pub extern fn scePowerUnregisterCallback(slot: c_int) c_int;
pub extern fn scePowerIsPowerOnline() c_int;
pub extern fn scePowerIsBatteryExist() c_int;
pub extern fn scePowerIsBatteryCharging() c_int;
pub extern fn scePowerGetBatteryChargingStatus() c_int;
pub extern fn scePowerIsLowBattery() c_int;
pub extern fn scePowerGetBatteryLifePercent() c_int;
pub extern fn scePowerGetBatteryLifeTime() c_int;
pub extern fn scePowerGetBatteryTemp() c_int;
pub extern fn scePowerGetBatteryElec() c_int;
pub extern fn scePowerGetBatteryVolt() c_int;
pub extern fn scePowerSetCpuClockFrequency(cpufreq: c_int) c_int;
pub extern fn scePowerSetBusClockFrequency(busfreq: c_int) c_int;
pub extern fn scePowerGetCpuClockFrequency() c_int;
pub extern fn scePowerGetCpuClockFrequencyInt() c_int;
pub extern fn scePowerGetCpuClockFrequencyFloat() f32;
pub extern fn scePowerGetBusClockFrequency() c_int;
pub extern fn scePowerGetBusClockFrequencyInt() c_int;
pub extern fn scePowerGetBusClockFrequencyFloat() f32;
pub extern fn scePowerSetClockFrequency(pllfreq: c_int, cpufreq: c_int, busfreq: c_int) c_int;
pub extern fn scePowerLock(unknown: c_int) c_int;
pub extern fn scePowerUnlock(unknown: c_int) c_int;
pub extern fn scePowerTick(type: c_int) c_int;
pub extern fn scePowerGetIdleTimer() c_int;
pub extern fn scePowerIdleTimerEnable(unknown: c_int) c_int;
pub extern fn scePowerIdleTimerDisable(unknown: c_int) c_int;
pub extern fn scePowerRequestStandby() c_int;
pub extern fn scePowerRequestSuspend() c_int;

pub const PSPPowerCB = extern enum(u32){
    Battpower = 0x0000007f,
    BatteryExist = 0x00000080,
    BatteryLow = 0x00000100,
    ACPower = 0x00001000,
    Suspending = 0x00010000,
    Resuming = 0x00020000,
    ResumeComplete = 0x00040000,
    Standby = 0x00080000,
    HoldSwitch = 0x40000000,
    PowerSwitch = 0x80000000,
};

pub const PSPPowerTick = extern enum(u32){
    All = 0,
    Suspend = 1,
    Display = 6
};

const macro = @import("pspmacros.zig");

comptime{
    asm(macro.import_module_start("scePower", "0x40010000", "46"));
    asm(macro.import_function("scePower", "0x2B51FE2F", "scePower_2B51FE2F"));
    asm(macro.import_function("scePower", "0x442BFBAC", "scePower_442BFBAC"));
    asm(macro.import_function("scePower", "0xEFD3C963", "scePowerTick"));
    asm(macro.import_function("scePower", "0xEDC13FE5", "scePowerGetIdleTimer"));
    asm(macro.import_function("scePower", "0x7F30B3B1", "scePowerIdleTimerEnable"));
    asm(macro.import_function("scePower", "0x972CE941", "scePowerIdleTimerDisable"));
    asm(macro.import_function("scePower", "0x27F3292C", "scePowerBatteryUpdateInfo"));
    asm(macro.import_function("scePower", "0xE8E4E204", "scePower_E8E4E204"));
    asm(macro.import_function("scePower", "0xB999184C", "scePowerGetLowBatteryCapacity"));
    asm(macro.import_function("scePower", "0x87440F5E", "scePowerIsPowerOnline"));
    asm(macro.import_function("scePower", "0x0AFD0D8B", "scePowerIsBatteryExist"));
    asm(macro.import_function("scePower", "0x1E490401", "scePowerIsBatteryCharging"));
    asm(macro.import_function("scePower", "0xB4432BC8", "scePowerGetBatteryChargingStatus"));
    asm(macro.import_function("scePower", "0xD3075926", "scePowerIsLowBattery"));
    asm(macro.import_function("scePower", "0x78A1A796", "scePower_78A1A796"));
    asm(macro.import_function("scePower", "0x94F5A53F", "scePowerGetBatteryRemainCapacity"));
    asm(macro.import_function("scePower", "0xFD18A0FF", "scePower_FD18A0FF"));
    asm(macro.import_function("scePower", "0x2085D15D", "scePowerGetBatteryLifePercent"));
    asm(macro.import_function("scePower", "0x8EFB3FA2", "scePowerGetBatteryLifeTime"));
    asm(macro.import_function("scePower", "0x28E12023", "scePowerGetBatteryTemp"));
    asm(macro.import_function("scePower", "0x862AE1A6", "scePowerGetBatteryElec"));
    asm(macro.import_function("scePower", "0x483CE86B", "scePowerGetBatteryVolt"));
    asm(macro.import_function("scePower", "0x23436A4A", "scePower_23436A4A"));
    asm(macro.import_function("scePower", "0x0CD21B1F", "scePower_0CD21B1F"));
    asm(macro.import_function("scePower", "0x165CE085", "scePower_165CE085"));
    asm(macro.import_function("scePower", "0xD6D016EF", "scePowerLock"));
    asm(macro.import_function("scePower", "0xCA3D34C1", "scePowerUnlock"));
    asm(macro.import_function("scePower", "0xDB62C9CF", "scePowerCancelRequest"));
    asm(macro.import_function("scePower", "0x7FA406DD", "scePowerIsRequest"));
    asm(macro.import_function("scePower", "0x2B7C7CF4", "scePowerRequestStandby"));
    asm(macro.import_function("scePower", "0xAC32C9CC", "scePowerRequestSuspend"));
    asm(macro.import_function("scePower", "0x2875994B", "scePower_2875994B"));
    asm(macro.import_function("scePower", "0x3951AF53", "scePowerEncodeUBattery"));
    asm(macro.import_function("scePower", "0x0074EF9B", "scePowerGetResumeCount"));
    asm(macro.import_function("scePower", "0x04B7766E", "scePowerRegisterCallback"));
    asm(macro.import_function("scePower", "0xDFA8BAF8", "scePowerUnregisterCallback"));
    asm(macro.import_function("scePower", "0xDB9D28DD", "scePowerUnregitserCallback"));
    asm(macro.import_function("scePower", "0x843FBF43", "scePowerSetCpuClockFrequency"));
    asm(macro.import_function("scePower", "0xB8D7B3FB", "scePowerSetBusClockFrequency"));
    asm(macro.import_function("scePower", "0xFEE03A2F", "scePowerGetCpuClockFrequency"));
    asm(macro.import_function("scePower", "0x478FE6F5", "scePowerGetBusClockFrequency"));
    asm(macro.import_function("scePower", "0xFDB5BFE9", "scePowerGetCpuClockFrequencyInt"));
    asm(macro.import_function("scePower", "0xBD681969", "scePowerGetBusClockFrequencyInt"));
    asm(macro.import_function("scePower", "0xB1A52C83", "scePowerGetCpuClockFrequencyFloat"));
    asm(macro.import_function("scePower", "0x9BADB3EB", "scePowerGetBusClockFrequencyFloat"));
    asm(macro.import_function("scePower", "0x737486F2", "scePowerSetClockFrequency"));
}