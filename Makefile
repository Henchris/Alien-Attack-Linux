PREFIX=/usr/local
MAN_PREFIX=$(PREFIX)
BIN_PREFIX=$(CURDIR)/bin
DATA_PREFIX=data/

XX = g++
SDL_LIB = -L/usr/local/lib -lSDL2 -lSDL2_mixer -lSDL2_image -Wl,-rpath=/usr/local/lib
GLEW_LIB = -L/usr/lib64 -lGLEW -Wl,-rpath=/usr/lib64

SDL_INCLUDE = -I /usr/local/include

CXXFLAGS = -Wall -c -g -std=c++11 -DDATA_PREFIX=\"$(DATA_PREFIX)\" $(SDL_INCLUDE) 
LDFLAGS = $(GLEW_LIB):$(SDL_LIB) -lz -lGL -ltinyxml

BIN_DIR = ./bin
SOURCES = src/AnimatedGraphic.cpp src/BulletHandler.cpp src/CollisionManager.cpp \
	src/Game.cpp src/GameObjectFactory.cpp src/GameOverState.cpp src/GameStateMachine.cpp \
	src/InputHandler.cpp src/Level.cpp src/LevelParser.cpp src/main.cpp src/MainMenuState.cpp \
	src/MapLoader.cpp src/MenuButton.cpp src/ObjectLayer.cpp src/PauseState.cpp \
	src/PlayState.cpp src/Player.cpp \
	src/ScrollingBackground.cpp src/ShooterObject.cpp src/SoundManager.cpp \
	src/StateParser.cpp src/TextureManager.cpp src/TileLayer.cpp \
	src/base64.cpp  

TARGET_BIN = $(BIN_DIR)/alienattack

all : make_dirs $(TARGET_BIN) 

$(TARGET_BIN) : $(SOURCES:.cpp=.o)
	$(CXX) $^ $(LDFLAGS) -o $@

.cpp.o: 
	$(CXX) $(CXXFLAGS) $< -o $@
	
install:
	install -d $(DATA_PREFIX)
	cp -R data/* $(DATA_PREFIX)
	chmod -R a+rX,g-w,o-w $(DATA_PREFIX)
	cp alienattack $(BIN_PREFIX)
	chmod a+rx,g-w,o-w $(BIN_PREFIX)/alienattack
	install -d $(MAN_PREFIX)/man/man6/
	cp  alienattack.6 $(MAN_PREFIX)/man/man6/
	chmod a+rx,g-w,o-w $(MAN_PREFIX)/man/man6/alienattack.6 

make_dirs :
	mkdir -p $(BIN_DIR)
	
check:
	valgrind --log-file=valgrind.output --leak-check=yes --tool=memcheck $(TARGET_BIN)

clean:
	rm -f bin/* && rm -f $(shell find . -name '*.o') 
#TESTS #########################################################################
# Testing iteration is make clean, make game-tests, ./bin/GameTests
TESTS_SOURCES = src/tests/TestMain.cpp  

game-tests: $(TESTS_SOURCES:.cpp=.o)
	$(CXX) $^ $(LDFLAGS) -lgtest -lgmock -pthread -o bin/GameTests	
