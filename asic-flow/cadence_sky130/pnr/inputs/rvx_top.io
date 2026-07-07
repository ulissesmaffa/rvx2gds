###############################################################
#  rvx_top.io — IO pad placement
#  Left + Bottom: GPIOs (lado 100% preenchido, sem filler)
#  Right: 4 power pads colados + filler acima
#  Top: filler apenas
#  Corners: sky130_ef_io__corner_pad (200 x 204, inteiro)
#  Die: 1040 x 1128
###############################################################
(globals
    version = 3
    io_order = default
)
(iopad
    (topleft
        (inst  name="PAD_connection/PAD_corner_ul"  orientation=MY   place_status=fixed)
    )
    (topright
        (inst  name="PAD_connection/PAD_corner_ur"  orientation=R0   place_status=fixed)
    )
    (bottomleft
        (inst  name="PAD_connection/PAD_corner_ll"  orientation=R180 place_status=fixed)
    )
    (bottomright
        (inst  name="PAD_connection/PAD_corner_lr"  orientation=MX   place_status=fixed)
    )
    (top
        (inst  name="PAD_connection/PAD_VDDR_io_0"    offset=200 orientation=R0 place_status=fixed)
        (inst  name="PAD_connection/PAD_GNDR_io_0"    space=0    orientation=R0 place_status=fixed)
        (inst  name="PAD_connection/PAD_VDD_core_0"   space=0    orientation=R0 place_status=fixed)
        (inst  name="PAD_connection/PAD_GND_core_0"   space=0    orientation=R0 place_status=fixed)
        (inst  name="PAD_connection/PAD_i2c_sda_in"   space=0    orientation=R0 place_status=fixed)
        (inst  name="PAD_connection/PAD_scan_en"      space=0    orientation=R0 place_status=fixed)
        (inst  name="PAD_connection/PAD_scan_in"      space=0    orientation=R0 place_status=fixed)
        (inst  name="PAD_connection/PAD_gpio_in_0"    space=0    orientation=R0 place_status=fixed)
        (inst  name="PAD_connection/PAD_uart_tx"      space=0    orientation=R0 place_status=fixed)
    )
    (left
        (inst  name="PAD_connection/PAD_clock"        offset=204 orientation=R90 place_status=fixed)
        (inst  name="PAD_connection/PAD_reset_n"      space=0    orientation=R90 place_status=fixed)
        (inst  name="PAD_connection/PAD_uart_rx"      space=0    orientation=R90 place_status=fixed)
        (inst  name="PAD_connection/PAD_miso"         space=0    orientation=R90 place_status=fixed)
        (inst  name="PAD_connection/PAD_VDDR_io_1"    space=0    orientation=R90 place_status=fixed)
        (inst  name="PAD_connection/PAD_GNDR_io_1"    space=0    orientation=R90 place_status=fixed)
        (inst  name="PAD_connection/PAD_VDD_core_1"   space=0    orientation=R90 place_status=fixed)
        (inst  name="PAD_connection/PAD_GND_core_1"   space=0    orientation=R90 place_status=fixed)
    )
    (bottom
        (inst  name="PAD_connection/PAD_mosi"         offset=200 orientation=R180 place_status=fixed)
        (inst  name="PAD_connection/PAD_cs"           space=0    orientation=R180 place_status=fixed)
        (inst  name="PAD_connection/PAD_i2c_sda_out"  space=0    orientation=R180 place_status=fixed)
        (inst  name="PAD_connection/PAD_i2c_scl_out"  space=0    orientation=R180 place_status=fixed)
        (inst  name="PAD_connection/PAD_VDDR_io_2"    space=0    orientation=R180 place_status=fixed)
        (inst  name="PAD_connection/PAD_GNDR_io_2"    space=0    orientation=R180 place_status=fixed)
        (inst  name="PAD_connection/PAD_VDD_core_2"   space=0    orientation=R180 place_status=fixed)
        (inst  name="PAD_connection/PAD_GND_core_2"   space=0    orientation=R180 place_status=fixed)

    )
    (right
        (inst  name="PAD_connection/PAD_VDDR_io_3"    offset=204 orientation=R270 place_status=fixed)
        (inst  name="PAD_connection/PAD_GNDR_io_3"    space=0    orientation=R270 place_status=fixed)
        (inst  name="PAD_connection/PAD_GND_core_3"   space=0    orientation=R270 place_status=fixed)
        (inst  name="PAD_connection/PAD_VDD_core_3"   space=0    orientation=R270 place_status=fixed)
        (inst  name="PAD_connection/PAD_scan_out"     space=0    orientation=R270 place_status=fixed)
        (inst  name="PAD_connection/PAD_gpio_oe_0"    space=0    orientation=R270 place_status=fixed)
        (inst  name="PAD_connection/PAD_gpio_out_0"   space=0    orientation=R270 place_status=fixed)
        (inst  name="PAD_connection/PAD_sclk"         space=0    orientation=R270 place_status=fixed)
    )
)