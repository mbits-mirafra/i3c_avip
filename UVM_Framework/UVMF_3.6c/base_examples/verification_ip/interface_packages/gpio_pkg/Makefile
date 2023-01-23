# Package make targets
GPIO_PKG         = \
+incdir+$(UVMF_HOME)/base_examples/verification_ip/interface_packages/gpio_pkg \
$(DASH_F_OPTION) $(UVMF_HOME)/base_examples/verification_ip/interface_packages/gpio_pkg/gpio_filelist_hvl.f 

GPIO_PKG_HDL         = \
+incdir+$(UVMF_HOME)/base_examples/verification_ip/interface_packages/gpio_pkg \
$(DASH_F_OPTION) $(UVMF_HOME)/base_examples/verification_ip/interface_packages/gpio_pkg/gpio_filelist_hdl.f 

COMP_GPIO_PKG_TGT_0 = q_comp_gpio_pkg
COMP_GPIO_PKG_TGT_1 = v_comp_gpio_pkg
COMP_GPIO_PKG_TGT = $(COMP_GPIO_PKG_TGT_$(USE_VELOCE))

comp_gpio_pkg: $(COMP_GPIO_PKG_TGT)
	$(HDL_COMP_CMD) $(GPIO_PKG_HDL)

q_comp_gpio_pkg:
	$(HVL_COMP_CMD) $(GPIO_PKG)

v_comp_gpio_pkg: q_comp_gpio_pkg
	$(VELANALYZE_HVL_CMD) $(GPIO_PKG)

