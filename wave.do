onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lab4_tb/lab4/CPU/clk
add wave -noupdate -radix unsigned /lab4_tb/IR_RX/bitcount
add wave -noupdate /lab4_tb/IR_RX/ir_flag
add wave -noupdate /lab4_tb/IR_RX/ir_n
add wave -noupdate /lab4_tb/IR_RX/state
add wave -noupdate /lab4_tb/IR_RX/repeat_ok
add wave -noupdate /lab4_tb/lab4/CPU/rst_in_n
add wave -noupdate /lab4_tb/lab4/CPU/rst_out_n
add wave -noupdate -radix hexadecimal /lab4_tb/lab4/CPU/irom_addr
add wave -noupdate -radix hexadecimal /lab4_tb/lab4/CPU/sfr_addr
add wave -noupdate -radix hexadecimal /lab4_tb/lab4/CPU/sfr_data_in
add wave -noupdate -radix hexadecimal /lab4_tb/lab4/CPU/sfr_data_out
add wave -noupdate /lab4_tb/lab4/CPU/sfr_rd
add wave -noupdate /lab4_tb/lab4/CPU/sfr_wr
add wave -noupdate -radix hexadecimal -childformat {{{/lab4_tb/lab4/KEY_CTRL/key_sfr_mem[236]} -radix hexadecimal} {{/lab4_tb/lab4/KEY_CTRL/key_sfr_mem[235]} -radix hexadecimal} {{/lab4_tb/lab4/KEY_CTRL/key_sfr_mem[234]} -radix hexadecimal -childformat {{{/lab4_tb/lab4/KEY_CTRL/key_sfr_mem[234][7]} -radix hexadecimal} {{/lab4_tb/lab4/KEY_CTRL/key_sfr_mem[234][6]} -radix hexadecimal} {{/lab4_tb/lab4/KEY_CTRL/key_sfr_mem[234][5]} -radix hexadecimal} {{/lab4_tb/lab4/KEY_CTRL/key_sfr_mem[234][4]} -radix hexadecimal} {{/lab4_tb/lab4/KEY_CTRL/key_sfr_mem[234][3]} -radix hexadecimal} {{/lab4_tb/lab4/KEY_CTRL/key_sfr_mem[234][2]} -radix hexadecimal} {{/lab4_tb/lab4/KEY_CTRL/key_sfr_mem[234][1]} -radix hexadecimal} {{/lab4_tb/lab4/KEY_CTRL/key_sfr_mem[234][0]} -radix hexadecimal}}}} -expand -subitemconfig {{/lab4_tb/lab4/KEY_CTRL/key_sfr_mem[236]} {-height 15 -radix hexadecimal} {/lab4_tb/lab4/KEY_CTRL/key_sfr_mem[235]} {-height 15 -radix hexadecimal} {/lab4_tb/lab4/KEY_CTRL/key_sfr_mem[234]} {-height 15 -radix hexadecimal -childformat {{{/lab4_tb/lab4/KEY_CTRL/key_sfr_mem[234][7]} -radix hexadecimal} {{/lab4_tb/lab4/KEY_CTRL/key_sfr_mem[234][6]} -radix hexadecimal} {{/lab4_tb/lab4/KEY_CTRL/key_sfr_mem[234][5]} -radix hexadecimal} {{/lab4_tb/lab4/KEY_CTRL/key_sfr_mem[234][4]} -radix hexadecimal} {{/lab4_tb/lab4/KEY_CTRL/key_sfr_mem[234][3]} -radix hexadecimal} {{/lab4_tb/lab4/KEY_CTRL/key_sfr_mem[234][2]} -radix hexadecimal} {{/lab4_tb/lab4/KEY_CTRL/key_sfr_mem[234][1]} -radix hexadecimal} {{/lab4_tb/lab4/KEY_CTRL/key_sfr_mem[234][0]} -radix hexadecimal}}} {/lab4_tb/lab4/KEY_CTRL/key_sfr_mem[234][7]} {-height 15 -radix hexadecimal} {/lab4_tb/lab4/KEY_CTRL/key_sfr_mem[234][6]} {-height 15 -radix hexadecimal} {/lab4_tb/lab4/KEY_CTRL/key_sfr_mem[234][5]} {-height 15 -radix hexadecimal} {/lab4_tb/lab4/KEY_CTRL/key_sfr_mem[234][4]} {-height 15 -radix hexadecimal} {/lab4_tb/lab4/KEY_CTRL/key_sfr_mem[234][3]} {-height 15 -radix hexadecimal} {/lab4_tb/lab4/KEY_CTRL/key_sfr_mem[234][2]} {-height 15 -radix hexadecimal} {/lab4_tb/lab4/KEY_CTRL/key_sfr_mem[234][1]} {-height 15 -radix hexadecimal} {/lab4_tb/lab4/KEY_CTRL/key_sfr_mem[234][0]} {-height 15 -radix hexadecimal}} /lab4_tb/lab4/KEY_CTRL/key_sfr_mem
add wave -noupdate -radix hexadecimal /lab4_tb/lab4/KEY_CTRL/key_state
add wave -noupdate -radix hexadecimal /lab4_tb/lab4/KEY_CTRL/counter_250u
add wave -noupdate -radix hexadecimal -childformat {{{/lab4_tb/lab4/KEY_CTRL/key_scan[3]} -radix hexadecimal} {{/lab4_tb/lab4/KEY_CTRL/key_scan[2]} -radix hexadecimal} {{/lab4_tb/lab4/KEY_CTRL/key_scan[1]} -radix hexadecimal} {{/lab4_tb/lab4/KEY_CTRL/key_scan[0]} -radix hexadecimal}} -subitemconfig {{/lab4_tb/lab4/KEY_CTRL/key_scan[3]} {-height 15 -radix hexadecimal} {/lab4_tb/lab4/KEY_CTRL/key_scan[2]} {-height 15 -radix hexadecimal} {/lab4_tb/lab4/KEY_CTRL/key_scan[1]} {-height 15 -radix hexadecimal} {/lab4_tb/lab4/KEY_CTRL/key_scan[0]} {-height 15 -radix hexadecimal}} /lab4_tb/lab4/KEY_CTRL/key_scan
add wave -noupdate -radix hexadecimal -childformat {{{/lab4_tb/lab4/KEY_CTRL/key_read[3]} -radix hexadecimal} {{/lab4_tb/lab4/KEY_CTRL/key_read[2]} -radix hexadecimal} {{/lab4_tb/lab4/KEY_CTRL/key_read[1]} -radix hexadecimal} {{/lab4_tb/lab4/KEY_CTRL/key_read[0]} -radix hexadecimal}} -subitemconfig {{/lab4_tb/lab4/KEY_CTRL/key_read[3]} {-height 15 -radix hexadecimal} {/lab4_tb/lab4/KEY_CTRL/key_read[2]} {-height 15 -radix hexadecimal} {/lab4_tb/lab4/KEY_CTRL/key_read[1]} {-height 15 -radix hexadecimal} {/lab4_tb/lab4/KEY_CTRL/key_read[0]} {-height 15 -radix hexadecimal}} /lab4_tb/lab4/KEY_CTRL/key_read
add wave -noupdate /lab4_tb/lab4/KEY_CTRL/key_pressed
add wave -noupdate /lab4_tb/lab4/KEY_CTRL/key_timeout
add wave -noupdate /lab4_tb/lab4/KEY_CTRL/key_changed
add wave -noupdate -radix hexadecimal -childformat {{{/lab4_tb/lab4/KEY_CTRL/key_mem[3]} -radix hexadecimal} {{/lab4_tb/lab4/KEY_CTRL/key_mem[2]} -radix hexadecimal} {{/lab4_tb/lab4/KEY_CTRL/key_mem[1]} -radix hexadecimal} {{/lab4_tb/lab4/KEY_CTRL/key_mem[0]} -radix hexadecimal -childformat {{{/lab4_tb/lab4/KEY_CTRL/key_mem[0][3]} -radix hexadecimal} {{/lab4_tb/lab4/KEY_CTRL/key_mem[0][2]} -radix hexadecimal} {{/lab4_tb/lab4/KEY_CTRL/key_mem[0][1]} -radix hexadecimal} {{/lab4_tb/lab4/KEY_CTRL/key_mem[0][0]} -radix hexadecimal}}}} -subitemconfig {{/lab4_tb/lab4/KEY_CTRL/key_mem[3]} {-height 15 -radix hexadecimal} {/lab4_tb/lab4/KEY_CTRL/key_mem[2]} {-height 15 -radix hexadecimal} {/lab4_tb/lab4/KEY_CTRL/key_mem[1]} {-height 15 -radix hexadecimal} {/lab4_tb/lab4/KEY_CTRL/key_mem[0]} {-height 15 -radix hexadecimal -childformat {{{/lab4_tb/lab4/KEY_CTRL/key_mem[0][3]} -radix hexadecimal} {{/lab4_tb/lab4/KEY_CTRL/key_mem[0][2]} -radix hexadecimal} {{/lab4_tb/lab4/KEY_CTRL/key_mem[0][1]} -radix hexadecimal} {{/lab4_tb/lab4/KEY_CTRL/key_mem[0][0]} -radix hexadecimal}}} {/lab4_tb/lab4/KEY_CTRL/key_mem[0][3]} {-height 15 -radix hexadecimal} {/lab4_tb/lab4/KEY_CTRL/key_mem[0][2]} {-height 15 -radix hexadecimal} {/lab4_tb/lab4/KEY_CTRL/key_mem[0][1]} {-height 15 -radix hexadecimal} {/lab4_tb/lab4/KEY_CTRL/key_mem[0][0]} {-height 15 -radix hexadecimal}} /lab4_tb/lab4/KEY_CTRL/key_mem
add wave -noupdate -radix unsigned /lab4_tb/lab4/KEY_CTRL/deb/counter
add wave -noupdate -radix hexadecimal /lab4_tb/lab4/IR_CTRL/send_state
add wave -noupdate -radix unsigned /lab4_tb/lab4/IR_CTRL/send_conter
add wave -noupdate /lab4_tb/lab4/IR_CTRL/bit_send_end
add wave -noupdate /lab4_tb/lab4/IR_CTRL/byte_send_end
add wave -noupdate -color Magenta /lab4_tb/lab4/IR_CTRL/IRDA_TXD
add wave -noupdate -radix unsigned /lab4_tb/lab4/IR_CTRL/leader_counter
add wave -noupdate -radix hexadecimal /lab4_tb/lab4/IR_CTRL/leader_tx
add wave -noupdate -radix unsigned /lab4_tb/lab4/IR_CTRL/rep_counter
add wave -noupdate -radix hexadecimal /lab4_tb/lab4/IR_CTRL/repeat_tx
add wave -noupdate -radix hexadecimal /lab4_tb/lab4/IR_CTRL/reset_n
add wave -noupdate -radix hexadecimal /lab4_tb/lab4/IR_CTRL/send
add wave -noupdate -radix hexadecimal -childformat {{{/lab4_tb/lab4/IR_CTRL/send_mem[245]} -radix hexadecimal} {{/lab4_tb/lab4/IR_CTRL/send_mem[244]} -radix hexadecimal} {{/lab4_tb/lab4/IR_CTRL/send_mem[243]} -radix hexadecimal} {{/lab4_tb/lab4/IR_CTRL/send_mem[242]} -radix hexadecimal} {{/lab4_tb/lab4/IR_CTRL/send_mem[241]} -radix hexadecimal}} -subitemconfig {{/lab4_tb/lab4/IR_CTRL/send_mem[245]} {-height 15 -radix hexadecimal} {/lab4_tb/lab4/IR_CTRL/send_mem[244]} {-height 15 -radix hexadecimal} {/lab4_tb/lab4/IR_CTRL/send_mem[243]} {-height 15 -radix hexadecimal} {/lab4_tb/lab4/IR_CTRL/send_mem[242]} {-height 15 -radix hexadecimal} {/lab4_tb/lab4/IR_CTRL/send_mem[241]} {-height 15 -radix hexadecimal}} /lab4_tb/lab4/IR_CTRL/send_mem
add wave -noupdate -radix hexadecimal /lab4_tb/lab4/IR_CTRL/send_repeat
add wave -noupdate -radix hexadecimal /lab4_tb/lab4/IR_CTRL/send_tx
add wave -noupdate -radix hexadecimal /lab4_tb/lab4/IR_CTRL/sfr_addr
add wave -noupdate -radix hexadecimal /lab4_tb/lab4/IR_CTRL/sfr_data_in
add wave -noupdate -radix hexadecimal /lab4_tb/lab4/IR_CTRL/sfr_data_out
add wave -noupdate /lab4_tb/lab4/IR_CTRL/sfr_rd
add wave -noupdate /lab4_tb/lab4/IR_CTRL/sfr_wr
add wave -noupdate /lab4_tb/lab4/IR_CTRL/wave
add wave -noupdate -radix unsigned /lab4_tb/lab4/IR_CTRL/wave_counter
TreeUpdate [SetDefaultTree]
WaveRestoreCursors
quietly wave cursor active 0
configure wave -namecolwidth 243
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {261375943500 ps}
