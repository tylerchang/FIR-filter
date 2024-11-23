# $Revision: 1.2 $
# generic switches
instname=RF1SHD
words=128
bits=64
frequency=1
ring_width=2
mux=2
drive=4
top_layer=m6-m8_m4
write_mask=off
wp_size=8
power_type=rings
horiz=met3
vert=met2
pin_space=0.0

# advanced options
cust_comment=
bus_notation=on
left_bus_delim=[
right_bus_delim=]
pwr_gnd_rename=VDD:VDD,GND:VSS
prefix=
name_case=upper
check_instname=on
diodes=on
inside_ring_type=GND
vclef-fp.inst2ring=blockages
vclef-fp.site_def=off
asvm=on

# view-specific switches which has to be specified
# for plugin views
ambit.libname=USERLIB
synopsys.libname=USERLIB
tlf.libname=USERLIB
udl.libname=USERLIB
wattwatcher.libname=USERLIB
corners=ff_1p32v_m55c,ff_1p65v_125c,tt_1p2v_25c,ss_1p08v_m55c
