#*******************************************************************************
#* This file is part of fhlow (fast handling of a lot of work), a working
#* environment that speeds up the development of and structures FPGA design
#* projects.
#* 
#* Copyright (c) 2003-2005 Markus Pfaff <markus.pfaff@fh-hagenberg.at>
#* Copyright (c) 2005 Christian Kitzler <christian.kitzler@fh-hagenberg.at>
#* Copyright (c) 2005 Simon Lasselsberger <simon.lasselsberger@fh-hagenberg.at>
#* Copyright (c) 2011-2016 Michael Roland <michael.roland@fh-hagenberg.at>
#* 
#* This program is free software: you can redistribute it and/or modify
#* it under the terms of the GNU General Public License as published by
#* the Free Software Foundation, either version 3 of the License, or
#* (at your option) any later version.
#* 
#* This program is distributed in the hope that it will be useful,
#* but WITHOUT ANY WARRANTY; without even the implied warranty of
#* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#* GNU General Public License for more details.
#* 
#* You should have received a copy of the GNU General Public License
#* along with this program.  If not, see <http://www.gnu.org/licenses/>.
#*******************************************************************************

#*******************************************************************************
#* 
#* Find documentation and grab the latest version at
#* <https://github.com/michaelroland/fhlow>
#* 
#*******************************************************************************


#*******************************************************************************
#*****  VHDL Input  ************************************************************
#*******************************************************************************

#*******************************************************************************
#* VhdlInputVersion
#* 
#* purpose:  defines the VHDL version used to compile VHDL files
#* 
#* examples:
#*     set VhdlInputVersion "1987"    for VHDL 1076-1987
#*     set VhdlInputVersion "1993"    for VHDL 1076-1993
#*     set VhdlInputVersion "2002"    for VHDL 1076-2002 (not supported by Quartus!)
#*     set VhdlInputVersion "2008"    for VHDL 1076-2008
#*
#*******************************************************************************
set VhdlInputVersion "1993"


#*******************************************************************************
#*****  Simulation Target  *****************************************************
#*******************************************************************************

#*******************************************************************************
#* VcomOptions
#* 
#* purpose:  defines additional options for vcom
#* 
#* examples:
#*     set VcomOptions "-vopt"
#* 
#*******************************************************************************
set VcomOptions ""

#*******************************************************************************
#* VsimOptions
#* 
#* purpose:  defines additional options for vsim
#* 
#* examples:
#*     set VsimOptions "-novopt"
#* 
#*******************************************************************************
set VsimOptions "-novopt"


#*******************************************************************************
#*****  Synthesis and Layout Target  *******************************************
#*******************************************************************************

#*******************************************************************************
#* ChipManufacturer
#* 
#* purpose:  defines the manufacturer of your target FPGA
#* 
#* examples:
#*     set ChipManufacturer "Xilinx"
#*     set ChipManufacturer "Altera"
#* 
#*******************************************************************************
set ChipManufacturer "Altera"

#*******************************************************************************
#* ChipFamiliy
#*
#* purpose:  defines the family of your target FPGA
#* 
#* examples:
#*     set ChipFamily "Spartan2"
#*     set ChipFamily "Cyclone"
#* 
#* note:  see the manual of your synthesis toolchain for possible values
#* 
#*******************************************************************************
set ChipFamily "Cyclone V"

#*******************************************************************************
#* ChipPart
#* 
#* purpose:  defines the part number of your target FPGA
#* 
#* examples:
#*     set ChipPart "2s150"
#*     set ChipPart "EP1C6"
#* 
#* note:  see the manual of your synthesis toolchain for possible values
#* 
#*******************************************************************************
set ChipPart "5CSEMA5"

#*******************************************************************************
#* ChipPackage
#* 
#* purpose:  defines the package of your target FPGA
#* 
#* examples:
#*     set ChipPackage "pq208"
#*     set ChipPackage "T144C"
#* 
#* note:  see the manual of your synthesis toolchain for possible values
#* 
#*******************************************************************************
set ChipPackage "F31C"

#*******************************************************************************
#* ChipSpeedgrade
#* 
#* purpose:  defines the speedgrade of your target FPGA
#* 
#* examples:
#*     set ChipSpeedgrade "5"
#*     set ChipSpeedgrade "8"
#* 
#*******************************************************************************
set ChipSpeedgrade "6"

#*******************************************************************************
#* ChipFrequency
#* 
#* purpose:  defines a global maximum frequency requirement for your target FPGA
#* 
#* examples:
#*     set ChipFrequency "48"
#*     set ChipFrequency "24"
#* 
#* note:  use the SDC file to set up multiple clock domains
#* 
#*******************************************************************************
set ChipFrequency "50"

#*******************************************************************************
#* ChipDefaultIOStandard
#* 
#* purpose:  defines the default I/O standard to be used for pins on the
#*           target FPGA
#* 
#* examples:
#*     set ChipDefaultIOStandard "2.5 V"
#*     set ChipDefaultIOStandard "3.3-V LVTTL"
#* 
#*******************************************************************************
set ChipDefaultIOStandard "2.5 V"

#*******************************************************************************
#* ChipGlobalAssignments
#* 
#* purpose:  defines parameters to be set with set_global_assignment
#* 
#* examples:
#*     set ChipGlobalAssignments {
#*         {RESERVE_ALL_UNUSED_PINS "AS INPUT TRI-STATED WITH WEAK PULL-UP"}
#*     }
#* 
#*******************************************************************************
set ChipGlobalAssignments {
    {RESERVE_ALL_UNUSED_PINS "AS INPUT TRI-STATED WITH WEAK PULL-UP"}
    {RESERVE_ASDO_AFTER_CONFIGURATION "AS INPUT TRI-STATED"}
    {RESERVE_NCEO_AFTER_CONFIGURATION "USE AS REGULAR IO"}
    {MIN_CORE_JUNCTION_TEMP 0}
    {MAX_CORE_JUNCTION_TEMP 85}
    {OPTIMIZE_MULTI_CORNER_TIMING ON}
    {NOMINAL_CORE_SUPPLY_VOLTAGE "1.1V"}
    {VCCPGM_USER_VOLTAGE "3.3V"}
    {VCCBAT_USER_VOLTAGE "2.5V"}
    {VCCRSTCLK_HPS_USER_VOLTAGE "3.3V"}
    {UNIPHY_SEQUENCER_DQS_CONFIG_ENABLE ON}
    {USE_DLL_FREQUENCY_FOR_DQS_DELAY_CHAIN ON}
}

#*******************************************************************************
#* ChipInstanceAssignments
#* 
#* purpose:  defines parameters to be set with set_instance_assignment
#* 
#* examples:
#*     set ChipInstanceAssignments {
#*         {"*|altera_pll:altera_pll_i*|*" PLL_COMPENSATION_MODE DIRECT}
#*     }
#* 
#*******************************************************************************
set ChipInstanceAssignments {
}


#*******************************************************************************
#*****  Global Pin Settings  ***************************************************
#*******************************************************************************

#*******************************************************************************
#* Pins
#* 
#* purpose:  defines to which pins the output signals of the top-level entity
#*           should be connected to
#* 
#* syntax:
#*     set Pins {
#*         {Signal FPGAPin}
#*         {Signal FPGAPin Pullup}
#*         {Signal FPGAPin Pullup IOStandard}
#*         {Signal FPGAPin Pullup IOStandard AdditionalParams}
#*         {Signal FPGAPin Pullup IOStandard {
#*             {Name Value}
#*             {Name Value}
#*         }}
#*     }
#* 
#*     -> Signal:            signal/port of top level entity (e.g. iClk)
#*     -> FPGAPin:           number/name of PIN on FPGA (e.g. A12)
#*     -> Pullup:            [optional] enable weak pull-up resistor (1=yes, 0=no)
#*     -> IOStandard:        [optional] I/O standard to use on this PIN (e.g. "3.3-V LVTTL")
#*     -> AdditionalParams:  [optional] list of additional parameters for use with set_instance_assignment on this pin
#*          -> Name:   name of parameter (e.g. INPUT_TERMINATION)
#*          -> Value:  [optional] value of parameter (e.g. "PARALLEL 50 OHM WITH CALIBRATION")
#* 
#* examples:
#*     set Pins {
#*         {oTest A88 0}
#*         {iTest B23 1 "3.3-V LVTTL"}
#*         {oAbc  C44 0 "" {
#*             {CURRENT_STRENGTH_NEW "MAXIMUM CURRENT"}
#*         }}
#*     }
#* 
#* WARNING: be very careful with this setting! check your pad reports!
#* 
#*******************************************************************************

#============================================================
# Pinout for Altera DE1-SoC Rev. E
#============================================================
set Pins {
}

# CLOCKS
append Pins {
    {iClk AF14 0 "3.3-V LVTTL"}
}

# BUTTONS (KEY0..KEY3)
append Pins {
    {inResetAsync AA14 0 "3.3-V LVTTL"}
    {inButton[1]  AA15 0 "3.3-V LVTTL"}
    {inButton[2]  W15  0 "3.3-V LVTTL"}
    {inButton[3]  Y16  0 "3.3-V LVTTL"}
}

## AUDIO CODEC (master mode)
#append Pins {
#    {oMclk   G7 0 "3.3-V LVTTL"}
#    {iBclk   H7 0 "3.3-V LVTTL"}
#    {iADClrc K8 0 "3.3-V LVTTL"}
#    {iADCdat K7 0 "3.3-V LVTTL"}
#    {iDAClrc H8 0 "3.3-V LVTTL"}
#    {oDACdat J7 0 "3.3-V LVTTL"}
#}

# AUDIO CODEC (slave mode)
append Pins {
    {oMclk   G7 0 "3.3-V LVTTL"}
    {oBclk   H7 0 "3.3-V LVTTL"}
    {oADClrc K8 0 "3.3-V LVTTL"}
    {iADCdat K7 0 "3.3-V LVTTL"}
    {oDAClrc H8 0 "3.3-V LVTTL"}
    {oDACdat J7 0 "3.3-V LVTTL"}
}

# I2C
append Pins {
    {oI2CSclk  J12 0 "3.3-V LVTTL"}
    {ioI2CSdin K12 0 "3.3-V LVTTL"}
}

# SWITCHES (SW0..SW9)
append Pins {
    {iSwitch[0] AB12 0 "3.3-V LVTTL"}
    {iSwitch[1] AC12 0 "3.3-V LVTTL"}
    {iSwitch[2] AF9  0 "3.3-V LVTTL"}
    {iSwitch[3] AF10 0 "3.3-V LVTTL"}
    {iSwitch[4] AD11 0 "3.3-V LVTTL"}
    {iSwitch[5] AD12 0 "3.3-V LVTTL"}
    {iSwitch[6] AE11 0 "3.3-V LVTTL"}
    {iSwitch[7] AC9  0 "3.3-V LVTTL"}
    {iSwitch[8] AD10 0 "3.3-V LVTTL"}
    {iSwitch[9] AE12 0 "3.3-V LVTTL"}
}

# LED (LEDR0..LEDR9)
append Pins {
    {oLed[0] V16 0 "3.3-V LVTTL"}
    {oLed[1] W16 0 "3.3-V LVTTL"}
    {oLed[2] V17 0 "3.3-V LVTTL"}
    {oLed[3] V18 0 "3.3-V LVTTL"}
    {oLed[4] W17 0 "3.3-V LVTTL"}
    {oLed[5] W19 0 "3.3-V LVTTL"}
    {oLed[6] Y19 0 "3.3-V LVTTL"}
    {oLed[7] W20 0 "3.3-V LVTTL"}
    {oLed[8] W21 0 "3.3-V LVTTL"}
    {oLed[9] Y21 0 "3.3-V LVTTL"}
}

# 7 SEGMENT (HEX0..HEX5)
append Pins {
    {oSEG0[0] AE26 0 "3.3-V LVTTL"}
    {oSEG0[1] AE27 0 "3.3-V LVTTL"}
    {oSEG0[2] AE28 0 "3.3-V LVTTL"}
    {oSEG0[3] AG27 0 "3.3-V LVTTL"}
    {oSEG0[4] AF28 0 "3.3-V LVTTL"}
    {oSEG0[5] AG28 0 "3.3-V LVTTL"}
    {oSEG0[6] AH28 0 "3.3-V LVTTL"}

    {oSEG1[0] AJ29 0 "3.3-V LVTTL"}
    {oSEG1[1] AH29 0 "3.3-V LVTTL"}
    {oSEG1[2] AH30 0 "3.3-V LVTTL"}
    {oSEG1[3] AG30 0 "3.3-V LVTTL"}
    {oSEG1[4] AF29 0 "3.3-V LVTTL"}
    {oSEG1[5] AF30 0 "3.3-V LVTTL"}
    {oSEG1[6] AD27 0 "3.3-V LVTTL"}

    {oSEG2[0] AB23 0 "3.3-V LVTTL"}
    {oSEG2[1] AE29 0 "3.3-V LVTTL"}
    {oSEG2[2] AD29 0 "3.3-V LVTTL"}
    {oSEG2[3] AC28 0 "3.3-V LVTTL"}
    {oSEG2[4] AD30 0 "3.3-V LVTTL"}
    {oSEG2[5] AC29 0 "3.3-V LVTTL"}
    {oSEG2[6] AC30 0 "3.3-V LVTTL"}

    {oSEG3[0] AD26 0 "3.3-V LVTTL"}
    {oSEG3[1] AC27 0 "3.3-V LVTTL"}
    {oSEG3[2] AD25 0 "3.3-V LVTTL"}
    {oSEG3[3] AC25 0 "3.3-V LVTTL"}
    {oSEG3[4] AB28 0 "3.3-V LVTTL"}
    {oSEG3[5] AB25 0 "3.3-V LVTTL"}
    {oSEG3[6] AB22 0 "3.3-V LVTTL"}

    {oSEG4[0] AA24 0 "3.3-V LVTTL"}
    {oSEG4[1] Y23  0 "3.3-V LVTTL"}
    {oSEG4[2] Y24  0 "3.3-V LVTTL"}
    {oSEG4[3] W22  0 "3.3-V LVTTL"}
    {oSEG4[4] W24  0 "3.3-V LVTTL"}
    {oSEG4[5] V23  0 "3.3-V LVTTL"}
    {oSEG4[6] W25  0 "3.3-V LVTTL"}

    {oSEG5[0] V25  0 "3.3-V LVTTL"}
    {oSEG5[1] AA28 0 "3.3-V LVTTL"}
    {oSEG5[2] Y27  0 "3.3-V LVTTL"}
    {oSEG5[3] AB27 0 "3.3-V LVTTL"}
    {oSEG5[4] AB26 0 "3.3-V LVTTL"}
    {oSEG5[5] AA26 0 "3.3-V LVTTL"}
    {oSEG5[6] AA25 0 "3.3-V LVTTL"}
}

## CLOCKS
#append Pins {
#    {CLOCK1_50 AF14 0 "3.3-V LVTTL"}
#    {CLOCK2_50 AA16 0 "3.3-V LVTTL"}
#    {CLOCK3_50 Y26  0 "3.3-V LVTTL"}
#    {CLOCK4_50 K14  0 "3.3-V LVTTL"}
#}
#
## GPIO_0
#append Pins {
#    {GPIO_0[0]  AC18 0 "3.3-V LVTTL"}
#    {GPIO_0[1]  Y17  0 "3.3-V LVTTL"}
#    {GPIO_0[2]  AD17 0 "3.3-V LVTTL"}
#    {GPIO_0[3]  Y18  0 "3.3-V LVTTL"}
#    {GPIO_0[4]  AK16 0 "3.3-V LVTTL"}
#    {GPIO_0[5]  AK18 0 "3.3-V LVTTL"}
#    {GPIO_0[6]  AK19 0 "3.3-V LVTTL"}
#    {GPIO_0[7]  AJ19 0 "3.3-V LVTTL"}
#    {GPIO_0[8]  AJ17 0 "3.3-V LVTTL"}
#    {GPIO_0[9]  AJ16 0 "3.3-V LVTTL"}
#    {GPIO_0[10] AH18 0 "3.3-V LVTTL"}
#    {GPIO_0[11] AH17 0 "3.3-V LVTTL"}
#    {GPIO_0[12] AG16 0 "3.3-V LVTTL"}
#    {GPIO_0[13] AE16 0 "3.3-V LVTTL"}
#    {GPIO_0[14] AF16 0 "3.3-V LVTTL"}
#    {GPIO_0[15] AG17 0 "3.3-V LVTTL"}
#    {GPIO_0[16] AA18 0 "3.3-V LVTTL"}
#    {GPIO_0[17] AA19 0 "3.3-V LVTTL"}
#    {GPIO_0[18] AE17 0 "3.3-V LVTTL"}
#    {GPIO_0[19] AC20 0 "3.3-V LVTTL"}
#    {GPIO_0[20] AH19 0 "3.3-V LVTTL"}
#    {GPIO_0[21] AJ20 0 "3.3-V LVTTL"}
#    {GPIO_0[22] AH20 0 "3.3-V LVTTL"}
#    {GPIO_0[23] AK21 0 "3.3-V LVTTL"}
#    {GPIO_0[24] AD19 0 "3.3-V LVTTL"}
#    {GPIO_0[25] AD20 0 "3.3-V LVTTL"}
#    {GPIO_0[26] AE18 0 "3.3-V LVTTL"}
#    {GPIO_0[27] AE19 0 "3.3-V LVTTL"}
#    {GPIO_0[28] AF20 0 "3.3-V LVTTL"}
#    {GPIO_0[29] AF21 0 "3.3-V LVTTL"}
#    {GPIO_0[30] AF19 0 "3.3-V LVTTL"}
#    {GPIO_0[31] AG21 0 "3.3-V LVTTL"}
#    {GPIO_0[32] AF18 0 "3.3-V LVTTL"}
#    {GPIO_0[33] AG20 0 "3.3-V LVTTL"}
#    {GPIO_0[34] AG18 0 "3.3-V LVTTL"}
#    {GPIO_0[35] AJ21 0 "3.3-V LVTTL"}
#}
#
## GPIO_1
#append Pins {
#    {GPIO_1[0]  AA21 0 "3.3-V LVTTL"}
#    {GPIO_1[1]  AB21 0 "3.3-V LVTTL"}
#    {GPIO_1[2]  AC23 0 "3.3-V LVTTL"}
#    {GPIO_1[3]  AD24 0 "3.3-V LVTTL"}
#    {GPIO_1[4]  AE23 0 "3.3-V LVTTL"}
#    {GPIO_1[5]  AE24 0 "3.3-V LVTTL"}
#    {GPIO_1[6]  AF25 0 "3.3-V LVTTL"}
#    {GPIO_1[7]  AF26 0 "3.3-V LVTTL"}
#    {GPIO_1[8]  AG25 0 "3.3-V LVTTL"}
#    {GPIO_1[9]  AB17 0 "3.3-V LVTTL"}
#    {GPIO_1[10] AG26 0 "3.3-V LVTTL"}
#    {GPIO_1[11] AH24 0 "3.3-V LVTTL"}
#    {GPIO_1[12] AH27 0 "3.3-V LVTTL"}
#    {GPIO_1[13] AJ27 0 "3.3-V LVTTL"}
#    {GPIO_1[14] AK29 0 "3.3-V LVTTL"}
#    {GPIO_1[15] AK28 0 "3.3-V LVTTL"}
#    {GPIO_1[16] AK27 0 "3.3-V LVTTL"}
#    {GPIO_1[17] AJ26 0 "3.3-V LVTTL"}
#    {GPIO_1[18] AK26 0 "3.3-V LVTTL"}
#    {GPIO_1[19] AH25 0 "3.3-V LVTTL"}
#    {GPIO_1[20] AJ25 0 "3.3-V LVTTL"}
#    {GPIO_1[21] AJ24 0 "3.3-V LVTTL"}
#    {GPIO_1[22] AK24 0 "3.3-V LVTTL"}
#    {GPIO_1[23] AG23 0 "3.3-V LVTTL"}
#    {GPIO_1[24] AK23 0 "3.3-V LVTTL"}
#    {GPIO_1[25] AH23 0 "3.3-V LVTTL"}
#    {GPIO_1[26] AK22 0 "3.3-V LVTTL"}
#    {GPIO_1[27] AJ22 0 "3.3-V LVTTL"}
#    {GPIO_1[28] AH22 0 "3.3-V LVTTL"}
#    {GPIO_1[29] AG22 0 "3.3-V LVTTL"}
#    {GPIO_1[30] AF24 0 "3.3-V LVTTL"}
#    {GPIO_1[31] AF23 0 "3.3-V LVTTL"}
#    {GPIO_1[32] AE22 0 "3.3-V LVTTL"}
#    {GPIO_1[33] AD21 0 "3.3-V LVTTL"}
#    {GPIO_1[34] AA20 0 "3.3-V LVTTL"}
#    {GPIO_1[35] AC22 0 "3.3-V LVTTL"}
#}
#
## IRDA
#append Pins {
#    {IRDA_RXD AA30 0 "3.3-V LVTTL"}
#    {IRDA_TXD AB30 0 "3.3-V LVTTL"}
#}
#
## PS2
#append Pins {
#    {PS2_CLK  AD7 0 "3.3-V LVTTL"}
#    {PS2_DAT  AE7 0 "3.3-V LVTTL"}
#    {PS2_CLK2 AD9 0 "3.3-V LVTTL"}
#    {PS2_DAT2 AE9 0 "3.3-V LVTTL"}
#}

# HPS
# (Note: Pin locations are implicitly assigned)
append Pins {
    {HPS_DDR3_ADDR[*]  {} 0 "SSTL-15 Class I" { {CURRENT_STRENGTH_NEW "MAXIMUM CURRENT"} {PACKAGE_SKEW_COMPENSATION OFF} } __hps_sdram_p0}
    {HPS_DDR3_BA[*]    {} 0 "SSTL-15 Class I" { {CURRENT_STRENGTH_NEW "MAXIMUM CURRENT"} {PACKAGE_SKEW_COMPENSATION OFF} } __hps_sdram_p0}
    {HPS_DDR3_CAS_N    {} 0 "SSTL-15 Class I" { {CURRENT_STRENGTH_NEW "MAXIMUM CURRENT"} {PACKAGE_SKEW_COMPENSATION OFF} } __hps_sdram_p0}
    {HPS_DDR3_CK_N     {} 0 "Differential 1.5-V SSTL Class I" { {D5_DELAY 2} {OUTPUT_TERMINATION "SERIES 50 OHM WITHOUT CALIBRATION"} {PACKAGE_SKEW_COMPENSATION OFF} } __hps_sdram_p0}
    {HPS_DDR3_CK_P     {} 0 "Differential 1.5-V SSTL Class I" { {D5_DELAY 2} {OUTPUT_TERMINATION "SERIES 50 OHM WITHOUT CALIBRATION"} {PACKAGE_SKEW_COMPENSATION OFF} } __hps_sdram_p0}
    {HPS_DDR3_CKE      {} 0 "SSTL-15 Class I" { {CURRENT_STRENGTH_NEW "MAXIMUM CURRENT"} {PACKAGE_SKEW_COMPENSATION OFF} } __hps_sdram_p0}
    {HPS_DDR3_CS_N     {} 0 "SSTL-15 Class I" { {CURRENT_STRENGTH_NEW "MAXIMUM CURRENT"} {PACKAGE_SKEW_COMPENSATION OFF} } __hps_sdram_p0}
    {HPS_DDR3_DM[*]    {} 0 "SSTL-15 Class I" { {OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION"} {PACKAGE_SKEW_COMPENSATION OFF} } __hps_sdram_p0}
    {HPS_DDR3_DQ[*]    {} 0 "SSTL-15 Class I" { {INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION"} {OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION"} {PACKAGE_SKEW_COMPENSATION OFF} } __hps_sdram_p0}
    {HPS_DDR3_DQS_N[*] {} 0 "Differential 1.5-V SSTL Class I" { {INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION"} {OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION"} {PACKAGE_SKEW_COMPENSATION OFF} } __hps_sdram_p0}
    {HPS_DDR3_DQS_P[*] {} 0 "Differential 1.5-V SSTL Class I" { {INPUT_TERMINATION "PARALLEL 50 OHM WITH CALIBRATION"} {OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION"} {PACKAGE_SKEW_COMPENSATION OFF} } __hps_sdram_p0}
    {HPS_DDR3_ODT      {} 0 "SSTL-15 Class I" { {CURRENT_STRENGTH_NEW "MAXIMUM CURRENT"} {PACKAGE_SKEW_COMPENSATION OFF} } __hps_sdram_p0}
    {HPS_DDR3_RAS_N    {} 0 "SSTL-15 Class I" { {CURRENT_STRENGTH_NEW "MAXIMUM CURRENT"} {PACKAGE_SKEW_COMPENSATION OFF} } __hps_sdram_p0}
    {HPS_DDR3_RESET_N  {} 0 "SSTL-15 Class I" { {CURRENT_STRENGTH_NEW "MAXIMUM CURRENT"} {PACKAGE_SKEW_COMPENSATION OFF} } __hps_sdram_p0}
    {HPS_DDR3_RZQ      {} 0 "SSTL-15 Class I" {} __hps_sdram_p0}
    {HPS_DDR3_WE_N     {} 0 "SSTL-15 Class I" { {CURRENT_STRENGTH_NEW "MAXIMUM CURRENT"} {PACKAGE_SKEW_COMPENSATION OFF} } __hps_sdram_p0}
    {HPS_SD_*          {} 0 "3.3-V LVTTL"}
    {HPS_UART_*        {} 0 "3.3-V LVTTL"}
    {HPS_KEY           {} 0 "3.3-V LVTTL"}
    {HPS_LED           {} 0 "3.3-V LVTTL"}
    {HPS_I2C_CONTROL   {} 0 "3.3-V LVTTL"}
}

append ChipInstanceAssignments {
    {"*|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|ureset|phy_reset_mem_stable_n"               GLOBAL_SIGNAL OFF __hps_sdram_p0}
    {"*|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|ureset|phy_reset_n"                          GLOBAL_SIGNAL OFF __hps_sdram_p0}
    {"*|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uio_pads|dq_ddio[0].read_capture_clk_buffer" GLOBAL_SIGNAL OFF __hps_sdram_p0}
    {"*|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_write_side[0]"   GLOBAL_SIGNAL OFF __hps_sdram_p0}
    {"*|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_wraddress[0]"    GLOBAL_SIGNAL OFF __hps_sdram_p0}
    {"*|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uio_pads|dq_ddio[1].read_capture_clk_buffer" GLOBAL_SIGNAL OFF __hps_sdram_p0}
    {"*|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_write_side[1]"   GLOBAL_SIGNAL OFF __hps_sdram_p0}
    {"*|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_wraddress[1]"    GLOBAL_SIGNAL OFF __hps_sdram_p0}
    {"*|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uio_pads|dq_ddio[2].read_capture_clk_buffer" GLOBAL_SIGNAL OFF __hps_sdram_p0}
    {"*|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_write_side[2]"   GLOBAL_SIGNAL OFF __hps_sdram_p0}
    {"*|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_wraddress[2]"    GLOBAL_SIGNAL OFF __hps_sdram_p0}
    {"*|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uio_pads|dq_ddio[3].read_capture_clk_buffer" GLOBAL_SIGNAL OFF __hps_sdram_p0}
    {"*|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_write_side[3]"   GLOBAL_SIGNAL OFF __hps_sdram_p0}
    {"*|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_wraddress[3]"    GLOBAL_SIGNAL OFF __hps_sdram_p0}
    {"*|hps_0|hps_io|border|hps_sdram_inst|pll0|fbout" PLL_COMPENSATION_MODE DIRECT __hps_sdram_p0}
}
