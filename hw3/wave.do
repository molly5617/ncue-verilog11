onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mac_sim/CLEAR
add wave -noupdate /mac_sim/CLEAR2
add wave -noupdate /mac_sim/MUL_16
add wave -noupdate /mac_sim/MAC_16
add wave -noupdate /mac_sim/SAT_16
add wave -noupdate /mac_sim/MUL_8
add wave -noupdate /mac_sim/MAC_8
add wave -noupdate /mac_sim/SAT_8
add wave -noupdate /mac_sim/NO_STALL
add wave -noupdate /mac_sim/STALL
add wave -noupdate /mac_sim/reset_n
add wave -noupdate /mac_sim/clk
add wave -noupdate /mac_sim/stall
add wave -noupdate /mac_sim/instruction
add wave -noupdate /mac_sim/multiplier
add wave -noupdate /mac_sim/multiplicand
add wave -noupdate /mac_sim/protect
add wave -noupdate /mac_sim/result
add wave -noupdate /mac_sim/protect_g
add wave -noupdate /mac_sim/result_g
add wave -noupdate /mac_sim/cycle_cnt
add wave -noupdate /mac_sim/result_file1
add wave -noupdate /mac_sim/result_file2
add wave -noupdate /mac_sim/data_base
add wave -noupdate /mac_sim/i
add wave -noupdate /mac_sim/data_tmp
add wave -noupdate /mac_sim/error_cnt
add wave -noupdate /mac_sim/ready
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
