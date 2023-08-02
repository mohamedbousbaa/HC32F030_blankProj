# 'make V=1' affichera tous les appels du compilateur.
V		?= 0
ifeq ($(V),0)
Q		:= @
NULL	:= 2>/dev/null
endif

# Préfixe pour les outils de chaînage ARM (par défaut : arm-none-eabi-)
PREFIX		?= $(ARM_TOOCHAIN)/arm-none-eabi-
CC			= $(PREFIX)gcc
AS			= $(PREFIX)as
LD			= $(PREFIX)ld
OBJCOPY		= $(PREFIX)objcopy
# `$(shell pwd)` ou `.`, les deux fonctionnent
TOP			= .
BDIR		= $(TOP)/$(BUILD_DIR)

# Pour chaque répertoire, ajouter ses sources C à CSOURCES
CSOURCES := $(foreach dir, $(CDIRS), $(shell find $(TOP)/$(dir) -maxdepth 1 -name '*.c'))
# Ajouter des fichiers source C individuels à CSOURCES
CSOURCES += $(addprefix $(TOP)/, $(CFILES))
# Ensuite, ajouter les dossiers et fichiers source en assembleur à ASOURCES
ASOURCES := $(foreach dir, $(ADIRS), $(shell find $(TOP)/$(dir) -maxdepth 1 -name '*.s'))
ASOURCES += $(addprefix $(TOP)/, $(AFILES))

# Remplir OBJS avec les fichiers C et ASM (en préservant la structure des répertoires source)
OBJS = $(CSOURCES:$(TOP)/%.c=$(BDIR)/%.o)
OBJS += $(ASOURCES:$(TOP)/%.s=$(BDIR)/%.o)
# Fichiers .d pour détecter les changements dans les fichiers h
DEPS=$(CSOURCES:$(TOP)/%.c=$(BDIR)/%.d)

# Drapeaux spécifiés par l'architecture et la cible
ARCH_FLAGS	:= -mthumb -mcpu=cortex-m0plus -fno-common

DEBUG_FLAGS ?= -gdwarf-3

# Drapeaux de compilation pour le C
OPT			?= -Os
CSTD		?= -std=c99
TGT_CFLAGS 	+= $(ARCH_FLAGS) $(DEBUG_FLAGS) $(OPT) $(CSTD) $(addprefix -D, $(LIB_FLAGS)) -Wall -ffunction-sections -fdata-sections

# Drapeaux de compilation pour l'assembleur
TGT_ASFLAGS += $(ARCH_FLAGS) $(DEBUG_FLAGS) $(OPT) -Wa,--warn

# Drapeaux de liaison
TGT_LDFLAGS += $(ARCH_FLAGS) -specs=nano.specs -specs=nosys.specs -static -lc -lm \
				-Wl,-Map=$(BDIR)/$(PROJECT).map \
				-Wl,--gc-sections \
				-Wl,--print-memory-usage 

### chemins inclus ###
TGT_INCFLAGS := $(addprefix -I $(TOP)/, $(INCLUDES))


.PHONY: all clean flash echo

all: $(BDIR)/$(PROJECT).elf $(BDIR)/$(PROJECT).bin $(BDIR)/$(PROJECT).hex

# pour le débogage
echo:
	$(info 1. $(AFILES))
	$(info 2. $(ASOURCES))
	$(info 3. $(CSOURCES))
	$(info 4. $(OBJS))
	$(info 5. $(TGT_INCFLAGS))

# inclure les fichiers .d sans avertissement si non-existants
-include $(DEPS)

# Compiler les fichiers C en objets - devrait être `$(BDIR)/%.o: $(TOP)/%.c`, mais $(TOP) est le dossier de base, donc sans chemin fonctionne également
$(BDIR)/%.o: %.c
	@printf "  CC\t$<\n"
	@mkdir -p $(dir $@)
	$(Q)$(CC) $(TGT_CFLAGS) $(TGT_INCFLAGS) -o $@ -c $< -MD -MF $(BDIR)/$*.d -MP

# Compiler les fichiers asm en objets
$(BDIR)/%.o: %.s
	@printf "  AS\t$<\n"
	@mkdir -p $(dir $@)
	$(Q)$(CC) $(TGT_ASFLAGS) -o $@ -c $<

# Lier les fichiers objets en elf
$(BDIR)/$(PROJECT).elf: $(OBJS) $(TOP)/$(LDSCRIPT)
	@printf "  LD\t$@\n"
	$(Q)$(CC) $(TGT_LDFLAGS) -T$(TOP)/$(LDSCRIPT) $(OBJS) -o $@

# Convertir elf en binaire
%.bin: %.elf
	@printf "  OBJCP BIN\t$@\n"
	$(Q)$(OBJCOPY) -I elf32-littlearm -O binary  $< $@

# Convertir elf en hexadécimal
%.hex: %.elf
	@printf "  OBJCP HEX\t$@\n"
	$(Q)$(OBJCOPY) -I elf32-littlearm -O ihex  $< $@

clean:
	rm -rf $(BDIR)/*
