create_floorplan \
  -die_size {97.92 97.68 0 0 0 0}

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
  "DI[0]" \
}

set i 0
foreach p $left_hand_side_ports {
  move_port $p \
    -x 0 \
    -y [expr 97.68 - 4.07 - [expr $i * 8.14]] \
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
  "DO[0]" \
}

set i 0
foreach p $right_hand_side_ports {
  move_port $p \
    -x 97.92 \
    -y [expr 97.68 - 4.07 - [expr $i * 8.14]] \
    -placement_status fixed

  incr i
}

set top_ports { \
  "PS_CTRL" \
  "ISO_ENC" \
  "RET_ENC" \
}

set i 0
foreach p $top_ports {
  move_port $p \
    -x [expr 16.32 + [expr $i * 32.64]] \
    -y 97.68 \
    -placement_status fixed

  incr i
}

check_floorplan