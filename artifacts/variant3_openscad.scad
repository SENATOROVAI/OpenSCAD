// Вариант 3. Параметрическая модель для получения скриншотов в OpenSCAD.
// Используй переменную scene_mode:
// 0 - деталь
// 1 - заготовка
// 2 - деталь и заготовка рядом

scene_mode = 0;

$fn = 120;

L1 = 135;
L2 = 25;
L3 = 26;
L4 = 33;
R1 = 17;
R2 = 25;
R3 = 30;
R4 = 20;
R5 = 16;
B1 = 16;
B2 = 19.5;
H  = 12;

stock_x = 145;
stock_y = 60;
stock_z = H;

module rounded_slot(len, height, rad) {
    hull() {
        translate([rad, rad]) circle(r = rad);
        translate([len - rad, rad]) circle(r = rad);
        translate([rad, height - rad]) circle(r = rad);
        translate([len - rad, height - rad]) circle(r = rad);
    }
}

module outer_profile() {
    // Упрощенный контур по эскизу варианта 3:
    // низ прямой, слева скругление и сверху плавный подъем с правым радиусным окончанием.
    linear_extrude(height = H)
    polygon(points = [
        [0, 0],
        [0, B2],
        [12, 34],
        [45, 46],
        [70, 55],
        [98, 48],
        [118, 36],
        [L1, B2],
        [L1, 0]
    ]);
}

module outer_profile_smooth() {
    linear_extrude(height = H)
    offset(r = 6)
    offset(delta = -6)
    polygon(points = [
        [0, 0],
        [0, B2],
        [12, 34],
        [45, 46],
        [70, 55],
        [98, 48],
        [118, 36],
        [L1, B2],
        [L1, 0]
    ]);
}

module inner_cut() {
    translate([L2 - 2, 3.5, -0.1])
    linear_extrude(height = H + 0.2)
    rounded_slot(89, 30, 15);
}

module detail_part() {
    difference() {
        color([0.82, 0.86, 0.93]) outer_profile_smooth();
        inner_cut();
    }
}

module stock_part() {
    color([0.88, 0.88, 0.88])
    cube([stock_x, stock_y, stock_z]);
}

module scene_detail() {
    rotate([65, 0, 35]) detail_part();
}

module scene_stock() {
    rotate([65, 0, 35]) stock_part();
}

module scene_both() {
    translate([-90, 0, 0]) rotate([65, 0, 35]) stock_part();
    translate([80, 0, 0]) rotate([65, 0, 35]) detail_part();
}

if (scene_mode == 0) {
    scene_detail();
} else if (scene_mode == 1) {
    scene_stock();
} else {
    scene_both();
}
