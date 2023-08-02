##### Projet #####

PROJECT 		?= app
# Le chemin pour les fichiers générés
BUILD_DIR 		= Build

ARM_TOOCHAIN 	?= C:/gcc-arm/bin

# Fichier de description de liaison, hc32f030
LDSCRIPT		= hc32f030.ld
# Drapeaux de compilation de bibliothèque
LIB_FLAGS       = 

# Dossiers sources C
CDIRS	:= User \
		CMSIS/HC32F030/source \
		driver/src
		
# Fichiers sources C (s'il y en a des individuels)
CFILES := 

# Dossiers sources ASM
ADIRS	:= User
# Fichiers sources ASM individuels
AFILES	:= CMSIS/HC32F030/source/startup_hc32f030.s

# Chemins d'inclusion
INCLUDES	:= CMSIS/CM0/Core \
			CMSIS/HC32F030/include \
			driver/inc \
			User

include ./rules.mk
