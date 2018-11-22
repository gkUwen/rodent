# Requires the following variables:
# - ANYDSL_DIR: Path to the AnyDSL installation directory
# - EMBREE_ROOT_DIR: Path to the root of the Embree sources
# - SCENES_DIR: Path to the scenes directory

mkdir -p renderers
cd renderers

# Paths to Embree and the AnyDSL runtime
ANYDSL_RUNTIME_DIR=$ANYDSL_DIR/runtime/build/share/anydsl/cmake

# Paths to scene files
LIVING_ROOM_SCENE=$SCENES_DIR/living_room/living_room.obj
BATHROOM_SCENE=$SCENES_DIR/salle_de_bain/salle_de_bain.obj
BEDROOM_SCENE=$SCENES_DIR/bedroom/bedroom.obj
DINING_ROOM_SCENE=$SCENES_DIR/dining_room/dining_room.obj
KITCHEN_SCENE=$SCENES_DIR/kitchen/kitchen.obj
STAIRCASE_SCENE=$SCENES_DIR/wooden_staircase/wooden_staircase.obj

# The compiler may need a large stack space
ulimit -s 65536

mkdir -p living_room && cd living_room && cmake ../../.. -DEMBREE_ROOT_DIR=${EMBREE_ROOT_DIR} -DAnyDSL_runtime_DIR=${ANYDSL_RUNTIME_DIR} -DCMAKE_BUILD_TYPE=Release -DMAX_PATH_LEN=20 -DSPP=4 -DTARGET_DEVICE=$1 -DSCENE_FILE=${LIVING_ROOM_SCENE} -DDISABLE_GUI=ON && cmake --build . --target rodent &
mkdir -p bathroom && cd bathroom && cmake ../../.. -DEMBREE_ROOT_DIR=${EMBREE_ROOT_DIR} -DAnyDSL_runtime_DIR=${ANYDSL_RUNTIME_DIR} -DCMAKE_BUILD_TYPE=Release -DMAX_PATH_LEN=20 -DSPP=4 -DTARGET_DEVICE=$1 -DSCENE_FILE=${BATHROOM_SCENE} -DDISABLE_GUI=ON && cmake --build . --target rodent &
mkdir -p bedroom && cd bedroom && cmake ../../.. -DEMBREE_ROOT_DIR=${EMBREE_ROOT_DIR} -DAnyDSL_runtime_DIR=${ANYDSL_RUNTIME_DIR} -DCMAKE_BUILD_TYPE=Release -DMAX_PATH_LEN=20 -DSPP=4 -DTARGET_DEVICE=$1 -DSCENE_FILE=${BEDROOM_SCENE} -DDISABLE_GUI=ON && cmake --build . --target rodent &
mkdir -p dining_room && cd dining_room && cmake ../../.. -DEMBREE_ROOT_DIR=${EMBREE_ROOT_DIR} -DAnyDSL_runtime_DIR=${ANYDSL_RUNTIME_DIR} -DCMAKE_BUILD_TYPE=Release -DMAX_PATH_LEN=20 -DSPP=4 -DTARGET_DEVICE=$1 -DSCENE_FILE=${DINING_ROOM_SCENE} -DDISABLE_GUI=ON && cmake --build . --target rodent &
mkdir -p kitchen && cd kitchen && cmake ../../.. -DEMBREE_ROOT_DIR=${EMBREE_ROOT_DIR} -DAnyDSL_runtime_DIR=${ANYDSL_RUNTIME_DIR} -DCMAKE_BUILD_TYPE=Release -DMAX_PATH_LEN=20 -DSPP=4 -DTARGET_DEVICE=$1 -DSCENE_FILE=${KITCHEN_SCENE} -DDISABLE_GUI=ON && cmake --build . --target rodent &
mkdir -p staircase && cd staircase && cmake ../../.. -DEMBREE_ROOT_DIR=${EMBREE_ROOT_DIR} -DAnyDSL_runtime_DIR=${ANYDSL_RUNTIME_DIR} -DCMAKE_BUILD_TYPE=Release -DMAX_PATH_LEN=20 -DSPP=4 -DTARGET_DEVICE=$1 -DSCENE_FILE=${STAIRCASE_SCENE} -DDISABLE_GUI=ON && cmake --build . --target rodent &
# Wait for all tasks to finish before benchmarking
wait

cd living_room
bin/rodent --bench 10 --eye -1.8 1 -5 --dir -0.1 0 1 --up 0 1 0 --fov 60 --width 1920 --height 1088 2> /dev/null | sed -n 's/#/Living Room/p'
cd ..

cd bathroom
bin/rodent --bench 10 --eye -2.26 15.62 35.23 --dir -22.18 -5.32 -97.36 --up 0 1 0 --fov 60 --width 1920 --height 1088 2> /dev/null | sed -n 's/#/Bathroom/p'
cd ..

cd bedroom
bin/rodent --bench 10 --eye 3.5 1 3.5 --dir -1 0 -1 --up 0 1 0 --fov 60 --width 1920 --height 1088 2> /dev/null | sed -n 's/#/Bedroom/p'
cd ..

cd dining_room
bin/rodent --bench 10 --eye -4 1.3 0.0 --dir 1 -0.1 0 --up 0 1 0 --fov 48 --width 1920 --height 1088 2> /dev/null | sed -n 's/#/Dining Room/p'
cd ..

cd kitchen
bin/rodent --bench 10 --eye 0.5 1.6 3 --dir -0.4 -0.05 -1 --up 0 1 0 --fov 60 --width 1920 --height 1088 2> /dev/null | sed -n 's/#/Kitchen/p'
cd ..

cd staircase
bin/rodent --bench 10 --eye 0 1.6 4.5 --dir 0 0 -1 --up 0 1 0 --fov 38 --height 1280 --width 720 2> /dev/null | sed -n 's/#/Staircase/p'
cd ..
