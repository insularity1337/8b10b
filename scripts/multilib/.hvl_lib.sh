#!/bin/bash

find $SKYWATER_PDK/libraries/sky130_fd_sc_hvl/latest/models/ -name "*.v" ! -name "*.blackbox.*" ! -name "*.symbol.*" ! -name "*.tb.*" | cat > hvl_models.txt

# find $SKYWATER_PDK/libraries/sky130_fd_sc_hvl/latest/cells/ -name "*functional.pp.v" | cat > hvl_cells.txt
find $SKYWATER_PDK/libraries/sky130_fd_sc_hvl/latest/cells/ -name "*.v" ! -name "*.pp.*" ! -name "*.blackbox.*" ! -name "*.tb.*" ! -name "*.symbol.*" ! -name "*.behavioral.*" ! -name "*.specify.*" ! -name "*.functional.*" ! -name "*dlxbn*" ! -name "*iso0n_lp2*" | cat > hvl_cells.txt

touch ./hvl_dir.txt

hvl_dir=`find $SKYWATER_PDK/libraries/sky130_fd_sc_hvl/latest/cells/ -maxdepth 1`

for i in ${hvl_dir[@]}
do
  echo "-incdir $i" >> ./hvl_dir.txt
done

xrun \
  -define UNIT_DELAY=#1 \
  -compile \
  -sv \
  -f hvl_dir.txt \
  -makelib hvl \
    -parallel \
    -f hvl_models.txt \
    -f hvl_cells.txt \
  -endlib



find $SKYWATER_PDK/libraries/sky130_fd_sc_ls/latest/models/ -name "*.v" ! -name "*.blackbox.*" ! -name "*.symbol.*" ! -name "*.tb.*" | cat > ls_models.txt

# find $SKYWATER_PDK/libraries/sky130_fd_sc_ls/latest/cells/ -name "*functional.pp.v" | cat > ls_cells.txt
find $SKYWATER_PDK/libraries/sky130_fd_sc_ls/latest/cells/ -name "*.v" ! -name "*.pp.*" ! -name "*.blackbox.*" ! -name "*.tb.*" ! -name "*.symbol.*" ! -name "*.behavioral.*" ! -name "*.specify.*" ! -name "*.functional.*" ! -name "*dlxbn*" ! -name "*iso0n_lp2*" | cat > ls_cells.txt

touch ./ls_dir.txt

ls_dir=`find $SKYWATER_PDK/libraries/sky130_fd_sc_ls/latest/cells/ -maxdepth 1`

for i in ${ls_dir[@]}
do
  echo "-incdir $i" >> ./ls_dir.txt
done

xrun \
  -define UNIT_DELAY=#1 \
  -compile \
  -sv \
  -f ls_dir.txt \
  -makelib ls \
    -parallel \
    -f ls_models.txt \
    -f ls_cells.txt \
  -endlib



find $SKYWATER_PDK/libraries/sky130_fd_sc_lp/latest/models/ -name "*.v" ! -name "*.blackbox.*" ! -name "*.symbol.*" ! -name "*.tb.*" | cat > lp_models.txt

# find $SKYWATER_PDK/libraries/sky130_fd_sc_lp/latest/cells/ -name "*functional.pp.v" | cat > lp_cells.txt
find $SKYWATER_PDK/libraries/sky130_fd_sc_lp/latest/cells/ -name "*.v" ! -name "*.pp.*" ! -name "*.blackbox.*" ! -name "*.tb.*" ! -name "*.symbol.*" ! -name "*.behavioral.*" ! -name "*.specify.*" ! -name "*.functional.*" ! -name "*dlxbn*" ! -name "*iso0n_lp2*" | cat > lp_cells.txt


touch ./lp_dir.txt

lp_dir=`find $SKYWATER_PDK/libraries/sky130_fd_sc_lp/latest/cells/ -maxdepth 1`

for i in ${lp_dir[@]}
do
  echo "-incdir $i" >> ./lp_dir.txt
done

xrun \
  -define UNIT_DELAY=#1 \
  -compile \
  -sv \
  -f lp_dir.txt \
  -makelib lp \
    -parallel \
    -f lp_models.txt \
    -f lp_cells.txt \
  -endlib



xrun \
  -define UNIT_DELAY=#1 \
  -define USE_POWER_PINS \
  -libext .v \
  -f hvl_dir.txt \
  -f hvl_cells.txt \
  -f ls_dir.txt \
  -f ls_cells.txt \
  -f lp_dir.txt \
  -f lp_cells.txt \
  -f ../scripts/multilib/xrun_launch_args.txt \
  -f ../scripts/multilib/xrun_lp_args.txt \
  ../qa/pa_env_tb.sv \
  ../synth/foo.v