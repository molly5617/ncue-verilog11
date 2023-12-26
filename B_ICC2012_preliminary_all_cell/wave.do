onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /test/duty
add wave -noupdate /test/clk
add wave -noupdate /test/rst
add wave -noupdate /test/done
add wave -noupdate /test/f_io_a
add wave -noupdate /test/f_cle_a
add wave -noupdate /test/f_ale_a
add wave -noupdate /test/f_ren_a
add wave -noupdate /test/f_wen_a
add wave -noupdate /test/f_rb_a
add wave -noupdate /test/f_io_b
add wave -noupdate /test/f_cle_b
add wave -noupdate /test/f_ale_b
add wave -noupdate /test/f_ren_b
add wave -noupdate /test/f_wen_b
add wave -noupdate /test/f_rb_b
add wave -noupdate /test/out_mem
add wave -noupdate /test/k
add wave -noupdate /test/x
add wave -noupdate /test/n
add wave -noupdate /test/i
add wave -noupdate /test/err
add wave -noupdate /test/y
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {700 ps} 0}
quietly wave cursor active 1
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
