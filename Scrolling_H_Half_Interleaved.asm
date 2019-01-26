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
    lda #BLACK
    sta background
    //lda #WHITE
    sta border
    clear_screen(96)
    randomize_screen()

    lda #$17                          //Default: 0001 1011
    sta vic2_screen_control_register1 //Now:     0001 0111 //#3:24 rows
    lda #$cf//7                       //Default: 1100 1000
    sta vic2_screen_control_register2 //Now:     1100 1111 //#3:40 cols
    lda #7+1 //XSCROLL is decremented as soon as scrolling starts.
    sta $fe //Buffers the current value of the XSCROLL bit field.

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
  :stabilize_irq() //RL54:3
  :cycles(-3 +63 -5-8-13)
  dec $fe //(5) 8 -> 7
  lda $fe //(3)
  and #$07 //(2)
  sta $fe //(3)
  lda vic2_screen_control_register2 //(4)
  and #$f8 //(2)
  eor $fe //(3)
// Row 1
  sta vic2_screen_control_register2 //(4) RL54:63
  jsr wait_one_bad_line_minus_3 // RL55:63 
  jsr wait_6_good_lines // RL61:63
  :cycles(63 -4*5-8-13)
  dec $fe //(5) 7 ->
  dec $fe //(5)
  dec $fe //(5)
  dec $fe //(5)  -> 3
  lda $fe //(3)
  and #$07 //(2)
  sta $fe //(3)
  lda vic2_screen_control_register2 //(4)
  and #$f8 //(2)
  eor $fe //(3)
// Row 2
  sta vic2_screen_control_register2 //(4) RL62:63
  jsr wait_one_bad_line_minus_3 // RL63:63
  jsr wait_6_good_lines // RL69:63
  :cycles(63 -3*5-8-13)
  inc $fe //(5) 3 ->
  inc $fe //(5)
  inc $fe //(5)   -> 6
  lda $fe //(3)
  and #$07 //(2)
  sta $fe //(3)
  lda vic2_screen_control_register2 //(4)
  and #$f8 //(2)
  eor $fe //(3)
// Row 3
  sta vic2_screen_control_register2 //(4) RL70:63
  jsr wait_one_bad_line_minus_3 // RL71:63
  jsr wait_6_good_lines // RL77:63
  :cycles(63 -4*5-8-13)
  dec $fe //(5) 6 ->
  dec $fe //(5)
  dec $fe //(5)
  dec $fe //(5)   -> 2
  lda $fe //(3)
  and #$07 //(2)
  sta $fe //(3)
  lda vic2_screen_control_register2 //(4)
  and #$f8 //(2)
  eor $fe //(3)
// Row 4
  sta vic2_screen_control_register2 //(4) RL78:63
  jsr wait_one_bad_line_minus_3
  jsr wait_6_good_lines
  :cycles(63 -3*5-8-13)
  inc $fe //(5) 2 ->
  inc $fe //(5)
  inc $fe //(5)   -> 5
  lda $fe //(3)
  and #$07 //(2)
  sta $fe //(3)
  lda vic2_screen_control_register2 //(4)
  and #$f8 //(2)
  eor $fe //(3)
// Row 5
  sta vic2_screen_control_register2 //(4) RL86:63
  jsr wait_one_bad_line_minus_3
  jsr wait_6_good_lines
  :cycles(63 -4*5-8-13)
  dec $fe //(5) 5 ->
  dec $fe //(5)
  dec $fe //(5)
  dec $fe //(5)   -> 1
  lda $fe //(3)
  and #$07 //(2)
  sta $fe //(3)
  lda vic2_screen_control_register2 //(4)
  and #$f8 //(2)
  eor $fe //(3)
// Row 6
  sta vic2_screen_control_register2 //(4) RL94:63
  jsr wait_one_bad_line_minus_3
  jsr wait_6_good_lines
  :cycles(63 -3*5-8-13)
  inc $fe //(5) 1 ->
  inc $fe //(5)
  inc $fe //(5)   -> 4
  lda $fe //(3)
  and #$07 //(2)
  sta $fe //(3)
  lda vic2_screen_control_register2 //(4)
  and #$f8 //(2)
  eor $fe //(3)
// Row 7
  sta vic2_screen_control_register2 //(4) RL102:63
  jsr wait_one_bad_line_minus_3
  jsr wait_6_good_lines
  :cycles(63 -4*5-8-13)
  dec $fe //(5) 4 ->
  dec $fe //(5)
  dec $fe //(5)
  dec $fe //(5)   -> 0
  lda $fe //(3)
  and #$07 //(2)
  sta $fe //(3)
  lda vic2_screen_control_register2 //(4)
  and #$f8 //(2)
  eor $fe //(3)
// Row 8
  sta vic2_screen_control_register2 //(4) RL110:63
  jsr wait_one_bad_line_minus_3
  jsr wait_6_good_lines
  :cycles(63 -3*5-8-13)
  inc $fe //(5) 0 ->
  inc $fe //(5)
  inc $fe //(5)   -> 3
  lda $fe //(3)
  and #$07 //(2)
  sta $fe //(3)
  lda vic2_screen_control_register2 //(4)
  and #$f8 //(2)
  eor $fe //(3)
 // Row 9
  sta vic2_screen_control_register2 //(4) RL118:63
  jsr wait_one_bad_line_minus_3
  jsr wait_6_good_lines
  :cycles(63 -4*5-8-13)
  inc $fe //(5) 3 ->
  inc $fe //(5)
  inc $fe //(5)
  inc $fe //(5)   -> 7
  lda $fe //(3)
  and #$07 //(2)
  sta $fe //(3)
  lda vic2_screen_control_register2 //(4)
  and #$f8 //(2)
  eor $fe //(3)
// Row 10
  sta vic2_screen_control_register2 //(4) RL126:63
  jsr wait_one_bad_line_minus_3
  jsr wait_6_good_lines
  :cycles(63 -5*5-8-13)
  dec $fe //(5) 7 ->
  dec $fe //(5)
  dec $fe //(5)
  dec $fe //(5)
  dec $fe //(5)   -> 2
  lda $fe //(3)
  and #$07 //(2)
  sta $fe //(3)
  lda vic2_screen_control_register2 //(4)
  and #$f8 //(2)
  eor $fe //(3)
// Row 11
  sta vic2_screen_control_register2 //(4) RL126:63
  jsr wait_one_bad_line_minus_3
  jsr wait_6_good_lines
  :cycles(63 -4*5-8-13)
  inc $fe //(5) 2 ->
  inc $fe //(5)
  inc $fe //(5)
  inc $fe //(5)   -> 6
  lda $fe //(3)
  and #$07 //(2)
  sta $fe //(3)
  lda vic2_screen_control_register2 //(4)
  and #$f8 //(2)
  eor $fe //(3)
// Row 12
  sta vic2_screen_control_register2 //(4) RL126:63
  jsr wait_one_bad_line_minus_3
  jsr wait_6_good_lines
  :cycles(63 -5*5-8-13)
  dec $fe //(5) 6 ->
  dec $fe //(5)
  dec $fe //(5)
  dec $fe //(5)
  dec $fe //(5)   -> 1
  lda $fe //(3)
  and #$07 //(2)
  sta $fe //(3)
  lda vic2_screen_control_register2 //(4)
  and #$f8 //(2)
  eor $fe //(3)
// Row 13
  sta vic2_screen_control_register2 //(4) RL126:63
  jsr wait_one_bad_line_minus_3
  jsr wait_6_good_lines
  :cycles(63 -4*5-8-13)
  inc $fe //(5) 1 ->
  inc $fe //(5)
  inc $fe //(5)
  inc $fe //(5)   -> 5
  lda $fe //(3)
  and #$07 //(2)
  sta $fe //(3)
  lda vic2_screen_control_register2 //(4)
  and #$f8 //(2)
  eor $fe //(3)
// Row 14
  sta vic2_screen_control_register2 //(4) RL126:63
  jsr wait_one_bad_line_minus_3
  jsr wait_6_good_lines
  :cycles(63 -5*5-8-13)
  dec $fe //(5) 5 ->
  dec $fe //(5)
  dec $fe //(5)
  dec $fe //(5)
  dec $fe //(5)   -> 0
  lda $fe //(3)
  and #$07 //(2)
  sta $fe //(3)
  lda vic2_screen_control_register2 //(4)
  and #$f8 //(2)
  eor $fe //(3)
// Row 15
  sta vic2_screen_control_register2 //(4) RL126:63
  jsr wait_one_bad_line_minus_3
  jsr wait_6_good_lines
  :cycles(63 -4*5-8-13)
  inc $fe //(5) 0 ->
  inc $fe //(5)
  inc $fe //(5)
  inc $fe //(5)   -> 4
  lda $fe //(3)
  and #$07 //(2)
  sta $fe //(3)
  lda vic2_screen_control_register2 //(4)
  and #$f8 //(2)
  eor $fe //(3)
// Row 16
  sta vic2_screen_control_register2 //(4) RL126:63
  jsr wait_one_bad_line_minus_3 // RL55:63 
  jsr wait_6_good_lines // RL61:63
  :cycles(63 -3*5-8-13)
  inc $fe //(5) 4 ->
  inc $fe //(5)
  inc $fe //(5)   -> 7
  lda $fe //(3)
  and #$07 //(2)
  sta $fe //(3)
  lda vic2_screen_control_register2 //(4)
  and #$f8 //(2)
  eor $fe //(3)
// Row 17
  sta vic2_screen_control_register2 //(4) RL62:63
  jsr wait_one_bad_line_minus_3 // RL63:63
  jsr wait_6_good_lines // RL69:63
  :cycles(63 -4*5-8-13)
  dec $fe //(5) 7 ->
  dec $fe //(5)
  dec $fe //(5)
  dec $fe //(5)   -> 3
  lda $fe //(3)
  and #$07 //(2)
  sta $fe //(3)
  lda vic2_screen_control_register2 //(4)
  and #$f8 //(2)
  eor $fe //(3)
// Row 18
  sta vic2_screen_control_register2 //(4) RL70:63
  jsr wait_one_bad_line_minus_3 // RL71:63
  jsr wait_6_good_lines // RL77:63
  :cycles(63 -3*5-8-13)
  inc $fe //(5) 3 ->
  inc $fe //(5)
  inc $fe //(5)   -> 6
  lda $fe //(3)
  and #$07 //(2)
  sta $fe //(3)
  lda vic2_screen_control_register2 //(4)
  and #$f8 //(2)
  eor $fe //(3)
// Row 19
  sta vic2_screen_control_register2 //(4) RL78:63
  jsr wait_one_bad_line_minus_3
  jsr wait_6_good_lines
  :cycles(63 -4*5-8-13)
  dec $fe //(5) 6 ->
  dec $fe //(5)
  dec $fe //(5)
  dec $fe //(5)   -> 2
  lda $fe //(3)
  and #$07 //(2)
  sta $fe //(3)
  lda vic2_screen_control_register2 //(4)
  and #$f8 //(2)
  eor $fe //(3)
// Row 20
  sta vic2_screen_control_register2 //(4) RL86:63
  jsr wait_one_bad_line_minus_3
  jsr wait_6_good_lines
  :cycles(63 -3*5-8-13)
  inc $fe //(5) 2 ->
  inc $fe //(5)
  inc $fe //(5)   -> 5
  lda $fe //(3)
  and #$07 //(2)
  sta $fe //(3)
  lda vic2_screen_control_register2 //(4)
  and #$f8 //(2)
  eor $fe //(3)
// Row 21
  sta vic2_screen_control_register2 //(4) RL94:63
  jsr wait_one_bad_line_minus_3
  jsr wait_6_good_lines
  :cycles(63 -4*5-8-13)
  dec $fe //(5) 5 ->
  dec $fe //(5)
  dec $fe //(5)
  dec $fe //(5)   -> 1
  lda $fe //(3)
  and #$07 //(2)
  sta $fe //(3)
  lda vic2_screen_control_register2 //(4)
  and #$f8 //(2)
  eor $fe //(3)
// Row 22
  sta vic2_screen_control_register2 //(4) RL102:63
  jsr wait_one_bad_line_minus_3
  jsr wait_6_good_lines
  :cycles(63 -3*5-8-13)
  inc $fe //(5) 1 ->
  inc $fe //(5)
  inc $fe //(5)   -> 4
  lda $fe //(3)
  and #$07 //(2)
  sta $fe //(3)
  lda vic2_screen_control_register2 //(4)
  and #$f8 //(2)
  eor $fe //(3)
// Row 23
  sta vic2_screen_control_register2 //(4) RL110:63
  jsr wait_one_bad_line_minus_3
  jsr wait_6_good_lines
  :cycles(63 -4*5-8-13)
  dec $fe //(5) 4 ->
  dec $fe //(5)
  dec $fe //(5)
  dec $fe //(5)   -> 0
  lda $fe //(3)
  and #$07 //(2)
  sta $fe //(3)
  lda vic2_screen_control_register2 //(4)
  and #$f8 //(2)
  eor $fe //(3)
// Row 24
  sta vic2_screen_control_register2 //(4) RL110:63
  jsr wait_2_rows_with_20_cycles_bad_lines

//inc border
//dec border
//jmp exiting_irq1

check_0:
  lda $fe
  cmp #0
  bne check_7
  jsr scroll_rows_8_15_24
//inc border
//dec border
  //jmp end_of_checks
check_7:
  lda $fe
  cmp #7
  bne check_6
  jsr scroll_rows_6_13_22
//inc border
//dec border
  //jmp end_of_checks
check_6:
  lda $fe
  cmp #6
  bne check_5
  jsr scroll_rows_4_11_20
//inc border
//dec border
  //jmp end_of_checks
check_5:
  lda $fe
  cmp #5
  bne check_4
  jsr scroll_rows_2_9_18
//inc border
//dec border
  //jmp end_of_checks
check_4:
  lda $fe
  cmp #4
  bne check_3
  jsr scroll_rows_7_16_23
//inc border
//dec border
  //jmp end_of_checks
check_3:
  lda $fe
  cmp #3
  bne check_2
  jsr scroll_rows_5_14_21
//inc border6
//dec border
  //jmp end_of_checks
check_2:
  lda $fe
  cmp #2
  bne check_1
  jsr scroll_rows_3_12_19
//inc border
//dec border
  //jmp end_of_checks
check_1:
  lda $fe
  cmp #1
  bne end_of_checks
  jsr scroll_rows_1_10_17
//inc border
//dec border
  //jmp end_of_checks
end_of_checks:
  // Scroll screen one pixel to the left.
  dec $fe //(5) 0 -> $ff => $ff-1 = $fe => $fe AND $07 -> $06
//inc border
//dec border

exiting_irq1:
  asl vic2_interrupt_status_register
  :set_raster(RASTER_LINE_UP)
  :mov16 #irq1 : $fffe
  rti

/*
 * Horizontal scroll functions.
*/
* = $3000 "ScrollingCode"

.macro scroll_3_half_interleaved_rows(row1, row2, row3) {
//  inc border
	// Row 1
    ldx $0400 + row1 * 40 + 0
    ldy $d800 + row1 * 40 + 0
    .for (var index = 1; index < 40; index++) {
      lda $0400 + row1 * 40 + index
      sta $0400 + row1 * 40 + index - 1
      lda $d800 + row1 * 40 + index
      sta $d800 + row1 * 40 + index - 1
    }
    stx $0400 + row1 * 40 + 39
    sty $d800 + row1 * 40 + 39

    // Row 2
    ldx $0400 + row2 * 40 + 0
    ldy $d800 + row2 * 40 + 0
    .for (var index = 1; index < 40; index++) {
      lda $0400 + row2 * 40 + index
      sta $0400 + row2 * 40 + index - 1
      lda $d800 + row2 * 40 + index
      sta $d800 + row2 * 40 + index - 1
    }
    stx $0400 + row2 * 40 + 39
    sty $d800 + row2 * 40 + 39

    // Row 3
    ldx $0400 + row3 * 40 + 0
    ldy $d800 + row3 * 40 + 0
    .for (var index = 1; index < 40; index++) {
      lda $0400 + row3 * 40 + index
      sta $0400 + row3 * 40 + index - 1
      lda $d800 + row3 * 40 + index
      sta $d800 + row3 * 40 + index - 1
    }
    stx $0400 + row3 * 40 + 39
    sty $d800 + row3 * 40 + 39
//  dec border
}

scroll_rows_8_15_24:
  :scroll_3_half_interleaved_rows(7, 14, 23)
  rts

scroll_rows_6_13_22:
  :scroll_3_half_interleaved_rows(5, 12, 21)
  rts

scroll_rows_4_11_20:
  :scroll_3_half_interleaved_rows(3, 10, 19)
  rts

scroll_rows_2_9_18:
  :scroll_3_half_interleaved_rows(1, 8, 17)
  rts

scroll_rows_7_16_23:
  :scroll_3_half_interleaved_rows(6, 15, 22)
  rts

scroll_rows_5_14_21:
  :scroll_3_half_interleaved_rows(4, 13, 20)
  rts

scroll_rows_3_12_19:
  :scroll_3_half_interleaved_rows(2, 11, 18)
  rts

scroll_rows_1_10_17:
  :scroll_3_half_interleaved_rows(0, 9, 16)
  rts
/*
.macro scroll_3_interleaved_rows(start_row, strive) {
//  inc border
  .for (var row = start_row; row < 24; row+=strive) {
    ldx $0400 + row * 40 + 0
    ldy $d800 + row * 40 + 0
    .for (var index = 1; index < 40; index++) {
      lda $0400 + row * 40 + index
      sta $0400 + row * 40 + index - 1
      lda $d800 + row * 40 + index
      sta $d800 + row * 40 + index - 1
    }
    stx $0400 + row * 40 + 39
    sty $d800 + row * 40 + 39
  }
//  dec border
}

scroll_rows_0_8_16:
  :scroll_3_interleaved_rows(0, 8)
  rts

scroll_rows_1_9_17:
  :scroll_3_interleaved_rows(1, 8)
  rts

scroll_rows_2_10_18:
  :scroll_3_interleaved_rows(2, 8)
  rts

scroll_rows_3_11_19:
  :scroll_3_interleaved_rows(3, 8)
  rts

scroll_rows_4_12_20:
  :scroll_3_interleaved_rows(4, 8)
  rts

scroll_rows_5_13_21:
  :scroll_3_interleaved_rows(5, 8)
  rts

scroll_rows_6_14_22:
  :scroll_3_interleaved_rows(6, 8)
  rts

scroll_rows_7_15_23:
  :scroll_3_interleaved_rows(7, 8)
  rts

.macro scroll_3_rows(start_row) {
  inc border
  .for (var row = start_row; row < start_row+3; row++) {
    ldx $0400 + row * 40 + 0
    ldy $d800 + row * 40 + 0
    .for (var index = 1; index < 40; index++) {
      lda $0400 + row * 40 + index
      sta $0400 + row * 40 + index - 1
      lda $d800 + row * 40 + index
      sta $d800 + row * 40 + index - 1
    }
    stx $0400 + row * 40 + 39
    sty $d800 + row * 40 + 39
  }
  dec border
}

scroll_rows_21_to_23:
  :scroll_3_rows(7*3)
  rts

scroll_rows_18_to_20:
  :scroll_3_rows(6*3)
  rts

scroll_rows_15_to_17:
  :scroll_3_rows(5*3)
  rts

scroll_rows_12_to_14:
  :scroll_3_rows(4*3)
  rts

scroll_rows_9_to_11:
  :scroll_3_rows(3*3)
  rts

scroll_rows_6_to_8:
  :scroll_3_rows(2*3)
  rts

scroll_rows_3_to_5:
  :scroll_3_rows(1*3)
  rts

scroll_rows_0_to_2:
  :scroll_3_rows(0*3)
  rts
  */