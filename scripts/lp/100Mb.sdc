create_clock \
  -name CLK \
  -waveform {0.0 40.0} \
  -period 80.0 \
  [get_db ports *CLK]

# skew & jitter pessimism
set_clock_uncertainty 1.0 [get_db clocks *CLK]

# DVI specification
set_input_delay -clock CLK -min 2.0 [get_db ports *DVI]
set_input_delay -clock CLK -max 6.0 [get_db ports *DVI]

set_input_transition 0.5 [get_db ports *DVI]

# KI specification
set_input_delay -clock CLK -min 2.5 [get_db ports *KI]
set_input_delay -clock CLK -max 6.5 [get_db ports *KI]

set_input_transition 0.44 [get_db ports *KI]

# DI specification
set_input_delay -clock CLK -min 1.5 [get_db ports *DI[*]]
set_input_delay -clock CLK -max 7.0 [get_db ports *DI[*]]

set_input_transition 0.75 [get_db ports *DI[*]]

# DVO specification
set_output_delay -clock CLK -min -1.0 [get_db ports *DVO]
set_output_delay -clock CLK -max  4.0 [get_db ports *DVO]

set_load 0.25 [get_db ports *DVO]

# KO specification
set_output_delay -clock CLK -min -0.75 [get_db ports *KO]
set_output_delay -clock CLK -max  5.0  [get_db ports *KO]

set_load 0.100 [get_db ports *KO]

# VIOL specification
set_output_delay -clock CLK -min -1.5 [get_db ports *VIOL]
set_output_delay -clock CLK -max  3.0 [get_db ports *VIOL]

set_load 0.33 [get_db ports *VIOL]

# DO specification
set_output_delay -clock CLK -min -0.5 [get_db ports *DO[*]]
set_output_delay -clock CLK -max  2.0 [get_db ports *DO[*]]

set_load 0.4 [get_db ports *DO[*]]