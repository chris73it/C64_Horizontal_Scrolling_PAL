#import "helpers.asm"
#import "wait_functions.asm"

.label border = $d020
.label background = $d021

.label cia1_interrupt_control_register = $dc0d
.label cia2_interrupt_control_register = $dd0d

// The animation skips these many frames in between 'active' frames:
// 0 means "max animation speed", for instance 50 Hz on PAL, and 60 on NTSC.
// 1 means "display one frame then repeat the next": the animation is 25 Hz on PAL.
.const RASTER_LINE = 50+4-2

.const VIC2 = $d000
.namespace sprites {
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
    lda #7+1 // It is decremented as soon as scrolling starts.
    sta $fe //Buffers the XSCROLL bit field.

    jsr init_sprites

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
    :set_raster(RASTER_LINE)
    :mov16 #irq1 : $fffe
  cli

loop:
  jmp loop

irq1:
  :stabilize_irq() //RL54:3
  :cycles(-3 +63 -5 -8 -13 -3-2)
  dec $fe //(5) 8 -> 7
  lda $fe //(3)
  and #$07 //(2)
  sta $fe //(3)
  lda vic2_screen_control_register2 //(4)
  and #$f8 //(2)
  eor $fe //(3)
// Rows from 1 to 3.
  sta vic2_screen_control_register2 //(4) RL54:63
  jsr wait_1_row_minus_5 // RL69:63
  jsr wait_1_row_minus_5 // RL70:63
  jsr wait_one_bad_line_minus_5_minus_3 // RL71:63 
  jsr wait_6_good_lines_minus_5 // RL77:63
  :cycles(63 -5-8-13 -3-2)
  dec $fe //(5) 7 -> 6
  lda $fe //(3)
  and #$07 //(2)
  sta $fe //(3)
  lda vic2_screen_control_register2 //(4)
  and #$f8 //(2)
  eor $fe //(3)
// Rows from 4 to 6.
  sta vic2_screen_control_register2 //(4) RL78:63
  jsr wait_1_row_minus_5
  jsr wait_1_row_minus_5
  jsr wait_one_bad_line_minus_5_minus_3
  jsr wait_6_good_lines_minus_5
  :cycles(63 -5-8-13 -3-2)
  dec $fe //(5) 6 -> 5
  lda $fe //(3)
  and #$07 //(2)
  sta $fe //(3)
  lda vic2_screen_control_register2 //(4)
  and #$f8 //(2)
  eor $fe //(3)
// Rows from 7 to 9.
  sta vic2_screen_control_register2 //(4)
  jsr wait_1_row_minus_5
  jsr wait_1_row_minus_5
  jsr wait_one_bad_line_minus_5_minus_3
  jsr wait_6_good_lines_minus_5
  :cycles(63 -5-8-13 -3-2)
  dec $fe //(5) 5 -> 4
  lda $fe //(3)
  and #$07 //(2)
  sta $fe //(3)
  lda vic2_screen_control_register2 //(4)
  and #$f8 //(2)
  eor $fe //(3)
// Rows from 10 to 12.
  sta vic2_screen_control_register2 //(4)
  jsr wait_1_row_minus_5
  jsr wait_1_row_minus_5
  jsr wait_one_bad_line_minus_5_minus_3
  jsr wait_6_good_lines_minus_5
  :cycles(63 -5-8-13 -3-2)
  dec $fe //(5) 4 -> 3
  lda $fe //(3)
  and #$07 //(2)
  sta $fe //(3)
  lda vic2_screen_control_register2 //(4)
  and #$f8 //(2)
  eor $fe //(3)
// Rows from 13 to 15.
  sta vic2_screen_control_register2 //(4)
  jsr wait_1_row_minus_5
  jsr wait_1_row_minus_5
  jsr wait_one_bad_line_minus_5_minus_3
  jsr wait_6_good_lines_minus_5
  :cycles(63 -5-8-13 -3-2)
  dec $fe //(5) 3 -> 2
  lda $fe //(3)
  and #$07 //(2)
  sta $fe //(3)
  lda vic2_screen_control_register2 //(4)
  and #$f8 //(2)
  eor $fe //(3)
// Rows from 16 to 18.
  sta vic2_screen_control_register2 //(4)
  jsr wait_1_row_minus_5
  jsr wait_1_row_minus_5
  jsr wait_one_bad_line_minus_5_minus_3
  jsr wait_6_good_lines_minus_5
  :cycles(63 -5-8-13 -3-2)
  dec $fe //(5) 2 -> 1
  lda $fe //(3)
  and #$07 //(2)
  sta $fe //(3)
  lda vic2_screen_control_register2 //(4)
  and #$f8 //(2)
  eor $fe //(3)
// Rows from 19 to 21.
  sta vic2_screen_control_register2 //(4)
  jsr wait_1_row_minus_5
  jsr wait_1_row_minus_5
  jsr wait_one_bad_line_minus_5_minus_3
  jsr wait_6_good_lines_minus_5
  :cycles(63 -5-8-13 -3-2)
  dec $fe //(5) 1 -> 0
  lda $fe //(3)
  and #$07 //(2)
  sta $fe //(3)
  lda vic2_screen_control_register2 //(4)
  and #$f8 //(2)
  eor $fe //(3)
// Rows from 22 to 24.
  sta vic2_screen_control_register2 //(4)
  jsr wait_1_row_minus_5
  jsr wait_1_row_minus_5
  jsr wait_1_row_minus_5
//inc border
//dec border

check_0:
  lda $fe
  cmp #0
  bne check_7
  jsr scroll_rows_21_to_23
//inc border
//dec border
  //jmp end_of_checks
check_7:
  lda $fe
  cmp #7
  bne check_6
  jsr scroll_rows_18_to_20
//inc border
//dec border
  //jmp end_of_checks
check_6:
  lda $fe
  cmp #6
  bne check_5
  jsr scroll_rows_15_to_17
//inc border
//dec border
  //jmp end_of_checks
check_5:
  lda $fe
  cmp #5
  bne check_4
  jsr scroll_rows_12_to_14
//inc border
//dec border
  //jmp end_of_checks
check_4:
  lda $fe
  cmp #4
  bne check_3
  jsr scroll_rows_9_to_11
//inc border
//dec border
  //jmp end_of_checks
check_3:
  lda $fe
  cmp #3
  bne check_2
  jsr scroll_rows_6_to_8
//inc border
//dec border
  //jmp end_of_checks
check_2:
  lda $fe
  cmp #2
  bne check_1
  jsr scroll_rows_3_to_5
//inc border
//dec border
  //jmp end_of_checks
check_1:
  lda $fe
  cmp #1
  bne end_of_checks
  jsr scroll_rows_0_to_2
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
  :set_raster(RASTER_LINE)
  :mov16 #irq1 : $fffe
  rti

init_sprites:
  .for (var sprite_id = 0; sprite_id < NAS; sprite_id++) {
    lda #BLACK
    sta sprites.colors + sprite_id
    lda #255-8 + sprite_id
    sta sprites.pointers + sprite_id
    ldx #4//7
    stx sprites.positions + sprite_id * 2
    ldy #RASTER_LINE+2 + sprite_id * 42
    sty sprites.positions + sprite_id * 2 + 1
  }
  lda #pow(2,NAS)-1
  sta sprites.vertical_stretch_bits
  sta sprites.enable_bits
  rts

/*
 * Horizontal scroll functions.
*/
* = $4000 "ScrollingCode"

.macro scroll_3_rows(start_row) {
//  inc border
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
//  dec border
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

.const SPRITE_BITMAPS = 255-8
* = SPRITE_BITMAPS*64 "Blank sprites"
.import binary "blank_sprites.bin"
