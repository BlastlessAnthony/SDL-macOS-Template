PROJECT_NAME = SDLTemplate
BUILD_DIR = Build
BINARY_DIR = Binary
ASSETS_DIR = Assets

SOURCE_DIR = Source
SOURCES := $(sort $(shell find $(SOURCE_DIR) -name '*.c'))

INCLUDE_DIR = $(SOURCE_DIR)/Include

INCLUDES := \
	-I$(INCLUDE_DIR) \
	-I"./Dependencies/Frameworks/SDL2.framework/Headers" \
	-I"./Dependencies/Frameworks/SDL2_image.framework/Headers" \
	-I"./Dependencies/Frameworks/SDL2_mixer.framework/Headers" \
	-I"./Dependencies/Frameworks/SDL2_ttf.framework/Headers" \
	-I"./Dependencies/Frameworks/SDL2_net.framework/Headers" \


CC=clang
CPPFLAGS = $(INCLUDES) -MMD -MP
CFLAGS = -std=c17 -Wall -Wpedantic -Wextra -m64
LDFLAGS = -rpath @executable_path/../Frameworks
	
LDLIBS = \
	-F "./Dependencies/Frameworks" \
	-framework SDL2 \
	-framework SDL2_image \
	-framework SDL2_mixer \
	-framework SDL2_ttf \
	-framework SDL2_net \

OBJECTS := $(SOURCES:$(SOURCE_DIR)/%.c=$(BUILD_DIR)/%.o)
DEPENDENCIES := $(OBJECTS:.o=.d)

.PHONY: all
all: $(BINARY_DIR)/$(PROJECT_NAME).app/Contents/MacOS/$(PROJECT_NAME)

#Link object files
$(BINARY_DIR)/$(PROJECT_NAME).app/Contents/MacOS/$(PROJECT_NAME): $(OBJECTS)
	@echo "Linking Object files $@"
	@mkdir -p $(@D)
	@cp -r ./Dependencies/Frameworks/. $(BINARY_DIR)/$(PROJECT_NAME).app/Contents/Frameworks
	@cp -r $(ASSETS_DIR)/. $(BINARY_DIR)/$(PROJECT_NAME).app/Contents/Resources
	@$(CC) $(LDFLAGS) $^ $(LDLIBS) -o $@

#Compile source files
$(BUILD_DIR)/%.o: $(SOURCE_DIR)/%.c
	@echo "Compiling $<"
	@mkdir -p $(@D)
	@$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

-include $(DEPENDENCIES)


.PHONY: clean
clean:
	@echo "Removing $(BUILD_DIR) and $(BINARY_DIR) directories"
	@$(RM) -r $(BUILD_DIR)
	@$(RM) -r $(BINARY_DIR)