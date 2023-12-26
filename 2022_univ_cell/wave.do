onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testfixture/fd
add wave -noupdate /testfixture/charcount
add wave -noupdate /testfixture/line
add wave -noupdate /testfixture/freturn
add wave -noupdate /testfixture/patnum
add wave -noupdate /testfixture/CLK
add wave -noupdate /testfixture/Valid
add wave -noupdate /testfixture/RST
add wave -noupdate /testfixture/W
add wave -noupdate /testfixture/J
add wave -noupdate /testfixture/Cost
add wave -noupdate /testfixture/MatchCount
add wave -noupdate /testfixture/MinCost
add wave -noupdate /testfixture/cycle
add wave -noupdate /testfixture/costrom
add wave -noupdate /testfixture/key_value
add wave -noupdate /testfixture/key
add wave -noupdate /testfixture/v0
add wave -noupdate /testfixture/v1
add wave -noupdate /testfixture/v2
add wave -noupdate /testfixture/v3
add wave -noupdate /testfixture/v4
add wave -noupdate /testfixture/v5
add wave -noupdate /testfixture/v6
add wave -noupdate /testfixture/v7
add wave -noupdate /testfixture/worker
add wave -noupdate /testfixture/i
add wave -noupdate /testfixture/j
add wave -noupdate /testfixture/goldMatchCount
add wave -noupdate /testfixture/goldMinCost
add wave -noupdate /testfixture/wait_valid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {230 ps} 0}
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
