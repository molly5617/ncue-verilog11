onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mac_half_tb001/clk
add wave -noupdate /mac_half_tb001/reset_n
add wave -noupdate /mac_half_tb001/instruction
add wave -noupdate /mac_half_tb001/multiplier
add wave -noupdate /mac_half_tb001/multiplicand
add wave -noupdate /mac_half_tb001/stall
add wave -noupdate /mac_half_tb001/protect
add wave -noupdate /mac_half_tb001/result
add wave -noupdate /mac_half_tb001/see
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ps} {1 ns}
