PRODUCT_VERSION_MAJOR = 17
PRODUCT_VERSION_MINOR = 0

# Increase EVO Version with each major release.
EVO_VERSION_BASE := 12.3
EVO_BUILD_TYPE ?= Unofficial

ifeq ($(EVO_BUILD_TYPE),Official)
else ifeq ($(EVO_BUILD_TYPE),Unofficial)
else
$(error EVO_BUILD_TYPE must be Official or Unofficial. Current value: $(EVO_BUILD_TYPE))
endif

# A device may state what its build actually is, via EVO_VERSION_SUFFIX.
#
# Upstream keys EVO_VERSION purely off WITH_GMS, which assumes WITH_GMS=false means "no
# Google at all". That is not always true: a device can legitimately set WITH_GMS := false
# to suppress the Google-app TIER that common_full_phone would otherwise pull in, and then
# add Play Store + GMS Core + GSF itself (see device/nubia/NX809J/gms_core.mk). Such a build
# ships GApps but was still labelled "-Vanilla" in ro.modversion, in
# ro.evolution.display.version (Settings > About) and in the OTA filename -- actively
# misleading to anyone choosing a build by name.
#
# NX809J set EVO_VERSION_SUFFIX for exactly this reason, but nothing read it, so the
# intended fix silently did nothing. This wires it up. Devices that set nothing are
# unaffected and keep the upstream behaviour below.
ifneq ($(EVO_VERSION_SUFFIX),)
EVO_VERSION := $(EVO_VERSION_BASE)-$(EVO_VERSION_SUFFIX)
else ifeq ($(WITH_GMS),true)
EVO_VERSION := $(EVO_VERSION_BASE)
else
EVO_VERSION := $(EVO_VERSION_BASE)-Vanilla
endif

# Internal version
LINEAGE_VERSION := EvolutionX-$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(shell date +%Y%m%d)-$(LINEAGE_BUILD)-$(EVO_VERSION)-$(EVO_BUILD_TYPE)

# Display version
LINEAGE_DISPLAY_VERSION := v$(EVO_VERSION)-$(shell date +%Y%m%d)

# Evolution X version properties
PRODUCT_PRODUCT_PROPERTIES += \
    ro.evolution.build.type=$(EVO_BUILD_TYPE) \
    ro.evolution.build.version=$(LINEAGE_VERSION) \
    ro.evolution.display.version=$(LINEAGE_DISPLAY_VERSION) \
    ro.evolution.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR) \
    ro.modversion=$(EVO_VERSION)
