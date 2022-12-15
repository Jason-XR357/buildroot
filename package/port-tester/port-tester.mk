################################################################################
#
# port-tester
#
################################################################################

#PORT_TESTER_VERSION = 1.0
#PORT_TESTER_SITE = $(call github,rjginc,copilot_hardware_tester,$(PORT_TESTER_VERSION))
#PORT_TESTER_SITE = https://github.com/rjginc/copilot_hardware_tester/archive/refs/heads/master.zip
#PORT_TESTER_SITE = git@github.com:rjginc/copilot_hardware_tester.git
#PORT_TESTER_SOURCE = heads/master.zip
#PORT_TESTER_SITE_METHOD = git

define PORT_TESTER_BUILD_CMDS
    if [ -e $(@D)/a ]; then \
        cd $(@D)/a ; git pull; \
    else \
        git clone --single-branch -b hardware_tester git@github.com:rjginc/realtime.git $(@D)/a ; \
        cd $(@D)/a/development/library ; rm -Rf interop src/protobuf src/ProtobufBuffer.cc src/valve_gate_utility.cc ; \
        cd $(@D)/a/development/system/RTService/plugins ; rm -Rf ControlSystem ethercat HeaterTweeter Sequencer Simulator TimingSignalProcessor USB_diags mark10_driver ; \
        rm $(@D)/a/development/build_mode.cfg ; \
    fi
    cd $(@D)/a/development/library ; $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" LD="$(TARGET_LD)" BUILD_DIR=tmp TARGET_DIR=out sensor_tester=1 release
    cd $(@D)/a/development/system/RTService ; $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" LD="$(TARGET_LD)" BUILD_DIR=tmp TARGET_DIR=out sensor_tester=1 release
    cd $(@D)/a/development/system/RTService/plugins ; $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" LD="$(TARGET_LD)" BUILD_DIR=tmp TARGET_DIR=out sensor_tester=1 release
    cd $(@D)/a/development/tools/hardware_tester ; $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" LD="$(TARGET_LD)" BUILD_DIR=tmp TARGET_DIR=out sensor_tester=1 release
endef

define PORT_TESTER_INSTALL_TARGET_CMDS
    cp -Rv $(@D)/a/out/bin/* $(TARGET_DIR)/usr/bin
    cp -Rv $(@D)/a/out/lib/* $(TARGET_DIR)/usr/lib
endef

$(eval $(generic-package))
