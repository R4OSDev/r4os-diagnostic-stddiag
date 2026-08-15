const r4os = @import("r4os");
const r4std = @import("r4std");

pub fn r4_app_main(r4_app: *r4os.App) i32 {
    if (!r4std.init(r4_app.startContext())) return r4os.abi.err_no_group;
    const ctx = r4_app.system();
    var ok = true;

    ctx.println("STDDIAG");
    ok = checkMetadata(&ctx) and ok;
    ok = checkDateCore(&ctx) and ok;
    ok = checkCurrentTime(&ctx) and ok;

    ctx.print("STDDIAG result: ");
    ctx.println(if (ok) "OK" else "FAILED");
    return if (ok) 0 else 1;
}

fn checkMetadata(ctx: *const r4os.r4sys.Context) bool {
    const ok = equals(r4std.name, "R4STD") and
        equals(r4std.import_date_v1, "R4STD:DATE_V1:1") and
        equals(r4std.import_time_v1, "R4STD:TIME_V1:1");
    printCheck(ctx, "R4STD tables", ok);
    return ok;
}

fn checkDateCore(ctx: *const r4os.r4sys.Context) bool {
    var ok = true;
    ok = r4std.date.validDateValue(2000, 2, 29) and ok;
    ok = !r4std.date.validDateValue(1900, 2, 29) and ok;
    ok = !r4std.date.validDateValue(2026, 2, 29) and ok;
    ok = !r4std.date.validDateValue(2026, 13, 1) and ok;
    ok = !r4std.date.validDateValue(2026, 1, 0) and ok;

    var date_buf: [11]u8 = .{0} ** 11;
    const formatted = r4std.date.formatDateIso(date_buf[0..], .{ .year = 2026, .month = 6, .day = 3 });
    ok = equals(formatted, "2026-06-03") and ok;
    ok = r4std.date.parseDateIso("2026-06-03") != null and ok;
    ok = r4std.date.parseDateIso("2026-02-29") == null and ok;
    printCheck(ctx, "date core", ok);
    return ok;
}

fn checkCurrentTime(ctx: *const r4os.r4sys.Context) bool {
    var status: r4os.abi.TimeServiceStatus = .{};
    const service_ok = ctx.timeServiceStatus(&status) == r4os.abi.service_api_result_ok;
    const state = ctx.timeState();
    const time = if (service_ok)
        r4std.time.splitTime(status.local_seconds_since_midnight)
    else
        r4std.time.splitTime(state.seconds_since_midnight);
    const clock_format = if (service_ok) @as(u32, status.clock_format) else r4os.abi.clock_format_24h;
    var time_buf: [12]u8 = .{0} ** 12;
    const formatted = r4std.time.formatDisplay(time_buf[0..], time, clock_format);
    const ok = formatted.len >= 8;
    ctx.write("  current time: ");
    ctx.println(formatted);
    printCheck(ctx, "current time", ok);
    return ok;
}

fn printCheck(ctx: *const r4os.r4sys.Context, name: []const u8, ok: bool) void {
    ctx.write("  ");
    ctx.write(name);
    ctx.write(": ");
    ctx.println(if (ok) "OK" else "FAILED");
}

fn equals(a: []const u8, b: []const u8) bool {
    if (a.len != b.len) return false;
    var i: usize = 0;
    while (i < a.len) : (i += 1) {
        if (a[i] != b[i]) return false;
    }
    return true;
}
