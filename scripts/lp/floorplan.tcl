create_floorplan \
  -die_size {99.84 99.9 0 0 0 0}

# create_row -site unithvdbl pa_env 

set left_hand_side_ports {\
  "CLK" \
  "RSTn" \
  "DVI" \
  "KI" \
  "DI[7]" \
  "DI[6]" \
  "DI[5]" \
  "DI[4]" \
  "DI[3]" \
  "DI[2]" \
  "DI[1]" \
  "DI[0]"}

set i 0
foreach p $left_hand_side_ports {
  move_port $p \
    -x 0 \
    -y [expr 99.9 - 4.1625 - [expr $i * 8.325]] \
    -placement_status fixed

  incr i
}

set right_hand_side_ports { \
  "DVO" \
  "KO" \
  "VIOL" \
  "DO[7]" \
  "DO[6]" \
  "DO[5]" \
  "DO[4]" \
  "DO[3]" \
  "DO[2]" \
  "DO[1]" \
  "DO[0]"}

set i 0
foreach p $right_hand_side_ports {
  move_port $p \
    -x 99.84 \
    -y [expr 99.9 - 4.54 - [expr $i * 9.082]] \
    -placement_status fixed

  incr i
}

# set top_ports { \
#   "ENC_PS_CTRL" \
#   "ENC_ISO" \
#   "ENC_RET" \
#   "DEC_PS_CTRL" \
#   "DEC_ISO" \
#   "DEC_RET"}

# set i 0
# foreach p $top_ports {
#   move_port $p \
#     -x [expr 8.32 + [expr $i * 16.64]] \
#     -y 99.9 \
#     -placement_status fixed

#   incr i
# }

check_floorplan