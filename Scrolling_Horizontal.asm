#import "helpers.asm"
#import "wait_functions.asm"

.label border = $d020
.label background = $d021

.label cia1_interrupt_control_register = $dc0d
.label cia2_interrupt_control_register = $dd0d

// The animation skips these many frames in between 'active' frames:
// 0 means "max animation speed", for instance 50 Hz on PAL, and 60 on NTSC.
// 1 means "display one frame then repeat the next": the animation is 25 Hz on PAL.
.const RASTER_LINE_UP = 51+4-2-1
//.const RASTER_LINE_DOWN = 251-2
.const SPRITE_BITMAPS = 255-8

.const VIC2 = $d000
.namespace Sprites {
  .label positions = VIC2
  .label position_x_high_bits = VIC2 + 16
  .label enable_bits = VIC2 + 21
  .label vertical_stretch_bits = VIC2 + 23
  .label horizontal_stretch_bits = VIC2 + 29
  .label colors = VIC2 + 39
  .label pointers = screen + 1024 - 8
}

:BasicUpstart2(main)
main:
  sei
    lda #WHITE
    sta background
    sta border
    clear_screen(96)
    randomize_screen()

    lda #$17                          //Default: 0001 1011
    sta vic2_screen_control_register1 //Now:     0001 0111 //#3:24 rows
    lda #$c7                          //Default: 1100 1000
    sta vic2_screen_control_register2 //Now:     1100 0111 //#3:38 cols
    lda #8 //8 == 7+1
    sta $fe //XSCROLL

    lda $01
    and #%11111101
    sta $01

    lda #%01111111
    sta cia1_interrupt_control_register
    sta cia2_interrupt_control_register
    lda cia1_interrupt_control_register
    lda cia2_interrupt_control_register

    lda #%00000001
    sta vic2_interrupt_control_register
    sta vic2_interrupt_status_register
    :set_raster(RASTER_LINE_UP)
    :mov16 #irq1 : $fffe
  cli

loop:
  jmp loop

irq1:
  :stabilize_irq() //RL50:3
  :cycles(-3 +63 -5-8-13)
  dec $fe //(5) 8 -> 7
  lda $fe //(3)
  and #$07 //(2)
  sta $fe //(3)
  lda vic2_screen_control_register2 //(4)
  and #$f8 //(2)
  eor $fe //(3)
// Rows from 1 to 3.
  sta vic2_screen_control_register2 //(4) RL50:63
  jsr wait_2_rows_with_20_cycles_bad_lines // RL66:63
  jsr wait_one_bad_line_minus_3 // RL67:63 
  jsr wait_one_good_line // RL68:63
  jsr wait_one_good_line // RL69:63
  jsr wait_one_good_line // RL70:63
  jsr wait_one_good_line // RL71:63
  jsr wait_one_good_line // RL72:63
  jsr wait_one_good_line // RL73:63
  :cycles(63 -5-8-13)
  dec $fe //(5) 7 -> 6
  lda $fe //(3)
  and #$07 //(2)
  sta $fe //(3)
  lda vic2_screen_control_register2 //(4)
  and #$f8 //(2)
  eor $fe //(3)
// Rows from 4 to 6.
  sta vic2_screen_control_register2 //(4) RL74:63
  jsr wait_2_rows_with_20_cycles_bad_lines // RL66:63
  jsr wait_one_bad_line_minus_3 // RL67:63
  jsr wait_one_good_line // RL68:63
  jsr wait_one_good_line // RL69:63
  jsr wait_one_good_line // RL70:63
  jsr wait_one_good_line // RL71:63
  jsr wait_one_good_line // RL72:63
  jsr wait_one_good_line // RL73:63
  :cycles(63 -5-8-13)
  dec $fe //(5) 6 -> 5
  lda $fe //(3)
  and #$07 //(2)
  sta $fe //(3)
  lda vic2_screen_control_register2 //(4)
  and #$f8 //(2)
  eor $fe //(3) RL74:63
// Rows from 7 to 9.
  sta vic2_screen_control_register2 //(4)
  jsr wait_2_rows_with_20_cycles_bad_lines // RL66:63
  jsr wait_one_bad_line_minus_3 // RL67:63
  jsr wait_one_good_line // RL68:63
  jsr wait_one_good_line // RL69:63
  jsr wait_one_good_line // RL70:63
  jsr wait_one_good_line // RL71:63
  jsr wait_one_good_line // RL72:63
  jsr wait_one_good_line // RL73:63
  :cycles(63 -5-8-13)
  dec $fe //(5) 5 -> 4
  lda $fe //(3)
  and #$07 //(2)
  sta $fe //(3)
  lda vic2_screen_control_register2 //(4)
  and #$f8 //(2)
  eor $fe //(3) RL74:63
// Rows from 10 to 12.
  sta vic2_screen_control_register2 //(4)
  jsr wait_2_rows_with_20_cycles_bad_lines // RL66:63
  jsr wait_one_bad_line_minus_3 // RL67:63
  jsr wait_one_good_line // RL68:63
  jsr wait_one_good_line // RL69:63
  jsr wait_one_good_line // RL70:63
  jsr wait_one_good_line // RL71:63
  jsr wait_one_good_line // RL72:63
  jsr wait_one_good_line // RL73:63
  :cycles(63 -5-8-13)
  dec $fe //(5) 4 -> 3
  lda $fe //(3)
  and #$07 //(2)
  sta $fe //(3)
  lda vic2_screen_control_register2 //(4)
  and #$f8 //(2)
  eor $fe //(3) RL74:63
// Rows from 13 to 15.
  sta vic2_screen_control_register2 //(4)
  jsr wait_2_rows_with_20_cycles_bad_lines // RL66:63
  jsr wait_one_bad_line_minus_3 // RL67:63
  jsr wait_one_good_line // RL68:63
  jsr wait_one_good_line // RL69:63
  jsr wait_one_good_line // RL70:63
  jsr wait_one_good_line // RL71:63
  jsr wait_one_good_line // RL72:63
  jsr wait_one_good_line // RL73:63
  :cycles(63 -5-8-13)
  dec $fe //(5) 3 -> 2
  lda $fe //(3)
  and #$07 //(2)
  sta $fe //(3)
  lda vic2_screen_control_register2 //(4)
  and #$f8 //(2)
  eor $fe //(3) RL74:63
// Rows from 16 to 18.
  sta vic2_screen_control_register2 //(4)
  jsr wait_2_rows_with_20_cycles_bad_lines // RL66:63
  jsr wait_one_bad_line_minus_3 // RL67:63
  jsr wait_one_good_line // RL68:63
  jsr wait_one_good_line // RL69:63
  jsr wait_one_good_line // RL70:63
  jsr wait_one_good_line // RL71:63
  jsr wait_one_good_line // RL72:63
  jsr wait_one_good_line // RL73:63
  :cycles(63 -5-8-13)
  dec $fe //(5) 2 -> 1
  lda $fe //(3)
  and #$07 //(2)
  sta $fe //(3)
  lda vic2_screen_control_register2 //(4)
  and #$f8 //(2)
  eor $fe //(3) RL74:63
// Rows from 19 to 21.
  sta vic2_screen_control_register2 //(4)
  jsr wait_2_rows_with_20_cycles_bad_lines // RL66:63
  jsr wait_one_bad_line_minus_3 // RL67:63
  jsr wait_one_good_line // RL68:63
  jsr wait_one_good_line // RL69:63
  jsr wait_one_good_line // RL70:63
  jsr wait_one_good_line // RL71:63
  jsr wait_one_good_line // RL72:63
  jsr wait_one_good_line // RL73:63
  :cycles(63 -5-8-13)
  dec $fe //(5) 1 -> 0
  lda $fe //(3)
  and #$07 //(2)
  sta $fe //(3)
  lda vic2_screen_control_register2 //(4)
  and #$f8 //(2)
  eor $fe //(3) RL74:63
// Rows from 22 to 24.
  sta vic2_screen_control_register2 //(4)
  jsr wait_2_rows_with_20_cycles_bad_lines
  jsr wait_1_row_with_20_cycles_bad_line

//lda #8+1
//sta $fe
//jmp exiting_irq1

check_0:
  lda $fe
  cmp #0
  bne check_7
  :scroll_rows_21_to_23()
  jmp exiting_irq1
check_7:
  lda $fe
  cmp #7
  bne check_6
  :scroll_rows_18_to_20()
  jmp exiting_irq1
check_6:
  lda $fe
  cmp #6
  bne check_5
  :scroll_rows_15_to_17()
  jmp exiting_irq1
check_5:
  lda $fe
  cmp #5
  bne check_4
  :scroll_rows_12_to_14()
  jmp exiting_irq1
check_4:
  lda $fe
  cmp #4
  bne check_3
  :scroll_rows_9_to_11()
  jmp exiting_irq1
check_3:
  lda $fe
  cmp #3
  bne check_2
  :scroll_rows_6_to_8()
  jmp exiting_irq1
check_2:
  lda $fe
  cmp #2
  bne check_1
  :scroll_rows_3_to_5()
  jmp exiting_irq1
check_1:
  lda $fe
  cmp #1
  bne exiting_irq1
  :scroll_rows_0_to_2()

exiting_irq1:
  dec $fe //(5) 0 -> $ff => $ff-1 = $fe => $fe AND $07 -> $06
  asl vic2_interrupt_status_register
  :set_raster(RASTER_LINE_UP)
  :mov16 #irq1 : $fffe
  rti

/*
 * Scroll functions.
*/
.macro scroll_rows_21_to_23() {
  dec border
  .for (var row = 7*3; row < 8*3; row++) {
    ldy $0400 + row * 40
    ldx #1
  continueRow:
    lda $0400 + row * 40,x
    sta $0400 + row * 40 - 1,x
    inx
    cpx #40
    bne continueRow
    sty $0400 + row * 40 + 40 - 1
  }
  inc border
}
.macro scroll_rows_18_to_20() {
  dec border
  .for (var row = 6*3; row < 7*3; row++) {
  // row 0
    ldy $0400 + row * 40
    ldx #1
  continueRow:
    lda $0400 + row * 40,x
    sta $0400 + row * 40 - 1,x
    inx
    cpx #40
    bne continueRow
    sty $0400 + row * 40 + 40 - 1
  }
  inc border
}
.macro scroll_rows_15_to_17() {
  dec border
  .for (var row = 5*3; row < 6*3; row++) {
  // row 0
    ldy $0400 + row * 40
    ldx #1
  continueRow:
    lda $0400 + row * 40,x
    sta $0400 + row * 40 - 1,x
    inx
    cpx #40
    bne continueRow
    sty $0400 + row * 40 + 40 - 1
  }
  inc border
}
.macro scroll_rows_12_to_14() {
  dec border
  .for (var row = 4*3; row < 5*3; row++) {
  // row 0
    ldy $0400 + row * 40
    ldx #1
  continueRow:
    lda $0400 + row * 40,x
    sta $0400 + row * 40 - 1,x
    inx
    cpx #40
    bne continueRow
    sty $0400 + row * 40 + 40 - 1
  }
  inc border
}
.macro scroll_rows_9_to_11() {
  dec border
  .for (var row = 3*3; row < 4*3; row++) {
  // row 0
    ldy $0400 + row * 40
    ldx #1
  continueRow:
    lda $0400 + row * 40,x
    sta $0400 + row * 40 - 1,x
    inx
    cpx #40
    bne continueRow
    sty $0400 + row * 40 + 40 - 1
  }
  inc border
}
.macro scroll_rows_6_to_8() {
  dec border
  .for (var row = 2*3; row < 3*3; row++) {
  // row 0
    ldy $0400 + row * 40
    ldx #1
  continueRow:
    lda $0400 + row * 40,x
    sta $0400 + row * 40 - 1,x
    inx
    cpx #40
    bne continueRow
    sty $0400 + row * 40 + 40 - 1
  }
  inc border
}
.macro scroll_rows_3_to_5() {
  dec border
  .for (var row = 1*3; row < 2*3; row++) {
  // row 0
    ldy $0400 + row * 40
    ldx #1
  continueRow:
    lda $0400 + row * 40,x
    sta $0400 + row * 40 - 1,x
    inx
    cpx #40
    bne continueRow
    sty $0400 + row * 40 + 40 - 1
  }
  inc border
}
.macro scroll_rows_0_to_2() {
  dec border
  .for (var row = 0*3; row < 1*3; row++) {
  // row 0
    ldy $0400 + row * 40
    ldx #1
  continueRow:
    lda $0400 + row * 40,x
    sta $0400 + row * 40 - 1,x
    inx
    cpx #40
    bne continueRow
    sty $0400 + row * 40 + 40 - 1
  }
  inc border
}
