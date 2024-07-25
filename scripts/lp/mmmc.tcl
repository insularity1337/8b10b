# [+] 1. Т.к. библиотеки куцие, то нужно применить voltage scaling и для ss и для ff случаев
#   [+] 1.1 Рабочий диапазон в lp: 1.6 V : 1.8 V : 1.95 V; но нужно предусмотреть работу на 1.2 В
# 2. Переписать UPF:
#   2.1 Все домены работают от одного опорного напряжения, но притом есть возможность 
#       работы либо на низком уровне либо на высоком
# 3. Переписать MMMC
#   [+] 3.1 Добавить условия окружающей среды для медленного и быстрого режимов
#   [+] 3.2 Написать условия окружающей среды для режимов с voltage scaling
#   [+] 3.3 Вспомнить главу про RC extraction и добавить тестовый rc corner для разных 
#       условий травления с учетом того что схемы мизерные
#   [+] 3.4 Написать констрейнты для двух режимов работы: 10 Мбит и 100 Мбит и добавить их в MMMC
# [+] 4. Прописать все analysis view для всех режимов (м.б. даже составить табличку для 
#    документации)
#
# [+] 11. Добавить power_mode в create_analysis_view
#
# 5. Красиво считать библиотеки в скрипте
# 6. Проверить очередность вызова команд в скрипте, все считывания делать с помощью
#    специальных команд
#
# 7. Проверить связку simple ple + low power + mmmc flows
# 8. Проверить экспорт файлов для моделирования
# 9. Переписать тестовое окружения под новые кейсы
# 10. Проверить работу моделирования
#
create_library_set \
  -name slow_cold_lib \
  -timing { \
    sky130_fd_sc_lp/latest/timing/sky130_fd_sc_lp__ss_n40C_1v55.lib \
    sky130_fd_sc_lp/latest/timing/sky130_fd_sc_lp__ss_n40C_1v60.lib}

create_library_set \
  -name slow_hot_lib \
  -timing sky130_fd_sc_lp/latest/timing/sky130_fd_sc_lp__ss_100C_1v60.lib

create_library_set \
  -name fast_cold_lib \
  -timing {{ \
    sky130_fd_sc_lp/latest/timing/sky130_fd_sc_lp__ff_n40C_1v56.lib \
    sky130_fd_sc_lp/latest/timing/sky130_fd_sc_lp__ff_n40C_1v76.lib \
    sky130_fd_sc_lp/latest/timing/sky130_fd_sc_lp__ff_n40C_1v95.lib \
    sky130_fd_sc_lp/latest/timing/sky130_fd_sc_lp__ff_n40C_2v05.lib}}

create_library_set \
  -name fast_hot_lib \
  -timing sky130_fd_sc_lp/latest/timing/sky130_fd_sc_lp__ff_100C_1v95.lib



#
# Virtual operating conditions
#
create_opcond \
  -name vnom_cold \
  -process 1.0 \
  -voltage 1.6 \
  -temperature -40

create_opcond \
  -name vboost_cold \
  -process 1.0 \
  -voltage 1.95 \
  -temperature -40

create_opcond \
  -name vnom_hot \
  -process 1.0 \
  -voltage 1.6 \
  -temperature 100

create_opcond \
  -name vboost_hot \
  -process 1.0 \
  -voltage 1.95 \
  -temperature 100



#
# Timing conditions
#

# Slow & low temperature
create_timing_condition \
  -name slow_vnom_hot \
  -library_sets slow_hot_lib \
  -opcond vnom_hot

create_timing_condition \
  -name slow_vnom_cold \
  -library_sets slow_cold_lib \
  -opcond vnom_cold

create_timing_condition \
  -name fast_vboost_cold \
  -library_sets fast_cold_lib \
  -opcond vboost_cold

create_timing_condition \
  -name fast_vboost_hot \
  -library_sets fast_hot_lib \
  -opcond vboost_hot



#
# RC corners
#
create_rc_corner \
  -name rc_typ_cold \
  -temperature -40 \
  -cap_table /home/sasha/lp.captbl

create_rc_corner \
  -name rc_typ_hot \
  -temperature -100 \
  -cap_table /home/sasha/lp.captbl



#
# Delay corners
#

# "slow" corners
create_delay_corner \
  -name slow_vnom_hot_typ_rc \
  -early_timing_condition slow_vnom_hot \
  -late_timing_condition slow_vnom_hot \
  -early_rc_corner rc_typ_hot \
  -late_rc_corner rc_typ_hot

create_delay_corner \
  -name slow_vnom_cold_typ_rc \
  -early_timing_condition slow_vnom_cold \
  -late_timing_condition slow_vnom_cold \
  -early_rc_corner rc_typ_cold \
  -late_rc_corner rc_typ_cold

# "fast" corners
create_delay_corner \
  -name fast_vboost_cold_typ_rc \
  -early_timing_condition fast_vboost_cold \
  -late_timing_condition fast_vboost_cold \
  -early_rc_corner rc_typ_cold \
  -late_rc_corner rc_typ_cold

create_delay_corner \
  -name fast_vboost_hot_typ_rc \
  -early_timing_condition fast_vboost_hot \
  -late_timing_condition fast_vboost_hot \
  -early_rc_corner rc_typ_hot \
  -late_rc_corner rc_typ_hot



#
# Constraint modes
#
create_constraint_mode \
  -name setup_10Mb \
  -sdc_files {/home/sasha/Downloads/8b10b/scripts/lp/10Mb.sdc}

create_constraint_mode \
  -name hold_10Mb \
  -sdc_files {/home/sasha/Downloads/8b10b/scripts/lp/10Mb.sdc}

create_constraint_mode \
  -name setup_100Mb \
  -sdc_files {/home/sasha/Downloads/8b10b/scripts/lp/100Mb.sdc}

create_constraint_mode \
  -name hold_100Mb \
  -sdc_files {/home/sasha/Downloads/8b10b/scripts/lp/100Mb.sdc}



#
# Analysis views
#

# Setup views
create_analysis_view \
  -name setup_10Mb_slow_hot_vnom \
  -constraint_mode setup_10Mb \
  -delay_corner slow_vnom_hot_typ_rc \
  -power_modes {OFF_VNOM_OFF VNOM_VNOM_OFF OFF_VNOM_VNOM VNOM_VNOM_VNOM}

create_analysis_view \
  -name setup_10Mb_slow_cold_vnom \
  -constraint_mode setup_10Mb \
  -delay_corner slow_vnom_cold_typ_rc \
  -power_modes {OFF_VNOM_OFF VNOM_VNOM_OFF OFF_VNOM_VNOM VNOM_VNOM_VNOM}

create_analysis_view \
  -name setup_100Mb_slow_hot_vnom \
  -constraint_mode setup_100Mb \
  -delay_corner slow_vnom_hot_typ_rc \
  -power_modes {OFF_VBOOST_OFF VBOOST_VBOOST_OFF OFF_VBOOST_VBOOST VBOOST_VBOOST_VBOOST}

create_analysis_view \
  -name setup_100Mb_slow_cold_vnom \
  -constraint_mode setup_100Mb \
  -delay_corner slow_vnom_cold_typ_rc \
  -power_modes {OFF_VBOOST_OFF VBOOST_VBOOST_OFF OFF_VBOOST_VBOOST VBOOST_VBOOST_VBOOST}


# Hold views
create_analysis_view \
  -name hold_10Mb_fast_cold_vboost \
  -constraint_mode hold_10Mb \
  -delay_corner fast_vboost_cold_typ_rc \
  -power_modes {OFF_VNOM_OFF VNOM_VNOM_OFF OFF_VNOM_VNOM VNOM_VNOM_VNOM}

create_analysis_view \
  -name hold_10Mb_fast_hot_vboost \
  -constraint_mode hold_10Mb \
  -delay_corner fast_vboost_hot_typ_rc \
  -power_modes {OFF_VNOM_OFF VNOM_VNOM_OFF OFF_VNOM_VNOM VNOM_VNOM_VNOM}

create_analysis_view \
  -name hold_100Mb_fast_cold_vboost \
  -constraint_mode hold_100Mb \
  -delay_corner fast_vboost_cold_typ_rc \
  -power_modes {OFF_VBOOST_OFF VBOOST_VBOOST_OFF OFF_VBOOST_VBOOST VBOOST_VBOOST_VBOOST}

create_analysis_view \
  -name hold_100Mb_fast_hot_vboost \
  -constraint_mode hold_100Mb \
  -delay_corner fast_vboost_hot_typ_rc \
  -power_modes {OFF_VBOOST_OFF VBOOST_VBOOST_OFF OFF_VBOOST_VBOOST VBOOST_VBOOST_VBOOST}



#
# Analysis view
#
set_analysis_view \
  -setup { \
    setup_100Mb_slow_hot_vnom \
    setup_100Mb_slow_cold_vnom \
    setup_10Mb_slow_hot_vnom \
    setup_10Mb_slow_cold_vnom} \
  -hold { \
    hold_100Mb_fast_cold_vboost \
    hold_100Mb_fast_hot_vboost \
    hold_10Mb_fast_cold_vboost \
    hold_10Mb_fast_hot_vboost}