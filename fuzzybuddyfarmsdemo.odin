// FuzzyBuddyFarms beta demo v.0.2.5
// an open source game created by Owen Edwards | ACS "a creative solution"
// for everyone to enjoy :) work in progress
package main

import "core:fmt"
import "core:math"
import "core:math/rand"
import "core:mem"
import "core:os"
import "core:strings"
import rl "vendor:raylib"

// constants

GAME_W        :: 640
GAME_H        :: 360
SCALE         :: 2
SCREEN_WIDTH  :: GAME_W * SCALE
SCREEN_HEIGHT :: GAME_H * SCALE
TITLE         :: "Fuzzy Buddy Farms"
TARGET_FPS    :: 60
PLAYER_SPEED  :: 105
INTERACT_DIST :: 48
NPC_COUNT     :: 24
NPC_SPEED     :: 38
ML_PER_LITER      :: 1000
HONEY_VALUE_PER_L :: 500
PLOT_COST_SMALL  :: 6500
PLOT_COST_MED    :: 8900
PLOT_COST_LARGE  :: 22000
PLOT_COST_XL     :: 45000
PLOT_COST_XXL    :: 100000
FISHING_DURATION :: f32(30)
HOME_COST        :: 200000
BOX_COST_SMALL_GROUND :: 500
BOX_COST_LARGE_GROUND :: 1000
BOX_COST_TREE         :: 1500
BOX_CAP_SMALL_GROUND  :: 500
BOX_CAP_LARGE_GROUND  :: 1000
BOX_CAP_TREE          :: 750
BOX_BEES_SMALL_GROUND :: 5
BOX_BEES_LARGE_GROUND :: 10
BOX_BEES_TREE         :: 8
START_MONEY :: 2000
NUM_HOMES   :: 5
MINIMAP_W     :: f32(120)
MINIMAP_H     :: f32(90)
MINIMAP_PAD   :: f32(4)
MINIMAP_WORLD :: f32(5000)
SAVE_MAGIC     :: u32(0xBEEF1234)
SAVE_VERSION   :: u32(22)
NUM_SAVE_SLOTS :: 3
ROAD_HALF  :: f32(36)
DIRT_HALF  :: f32(20)
PLOT_GAP   :: f32(20)
INGAME_HOUR_REAL :: f32(360)
DAY_DURATION     :: f32(8640)
NIGHT_START      :: f32(0.9)
SEASON_DURATION  :: f32(43200)
RAIN_DURATION    :: f32(360)
RAIN_INTERVAL    :: f32(720)
HIVE_LIMIT_SMALL  :: 4
HIVE_LIMIT_MEDIUM :: 5
NPC_FREEZE_DURATION :: f32(10)
CAR_SPEED        :: PLAYER_SPEED * 3.0
MAX_CARS         :: 3
CAR_ENTER_DIST   :: 40
SOCCER_FIELD_X      :: f32(690)
SOCCER_FIELD_Y      :: f32(-350)
SOCCER_FIELD_W      :: f32(340)
SOCCER_FIELD_H      :: f32(220)
SOCCER_BALL_RADIUS  :: f32(6)
SOCCER_KICK_FORCE   :: f32(180)
SOCCER_FRICTION     :: f32(0.88)
SOCCER_BOUNCE       :: f32(0.62)
SOCCER_GOALS_TO_WIN :: 3
SOCCER_NPC_SPEED    :: f32(100)
SOCCER_TACKLE_DIST  :: f32(22)
SOCCER_CHALLENGE_DIST :: f32(60)
SOCCER_BALL_BOUNCE_AMP :: f32(3)
SOCCER_BALL_BOUNCE_FREQ :: f32(6)
RACETRACK_CENTER      :: Vec2{620, 2050}
RACETRACK_OUTER_W     :: f32(860)
RACETRACK_OUTER_H     :: f32(540)
RACETRACK_INNER_W     :: f32(480)
RACETRACK_INNER_H     :: f32(180)
RACETRACK_WALL_THICK  :: f32(24)
RACETRACK_GATE_HW     :: f32(60)
MAX_TRACK_SPECTATORS :: 14
FINISH_LINE_THICK :: f32(10)
FISHING_SPOT :: Vec2{ POND_DOCK_X + POND_DOCK_WIDTH/2, POND_Y + 2 }
COL_TRACK_ASPHALT :: rl.Color{ 60,  60,  65, 255}
COL_TRACK_INFIELD :: rl.Color{ 90, 160,  70, 255}
COL_TRACK_CURB    :: rl.Color{255, 255, 255, 255}
LIGHTNING_BUG_COUNT :: 120
LIGHTNING_BUG_SPEED :: 28
LANTERN_BUGS_REQUIRED :: 10
LANTERN_CATCH_DIST     :: f32(20)
LANTERN_LIGHT_RADIUS   :: f32(70)
LANTERN_LIGHT_COLOR    :: rl.Color{255, 240, 160, 90}
POND_X		:: f32(456)
POND_Y		:: f32(-2300)
POND_W		:: f32(420)
POND_H		:: f32(320)
POND_FISH_COUNT :: 18
POND_DOCK_WIDTH :: f32(24)
POND_DOCK_X :: POND_X + POND_W/2 - POND_DOCK_WIDTH/2
ANIMAL_COUNT       :: 30
ANIMAL_WANDER_SPEED :: f32(28)
HOME_TROPHY_SLOTS :: 6
HOME_INT_W        :: f32(260)
HOME_INT_H        :: f32(180)
HOME_DECORATE_ROW_WALL   :: 0
HOME_DECORATE_ROW_FLOOR  :: 1
HOME_DECORATE_ROW_SAVE   :: 2
HOME_DECORATE_ROW_CANCEL :: 3
HOME_DECORATE_ROW_COUNT  :: 4
FLOWER_SEED_COST :: f32(80)
TREE_SEED_COST   :: f32(400)
QUEEN_BEE_COST   :: f32(10000)
BEE_NET_COST             :: f32(5000)
BEE_SWARM_SPAWN_MIN_WAIT :: f32(380)
BEE_SWARM_SPAWN_MAX_WAIT :: f32(480)
BEE_SWARM_LIFETIME       :: f32(45)
BEE_SWARM_SPEED          :: f32(24)
BEE_SWARM_CATCH_DIST     :: f32(28)
BEE_SWARM_REWARD_ML      :: f32(250)
BEE_CAM_SPEED     :: f32(220)
BEE_CAM_ZOOM      :: f32(3)
PLAYER_ZOOM_NORMAL :: f32(1.0)
PLAYER_ZOOM_CLOSE  :: f32(2.5)
BEE_CAM_BOB_AMP   :: f32(3)
BEE_CAM_BOB_FREQ  :: f32(10)
PARK_X       :: f32(-1050)
PARK_Y       :: f32(-2360)
PARK_W       :: f32(700)
PARK_H       :: f32(600)
BIRD_COUNT   :: 10
BIRD_SPEED   :: f32(26.0)
PARK_TREE_X :: PARK_X + PARK_W/2
PARK_TREE_Y :: PARK_Y + 90
FESTIVAL_DURATION  :: 6 * INGAME_HOUR_REAL
FESTIVAL_INTERVAL  :: 2 * DAY_DURATION
FESTIVAL_NPC_COUNT :: 6
FESTIVAL_SELL_MULT :: f32(2.0)
FESTIVAL_JAR_ML    :: f32(500)
COL_FESTIVAL_BANNER :: rl.Color{250, 210, 40, 255}
FOUNTAIN_RADIUS :: f32(38)
CAMERA_ROLL_MAX :: 12
BSX :: f32(350)
BEE_SANCTUARY_GOAL :: f32(10000000)
DONATE_TIER1 :: f32(1000)
DONATE_TIER2 :: f32(10000)
DONATE_TIER3 :: f32(100000)
AUCTION_MULT      :: f32(5)
AUCTION_DURATION  :: f32(90)
AUCTION_MIN_WAIT  :: f32(1800)
AUCTION_MAX_WAIT  :: f32(5400)
TAX_PER_PLOT :: f32(25000)
TAX_PER_HOME :: f32(50000)
FBF_COST :: f32(600000)
FACTORY_CONVERT_RATIO :: f32(2.5)
FACTORY_PREMIUM_MULT  :: f32(5)
FACTORY_INDOOR_BOX_COST     :: f32(150000)
FACTORY_INDOOR_BOX_CAPACITY :: f32(10000)
FACTORY_INDOOR_BOX_RATE     :: f32(6)
LIGHTSABER_HILT_COLOR  :: rl.Color{160, 160, 160, 255}
LIGHTSABER_BLADE_COLOR :: rl.Color{ 70, 160, 255, 255}
LIGHTSABER_BLADE_LEN   :: f32(22)
LIGHTSABER_HILT_LEN    :: f32(7)
LIGHTSABER_HAND_OFFSET :: Vec2{7, 2}
YODA_FOLLOW_SPEED :: f32(90)
YODA_FOLLOW_DIST  :: f32(30)
COL_YODA_SKIN  :: rl.Color{120, 168,  80, 255}
COL_YODA_ROBE  :: rl.Color{150, 120,  80, 255}
COL_YODA_ROBE2 :: rl.Color{110,  85,  55, 255}
ANIMAL_BUDDY_FOLLOW_SPEED :: f32(100)
ANIMAL_BUDDY_FOLLOW_DIST  :: f32(26)
COL_CAT_BODY   :: rl.Color{ 80,  80,  90, 255}
COL_CAT_BELLY  :: rl.Color{235, 230, 220, 255}
COL_DOG_BODY   :: rl.Color{200, 150,  90, 255}
COL_DOG_EAR    :: rl.Color{140,  95,  55, 255}
COL_FISH_BAG   :: rl.Color{170, 220, 240, 130}
COL_FISH_BODY  :: rl.Color{255, 160,  40, 255}
COL_FISH_FIN   :: rl.Color{200, 100,   0, 255}
COL_ROCK_BODY  :: rl.Color{212, 175,  55, 255}
COL_ROCK_SHINE :: rl.Color{255, 223, 120, 255}
COL_ROCK_SPARKLE :: rl.Color{255, 255, 255, 255}
COL_TURTLE_SHELL   :: rl.Color{ 90, 170,  90, 255}
COL_TURTLE_SHELL_HL :: rl.Color{130, 210, 130, 255}
COL_TURTLE_SKIN    :: rl.Color{140, 200, 110, 255}
COL_TURTLE_BELLY   :: rl.Color{225, 230, 180, 255}
COL_R2D2_WHITE     :: rl.Color{235, 235, 235, 255}
COL_R2D2_GRAY      :: rl.Color{160, 165, 170, 255}
COL_R2D2_DARKGRAY  :: rl.Color{ 90,  95, 100, 255}
COL_R2D2_BLUE      :: rl.Color{ 40,  90, 200, 255}
COL_R2D2_BLUE_LIGHT:: rl.Color{ 80, 140, 230, 255}
COL_R2D2_RED       :: rl.Color{220,  40,  40, 255}
COL_R2D2_BLACK       :: rl.Color{ 20,  20,  20, 255}
COL_R2D2_EYE_DARK   :: rl.Color{ 35,  45,  85, 255}
COL_R2D2_EYE_BLACK  :: rl.Color{ 15,  15,  20, 255}
COL_R2D2_FOOT       :: rl.Color{150, 110,  70, 255}
BANDANA_COLOR_COUNT :: 4
BANDANA_COLORS := [BANDANA_COLOR_COUNT]rl.Color{
    {60, 120, 230, 255},  // Blue
    {220, 50, 50, 255},   // Red
    {240, 140, 30, 255},  // Orange
    {160, 70, 200, 255},  // Purple
}
COL_BATMAN_BLACK :: rl.Color{ 20,  20,  20, 255}
COL_BATMAN_BLUE  :: rl.Color{ 20,  40, 170, 255}
COL_BATMAN_GREY  :: rl.Color{160, 160, 160, 255}
COL_BATMAN_GOLD  :: rl.Color{230, 180,  40, 255}
COL_BATMAN_SKIN  :: rl.Color{240, 200, 160, 255}
BATARANG_COLOR      :: rl.Color{15, 15, 15, 255}
BATARANG_HAND_OFFSET :: Vec2{7, 2}
GARAGE_COST   :: f32(325000)
GARAGE_W      :: f32(200)
GARAGE_H      :: f32(150)
GARAGE_X      :: CDX + CDW + 120
GARAGE_Y      :: BROW_DEALER
GARAGE_INT_W  :: f32(320)
GARAGE_INT_H  :: f32(200)
GARAGE_SLOT_GAP :: f32(80)
COL_GARAGE    :: rl.Color{ 90,  90, 100, 255}
CAR_CUSTOMIZE_ROW_CAR    :: 0
CAR_CUSTOMIZE_ROW_COLOR  :: 1
CAR_CUSTOMIZE_ROW_SAVE   :: 2
CAR_CUSTOMIZE_ROW_CANCEL :: 3
CAR_CUSTOMIZE_ROW_COUNT  :: 4
MARKET_MENU_ROW_PRICE :: 0
MARKET_MENU_ROW_CLOSE :: 1
MARKET_MENU_ROW_COUNT :: 2
FARMERS_MARKET_W :: f32(180)
FARMERS_MARKET_H :: f32(130)
FARMERS_MARKET_X :: GARAGE_X + GARAGE_W + 60
FARMERS_MARKET_Y :: BROW_DEALER
FARMERS_MARKET_COST :: f32(50000)
MARKET_SALE_ML      :: f32(2500)
MARKET_PRICE_MIN    :: f32(1800)
MARKET_PRICE_MAX    :: f32(4200)
MARKET_PRICE_STEP   :: f32(100)
MARKET_INTERACT_DIST :: f32(40)
FESTIVAL_ROW_SELL :: 0
FESTIVAL_ROW_BUY  :: 1
FESTIVAL_ROW_EXIT :: 2
FESTIVAL_ROW_COUNT :: 3
COL_MARKET_STALL  :: rl.Color{200, 160, 90, 255}
COL_MARKET_AWNING :: rl.Color{200, 60, 60, 255}
PHONE_W          :: f32(140)
PHONE_H          :: f32(220)
PHONE_MARGIN     :: f32(8)
PHONE_BORDER     :: f32(3)
COL_PHONE_BORDER :: rl.Color{250, 210, 40, 255}
COL_PHONE_SCREEN :: rl.Color{20, 20, 25, 255}
PHONE_APP_COUNT  :: 8
PHONE_APP_NAMES := [PHONE_APP_COUNT]string{
    "Contacts", "Inventory", "Photo Album",
    "Discovered", "Achievements", "Stats", "Help", "Buzzy Bee",
}
HELP_LINES := []string{
    "== KEYBINDS ==",
    "WASD - Move",
    "F5 - Save/Load",
    "F4 - Stats",
    "SPACE - Phone",
    "1 - Customize Player",
    "2 - Achievements",
    "3 - Customize Home",
    "4 - Weather Forecast",
    "5 - Animal Buddy",
    "6 - Bee POV",
    "7 - Easter Egg",
    "8 - Easter Egg",
    "9 - Lightning Bug Lantern",
    "0 - Bee Net",
    "E - Interact",
    "M - Map",
    "Z - Zoom",
    "I - Inventory",
    "L - List Animals",
    "",
    "== BUILDINGS ==",
    "E - Enter/Exit",
    "O - Options",
    "3 - Customize Home",
    "",
    "== CAMERA ==",
    "C - Cature Photo",
    "P - Photo Album",
    "R - Remove Photo",
    "",
    "== SOCCER ==",
    "C - Challenge",
    "X - Slide Tackle",
    "H - Help page",
    "",
    "== CAR ==",
    "ARROW KEYS - Drive",
    "C - Enter/Exit",
    "",
    "== LAND PLOT ==",
    "T - Plant Tree",
    "F - Plant Flower",
    "Q - Deploy Queen Bee",
    "",
    "== SYSTEM ==",
    "ESC - Close Game",
    " SAVE FIRST!!! ",
    "",
}

ACH_MONEY_10K         :: 0
ACH_MONEY_50K         :: 1
ACH_SOLD_NPC          :: 2
ACH_SOLD_BANK         :: 3
ACH_BOUGHT_PLOT       :: 4
ACH_BOUGHT_HOME       :: 5
ACH_ALL_HOMES         :: 6
ACH_CHALLENGED_MESSY  :: 7
ACH_WON_SOCCER        :: 8
ACH_DONATED_SANCTUARY :: 9
ACH_FIRST_PHOTO       :: 10
ACH_DISCOVERED_ANIMAL :: 11
ACH_DISCOVERED_FISH   :: 12
ACH_SWAM_POND         :: 13
ACH_RODE_CAR          :: 14
ACHIEVEMENT_COUNT     :: 15
ACHIEVEMENT_NAMES := [ACHIEVEMENT_COUNT]string{
    "First $10,000 Earned",
    "First $100,000 Earned",
    "Sold Honey to an NPC",
    "Sold Honey to the Bank",
    "Purchased a Land Plot",
    "Bought a home",
    "Bought all homes",
    "Challenged Messy to Soccer",
    "Won a Soccer Match",
    "Donated to the Bee Sanctuary",
    "Took Your First Photo",
    "Discovered an Animal",
    "Discovered a Fish",
    "Went for a Swim",
    "Rode in a Car",
}
RELATIONSHIP_MAX         :: f32(100)
RELATIONSHIP_TALK_GAIN   :: f32(2)
RELATIONSHIP_TRADE_GAIN  :: f32(5)
RELATIONSHIP_TIER_COUNT :: 5
RELATIONSHIP_TIER_NAMES := [RELATIONSHIP_TIER_COUNT]string{
    "Stranger", "Neighbor", "Friend", "BFF", "Homie",
}
RELATIONSHIP_TIER_THRESHOLDS := [RELATIONSHIP_TIER_COUNT]f32{
    0, 20, 40, 60, 80,
}
RELATIONSHIP_TIER_COLORS := [RELATIONSHIP_TIER_COUNT]rl.Color{
    {150, 150, 150, 255},  // Stranger - grey
    {120, 180, 220, 255},  // Acquaintance - blue
    {90, 200, 110, 255},   // Friend - green
    {240, 200, 50, 255},   // Good Friend - gold
    {230, 90, 160, 255},   // Best Friend - pink
}
POLICE_TV_COUNT         :: 3
POLICE_TV_CYCLE_SECONDS :: f32(4)
PLAYER_STAT_MAX          :: f32(100)
PLAYER_STAT_LOW          :: f32(30)
HUNGER_DECAY_RATE        :: f32(0.25)
THIRST_DECAY_RATE        :: f32(0.50)
STARVATION_TICK_SECONDS  :: f32(4)
STARVATION_DAMAGE        :: f32(2)
DEATH_BLACKOUT_SECONDS   :: f32(2)
DEATH_MONEY_PENALTY_PCT  :: f32(0.5)
FOOD_HUNGER_RESTORE   :: f32(9)
DRINK_HUNGER_RESTORE  :: f32(1)
DRINK_THIRST_RESTORE  :: f32(8)
HEALTH_REGEN_THRESHOLD :: f32(50)
HEALTH_REGEN_RATE      :: f32(4)
BUZZY_PLAY_W    :: f32(126)
BUZZY_PLAY_H    :: f32(170)
BUZZY_GROUND_H  :: f32(14)
BUZZY_BEE_X    :: f32(30)
BUZZY_BEE_SIZE :: f32(8)
BUZZY_GRAVITY   :: f32(260)
BUZZY_FLAP_VEL  :: f32(-95)
BUZZY_PIPE_SPEED   :: f32(40)
BUZZY_PIPE_GAP     :: f32(50)
BUZZY_PIPE_SPACING :: f32(70)
BUZZY_PIPE_W       :: f32(14)

// ENUMS

PlotSize :: enum { Small, Medium, Large, XLarge, XXLarge }
BoxType  :: enum { SmallGround, LargeGround, TreeHang }
PhoneScreen :: enum { Home, Contacts, ContactDetail, Help, BuzzyBee }
BuildingType :: enum {
    Market, SheriffOffice, DoctorOffice, Bank, Diner, Bar, CarDealership, BeeSanctuary, FuzzyBuddyFactory, Garage, FarmersMarket,
}

GameState :: enum {
    MainMenu,
    HelpMenu,
    MultiplayerMenu,
    MultiplayerIPEntry,
    MultiplayerLobby,
    MultiplayerHostPassphrase,
    World,
    Interior,
    ShopMenu, LandMenu, BankMenu, DinerMenu, BarMenu, DoctorMenu, SheriffMenu, FuzzyBuddyMenu,
    HomeMenu,
    EditHomeMenu,
    EditHomeColorMenu,
    HomeInterior,
    HomeDecorateMenu,
    HomeTrophyMenu,
    HomeTrophyPickMenu,
    SaveMenu,
    NPCMenu,
    HiveAddressMenu,
    CarDealerMenu,
    BeeSanctuaryMenu,
    GarageInterior,
    FarmersMarketInterior,
}

NPCType :: enum { Farmer, Civilian }

Season :: enum { Spring, Summer, Fall, Winter }

AnimalBuddyType :: enum { Cat, Turtle, Dog, Goldfish, R2D2, GoldenRock }
ANIMAL_BUDDY_COUNT :: 6
ANIMAL_BUDDY_NAMES := [ANIMAL_BUDDY_COUNT]string{
    "Cat", "Ninja Turtle", "Dog", "Goldfish", "R2D2", "Golden Rock",
}
ANIMAL_BUDDY_COSTS := [ANIMAL_BUDDY_COUNT]f32{
    100000, 125000, 150000, 200000, 325000, 500000,
}

// NPC clothing
ClothingPattern :: enum { Solid, Stripes, Dots, Plaid, Checkered }
CUSTOMIZE_PALETTE_COUNT :: 12
CUSTOMIZE_PATTERN_COUNT :: 5
CUSTOMIZE_PALETTE := [CUSTOMIZE_PALETTE_COUNT]rl.Color{
    { 220,  40,  40, 255}, // 0  Red
    { 240, 140,  30, 255}, // 1  Orange
    { 250, 210,  40, 255}, // 2  Yellow
    {  80, 200,  90, 255}, // 3  Green
    {  60, 210, 210, 255}, // 4  Cyan
    {  40,  80, 200, 255}, // 5  Blue
    { 138,  43, 226, 255}, // 6  Purple
    { 230,  90, 200, 255}, // 7  Pink
    { 140,  90,  50, 255}, // 8  Brown
    {  30,  30,  30, 255}, // 9  Black
    { 235, 235, 240, 255}, // 10 White
    { 150, 150, 150, 255}, // 11 Grey
}

CUSTOMIZE_PALETTE_NAMES := [CUSTOMIZE_PALETTE_COUNT]string{
    "Red","Orange","Yellow","Green","Cyan","Blue",
    "Purple","Pink","Brown","Black","White","Grey",
}

CUSTOMIZE_PATTERN_NAMES := [CUSTOMIZE_PATTERN_COUNT]string{
    "Solid","Stripes","Dots","Plaid","Checkered",
}
CUSTOMIZE_ROW_SHIRT         :: 0
CUSTOMIZE_ROW_PANTS         :: 1
CUSTOMIZE_ROW_HAT           :: 2
CUSTOMIZE_ROW_SKIN	    :: 3
CUSTOMIZE_ROW_PATTERN       :: 4
CUSTOMIZE_ROW_PATTERN_COLOR :: 5
CUSTOMIZE_ROW_SAVE          :: 6
CUSTOMIZE_ROW_CANCEL        :: 7
CUSTOMIZE_ROW_COUNT         :: 8
SKIN_PALETTE_COUNT :: 6
SKIN_PALETTE := [SKIN_PALETTE_COUNT]rl.Color{
    {255, 224, 189, 255}, // Light
    {241, 194, 125, 255}, // Fair
    {224, 172, 105, 255}, // Tan
    {198, 134, 66,  255}, // Medium
    {141, 85,  36,  255}, // Deep
    {92,  51,  23,  255}, // Dark
}
CarType :: enum { HoneyRacer, BeeCruiser, PollenGT }
SoccerState :: enum { Idle, Playing, GoalFlash, GameOver }
AnimalType :: enum { Rabbit, Fox, Deer, Squirrel, Frog, Butterfly }
FishType :: enum { Bass, Trout, Catfish, Goldfish, Pike, Perch }
TrophyKind :: enum { Empty, Animal, Fish, Photo }


// Inventory item
InventoryItem :: struct {
    name:     string,
    quantity: int,
}

// SAVE STRUCTS

SaveSlotHeader :: struct {
    used:              bool,
    name:              [32]u8,
    timestamp:         [32]u8,
    money:             f32,
}

SaveVec2 :: struct { x, y: f32 }

SavePlot :: struct {
    rect:            [4]f32,
    size:            PlotSize,
    cost:            f32,
    owned:           bool,
    owner_is_player: bool,
    tree_count:      int,
    flower_count:    int,
    box_count:       int,
}

SaveBeeBox :: struct {
    pos:       [2]f32,
    kind:      BoxType,
    honey_ml:  f32,
    capacity:  f32,
    bee_count: int,
    active:    bool,
    on_plot:   int,
}

SaveData :: struct {
    magic:          u32,
    version:        u32,
    header:         SaveSlotHeader,
    player_pos:     [2]f32,
    honey_ml:       f32,
    money:          f32,
    owned_plot:     int,
    homes_owned:    [NUM_HOMES]bool,
    plot_count:     int,
    box_count:      int,
}
SaveCar :: struct {
    kind:   CarType,
    owned:  bool,
    active: bool,
    pos:    [2]f32,
    angle:  f32,
}

// game structs

Vec2 :: rl.Vector2

Player :: struct {
    pos:        Vec2,
    honey_ml:   f32,
    money:      f32,
    owned_plot: int,
    shirt_color:      rl.Color,
    pants_color:      rl.Color,
    hat_color:        rl.Color,
    clothing_pattern: ClothingPattern,
    pattern_color:    rl.Color,
    skin_color:	      rl.Color,
    health: f32,
    hunger: f32,
    thirst: f32,
}


BeeBox :: struct {
    pos:       Vec2,
    kind:      BoxType,
    honey_ml:  f32,
    capacity:  f32,
    bee_count: int,
    active:    bool,
    on_plot:   int,
    queen_tier: int,
}
BuzzyPipe :: struct {
    x:      f32,
    gap_y:  f32,
    passed: bool,
}

BuzzyBeeState :: struct {
    buzzybee_y:      f32,
    buzzybee_vel:    f32,
    pipes:       [dynamic]BuzzyPipe,
    score:       int,
    high_score:  int,
    started:     bool,
    game_over:   bool,
    spawn_timer: f32,
    wing_timer:  f32,
}

LandPlot :: struct {
    rect:            rl.Rectangle,
    size:            PlotSize,
    cost:            f32,
    owned:           bool,
    owner_is_player: bool,
    trees:           [dynamic]Vec2,
    flowers:         [dynamic]Vec2,
    boxes:           [dynamic]int,
    address:         string,
}

Building :: struct {
    kind:  BuildingType,
    rect:  rl.Rectangle,
    label: string,
    color: rl.Color,
    door:  Vec2,
    owned: bool,
    cost:  f32,
}

Home :: struct {
    rect:    rl.Rectangle,
    color:   rl.Color,
    door:    Vec2,
    owned:   bool,
    label:   string,
    interior_wall_color:  rl.Color,
    interior_floor_color: rl.Color,
    trophies: [HOME_TROPHY_SLOTS]Trophy,
}

NPC :: struct {
    pos:              Vec2,
    kind:             NPCType,
    color:            rl.Color,
    target:           Vec2,
    timer:            f32,
    name:             string,
    sell_item:        string,
    sell_price:       f32,
    buy_item:         string,
    buy_price:        f32,
    dialogue:         [3]string,
    frozen_timer:     f32,
    shirt_color:      rl.Color,
    pants_color:      rl.Color,
    hat_color:        rl.Color,
    clothing_pattern: ClothingPattern,
    pattern_color:    rl.Color,
    market_cooldown: f32,
    at_market:       bool,
    food_item:        string,
    food_price:       f32,
    drink_item:       string,
    drink_price:      f32,
}
Car :: struct {
    pos:       Vec2,
    angle:     f32,
    kind:      CarType,
    body_col:  rl.Color,
    owned:     bool,
    active:    bool,
    occupied:  bool,
    in_garage: bool,
}


ShopItem :: struct {
    label: string,
    cost:  f32,
    kind:  BoxType,
}

CollisionRect :: rl.Rectangle


MainMenuFlower :: struct {
    x, y: f32,
    seed: int,
}
LightningBug :: struct {
    pos:        Vec2,
    target:     Vec2,
    timer:      f32,
    flash_time: f32,
}
SoccerBall :: struct {
    pos:        Vec2,
    vel:        Vec2,
    bob_time:   f32,
}

SoccerNPC :: struct {
    pos:        Vec2,
    target:     Vec2,
    timer:      f32,
    frozen:     f32,
}

SoccerGame :: struct {
    state:           SoccerState,
    ball:            SoccerBall,
    npc:             SoccerNPC,
    player_score:    int,
    npc_score:       int,
    goal_flash_time: f32,
    last_scorer:     int,
    show_help:       bool,
    game_over_timer: f32,
    field_x:  f32,
    field_y:  f32,
    field_w:  f32,
    field_h:  f32,
    goal_left_y1:  f32,
    goal_left_y2:  f32,
    goal_right_y1: f32,
    goal_right_y2: f32,
}
Animal :: struct {
    pos:        Vec2,
    target:     Vec2,
    kind:       AnimalType,
    timer:      f32,
    idle_time:  f32,
    is_idle:    bool,
    anim_time:  f32,
    color:      rl.Color,
}
Bird :: struct {
    pos:       Vec2,
    target:    Vec2,
    timer:     f32,
    idle_time: f32,
    is_idle:   bool,
    anim_time: f32,
    color:     rl.Color,
}
BeeSwarm :: struct {
    pos:            Vec2,
    target:         Vec2,
    active:         bool,
    wander_timer:   f32,
    life_timer:     f32,
    spawn_cooldown: f32,
    anim_time:      f32,
}
Fish :: struct {
    pos:       Vec2,
    vel:       Vec2,
    kind:      FishType,
    timer:     f32,
    anim_time: f32,
    flip:      bool,
    depth:     f32,
    dive_time: f32,
    is_deep:   bool,
}
Trophy :: struct {
    kind:       TrophyKind,
    animal:     AnimalType,
    fish:       FishType,
    photo_tex:  rl.Texture2D,
    photo_file: string,
}
Photo :: struct {
    texture:  rl.Texture2D,
    filename: string,
}
Pond :: struct {
    fish:	 [POND_FISH_COUNT]Fish,
    ripple_time: f32,
    wave_time:	 f32,
}
Yoda :: struct {
    pos:       Vec2,
    visible:   bool,
    anim_time: f32,
}
AnimalBuddy :: struct {
    pos:       Vec2,
    visible:   bool,
    kind:      AnimalBuddyType,
    anim_time: f32,
    bandana_idx: int,
}
InventoryRow :: struct {
    text:   string,
    color:  rl.Color,
    usable: bool,
    on_use: proc(),
}
RaceTimer :: struct {
    active:      bool,
    enabled:     bool,   // <-- new: master on/off switch
    current_lap: f64,
    last_lap:    f64,
    best_lap:    f64,
    laps:        int,
    prev_side:   bool,
    had_prev:    bool,
}

Game :: struct {
    state:              GameState,
    player:             Player,
    inv_food_count:  int,
    inv_drink_count: int,
    starvation_timer:  f32,
    death_active:      bool,
    death_timer:       f32,
    death_return_pos:  Vec2,
    camera:             rl.Camera2D,
    phone_open:   	bool,
    phone_cursor: 	int,
    phone_screen:         PhoneScreen,
    phone_contact_cursor: int,
    selected_contact:     int,
    phone_last_message:   string,
    phone_help_scroll: int,
    buzzy: BuzzyBeeState,
    buildings:          [BuildingType]Building,
    homes:              [NUM_HOMES]Home,
    plots:              [dynamic]LandPlot,
    bee_boxes:          [dynamic]BeeBox,
    npcs:               [NPC_COUNT]NPC,
    npc_met: [NPC_COUNT]bool,
    npc_relationship: [NPC_COUNT]f32,
    collision_rects:    [dynamic]CollisionRect,
    message:            string,
    message_timer:      f32,
    dt:                 f32,
    shop_items:         [3]ShopItem,
    selected_plot:      int,
    selected_home:      int,
    edit_home_color_idx: int,
    edit_home_color_backup_idx: int,
    interior_home:        int,
    home_option_open:     bool,
    home_option_cursor:   int,
    trophy_slot_editing:  int,
    selected_npc:       int,
    render_tex:         rl.RenderTexture2D,
    minimap_full:       bool,
    menu_cursor:        int,
    menu_action:        bool,
    shop_page:          int,
    fbf_page:           int,
    fbf_indoor_owned:      bool,
    fbf_indoor_honey_ml:   f32,
    interior_building:  BuildingType,
    prev_world_pos:     Vec2,
    save_headers:       [NUM_SAVE_SLOTS]SaveSlotHeader,
    save_rename_slot:   int,
    save_rename_buf:    [32]u8,
    save_rename_len:    int,
    day_time:           f32,
    is_night:           bool,
    season_time:        f32,
    season:             Season,
    rain_timer:         f32,
    rain_cooldown:      f32,
    weather_menu_open:    bool,
    weather_state_timer:  f32,
    inventory_open:     bool,
    inventory_cursor:   int,
    customize_open:              bool,
    customize_cursor:            int,
    customize_shirt_idx:         int,
    customize_pants_idx:         int,
    customize_hat_idx:           int,
    customize_pattern_idx:       int,
    customize_pattern_color_idx: int,
    customize_skin_idx: int,
    backup_skin_idx:    int,
    backup_shirt_idx:            int,
    backup_pants_idx:            int,
    backup_hat_idx:              int,
    backup_pattern_idx:          int,
    backup_pattern_color_idx:    int,
    car_customize_open:      bool,
    car_customize_cursor:    int,
    car_customize_car_idx:   int,
    car_customize_color_idx: int,
    backup_car_color_idx:    int,
    inv_flower_seeds:	int,
    inv_tree_seeds:	int,
    inv_queen_bees:     int,
    inv_bee_net:      bool,
    bee_net_active:   bool,
    lightning_bugs_caught: int,
    inv_lantern:           bool,
    lantern_active:        bool,
    bee_swarm:        BeeSwarm,
    inv_lightsaber:    bool,
    lightsaber_active: bool,
    yoda:              Yoda,
    owned_animal_buddies: [ANIMAL_BUDDY_COUNT]bool,
    animal_buddy:         AnimalBuddy,
    animal_menu_open:     bool,
    animal_menu_cursor:   int,
    turtle_bandana_idx: int,
    inv_batarang:      bool,
    batarang_active:   bool,
    bee_cam_active:      bool,
    player_zoom_active:  bool,
    bee_cam_pos:         Vec2,
    bee_cam_angle:       f32,
    bee_cam_anim_time:   f32,
    bee_cam_prev_target: Vec2,
    bee_cam_prev_zoom:   f32,
    bee_cam_return_pos:  Vec2,
    interior_option_open: bool,
    interior_option_cursor: int,
    bank_stock_cursor:  int,
    hive_address_cursor: int,
    hive_address_kind:   BoxType,
    main_menu_cursor:   int,
    main_menu_mode:     int,
    suppress_enter_this_frame: bool,
    mp_ip_buf:      [16]u8,
    mp_ip_len:      int,
    mp_cursor_blink: f32,
    mp_pass_buf:   [NET_PASSPHRASE_LEN]u8,
    mp_pass_len:   int,
    mp_join_focus: int,
    pending_host_passphrase_buf: [NET_PASSPHRASE_LEN]u8,
    pending_host_passphrase_len: int,
    pending_host_after_load: bool,
    honey_stock_history: [12]f32,
    honey_stock_season:  [12]Season,
    honey_stock_count:   int,
    main_menu_flowers:  [28]MainMenuFlower,
    menu_frame_skip:    bool,
    cars:            [MAX_CARS]Car,
    in_car:          bool,
    current_car:     int,
    lightning_bugs: [LIGHTNING_BUG_COUNT]LightningBug,
    soccer: SoccerGame,
    animals: [ANIMAL_COUNT]Animal,
    player_in_water:  bool,
    pond: Pond,
    fishing_active:      bool,
    fishing_timer:       f32,
    input_e_consumed:    bool,
    birds: [BIRD_COUNT]Bird,
    bear_anim_time: f32,
    camera_roll:      [dynamic]Photo,
    album_open:        bool,
    album_viewing:     bool,
    album_cursor:      int,
    photo_seq:         int,
    input_c_consumed:  bool,
    discovered_open:    bool,
    discovered_animals: [AnimalType]bool,
    discovered_fish:    [FishType]bool,
    sanctuary_donated:    f32,
    sanctuary_bee_count:  int,
    police_tv_index: int,
    police_tv_timer: f32,
    achievements_open:     bool,
    achievements_cursor:   int,
    achievements_unlocked: [ACHIEVEMENT_COUNT]bool,
    auction_timer:        f32,
    auction_cooldown:     f32,
    stats_open:                bool,
    total_honey_produced_ml:   f32,
    total_honey_sold_ml:       f32,
    total_money_earned:        f32,
    total_play_time:           f32,
    honey_product_ml:          f32,
    market_price:       f32,
    market_menu_open:   bool,
    market_menu_cursor: int,
    festival_active:      bool,
    festival_timer:       f32,
    festival_cooldown:    f32,
    festival_npcs:        [FESTIVAL_NPC_COUNT]NPC,
    festival_menu_open:   bool,
    festival_menu_cursor: int,
    festival_menu_npc:    int,

}

g: Game

gallery_textures: [1]rl.Texture2D
gallery_names    : [1]string = { "Bills Painting" }

// COLORS FINALLY fuck python for naming their colors "colours"

COL_SKY          :: rl.Color{ 74, 122, 150, 255}
COL_SKY2         :: rl.Color{ 52,  90, 120, 255}
COL_GRASS        :: rl.Color{ 58,  90,  28, 255}
COL_GRASS2       :: rl.Color{ 76, 112,  36, 255}
COL_GRASS3       :: rl.Color{ 92, 132,  44, 255}
COL_ROAD         :: rl.Color{ 64,  60,  56, 255}
COL_ROAD_LINE    :: rl.Color{ 88,  84,  76, 255}
COL_DIRT_ROAD    :: rl.Color{139, 105,  60, 255}
COL_DIRT_ROAD2   :: rl.Color{120,  88,  48, 255}
COL_SIDEWALK     :: rl.Color{172, 160, 140, 255}
COL_SIDEWALK2    :: rl.Color{148, 136, 116, 255}
COL_TREE_TRUNK   :: rl.Color{ 88,  56,  28, 255}
COL_TREE_LEAF    :: rl.Color{ 36, 108,  36, 255}
COL_TREE_LEAF2   :: rl.Color{ 52, 140,  52, 255}
COL_TREE_DARK    :: rl.Color{ 24,  72,  24, 255}
COL_FLOWER_Y     :: rl.Color{240, 200,   0, 255}
COL_FLOWER_P     :: rl.Color{200,  80, 180, 255}
COL_FLOWER_W     :: rl.Color{240, 240, 240, 255}
COL_FLOWER_R     :: rl.Color{220,  60,  60, 255}
COL_FLOWER_B     :: rl.Color{ 80, 160, 220, 255}
COL_HONEY        :: rl.Color{240, 160,   0, 255}
COL_HONEY2       :: rl.Color{255, 200,  40, 255}
COL_BOX_S        :: rl.Color{196, 164, 120, 255}
COL_BOX_L        :: rl.Color{148, 108,  68, 255}
COL_BOX_T        :: rl.Color{108,  72,  36, 255}
COL_HUD_BG       :: rl.Color{  8,   8,  12, 200}
COL_PANEL        :: rl.Color{ 20,  16,  10, 240}
COL_PANEL2       :: rl.Color{ 32,  24,  14, 240}
COL_PANEL_BORDER :: rl.Color{180, 140,  40, 255}
COL_BTN          :: rl.Color{ 48,  36,  16, 255}
COL_BTN_HOV      :: rl.Color{ 88,  68,  28, 255}
COL_TEXT         :: rl.Color{240, 224, 180, 255}
COL_TEXT2        :: rl.Color{200, 188, 148, 255}
COL_GREEN_TEXT   :: rl.Color{ 88, 200,  88, 255}
COL_RED_TEXT     :: rl.Color{210,  72,  72, 255}
COL_MARKET       :: rl.Color{200, 140,  48, 255}
COL_SHERIFF      :: rl.Color{ 56,  88, 168, 255}
COL_DOCTOR       :: rl.Color{180, 212, 240, 255}
COL_BANK         :: rl.Color{160, 144, 104, 255}
COL_DINER        :: rl.Color{200,  68,  48, 255}
COL_BAR   	 :: rl.Color{ 64,  32,  16, 255}
COL_DEALER_STEEL :: rl.Color{ 48,  56,  72, 255}
COL_DEALER_GLASS :: rl.Color{160, 210, 240, 180} 
COL_DEALER_GLASS2:: rl.Color{120, 180, 220, 140}
COL_DEALER_TRIM  :: rl.Color{200, 210, 220, 255}
COL_DEALER_FLOOR :: rl.Color{220, 220, 228, 255}
COL_DEALER_SIGN  :: rl.Color{ 20, 160, 255, 255}  
COL_CAR_RED      :: rl.Color{220,  40,  40, 255}
COL_CAR_BLUE     :: rl.Color{ 40,  80, 200, 255}
COL_CAR_YELLOW   :: rl.Color{240, 200,  20, 255}
COL_CAR_WHITE    :: rl.Color{235, 235, 240, 255}
COL_CAR_WINDOW   :: rl.Color{140, 190, 220, 200}
COL_CAR_WHEEL    :: rl.Color{ 28,  28,  28, 255}
COL_CAR_CHROME   :: rl.Color{200, 210, 220, 255}
COL_BRICK        :: rl.Color{140,  80,  56, 255}
COL_BRICK2       :: rl.Color{120,  64,  44, 255}
COL_ROOF         :: rl.Color{ 80,  56,  40, 255}
COL_ROOF2        :: rl.Color{ 60,  40,  28, 255}
COL_CHIMNEY      :: rl.Color{ 96,  72,  56, 255}
COL_WATER        :: rl.Color{ 80, 140, 200, 255}
COL_WATER2       :: rl.Color{100, 164, 220, 255}
COL_SHADOW       :: rl.Color{  0,   0,   0,  48}
COL_PATH         :: rl.Color{160, 148, 120, 255}
COL_FENCE        :: rl.Color{200, 180, 140, 255}
COL_INT_FLOOR    :: rl.Color{180, 160, 120, 255}
COL_INT_WALL     :: rl.Color{140, 110,  80, 255}
COL_CAR_ICON     :: rl.Color{255, 220,  40, 255}
COL_SANCTUARY    :: rl.Color{ 90, 190,  90, 255}
COL_FACTORY      :: rl.Color{210, 140,  40, 255}
COL_BAR_BG       :: rl.Color{ 40,  40,  40, 255}
COL_BAR_BORDER   :: rl.Color{ 20,  20,  20, 255}
COL_HEALTH       :: rl.Color{ 60, 200,  80, 255}
COL_HUNGER       :: rl.Color{240, 140,  30, 255}
COL_THIRST       :: rl.Color{ 40,  80, 200, 255}
COL_BAR_CRITICAL :: rl.Color{220,  40,  40, 255}
COL_WALL_SHADOW  :: rl.Color{ 20,  20,  20,  90}
COL_WALL_DARK    :: rl.Color{ 80,  90,  80, 255}
COL_WALL_MID     :: rl.Color{120, 130, 115, 255}
COL_WALL_LIGHT   :: rl.Color{175, 185, 165, 255}
HEADLIGHT_COL    :: rl.Color{255, 250, 210, 255}
TAILLIGHT_COL    :: rl.Color{200,  30,  30, 255}



// helpers

vec2_dist :: proc(a, b: Vec2) -> f32 {
    dx := a.x - b.x; dy := a.y - b.y
    return math.sqrt(dx*dx + dy*dy)
}

rng_seed :: proc(seed: u64) { rand.reset(seed) }

rand_f32 :: proc(lo, hi: f32) -> f32 {
    return lo + rand.float32()*(hi-lo)
}

rand_int :: proc(lo, hi: int) -> int {
    if hi <= lo { return lo }
    return lo + int(rand.uint32()) % (hi - lo)
}

rand_color :: proc() -> rl.Color {
    return rl.Color{u8(rand_int(40,220)), u8(rand_int(40,220)),
u8(rand_int(40,220)), 255}
}
get_sanctuary_bee_speed :: proc(bi: int) -> f32 {
    h := u32(bi) * 374761393 + 668265263
    h = (h ~ (h >> 13)) * 1274126177
    h = h ~ (h >> 16)
    r := f32(h & 0x7fffffff) / f32(0x7fffffff)
    if r < 0.33 { return 0.50 }
    if r < 0.66 { return 0.75 }
    return 1.00
}


plot_size_label :: proc(s: PlotSize) -> string {
    switch s {
    case .Small:   return "Small"
    case .Medium:  return "Medium"
    case .Large:   return "Large"
    case .XLarge:  return "Extra Large"
    case .XXLarge: return "Double XL"
    }
    return ""
}

plot_cost :: proc(s: PlotSize) -> f32 {
    switch s {
    case .Small:   return PLOT_COST_SMALL
    case .Medium:  return PLOT_COST_MED
    case .Large:   return PLOT_COST_LARGE
    case .XLarge:  return PLOT_COST_XL
    case .XXLarge: return PLOT_COST_XXL
    }
    return 0
}

plot_rect_size :: proc(s: PlotSize) -> Vec2 {
    switch s {
    case .Small:   return {280, 280}
    case .Medium:  return {380, 380}
    case .Large:   return {480, 480}
    case .XLarge:  return {580, 580}
    case .XXLarge: return {700, 700}
    }
    return {280, 280}
}

box_capacity :: proc(k: BoxType) -> f32 {
    switch k {
    case .SmallGround: return BOX_CAP_SMALL_GROUND
    case .LargeGround: return BOX_CAP_LARGE_GROUND
    case .TreeHang:    return BOX_CAP_TREE
    }
    return 0
}

box_bees :: proc(k: BoxType) -> int {
    switch k {
    case .SmallGround: return BOX_BEES_SMALL_GROUND
    case .LargeGround: return BOX_BEES_LARGE_GROUND
    case .TreeHang:    return BOX_BEES_TREE
    }
    return 0
}
apply_plant_flower :: proc(plot_idx: int, pos: Vec2) -> (ok: bool, msg: string) {
    if plot_idx < 0 || plot_idx >= len(g.plots) { return false, "Invalid plot." }
    plot := &g.plots[plot_idx]
    if !plot.owner_is_player { return false, "You must be standing on your own land to plant flowers!" }
    if g.inv_flower_seeds <= 0 { return false, "No flower seeds! Buy some at the Market." }
    g.inv_flower_seeds -= 1
    append(&plot.flowers, pos)
    return true, fmt.aprintf("Flower planted! +1%d honey boost on this plot.", g.inv_flower_seeds, allocator = context.temp_allocator)
}

apply_plant_tree :: proc(plot_idx: int, pos: Vec2) -> (ok: bool, msg: string) {
    if plot_idx < 0 || plot_idx >= len(g.plots) { return false, "Invalid plot." }
    plot := &g.plots[plot_idx]
    if !plot.owner_is_player { return false, "You must be standing on your own land to plant trees!" }
    if g.inv_tree_seeds <= 0 { return false, "No tree seeds! Buy some at the Market." }
    g.inv_tree_seeds -= 1
    append(&plot.trees, pos)
    return true, fmt.aprintf("Tree planted! +3%d honey boost on this plot.", g.inv_tree_seeds, allocator = context.temp_allocator)
}
apply_place_box :: proc(plot_idx: int, kind: BoxType) -> (ok: bool, msg: string) {
    if plot_idx < 0 || plot_idx >= len(g.plots) { return false, "Invalid plot." }
    plot := &g.plots[plot_idx]
    if !plot.owner_is_player { return false, "You don't own that plot." }

    ki := int(kind)
    if ki < 0 || ki >= len(g.shop_items) { return false, "Invalid hive type." } // network-sourced enum, must bound-check
    item := g.shop_items[ki]

    if g.player.money < item.cost { return false, "Not enough money!" } // added: host-side re-check for remote requests

    limit := plot_hive_limit(plot.size)
    if limit >= 0 && len(plot.boxes) >= limit {
        return false, fmt.aprintf("This plot can only hold %d bee hives!", limit, allocator = context.temp_allocator)
    }
    if item.kind == .TreeHang && len(plot.trees) == 0 {
        return false, "No trees on that plot!"
    }

    g.player.money -= item.cost
    bx, by_pos: f32
    if item.kind == .TreeHang && len(plot.trees) > 0 {
        ti := rand_int(0, len(plot.trees))
        bx = plot.trees[ti].x; by_pos = plot.trees[ti].y
    } else {
        bx     = rand_f32(plot.rect.x+20, plot.rect.x+plot.rect.width-20)
        by_pos = rand_f32(plot.rect.y+20, plot.rect.y+plot.rect.height-20)
    }
    box := BeeBox{pos={bx,by_pos}, kind=item.kind, honey_ml=0, capacity=box_capacity(item.kind), bee_count=box_bees(item.kind), active=true, on_plot=plot_idx}
    append(&g.bee_boxes, box)
    append(&plot.boxes, len(g.bee_boxes)-1)
    return true, fmt.aprintf("Installed %s at %s!", item.label, plot.address, allocator = context.temp_allocator)
}


apply_deploy_queen :: proc(requester_pos: Vec2) -> (ok: bool, msg: string) {
    if g.inv_queen_bees <= 0 { return false, "No queen bees in inventory! Buy one at the Market." }
    best_idx, best_dist := -1, f32(INTERACT_DIST)
    for i in 0..<len(g.bee_boxes) {
        box := &g.bee_boxes[i]
        if !box.active || box.on_plot < 0 { continue }
        if !g.plots[box.on_plot].owner_is_player { continue }
        d := vec2_dist(requester_pos, box.pos)
        if d < best_dist { best_dist = d; best_idx = i }
    }
    if best_idx < 0 { return false, "Stand near one of your bee boxes to deploy a queen bee!" }
    box := &g.bee_boxes[best_idx]
    if box.queen_tier > 0 { return false, "This bee box already has a queen bee!" }
    box.queen_tier = 1
    g.inv_queen_bees -= 1
    return true, fmt.aprintf("Queen bee deployed! +50%d honey boost on this hive.", g.inv_queen_bees, allocator = context.temp_allocator)
}

apply_buy_plot :: proc(plot_idx: int) -> (ok: bool, msg: string) {
    if plot_idx < 0 || plot_idx >= len(g.plots) { return false, "Invalid plot." }
    plot := &g.plots[plot_idx]
    if plot.owned { return false, "Already owned." }
    if g.player.money < plot.cost { return false, "Not enough money!" }
    g.player.money -= plot.cost
    plot.owned = true; plot.owner_is_player = true
    if g.player.owned_plot < 0 { g.player.owned_plot = plot_idx }
    build_collision_rects()
    unlock_achievement(ACH_BOUGHT_PLOT)
    return true, fmt.aprintf("Purchased %s at %s!", plot_size_label(plot.size), plot.address, allocator = context.temp_allocator)
}

apply_collect_honey :: proc(requester_pos: Vec2) -> (ok: bool, msg: string) {
    best_idx, best_dist := -1, f32(INTERACT_DIST)
    for i in 0..<len(g.bee_boxes) {
        box := &g.bee_boxes[i]
        if !box.active { continue }
        d := vec2_dist(requester_pos, box.pos)
        if d < best_dist { best_dist = d; best_idx = i }
    }
    if best_idx < 0 { return false, "" }
    box := &g.bee_boxes[best_idx]
    if box.honey_ml <= 0 { return false, "" } // matches original: empty box collects silently
    collected := box.honey_ml
    g.player.honey_ml += collected
    box.honey_ml = 0
    return true, fmt.aprintf("Collected %.0fml of honey!", collected, allocator = context.temp_allocator)
}

apply_buy_building :: proc(bt: BuildingType) -> (ok: bool, msg: string) {
    b := &g.buildings[bt]
    if b.owned { return false, "" }
    if g.player.money < b.cost { return false, "Get yo money not yo funny up young blood!" }
    g.player.money -= b.cost
    b.owned = true
    return true, fmt.aprintf("You purchased the %s for $%.0f!", b.label, b.cost, allocator = context.temp_allocator)
}

show_message :: proc(msg: string, duration: f32 = 3.0) {
    delete(g.message)
    g.message = strings.clone(msg)
    g.message_timer = duration
}

unlock_achievement :: proc(id: int) {
    if g.achievements_unlocked[id] { return }
    g.achievements_unlocked[id] = true
    show_message(fmt.aprintf("Achievement Unlocked: %s!", ACHIEVEMENT_NAMES[id],
        allocator = context.temp_allocator), 3)
}

check_passive_achievements :: proc() {
    if g.player.money >= 10000 { unlock_achievement(ACH_MONEY_10K) }
    if g.player.money >= 50000 { unlock_achievement(ACH_MONEY_50K) }

    if len(g.camera_roll) > 0 { unlock_achievement(ACH_FIRST_PHOTO) }

    for discovered in g.discovered_animals {
        if discovered { unlock_achievement(ACH_DISCOVERED_ANIMAL); break }
    }
    for discovered in g.discovered_fish {
        if discovered { unlock_achievement(ACH_DISCOVERED_FISH); break }
    }

    if g.player_in_water { unlock_achievement(ACH_SWAM_POND) }
    if g.in_car          { unlock_achievement(ACH_RODE_CAR) }

    if g.soccer.player_score >= 3 { unlock_achievement(ACH_WON_SOCCER) }

    all_owned := true
    for h in g.homes {
        if !h.owned { all_owned = false; break }
    }
    if all_owned { unlock_achievement(ACH_ALL_HOMES) }
}
update_achievements_toggle :: proc() {
    if g.save_rename_slot >= 0 { return }
    if rl.IsKeyPressed(.TWO) {
        g.achievements_open = !g.achievements_open
        g.achievements_cursor = 0
    }
}

update_achievements_menu :: proc() {
    if !g.achievements_open { return }

    if rl.IsKeyPressed(.UP) {
        g.achievements_cursor -= 1
        if g.achievements_cursor < 0 { g.achievements_cursor = ACHIEVEMENT_COUNT - 1 }
    }
    if rl.IsKeyPressed(.DOWN) {
        g.achievements_cursor += 1
        if g.achievements_cursor >= ACHIEVEMENT_COUNT { g.achievements_cursor = 0 }
    }
    if rl.IsKeyPressed(.ENTER) || rl.IsKeyPressed(.KP_ENTER) {
        g.achievements_open = false
    }
}

draw_achievements_menu :: proc() {
    if !g.achievements_open { return }

    pw :: f32(280); ph :: f32(280)
    px := f32(GAME_W)/2 - pw/2
    py := f32(GAME_H)/2 - ph/2
    draw_panel(px, py, pw, ph, "=== ACHIEVEMENTS ===")

    row_h    :: f32(28)
    list_top := py + 22
    list_h   := ph - 22 - 16

    visible_rows := int(list_h / row_h)
    if visible_rows < 1 { visible_rows = 1 }

    scroll := g.achievements_cursor - visible_rows/2
    if scroll < 0 { scroll = 0 }
    max_scroll := ACHIEVEMENT_COUNT - visible_rows
    if max_scroll < 0 { max_scroll = 0 }
    if scroll > max_scroll { scroll = max_scroll }

    for i in 0..<visible_rows {
        idx := scroll + i
        if idx >= ACHIEVEMENT_COUNT { break }
        ry := list_top + f32(i) * row_h
        selected := (g.achievements_cursor == idx)
        bg := COL_BTN_HOV if selected else COL_BTN

        rl.DrawRectangle(pxi(px)+8, pxi(ry), pxi(pw)-16, pxi(row_h)-4, bg)
        rl.DrawRectangleLinesEx({px+8, ry, pw-16, row_h-4}, 1,
            COL_HONEY2 if selected else COL_PANEL_BORDER)

        name_cstr := strings.clone_to_cstring(ACHIEVEMENT_NAMES[idx], context.temp_allocator)
        rl.DrawText(name_cstr, pxi(px)+12, pxi(ry)+4, 8, COL_TEXT)

        status_str := "NOT COMPLETED"
        status_col := COL_RED_TEXT
        if g.achievements_unlocked[idx] {
            status_str = "COMPLETED"
            status_col = COL_GREEN_TEXT
        }
        status_cstr := strings.clone_to_cstring(status_str, context.temp_allocator)
        rl.DrawText(status_cstr, pxi(px)+12, pxi(ry)+15, 7, status_col)
    }

    rl.DrawText("UP/DOWN: Scroll   2: Close", pxi(px)+8, pxi(py)+pxi(ph)-14,
        7, {140,140,100,200})
}

pxi :: proc(v: f32) -> i32 { return i32(v) }

rect_expand :: proc(r: rl.Rectangle, amount: f32) -> rl.Rectangle {
    return {r.x - amount, r.y - amount, r.width + amount*2, r.height + amount*2}
}

honey_season_value_mult :: proc() -> f32 {
    switch g.season {
    case .Summer: return 1.0
    case .Fall:   return 2.0
    case .Winter: return 3.0
    case .Spring: return 0.8
    }
    return 1.0
}

honey_production_multiplier :: proc() -> f32 {
    mult := f32(1.0)
    switch g.season {
    case .Spring: mult *= 1.50
    case .Summer: mult *= 1.00
    case .Fall:   mult *= 0.80
    case .Winter: mult *= 0.20
    }
    if g.is_night { mult *= 0.50 }
    if g.rain_timer > 0 { mult = 0.0 }
    return mult
}
honey_production_multiplier_for_plot :: proc(plot_idx: int) -> f32 {
    mult := honey_production_multiplier()
    if plot_idx >= 0 && plot_idx < len(g.plots) {
        p := &g.plots[plot_idx]
        flower_bonus := f32(len(p.flowers)) * 0.01
        tree_bonus   := f32(len(p.trees))   * 0.03
        mult *= (1.0 + flower_bonus + tree_bonus)
    }
    return mult
}
queen_bee_multiplier :: proc(tier: int) -> f32 {
    return 1.0 + f32(tier) * 0.5
}


season_label :: proc(s: Season) -> string {
    switch s {
    case .Spring: return "Spring"
    case .Summer: return "Summer"
    case .Fall:   return "Fall"
    case .Winter: return "Winter"
    }
    return ""
}

honey_value_per_liter :: proc() -> f32 {
    return HONEY_VALUE_PER_L * honey_season_value_mult()
}
auction_active :: proc() -> bool {
    return g.auction_timer > 0
}

bank_honey_value_per_liter :: proc() -> f32 {
    v := honey_value_per_liter()
    if auction_active() { v *= AUCTION_MULT }
    return v
}

push_honey_stock :: proc(v: f32) {
    if g.honey_stock_count < 12 {
        g.honey_stock_history[g.honey_stock_count] = v
        g.honey_stock_season[g.honey_stock_count]  = g.season
        g.honey_stock_count += 1
    } else {
        for i in 0..<11 {
            g.honey_stock_history[i] = g.honey_stock_history[i+1]
            g.honey_stock_season[i]  = g.honey_stock_season[i+1]
        }
        g.honey_stock_history[11] = v
        g.honey_stock_season[11]  = g.season
    }
}

apply_property_tax :: proc() {
    plots_owned := 0
    for i in 0..<len(g.plots) {
        if g.plots[i].owner_is_player { plots_owned += 1 }
    }
    homes_owned := 0
    for i in 0..<NUM_HOMES {
        if g.homes[i].owned { homes_owned += 1 }
    }
    tax := f32(plots_owned)*TAX_PER_PLOT + f32(homes_owned)*TAX_PER_HOME
    if tax > 0 {
        g.player.money -= tax
        show_message(fmt.aprintf(
            "Property tax due! -$%.0f (%d plots x $10000, %d homes x $25000)",
            tax, plots_owned, homes_owned,
            allocator = context.temp_allocator), 6)
    }
}
npc_relationship_gain :: proc(idx: int, amount: f32) {
    g.npc_relationship[idx] = min(g.npc_relationship[idx] + amount, RELATIONSHIP_MAX)
}

npc_relationship_tier :: proc(idx: int) -> int {
    rel := g.npc_relationship[idx]
    tier := 0
    for t in 0..<RELATIONSHIP_TIER_COUNT {
        if rel >= RELATIONSHIP_TIER_THRESHOLDS[t] { tier = t }
    }
    return tier
}
is_raining :: proc() -> bool { return g.rain_timer > 0 }

weather_label :: proc() -> string {
    return "Rainy" if is_raining() else "Sunny"
}

time_until_next_rain :: proc() -> f32 {
    if is_raining() { return g.rain_timer + RAIN_INTERVAL }
    return g.rain_cooldown
}

format_clock :: proc(seconds: f32, allocator := context.temp_allocator) -> string {
    s   := int(max(seconds, 0))
    m   := s / 60
    sec := s % 60
    return fmt.aprintf("%02d:%02d", m, sec, allocator = allocator)
}



// SAVE / LOAD

save_filename :: proc(slot: int, allocator := context.temp_allocator) -> string
{
    return fmt.aprintf("fuzzybuddyfarms_save_%d.dat", slot, allocator =
allocator)
}

make_timestamp :: proc(allocator := context.temp_allocator) -> string {
    t     := rl.GetTime()
    total := int(t)
    h     := total / 3600
    m     := (total % 3600) / 60
    s     := total % 60
    return fmt.aprintf("Session %02d:%02d:%02d", h, m, s, allocator = allocator)
}

refresh_save_header :: proc(slot: int) {
    fname := save_filename(slot)
    data, err := os.read_entire_file_from_path(fname, context.allocator)
    if err != nil { g.save_headers[slot] = {}; return }
    defer delete(data, context.allocator)

    needed := size_of(u32)*2 + size_of(SaveSlotHeader)
    if len(data) < needed { g.save_headers[slot] = {}; return }

    offset := 0
    magic: u32
    mem.copy(&magic, raw_data(data[offset:]), size_of(u32))
    offset += size_of(u32)
    if magic != SAVE_MAGIC { g.save_headers[slot] = {}; return }

    version: u32
    mem.copy(&version, raw_data(data[offset:]), size_of(u32))
    offset += size_of(u32)

    header: SaveSlotHeader
    mem.copy(&header, raw_data(data[offset:]), size_of(SaveSlotHeader))
    g.save_headers[slot] = header
}

save_game :: proc(slot: int, save_name: string) -> bool {
    header := SaveSlotHeader{used = true}
    name_bytes := transmute([]u8)save_name
    copy_len := min(len(name_bytes), 31)
    for i in 0..<copy_len { header.name[i] = name_bytes[i] }
    header.name[copy_len] = 0

    ts := make_timestamp(context.temp_allocator)
    ts_bytes := transmute([]u8)ts
    ts_len := min(len(ts_bytes), 31)
    for i in 0..<ts_len { header.timestamp[i] = ts_bytes[i] }
    header.timestamp[ts_len] = 0
    header.money = g.player.money

    sd := SaveData{
        magic          = SAVE_MAGIC,
        version        = SAVE_VERSION,
        header         = header,
        player_pos     = {g.player.pos.x, g.player.pos.y},
        honey_ml       = g.player.honey_ml,
        money          = g.player.money,
        owned_plot     = g.player.owned_plot,
        plot_count     = len(g.plots),
        box_count      = len(g.bee_boxes),
    }
    for i in 0..<NUM_HOMES { sd.homes_owned[i] = g.homes[i].owned }

    save_plots := make([]SavePlot,   len(g.plots),    context.temp_allocator)
    save_boxes := make([]SaveBeeBox, len(g.bee_boxes), context.temp_allocator)

    total_trees := 0; total_flowers := 0; total_box_idx := 0
    for i in 0..<len(g.plots) {
        p := &g.plots[i]
        save_plots[i] = SavePlot{
            rect            = {p.rect.x, p.rect.y, p.rect.width, p.rect.height},
            size            = p.size,
            cost            = p.cost,
            owned           = p.owned,
            owner_is_player = p.owner_is_player,
            tree_count      = len(p.trees),
            flower_count    = len(p.flowers),
            box_count       = len(p.boxes),
        }
        total_trees   += len(p.trees)
        total_flowers += len(p.flowers)
        total_box_idx += len(p.boxes)
    }

    all_trees   := make([]SaveVec2, total_trees,   context.temp_allocator)
    all_flowers := make([]SaveVec2, total_flowers, context.temp_allocator)
    all_box_idx := make([]int,      total_box_idx, context.temp_allocator)

    ti := 0; fi := 0; bi := 0
    for i in 0..<len(g.plots) {
        p := &g.plots[i]
        for t in p.trees   { all_trees[ti]   = {t.x, t.y}; ti += 1 }
        for f in p.flowers { all_flowers[fi] = {f.x, f.y}; fi += 1 }
        for b in p.boxes   { all_box_idx[bi] = b;           bi += 1 }
    }
    for i in 0..<len(g.bee_boxes) {
        b := &g.bee_boxes[i]
        save_boxes[i] = SaveBeeBox{
            pos = {b.pos.x, b.pos.y}, kind = b.kind,
            honey_ml = b.honey_ml, capacity = b.capacity,
            bee_count = b.bee_count, active = b.active, on_plot = b.on_plot,
        }
    }

    buf := make([dynamic]u8, context.temp_allocator)
    append_bytes :: proc(buf: ^[dynamic]u8, ptr: rawptr, n: int) {
        old_len := len(buf)
        resize(buf, old_len + n)
        mem.copy(raw_data(buf^[old_len:]), ptr, n)
    }
    append_bytes(&buf, &sd, size_of(SaveData))
    if len(save_plots) > 0 { append_bytes(&buf, &save_plots[0],
len(save_plots)*size_of(SavePlot)) }
    if len(save_boxes) > 0 { append_bytes(&buf, &save_boxes[0],
len(save_boxes)*size_of(SaveBeeBox)) }
    if total_trees   > 0 { append_bytes(&buf, &all_trees[0],
total_trees*size_of(SaveVec2)) }
    if total_flowers > 0 { append_bytes(&buf, &all_flowers[0],
total_flowers*size_of(SaveVec2)) }
    if total_box_idx > 0 { append_bytes(&buf, &all_box_idx[0],
total_box_idx*size_of(int)) }

    // Save time-cycle data
    day_time_sv      := g.day_time
    season_time_sv   := g.season_time
    season_sv        := g.season
    rain_timer_sv    := g.rain_timer
    rain_cooldown_sv := g.rain_cooldown
    append_bytes(&buf, &day_time_sv,      size_of(f32))
    append_bytes(&buf, &season_time_sv,   size_of(f32))
    append_bytes(&buf, &season_sv,        size_of(Season))
    append_bytes(&buf, &rain_timer_sv,    size_of(f32))
    append_bytes(&buf, &rain_cooldown_sv, size_of(f32))
    queen_tiers := make([]i32, len(g.bee_boxes), context.temp_allocator)
    for i in 0..<len(g.bee_boxes) {
	queen_tiers[i] = i32(g.bee_boxes[i].queen_tier)
}
if len(queen_tiers) > 0 {
    append_bytes(&buf, &queen_tiers[0], len(queen_tiers)*size_of(i32))
}
    stat_honey_produced := g.total_honey_produced_ml
    stat_honey_sold      := g.total_honey_sold_ml
    stat_money_earned    := g.total_money_earned
    stat_play_time       := g.total_play_time
    append_bytes(&buf, &stat_honey_produced, size_of(f32))
    append_bytes(&buf, &stat_honey_sold,      size_of(f32))
    append_bytes(&buf, &stat_money_earned,    size_of(f32))
    append_bytes(&buf, &stat_play_time,       size_of(f32))
    achievements_sv := g.achievements_unlocked
    append_bytes(&buf, &achievements_sv, size_of(achievements_sv))

    inv_flower_seeds_sv      := g.inv_flower_seeds
    inv_tree_seeds_sv        := g.inv_tree_seeds
    inv_queen_bees_sv        := g.inv_queen_bees
    inv_bee_net_sv           := g.inv_bee_net
    inv_lantern_sv           := g.inv_lantern
    inv_lightsaber_sv        := g.inv_lightsaber
    inv_batarang_sv := g.inv_batarang
    append_bytes(&buf, &inv_batarang_sv, size_of(bool))
    lightning_bugs_caught_sv := g.lightning_bugs_caught
    append_bytes(&buf, &inv_flower_seeds_sv,      size_of(int))
    append_bytes(&buf, &inv_tree_seeds_sv,        size_of(int))
    append_bytes(&buf, &inv_queen_bees_sv,        size_of(int))
    append_bytes(&buf, &inv_bee_net_sv,           size_of(bool))
    append_bytes(&buf, &inv_lantern_sv,           size_of(bool))
    append_bytes(&buf, &inv_lightsaber_sv,        size_of(bool))
    append_bytes(&buf, &lightning_bugs_caught_sv, size_of(int))

    discovered_animals_sv := g.discovered_animals
    discovered_fish_sv    := g.discovered_fish
    append_bytes(&buf, &discovered_animals_sv, size_of(discovered_animals_sv))
    append_bytes(&buf, &discovered_fish_sv,     size_of(discovered_fish_sv))

    sanctuary_donated_sv   := g.sanctuary_donated
    sanctuary_bee_count_sv := g.sanctuary_bee_count
    append_bytes(&buf, &sanctuary_donated_sv,   size_of(f32))
    append_bytes(&buf, &sanctuary_bee_count_sv, size_of(int))

    // Player outfit 
    shirt_col_sv   := g.player.shirt_color
    pants_col_sv   := g.player.pants_color
    hat_col_sv     := g.player.hat_color
    pattern_sv     := g.player.clothing_pattern
    pattern_col_sv := g.player.pattern_color
    append_bytes(&buf, &shirt_col_sv,   size_of(rl.Color))
    append_bytes(&buf, &pants_col_sv,   size_of(rl.Color))
    append_bytes(&buf, &hat_col_sv,     size_of(rl.Color))
    append_bytes(&buf, &pattern_sv,     size_of(ClothingPattern))
    append_bytes(&buf, &pattern_col_sv, size_of(rl.Color))

    // Cars
    save_cars: [MAX_CARS]SaveCar
    for i in 0..<MAX_CARS {
        c := &g.cars[i]
        save_cars[i] = SaveCar{
            kind = c.kind, owned = c.owned, active = c.active,
            pos = {c.pos.x, c.pos.y}, angle = c.angle,
        }
    }
    append_bytes(&buf, &save_cars, size_of(save_cars))
    photo_seq_sv := g.photo_seq
    append_bytes(&buf, &photo_seq_sv, size_of(int))

    photo_count := len(g.camera_roll)
    append_bytes(&buf, &photo_count, size_of(int))

    for i in 0..<photo_count {
        p := &g.camera_roll[i]
        fname_len := len(p.filename)
        append_bytes(&buf, &fname_len, size_of(int))
        if fname_len > 0 {
            fname_bytes := transmute([]u8)p.filename
            append_bytes(&buf, &fname_bytes[0], fname_len)
        }
    }

    factory_owned_sv    := g.buildings[.FuzzyBuddyFactory].owned
    honey_product_ml_sv := g.honey_product_ml
    append_bytes(&buf, &factory_owned_sv,    size_of(bool))
    append_bytes(&buf, &honey_product_ml_sv, size_of(f32))
    owned_animal_buddies_sv := g.owned_animal_buddies
    animal_active_kind_sv   := int(g.animal_buddy.kind)
    animal_visible_sv       := g.animal_buddy.visible
    append_bytes(&buf, &owned_animal_buddies_sv[0], ANIMAL_BUDDY_COUNT*size_of(bool))
    append_bytes(&buf, &animal_active_kind_sv,      size_of(int))
    append_bytes(&buf, &animal_visible_sv,           size_of(bool))
    fbf_indoor_owned_sv := g.fbf_indoor_owned
    fbf_indoor_honey_sv := g.fbf_indoor_honey_ml
    append_bytes(&buf, &fbf_indoor_owned_sv, size_of(bool))
    append_bytes(&buf, &fbf_indoor_honey_sv, size_of(f32))
    garage_flags_sv: [MAX_CARS]bool
    for i in 0..<MAX_CARS {
        garage_flags_sv[i] = g.cars[i].in_garage
    }
    append_bytes(&buf, &garage_flags_sv, size_of(garage_flags_sv))
    garage_owned_sv := g.buildings[.Garage].owned
    append_bytes(&buf, &garage_owned_sv, size_of(bool))

    market_owned_sv := g.buildings[.FarmersMarket].owned
    market_price_sv  := g.market_price
    append_bytes(&buf, &market_owned_sv, size_of(bool))
    append_bytes(&buf, &market_price_sv,  size_of(f32))

    npc_met_sv := g.npc_met
    npc_relationship_sv := g.npc_relationship
    append_bytes(&buf, &npc_met_sv, size_of(npc_met_sv))
    append_bytes(&buf, &npc_relationship_sv, size_of(npc_relationship_sv))

    weather_state_timer_sv := g.weather_state_timer
    append_bytes(&buf, &weather_state_timer_sv, size_of(f32))

    health_sv := g.player.health
    hunger_sv := g.player.hunger
    thirst_sv := g.player.thirst
    append_bytes(&buf, &health_sv, size_of(f32))
    append_bytes(&buf, &hunger_sv, size_of(f32))
    append_bytes(&buf, &thirst_sv, size_of(f32))
    food_sv  := g.inv_food_count
    drink_sv := g.inv_drink_count
    append_bytes(&buf, &food_sv,  size_of(int))
    append_bytes(&buf, &drink_sv, size_of(int))

    hs_sv := g.buzzy.high_score
    append_bytes(&buf, &hs_sv, size_of(int))
    
    turtle_bandana_sv := g.animal_buddy.bandana_idx
    append_bytes(&buf, &turtle_bandana_sv, size_of(int))

    fname     := save_filename(slot)
    write_err := os.write_entire_file(fname, buf[:])
    if write_err == nil { g.save_headers[slot] = header }
    return write_err == nil
}
take_photo :: proc() {
    img := rl.LoadImageFromTexture(g.render_tex.texture)
    rl.ImageFlipVertical(&img)

    g.photo_seq += 1
    fname := fmt.aprintf("fuzzybuddyfarms_photo_%03d.png", g.photo_seq, allocator = context.allocator)
    rl.ExportImage(img, strings.clone_to_cstring(fname, context.temp_allocator))

    tex := rl.LoadTextureFromImage(img)
    rl.SetTextureFilter(tex, .POINT)
    rl.UnloadImage(img)

    if len(g.camera_roll) >= CAMERA_ROLL_MAX {
        oldest := g.camera_roll[0]
        rl.UnloadTexture(oldest.texture)
        delete(oldest.filename)
        ordered_remove(&g.camera_roll, 0)
    }

    append(&g.camera_roll, Photo{texture = tex, filename = fname})
    g.album_cursor = len(g.camera_roll) - 1
    show_message(fmt.aprintf("Photo captured! Saved as %s ([P] for photo album)",
        fname, allocator = context.temp_allocator), 3)
    record_photo_discoveries()

}
animal_label :: proc(k: AnimalType) -> string {
    switch k {
    case .Rabbit:    return "Rabbit"
    case .Fox:       return "Fox"
    case .Deer:      return "Deer"
    case .Squirrel:  return "Squirrel"
    case .Frog:      return "Frog"
    case .Butterfly: return "Butterfly"
    }
    return ""
}

fish_label :: proc(k: FishType) -> string {
    switch k {
    case .Bass:     return "Bass"
    case .Trout:    return "Trout"
    case .Catfish:  return "Catfish"
    case .Goldfish: return "Goldfish"
    case .Pike:     return "Pike"
    case .Perch:    return "Perch"
    }
    return ""
}

record_photo_discoveries :: proc() {
    top_left := rl.GetScreenToWorld2D({0, 0}, g.camera)
    view := rl.Rectangle{
        top_left.x, top_left.y,
        f32(GAME_W) / g.camera.zoom,
        f32(GAME_H) / g.camera.zoom,
    }

    new_count := 0
    last_name := ""

    for i in 0..<ANIMAL_COUNT {
        a := &g.animals[i]
        if !g.discovered_animals[a.kind] && rl.CheckCollisionPointRec(a.pos, view) {
            g.discovered_animals[a.kind] = true
            new_count += 1
            last_name = animal_label(a.kind)
        }
    }
    for i in 0..<POND_FISH_COUNT {
        f := &g.pond.fish[i]
        if !g.discovered_fish[f.kind] && rl.CheckCollisionPointRec(f.pos, view) {
            g.discovered_fish[f.kind] = true
            new_count += 1
            last_name = fish_label(f.kind)
        }
    }

    if new_count == 1 {
        show_message(fmt.aprintf("New species discovered: %s! (Toggle L for checklist)",
            last_name, allocator = context.temp_allocator), 4)
    } else if new_count > 1 {
        show_message(fmt.aprintf("%d new species discovered! (Toggle L for checklist)",
            new_count, allocator = context.temp_allocator), 4)
    }
}

delete_current_photo :: proc() {
    n := len(g.camera_roll)
    if n == 0 { return }

    idx := clamp(g.album_cursor, 0, n-1)
    photo := g.camera_roll[idx]

    rl.UnloadTexture(photo.texture)

    delete(photo.filename)
    ordered_remove(&g.camera_roll, idx)

    n = len(g.camera_roll)
    g.album_cursor = 0 if n == 0 else clamp(idx, 0, n-1)
    g.album_viewing = false

    show_message("Photo deleted.", 2)
}

update_camera_capture :: proc() {
    if g.album_open || g.discovered_open { return }
    if !rl.IsKeyPressed(.C) { return }
    if g.input_c_consumed { return }
    take_photo()
}

update_camera_album :: proc() {
    if g.in_car { return }

    if rl.IsKeyPressed(.P) {
        g.album_open    = !g.album_open
        g.album_viewing = false
        if len(g.camera_roll) > 0 {
            g.album_cursor = clamp(g.album_cursor, 0, len(g.camera_roll)-1)
        }
        return
    }
    if !g.album_open { return }

    n := len(g.camera_roll)
    if n == 0 { return }
    cols :: 4

    if g.album_viewing {
        if rl.IsKeyPressed(.ENTER) || rl.IsKeyPressed(.KP_ENTER) || rl.IsKeyPressed(.ESCAPE) {
            g.album_viewing = false
        }
	if rl.IsKeyPressed(.R) { delete_current_photo() }
        return
    }

    if rl.IsKeyPressed(.RIGHT) { g.album_cursor = min(g.album_cursor+1, n-1) }
    if rl.IsKeyPressed(.LEFT)  { g.album_cursor = max(g.album_cursor-1, 0) }
    if rl.IsKeyPressed(.DOWN)  { g.album_cursor = min(g.album_cursor+cols, n-1) }
    if rl.IsKeyPressed(.UP)    { g.album_cursor = max(g.album_cursor-cols, 0) }
    if rl.IsKeyPressed(.ENTER) || rl.IsKeyPressed(.KP_ENTER) { g.album_viewing = true }
    if rl.IsKeyPressed(.ESCAPE) { g.album_open = false }
    if rl.IsKeyPressed(.R) { delete_current_photo() }
}


load_game :: proc(slot: int) -> bool {
    fname := save_filename(slot)
    data, err := os.read_entire_file_from_path(fname, context.allocator)
    if err != nil { return false }
    defer delete(data, context.allocator)
    if len(data) < size_of(SaveData) { return false }

    off := 0
    read_bytes :: proc(data: []u8, off: ^int, dst: rawptr, n: int) -> bool {
        if off^ + n > len(data) { return false }
        mem.copy(dst, raw_data(data[off^:]), n)
        off^ += n
        return true
    }

    sd: SaveData
    if !read_bytes(data, &off, &sd, size_of(SaveData)) { return false }
    if sd.magic != SAVE_MAGIC { return false }
    for i in 0..<len(g.camera_roll) {
    	rl.UnloadTexture(g.camera_roll[i].texture)
    	delete(g.camera_roll[i].filename)
    }
    delete(g.camera_roll)
    g.camera_roll = make([dynamic]Photo)
    g.album_cursor = 0
    g.album_open = false
    g.album_viewing = false

    if sd.plot_count < 0 || sd.plot_count > 10000 { return false }
    save_plots := make([]SavePlot, sd.plot_count, context.temp_allocator)
    if sd.plot_count > 0 {
        if !read_bytes(data, &off, &save_plots[0],
sd.plot_count*size_of(SavePlot)) { return false }
    }
    if sd.box_count < 0 || sd.box_count > 100000 { return false }
    save_boxes := make([]SaveBeeBox, sd.box_count, context.temp_allocator)
    if sd.box_count > 0 {
        if !read_bytes(data, &off, &save_boxes[0],
sd.box_count*size_of(SaveBeeBox)) { return false }
    }

    total_trees := 0; total_flowers := 0; total_box_idx := 0
    for i in 0..<sd.plot_count {
        total_trees   += save_plots[i].tree_count
        total_flowers += save_plots[i].flower_count
        total_box_idx += save_plots[i].box_count
    }
    all_trees   := make([]SaveVec2, total_trees,   context.temp_allocator)
    all_flowers := make([]SaveVec2, total_flowers, context.temp_allocator)
    all_box_idx := make([]int,      total_box_idx, context.temp_allocator)
    if total_trees   > 0 { if !read_bytes(data, &off, &all_trees[0],
total_trees*size_of(SaveVec2))   { return false } }
    if total_flowers > 0 { if !read_bytes(data, &off, &all_flowers[0],
total_flowers*size_of(SaveVec2)) { return false } }
    if total_box_idx > 0 { if !read_bytes(data, &off, &all_box_idx[0],
total_box_idx*size_of(int))      { return false } }

    // Load time-cycle data
if sd.version >= 3 {
        tdt: f32; tst: f32; ts: Season; trt: f32; trc: f32
        if read_bytes(data, &off, &tdt, size_of(f32)) &&
           read_bytes(data, &off, &tst, size_of(f32)) &&
           read_bytes(data, &off, &ts,  size_of(Season)) &&
           read_bytes(data, &off, &trt, size_of(f32)) &&
           read_bytes(data, &off, &trc, size_of(f32)) {
            g.day_time      = tdt
            g.season_time   = tst
            g.season        = ts
            g.rain_timer    = trt
            g.rain_cooldown = trc
	    g.auction_timer    = 0
	    g.auction_cooldown = rand_f32(AUCTION_MIN_WAIT, AUCTION_MAX_WAIT)

        }
    }
queen_tiers: []i32
if sd.version >= 2 {
queen_tiers := make([]i32, sd.box_count, context.temp_allocator)
if sd.version >= 4 && sd.box_count > 0 {
    read_bytes(data, &off, &queen_tiers[0], sd.box_count*size_of(i32))
}

if sd.version >= 5 {
    sh: f32; ss: f32; sm: f32; sp: f32
    if read_bytes(data, &off, &sh, size_of(f32)) &&
       read_bytes(data, &off, &ss, size_of(f32)) &&
       read_bytes(data, &off, &sm, size_of(f32)) &&
       read_bytes(data, &off, &sp, size_of(f32)) {
        g.total_honey_produced_ml = sh
        g.total_honey_sold_ml     = ss
        g.total_money_earned      = sm
        g.total_play_time         = sp
    }
}
if sd.version >= 6 {
    achievements_ld: [ACHIEVEMENT_COUNT]bool
    if read_bytes(data, &off, &achievements_ld, size_of(achievements_ld)) {
        g.achievements_unlocked = achievements_ld
} else {
    g.achievements_unlocked = {}
    g.photo_seq = 0
    for i in 0..<MAX_CARS {
        g.cars[i].owned = false
        g.cars[i].active = false
        g.cars[i].occupied = false
	g.cars[i].in_garage = false
    }
}

    }
if sd.version >= 7 {
    ibr: bool
    if read_bytes(data, &off, &ibr, size_of(bool)) {
        g.inv_batarang = ibr
    }
} else {
    g.inv_batarang = false
}
    

    ifs, its, iqb, lbc: int
    ibn, ilt, ils: bool
    if read_bytes(data, &off, &ifs, size_of(int)) &&
       read_bytes(data, &off, &its, size_of(int)) &&
       read_bytes(data, &off, &iqb, size_of(int)) &&
       read_bytes(data, &off, &ibn, size_of(bool)) &&
       read_bytes(data, &off, &ilt, size_of(bool)) &&
       read_bytes(data, &off, &ils, size_of(bool)) &&
       read_bytes(data, &off, &lbc, size_of(int)) {
        g.inv_flower_seeds      = ifs
        g.inv_tree_seeds        = its
        g.inv_queen_bees        = iqb
        g.inv_bee_net           = ibn
        g.inv_lantern           = ilt
        g.inv_lightsaber        = ils
        g.lightning_bugs_caught = lbc
    }

    da: [AnimalType]bool
    df: [FishType]bool
    if read_bytes(data, &off, &da, size_of(da)) &&
       read_bytes(data, &off, &df, size_of(df)) {
        g.discovered_animals = da
        g.discovered_fish    = df
    }

    sdn: f32
    sbc: int
    if read_bytes(data, &off, &sdn, size_of(f32)) &&
       read_bytes(data, &off, &sbc, size_of(int)) {
        g.sanctuary_donated   = sdn
        g.sanctuary_bee_count = sbc
    }

    shirt_c, pants_c, hat_c, pattern_c: rl.Color
    pattern_ld: ClothingPattern
    if read_bytes(data, &off, &shirt_c,    size_of(rl.Color)) &&
       read_bytes(data, &off, &pants_c,    size_of(rl.Color)) &&
       read_bytes(data, &off, &hat_c,      size_of(rl.Color)) &&
       read_bytes(data, &off, &pattern_ld, size_of(ClothingPattern)) &&
       read_bytes(data, &off, &pattern_c,  size_of(rl.Color)) {
        g.player.shirt_color      = shirt_c
        g.player.pants_color      = pants_c
        g.player.hat_color        = hat_c
        g.player.clothing_pattern = pattern_ld
        g.player.pattern_color    = pattern_c
        apply_customize_selection()
    }

    load_cars: [MAX_CARS]SaveCar
    if read_bytes(data, &off, &load_cars, size_of(load_cars)) {
        for i in 0..<MAX_CARS {
            g.cars[i].kind     = load_cars[i].kind
            g.cars[i].owned    = load_cars[i].owned
            g.cars[i].active   = load_cars[i].active
            g.cars[i].pos      = {load_cars[i].pos[0], load_cars[i].pos[1]}
            g.cars[i].angle    = load_cars[i].angle
            g.cars[i].occupied = false
        }
    }
    if sd.version >= 8 {
    	seq: int
    	pcount: int
    	if read_bytes(data, &off, &seq, size_of(int)) &&
	   read_bytes(data, &off, &pcount, size_of(int)) {
            g.photo_seq = seq

            for i in 0..<pcount {
            	fname_len: int
            	if !read_bytes(data, &off, &fname_len, size_of(int)) { break }
            	if fname_len <= 0 { continue }

            	fname_buf := make([]u8, fname_len, context.temp_allocator)
            	if !read_bytes(data, &off, &fname_buf[0], fname_len) { break }
            	fname := strings.clone(string(fname_buf), context.allocator)

            	cfname := strings.clone_to_cstring(fname, context.temp_allocator)
            	if !os.exists(fname) {
                    delete(fname)
                    continue
                }
                img := rl.LoadImage(cfname)
                if img.data == nil {
                    delete(fname)
                    continue
                }
                tex := rl.LoadTextureFromImage(img)
                rl.SetTextureFilter(tex, .POINT)
                rl.UnloadImage(img)

                append(&g.camera_roll, Photo{texture = tex, filename = fname})
            }
        }
    } else {
        g.photo_seq = 0
    }
    if sd.version >= 9 {
        fac_owned:  bool
        honey_prod: f32
        if read_bytes(data, &off, &fac_owned, size_of(bool)) &&
           read_bytes(data, &off, &honey_prod, size_of(f32)) {
            g.buildings[.FuzzyBuddyFactory].owned = fac_owned
            g.honey_product_ml                    = honey_prod
        }
    } else {
        g.buildings[.FuzzyBuddyFactory].owned = false
        g.honey_product_ml                    = 0
    }

    if sd.version >= 10 {
    	old_ab_count: int
    	switch {
    	case sd.version < 21: old_ab_count = 4
    	case sd.version < 22: old_ab_count = 5
    	case:                 old_ab_count = ANIMAL_BUDDY_COUNT
    	}
    	owned_ab_buf := make([]bool, old_ab_count, context.temp_allocator)
    	active_kind: int
    	ab_visible:  bool
    	if read_bytes(data, &off, &owned_ab_buf[0], old_ab_count*size_of(bool)) &&
	   read_bytes(data, &off, &active_kind, size_of(int)) &&
	   read_bytes(data, &off, &ab_visible,  size_of(bool)) {
	    g.owned_animal_buddies = {}
	    for i in 0..<old_ab_count {
		g.owned_animal_buddies[i] = owned_ab_buf[i]
	    }
	    g.animal_buddy.kind    = AnimalBuddyType(active_kind)
	    g.animal_buddy.visible = ab_visible
	    if ab_visible {
		g.animal_buddy.pos = {g.player.pos.x - 30, g.player.pos.y + 10}
	    }
        }
    } else {
	g.owned_animal_buddies = {}
	g.animal_buddy         = {}
    }



    if sd.version >= 11 {
	fbf_io: bool
    	fbf_ih: f32
    	if read_bytes(data, &off, &fbf_io, size_of(bool)) &&
           read_bytes(data, &off, &fbf_ih, size_of(f32)) {
            g.fbf_indoor_owned = fbf_io
            g.fbf_indoor_honey_ml = fbf_ih
        }
    } else {
        g.fbf_indoor_owned = false
        g.fbf_indoor_honey_ml = 0
    }
    if sd.version >= 12 {
        garage_flags_ld: [MAX_CARS]bool
        if read_bytes(data, &off, &garage_flags_ld, size_of(garage_flags_ld)) {
            for i in 0..<MAX_CARS {
                g.cars[i].in_garage = garage_flags_ld[i]
            }
        }
    } else {
        for i in 0..<MAX_CARS {
            g.cars[i].in_garage = false
        }
    }
    if sd.version >= 13 {
        garage_owned_ld: bool
        if read_bytes(data, &off, &garage_owned_ld, size_of(bool)) {
            g.buildings[.Garage].owned = garage_owned_ld
        }
    } else {
        g.buildings[.Garage].owned = false
    }
    if sd.version >= 14 {
        market_owned_ld: bool
        market_price_ld: f32
        if read_bytes(data, &off, &market_owned_ld, size_of(bool)) &&
           read_bytes(data, &off, &market_price_ld, size_of(f32)) {
            g.buildings[.FarmersMarket].owned = market_owned_ld
            g.market_price                    = market_price_ld
        }
    } else {
        g.buildings[.FarmersMarket].owned = false
        g.market_price                    = 1800
	g.festival_active   = false
	g.festival_cooldown = FESTIVAL_INTERVAL
    }
    if sd.version >= 15 {
	read_bytes(data, &off, &g.npc_met, size_of(g.npc_met))
    } else {
	g.npc_met = {}
    }
    if sd.version >= 16 {
	read_bytes(data, &off, &g.npc_relationship, size_of(g.npc_relationship))
    } else {
	g.npc_relationship = {}
    }
    if sd.version >= 17 {
	read_bytes(data, &off, &g.weather_state_timer, size_of(f32))
    } else {
	g.weather_state_timer = 0
    }
    if sd.version >= 18 {
	read_bytes(data, &off, &g.player.health, size_of(f32))
	read_bytes(data, &off, &g.player.hunger, size_of(f32))
	read_bytes(data, &off, &g.player.thirst, size_of(f32))
    } else {
	g.player.health = PLAYER_STAT_MAX
	g.player.hunger = PLAYER_STAT_MAX
	g.player.thirst = PLAYER_STAT_MAX
    }
    if sd.version >= 19 {
    	read_bytes(data, &off, &g.inv_food_count,  size_of(int))
    	read_bytes(data, &off, &g.inv_drink_count, size_of(int))
    } else {
    	g.inv_food_count  = 0
    	g.inv_drink_count = 0
    }
    if sd.version >= 20 {
    	read_bytes(data, &off, &g.buzzy.high_score, size_of(int))
    } else {
    	g.buzzy.high_score = 0
    }
    if sd.version >= 21 {
	read_bytes(data, &off, &g.animal_buddy.bandana_idx, size_of(int))
    } else {
	g.animal_buddy.bandana_idx = 0
    }

} else {
    g.achievements_unlocked = {}
    g.inv_flower_seeds      = 0
    g.inv_tree_seeds        = 0
    g.inv_queen_bees        = 0
    g.inv_bee_net           = false
    g.inv_lantern           = false
    g.inv_lightsaber        = false
    g.lightning_bugs_caught = 0
    g.discovered_animals    = {}
    g.discovered_fish       = {}
    g.sanctuary_donated     = 0
    g.sanctuary_bee_count   = 0
    for i in 0..<MAX_CARS {
        g.cars[i].owned = false
        g.cars[i].active = false
        g.cars[i].occupied = false
	g.cars[i].in_garage  = false
    }
    g.buildings[.Garage].owned = false
}

g.in_car             = false
g.current_car        = -1
g.bee_net_active      = false
g.lantern_active      = false
g.lightsaber_active   = false
g.yoda.visible        = false
g.batarang_active     = false
g.bee_cam_active      = false


    for i in 0..<len(g.plots) {
        delete(g.plots[i].trees); delete(g.plots[i].flowers); delete(g.plots[i].boxes)
    }
    delete(g.plots); delete(g.bee_boxes)

    g.player.pos        = {sd.player_pos[0], sd.player_pos[1]}
    g.player.honey_ml   = sd.honey_ml
    g.player.money      = sd.money
    g.player.owned_plot = sd.owned_plot
    for i in 0..<NUM_HOMES { g.homes[i].owned = sd.homes_owned[i] }

    g.plots     = make([dynamic]LandPlot)
    g.bee_boxes = make([dynamic]BeeBox)


    g.plots = make([dynamic]LandPlot)
    init_plots()

    remap_to_new_rect :: proc(old_pos: Vec2, old_rect, new_rect: rl.Rectangle) -> Vec2 {
        fx := (old_pos.x - old_rect.x) / old_rect.width
        fy := (old_pos.y - old_rect.y) / old_rect.height
        return Vec2{
            new_rect.x + fx * new_rect.width,
            new_rect.y + fy * new_rect.height,
        }
    }

    ti := 0; fi := 0; bi := 0
    for i in 0..<sd.plot_count {
    	sp := save_plots[i]

	if i >= len(g.plots) {
	    ti += sp.tree_count; fi += sp.flower_count; bi += sp.box_count
            continue
        }
        plot := &g.plots[i]
        plot.owned           = sp.owned
        plot.owner_is_player = sp.owner_is_player

    	old_rect := rl.Rectangle{sp.rect[0], sp.rect[1], sp.rect[2], sp.rect[3]}

    	clear(&plot.trees)
    	clear(&plot.flowers)
    	clear(&plot.boxes)

    	for _ in 0..<sp.tree_count {
	    old_pos := Vec2{all_trees[ti].x, all_trees[ti].y}
	    append(&plot.trees, remap_to_new_rect(old_pos, old_rect, plot.rect))
	    ti += 1
	}
	for _ in 0..<sp.flower_count {
	    old_pos := Vec2{all_flowers[fi].x, all_flowers[fi].y}
	    append(&plot.flowers, remap_to_new_rect(old_pos, old_rect, plot.rect))
	    fi += 1
        }
	for _ in 0..<sp.box_count {
            append(&plot.boxes, all_box_idx[bi]); bi += 1
    	}
    }

    for i in 0..<sd.box_count {
    	sb := save_boxes[i]
    	qt := 0
    	if i < len(queen_tiers) { qt = int(queen_tiers[i]) }

    	pos := Vec2{sb.pos[0], sb.pos[1]}

    	if sb.on_plot >= 0 && sb.on_plot < sd.plot_count && sb.on_plot < len(g.plots) {
            old_rect := rl.Rectangle{
        	save_plots[sb.on_plot].rect[0], save_plots[sb.on_plot].rect[1],
            	save_plots[sb.on_plot].rect[2], save_plots[sb.on_plot].rect[3],
            }
            new_rect := g.plots[sb.on_plot].rect
            pos = remap_to_new_rect(pos, old_rect, new_rect)
    	}

	append(&g.bee_boxes, BeeBox{
	    pos = pos, kind = sb.kind,
	    honey_ml = sb.honey_ml, capacity = sb.capacity,
	    bee_count = sb.bee_count, active = sb.active, on_plot = sb.on_plot,
	    queen_tier = qt,
    	})
    }


    g.camera.target = g.player.pos
    build_collision_rects()
    return true
}


// INIT — BUILDINGS


BW :: f32(200)
BH :: f32(150)
BLX :: f32(-316)
BRX :: f32( 116)
BROW_TOP :: f32(-266)
BROW_MID :: f32( 116)
BROW_BOT :: f32( 326)
BROW_DEALER :: f32(650)
CDW         :: f32(320)
CDH         :: f32(160)
CDX         :: f32(-360)
FBF_X :: f32(-550)
FBF_Y :: BROW_TOP


init_buildings :: proc() {
    make_building :: proc(kind: BuildingType, rx, ry: f32, label: string, color: rl.Color) -> Building {
        return Building{
            kind  = kind,
            rect  = {rx, ry, BW, BH},
            label = label,
            color = color,
            door  = {rx + BW/2, ry + BH},
	    owned = true,
	    cost  = 0,
        }
    }
    g.buildings[.Market]        = make_building(.Market,        BLX, BROW_TOP,
"MARKET",           COL_MARKET)
    g.buildings[.SheriffOffice] = make_building(.SheriffOffice, BRX, BROW_TOP,
"POLICE",           COL_SHERIFF)
    g.buildings[.Diner]         = make_building(.Diner,         BLX, BROW_MID,
"RESTURANT",  COL_DINER)
    g.buildings[.Bank]          = make_building(.Bank,          BRX, BROW_MID,
"BANK", COL_BANK)
    g.buildings[.DoctorOffice]  = make_building(.DoctorOffice,  BLX, BROW_BOT,
"HOSPITAL",         COL_DOCTOR)
    g.buildings[.Bar]           = make_building(.Bar,           BRX, BROW_BOT,
"BAR",   COL_BAR)
    g.buildings[.BeeSanctuary]  = make_building(.BeeSanctuary,  BSX, BROW_TOP,
"BEE SANCTUARY", COL_SANCTUARY)
    g.buildings[.FuzzyBuddyFactory] = Building{
    kind  = .FuzzyBuddyFactory,
    rect  = {FBF_X, FBF_Y, BW, BH},
    label = "HONEY FACTORY",
    color = COL_FACTORY,
    door  = {FBF_X + BW/2, FBF_Y + BH},
    owned = false,
    cost  = FBF_COST,
}
    g.buildings[.CarDealership] = Building{
    kind  = .CarDealership,
    rect  = {CDX, BROW_DEALER, CDW, CDH},
    label = "DEALERSHIP",
    color = COL_DEALER_STEEL,
    door  = {CDX + CDW/2, BROW_DEALER + CDH},
}
    g.buildings[.Garage] = Building{
    kind  = .Garage,
    rect  = {GARAGE_X, GARAGE_Y, GARAGE_W, GARAGE_H},
    label = "GARAGE",
    color = COL_GARAGE,
    door  = {GARAGE_X + GARAGE_W/2, GARAGE_Y + GARAGE_H},
    owned = false,
    cost  = GARAGE_COST,
}
    g.buildings[.FarmersMarket] = Building{
    kind  = .FarmersMarket,
    rect  = {FARMERS_MARKET_X, FARMERS_MARKET_Y, FARMERS_MARKET_W, FARMERS_MARKET_H},
    label = "FARMERS MARKET",
    color = COL_MARKET_STALL,
    door  = {FARMERS_MARKET_X + FARMERS_MARKET_W/2, FARMERS_MARKET_Y + FARMERS_MARKET_H},
    owned = false,
    cost  = FARMERS_MARKET_COST,
}



}

init_homes :: proc() {
    home_colors := [NUM_HOMES]rl.Color{
        {200, 80, 80, 255}, {80, 140, 200, 255}, {100, 180, 80, 255},
        {200, 160, 60, 255}, {160, 80, 200, 255},
    }
    home_names := [NUM_HOMES]string{
        "Bando", "Le Crib", "BatCave", "Pimp Paradise", "Honey Home",
    }
    hw :: f32(120); hh :: f32(100)
    home_positions := [NUM_HOMES][2]f32{
        {-180, -440}, {-500, -440}, {-480, 440}, {460, 440}, {-350, -440},
    }
    for i in 0..<NUM_HOMES {
        px := home_positions[i][0]; py := home_positions[i][1]
        g.homes[i] = Home{
            rect  = {px, py, hw, hh},
            color = home_colors[i],
            door  = {px + hw/2, py + hh},
            owned = false,
            label = home_names[i],
	    interior_wall_color  = COL_INT_WALL,
	    interior_floor_color = COL_INT_FLOOR,
        }
    }
}


// INIT — PLOTS


add_plot :: proc(cx, cy: f32, s: PlotSize) {
    sz := plot_rect_size(s)
    plot: LandPlot
    plot.rect            = {cx - sz.x/2, cy - sz.y/2, sz.x, sz.y}
    plot.size            = s
    plot.cost            = plot_cost(s)
    plot.owned           = false
    plot.owner_is_player = false
    plot.trees   = make([dynamic]Vec2)
    plot.flowers = make([dynamic]Vec2)
    plot.boxes   = make([dynamic]int)

    tree_count := rand_int(3, 10)
    for _ in 0..<tree_count {
        tx := rand_f32(plot.rect.x + 28, plot.rect.x + plot.rect.width  - 28)
        ty := rand_f32(plot.rect.y + 28, plot.rect.y + plot.rect.height - 28)
        append(&plot.trees, Vec2{tx, ty})
    }
    flower_count := rand_int(8, 24)
    for _ in 0..<flower_count {
        fx := rand_f32(plot.rect.x + 8, plot.rect.x + plot.rect.width  - 8)
        fy := rand_f32(plot.rect.y + 8, plot.rect.y + plot.rect.height - 8)
        append(&plot.flowers, Vec2{fx, fy})
    }
    append(&g.plots, plot)
}

init_plots :: proc() {
    add_plot(-800, -680, .Small) // starting plot
    add_plot( 850, -650, .Small)
    add_plot(-850,  620, .Small)
    add_plot( 750,  1300, .Small)
    add_plot(-850, -1300, .Small)
    add_plot(-850,  250, .Small)
    add_plot( 850,  600, .Small)
    add_plot( 850,  220, .Small)

    add_plot(-1500, -1300, .Medium)
    add_plot( 1500, -1300, .Medium)
    add_plot(-1500,  1300, .Medium)
    add_plot( 1500,  1300, .Medium)

    add_plot(-350, -1300, .Medium)
    add_plot( 550, -1300, .Medium)
    add_plot(-550,  1300, .Medium)
    add_plot( 350,  1300, .Medium)

    add_plot(-1500, -450, .Large)
    add_plot(-1500,  450, .Large)
    add_plot( 1500, -450, .Large)
    add_plot( 1500,  450, .Large)

    add_plot(-1500, -2100, .XLarge)
    add_plot(    0, -2100, .XLarge)
    add_plot( 1500, -2100, .XLarge)
    add_plot(-1500,  2100, .XLarge)
    add_plot( -500,  2040, .XLarge)
    add_plot( 1500,  2100, .XLarge)
    add_plot(-2300, -1300, .XLarge)
    add_plot(-2300,     0, .XXLarge)
    add_plot(-2300,  1300, .XLarge)
    add_plot( 2300, -1300, .XLarge)
    add_plot( 2300,     0, .XXLarge)
    add_plot( 2300,  1300, .XLarge)

    add_plot(-2300, -2100, .XXLarge)
    add_plot( 2300, -2100, .XXLarge)
    add_plot(-2300,  2100, .XXLarge)
    add_plot( 2300,  2100, .XXLarge)

    for i in 0..<len(g.plots) {
        if g.plots[i].size == .Small {
            g.plots[i].owned           = true
            g.plots[i].owner_is_player = true
            g.player.owned_plot        = i
            break
        }
    }
}


// INIT — NPCs
try_buy_lightsaber_special :: proc(npc: ^NPC) -> bool {
    if npc.sell_item != "Lightsaber" { return false }
    if g.inv_lightsaber {
        show_message("Obiwan: \"You already carry a lightsaber, young Padawan.\"", 3)
        return true
    }
    if g.player.money < npc.sell_price {
        show_message("Not enough money!")
        return true
    }
    g.player.money   -= npc.sell_price
    g.inv_lightsaber  = true
    show_message("Obiwan hands you a lightsaber! \"The force is strong with you.\"toggle '8'", 6)
    return true
}
try_buy_batarang_special :: proc(npc: ^NPC) -> bool {
    if npc.sell_item != "Batarang" { return false }
    if g.inv_batarang {
        show_message("Bruce Wayne: \"What are you talking about?\"", 3)
        return true
    }
    if g.player.money < npc.sell_price {
        show_message("Not enough money!")
        return true
    }
    g.player.money  -= npc.sell_price
    g.inv_batarang   = true
    show_message("Mr.Fox send you a present.'7' to suit up.", 7)
    return true
}



init_npcs :: proc() {
    npc_names := [NPC_COUNT]string{
        "Earl","Dolly","Owen","Patsy","Cletus","Loretta",
        "Bruce","Kanye West","Jay","Tammy","Dale","Obama","Brent","Chase",
        "Lisa","Colin","Claire","El Sid","Randy",
        "Evan","Bruce Wayne","Lebron","Obiwan","Young Thug",
    }

    npc_colors := [6]rl.Color{
        {220,148,96,255},{176,116,76,255},{236,196,152,255},
        {196,156,116,255},{156,96,56,255},{228,176,136,255},
    }

    sell_items := [NPC_COUNT]string{
        "Flower Food","Bee Food","Honey Jar","Wax Candle","Whipped Honey","Clover Seeds",
        "Bee Smoker","Royal Jelly","Hive Tool","Bee Veil","Honey Comb","Bee Brush","Nectar","Propolis",
        "Lavender Honey","Maple Syrup","Cinnamon Sticks","Hot Sauce","Sunflower Seeds",
        "Meth","Batarang","Basketball","Lightsaber","Gold Chain",
    }

    sell_prices := [NPC_COUNT]f32{
        500,800,1200,600,400,550,200,350,900,1500,1800,700,450,220,
        750, 900, 350, 250, 300,
        600, 999, 250, 800, 420,
    }

    buy_items := [NPC_COUNT]string{
        "Spicy Honey","Honey Fruit Snacks","Beeswax","Honey","Pollen","Honey",
        "Honey","Royal Jelly","Whipped Honey","Frozen Honeysicle","Beeswax","Wax Candle","Nectar","Honey Tube",
        "Honey","Beeswax","Honey Comb","Pollen","Nectar",
        "Royal Jelly","Honey","Honey","Honey","Honey",
    }

    buy_prices := [NPC_COUNT]f32{
        3200,3400,1500,3300,800,3100,3500,4000,3200,3300,1600,3400,900,3600,
        2800, 1700, 2200, 950, 1100,
        3800, 5000, 4200, 4500, 3900,
    }
    npc_food_names := [NPC_COUNT]string{
	"Honeycomb Waffle", "Beeswax Toffee", "Clover Honey Bar", "Royal Honey",
	"Frozen Honey", "Honey-Glazed Nuts", "Honey Biscuit", "Pretzel",
	"Honey-drizzle Muffin", "Sticky Bun Supreme", "Honey Cake", "Nectar Nuggets",
	"Honey Sticks", "Wildflower Wafer", "Sunflower Honey Chip", "Bee Sting Pastry",
	"Amber Bagel", "Honey Danish", "Comb & Crumb Bar", "Honey Roll",
	"Clover Bagel", "Honey Crackers", "Hive Mind Crisp", "Honeydew Cookie",
    }
    npc_food_prices := [NPC_COUNT]f32{
	60.00, 70.50, 50.00, 90.00, 40.50, 80.00, 50.50, 60.50,
	70.00, 80.50, 60.00, 70.50, 90.50, 50.00, 60.50, 70.00,
    	50.50, 80.00, 60.00, 10.00, 50.00, 70.50, 60.50, 80.00,
    }
    npc_drink_names := [NPC_COUNT]string{
	"Honey Lemonade", "Royal Mead Fizz", "Nectar Cooler", "Buzzin' Bee-Tea",
    	"Golden Cider", "Clover Cola", "Wildflower Water", "Honeysuckle Punch",
    	"Pollen Smoothie", "Hive Hydrator", "Sweet Comb Tonic", "Amber Ale (Non-Alc)",
    	"Meadow Milkshake", "Sting Slush", "Sunny Honey Soda", "Bee's Knees Brew",
    	"Drizzle Dew", "Queen Bee Cooler", "Buzzworthy Brew", "Nectar Nog",
    	"Honeycomb Frappe", "Petal Punch", "Hive High Tea", "Golden Hour Juice",
    }
    npc_drink_prices := [NPC_COUNT]f32{
    	30.50, 40.50, 30.00, 40.00, 30.50, 30.00, 30.50, 40.00,
    	40.50, 30.50, 40.00, 50.00, 40.50, 30.50, 30.00, 40.50,
    	30.50, 40.00, 40.50, 50.00, 40.00, 30.50, 40.00, 40.50,
    }


    dialogues := [NPC_COUNT][3]string{
        {"Hey there farmer!", "Bees are buzzin' today!", "Good honey weather!"},
        {"My bees made extra today!", "Have you tried clover honey?", "Sweet as pie!"},
        {"Sheriff says stay off my land Dale!", "I got the best hives in town.", "Yee-haw!"}, // owen 
        {"Lovely day for beekeeping!", "My flowers attract the best bees.", "Try my honey cake!"},
        {"Watch out for the hornets!", "I planted extra clover this year.", "Bees love me."},
        {"I sell the finest seeds!", "Plant near your hives for more honey.", "Good luck out there!"},
        {"My smoker keeps 'em calm.", "Never rush a bee, partner.", "Slow and steady wins."},
        {"I only deal in royal jelly.", "ye.", "this yeezy honey."}, // kanye west
        {"Got a new hive tool today!", "Keep your equipment clean.", "Lets go flying."},
        {"This veil saved me twice!", "Safety first in the apiary.", "Bees can smell fear."},
        {"Fresh honeycomb this morning!", "Nothing beats raw comb.", "Try it with butter!"},
        {"Im hungry.", "Want to sell any honey?.", "Steady hands matter."},
        {"Nectar season is peaking!", "The flowers are blooming early.", "Great time to harvest."},
        {"Propolis seals everything.", "The bees know best.", "Nature's glue, they call it."},
        {"Honey is my skincare secret!", "Lavender and bees go together.", "Stay sweet out there!"},
        {"Beeswax candles are life.", "I read about bees all night.", "Knowledge is honey."},
        {"The hive mind fascinates me.", "Every bee has a purpose.", "Nature is perfect."},
        {"Yo, the bees respect me.", "El Sid don't mess with hornets.", "Keep it buzzing, fam."}, // el sid 
        {"I once wrestled a bear for honey.", "True story, no cap.", "Bees are my spirit animal."},
        {"I'm hungry", "How did I get here?.", "Buy my honey so I can buy an RX7."}, // evan 
        {"The bees are my allies tonight.", "Gotham needs more honey farms.", "I am the night... farmer."}, // bruce wayne
        {"Honey is my pre-game ritual.", "Bees got that championship energy.", "Stay humble nephew."}, // lebron
        {"These are not the bees you're looking for.", "Use the hive, Luke.", "May the honey be with you, always."}, //obiwan
        {"Slatt", "Slime", "Free the bees."}, // young thug
    }

    spawn_positions := [NPC_COUNT]Vec2{
        { 500,  500}, {-500,  500}, { 500, -500}, {-500, -500},
        { 650,    0}, {-650,    0}, {   0,  650}, {   0, -650},
        { 550,  300}, {-550,  300}, { 550, -300}, {-550, -300},
        { 300,  600}, {-300,  600},
        {-1500, -1300}, { 1500, -1300}, {-1500,  1300}, { 1500,  1300},
        {-2300,     0},
        { 2300,     0}, {    0, -2100}, {    0,  2100}, {-2300, -2100},
        { 2300,  2100},
    }

    wander_targets := [NPC_COUNT]Vec2{
        { 620,  880}, {-820,  880}, { 820, -780}, {-920, -480},
        { 700,   80}, {-700,   80}, {  80,  700}, {  80, -700},
        { 480,  420}, {-480,  420}, { 480, -420}, {-480, -420},
        { 420,  520}, {-420,  520},
        {-1800, -800}, { 1800, -800}, {-1800,  800}, { 1800,  800},
        {-2000,  500},
        { 2000, -500}, {  500, -1800}, { -500,  1800}, {-2000, -1800},
        { 2000,  1800},
    }

    patterns := [5]ClothingPattern{.Solid, .Stripes, .Dots, .Plaid, .Checkered}

    new_shirt_colors := [10]rl.Color{
        {220,  60, 120, 255}, // Lisa      — hot pink
        { 40,  80, 200, 255}, // Colin     — royal blue
        { 80, 200, 160, 255}, // Claire    — teal
        {255, 140,   0, 255}, // El Sid    — orange
        { 60, 160,  60, 255}, // Randy     — forest green
        {180,  40, 220, 255}, // Evan      — purple
        { 20,  20,  20, 255}, // Bruce Wayne — black
        {148,   0, 211, 255}, // Lebron    — Lakers purple
        {200, 200, 200, 255}, // Obiwan    — robe grey
        {255, 215,   0, 255}, // Young Thug — gold
    }
    new_pants_colors := [10]rl.Color{
        {255, 182, 193, 255}, // Lisa      — light pink
        {200, 220, 255, 255}, // Colin     — light blue
        { 30, 100,  80, 255}, // Claire    — dark teal
        { 80,  40,   0, 255}, // El Sid    — dark brown
        {200, 180, 100, 255}, // Randy     — khaki
        { 60,  20,  80, 255}, // Evan      — dark purple
        { 10,  10,  10, 255}, // Bruce Wayne — near black
        {255, 215,   0, 255}, // Lebron    — gold
        {160, 160, 160, 255}, // Obiwan    — grey
        { 20,  20,  20, 255}, // Young Thug — black
    }
    new_hat_colors := [10]rl.Color{
        {255, 105, 180, 255}, // Lisa
        {  0,   0, 180, 255}, // Colin
        {  0, 180, 140, 255}, // Claire
        {200, 100,   0, 255}, // El Sid
        { 34, 139,  34, 255}, // Randy
        {138,  43, 226, 255}, // Evan
        { 30,  30,  30, 255}, // Bruce Wayne
        { 85,  26, 139, 255}, // Lebron
        {210, 210, 210, 255}, // Obiwan
        {255, 200,   0, 255}, // Young Thug
    }
    new_pattern_colors := [10]rl.Color{
        {255, 255, 255, 255}, // Lisa      — white dots
        {255, 165,   0, 255}, // Colin     — orange stripes
        {255, 255,   0, 255}, // Claire    — yellow plaid
        {255,  50,  50, 255}, // El Sid    — red checkered
        {255, 255, 255, 255}, // Randy     — white solid
        {  0, 255, 255, 255}, // Evan      — cyan dots
        {255, 215,   0, 255}, // Bruce Wayne — gold stripes
        {  0,   0, 255, 255}, // Lebron    — blue plaid
        {200, 180, 100, 255}, // Obiwan    — tan solid
        {255,   0, 255, 255}, // Young Thug — magenta checkered
    }
    new_patterns := [10]ClothingPattern{
        .Dots, .Stripes, .Plaid, .Checkered, .Solid,
        .Dots, .Stripes, .Plaid, .Solid, .Checkered,
    }

    for i in 0..<NPC_COUNT {
        kind: NPCType = .Farmer if i < 7 else .Civilian

        if i < 14 {
            
		g.npcs[i] = NPC{
                pos              = spawn_positions[i],
                kind             = kind,
                color            = npc_colors[i % 6],
                target           = wander_targets[i],
                timer            = rand_f32(2, 8),
                name             = npc_names[i],
                sell_item        = sell_items[i],
                sell_price       = sell_prices[i],
                buy_item         = buy_items[i],
                buy_price        = buy_prices[i],
                dialogue         = dialogues[i],
                frozen_timer     = 0,
                shirt_color      = rand_color(),
                pants_color      = rand_color(),
                hat_color        = rand_color(),
                clothing_pattern = patterns[i % 5],
                pattern_color    = rand_color(),
		food_item   = npc_food_names[i],
		food_price  = npc_food_prices[i],
		drink_item  = npc_drink_names[i],
		drink_price = npc_drink_prices[i],

            }
        } else {
            ni := i - 14
            g.npcs[i] = NPC{
                pos              = spawn_positions[i],
                kind             = .Civilian,
                color            = npc_colors[ni % 6],
                target           = wander_targets[i],
                timer            = rand_f32(2, 8),
                name             = npc_names[i],
                sell_item        = sell_items[i],
                sell_price       = sell_prices[i],
                buy_item         = buy_items[i],
                buy_price        = buy_prices[i],
                dialogue         = dialogues[i],
                frozen_timer     = 0,
                shirt_color      = new_shirt_colors[ni],
                pants_color      = new_pants_colors[ni],
                hat_color        = new_hat_colors[ni],
                clothing_pattern = new_patterns[ni],
                pattern_color    = new_pattern_colors[ni],
		food_item   = npc_food_names[i],
		food_price  = npc_food_prices[i],
		drink_item  = npc_drink_names[i],
		drink_price = npc_drink_prices[i],

            }
        }
    }
}
FESTIVAL_NPC_NAMES := [FESTIVAL_NPC_COUNT]string{
    "Farmer Gus", "Farmer May", "Farmer Cole", "Farmer June", "Farmer Ray", "Farmer Fern",
}
FESTIVAL_GOODS := [FESTIVAL_NPC_COUNT]struct{name: string, price: f32}{
    {"Flower Seeds", 150}, {"Tree Sapling", 500}, {"Bee Snack", 80},
    {"Fertilizer", 250}, {"Honey Dipper", 120}, {"Candle Mold", 300},
}

start_festival :: proc() {
    g.festival_active = true
    g.festival_timer  = FESTIVAL_DURATION
    for i in 0..<FESTIVAL_NPC_COUNT {
        npc := &g.festival_npcs[i]
        npc^ = NPC{
            pos   = { rand_f32(PARK_X + 40, PARK_X + PARK_W - 40),
                      rand_f32(PARK_Y + 40, PARK_Y + PARK_H - 40) },
            kind  = .Farmer,
            color = rand_color(),
            target= { rand_f32(PARK_X + 40, PARK_X + PARK_W - 40),
                      rand_f32(PARK_Y + 40, PARK_Y + PARK_H - 40) },
            timer = rand_f32(2, 6),
            name  = FESTIVAL_NPC_NAMES[i],
            buy_item  = "Honey",
            buy_price = 600 * FESTIVAL_SELL_MULT,
            sell_item  = FESTIVAL_GOODS[i].name,
            sell_price = FESTIVAL_GOODS[i].price,
            frozen_timer = 0,
            shirt_color  = rand_color(),
            pants_color  = rand_color(),
            hat_color    = rand_color(),
        }
    }
    show_message("Honey Festival started: Go to the Honeycomb Park to explore.", 6)
}

end_festival :: proc() {
    g.festival_active   = false
    g.festival_menu_open = false
    show_message("Festival Over", 3)
}



init_shop :: proc() {
    g.shop_items = {
        {label="Small Bee Hive ($500)",     cost=BOX_COST_SMALL_GROUND,
kind=.SmallGround},
        {label="Large Bee Hive ($1000)",    cost=BOX_COST_LARGE_GROUND,
kind=.LargeGround},
        {label="Tree Hanging Hive ($1500)", cost=BOX_COST_TREE,
kind=.TreeHang},
    }
}

init_cars :: proc() {
    g.in_car      = false
    g.current_car = -1

    dealer_door_x := f32(-160) + f32(320)/2
    dealer_door_y := f32(560) + f32(160)

    car_types := [MAX_CARS]CarType{ .HoneyRacer, .BeeCruiser, .PollenGT }
    car_cols  := [MAX_CARS]rl.Color{
        COL_CAR_RED,
        COL_CAR_BLUE,
        COL_CAR_YELLOW,
    }

    for i in 0..<MAX_CARS {
        g.cars[i] = Car{
            pos      = { dealer_door_x + f32(i - 1) * 60, dealer_door_y + 40 },
            angle    = 0,
            kind     = car_types[i],
            body_col = car_cols[i],
            owned    = false,
            active   = false,
            occupied = false,
        }
    }
}
init_lightning_bugs :: proc() {
    for i in 0..<LIGHTNING_BUG_COUNT {
        x, y: f32
        for {
            x = rand_f32(-2600, 2600)
            y = rand_f32(-2600, 2600)
            if x > -620 && x < 620 && y > -620 && y < 620 { continue }
            break
        }
        g.lightning_bugs[i] = LightningBug{
            pos        = {x, y},
            target     = {x + rand_f32(-80, 80), y + rand_f32(-80, 80)},
            timer      = rand_f32(1, 6),
            flash_time = rand_f32(0, 4),
        }
    }
}
init_soccer :: proc() {
    fw := SOCCER_FIELD_W
    fh := SOCCER_FIELD_H
    fx := SOCCER_FIELD_X
    fy := SOCCER_FIELD_Y
    wall  :: f32(8)
    goal_h :: f32(60)
    sg := &g.soccer
    sg.field_x = fx + wall
    sg.field_y = fy + wall
    sg.field_w = fw - wall*2
    sg.field_h = fh - wall*2
    cy := fy + fh/2
    sg.goal_left_y1  = cy - goal_h/2
    sg.goal_left_y2  = cy + goal_h/2
    sg.goal_right_y1 = cy - goal_h/2
    sg.goal_right_y2 = cy + goal_h/2
    sg.ball.pos = {fx + fw/2, fy + fh/2}
    sg.ball.vel = {0, 0}
    sg.npc.pos    = {fx + fw*0.75, fy + fh/2}
    sg.npc.target = sg.npc.pos
    sg.npc.timer  = 1.0
    sg.state         = .Idle
    sg.player_score  = 0
    sg.npc_score     = 0
    sg.show_help     = false
    sg.game_over_timer = 0
    cy1 := sg.goal_left_y1
    cy2 := sg.goal_left_y2

    // Top wall
    append(&g.collision_rects, rl.Rectangle{fx, fy, fw, wall})
    // Bottom wall
    append(&g.collision_rects, rl.Rectangle{fx, fy + fh - wall, fw, wall})
    // Left wall — above goal
    append(&g.collision_rects, rl.Rectangle{fx, fy + wall, wall, cy1 - (fy + wall)})
    // Left wall — below goal
    append(&g.collision_rects, rl.Rectangle{fx, cy2, wall, (fy + fh - wall) - cy2})
    // Right wall — above goal
    append(&g.collision_rects, rl.Rectangle{fx + fw - wall, fy + wall, wall, cy1 - (fy + wall)})
    // Right wall — below goal
    append(&g.collision_rects, rl.Rectangle{fx + fw - wall, cy2, wall, (fy + fh - wall) - cy2})
}
init_animals :: proc() {
    types := []AnimalType{.Rabbit, .Fox, .Deer, .Squirrel, .Frog, .Butterfly}

    for i in 0..<ANIMAL_COUNT {
        kind := types[i % len(types)]
        x, y: f32
        for {
            x = rand_f32(-2400, 2400)
            y = rand_f32(-2400, 2400)
            if x > -700 && x < 700 && y > -700 && y < 700 { continue }
            if x > 650 && x < 1100 && y > -1000 && y < -350 { continue }
            break
        }
        tint := rl.Color{
            u8(rand_int(220, 255)),
            u8(rand_int(220, 255)),
            u8(rand_int(220, 255)),
            255,
        }

        g.animals[i] = Animal{
            pos       = {x, y},
            target    = {x + rand_f32(-100, 100), y + rand_f32(-100, 100)},
            kind      = kind,
            timer     = rand_f32(2, 8),
            idle_time = rand_f32(0, 3),
            is_idle   = false,
            anim_time = rand_f32(0, 6.28),
            color     = tint,
        }
    }
}
init_pond :: proc() {
    fish_kinds := []FishType{.Bass, .Trout, .Catfish, .Goldfish, .Pike, .Perch}
    for i in 0..<POND_FISH_COUNT {
	kind := fish_kinds[i % len(fish_kinds)]
	x := rand_f32(POND_X + 30, POND_X + POND_W - 30)
	y := rand_f32(POND_Y + 30, POND_Y + POND_H - 30)
	g.pond.fish[i] = Fish{
	    pos       = {x, y},
            vel       = {rand_f32(-20, 20), rand_f32(-15, 15)},
            kind      = kind,
            timer     = rand_f32(1, 5),
            anim_time = rand_f32(0, 6.28),
            flip      = rand_int(0, 2) == 0,
            depth     = rand_f32(0, 1),
            dive_time = rand_f32(2, 8),
            is_deep   = rand_int(0, 2) == 0,
        }
    }
}
init_birds :: proc() {
    bird_colors := [8]rl.Color{
        {230,  60,  60, 255}, // red
        { 60, 120, 230, 255}, // blue
        {250, 210,  40, 255}, // yellow
        { 80, 200,  90, 255}, // green
        {240, 140,  30, 255}, // orange
        {230,  90, 200, 255}, // pink
        {160,  90, 230, 255}, // purple
        { 60, 210, 210, 255}, // cyan
    }
    margin :: f32(30)
    lo_x := PARK_X + margin;          hi_x := PARK_X + PARK_W - margin
    lo_y := PARK_Y + margin;          hi_y := PARK_Y + PARK_H - margin

    for i in 0..<BIRD_COUNT {
        g.birds[i] = Bird{
            pos       = {rand_f32(lo_x, hi_x), rand_f32(lo_y, hi_y)},
            target    = {rand_f32(lo_x, hi_x), rand_f32(lo_y, hi_y)},
            timer     = rand_f32(1, 5),
            idle_time = rand_f32(0, 3),
            is_idle   = false,
            anim_time = rand_f32(0, 6.28),
            color     = bird_colors[i % 8],
        }
    }
}

// INIT — COLLISION RECTS


build_collision_rects :: proc() {
    clear(&g.collision_rects)
    for bt in BuildingType { append(&g.collision_rects, g.buildings[bt].rect) }
    for i in 0..<NUM_HOMES { append(&g.collision_rects, g.homes[i].rect) }
    for plot in g.plots {
        if !plot.owner_is_player { append(&g.collision_rects, plot.rect) }
    }
    add_park_collision()
    add_racetrack_collision()
    add_fountain_collision()
}
add_pond_collision :: proc() {
    wall_thickness :: f32(8)

    px := POND_X
    py := POND_Y
    pw := POND_W
    ph := POND_H
    dw := POND_DOCK_WIDTH
    dock_x := px + pw/2 - dw/2

    // Top wall
    append(&g.collision_rects, rl.Rectangle{
        px, py - wall_thickness, pw, wall_thickness,
    })

    // Left wall
    append(&g.collision_rects, rl.Rectangle{
        px - wall_thickness, py, wall_thickness, ph,
    })

    // Right wall
    append(&g.collision_rects, rl.Rectangle{
        px + pw, py, wall_thickness, ph,
    })

    // Bottom wall — LEFT segment
    append(&g.collision_rects, rl.Rectangle{
        px, py + ph, dock_x - px, wall_thickness,
    })

    // Bottom wall — RIGHT segment
    append(&g.collision_rects, rl.Rectangle{
        dock_x + dw, py + ph, (px + pw) - (dock_x + dw), wall_thickness,
    })
}
add_racetrack_collision :: proc() {
    outer := racetrack_outer_rect()
    inner := racetrack_inner_rect()
    wall  := RACETRACK_WALL_THICK
    gate_cx := RACETRACK_CENTER.x

    append(&g.collision_rects, CollisionRect{outer.x, outer.y, outer.width, wall})                 // top
    append(&g.collision_rects, CollisionRect{outer.x, outer.y, wall, outer.height})                 // left
    append(&g.collision_rects, CollisionRect{outer.x+outer.width-wall, outer.y, wall, outer.height}) // right

    bottom_y := outer.y + outer.height - wall
    left_w   := (gate_cx - RACETRACK_GATE_HW) - outer.x
    right_x  := gate_cx + RACETRACK_GATE_HW
    right_w  := (outer.x + outer.width) - right_x
    append(&g.collision_rects, CollisionRect{outer.x, bottom_y, left_w, wall})   // bottom-left of gate
    append(&g.collision_rects, CollisionRect{right_x, bottom_y, right_w, wall})  // bottom-right of gate

    append(&g.collision_rects, inner) // infield
}

// INIT — MAIN MENU FLOWERS


init_main_menu_flowers :: proc() {
    for i in 0..<28 {
        g.main_menu_flowers[i] = MainMenuFlower{
            x    = rand_f32(8, f32(GAME_W) - 8),
            y    = rand_f32(32, f32(GAME_H) - 20),
            seed = rand_int(0, 100),
        }
    }
}


// INIT — MAIN


init_game :: proc() {
    rng_seed(42069)

    g.player = Player{
    pos        = {0, 560},
    money      = START_MONEY,
    owned_plot = -1,
    honey_ml   = 0,
    shirt_color      = CUSTOMIZE_PALETTE[5],  // Blue
    pants_color      = CUSTOMIZE_PALETTE[6],  // Purple
    hat_color        = CUSTOMIZE_PALETTE[8],  // Brown
    clothing_pattern = .Solid,
    pattern_color    = CUSTOMIZE_PALETTE[10], // White
}
g.customize_shirt_idx         = 5
g.customize_pants_idx         = 6
g.customize_hat_idx           = 8
g.customize_pattern_idx       = 0
g.customize_pattern_color_idx = 10
g.customize_open              = false
g.customize_cursor            = 0
g.player.skin_color = SKIN_PALETTE[0]
g.customize_skin_idx = 0
g.player.health = PLAYER_STAT_MAX
g.player.hunger = PLAYER_STAT_MAX
g.player.thirst = PLAYER_STAT_MAX


    g.camera = rl.Camera2D{
        target = g.player.pos,
        offset = {GAME_W/2, GAME_H/2},
        zoom   = 1.0,
    }
    g.state                  = .World
    g.selected_plot          = -1
    g.selected_home          = -1
    g.selected_npc           = -1
    g.minimap_full           = false
    g.menu_cursor            = 0
    g.menu_action            = false
    g.save_rename_slot       = -1
    g.bee_boxes              = make([dynamic]BeeBox)
    g.camera_roll            = make([dynamic]Photo)
    g.discovered_open        = false
    g.discovered_animals     = {}
    g.discovered_fish        = {}
    g.plots                  = make([dynamic]LandPlot)
    g.collision_rects        = make([dynamic]CollisionRect)
    g.inventory_open         = false
    g.inventory_cursor       = 0
    g.inv_queen_bees         = 0
    g.inv_bee_net             = false
    g.bee_net_active          = false
    g.inv_lightsaber    = false
    g.lightsaber_active = false
    g.player_zoom_active = false
    g.inv_batarang    = false
    g.batarang_active = false
    g.yoda              = {}
    g.buzzy.pipes      = make([dynamic]BuzzyPipe)
    g.buzzy.high_score = 0
    g.owned_animal_buddies = {}
    g.animal_buddy         = {}
    g.animal_menu_open     = false
    g.animal_menu_cursor   = 0
    g.lightning_bugs_caught = 0
    g.inv_lantern           = false
    g.lantern_active        = false
    g.fishing_active   = false
    g.fishing_timer    = 0
    g.bee_swarm.active        = false
    g.bee_swarm.spawn_cooldown = rand_f32(BEE_SWARM_SPAWN_MIN_WAIT, BEE_SWARM_SPAWN_MAX_WAIT)
    g.festival_cooldown = FESTIVAL_INTERVAL
    g.interior_option_open   = false
    g.interior_option_cursor = 0
    g.interior_home          = -1
    g.home_option_open       = false
    g.home_option_cursor     = 0
    g.trophy_slot_editing    = 0
    g.bank_stock_cursor      = 0
    g.hive_address_cursor    = 0
    g.honey_stock_count      = 0
    g.main_menu_mode         = 0
    g.sanctuary_donated      = 0
    g.sanctuary_bee_count    = 0
    g.auction_timer          = 0
    g.auction_cooldown       = rand_f32(AUCTION_MIN_WAIT, AUCTION_MAX_WAIT)
    g.day_time      = 0
    g.is_night      = false
    g.season_time   = 0
    g.season        = .Summer
    g.rain_timer    = 0
    g.rain_cooldown = RAIN_INTERVAL
    g.weather_menu_open = false
    g.weather_state_timer = 0
    g.honey_stock_history[0] = honey_value_per_liter()
    g.honey_stock_season[0]  = g.season
    g.honey_stock_count      = 1
    g.render_tex = rl.LoadRenderTexture(GAME_W, GAME_H)
    rl.SetTextureFilter(g.render_tex.texture, .POINT)
    gallery_textures[0] = rl.LoadTexture("assets/bill_painting.png")
    rl.SetTextureFilter(gallery_textures[0], .POINT)
    init_buildings()
    init_homes()
    init_plots()
    init_npcs()
    init_shop()
    init_cars()
    init_soccer()
    init_animals()
    init_pond()
    init_birds()
    init_lightning_bugs()
    build_collision_rects()

    for i in 0..<NUM_SAVE_SLOTS { refresh_save_header(i) }

    show_message("Welcome to Honeyville! Where honey is money!", 6)
}


// COLLISION HELPERS


player_radius :: f32(8)

resolve_collision :: proc(pos: Vec2) -> Vec2 {
    result := pos
    pr     := player_radius
    for r in g.collision_rects {
        expanded := rl.Rectangle{r.x - pr, r.y - pr, r.width + pr*2, r.height +
pr*2}
        if !rl.CheckCollisionPointRec(result, expanded) { continue }
        ox_left  := (expanded.x + expanded.width)  - result.x
        ox_right := result.x - expanded.x
        oy_top   := (expanded.y + expanded.height) - result.y
        oy_bot   := result.y - expanded.y

        min_ox := ox_left if ox_left < ox_right else -ox_right
        min_oy := oy_top  if oy_top  < oy_bot   else -oy_bot

        if abs(min_ox) < abs(min_oy) {
            result.x += min_ox
        } else {
            result.y += min_oy
        }
    }
    return result
}

// UPDATE


update_player :: proc() {
    if g.in_car { return }
    if g.customize_open { return }
    if g.achievements_open { return }
    dt  := g.dt
    vel : Vec2
    if rl.IsKeyDown(.W) { vel.y -= 1 }
    if rl.IsKeyDown(.S) { vel.y += 1 }
    if rl.IsKeyDown(.A) { vel.x -= 1 }
    if rl.IsKeyDown(.D) { vel.x += 1 }

    l := math.sqrt(vel.x*vel.x + vel.y*vel.y)
    if l > 0 { vel.x = vel.x/l * PLAYER_SPEED; vel.y = vel.y/l * PLAYER_SPEED }

    new_pos := Vec2{
        g.player.pos.x + vel.x * dt,
        g.player.pos.y + vel.y * dt,
    }
    g.player.pos = resolve_collision(new_pos)
}

consume_food :: proc() {
    if g.inv_food_count <= 0 {
        show_message("You have no food to eat!")
        return
    }
    g.inv_food_count -= 1
    g.player.hunger = min(g.player.hunger + FOOD_HUNGER_RESTORE, PLAYER_STAT_MAX)
    show_message(fmt.aprintf("Ate a meal! Hunger +%.0f. (%d left)", FOOD_HUNGER_RESTORE, g.inv_food_count, allocator = context.temp_allocator), 3)
}

consume_drink :: proc() {
    if g.inv_drink_count <= 0 {
        show_message("You have no drinks left!")
        return
    }
    g.inv_drink_count -= 1
    g.player.hunger = min(g.player.hunger + DRINK_HUNGER_RESTORE, PLAYER_STAT_MAX)
    g.player.thirst = min(g.player.thirst + DRINK_THIRST_RESTORE, PLAYER_STAT_MAX)
    show_message(fmt.aprintf("Had a drink! Thirst +%.0f, Hunger +%.0f. (%d left)", DRINK_THIRST_RESTORE, DRINK_HUNGER_RESTORE, g.inv_drink_count, allocator = context.temp_allocator), 3)
}

update_player_needs :: proc() {
    dt := g.dt

    if g.death_active {
        g.death_timer -= dt
        if g.death_timer <= 0 {
            g.death_active = false
            respawn_at_hospital()
        }
        return
    }

    g.player.hunger = max(g.player.hunger - HUNGER_DECAY_RATE*dt, 0)
    g.player.thirst = max(g.player.thirst - THIRST_DECAY_RATE*dt, 0)

    if g.player.hunger <= 0 || g.player.thirst <= 0 {
        g.starvation_timer += dt
        if g.starvation_timer >= STARVATION_TICK_SECONDS {
            g.starvation_timer -= STARVATION_TICK_SECONDS
            g.player.health = max(g.player.health - STARVATION_DAMAGE, 0)
            if g.player.health <= 0 {
                trigger_player_death()
            }
        }
    } else {
        g.starvation_timer = 0
    }

    if g.player.hunger >= HEALTH_REGEN_THRESHOLD || g.player.thirst >= HEALTH_REGEN_THRESHOLD {
        g.player.health = min(g.player.health + HEALTH_REGEN_RATE*dt, PLAYER_STAT_MAX)
    }
}

trigger_player_death :: proc() {
    g.death_active    = true
    g.death_timer     = DEATH_BLACKOUT_SECONDS
    g.death_return_pos = g.player.pos
    show_message("You collapsed! Rushing to the hospital...", 4)
}

respawn_at_hospital :: proc() {
    g.interior_building = .DoctorOffice
    g.prev_world_pos    = g.death_return_pos
    g.state             = .Interior

    rw, rh := interior_room_size(g.interior_building)
    g.player.pos = {0, rh/2 - 40}

    g.player.health = PLAYER_STAT_MAX
    g.player.hunger = PLAYER_STAT_MAX
    g.player.thirst = PLAYER_STAT_MAX

    penalty := g.player.money * DEATH_MONEY_PENALTY_PCT
    g.player.money -= penalty
    show_message(fmt.aprintf("You died. Treatment cost you $%.0f!", penalty, allocator = context.temp_allocator), 5)
}


update_camera :: proc() {
    dt := g.dt
    g.camera.target.x += (g.player.pos.x - g.camera.target.x) * 10 * dt
    g.camera.target.y += (g.player.pos.y - g.camera.target.y) * 10 * dt

    if !g.bee_cam_active {
        target_zoom := PLAYER_ZOOM_CLOSE if g.player_zoom_active else PLAYER_ZOOM_NORMAL
        g.camera.zoom += (target_zoom - g.camera.zoom) * 8 * dt
    }
}


update_npcs :: proc() {
    dt := g.dt
    for i in 0..<NPC_COUNT {
        npc := &g.npcs[i]
        if npc.frozen_timer > 0 {
            npc.frozen_timer -= dt
            continue
        }
        npc.timer -= dt
        if npc.timer <= 0 {
	    market_open := g.buildings[.FarmersMarket].owned && !g.is_night
	    can_shop := market_open && npc.buy_item == "Honey" && npc.market_cooldown <= 0 && !npc.at_market

	    if can_shop && rand_f32(0, 1) < 0.2 {
		npc.target = {FARMERS_MARKET_X + FARMERS_MARKET_W/2, FARMERS_MARKET_Y + FARMERS_MARKET_H/2}
		npc.at_market = true
	    } else {
            	side := rand_int(0, 4)
            	switch side {
            	case 0: npc.target = {rand_f32( 420, 2400), rand_f32(-2400, 2400)}
            	case 1: npc.target = {rand_f32(-2400, -420), rand_f32(-2400, 2400)}
            	case 2: npc.target = {rand_f32(-2400, 2400), rand_f32( 420, 2400)}
            	case 3: npc.target = {rand_f32(-2400, 2400), rand_f32(-2400, -420)}
		}
            }
            npc.timer = rand_f32(3, 10)
        }
	if npc.market_cooldown > 0 { npc.market_cooldown -= dt }
        dir := Vec2{npc.target.x - npc.pos.x, npc.target.y - npc.pos.y}
        d   := math.sqrt(dir.x*dir.x + dir.y*dir.y)
        if d > 4 {
            new_npc_pos := Vec2{
                npc.pos.x + (dir.x/d) * NPC_SPEED * dt,
                npc.pos.y + (dir.y/d) * NPC_SPEED * dt,
            }
            resolved := resolve_collision(new_npc_pos)
            if abs(resolved.x - npc.pos.x) < 0.1 && abs(resolved.y - npc.pos.y)< 0.1 {
                side := rand_int(0, 4)
                switch side {
                case 0: npc.target = {rand_f32( 420, 2400), rand_f32(-2400, 2400)}
                case 1: npc.target = {rand_f32(-2400, -420), rand_f32(-2400, 2400)}
                case 2: npc.target = {rand_f32(-2400, 2400), rand_f32( 420, 2400)}
                case 3: npc.target = {rand_f32(-2400, 2400), rand_f32(-2400, -420)}
                }
                npc.timer = rand_f32(2, 6)
            }
            npc.pos = resolved
        }
	if npc.at_market {
	    dist := math.sqrt((npc.pos.x-npc.target.x)*(npc.pos.x-npc.target.x) + (npc.pos.y-npc.target.y)*(npc.pos.y-npc.target.y))
	    if dist < MARKET_INTERACT_DIST {
		if g.is_night || !g.buildings[.FarmersMarket].owned {
		    npc.at_market = false
		    npc.market_cooldown = rand_f32(30, 60)
		} else if g.market_price > npc.buy_price {
		    show_message(fmt.aprintf("%s thinks the honey is too expensive!", npc.name, allocator = context.temp_allocator))
		    npc.at_market = false
		    npc.market_cooldown = rand_f32(40, 90)
		} else if g.player.honey_ml >= MARKET_SALE_ML {
		    g.player.honey_ml -= MARKET_SALE_ML
		    g.player.money += g.market_price
		    show_message(fmt.aprintf("%s bought honey for $%.0f!", npc.name, g.market_price, allocator = context.temp_allocator))
		    npc.at_market = false
		    npc.market_cooldown = rand_f32(60, 120)
		} else {
		    show_message(fmt.aprintf("%s found the stall sold out!", npc.name, allocator = context.temp_allocator))
		    npc.at_market = false
		    npc.market_cooldown = rand_f32(60, 120)
                }
            }
        } 
    }
}
update_lightsaber_toggle :: proc() {
    if !rl.IsKeyPressed(.EIGHT) { return }
    if !g.inv_lightsaber {
        show_message("You don't have a lightsaber yet!")
        return
    }
    g.lightsaber_active = !g.lightsaber_active
    if g.lightsaber_active {
        spawn_yoda()
        show_message("~whoosh~ A small green figure appears nearby...", 5)
    } else {
        g.yoda.visible = false
        show_message("See you later I will.", 4)
    }
}
update_batarang_toggle :: proc() {
    if !rl.IsKeyPressed(.SEVEN) { return }
    if !g.inv_batarang {
        show_message("Someone said to talk to Bruce? Which one?")
        return
    }
    g.batarang_active = !g.batarang_active
    if g.batarang_active {
        show_message("The Dark Knight of Honeyville.", 4)
    } else {
        show_message("Time to farm.", 3)
    }
}
update_bee_cam_toggle :: proc() {
    if !rl.IsKeyPressed(.SIX) { return }
    if g.in_car {
        show_message("Now isn't the time for bee business!")
        return
    }
    g.bee_cam_active = !g.bee_cam_active
    if g.bee_cam_active {
        g.bee_cam_return_pos  = g.player.pos
        g.bee_cam_pos         = g.player.pos
        g.bee_cam_angle       = 0
        g.bee_cam_anim_time   = 0
        g.bee_cam_prev_target = g.camera.target
        g.bee_cam_prev_zoom   = g.camera.zoom
        show_message("Bzzzt! You are now a bee!", 4)
    } else {
        g.player.pos    = g.bee_cam_return_pos
        g.camera.target = g.bee_cam_prev_target
        g.camera.zoom    = g.bee_cam_prev_zoom
        show_message("exit", 2)
    }
}
update_phone_toggle :: proc() {
    if rl.IsKeyPressed(.SPACE) {
        g.phone_open = !g.phone_open
        if g.phone_open {
            g.phone_cursor  = 0
            g.phone_screen  = .Home
        }
    }
}

update_phone_menu :: proc() {
    if !g.phone_open { return }
    switch g.phone_screen {
    case .Home:          update_phone_home()
    case .Contacts:       update_phone_contacts()
    case .ContactDetail:  update_phone_contact_detail()
    case .Help:           update_phone_help()
    case .BuzzyBee:     update_buzzy_bee()
    }
}

update_phone_home :: proc() {
    if rl.IsKeyPressed(.DOWN) { g.phone_cursor = (g.phone_cursor + 1) % PHONE_APP_COUNT }
    if rl.IsKeyPressed(.UP)   { g.phone_cursor = (g.phone_cursor - 1 + PHONE_APP_COUNT) % PHONE_APP_COUNT }
    if rl.IsKeyPressed(.ENTER) || rl.IsKeyPressed(.KP_ENTER) {
        switch g.phone_cursor {
        case 0:
            g.phone_screen         = .Contacts
            g.phone_contact_cursor = 0
        case 1: g.inventory_open	= true; g.phone_open = false
        case 2: g.album_open		= true; g.phone_open = false
        case 3: g.discovered_open	= true; g.phone_open = false
        case 4: g.achievements_open	= true; g.phone_open = false
        case 5: g.stats_open		= true; g.phone_open = false
	case 6: g.phone_screen		= .Help
	case 7:
	    g.phone_screen       = .BuzzyBee
	    g.buzzy.started     = false
	    g.buzzy.game_over   = false

        }
    }
}
update_phone_help :: proc() {
    max_visible := 12
    max_scroll := max(0, len(HELP_LINES) - max_visible)
    if rl.IsKeyPressed(.DOWN) { g.phone_help_scroll = min(g.phone_help_scroll + 1, max_scroll) }
    if rl.IsKeyPressed(.UP)   { g.phone_help_scroll = max(g.phone_help_scroll - 1, 0) }
    if rl.IsKeyPressed(.BACKSPACE) {
        g.phone_screen = .Home
        g.phone_help_scroll = 0
    }
}

update_phone_contacts :: proc() {
    met := make([dynamic]int, context.temp_allocator)
    for i in 0..<NPC_COUNT {
        if g.npc_met[i] { append(&met, i) }
    }
    if rl.IsKeyPressed(.BACKSPACE) { g.phone_screen = .Home; return }
    if len(met) == 0 { return }

    if rl.IsKeyPressed(.DOWN) { g.phone_contact_cursor = (g.phone_contact_cursor + 1) % len(met) }
    if rl.IsKeyPressed(.UP)   { g.phone_contact_cursor = (g.phone_contact_cursor - 1 + len(met)) % len(met) }
    if rl.IsKeyPressed(.ENTER) || rl.IsKeyPressed(.KP_ENTER) {
        g.selected_contact   = met[g.phone_contact_cursor]
        g.phone_last_message = ""
        g.phone_screen       = .ContactDetail
    }
}

update_phone_contact_detail :: proc() {
    if rl.IsKeyPressed(.BACKSPACE) {
        g.phone_screen       = .Contacts
        g.phone_last_message = ""
        return
    }
    if rl.IsKeyPressed(.ENTER) || rl.IsKeyPressed(.KP_ENTER) {
        npc := g.npcs[g.selected_contact]
        idx := int(rand_f32(0, 2.999))
        g.phone_last_message = npc.dialogue[idx]
    }
}
update_buzzy_bee :: proc() {
    if rl.IsKeyPressed(.BACKSPACE) {
        g.phone_screen = .Home
        return
    }

    fb := &g.buzzy
    flap_pressed := rl.IsKeyPressed(.LEFT_SHIFT) || rl.IsKeyPressed(.RIGHT_SHIFT)

    if !fb.started {
        if flap_pressed {
            fb.started     = true
            fb.game_over   = false
            fb.buzzybee_y      = BUZZY_PLAY_H / 2
            fb.buzzybee_vel    = BUZZY_FLAP_VEL
            fb.score       = 0
            fb.spawn_timer = 0
            clear(&fb.pipes)
            append(&fb.pipes, BuzzyPipe{x = BUZZY_PLAY_W - 10, gap_y = BUZZY_PLAY_H / 2})
        }
        return
    }

    if fb.game_over {
        if flap_pressed { fb.started = false }
        return
    }

    dt := g.dt
    if flap_pressed { fb.buzzybee_vel = BUZZY_FLAP_VEL }

    fb.buzzybee_vel += BUZZY_GRAVITY * dt
    fb.buzzybee_y   += fb.buzzybee_vel * dt

    for i in 0..<len(fb.pipes) {
        fb.pipes[i].x -= BUZZY_PIPE_SPEED * dt
    }

    fb.spawn_timer -= dt
    if fb.spawn_timer <= 0 {
        fb.spawn_timer = BUZZY_PIPE_SPACING / BUZZY_PIPE_SPEED
        last_x := BUZZY_PLAY_W
        if len(fb.pipes) > 0 { last_x = fb.pipes[len(fb.pipes)-1].x }
        append(&fb.pipes, BuzzyPipe{
            x     = last_x + BUZZY_PIPE_SPACING,
            gap_y = rand_f32(BUZZY_PIPE_GAP, BUZZY_PLAY_H - BUZZY_GROUND_H - BUZZY_PIPE_GAP),
        })
    }

    for i := 0; i < len(fb.pipes); {
        if fb.pipes[i].x < -BUZZY_PIPE_W {
            ordered_remove(&fb.pipes, i)
            continue
        }
        i += 1
    }

    for i in 0..<len(fb.pipes) {
        p := &fb.pipes[i]
        if !p.passed && p.x + BUZZY_PIPE_W < BUZZY_BEE_X {
            p.passed = true
            fb.score += 1
        }
    }

    if fb.buzzybee_y - BUZZY_BEE_SIZE/2 < 0 || fb.buzzybee_y + BUZZY_BEE_SIZE/2 > BUZZY_PLAY_H - BUZZY_GROUND_H {
        end_buzzy_run()
    }

    for p in fb.pipes {
        if BUZZY_BEE_X + BUZZY_BEE_SIZE/2 > p.x && BUZZY_BEE_X - BUZZY_BEE_SIZE/2 < p.x + BUZZY_PIPE_W {
            if fb.buzzybee_y - BUZZY_BEE_SIZE/2 < p.gap_y - BUZZY_PIPE_GAP/2 ||
               fb.buzzybee_y + BUZZY_BEE_SIZE/2 > p.gap_y + BUZZY_PIPE_GAP/2 {
                end_buzzy_run()
            }
        }
    }
}

end_buzzy_run :: proc() {
    fb := &g.buzzy
    fb.game_over = true
    if fb.score > fb.high_score { fb.high_score = fb.score }
}

update_weather_toggle :: proc() {
    if g.save_rename_slot >= 0 { return }
    if rl.IsKeyPressed(.FOUR) {
        g.weather_menu_open = !g.weather_menu_open
    }
}

update_weather_menu :: proc() {
    if !g.weather_menu_open { return }
    if rl.IsKeyPressed(.ENTER) || rl.IsKeyPressed(.KP_ENTER) || rl.IsKeyPressed(.ESCAPE) {
        g.weather_menu_open = false
    }
}


update_bee_cam :: proc() {
    if !g.bee_cam_active { return }
    dt := g.dt
    g.bee_cam_anim_time += dt * BEE_CAM_BOB_FREQ

    vel: Vec2
    if rl.IsKeyDown(.W) { vel.y -= 1 }
    if rl.IsKeyDown(.S) { vel.y += 1 }
    if rl.IsKeyDown(.A) { vel.x -= 1 }
    if rl.IsKeyDown(.D) { vel.x += 1 }

    l := math.sqrt(vel.x*vel.x + vel.y*vel.y)
    if l > 0 {
        vel.x = vel.x/l * BEE_CAM_SPEED
        vel.y = vel.y/l * BEE_CAM_SPEED
        g.bee_cam_angle = math.atan2(vel.y, vel.x) * 180.0 / math.PI
    }

    g.bee_cam_pos.x += vel.x * dt
    g.bee_cam_pos.y += vel.y * dt
}

update_bee_cam_camera :: proc() {
    if !g.bee_cam_active { return }
    dt  := g.dt
    bob := math.sin(g.bee_cam_anim_time) * BEE_CAM_BOB_AMP

    g.camera.zoom += (BEE_CAM_ZOOM - g.camera.zoom) * 6 * dt
    g.camera.target.x += (g.bee_cam_pos.x - g.camera.target.x) * 12 * dt
    g.camera.target.y += (g.bee_cam_pos.y + bob - g.camera.target.y) * 12 * dt
}
update_player_zoom_toggle :: proc() {
    if g.save_rename_slot >= 0 { return }
    if !rl.IsKeyPressed(.Z) { return }

    if g.bee_cam_active {
        show_message("Exit bee cam before using player zoom.", 4)
        return
    }

    g.player_zoom_active = !g.player_zoom_active
    if g.player_zoom_active {
        show_message("Zoomed in on player. Press Z to zoom out.", 4)
    } else {
        show_message("Camera zoom normal.", 4)
    }
}





update_car :: proc() {
    if !g.in_car || g.current_car < 0 { return }
    car := &g.cars[g.current_car]
    dt  := g.dt

    TURN_SPEED :: f32(140.0)
    if rl.IsKeyDown(.LEFT)  { car.angle -= TURN_SPEED * dt }
    if rl.IsKeyDown(.RIGHT) { car.angle += TURN_SPEED * dt }

    speed := f32(0)
    if rl.IsKeyDown(.UP)   { speed =  CAR_SPEED }
    if rl.IsKeyDown(.DOWN) { speed = -CAR_SPEED * 0.5 }

    if speed != 0 {
        rad     := car.angle * math.PI / 180.0
        new_pos := Vec2{
            car.pos.x + math.cos(rad) * speed * dt,
            car.pos.y + math.sin(rad) * speed * dt,
        }
        resolved := resolve_collision(new_pos)
        car.pos   = resolved
    }
    g.player.pos = car.pos
}
try_enter_exit_car :: proc() {
    if !rl.IsKeyPressed(.C) { return }

    if g.in_car {
        car := &g.cars[g.current_car]
        rad := car.angle * math.PI / 180.0
        g.player.pos = Vec2{
            car.pos.x - math.sin(rad) * 24,
            car.pos.y + math.cos(rad) * 24,
        }
        car.occupied  = false
        g.in_car      = false
        g.current_car = -1
	g.input_c_consumed = true
        show_message("sidewalks are now safe.", 4)
        return
    }

    best_dist := f32(CAR_ENTER_DIST)
    best_idx  := -1
    for i in 0..<MAX_CARS {
        c := &g.cars[i]
        if !c.owned || !c.active || c.occupied { continue }
        d := vec2_dist(g.player.pos, c.pos)
        if d < best_dist {
            best_dist = d
            best_idx  = i
        }
    }
    if best_idx >= 0 {
        g.cars[best_idx].occupied = true
        g.in_car      = true
        g.current_car = best_idx
	g.input_c_consumed = true
        show_message("*grabs road soadie*", 4)
    }
}
garage_slot_pos :: proc(slot: int) -> Vec2 {
    cols    := MAX_CARS
    start_x := -f32(cols-1) * GARAGE_SLOT_GAP / 2
    return Vec2{ start_x + f32(slot) * GARAGE_SLOT_GAP, -20 }
}

enter_garage :: proc() {
    car_idx := g.current_car
    if car_idx < 0 { return }

    g.prev_world_pos = g.player.pos

    car := &g.cars[car_idx]
    car.in_garage = true
    car.active    = false
    car.occupied  = false
    car.angle     = 0
    car.pos       = garage_slot_pos(car_idx)

    g.in_car      = false
    g.current_car = -1

    g.player.pos    = {0, GARAGE_INT_H/2 - 30}
    g.camera.target = g.player.pos
    g.state         = .GarageInterior
    show_message("Goodbye speed demon.", 6)
}
enter_garage_on_foot :: proc() {
    g.prev_world_pos = g.player.pos
    g.player.pos     = {0, GARAGE_INT_H/2 - 30}
    g.camera.target  = g.player.pos
    g.state          = .GarageInterior
    show_message("Goodbye hot shoes.", 3)
}
update_garage_interior :: proc() {
    if g.death_active { return }

    dt := g.dt
    rw, rh := GARAGE_INT_W, GARAGE_INT_H
    margin :: f32(10)

    vel: Vec2
    if rl.IsKeyDown(.W) { vel.y -= 1 }
    if rl.IsKeyDown(.S) { vel.y += 1 }
    if rl.IsKeyDown(.A) { vel.x -= 1 }
    if rl.IsKeyDown(.D) { vel.x += 1 }
    l := math.sqrt(vel.x*vel.x + vel.y*vel.y)
    if l > 0 { vel.x = vel.x/l * PLAYER_SPEED; vel.y = vel.y/l * PLAYER_SPEED }
    g.player.pos.x += vel.x * dt
    g.player.pos.y += vel.y * dt
    g.player.pos.x = clamp(g.player.pos.x, -rw/2 + margin, rw/2 - margin)
    g.player.pos.y = clamp(g.player.pos.y, -rh/2 + margin, rh/2 - margin)

    update_camera()

    // Drive a parked car back out
    if rl.IsKeyPressed(.E) {
        for i in 0..<MAX_CARS {
            c := &g.cars[i]
            if !c.owned || !c.in_garage { continue }
            if vec2_dist(g.player.pos, garage_slot_pos(i)) < INTERACT_DIST {
                c.in_garage = false
                c.active    = true
                c.occupied  = true
                c.angle     = 0
                c.pos       = { g.buildings[.Garage].door.x, g.buildings[.Garage].door.y + 30 }

                g.in_car        = true
                g.current_car   = i
                g.player.pos    = c.pos
                g.camera.target = g.player.pos
                g.state         = .World
                show_message("Vroom!", 3)
                return
            }
        }
    }

    leave_y := rh/2 - 20
    if g.player.pos.y > leave_y && rl.IsKeyPressed(.E) {
        g.player.pos    = g.prev_world_pos
        g.camera.target = g.player.pos
        g.state = .World
        return
    }
    if rl.IsKeyPressed(.ESCAPE) {
        g.player.pos    = g.prev_world_pos
        g.camera.target = g.player.pos
        g.state = .World
    }
}
update_car_customize_toggle :: proc() {
    if g.save_rename_slot >= 0 { return }
    if g.state != .GarageInterior { return }
    if !rl.IsKeyPressed(.O) { return }

    if !g.car_customize_open {
        start_idx := 0
        for i in 0..<MAX_CARS {
            if g.cars[i].owned { start_idx = i; break }
        }
        g.car_customize_car_idx   = start_idx
        g.car_customize_color_idx = find_palette_index(g.cars[start_idx].body_col)
        if g.car_customize_color_idx < 0 { g.car_customize_color_idx = 0 }
        g.backup_car_color_idx    = g.car_customize_color_idx
        g.car_customize_cursor    = 0
    }
    g.car_customize_open = !g.car_customize_open
}
update_farmers_market_interior :: proc() {
    if g.death_active { return }

    if g.market_menu_open { return }

    if rl.IsKeyPressed(.E) {
        g.state = .World
        g.player.pos = g.prev_world_pos
        g.camera.target = g.player.pos
        return
    }
    if rl.IsKeyPressed(.O) {
        g.market_menu_open = true
        g.market_menu_cursor = 0
    }
}
update_festival :: proc(dt: f32) {
    if g.festival_active {
        g.festival_timer -= dt
        if g.festival_timer <= 0 {
            end_festival()
            g.festival_cooldown = FESTIVAL_INTERVAL
        }
    } else {
        if g.festival_cooldown <= 0 && g.total_play_time < 1.0 {
            g.festival_cooldown = FESTIVAL_INTERVAL
        }
        g.festival_cooldown -= dt
        if g.festival_cooldown <= 0 {
            start_festival()
        }
    }
}

update_festival_npcs :: proc(dt: f32) {
    if !g.festival_active { return }
    for i in 0..<FESTIVAL_NPC_COUNT {
        npc := &g.festival_npcs[i]
        npc.timer -= dt
        if npc.timer <= 0 {
            npc.target = { rand_f32(PARK_X + 30, PARK_X + PARK_W - 30),
                           rand_f32(PARK_Y + 30, PARK_Y + PARK_H - 30) }
            npc.timer = rand_f32(2, 6)
        }
        dx := npc.target.x - npc.pos.x
        dy := npc.target.y - npc.pos.y
        dist := math.sqrt(dx*dx + dy*dy)
        if dist > 4 {
            npc.pos.x += (dx / dist) * NPC_SPEED * dt
            npc.pos.y += (dy / dist) * NPC_SPEED * dt
        }
    }
}




update_environment :: proc() {
    dt := g.dt

    g.day_time += dt
    if g.day_time >= DAY_DURATION {
        g.day_time -= DAY_DURATION
        apply_property_tax()
}
    day_frac := g.day_time / DAY_DURATION
    g.is_night = day_frac >= NIGHT_START

    g.season_time += dt
    if g.season_time >= SEASON_DURATION {
        g.season_time -= SEASON_DURATION
        switch g.season {
        case .Spring: g.season = .Summer;  show_message("The season has changed to Summer!", 5)
        case .Summer: g.season = .Fall;    show_message("The season has changed to Fall!", 5)
        case .Fall:   g.season = .Winter;  show_message("The season has changed to Winter!", 5)
        case .Winter: g.season = .Spring;  show_message("The season has changed to Spring!", 5)
        }
        push_honey_stock(honey_value_per_liter())
    }

    if g.rain_timer > 0 {
        g.rain_timer -= dt
        if g.rain_timer <= 0 {
            g.rain_timer = 0
            show_message("The rain has stopped.", 4)
            g.rain_cooldown = RAIN_INTERVAL + rand_f32(-120, 120)
	    g.weather_state_timer = 0
        }
    } else {
        g.rain_cooldown -= dt
        if g.rain_cooldown <= 0 {
            g.rain_timer    = RAIN_DURATION
            g.rain_cooldown = RAIN_INTERVAL
            show_message("A rain storm has started! Bees are sheltering.", 5)
	    g.weather_state_timer = 0
        }
    }
if g.auction_timer > 0 {
    g.auction_timer -= dt
    if g.auction_timer <= 0 {
        g.auction_timer = 0
        show_message("The Rare Honey Auction has ended.", 5)
        g.auction_cooldown = rand_f32(AUCTION_MIN_WAIT, AUCTION_MAX_WAIT)
    }
} else {
    g.auction_cooldown -= dt
    if g.auction_cooldown <= 0 {
        g.auction_timer    = AUCTION_DURATION
        g.auction_cooldown = rand_f32(AUCTION_MIN_WAIT, AUCTION_MAX_WAIT)
        push_honey_stock(honey_value_per_liter() * AUCTION_MULT)
        show_message("Rare Honey Auction at the Bank! Honey is worth 5x!", 6)
    }
}

}

update_bee_boxes :: proc() {
    if net_state.role == .Client { return } // host (or singleplayer) is sole authority on honey accrual
    dt := g.dt
    for i in 0..<len(g.bee_boxes) {
        box := &g.bee_boxes[i]
        if !box.active || box.on_plot < 0 { continue }
        if !g.plots[box.on_plot].owner_is_player { continue }
        mult         := honey_production_multiplier_for_plot(box.on_plot) * queen_bee_multiplier(box.queen_tier)
        produced     := f32(box.bee_count) * dt * mult
        before       := box.honey_ml
        box.honey_ml  = min(box.honey_ml + produced, box.capacity)
        g.total_honey_produced_ml += (box.honey_ml - before)
    }
}

update_factory_indoor_box :: proc() {
    if !g.fbf_indoor_owned { return }
    dt := g.dt
    if g.fbf_indoor_honey_ml < FACTORY_INDOOR_BOX_CAPACITY {
        g.fbf_indoor_honey_ml += FACTORY_INDOOR_BOX_RATE * dt
        if g.fbf_indoor_honey_ml > FACTORY_INDOOR_BOX_CAPACITY {
            g.fbf_indoor_honey_ml = FACTORY_INDOOR_BOX_CAPACITY
        }
    }
}

update_stats_toggle :: proc() {
    if rl.IsKeyPressed(.F4) {
        g.stats_open = !g.stats_open
    }
}

update_stats_menu :: proc() {
    if !g.stats_open { return }
    if rl.IsKeyPressed(.ENTER) || rl.IsKeyPressed(.KP_ENTER) || rl.IsKeyPressed(.ESCAPE) {
        g.stats_open = false
    }
}


update_lightning_bugs :: proc() {
    if !g.is_night { return }
    dt := g.dt
    for i in 0..<LIGHTNING_BUG_COUNT {
        bug := &g.lightning_bugs[i]

        bug.flash_time += dt

        bug.timer -= dt
        if bug.timer <= 0 {
            bug.target = Vec2{
                bug.pos.x + rand_f32(-120, 120),
                bug.pos.y + rand_f32(-80,   80),
            }
            bug.target.x = clamp(bug.target.x, -2580, 2580)
            bug.target.y = clamp(bug.target.y, -2580, 2580)
            if bug.target.x > -640 && bug.target.x < 640 &&
               bug.target.y > -640 && bug.target.y < 640 {
                bug.target.x += 700 * (1 if bug.target.x >= 0 else -1)
            }
            bug.timer = rand_f32(2, 7)
        }

        dir := Vec2{bug.target.x - bug.pos.x, bug.target.y - bug.pos.y}
        d   := math.sqrt(dir.x*dir.x + dir.y*dir.y)
        if d > 2 {
            bug.pos.x += (dir.x / d) * LIGHTNING_BUG_SPEED * dt
            bug.pos.y += (dir.y / d) * LIGHTNING_BUG_SPEED * dt
        }
    }
}
update_lightning_bug_catching :: proc() {
    if !g.bee_net_active || !g.is_night { return }
    if g.inv_lantern { return }

    for &bug in g.lightning_bugs {
        if vec2_dist(g.player.pos, bug.pos) < LANTERN_CATCH_DIST {
            bug.pos = Vec2{bug.pos.x + rand_f32(-400,400), bug.pos.y + rand_f32(-400,400)}
            g.lightning_bugs_caught += 1
            show_message(fmt.aprintf("Caught a lightning bug! (%d/%d)",
                g.lightning_bugs_caught, LANTERN_BUGS_REQUIRED, allocator = context.temp_allocator), 2)

            if g.lightning_bugs_caught >= LANTERN_BUGS_REQUIRED {
                g.inv_lantern = true
                show_message("You collected enough to craft a Lantern! [9] to toggle it.", 5)
            }
            break
        }
    }
}

update_soccer :: proc() {
    sg := &g.soccer
    dt := g.dt
    fw := SOCCER_FIELD_W
    fh := SOCCER_FIELD_H
    fx := SOCCER_FIELD_X
    fy := SOCCER_FIELD_Y
    wall :: f32(8)

    if sg.state == .Idle {
        dist := vec2_dist(g.player.pos, sg.npc.pos)
        if dist < SOCCER_CHALLENGE_DIST && rl.IsKeyPressed(.C) {
	    g.input_c_consumed = true
            sg.state        = .Playing
            sg.player_score = 0
            sg.npc_score    = 0
            sg.ball.pos = {fx + fw/2, fy + fh/2}
            sg.ball.vel = {0, 0}
            g.player.pos = {fx + fw*0.25, fy + fh/2}
            sg.npc.pos   = {fx + fw*0.75, fy + fh/2}
            show_message("Soccer match started! First to 3 goals wins! [H] for help", 4.0)
	    unlock_achievement(ACH_CHALLENGED_MESSY)
        }
        return
    }

    if rl.IsKeyPressed(.H) { sg.show_help = !sg.show_help }

    if sg.state == .GoalFlash {
        sg.goal_flash_time -= dt
        if sg.goal_flash_time <= 0 {
            if sg.player_score >= SOCCER_GOALS_TO_WIN || sg.npc_score >= SOCCER_GOALS_TO_WIN {
                sg.state = .GameOver
                sg.game_over_timer = 5.0
                if sg.player_score >= SOCCER_GOALS_TO_WIN {
                    g.player.money += 2000
                    show_message("YOU WIN! +$2000", 5.0)
                } else {
                    g.player.money -= 1000
                    show_message("BOOOO! -$1000", 5.0)
                }
            } else {
                sg.state     = .Playing
                sg.ball.pos  = {fx + fw/2, fy + fh/2}
                sg.ball.vel  = {0, 0}
                g.player.pos = {fx + fw*0.12, fy + fh/2}
                sg.npc.pos   = {fx + fw*0.75, fy + fh/2}
            }
        }
        return
    }

    if sg.state == .GameOver {
        sg.game_over_timer -= dt
        if sg.game_over_timer <= 0 {
            sg.state = .Idle
            g.player.pos = {fx + fw/2, fy + fh + 30}
        }
        return
    }

    move := Vec2{0, 0}
    if rl.IsKeyDown(.W) || rl.IsKeyDown(.UP)    { move.y -= 1 }
    if rl.IsKeyDown(.S) || rl.IsKeyDown(.DOWN)  { move.y += 1 }
    if rl.IsKeyDown(.A) || rl.IsKeyDown(.LEFT)  { move.x -= 1 }
    if rl.IsKeyDown(.D) || rl.IsKeyDown(.RIGHT) { move.x += 1 }
    mlen := math.sqrt(move.x*move.x + move.y*move.y)
    if mlen > 0 {
        move.x /= mlen; move.y /= mlen
        g.player.pos.x += move.x * PLAYER_SPEED * dt
        g.player.pos.y += move.y * PLAYER_SPEED * dt
    }

    pr :: f32(8)
    g.player.pos.x = clamp(g.player.pos.x, fx + wall + pr, fx + fw - wall - pr)
    g.player.pos.y = clamp(g.player.pos.y, fy + wall + pr, fy + fh - wall - pr)

    // Slide tackle
    if rl.IsKeyPressed(.X) {
        dist_to_ball := vec2_dist(g.player.pos, sg.ball.pos)
        if dist_to_ball < SOCCER_TACKLE_DIST {
            dir := Vec2{sg.ball.pos.x - sg.npc.pos.x, sg.ball.pos.y - sg.npc.pos.y}
            dl  := math.sqrt(dir.x*dir.x + dir.y*dir.y)
            if dl < 1 { dl = 1 }
            sg.ball.vel.x = (dir.x / dl) * SOCCER_KICK_FORCE * 1.4
            sg.ball.vel.y = (dir.y / dl) * SOCCER_KICK_FORCE * 1.4
            sg.npc.frozen = 1.5
            show_message("Slide tackle!", 1.5)
        }
    }

    dist_to_ball := vec2_dist(g.player.pos, sg.ball.pos)
    if dist_to_ball < SOCCER_BALL_RADIUS + 10 {
        dir := Vec2{sg.ball.pos.x - g.player.pos.x, sg.ball.pos.y - g.player.pos.y}
        dl  := math.sqrt(dir.x*dir.x + dir.y*dir.y)
        if dl < 1 { dl = 1 }
        sg.ball.vel.x += (dir.x / dl) * SOCCER_KICK_FORCE
        sg.ball.vel.y += (dir.y / dl) * SOCCER_KICK_FORCE
        sg.ball.pos.x = g.player.pos.x + (dir.x / dl) * 20
        sg.ball.pos.y = g.player.pos.y + (dir.y / dl) * 20
    }

    if sg.npc.frozen > 0 {
        sg.npc.frozen -= dt
    } else {
	npc_target := sg.ball.pos
        predicted := Vec2{
	    sg.ball.pos.x + sg.ball.vel.x * 0.25,
	    sg.ball.pos.y + sg.ball.vel.y * 0.25,
	}

        sg.npc.timer -= dt
        if sg.npc.timer <= 0 {
            npc_target.x += rand_f32(-8, 8)
            npc_target.y += rand_f32(-8, 8)
            sg.npc.target = predicted
            sg.npc.timer  = rand_f32(0.3, 0.18)
        }
        ndir := Vec2{sg.npc.target.x - sg.npc.pos.x, sg.npc.target.y - sg.npc.pos.y}
        nd   := math.sqrt(ndir.x*ndir.x + ndir.y*ndir.y)
        if nd > 2 {
            sg.npc.pos.x += (ndir.x / nd) * SOCCER_NPC_SPEED * dt
            sg.npc.pos.y += (ndir.y / nd) * SOCCER_NPC_SPEED * dt
        }
        sg.npc.pos.x = clamp(sg.npc.pos.x, fx + wall + pr, fx + fw - wall - pr)
        sg.npc.pos.y = clamp(sg.npc.pos.y, fy + wall + pr, fy + fh - wall - pr)

        dist_npc_ball := vec2_dist(sg.npc.pos, sg.ball.pos)
        if dist_npc_ball < SOCCER_BALL_RADIUS + 10 {
            goal_center := Vec2{fx + wall, fy + fh/2}
            kdir := Vec2{goal_center.x - sg.ball.pos.x, goal_center.y - sg.ball.pos.y}
            kd   := math.sqrt(kdir.x*kdir.x + kdir.y*kdir.y)
            if kd < 1 { kd = 1 }
            sg.ball.vel.x += (kdir.x / kd) * SOCCER_KICK_FORCE * 0.9
            sg.ball.vel.y += (kdir.y / kd) * SOCCER_KICK_FORCE * 0.9
        }
    }

    sg.ball.bob_time += dt

    sg.ball.pos.x += sg.ball.vel.x * dt
    sg.ball.pos.y += sg.ball.vel.y * dt
    sg.ball.vel.x *= math.pow(SOCCER_FRICTION, dt * 60)
    sg.ball.vel.y *= math.pow(SOCCER_FRICTION, dt * 60)

    br := SOCCER_BALL_RADIUS

    if sg.ball.pos.x - br < fx + wall &&
       sg.ball.pos.y > sg.goal_left_y1 &&
       sg.ball.pos.y < sg.goal_left_y2 {
        sg.npc_score += 1
        sg.last_scorer = 1
        sg.state = .GoalFlash
        sg.goal_flash_time = 2.0
        show_message(fmt.aprintf("MESSY scores! %d - %d", sg.player_score, sg.npc_score), 2.0)
        return
    }
    if sg.ball.pos.x + br > fx + fw - wall &&
       sg.ball.pos.y > sg.goal_right_y1 &&
       sg.ball.pos.y < sg.goal_right_y2 {
        sg.player_score += 1
        sg.last_scorer = 0
        sg.state = .GoalFlash
        sg.goal_flash_time = 2.0
        show_message(fmt.aprintf("GOAL! %d - %d", sg.player_score, sg.npc_score), 2.0)
        return
    }

    if sg.ball.pos.y - br < fy + wall {
        sg.ball.pos.y = fy + wall + br
        sg.ball.vel.y = -sg.ball.vel.y * SOCCER_BOUNCE
    }
    if sg.ball.pos.y + br > fy + fh - wall {
        sg.ball.pos.y = fy + fh - wall - br
        sg.ball.vel.y = -sg.ball.vel.y * SOCCER_BOUNCE
    }
    if sg.ball.pos.x - br < fx + wall {
        if sg.ball.pos.y < sg.goal_left_y1 || sg.ball.pos.y > sg.goal_left_y2 {
            sg.ball.pos.x = fx + wall + br
            sg.ball.vel.x = -sg.ball.vel.x * SOCCER_BOUNCE
        }
    }
    if sg.ball.pos.x + br > fx + fw - wall {
        if sg.ball.pos.y < sg.goal_right_y1 || sg.ball.pos.y > sg.goal_right_y2 {
            sg.ball.pos.x = fx + fw - wall - br
            sg.ball.vel.x = -sg.ball.vel.x * SOCCER_BOUNCE
        }
    }
}
update_animals :: proc() {
    dt := g.dt

    for i in 0..<ANIMAL_COUNT {
        a := &g.animals[i]
        a.anim_time += dt * 6.0

        if a.is_idle {
            a.idle_time -= dt
            if a.idle_time <= 0 {
                a.is_idle = false
                a.timer   = rand_f32(3, 9)
                a.target = Vec2{
                    a.pos.x + rand_f32(-180, 180),
                    a.pos.y + rand_f32(-120, 120),
                }
                a.target.x = clamp(a.target.x, -2380, 2380)
                a.target.y = clamp(a.target.y, -2380, 2380)
                if a.target.x > -720 && a.target.x < 720 &&
                   a.target.y > -720 && a.target.y < 720 {
                    a.target.x += 800 * (1 if a.target.x >= 0 else -1)
                }
            }
            continue
        }

        a.timer -= dt
        if a.timer <= 0 {
            if rand_int(0, 3) == 0 {
                a.is_idle   = true
                a.idle_time = rand_f32(1.0, 3.5)
            } else {
                a.target = Vec2{
                    a.pos.x + rand_f32(-200, 200),
                    a.pos.y + rand_f32(-150, 150),
                }
                a.target.x = clamp(a.target.x, -2380, 2380)
                a.target.y = clamp(a.target.y, -2380, 2380)
                if a.target.x > -720 && a.target.x < 720 &&
                   a.target.y > -720 && a.target.y < 720 {
                    a.target.x += 800 * (1 if a.target.x >= 0 else -1)
                }
                a.timer = rand_f32(3, 9)
            }
        }

        dir := Vec2{a.target.x - a.pos.x, a.target.y - a.pos.y}
        d   := math.sqrt(dir.x*dir.x + dir.y*dir.y)
        if d > 4 {
            spd := ANIMAL_WANDER_SPEED
            if a.kind == .Butterfly { spd = 22 }
            if a.kind == .Deer      { spd = 34 }
            a.pos.x += (dir.x / d) * spd * dt
            a.pos.y += (dir.y / d) * spd * dt
        }
    }
}
update_birds :: proc() {
    dt := g.dt
    margin :: f32(30)
    lo_x := PARK_X + margin;          hi_x := PARK_X + PARK_W - margin
    lo_y := PARK_Y + margin;          hi_y := PARK_Y + PARK_H - margin

    for i in 0..<BIRD_COUNT {
        b := &g.birds[i]
        b.anim_time += dt * 6.0

        if b.is_idle {
            b.idle_time -= dt
            if b.idle_time <= 0 {
                b.is_idle = false
                b.timer   = rand_f32(2, 5)
                b.target  = {rand_f32(lo_x, hi_x), rand_f32(lo_y, hi_y)}
            }
            continue
        }

        b.timer -= dt
        if b.timer <= 0 {
            if rand_int(0, 3) == 0 {
                b.is_idle   = true
                b.idle_time = rand_f32(1.5, 4.0)
            } else {
                b.target = {rand_f32(lo_x, hi_x), rand_f32(lo_y, hi_y)}
                b.timer  = rand_f32(2, 6)
            }
        }

        dir := Vec2{b.target.x - b.pos.x, b.target.y - b.pos.y}
        d   := math.sqrt(dir.x*dir.x + dir.y*dir.y)
        if d > 3 {
            b.pos.x += (dir.x/d) * BIRD_SPEED * dt
            b.pos.y += (dir.y/d) * BIRD_SPEED * dt
        }
    }
}
spawn_bee_swarm :: proc() {
    angle := rand_f32(0, 6.2831853)
    dist  := rand_f32(650, 950)
    x := math.cos(angle) * dist
    y := math.sin(angle) * dist
    g.bee_swarm.pos          = {x, y}
    g.bee_swarm.target       = {x + rand_f32(-100, 100), y + rand_f32(-100, 100)}
    g.bee_swarm.active       = true
    g.bee_swarm.wander_timer = rand_f32(2, 5)
    g.bee_swarm.life_timer   = BEE_SWARM_LIFETIME
    g.bee_swarm.anim_time    = 0
    show_message("A wild bee swarm is nearby! Equip your Bee Net [0] and catch it!", 4)
}

update_bee_swarm :: proc() {
    dt := g.dt

    if !g.bee_swarm.active {
        g.bee_swarm.spawn_cooldown -= dt
        if g.bee_swarm.spawn_cooldown <= 0 {
            spawn_bee_swarm()
            g.bee_swarm.spawn_cooldown = rand_f32(BEE_SWARM_SPAWN_MIN_WAIT, BEE_SWARM_SPAWN_MAX_WAIT)
        }
        return
    }

    sw := &g.bee_swarm
    sw.anim_time += dt * 6.0

    sw.life_timer -= dt
    if sw.life_timer <= 0 {
        sw.active = false
        show_message("The wild bee swarm flew away...", 3)
        return
    }

    sw.wander_timer -= dt
    if sw.wander_timer <= 0 {
        sw.target = Vec2{
            sw.pos.x + rand_f32(-120, 120),
            sw.pos.y + rand_f32(-120, 120),
        }
        sw.wander_timer = rand_f32(2, 5)
    }
    dir := Vec2{sw.target.x - sw.pos.x, sw.target.y - sw.pos.y}
    d   := math.sqrt(dir.x*dir.x + dir.y*dir.y)
    if d > 3 {
        sw.pos.x += (dir.x/d) * BEE_SWARM_SPEED * dt
        sw.pos.y += (dir.y/d) * BEE_SWARM_SPEED * dt
    }

    if g.bee_net_active {
        if vec2_dist(g.player.pos, sw.pos) < BEE_SWARM_CATCH_DIST {
            sw.active          = false
            g.player.honey_ml += BEE_SWARM_REWARD_ML
            show_message(fmt.aprintf("Caught the wild bee swarm! +%.0f ml of honey!",
                BEE_SWARM_REWARD_ML, allocator = context.temp_allocator), 4)
        }
    }
}
phone_time_string :: proc() -> string {
    day_frac := g.day_time / DAY_DURATION
    total_minutes := i32(day_frac * 24.0 * 60.0)
    hour   := (total_minutes / 60) % 24
    minute := total_minutes % 60

    display_hour := hour % 12
    if display_hour == 0 { display_hour = 12 }
    suffix := "AM" if hour < 12 else "PM"

    return fmt.aprintf("%02d:%02d %s", display_hour, minute, suffix, allocator = context.temp_allocator)
}

PHONE_APP_ICON_COLORS := [PHONE_APP_COUNT]rl.Color{
    {90, 170, 230, 255},   // contacts   - blue
    {90, 200, 110, 255},   // inventory       - green
    {230, 160, 60, 255},   // photo album     - amber
    {170, 110, 220, 255},  // discovered - purple
    {240, 200, 50, 255},   // achievements - gold
    {90, 210, 200, 255},   // stats      - teal
    {220, 90, 90, 255},   // help menu
    {255, 210, 40, 255}, // Buzzy Bee
}
draw_contact_portrait :: proc(x, y, size: f32, npc: NPC) {
    rl.DrawRectangle(pxi(x)-2, pxi(y)-2, pxi(size)+4, pxi(size)+4, {60,40,20,255})
    rl.DrawRectangleLinesEx({x, y, size, size}, 1, COL_HONEY2)

    cx := x + size/2
    cy := y + size/2 + size*0.40

    rl.BeginScissorMode(pxi(x), pxi(y), pxi(size), pxi(size))
    draw_npc_icon(npc, cx, cy)
    rl.EndScissorMode()
}


draw_phone_contacts :: proc(sx, sy, sw, sh: f32) {
    met := make([dynamic]int, context.temp_allocator)
    for i in 0..<NPC_COUNT {
        if g.npc_met[i] { append(&met, i) }
    }

    if len(met) == 0 {
        rl.DrawText("No contacts yet.", pxi(sx)+6, pxi(sy)+30, 7, COL_TEXT)
        rl.DrawText("Talk to NPCs to add them!", pxi(sx)+6, pxi(sy)+42, 6, rl.Color{150,150,150,255})
    } else {
        row_h    := f32(22)
        list_top := sy + 18
        for row in 0..<len(met) {
            idx      := met[row]
            npc      := g.npcs[idx]
            row_y    := list_top + f32(row) * row_h
            selected := (row == g.phone_contact_cursor)

            if selected {
                rl.DrawRectangle(pxi(sx)+2, pxi(row_y)-2, pxi(sw)-4, pxi(row_h)-4, rl.Color{60,60,40,200})
            }
            draw_contact_portrait(sx+6, row_y, 14, npc)
            label_col := COL_HONEY if selected else COL_TEXT
            label := strings.clone_to_cstring(npc.name, context.temp_allocator)
            rl.DrawText(label, pxi(sx)+6+20, pxi(row_y)+3, 7, label_col)
        }
    }
}

draw_phone_contact_detail :: proc(sx, sy, sw, sh: f32) {
    npc := g.npcs[g.selected_contact]

    portrait_y := sy + 16
    draw_contact_portrait(sx + sw/2 - 18, portrait_y, 36, npc)

    bar_y := portrait_y + 36 + 6
    bar_w := sw - 16
    rl.DrawRectangle(pxi(sx)+8, pxi(bar_y), pxi(bar_w), 6, rl.Color{50,50,50,255})

    tier := npc_relationship_tier(g.selected_contact)
    tier_col := RELATIONSHIP_TIER_COLORS[tier]
    fill_w := bar_w * (g.npc_relationship[g.selected_contact] / RELATIONSHIP_MAX)
    rl.DrawRectangle(pxi(sx)+8, pxi(bar_y), pxi(fill_w), 6, tier_col)

    tier_label_y := bar_y + 6 + 2
    tier_name := RELATIONSHIP_TIER_NAMES[tier]
    tier_c := strings.clone_to_cstring(tier_name, context.temp_allocator)
    rl.DrawText(tier_c, pxi(sx)+8, pxi(tier_label_y), 6, tier_col)

    msg_y := tier_label_y + 10
    if g.phone_last_message == "" {
        rl.DrawText("ENTER to message...", pxi(sx)+6, pxi(msg_y), 6, rl.Color{150,150,150,255})
    } else {
        for line, li in wrap_text_lines(g.phone_last_message, 6, sw - 12) {
            line_c := strings.clone_to_cstring(line, context.temp_allocator)
            rl.DrawText(line_c, pxi(sx)+6, pxi(msg_y) + i32(li)*10, 6, COL_TEXT)
        }
    }
}
draw_buzzy_bee :: proc(sx, sy, sw, sh: f32) {
    fb := &g.buzzy
    play_x := sx + 4
    play_y := sy + 16

    rl.BeginScissorMode(pxi(play_x), pxi(play_y), pxi(BUZZY_PLAY_W), pxi(BUZZY_PLAY_H))

    rl.DrawRectangle(pxi(play_x), pxi(play_y), pxi(BUZZY_PLAY_W), pxi(BUZZY_PLAY_H), rl.Color{90, 200, 250, 255})
    rl.DrawCircle(pxi(play_x + BUZZY_PLAY_W - 16), pxi(play_y + 14), 8, rl.Color{255, 235, 80, 255})

    ground_y := play_y + BUZZY_PLAY_H - BUZZY_GROUND_H
    rl.DrawRectangle(pxi(play_x), pxi(ground_y), pxi(BUZZY_PLAY_W), pxi(BUZZY_GROUND_H), rl.Color{90, 210, 90, 255})
    rl.DrawRectangle(pxi(play_x), pxi(ground_y), pxi(BUZZY_PLAY_W), 2, rl.Color{60, 170, 60, 255})

    for p in fb.pipes {
        top_h := p.gap_y - BUZZY_PIPE_GAP/2
        bot_y := p.gap_y + BUZZY_PIPE_GAP/2
        bot_h := (BUZZY_PLAY_H - BUZZY_GROUND_H) - bot_y
        pxs   := play_x + p.x

        rl.DrawRectangle(pxi(pxs), pxi(play_y), pxi(BUZZY_PIPE_W), pxi(top_h), rl.Color{60, 220, 90, 255})
        rl.DrawRectangle(pxi(pxs), pxi(play_y) + pxi(top_h) - 3, pxi(BUZZY_PIPE_W), 3, rl.Color{30, 180, 60, 255})
        rl.DrawRectangle(pxi(pxs), pxi(play_y + bot_y), pxi(BUZZY_PIPE_W), pxi(bot_h), rl.Color{60, 220, 90, 255})
        rl.DrawRectangle(pxi(pxs), pxi(play_y + bot_y), pxi(BUZZY_PIPE_W), 3, rl.Color{30, 180, 60, 255})
    }

    bx := play_x + BUZZY_BEE_X
    by := play_y + fb.buzzybee_y
    tilt := clamp(fb.buzzybee_vel * 0.05, -25, 45)

    wing_lift := math.sin(fb.wing_timer) * 3

    rl.DrawEllipse(pxi(bx)-1, pxi(by)-3-i32(wing_lift), 5, 3, rl.Color{220, 240, 255, 200})

    rl.DrawCircle(pxi(bx), pxi(by), BUZZY_BEE_SIZE/2+1, rl.Color{255, 205, 30, 255})

    rl.DrawRectangle(pxi(bx)-4, pxi(by)-4, 2, 8, rl.BLACK)
    rl.DrawRectangle(pxi(bx),   pxi(by)-4, 2, 8, rl.BLACK)
    rl.DrawRectangle(pxi(bx)+3, pxi(by)-3, 2, 6, rl.BLACK)

    rl.DrawEllipse(pxi(bx)+1, pxi(by)-3+i32(wing_lift), 5, 3, rl.Color{240, 250, 255, 220})
    rl.DrawEllipseLines(pxi(bx)+1, pxi(by)-3+i32(wing_lift), 5, 3, rl.Color{200, 220, 240, 255})

    rl.DrawLine(pxi(bx)-1, pxi(by)-5, pxi(bx)-3, pxi(by)-8, rl.BLACK)
    rl.DrawLine(pxi(bx)+1, pxi(by)-5, pxi(bx)+3, pxi(by)-8, rl.BLACK)
    rl.DrawCircle(pxi(bx)-3, pxi(by)-8, 1, rl.BLACK)
    rl.DrawCircle(pxi(bx)+3, pxi(by)-8, 1, rl.BLACK)

    rl.DrawTriangle(
	rl.Vector2{f32(pxi(bx)-5), f32(pxi(by))},
	rl.Vector2{f32(pxi(bx)-7), f32(pxi(by)-1)},
	rl.Vector2{f32(pxi(bx)-7), f32(pxi(by)+1)},
	rl.Color{40, 40, 40, 255},
    )

    rl.EndScissorMode()

    score_str := fmt.aprintf("%d", fb.score, allocator = context.temp_allocator)
    rl.DrawText(strings.clone_to_cstring(score_str, context.temp_allocator), pxi(play_x + BUZZY_PLAY_W/2) - 4, pxi(play_y) + 2, 10, rl.WHITE)

    if !fb.started {
        rl.DrawText("BUZZY BEE", pxi(play_x) + 12, pxi(play_y + BUZZY_PLAY_H/2) - 14, 8, rl.WHITE)
        rl.DrawText("SHIFT to start", pxi(play_x) + 8, pxi(play_y + BUZZY_PLAY_H/2), 7, rl.WHITE)
    } else if fb.game_over {
        rl.DrawText("GAME OVER", pxi(play_x) + 14, pxi(play_y + BUZZY_PLAY_H/2) - 14, 8, rl.Color{255, 80, 80, 255})
        stat := fmt.aprintf("Score:%d Best:%d", fb.score, fb.high_score, allocator = context.temp_allocator)
        rl.DrawText(strings.clone_to_cstring(stat, context.temp_allocator), pxi(play_x)+4, pxi(play_y + BUZZY_PLAY_H/2), 7, rl.WHITE)
        rl.DrawText("SHIFT to retry", pxi(play_x) + 12, pxi(play_y + BUZZY_PLAY_H/2) + 12, 7, rl.WHITE)
    }
}


wrap_text_lines :: proc(text: string, font_size: i32, max_width: f32) -> []string {
    words   := strings.split(text, " ", context.temp_allocator)
    lines   := make([dynamic]string, context.temp_allocator)
    current := ""
    for w in words {
        candidate := w if current == "" else strings.concatenate({current, " ", w}, context.temp_allocator)
        cw := rl.MeasureText(strings.clone_to_cstring(candidate, context.temp_allocator), font_size)
        if f32(cw) > max_width && current != "" {
            append(&lines, current)
            current = w
        } else {
            current = candidate
        }
    }
    if current != "" { append(&lines, current) }
    return lines[:]
}

draw_phone_icon :: proc(x, y, size: f32, col: rl.Color, selected: bool) {
    // drop shadow
    rl.DrawRectangle(pxi(x) + 1, pxi(y) + 1, pxi(size), pxi(size), rl.Color{0, 0, 0, 90})
    // icon body
    rl.DrawRectangle(pxi(x), pxi(y), pxi(size), pxi(size), col)
    // gloss highlight strip
    rl.DrawRectangle(pxi(x) + 1, pxi(y) + 1, pxi(size) - 2, 2, rl.Color{255, 255, 255, 70})
    // selection ring
    if selected {
        rl.DrawRectangleLines(pxi(x) - 2, pxi(y) - 2, pxi(size) + 4, pxi(size) + 4, COL_HONEY)
    }
}

draw_phone :: proc() {
    if !g.phone_open { return }

    px := PHONE_MARGIN
    py := f32(GAME_H) - PHONE_H - PHONE_MARGIN

    rl.DrawRectangle(pxi(px), pxi(py), pxi(PHONE_W), pxi(PHONE_H), COL_PHONE_BORDER)

    sx := px + PHONE_BORDER
    sy := py + PHONE_BORDER
    sw := PHONE_W - PHONE_BORDER * 2
    sh := PHONE_H - PHONE_BORDER * 2
    rl.DrawRectangle(pxi(sx), pxi(sy), pxi(sw), pxi(sh), COL_PHONE_SCREEN)

    title := "FuzzyPhone"
    switch g.phone_screen {
    case .Home:
    case .Contacts:      title = "Contacts"
    case .ContactDetail: title = g.npcs[g.selected_contact].name
    case .Help:          title = "Help"
    case .BuzzyBee:    title = "Buzzy Bee"
    }
    title_c := strings.clone_to_cstring(title, context.temp_allocator)
    rl.DrawText(title_c, pxi(sx) + 4, pxi(sy) + 3, 8, COL_HONEY)

    clock_str := strings.clone_to_cstring(phone_time_string(), context.temp_allocator)
    clock_w := rl.MeasureText(clock_str, 8)
    rl.DrawText(clock_str, pxi(sx) + pxi(sw) - clock_w - 4, pxi(sy) + 3, 8, rl.WHITE)

    switch g.phone_screen {
    case .Home:          draw_phone_home(sx, sy, sw, sh)
    case .Contacts:       draw_phone_contacts(sx, sy, sw, sh)
    case .ContactDetail:  draw_phone_contact_detail(sx, sy, sw, sh)
    case .Help:           draw_phone_help(sx, sy, sw, sh)
    case .BuzzyBee:    draw_buzzy_bee(sx, sy, sw, sh)
    }

    footer := "SPACE:exit"
    #partial switch g.phone_screen {
    case .Home:
    case .Contacts:      footer = "ENTER:open BKSP:back"
    case .ContactDetail: footer = "ENTER:message BKSP:back"
    case .BuzzyBee:    footer = "SHIFT:flap BKSP:back"
    }
    footer_c := strings.clone_to_cstring(footer, context.temp_allocator)
    rl.DrawText(footer_c, pxi(sx) + 4, pxi(sy) + pxi(sh) - 10, 6, rl.Color{150, 150, 150, 255})
}

draw_phone_home :: proc(sx, sy, sw, sh: f32) {
    wall_top := sy + 16
    rl.DrawRectangle(pxi(sx), pxi(wall_top), pxi(sw), pxi(sh) / 3, rl.Color{35, 55, 100, 255})
    rl.DrawRectangle(pxi(sx), pxi(wall_top) + pxi(sh) / 3, pxi(sw), pxi(sh) - pxi(sh) / 3, rl.Color{18, 26, 55, 255})

    icon_size  := f32(16)
    row_h      := f32(26)
    pad_top    := f32(6)
    pad_bottom := f32(12)
    list_top   := wall_top + pad_top
    list_h     := sh - (list_top - sy) - pad_bottom

    max_scroll := max(f32(PHONE_APP_COUNT) * row_h - list_h, 0)

    target_scroll := f32(g.phone_cursor) * row_h - list_h/2 + row_h/2
    scroll := clamp(target_scroll, 0, max_scroll)

    rl.BeginScissorMode(pxi(sx), pxi(list_top), pxi(sw), pxi(list_h))

    for i in 0..<PHONE_APP_COUNT {
        row_y := list_top + f32(i) * row_h - scroll
        if row_y + row_h < list_top || row_y > list_top + list_h { continue }

        selected := (i == g.phone_cursor)

        if selected {
            rl.DrawRectangle(pxi(sx) + 2, pxi(row_y) - 2, pxi(sw) - 4, pxi(row_h) - 4, rl.Color{60, 60, 40, 200})
        }

        icon_x := sx + 8
        icon_y := row_y + (row_h - icon_size) / 2

        icon_col := PHONE_APP_ICON_COLORS[i]
        rl.DrawRectangle(pxi(icon_x), pxi(icon_y), pxi(icon_size), pxi(icon_size), icon_col)
        rl.DrawRectangle(pxi(icon_x), pxi(icon_y), pxi(icon_size), 2, rl.Color{255, 255, 255, 70})
        label_col := COL_HONEY if selected else COL_TEXT
        label := strings.clone_to_cstring(PHONE_APP_NAMES[i], context.temp_allocator)
        rl.DrawText(label, pxi(icon_x) + pxi(icon_size) + 8, pxi(row_y) + pxi(row_h)/2 - 3, 7, label_col)
    }

    rl.EndScissorMode()

    if scroll > 0 {
        rl.DrawTriangle(
            rl.Vector2{f32(pxi(sx+sw/2-4)), f32(pxi(list_top+2))},
            rl.Vector2{f32(pxi(sx+sw/2+4)), f32(pxi(list_top+2))},
            rl.Vector2{f32(pxi(sx+sw/2)),   f32(pxi(list_top-2))},
            rl.Color{200, 200, 200, 200},
        )
    }
    if scroll < max_scroll {
        by := list_top + list_h
        rl.DrawTriangle(
            rl.Vector2{f32(pxi(sx+sw/2-4)), f32(pxi(by-2))},
            rl.Vector2{f32(pxi(sx+sw/2)),   f32(pxi(by+2))},
            rl.Vector2{f32(pxi(sx+sw/2+4)), f32(pxi(by-2))},
            rl.Color{200, 200, 200, 200},
        )
    }
}

draw_phone_help :: proc(sx, sy, sw, sh: f32) {
    max_visible := 12
    line_h := f32(11)
    list_top := sy + 18

    end := min(g.phone_help_scroll + max_visible, len(HELP_LINES))
    for i in g.phone_help_scroll..<end {
        row := i - g.phone_help_scroll
        line := HELP_LINES[i]
        col := COL_HONEY if strings.has_prefix(line, "==") else COL_TEXT
        line_c := strings.clone_to_cstring(line, context.temp_allocator)
        rl.DrawText(line_c, pxi(sx) + 6, pxi(list_top) + i32(row) * i32(line_h), 6, col)
    }

    if len(HELP_LINES) > max_visible {
        rl.DrawText("UP/DOWN to scroll", pxi(sx) + 4, pxi(sy) + pxi(sh) - 20, 6, rl.Color{150,150,150,255})
    }
}
draw_weather_icon :: proc(cx, cy, size: f32, raining: bool) {
    t := f32(rl.GetTime())
    if raining {
        rl.DrawCircle(pxi(cx)-8, pxi(cy)-4, size*0.28, {90,90,100,255})
        rl.DrawCircle(pxi(cx),   pxi(cy)-8, size*0.34, {100,100,110,255})
        rl.DrawCircle(pxi(cx)+9, pxi(cy)-4, size*0.28, {90,90,100,255})
        rl.DrawRectangle(pxi(cx)-16, pxi(cy)-4, 32, i32(size*0.3), {95,95,105,255})
        for i in 0..<5 {
            fi     := f32(i)
            drop_x := cx - 14 + fi*7
            drop_y := cy + 8 + math.mod(t*60 + fi*9, 22)
            rl.DrawLine(pxi(drop_x), pxi(drop_y), pxi(drop_x)-2, pxi(drop_y)+6, {110,170,230,255})
        }
    } else {
        rl.DrawCircle(pxi(cx), pxi(cy), size*0.3, {250,210,60,255})
        for i in 0..<8 {
            ang := f32(i)/8.0 * math.PI*2 + t*0.6
            rl.DrawLine(
                pxi(cx + math.cos(ang)*size*0.34), pxi(cy + math.sin(ang)*size*0.34),
                pxi(cx + math.cos(ang)*size*0.5),  pxi(cy + math.sin(ang)*size*0.5),
                {250,210,60,255})
        }
    }
}
draw_stat_bar :: proc(x, y, w, h: f32, value, max_value: f32, fill_color: rl.Color, label: string) {
    pct := clamp(value / max_value, 0, 1)
    bar_color := fill_color
    if value < PLAYER_STAT_LOW { bar_color = COL_BAR_CRITICAL }

    rl.DrawRectangle(pxi(x)-1, pxi(y)-1, pxi(w)+2, pxi(h)+2, COL_BAR_BORDER)
    rl.DrawRectangle(pxi(x), pxi(y), pxi(w), pxi(h), COL_BAR_BG)
    rl.DrawRectangle(pxi(x), pxi(y), pxi(w*pct), pxi(h), bar_color)

    lbl := strings.clone_to_cstring(fmt.aprintf("%s %.0f", label, value, allocator = context.temp_allocator), context.temp_allocator)
    rl.DrawText(lbl, pxi(x)+2, pxi(y)+1, 7, rl.WHITE)
}

draw_player_needs_hud :: proc() {
    bar_w :: f32(70); bar_h :: f32(9); gap :: f32(3)
    x := f32(8); y := f32(300)
    draw_stat_bar(x, y,                    bar_w, bar_h, g.player.health, PLAYER_STAT_MAX, COL_HEALTH, "Health")
    draw_stat_bar(x, y+(bar_h+gap),         bar_w, bar_h, g.player.hunger, PLAYER_STAT_MAX, COL_HUNGER, "Hunger")
    draw_stat_bar(x, y+(bar_h+gap)*2,       bar_w, bar_h, g.player.thirst, PLAYER_STAT_MAX, COL_THIRST, "Thirst")
}

draw_death_overlay :: proc() {
    if !g.death_active { return }
    rl.DrawRectangle(0, 0, GAME_W, GAME_H, rl.BLACK)
}


draw_weather_menu :: proc() {
    if !g.weather_menu_open { return }

    pw :: f32(240); ph :: f32(180)
    px := f32(GAME_W)/2 - pw/2; py := f32(GAME_H)/2 - ph/2
    draw_panel(px, py, pw, ph, "=== WEATHER ===")

    icon_cx := px + pw/2
    icon_cy := py + 56
    draw_weather_icon(icon_cx, icon_cy, 40, is_raining())

    label_c := strings.clone_to_cstring(weather_label(), context.temp_allocator)
    label_w := rl.MeasureText(label_c, 10)
    rl.DrawText(label_c, pxi(icon_cx) - label_w/2, pxi(py)+92, 10, COL_TEXT)

    elapsed_str := fmt.aprintf("Current weather duration: %s", format_clock(g.weather_state_timer), allocator = context.temp_allocator)
    rl.DrawText(strings.clone_to_cstring(elapsed_str, context.temp_allocator), pxi(px)+12, pxi(py)+112, 8, COL_TEXT)

    next_rain_str := fmt.aprintf("Next rain storm in: %s", format_clock(time_until_next_rain()), allocator = context.temp_allocator)
    rl.DrawText(strings.clone_to_cstring(next_rain_str, context.temp_allocator), pxi(px)+12, pxi(py)+128, 8, COL_RED_TEXT)

    rl.DrawText("ENTER/4: Close", pxi(px)+8, pxi(py)+pxi(ph)-14, 7, {140,140,100,200})
}

draw_police_tv_screens :: proc(rx, ry: f32) {
    tv_w :: f32(40); tv_h :: f32(30); gap :: f32(14)
    total_w := f32(POLICE_TV_COUNT)*tv_w + f32(POLICE_TV_COUNT-1)*gap
    start_x := rx + 140 - total_w/2 + tv_w/2
    top_y   := ry + 10

    for i in 0..<POLICE_TV_COUNT {
        sx := start_x + f32(i)*(tv_w+gap)
        sy := top_y

        rl.DrawRectangle(pxi(sx)-3, pxi(sy)-3, pxi(tv_w)+6, pxi(tv_h)+6, {25,25,25,255})
        rl.DrawRectangleLinesEx({sx, sy, tv_w, tv_h}, 1, {90,90,90,255})
        rl.DrawLine(pxi(sx)+pxi(tv_w)/2, pxi(sy)-3, pxi(sx)+pxi(tv_w)/2-6, pxi(sy)-12, {90,90,90,255})
        rl.DrawLine(pxi(sx)+pxi(tv_w)/2, pxi(sy)-3, pxi(sx)+pxi(tv_w)/2+6, pxi(sy)-12, {90,90,90,255})
        rl.DrawRectangle(pxi(sx), pxi(sy), pxi(tv_w), pxi(tv_h), {10,15,10,255})

        npc_idx := (g.police_tv_index + i) % NPC_COUNT
	npc := g.npcs[npc_idx]
	cx := sx + tv_w/2
	cy := sy + tv_h/2 + tv_h*0.15

	top_left  := rl.GetWorldToScreen2D({sx, sy}, g.camera)
	bot_right := rl.GetWorldToScreen2D({sx + tv_w, sy + tv_h}, g.camera)

	rl.BeginScissorMode(
	    i32(top_left.x), i32(top_left.y),
	    i32(bot_right.x - top_left.x), i32(bot_right.y - top_left.y),
	)
	draw_npc_icon(npc, cx, cy)
	rl.EndScissorMode()


        rl.DrawRectangle(pxi(sx), pxi(sy)+pxi(tv_h)/2, pxi(tv_w), 1, rl.Color{255,255,255,25})

        lbl   := strings.clone_to_cstring(npc.name, context.temp_allocator)
        lbl_w := rl.MeasureText(lbl, 6)
        rl.DrawText(lbl, pxi(sx)+pxi(tv_w)/2-lbl_w/2, pxi(sy)+pxi(tv_h)+2, 6, COL_TEXT2)
    }
}




draw_bee_cam_player :: proc() {
    if !g.bee_cam_active { return }
    bob := math.sin(g.bee_cam_anim_time) * BEE_CAM_BOB_AMP
    x := pxi(g.bee_cam_pos.x)
    y := pxi(g.bee_cam_pos.y + bob)

    rl.DrawEllipse(x, y, 6, 4, {30, 20, 10, 255})        // body
    rl.DrawEllipse(x, y, 5, 3, COL_HONEY2)                // stripe base
    rl.DrawRectangle(x-5, y-1, 10, 2, {20, 20, 20, 255})  // dark stripe

    wing_flap := i32(math.sin(g.bee_cam_anim_time * 3) * 4)
    rl.DrawEllipse(x-3, y-4-wing_flap, 4, 2, {255, 255, 255, 160}) // wing L
    rl.DrawEllipse(x+3, y-4-wing_flap, 4, 2, {255, 255, 255, 160}) // wing R
}

draw_bee_cam_overlay :: proc() {
    if !g.bee_cam_active { return }
    rl.DrawRectangle(0, 0, GAME_W, 10, {0, 0, 0, 140})
    rl.DrawRectangle(0, GAME_H-10, GAME_W, 10, {0, 0, 0, 140})
    rl.DrawRectangle(0, 0, 10, GAME_H, {0, 0, 0, 140})
    rl.DrawRectangle(GAME_W-10, 0, 10, GAME_H, {0, 0, 0, 140})
    rl.DrawText("BEE CAM MODE", 8, 8, 10, COL_HONEY2)
    rl.DrawText("[6] Toggle off", 8, 20, 7, {220, 220, 220, 220})
}

draw_bee_swarm :: proc() {
    if !g.bee_swarm.active { return }
    sw := &g.bee_swarm
    bob := math.sin(sw.anim_time) * 3
    rl.DrawCircle(pxi(sw.pos.x), pxi(sw.pos.y + bob), 10, {40,30,10,180})
    rl.DrawCircle(pxi(sw.pos.x), pxi(sw.pos.y + bob), 7, COL_HONEY2)
    for i in 0..<5 {
        ang := sw.anim_time*3 + f32(i)*1.25
        bx := sw.pos.x + math.cos(ang)*9
        by := sw.pos.y + bob + math.sin(ang)*9
        rl.DrawCircle(pxi(bx), pxi(by), 2, {20,20,20,255})
    }
}
draw_yoda :: proc() {
    if !g.lightsaber_active || !g.yoda.visible { return }
    y := &g.yoda
    bob := math.sin(y.anim_time) * 2

    x  := pxi(y.pos.x)
    yy := pxi(y.pos.y + bob)

    // Robe
    rl.DrawRectangle(x-5, yy-6, 10, 12, COL_YODA_ROBE)
    rl.DrawRectangle(x-5, yy+2, 10, 4,  COL_YODA_ROBE2)

    // Head 
    rl.DrawRectangle(x-4, yy-14, 8, 8, COL_YODA_SKIN)
    rl.DrawRectangle(x-7, yy-13, 3, 5, COL_YODA_SKIN)
    rl.DrawRectangle(x+4, yy-13, 3, 5, COL_YODA_SKIN)

    // Eyes
    rl.DrawRectangle(x-3, yy-11, 2, 2, {10,10,10,255})
    rl.DrawRectangle(x+1, yy-11, 2, 2, {10,10,10,255})

    rl.DrawEllipse(x, yy+10, 6, 2, COL_SHADOW)
}

draw_animal_buddy :: proc() {
    if !g.animal_buddy.visible { return }
    a   := &g.animal_buddy
    bob := math.sin(a.anim_time) * 2
    x   := pxi(a.pos.x)
    yy  := pxi(a.pos.y + bob)

    switch a.kind {
    case .Cat:
        rl.DrawRectangle(x-5, yy-4, 10, 8, COL_CAT_BODY)
        rl.DrawRectangle(x-3, yy,   6, 4, COL_CAT_BELLY)
        rl.DrawRectangle(x-4, yy-9, 8, 6, COL_CAT_BODY)
        rl.DrawTriangle({f32(x-4),f32(yy-9)}, {f32(x-2),f32(yy-13)}, {f32(x),f32(yy-9)}, COL_CAT_BODY)
        rl.DrawTriangle({f32(x),f32(yy-9)}, {f32(x+2),f32(yy-13)}, {f32(x+4),f32(yy-9)}, COL_CAT_BODY)
        rl.DrawRectangle(x-2, yy-7, 1, 1, {10,10,10,255})
        rl.DrawRectangle(x+1, yy-7, 1, 1, {10,10,10,255})
        swing := math.sin(a.anim_time*1.5) * 3
        rl.DrawLineEx({f32(x+5), f32(yy+2)}, {f32(x+9)+swing, f32(yy-2)}, 2, COL_CAT_BODY)

    case .Dog:
        rl.DrawRectangle(x-5, yy-3, 10, 8, COL_DOG_BODY)
        rl.DrawRectangle(x-4, yy-10, 8, 7, COL_DOG_BODY)
        rl.DrawRectangle(x-6, yy-9, 3, 5, COL_DOG_EAR)
        rl.DrawRectangle(x+3, yy-9, 3, 5, COL_DOG_EAR)
        rl.DrawRectangle(x-2, yy-7, 1, 1, {10,10,10,255})
        rl.DrawRectangle(x+1, yy-7, 1, 1, {10,10,10,255})
        rl.DrawRectangle(x-1, yy-4, 2, 2, {40,25,15,255})
        wag := math.sin(a.anim_time*4) * 4
        rl.DrawLineEx({f32(x-5), f32(yy+1)}, {f32(x-9), f32(yy-2)+wag}, 2, COL_DOG_BODY)

    case .Goldfish:
    rl.DrawRectangleLinesEx({f32(x-8), f32(yy-10), 16, 20}, 1, {255,255,255,180})
    rl.DrawRectangle(x-7, yy-4, 14, 13, COL_FISH_BAG)
    fbob := i32(math.sin(a.anim_time*2) * 3)
    rl.DrawEllipse(x, yy+3+fbob, 5, 3, COL_FISH_BODY)
    rl.DrawTriangle({f32(x+4),f32(yy+3+fbob)}, {f32(x+8),f32(yy+1+fbob)}, {f32(x+8),f32(yy+5+fbob)}, COL_FISH_BODY)
    rl.DrawTriangleLines(
        {f32(x-1), f32(yy+fbob)},
        {f32(x+2), f32(yy-3+fbob)},
        {f32(x+3), f32(yy+fbob)},
        COL_FISH_FIN,
    )
    rl.DrawTriangleLines(
        {f32(x-2), f32(yy+6+fbob)},
        {f32(x+1), f32(yy+9+fbob)},
        {f32(x+2), f32(yy+6+fbob)},
        COL_FISH_FIN,
    )
    rl.DrawRectangle(x-3, yy+2+fbob, 1, 1, {10,10,10,255})
    rl.DrawLine(x-4, yy+4+fbob, x-3, yy+5+fbob, {10,10,10,255})


    case .GoldenRock:
    	rl.DrawRectangle(x-7, yy-6, 14, 10, COL_ROCK_BODY)
    	rl.DrawRectangle(x-5, yy-8, 10, 3, COL_ROCK_BODY)

    	shine_pulse := (math.sin(a.anim_time * 2.0) + 1.0) * 0.5
    	shine_alpha := u8(140 + shine_pulse*115)
	rl.DrawRectangle(x-3, yy-7, 3, 2, rl.Color{COL_ROCK_SHINE.r, COL_ROCK_SHINE.g, COL_ROCK_SHINE.b, shine_alpha})
    	sparkle_spots := [3][2]i32{ {x-4, yy-8}, {x+3, yy-6}, {x-1, yy-9} }
    	sparkle_phases := [3]f32{ 0.0, 2.1, 4.2 }

    	for i in 0..<3 {
            t := a.anim_time*3.0 + sparkle_phases[i]
            pulse := math.sin(t)
            if pulse > 0.6 {
                bright := (pulse - 0.6) / 0.4
                a_col := u8(bright * 255)
                sx := sparkle_spots[i][0]
                sy := sparkle_spots[i][1]
                col := rl.Color{COL_ROCK_SPARKLE.r, COL_ROCK_SPARKLE.g, COL_ROCK_SPARKLE.b, a_col}
                rl.DrawLine(sx-2, sy, sx+2, sy, col)
                rl.DrawLine(sx, sy-2, sx, sy+2, col)
            }
        }
    case .Turtle:
	rl.DrawRectangle(x-7, yy+3, 3, 3, COL_TURTLE_SKIN)
    	rl.DrawRectangle(x+4, yy+3, 3, 3, COL_TURTLE_SKIN)

    	rl.DrawRectangle(x-6, yy-5, 12, 9, COL_TURTLE_SHELL)
    	rl.DrawRectangle(x-4, yy-7, 8, 3, COL_TURTLE_SHELL)
    	rl.DrawRectangle(x-3, yy-3, 2, 2, COL_TURTLE_SHELL_HL)
    	rl.DrawRectangle(x+1, yy-3, 2, 2, COL_TURTLE_SHELL_HL)
    	rl.DrawRectangle(x-1, yy,   2, 2, COL_TURTLE_SHELL_HL)

    	rl.DrawRectangle(x-8, yy+1, 3, 3, COL_TURTLE_SKIN)
    	rl.DrawRectangle(x+5, yy+1, 3, 3, COL_TURTLE_SKIN)

    	rl.DrawRectangle(x+5, yy-3, 6, 6, COL_TURTLE_SKIN)

    	band_col := BANDANA_COLORS[a.bandana_idx]
    	rl.DrawRectangle(x+4, yy-4, 8, 2, band_col)
    	rl.DrawTriangle(
	    {f32(x+4), f32(yy-4)},
	    {f32(x+1), f32(yy-5)},
	    {f32(x+1), f32(yy-2)},
	    band_col,
	)

    	rl.DrawRectangle(x+8, yy-2, 1, 1, {10,10,10,255})
    	rl.DrawRectangle(x+10, yy-2, 1, 1, {10,10,10,255})

        rl.DrawEllipse(x, yy+9, 6, 2, COL_SHADOW)


    case .R2D2:
    	// blink timing — red indicator pulses, logic-display squares blink independently
    	t   := a.anim_time
    	cyc := t - math.floor(t/1.8) * 1.8
    	red_on    := cyc < 0.3
    	logic_on  := cyc >= 0.5 && cyc < 0.8
    	glint_a   := u8(180 + math.sin(t*3) * 60)

    	red_col   := COL_R2D2_RED        if red_on   else rl.Color{100, 25, 25, 200}
    	logic_col := COL_R2D2_BLUE_LIGHT if logic_on else COL_R2D2_BLUE

    	// ground shadow
    	rl.DrawEllipse(x, yy+10, 8, 2, COL_SHADOW)

    	// slender front legs (thin cylinders, not chunky blocks)
    	rl.DrawRectangle(x-8, yy-3, 3, 10, COL_R2D2_WHITE)
    	rl.DrawRectangle(x-8, yy+7, 3, 2, COL_R2D2_GRAY)
    	rl.DrawRectangle(x+6, yy-3, 3, 10, COL_R2D2_WHITE)
    	rl.DrawRectangle(x+6, yy+7, 3, 2, COL_R2D2_GRAY)

    	// barrel body
    	rl.DrawRectangle(x-6, yy-6, 12, 10, COL_R2D2_WHITE)

    	// vertical blue side panels on body
    	rl.DrawRectangle(x-6, yy-6, 2, 8, COL_R2D2_WHITE)
    	rl.DrawRectangle(x+4, yy-6, 2, 8, COL_R2D2_WHITE)

    	// two horizontal blue stripe panels (mid body)
    	rl.DrawRectangle(x-3, yy-4, 6, 1, COL_R2D2_GRAY)
    	rl.DrawRectangle(x-3, yy-2, 6, 1, COL_R2D2_BLUE)

    	rl.DrawRectangle(x-4, yy-3, 8, 1, COL_R2D2_BLUE)
    	rl.DrawRectangle(x-3, yy-1, 6, 1, COL_R2D2_GRAY)
    	rl.DrawRectangle(x-2, yy+1, 4, 1, COL_R2D2_BLUE)

    	// blue collar stripe where dome meets body
    	rl.DrawRectangle(x-6, yy-7, 12, 1, COL_R2D2_GRAY)

    	// dome head — rounded via layered rectangles
    	rl.DrawRectangle(x-5, yy-13, 10, 6, COL_R2D2_WHITE)
    	rl.DrawRectangle(x-4, yy-14, 8, 1, COL_R2D2_GRAY)

    	// small blue "logic display" lights, far left of dome, blink independently
    	rl.DrawRectangle(x-4, yy-11, 1, 1, logic_col)
    	rl.DrawRectangle(x-4, yy-9,  1, 1, logic_col)

    	// large black photoreceptor eye with blue frame, offset left of center
    	rl.DrawRectangle(x-2, yy-12, 4, 4, COL_R2D2_BLUE)
    	rl.DrawCircle(x, yy-10, 2, COL_R2D2_EYE_BLACK)
    	rl.DrawCircle(x-1, yy-11, 1, rl.Color{255, 255, 255, glint_a}) // eye glint

    	// blinking red indicator light, below/right of the eye
    	rl.DrawCircle(x+3, yy-9, 1, red_col)

    	// small silver logic-vent slot, right side of dome
    	rl.DrawRectangle(x+4, yy-11, 1, 2, COL_R2D2_DARKGRAY)
}
}

update_park_bear :: proc() {
    g.bear_anim_time += g.dt
}

update_pond :: proc() {
    dt := g.dt
    p  := &g.pond

    p.ripple_time += dt
    p.wave_time   += dt * 0.8

    px := g.player.pos.x
    py := g.player.pos.y
    in_water := px > POND_X && px < POND_X + POND_W &&
                py > POND_Y && py < POND_Y + POND_H
    dock_x := POND_X + POND_W/2 - POND_DOCK_WIDTH/2
    on_dock := px > dock_x && px < dock_x + POND_DOCK_WIDTH
    g.player_in_water = in_water && !on_dock
    for i in 0..<POND_FISH_COUNT {
        f := &p.fish[i]
        f.anim_time += dt * 5.0

        f.dive_time -= dt
        if f.dive_time <= 0 {
            f.is_deep   = !f.is_deep
            f.dive_time = rand_f32(3, 10)
        }
        target_depth := f32(0.1) if !f.is_deep else f32(0.85)
        f.depth += (target_depth - f.depth) * dt * 1.2

        f.timer -= dt
        if f.timer <= 0 {
            tx := rand_f32(POND_X + 25, POND_X + POND_W - 25)
            ty := rand_f32(POND_Y + 25, POND_Y + POND_H - 25)
            dir := Vec2{tx - f.pos.x, ty - f.pos.y}
            d   := math.sqrt(dir.x*dir.x + dir.y*dir.y)
            if d < 1 { d = 1 }
            spd := rand_f32(14, 38)
            f.vel   = {(dir.x / d) * spd, (dir.y / d) * spd}
            f.flip  = f.vel.x < 0
            f.timer = rand_f32(1.5, 5.0)
        }

        f.pos.x += f.vel.x * dt
        f.pos.y += f.vel.y * dt

        if f.pos.x < POND_X + 20 {
            f.pos.x = POND_X + 20
            f.vel.x = math.abs(f.vel.x)
            f.flip  = false
        }
        if f.pos.x > POND_X + POND_W - 20 {
            f.pos.x = POND_X + POND_W - 20
            f.vel.x = -math.abs(f.vel.x)
            f.flip  = true
        }
        if f.pos.y < POND_Y + 20 {
            f.pos.y = POND_Y + 20
            f.vel.y = math.abs(f.vel.y)
        }
        if f.pos.y > POND_Y + POND_H - 20 {
            f.pos.y = POND_Y + POND_H - 20
            f.vel.y = -math.abs(f.vel.y)
        }
    }
}
reset_pond_fish :: proc() {
    fish_kinds := []FishType{.Bass, .Trout, .Catfish, .Goldfish, .Pike, .Perch}
    for i in 0..<POND_FISH_COUNT {
        kind := fish_kinds[i % len(fish_kinds)]
        x := rand_f32(POND_X + 30, POND_X + POND_W - 30)
        y := rand_f32(POND_Y + 30, POND_Y + POND_H - 30)
        g.pond.fish[i] = Fish{
            pos       = {x, y},
            vel       = {rand_f32(-20, 20), rand_f32(-15, 15)},
            kind      = kind,
            timer     = rand_f32(1, 5),
            anim_time = rand_f32(0, 6.28),
            flip      = rand_int(0, 2) == 0,
            depth     = rand_f32(0, 1),
            dive_time = rand_f32(2, 8),
            is_deep   = rand_int(0, 2) == 0,
        }
    }
}

end_fishing_minigame :: proc(msg: string) {
    g.fishing_active = false
    g.fishing_timer  = 0
    reset_pond_fish()
    show_message(msg, 3)
}

update_fishing_minigame :: proc() {
    if g.save_rename_slot >= 0 { return }
    if g.in_car { return }

    if !g.fishing_active {
        if rl.IsKeyPressed(.E) && vec2_dist(g.player.pos, FISHING_SPOT) < INTERACT_DIST {
            g.fishing_active   = true
            g.fishing_timer    = FISHING_DURATION
            g.input_e_consumed = true
            show_message("You cast your line and crack a cold one...", 3)
        }
        return
    }

    if rl.IsKeyPressed(.E) {
        g.input_e_consumed = true
        end_fishing_minigame("You reeled in your line.")
        return
    }

    g.fishing_timer -= g.dt
    if g.fishing_timer <= 0 {
        end_fishing_minigame("Time's up! The pond has reset.")
    }
}


plot_hive_limit :: proc(s: PlotSize) -> int {
    switch s {
    case .Small:   return HIVE_LIMIT_SMALL
    case .Medium:  return HIVE_LIMIT_MEDIUM
    case .Large, .XLarge, .XXLarge: return -1
    }
    return -1
}

update_interactions :: proc() {
    if g.input_e_consumed { return }
    if g.festival_menu_open { return }
    if !rl.IsKeyPressed(.E) { return }
    pp := g.player.pos

    if g.festival_active && !g.festival_menu_open {
	for i in 0..<FESTIVAL_NPC_COUNT {
	    npc := &g.festival_npcs[i]
	    if vec2_dist(pp, npc.pos) < INTERACT_DIST {
		g.festival_menu_open   = true
		g.festival_menu_npc    = i
		g.festival_menu_cursor = 0
		g.input_e_consumed     = true
		return
	    }
        }
    }

    for bt in BuildingType {
        b := &g.buildings[bt]
        if vec2_dist(pp, b.door) < INTERACT_DIST {
	    if !b.owned {
                if net_state.role == .Client {
                    net_request_plot_action(int(bt), .BuyBuilding, pp)
                    return
                }
		if g.player.money >= b.cost {
		    g.player.money -= b.cost
		    g.buildings[bt].owned = true
		    show_message(fmt.aprintf("You purchased the %s for $%.0f!",
			b.label, b.cost, allocator = context.temp_allocator), 4)
                    if net_state.role == .Host { net_broadcast_world_snapshot() }
		} else {
		    show_message("Get yo money not yo funny up young blood!")
		}
		return
	    }
	    if bt == .Garage {
            	if g.in_car {
		     enter_garage()
		} else {
		     enter_garage_on_foot()
		}
            	return
	    }
	    if bt == .FarmersMarket {
		if g.is_night {
		    show_message("The market is closed for the night.")
		} else {
		    g.prev_world_pos = pp
		    g.player.pos = {f32(GAME_W)/2, f32(GAME_H)/2 + 60}
		    g.state = .FarmersMarketInterior
		    g.market_menu_open   = false
		}
		return
	    }

            g.interior_building      = bt
            g.prev_world_pos         = pp
            g.player.pos             = {0, 40}
            g.camera.target          = g.player.pos
            g.state                  = .Interior
            g.interior_option_open   = false
            g.interior_option_cursor = 0
            return
        }
    }

    for i in 0..<NUM_HOMES {
        h := &g.homes[i]
        if vec2_dist(pp, h.door) < INTERACT_DIST {
            g.selected_home = i
            g.menu_cursor   = 0
            g.state = .HomeMenu
            return
        }
    }

    for i in 0..<len(g.bee_boxes) {
        box := &g.bee_boxes[i]
        if !box.active { continue }
        if vec2_dist(pp, box.pos) < INTERACT_DIST {
            if net_state.role == .Client {
                net_request_plot_action(-1, .CollectHoney, pp)
                return
            }
            if box.honey_ml > 0 {
                collected         := box.honey_ml
                g.player.honey_ml += collected
                box.honey_ml       = 0
                if net_state.role == .Host { net_broadcast_world_snapshot() }
            }
            return
        }
    }

    for i in 0..<NPC_COUNT {
        if vec2_dist(pp, g.npcs[i].pos) < INTERACT_DIST {
            g.npcs[i].frozen_timer = NPC_FREEZE_DURATION
            g.selected_npc = i
            g.menu_cursor  = 0
            g.state = .NPCMenu
	    g.npc_met[i] = true
            return
        }
    }

    for i in 0..<len(g.plots) {
    	plot := &g.plots[i]
    	if plot.owned { continue }
    	expanded := rect_expand(plot.rect, INTERACT_DIST)
    	if rl.CheckCollisionPointRec(pp, expanded) {
            g.selected_plot = i
            g.menu_cursor   = 0
            g.state = .LandMenu
            return
        }
    }
}

enter_home_interior :: proc(idx: int) {
    g.interior_home      = idx
    g.prev_world_pos     = g.player.pos
    g.player.pos         = {0, 40}
    g.camera.target      = g.player.pos
    g.home_option_open   = false
    g.home_option_cursor = 0
    g.state              = .HomeInterior
}
update_home_interior :: proc() {
    if g.death_active { return }

    idx := g.interior_home
    if idx < 0 || idx >= NUM_HOMES { g.state = .World; return }

    dt := g.dt
    rw, rh := HOME_INT_W, HOME_INT_H
    margin :: f32(10)

    if rl.IsKeyPressed(.O) {
        g.home_option_open   = !g.home_option_open
        g.home_option_cursor = 0
        return
    }

    if g.home_option_open {
        if rl.IsKeyPressed(.UP)   { g.home_option_cursor -= 1; if g.home_option_cursor < 0 { g.home_option_cursor = 0 } }
        if rl.IsKeyPressed(.DOWN) { g.home_option_cursor += 1; if g.home_option_cursor > 1 { g.home_option_cursor = 1 } }
        if rl.IsKeyPressed(.ENTER) || rl.IsKeyPressed(.KP_ENTER) {
            g.home_option_open = false
            g.menu_cursor      = 0
            g.menu_action      = false
            g.menu_frame_skip  = true
            switch g.home_option_cursor {
            case 0: g.state = .HomeDecorateMenu
            case 1: g.state = .HomeTrophyMenu
            }
        }
        return
    }

    vel: Vec2
    if rl.IsKeyDown(.W) { vel.y -= 1 }
    if rl.IsKeyDown(.S) { vel.y += 1 }
    if rl.IsKeyDown(.A) { vel.x -= 1 }
    if rl.IsKeyDown(.D) { vel.x += 1 }
    l := math.sqrt(vel.x*vel.x + vel.y*vel.y)
    if l > 0 { vel.x = vel.x/l * PLAYER_SPEED; vel.y = vel.y/l * PLAYER_SPEED }
    g.player.pos.x += vel.x * dt
    g.player.pos.y += vel.y * dt
    g.player.pos.x = clamp(g.player.pos.x, -rw/2 + margin, rw/2 - margin)
    g.player.pos.y = clamp(g.player.pos.y, -rh/2 + margin, rh/2 - margin)

    update_camera()

    leave_y := rh/2 - 20
    if g.player.pos.y > leave_y && rl.IsKeyPressed(.E) {
        g.player.pos    = g.prev_world_pos
        g.camera.target = g.player.pos
        g.state = .World
        return
    }
    if rl.IsKeyPressed(.ESCAPE) && !g.home_option_open {
        g.player.pos    = g.prev_world_pos
        g.camera.target = g.player.pos
        g.state = .World
    }
}


update_interior :: proc() {

    if g.death_active { return }

    dt  := g.dt
    rw, rh := interior_room_size(g.interior_building)
    margin :: f32(10)

    if g.interior_building == .SheriffOffice {
        g.police_tv_timer += dt
        if g.police_tv_timer >= POLICE_TV_CYCLE_SECONDS {
            g.police_tv_timer = 0
            g.police_tv_index = (g.police_tv_index + 1) % NPC_COUNT
        }
    }

    if rl.IsKeyPressed(.O) {
        g.interior_option_open   = !g.interior_option_open
        g.interior_option_cursor = 0
        return
    }

    if g.interior_option_open {
        if rl.IsKeyPressed(.UP)   { g.interior_option_cursor -= 1; if g.interior_option_cursor < 0 { g.interior_option_cursor = 0 } }
        if rl.IsKeyPressed(.DOWN) { g.interior_option_cursor += 1 }
        if rl.IsKeyPressed(.ENTER) || rl.IsKeyPressed(.KP_ENTER) {
            g.interior_option_open = false
            g.menu_cursor = 0
            g.menu_action = false
	    g.menu_frame_skip = true
	    #partial switch g.interior_building {
            case .Market:        g.state = .ShopMenu
            case .SheriffOffice: g.state = .SheriffMenu
            case .DoctorOffice:  g.state = .DoctorMenu
            case .Bank:          g.state = .BankMenu
            case .Diner:         g.state = .DinerMenu
	    case .Bar:		 g.state = .BarMenu
	    case .CarDealership: g.state = .CarDealerMenu
	    case .BeeSanctuary:  g.state = .BeeSanctuaryMenu
	    case .FuzzyBuddyFactory: g.state = .FuzzyBuddyMenu
            }
        }
        return
    }

    vel : Vec2
    if rl.IsKeyDown(.W) { vel.y -= 1 }
    if rl.IsKeyDown(.S) { vel.y += 1 }
    if rl.IsKeyDown(.A) { vel.x -= 1 }
    if rl.IsKeyDown(.D) { vel.x += 1 }
    l := math.sqrt(vel.x*vel.x + vel.y*vel.y)
    if l > 0 { vel.x = vel.x/l * PLAYER_SPEED; vel.y = vel.y/l * PLAYER_SPEED }
    g.player.pos.x += vel.x * dt
    g.player.pos.y += vel.y * dt

    g.player.pos.x = clamp(g.player.pos.x, -rw/2 + margin, rw/2 - margin)
    g.player.pos.y = clamp(g.player.pos.y, -rh/2 + margin, rh/2 - margin)

    update_camera()

    leave_y := rh/2 - 20
    if g.player.pos.y > leave_y && rl.IsKeyPressed(.E) {
        g.player.pos    = g.prev_world_pos
        g.camera.target = g.player.pos
        g.state = .World
        g.menu_cursor = 0
        return
    }
    if rl.IsKeyPressed(.ESCAPE) && !g.interior_option_open {
        g.player.pos    = g.prev_world_pos
        g.camera.target = g.player.pos
        g.state = .World
    }
}

update_message :: proc() {
    if g.message_timer > 0 { g.message_timer -= g.dt }
}

update_minimap_toggle :: proc() {
    if g.save_rename_slot >= 0 { return }
    if rl.IsKeyPressed(.M) { g.minimap_full = !g.minimap_full }
}

update_inventory_toggle :: proc() {
    if g.save_rename_slot >= 0 { return }
    if rl.IsKeyPressed(.I) {
        g.inventory_open   = !g.inventory_open
        g.inventory_cursor = 0
    }
}
apply_customize_selection :: proc() {
    g.player.shirt_color      = CUSTOMIZE_PALETTE[g.customize_shirt_idx]
    g.player.pants_color      = CUSTOMIZE_PALETTE[g.customize_pants_idx]
    g.player.hat_color        = CUSTOMIZE_PALETTE[g.customize_hat_idx]
    g.player.pattern_color    = CUSTOMIZE_PALETTE[g.customize_pattern_color_idx]
    g.player.clothing_pattern = ClothingPattern(g.customize_pattern_idx)
    g.player.skin_color       = SKIN_PALETTE[g.customize_skin_idx]
}
find_palette_index :: proc(col: rl.Color) -> int {
    for i in 0..<CUSTOMIZE_PALETTE_COUNT {
        c := CUSTOMIZE_PALETTE[i]
        if c.r == col.r && c.g == col.g && c.b == col.b { return i }
    }
    return -1
}
update_customize_toggle :: proc() {
    if g.save_rename_slot >= 0 { return }
    if rl.IsKeyPressed(.ONE) {
        if !g.customize_open {
            g.backup_shirt_idx         = g.customize_shirt_idx
            g.backup_pants_idx         = g.customize_pants_idx
            g.backup_hat_idx           = g.customize_hat_idx
            g.backup_pattern_idx       = g.customize_pattern_idx
            g.backup_pattern_color_idx = g.customize_pattern_color_idx
	    g.backup_skin_idx          = g.customize_skin_idx
            g.customize_cursor = 0
        }
        g.customize_open = !g.customize_open
    }
}
update_edit_home_toggle :: proc() {
    if g.save_rename_slot >= 0 { return }
    if !rl.IsKeyPressed(.THREE) { return }
    if g.state != .World { return }
    g.menu_cursor = 0
    g.state = .EditHomeMenu
}


revert_customize :: proc() {
    g.customize_shirt_idx         = g.backup_shirt_idx
    g.customize_pants_idx         = g.backup_pants_idx
    g.customize_hat_idx           = g.backup_hat_idx
    g.customize_pattern_idx       = g.backup_pattern_idx
    g.customize_pattern_color_idx = g.backup_pattern_color_idx
    g.customize_skin_idx          = g.backup_skin_idx
    apply_customize_selection()
}

commit_customize :: proc() {
    g.backup_shirt_idx         = g.customize_shirt_idx
    g.backup_pants_idx         = g.customize_pants_idx
    g.backup_hat_idx           = g.customize_hat_idx
    g.backup_pattern_idx       = g.customize_pattern_idx
    g.backup_pattern_color_idx = g.customize_pattern_color_idx
    g.backup_skin_idx 	       = g.customize_skin_idx
    apply_customize_selection()
}

update_customize_menu :: proc() {
    if g.save_rename_slot >= 0 { return }
    if !g.customize_open { return }

    if rl.IsKeyPressed(.UP) {
        g.customize_cursor -= 1
        if g.customize_cursor < 0 { g.customize_cursor = CUSTOMIZE_ROW_COUNT - 1 }
    }
    if rl.IsKeyPressed(.DOWN) {
        g.customize_cursor += 1
        if g.customize_cursor >= CUSTOMIZE_ROW_COUNT { g.customize_cursor = 0 }
    }

    left  := rl.IsKeyPressed(.LEFT)
    right := rl.IsKeyPressed(.RIGHT)

    switch g.customize_cursor {
    case CUSTOMIZE_ROW_SHIRT:
        if right { g.customize_shirt_idx = (g.customize_shirt_idx + 1) % CUSTOMIZE_PALETTE_COUNT }
        if left  { g.customize_shirt_idx = (g.customize_shirt_idx - 1 + CUSTOMIZE_PALETTE_COUNT) % CUSTOMIZE_PALETTE_COUNT }
    case CUSTOMIZE_ROW_PANTS:
        if right { g.customize_pants_idx = (g.customize_pants_idx + 1) % CUSTOMIZE_PALETTE_COUNT }
        if left  { g.customize_pants_idx = (g.customize_pants_idx - 1 + CUSTOMIZE_PALETTE_COUNT) % CUSTOMIZE_PALETTE_COUNT }
    case CUSTOMIZE_ROW_HAT:
        if right { g.customize_hat_idx = (g.customize_hat_idx + 1) % CUSTOMIZE_PALETTE_COUNT }
        if left  { g.customize_hat_idx = (g.customize_hat_idx - 1 + CUSTOMIZE_PALETTE_COUNT) % CUSTOMIZE_PALETTE_COUNT }
    case CUSTOMIZE_ROW_PATTERN:
        if right { g.customize_pattern_idx = (g.customize_pattern_idx + 1) % CUSTOMIZE_PATTERN_COUNT }
        if left  { g.customize_pattern_idx = (g.customize_pattern_idx - 1 + CUSTOMIZE_PATTERN_COUNT) % CUSTOMIZE_PATTERN_COUNT }
    case CUSTOMIZE_ROW_PATTERN_COLOR:
        if right { g.customize_pattern_color_idx = (g.customize_pattern_color_idx + 1) % CUSTOMIZE_PALETTE_COUNT }
        if left  { g.customize_pattern_color_idx = (g.customize_pattern_color_idx - 1 + CUSTOMIZE_PALETTE_COUNT) % CUSTOMIZE_PALETTE_COUNT }
    case CUSTOMIZE_ROW_SKIN:
	if right { g.customize_skin_idx = (g.customize_skin_idx + 1) % SKIN_PALETTE_COUNT }
	if left  { g.customize_skin_idx = (g.customize_skin_idx - 1 + SKIN_PALETTE_COUNT) % SKIN_PALETTE_COUNT }

    }

    apply_customize_selection()

    if rl.IsKeyPressed(.ENTER) || rl.IsKeyPressed(.KP_ENTER) {
        switch g.customize_cursor {
        case CUSTOMIZE_ROW_SAVE:
            commit_customize()
            g.customize_open = false
            show_message("Outfit saved!", 2)
        case CUSTOMIZE_ROW_CANCEL:
            revert_customize()
            g.customize_open = false
            show_message("Changes cancelled.", 2)
        }
    }

    if rl.IsKeyPressed(.ESCAPE) {
        revert_customize()
        g.customize_open = false
    }
}
update_car_customize_menu :: proc() {
    if !g.car_customize_open { return }

    if rl.IsKeyPressed(.UP) {
        g.car_customize_cursor -= 1
        if g.car_customize_cursor < 0 { g.car_customize_cursor = CAR_CUSTOMIZE_ROW_COUNT - 1 }
    }
    if rl.IsKeyPressed(.DOWN) {
        g.car_customize_cursor += 1
        if g.car_customize_cursor >= CAR_CUSTOMIZE_ROW_COUNT { g.car_customize_cursor = 0 }
    }

    left  := rl.IsKeyPressed(.LEFT)
    right := rl.IsKeyPressed(.RIGHT)

    switch g.car_customize_cursor {
    case CAR_CUSTOMIZE_ROW_CAR:
        if right || left {
            step := 1 if right else -1
            idx := g.car_customize_car_idx
            for _ in 0..<MAX_CARS {
                idx = (idx + step + MAX_CARS) % MAX_CARS
                if g.cars[idx].owned { break }
            }
            g.car_customize_car_idx   = idx
            g.car_customize_color_idx = find_palette_index(g.cars[idx].body_col)
            if g.car_customize_color_idx < 0 { g.car_customize_color_idx = 0 }
            g.backup_car_color_idx    = g.car_customize_color_idx
        }
    case CAR_CUSTOMIZE_ROW_COLOR:
        if right { g.car_customize_color_idx = (g.car_customize_color_idx + 1) % CUSTOMIZE_PALETTE_COUNT }
        if left  { g.car_customize_color_idx = (g.car_customize_color_idx - 1 + CUSTOMIZE_PALETTE_COUNT) % CUSTOMIZE_PALETTE_COUNT }
    }

    g.cars[g.car_customize_car_idx].body_col = CUSTOMIZE_PALETTE[g.car_customize_color_idx]

    if rl.IsKeyPressed(.ENTER) || rl.IsKeyPressed(.KP_ENTER) {
        switch g.car_customize_cursor {
        case CAR_CUSTOMIZE_ROW_SAVE:
            g.backup_car_color_idx = g.car_customize_color_idx
            g.car_customize_open = false
            show_message("Car color saved!", 2)
        case CAR_CUSTOMIZE_ROW_CANCEL:
            g.cars[g.car_customize_car_idx].body_col = CUSTOMIZE_PALETTE[g.backup_car_color_idx]
            g.car_customize_color_idx = g.backup_car_color_idx
            g.car_customize_open = false
            show_message("Changes cancelled.", 2)
        }
    }

    if rl.IsKeyPressed(.ESCAPE) {
        g.cars[g.car_customize_car_idx].body_col = CUSTOMIZE_PALETTE[g.backup_car_color_idx]
        g.car_customize_open = false
    }
}


draw_customize_menu :: proc() {
    if !g.customize_open { return }

    pw :: f32(260); ph :: f32(210)
    px := f32(GAME_W)/2 - pw/2
    py := f32(GAME_H)/2 - ph/2

    draw_panel(px, py, pw, ph, "=== CUSTOMIZE OUTFIT ===")

    row_labels := [6]string{"Shirt Color", "Pants Color", "Hat Color", "Skin Color", "Pattern", "Pattern Color"}
    row_top :: f32(24)
    row_h   :: f32(24)

    for i in 0..<6 {
        ry := py + row_top + f32(i) * row_h
        selected := (g.customize_cursor == i)
        bg := COL_BTN_HOV if selected else COL_BTN
        border_col := COL_HONEY2 if selected else COL_PANEL_BORDER

        rl.DrawRectangle(pxi(px)+8, pxi(ry), pxi(pw)-16, 20, bg)
        rl.DrawRectangleLinesEx({px+8, ry, pw-16, 20}, 1, border_col)
        rl.DrawText(strings.clone_to_cstring(row_labels[i], context.temp_allocator), pxi(px)+12, pxi(ry)+6, 8, COL_TEXT)

        value_x := pxi(px) + pxi(pw) - 86
        if selected { rl.DrawText("<", value_x - 12, pxi(ry)+5, 9, COL_HONEY2) }

        switch i {
        case 0: rl.DrawRectangle(value_x, pxi(ry)+4, 24, 12, g.player.shirt_color)
        case 1: rl.DrawRectangle(value_x, pxi(ry)+4, 24, 12, g.player.pants_color)
        case 2: rl.DrawRectangle(value_x, pxi(ry)+4, 24, 12, g.player.hat_color)
	case 3: rl.DrawRectangle(value_x, pxi(ry)+4, 24, 12, g.player.skin_color)
        case 4:
            rl.DrawText(strings.clone_to_cstring(CUSTOMIZE_PATTERN_NAMES[g.customize_pattern_idx], context.temp_allocator), value_x, pxi(ry)+6, 8, COL_TEXT2)
        case 5: rl.DrawRectangle(value_x, pxi(ry)+4, 24, 12, g.player.pattern_color)
        }
        if selected { rl.DrawText(">", value_x + 30, pxi(ry)+5, 9, COL_HONEY2) }
    }

    btn_y := py + row_top + 6*row_h + 6
    btn_w := (pw - 36) / 2

    save_sel := (g.customize_cursor == CUSTOMIZE_ROW_SAVE)
    save_bg  := COL_BTN_HOV if save_sel else COL_BTN
    rl.DrawRectangle(pxi(px)+14, pxi(btn_y), pxi(btn_w), 22, save_bg)
    rl.DrawRectangleLinesEx({px+14, btn_y, btn_w, 22}, 1, COL_HONEY2 if save_sel else COL_PANEL_BORDER)
    rl.DrawText("Save", pxi(px)+14+pxi(btn_w)/2-14, pxi(btn_y)+6, 9, COL_GREEN_TEXT)

    cancel_x  := px + 14 + btn_w + 8
    cancel_sel:= (g.customize_cursor == CUSTOMIZE_ROW_CANCEL)
    cancel_bg := COL_BTN_HOV if cancel_sel else COL_BTN
    rl.DrawRectangle(pxi(cancel_x), pxi(btn_y), pxi(btn_w), 22, cancel_bg)
    rl.DrawRectangleLinesEx({cancel_x, btn_y, btn_w, 22}, 1, COL_HONEY2 if cancel_sel else COL_PANEL_BORDER)
    rl.DrawText("Cancel", pxi(cancel_x)+pxi(btn_w)/2-18, pxi(btn_y)+6, 9, COL_RED_TEXT)

    rl.DrawText("UP/DOWN: Row  LEFT/RIGHT: Change  ENTER: Select", pxi(px)+8, pxi(py)+pxi(ph)-14, 7, {140,140,100,200})
}
draw_car_customize_menu :: proc() {
    if !g.car_customize_open { return }

    pw :: f32(260); ph :: f32(180)
    px := f32(GAME_W)/2 - pw/2
    py := f32(GAME_H)/2 - ph/2
    draw_panel(px, py, pw, ph, "=== CUSTOMIZE CAR ===")

    row_top :: f32(24); row_h :: f32(24)
    car := &g.cars[g.car_customize_car_idx]
    car_label: string
    switch car.kind {
    case .HoneyRacer: car_label = "Honey Racer"
    case .BeeCruiser: car_label = "Bee Cruiser"
    case .PollenGT:   car_label = "Pollen GT"
    }

    ry0 := py + row_top
    sel0 := (g.car_customize_cursor == CAR_CUSTOMIZE_ROW_CAR)
    rl.DrawRectangle(pxi(px)+8, pxi(ry0), pxi(pw)-16, 20, COL_BTN_HOV if sel0 else COL_BTN)
    rl.DrawRectangleLinesEx({px+8, ry0, pw-16, 20}, 1, COL_HONEY2 if sel0 else COL_PANEL_BORDER)
    rl.DrawText("Car", pxi(px)+12, pxi(ry0)+6, 8, COL_TEXT)
    rl.DrawText(strings.clone_to_cstring(car_label, context.temp_allocator), pxi(px)+pxi(pw)-110, pxi(ry0)+6, 8, COL_TEXT2)
    if sel0 {
        rl.DrawText("<", pxi(px)+pxi(pw)-122, pxi(ry0)+5, 9, COL_HONEY2)
        rl.DrawText(">", pxi(px)+pxi(pw)-16,  pxi(ry0)+5, 9, COL_HONEY2)
    }

    ry1 := py + row_top + row_h
    sel1 := (g.car_customize_cursor == CAR_CUSTOMIZE_ROW_COLOR)
    rl.DrawRectangle(pxi(px)+8, pxi(ry1), pxi(pw)-16, 20, COL_BTN_HOV if sel1 else COL_BTN)
    rl.DrawRectangleLinesEx({px+8, ry1, pw-16, 20}, 1, COL_HONEY2 if sel1 else COL_PANEL_BORDER)
    rl.DrawText("Color", pxi(px)+12, pxi(ry1)+6, 8, COL_TEXT)
    rl.DrawRectangle(pxi(px)+pxi(pw)-86, pxi(ry1)+4, 24, 12, CUSTOMIZE_PALETTE[g.car_customize_color_idx])
    if sel1 {
        rl.DrawText("<", pxi(px)+pxi(pw)-98, pxi(ry1)+5, 9, COL_HONEY2)
        rl.DrawText(">", pxi(px)+pxi(pw)-56, pxi(ry1)+5, 9, COL_HONEY2)
    }

    btn_y := py + row_top + 2*row_h + 10
    btn_w := (pw - 36) / 2
    save_sel := (g.car_customize_cursor == CAR_CUSTOMIZE_ROW_SAVE)
    rl.DrawRectangle(pxi(px)+14, pxi(btn_y), pxi(btn_w), 22, COL_BTN_HOV if save_sel else COL_BTN)
    rl.DrawRectangleLinesEx({px+14, btn_y, btn_w, 22}, 1, COL_HONEY2 if save_sel else COL_PANEL_BORDER)
    rl.DrawText("Save", pxi(px)+14+pxi(btn_w)/2-14, pxi(btn_y)+6, 9, COL_GREEN_TEXT)

    cancel_x := px + 14 + btn_w + 8
    cancel_sel := (g.car_customize_cursor == CAR_CUSTOMIZE_ROW_CANCEL)
    rl.DrawRectangle(pxi(cancel_x), pxi(btn_y), pxi(btn_w), 22, COL_BTN_HOV if cancel_sel else COL_BTN)
    rl.DrawRectangleLinesEx({cancel_x, btn_y, btn_w, 22}, 1, COL_HONEY2 if cancel_sel else COL_PANEL_BORDER)
    rl.DrawText("Cancel", pxi(cancel_x)+pxi(btn_w)/2-18, pxi(btn_y)+6, 9, COL_RED_TEXT)

    rl.DrawText("UP/DOWN: Row  LEFT/RIGHT: Change  ENTER: Select  O: Close",
        pxi(px)+8, pxi(py)+pxi(ph)-14, 7, {140,140,100,200})
}

update_market_menu :: proc() {
    if !g.market_menu_open { return }

    if rl.IsKeyPressed(.UP) || rl.IsKeyPressed(.DOWN) {
        g.market_menu_cursor = 1 - g.market_menu_cursor
    }
    if g.market_menu_cursor == MARKET_MENU_ROW_PRICE {
        if rl.IsKeyPressed(.RIGHT) {
            g.market_price = min(g.market_price + MARKET_PRICE_STEP, MARKET_PRICE_MAX)
        }
        if rl.IsKeyPressed(.LEFT) {
            g.market_price = max(g.market_price - MARKET_PRICE_STEP, MARKET_PRICE_MIN)
        }
    }
    if (rl.IsKeyPressed(.ENTER) || rl.IsKeyPressed(.KP_ENTER)) && g.market_menu_cursor == MARKET_MENU_ROW_CLOSE {
        g.market_menu_open = false
    }
    if rl.IsKeyPressed(.ESCAPE) {
        g.market_menu_open = false
    }
}

update_festival_menu :: proc() {
    if !g.festival_menu_open { return }
    if rl.IsKeyPressed(.UP) {
        g.festival_menu_cursor -= 1
        if g.festival_menu_cursor < 0 { g.festival_menu_cursor = FESTIVAL_ROW_COUNT - 1 }
    }
    if rl.IsKeyPressed(.DOWN) {
        g.festival_menu_cursor += 1
        if g.festival_menu_cursor >= FESTIVAL_ROW_COUNT { g.festival_menu_cursor = 0 }
    }
    npc := &g.festival_npcs[g.festival_menu_npc]
    if rl.IsKeyPressed(.ENTER) || rl.IsKeyPressed(.KP_ENTER) {
        switch g.festival_menu_cursor {
        case FESTIVAL_ROW_SELL:
            if g.player.honey_ml >= FESTIVAL_JAR_ML {
                g.player.honey_ml -= FESTIVAL_JAR_ML
                g.player.money    += npc.buy_price
                show_message(fmt.tprintf("%s bought your honey for $%.0f!", npc.name, npc.buy_price), 3)
		npc_relationship_gain(g.selected_npc, RELATIONSHIP_TRADE_GAIN)
            } else {
                show_message("Not enough honey to sell!", 2)
            }
        case FESTIVAL_ROW_BUY:
            if g.player.money >= npc.sell_price {
                g.player.money -= npc.sell_price
                show_message(fmt.tprintf("You bought %s from %s.", npc.sell_item, npc.name), 3)
		npc_relationship_gain(g.selected_npc, RELATIONSHIP_TRADE_GAIN)
            } else {
                show_message("Not enough money!", 2)
            }
        case FESTIVAL_ROW_EXIT:
            g.festival_menu_open = false
        }
    }
    if rl.IsKeyPressed(.LEFT_SHIFT) { g.festival_menu_open = false }
}

draw_market_menu_item :: proc(x, y, w, h: f32, label: string, index: int, font_size: i32 = 9) {
    selected := (g.market_menu_cursor == index)
    bg_col := COL_BTN_HOV if selected else COL_BTN
    rl.DrawRectangle(pxi(x), pxi(y), pxi(w), pxi(h), bg_col)
    if selected {
        rl.DrawRectangleLinesEx({x, y, w, h}, 1, COL_HONEY2)
        rl.DrawText(">", pxi(x)+3, pxi(y)+pxi(h)/2-font_size/2, font_size, COL_HONEY2)
    } else {
        rl.DrawRectangleLinesEx({x, y, w, h}, 1, COL_PANEL_BORDER)
    }
    cstr := strings.clone_to_cstring(label, context.temp_allocator)
    rl.DrawText(cstr, pxi(x)+14, pxi(y)+pxi(h)/2-font_size/2, font_size, COL_TEXT)
}
// --- Multiplayer night backdrop (visual only, no state) ---
MP_NIGHT_STAR_COUNT     :: 40
MP_NIGHT_FIREFLY_COUNT  :: 22
COL_MP_NIGHT_TOP    :: rl.Color{ 10,  14,  40, 255}
COL_MP_NIGHT_BOTTOM :: rl.Color{ 35,  30,  70, 255}
COL_MP_FIREFLY      :: rl.Color{200, 255, 140, 255}

// Deterministic hash -> [0,1), mirrors get_sanctuary_bee_speed's approach
mp_night_hash01 :: proc(seed: u32) -> f32 {
    h := seed * 374761393 + 668265263
    h = (h ~ (h >> 13)) * 1274126177
    h = h ~ (h >> 16)
    return f32(h & 0x7fffffff) / f32(0x7fffffff)
}

draw_mp_night_backdrop :: proc() {
    t := f32(rl.GetTime())

    // Night sky gradient (replaces the plain green fill)
    rl.DrawRectangleGradientV(0, 0, GAME_W, GAME_H, COL_MP_NIGHT_TOP, COL_MP_NIGHT_BOTTOM)

    // Twinkling stars
    for i in 0..<MP_NIGHT_STAR_COUNT {
        sx := mp_night_hash01(u32(i)*7  + 1) * f32(GAME_W)
        sy := mp_night_hash01(u32(i)*13 + 2) * f32(GAME_H) * 0.75
        phase    := mp_night_hash01(u32(i)*19 + 3) * 6.283
        twinkle  := 0.5 + 0.5*math.sin(t*2.0 + phase)
        a := u8(90.0 + 140.0*twinkle)
        rl.DrawCircle(pxi(sx), pxi(sy), 1, rl.Color{255,255,255,a})
    }

    // Fireflies: organic wander + flicker on/off
    for i in 0..<MP_NIGHT_FIREFLY_COUNT {
        seed  := u32(i)
        speed := 0.15 + mp_night_hash01(seed*3+5)*0.25
        px := f32(GAME_W)*0.5 + math.sin(t*speed     + mp_night_hash01(seed*5+7)*6.283)  * (f32(GAME_W)*0.42)
        py := f32(GAME_H)*0.55 + math.cos(t*speed*1.3 + mp_night_hash01(seed*9+11)*6.283) * (f32(GAME_H)*0.32)

        flicker := 0.5 + 0.5*math.sin(t*3.0 + mp_night_hash01(seed*17+2)*6.283)
        if flicker < 0.35 { continue } // fireflies periodically go dark

        glow_a := u8(60.0 + 120.0*flicker)
        rl.DrawCircleV({px, py}, 4,   rl.Color{COL_MP_FIREFLY.r, COL_MP_FIREFLY.g, COL_MP_FIREFLY.b, glow_a/3})
        rl.DrawCircleV({px, py}, 1.5, rl.Color{COL_MP_FIREFLY.r, COL_MP_FIREFLY.g, COL_MP_FIREFLY.b, glow_a})
    }

    // Shooting star: one streaks by every ~4.5s, deterministic per cycle
    STAR_CYCLE :: f32(4.5)
    cycle_idx := u32(t / STAR_CYCLE)
    cycle_t   := math.mod(t, STAR_CYCLE)
    if cycle_t < 0.9 {
        prog := cycle_t / 0.9
        sx0 := mp_night_hash01(cycle_idx*31+1) * f32(GAME_W)*0.6
        sy0 := mp_night_hash01(cycle_idx*37+2) * f32(GAME_H)*0.3
        dx, dy := f32(160), f32(90)
        hx := sx0 + dx*prog
        hy := sy0 + dy*prog
        tail_a := u8(255.0 * (1.0-prog))
        rl.DrawLineEx({hx - dx*0.15, hy - dy*0.15}, {hx, hy}, 2, rl.Color{255,255,255,tail_a})
        rl.DrawCircleV({hx, hy}, 1.5, {255,255,255,255})
    }
}

draw_multiplayer_menu :: proc() {
    draw_mp_night_backdrop()
    pw :: f32(240); ph :: f32(160)
    px := f32(GAME_W)/2 - pw/2
    py := f32(GAME_H)/2 - ph/2
    update_menu_input(3)
    draw_panel(px, py, pw, ph, "=== MULTIPLAYER ===")

    if draw_menu_item(px+8, py+30, pw-16, 28, "Host Game", 0) {
        g.mp_pass_len     = 0
        g.mp_pass_buf     = {}
        g.mp_cursor_blink = 0
        g.state = .MultiplayerHostPassphrase
    }
    if draw_menu_item(px+8, py+62, pw-16, 28, "Join Game", 1) {
        g.mp_ip_len       = 0
        g.mp_ip_buf       = {}
        g.mp_pass_len     = 0
        g.mp_pass_buf     = {}
        g.mp_join_focus   = 0
        g.mp_cursor_blink = 0
        g.state = .MultiplayerIPEntry
    }
    if draw_menu_item(px+8, py+94, pw-16, 28, "Back", 2) {
        g.state = .MainMenu
    }

    rl.DrawText("ENTER: Confirm   LEFT SHIFT: BACK",
        pxi(px)+8, pxi(py)+pxi(ph)-14, 7, {140,140,100,200})

    if rl.IsKeyPressed(.LEFT_SHIFT) { g.state = .MainMenu; g.menu_cursor = 0 }
}


update_multiplayer_host_passphrase :: proc() {
    g.mp_cursor_blink += g.dt

    for {
        ch := rl.GetCharPressed()
        if ch == 0 { break }
        if ch >= 32 && ch < 127 && g.mp_pass_len < len(g.mp_pass_buf)-1 {
            g.mp_pass_buf[g.mp_pass_len] = u8(ch)
            g.mp_pass_len += 1
        }
    }
    if rl.IsKeyPressed(.BACKSPACE) && g.mp_pass_len > 0 {
        g.mp_pass_len -= 1
        g.mp_pass_buf[g.mp_pass_len] = 0
    }
    if rl.IsKeyPressed(.ENTER) || rl.IsKeyPressed(.KP_ENTER) {
        g.pending_host_passphrase_len = g.mp_pass_len
        copy(g.pending_host_passphrase_buf[:], g.mp_pass_buf[:])

        g.main_menu_mode   = 2
        g.main_menu_cursor = 0
	g.suppress_enter_this_frame = true
        for i in 0..<NUM_SAVE_SLOTS { refresh_save_header(i) }
        g.pending_host_after_load = true
        g.state = .MainMenu
    }
    if rl.IsKeyPressed(.RIGHT_SHIFT) {
        g.state = .MultiplayerMenu
        g.menu_cursor = 0
    }
}

draw_multiplayer_host_passphrase :: proc() {
    draw_mp_night_backdrop()
    pw :: f32(240); ph :: f32(120)
    px := f32(GAME_W)/2 - pw/2
    py := f32(GAME_H)/2 - ph/2
    draw_panel(px, py, pw, ph, "=== HOST GAME ===")

    rl.DrawText("Set a passphrase (optional):", pxi(px)+8, pxi(py)+30, 9, COL_TEXT)

    box_y := py + 46
    rl.DrawRectangle(pxi(px)+8, pxi(box_y), pxi(pw)-16, 20, COL_BTN)
    rl.DrawRectangleLinesEx({px+8, box_y, pw-16, 20}, 1, COL_HONEY2)

    pass_str   := string(g.mp_pass_buf[:g.mp_pass_len])
    cursor_str := "_" if math.mod(g.mp_cursor_blink, 1.0) < 0.5 else ""
    display    := fmt.aprintf("%s%s", pass_str, cursor_str, allocator = context.temp_allocator)
    rl.DrawText(strings.clone_to_cstring(display, context.temp_allocator),
        pxi(px)+14, pxi(box_y)+6, 9, COL_TEXT)

    rl.DrawText("Leave blank for an open lobby", pxi(px)+8, pxi(box_y)+26, 7, {140,140,100,200})
    rl.DrawText("ENTER:NEXT  RIGHT SHIFT:BACK",
        pxi(px)+8, pxi(py)+pxi(ph)-14, 7, {140,140,100,200})
}


update_multiplayer_ip_entry :: proc() {
    g.mp_cursor_blink += g.dt

    if rl.IsKeyPressed(.TAB) {
        g.mp_join_focus = 1 - g.mp_join_focus
    }

    for {
        ch := rl.GetCharPressed()
        if ch == 0 { break }
        if g.mp_join_focus == 0 {
            is_digit := ch >= '0' && ch <= '9'
            if (is_digit || ch == '.') && g.mp_ip_len < len(g.mp_ip_buf)-1 {
                g.mp_ip_buf[g.mp_ip_len] = u8(ch)
                g.mp_ip_len += 1
            }
        } else {
            if ch >= 32 && ch < 127 && g.mp_pass_len < len(g.mp_pass_buf)-1 {
                g.mp_pass_buf[g.mp_pass_len] = u8(ch)
                g.mp_pass_len += 1
            }
        }
    }
    if rl.IsKeyPressed(.BACKSPACE) {
        if g.mp_join_focus == 0 {
            if g.mp_ip_len > 0 {
                g.mp_ip_len -= 1
                g.mp_ip_buf[g.mp_ip_len] = 0
            }
        } else {
            if g.mp_pass_len > 0 {
                g.mp_pass_len -= 1
                g.mp_pass_buf[g.mp_pass_len] = 0
            }
        }
    }
    if rl.IsKeyPressed(.ENTER) || rl.IsKeyPressed(.KP_ENTER) {
        if g.mp_ip_len > 0 {
            ip_str   := string(g.mp_ip_buf[:g.mp_ip_len])
            pass_str := string(g.mp_pass_buf[:g.mp_pass_len])
            if net_client_connect(ip_str, NET_PORT_DEFAULT, pass_str) {
                g.state = .MultiplayerLobby
            }
        }
    }
    if rl.IsKeyPressed(.RIGHT_SHIFT) {
        g.state = .MultiplayerMenu
        g.menu_cursor = 0
    }
}

draw_multiplayer_ip_entry :: proc() {
    draw_mp_night_backdrop()
    pw :: f32(240); ph :: f32(160)
    px := f32(GAME_W)/2 - pw/2
    py := f32(GAME_H)/2 - ph/2
    draw_panel(px, py, pw, ph, "=== JOIN GAME ===")

    rl.DrawText("Enter host IP address:", pxi(px)+8, pxi(py)+28, 9, COL_TEXT)

    ip_box_y   := py + 44
    ip_focused := g.mp_join_focus == 0
    ip_line_col := COL_HONEY2
    if !ip_focused { ip_line_col = {90,80,60,255} }

    rl.DrawRectangle(pxi(px)+8, pxi(ip_box_y), pxi(pw)-16, 20, COL_BTN)
    rl.DrawRectangleLinesEx({px+8, ip_box_y, pw-16, 20}, 1, ip_line_col)

    ip_str     := string(g.mp_ip_buf[:g.mp_ip_len])
    ip_cursor  := "_" if (ip_focused && math.mod(g.mp_cursor_blink, 1.0) < 0.5) else ""
    ip_display := fmt.aprintf("%s%s", ip_str, ip_cursor, allocator = context.temp_allocator)
    rl.DrawText(strings.clone_to_cstring(ip_display, context.temp_allocator),
        pxi(px)+14, pxi(ip_box_y)+6, 9, COL_TEXT)

    rl.DrawText("Passphrase (if host set one):", pxi(px)+8, pxi(py)+72, 9, COL_TEXT)

    pass_box_y   := py + 88
    pass_focused := g.mp_join_focus == 1
    pass_line_col := COL_HONEY2
    if !pass_focused { pass_line_col = {90,80,60,255} }

    rl.DrawRectangle(pxi(px)+8, pxi(pass_box_y), pxi(pw)-16, 20, COL_BTN)
    rl.DrawRectangleLinesEx({px+8, pass_box_y, pw-16, 20}, 1, pass_line_col)

    pass_str     := string(g.mp_pass_buf[:g.mp_pass_len])
    pass_cursor  := "_" if (pass_focused && math.mod(g.mp_cursor_blink, 1.0) < 0.5) else ""
    pass_display := fmt.aprintf("%s%s", pass_str, pass_cursor, allocator = context.temp_allocator)
    rl.DrawText(strings.clone_to_cstring(pass_display, context.temp_allocator),
        pxi(px)+14, pxi(pass_box_y)+6, 9, COL_TEXT)

    rl.DrawText("TAB:SWITCH/R_SHIFT:BACK/ENTER:JOIN",
        pxi(px)+8, pxi(py)+pxi(ph)-14, 7, {140,140,100,200})
}

draw_multiplayer_lobby :: proc() {

    draw_mp_night_backdrop()
    pw :: f32(260); ph :: f32(200)
    px := f32(GAME_W)/2 - pw/2
    py := f32(GAME_H)/2 - ph/2
    title := "=== HOSTING LOBBY ===" if net_state.role == .Host else "=== JOINED LOBBY ==="
    draw_panel(px, py, pw, ph, title)

    you_label := fmt.aprintf("You (Player %d)", net_state.local_id, allocator = context.temp_allocator)
    rl.DrawText(strings.clone_to_cstring(you_label, context.temp_allocator),
	pxi(px)+8, pxi(py)+26, 8, COL_HONEY2)


    row := 1
    for i in 0..<NET_MAX_PLAYERS {
        r := net_state.remotes[i]
        if !r.active { continue }
        label := fmt.aprintf("Player %d", r.id, allocator = context.temp_allocator)
        rl.DrawText(strings.clone_to_cstring(label, context.temp_allocator),
            pxi(px)+8, pxi(py)+26+i32(row)*12, 8, COL_TEXT)
        row += 1
    }

    if net_state.role == .Host {
        rl.DrawText("ENTER: Start Game  RIGHT SHIFT: CANCEL",
            pxi(px)+8, pxi(py)+pxi(ph)-14, 7, {140,140,100,200})
        if rl.IsKeyPressed(.ENTER) || rl.IsKeyPressed(.KP_ENTER) {
            net_start_game()
        }
    } else {
        rl.DrawText("Wait for host to start | RIGHT SHIFT:LEAVE",
            pxi(px)+8, pxi(py)+pxi(ph)-14, 7, {140,140,100,200})
    }

    if rl.IsKeyPressed(.RIGHT_SHIFT) {
        net_shutdown()
        g.state = .MultiplayerMenu
        g.menu_cursor = 0
    }
}


draw_market_menu :: proc() {
    if !g.market_menu_open { return }
    pw :: f32(220); ph :: f32(110)
    px := f32(GAME_W)/2 - pw/2
    py := f32(GAME_H)/2 - ph/2
    draw_panel(px, py, pw, ph, "=== FARMERS MARKET ===")

    price_str := fmt.tprintf("Honey Price: $%.0f", g.market_price)
    draw_market_menu_item(px+10, py+24, pw-20, 24, price_str, MARKET_MENU_ROW_PRICE)
    draw_market_menu_item(px+10, py+52, pw-20, 24, "Close", MARKET_MENU_ROW_CLOSE)

    rl.DrawText("LEFT/RIGHT: Adjust Price  ENTER: Select",
        pxi(px)+8, pxi(py)+pxi(ph)-14, 7, {140,140,100,200})
}
draw_festival :: proc() {
    if !g.festival_active { return }

    rl.DrawRectangle(pxi(PARK_X), pxi(PARK_Y - 26), pxi(PARK_W), 22, COL_FESTIVAL_BANNER)
    rl.DrawText("~ HONEYVILLE FESTIVAL ~", pxi(PARK_X) + pxi(PARK_W)/2 - 80, pxi(PARK_Y) - 20, 12, rl.Color{120, 80, 10, 255})
    rl.DrawRectangleLinesEx({PARK_X, PARK_Y - 26, PARK_W, 22}, 2, rl.Color{140, 100, 20, 255})

    for i in 0..<FESTIVAL_NPC_COUNT {
        draw_npc(g.festival_npcs[i])
    }
}


draw_festival_menu :: proc() {
    if !g.festival_menu_open { return }
    npc := &g.festival_npcs[g.festival_menu_npc]
    pw :: f32(250); ph :: f32(120)
    px := f32(GAME_W)/2 - pw/2
    py := f32(GAME_H)/2 - ph/2
    draw_panel(px, py, pw, ph, fmt.tprintf("=== %s ===", npc.name))

    labels := [FESTIVAL_ROW_COUNT]string{
        fmt.tprintf("Sell Honey ($%.0f)", npc.buy_price),
        fmt.tprintf("Buy %s ($%.0f)", npc.sell_item, npc.sell_price),
        "Leave",
    }
    for r in 0..<FESTIVAL_ROW_COUNT {
        ry := py + 26 + f32(r)*24
        sel := (g.festival_menu_cursor == r)
        rl.DrawRectangle(pxi(px)+8, pxi(ry), pxi(pw)-16, 20, COL_BTN_HOV if sel else COL_BTN)
        rl.DrawRectangleLinesEx({px+8, ry, pw-16, 20}, 1, COL_HONEY2 if sel else COL_PANEL_BORDER)
        if sel { rl.DrawText(">", pxi(px)+12, pxi(ry)+6, 9, COL_HONEY2) }
        rl.DrawText(strings.clone_to_cstring(labels[r], context.temp_allocator), pxi(px)+22, pxi(ry)+6, 9, COL_TEXT)
    }
    rl.DrawText("UP/DOWN: Choose  ENTER: Confirm", pxi(px)+8, pxi(py)+pxi(ph)-14, 7, {140,140,100,200})
}

update_discovered_toggle :: proc() {
    if g.save_rename_slot >= 0 { return }
    if rl.IsKeyPressed(.L) {
        g.discovered_open = !g.discovered_open
        if g.discovered_open {
            g.album_open    = false
            g.album_viewing = false
        }
    }
    if g.discovered_open && rl.IsKeyPressed(.ESCAPE) {
        g.discovered_open = false
    }
}
update_bee_net_toggle :: proc() {
    if g.save_rename_slot >= 0 { return }
    if !rl.IsKeyPressed(.ZERO) { return }
    if !g.inv_bee_net {
        show_message("You don't own a Bee Net! Buy one at the Market for $5000.")
        return
    }
    g.bee_net_active = !g.bee_net_active
    if g.bee_net_active {
        show_message("Bee Net equipped!", 3)
    } else {
        show_message("Bee Net put away.", 2)
    }
}
update_lantern_toggle :: proc() {
    if g.save_rename_slot >= 0 { return }
    if !rl.IsKeyPressed(.NINE) { return }
    if !g.inv_lantern {
        show_message(fmt.aprintf("You need to catch %d lightning bugs with your Bee Net at night to craft a lantern! (%d/%d)",
            LANTERN_BUGS_REQUIRED, g.lightning_bugs_caught, LANTERN_BUGS_REQUIRED, allocator = context.temp_allocator))
        return
    }
    g.lantern_active = !g.lantern_active
    if g.lantern_active {
        show_message("Lightning Bug Lantern lit!", 2)
    } else {
        show_message("Lantern put away.", 2)
    }
}
spawn_yoda :: proc() {
    g.yoda.pos       = {g.player.pos.x - 40, g.player.pos.y + 10}
    g.yoda.visible   = true
    g.yoda.anim_time = 0
}

update_yoda :: proc() {
    if g.save_rename_slot >= 0 { return }
    if !g.lightsaber_active || !g.yoda.visible { return }
    y := &g.yoda
    y.anim_time += g.dt * 4.0

    dir := Vec2{g.player.pos.x - y.pos.x, g.player.pos.y - y.pos.y}
    d   := math.sqrt(dir.x*dir.x + dir.y*dir.y)
    if d > YODA_FOLLOW_DIST {
        move := min(d - YODA_FOLLOW_DIST, YODA_FOLLOW_SPEED * g.dt)
        y.pos.x += (dir.x/d) * move
        y.pos.y += (dir.y/d) * move
    }
}
update_animal_menu_toggle :: proc() {
    if g.save_rename_slot >= 0 { return }
    if !rl.IsKeyPressed(.FIVE) { return }
    any_owned := false
    for owned in g.owned_animal_buddies { if owned { any_owned = true; break } }
    if !any_owned {
        show_message("You don't own any animal buddies! Buy one at the Market.")
        return
    }
    g.animal_menu_open   = !g.animal_menu_open
    g.animal_menu_cursor = 0
}

update_animal_menu :: proc() {
    if !g.animal_menu_open { return }

    if rl.IsKeyPressed(.UP) {
        g.animal_menu_cursor -= 1
        if g.animal_menu_cursor < 0 { g.animal_menu_cursor = ANIMAL_BUDDY_COUNT }
    }
    if rl.IsKeyPressed(.DOWN) {
        g.animal_menu_cursor += 1
        if g.animal_menu_cursor > ANIMAL_BUDDY_COUNT { g.animal_menu_cursor = 0 }
    }
    if rl.IsKeyPressed(.ENTER) || rl.IsKeyPressed(.KP_ENTER) {
        if g.animal_menu_cursor == ANIMAL_BUDDY_COUNT {
            g.animal_buddy.visible = false
            show_message("Your animal buddy is resting at home.", 2)
        } else {
            kind := AnimalBuddyType(g.animal_menu_cursor)
            if g.owned_animal_buddies[kind] {
                spawn_animal_buddy(kind)
                show_message(fmt.aprintf("Your %s is now following you!",
                    ANIMAL_BUDDY_NAMES[kind], allocator = context.temp_allocator), 3)
            } else {
                show_message("You don't own that animal yet!")
            }
        }
        g.animal_menu_open = false
    }
    if rl.IsKeyPressed(.ESCAPE) { g.animal_menu_open = false }
}

draw_animal_menu :: proc() {
    if !g.animal_menu_open { return }
    pw :: f32(240); ph :: f32(200)
    px := f32(GAME_W)/2 - pw/2
    py := f32(GAME_H)/2 - ph/2
    draw_panel(px, py, pw, ph, "=== ANIMAL BUDDIES ===")

    row_h      := f32(28)
    pad_top    := f32(22)
    pad_bottom := f32(16) // reserved so the list never draws over the footer hint text
    list_top   := py + pad_top
    list_h     := ph - pad_top - pad_bottom

    total_items := ANIMAL_BUDDY_COUNT + 1 // +1 for "None"
    max_scroll  := max(f32(total_items) * row_h - list_h, 0)

    // Keep the selected row centered in the visible window, clamped to valid range
    target_scroll := f32(g.animal_menu_cursor) * row_h - list_h/2 + row_h/2
    scroll := clamp(target_scroll, 0, max_scroll)

    rl.BeginScissorMode(pxi(px), pxi(list_top), pxi(pw), pxi(list_h))

    for i in 0..<ANIMAL_BUDDY_COUNT {
        kind := AnimalBuddyType(i)
        by   := list_top + f32(i)*row_h - scroll
        if by + row_h < list_top || by > list_top + list_h { continue } // skip off-screen rows

        owned := g.owned_animal_buddies[kind]
        label: string
        if owned {
            active_str := " [ACTIVE]" if g.animal_buddy.visible && g.animal_buddy.kind == kind else ""
            label = fmt.aprintf("%s%s", ANIMAL_BUDDY_NAMES[i], active_str, allocator = context.temp_allocator)
        } else {
            label = fmt.aprintf("%s [LOCKED]", ANIMAL_BUDDY_NAMES[i], allocator = context.temp_allocator)
        }
        selected := (g.animal_menu_cursor == i)
        text_col := COL_TEXT if owned else COL_TEXT2
        rl.DrawRectangle(pxi(px)+8, pxi(by), pxi(pw)-16, 24, COL_BTN_HOV if selected else COL_BTN)
        rl.DrawRectangleLinesEx({px+8, by, pw-16, 24}, 1, COL_HONEY2 if selected else COL_PANEL_BORDER)
        rl.DrawText(strings.clone_to_cstring(label, context.temp_allocator), pxi(px)+14, pxi(by)+7, 8, text_col)
    }

    none_by := list_top + f32(ANIMAL_BUDDY_COUNT)*row_h - scroll
    if none_by + row_h >= list_top && none_by <= list_top + list_h {
        none_sel := (g.animal_menu_cursor == ANIMAL_BUDDY_COUNT)
        rl.DrawRectangle(pxi(px)+8, pxi(none_by), pxi(pw)-16, 24, COL_BTN_HOV if none_sel else COL_BTN)
        rl.DrawRectangleLinesEx({px+8, none_by, pw-16, 24}, 1, COL_HONEY2 if none_sel else COL_PANEL_BORDER)
        rl.DrawText("None", pxi(px)+14, pxi(none_by)+7, 8, COL_TEXT)
    }

    rl.EndScissorMode()

    if scroll > 0 {
        rl.DrawTriangle(
            {f32(pxi(px+pw/2-4)), f32(pxi(list_top+2))},
            {f32(pxi(px+pw/2+4)), f32(pxi(list_top+2))},
            {f32(pxi(px+pw/2)),   f32(pxi(list_top-2))},
            rl.Color{200,200,200,200},
        )
    }
    if scroll < max_scroll {
        arrow_y := list_top + list_h
        rl.DrawTriangle(
            {f32(pxi(px+pw/2-4)), f32(pxi(arrow_y-2))},
            {f32(pxi(px+pw/2)),   f32(pxi(arrow_y+2))},
            {f32(pxi(px+pw/2+4)), f32(pxi(arrow_y-2))},
            rl.Color{200,200,200,200},
        )
    }

    rl.DrawText("UP/DOWN: Select  ENTER: Confirm  5: Close", pxi(px)+8, pxi(py)+pxi(ph)-14, 7, {140,140,100,200})
}


spawn_animal_buddy :: proc(kind: AnimalBuddyType) {
    g.animal_buddy.pos       = {g.player.pos.x - 30, g.player.pos.y + 10}
    g.animal_buddy.visible   = true
    g.animal_buddy.kind      = kind
    g.animal_buddy.anim_time = 0

    if kind == .Turtle {
        g.animal_buddy.bandana_idx = (g.animal_buddy.bandana_idx + 1) % BANDANA_COLOR_COUNT
    }
}

update_animal_buddy :: proc() {
    if g.save_rename_slot >= 0 { return }
    if !g.animal_buddy.visible { return }
    a := &g.animal_buddy
    a.anim_time += g.dt * 4.0

    dir := Vec2{g.player.pos.x - a.pos.x, g.player.pos.y - a.pos.y}
    d   := math.sqrt(dir.x*dir.x + dir.y*dir.y)
    if d > ANIMAL_BUDDY_FOLLOW_DIST {
        move := min(d - ANIMAL_BUDDY_FOLLOW_DIST, ANIMAL_BUDDY_FOLLOW_SPEED * g.dt)
        a.pos.x += (dir.x/d) * move
        a.pos.y += (dir.y/d) * move
    }
}




update_planting :: proc() {
    if g.save_rename_slot >= 0 { return }
    if g.in_car { return }
    pp := g.player.pos

    plot_idx := -1
    for i in 0..<len(g.plots) {
        p := &g.plots[i]
        if !p.owner_is_player { continue }
        if pp.x >= p.rect.x && pp.x <= p.rect.x + p.rect.width &&
           pp.y >= p.rect.y && pp.y <= p.rect.y + p.rect.height {
            plot_idx = i
            break
        }
    }

    if rl.IsKeyPressed(.F) {
        if plot_idx < 0 {
            show_message("You must be standing on your own land to plant flowers!")
            return
        }
        if net_state.role == .Client {
            net_request_plot_action(plot_idx, .PlantFlower, pp)
            return
        }
        ok, msg := apply_plant_flower(plot_idx, pp)
        show_message(msg)
        if ok && net_state.role == .Host { net_broadcast_world_snapshot() }
    }

    if rl.IsKeyPressed(.T) {
        if plot_idx < 0 {
            show_message("You must be standing on your own land to plant trees!")
            return
        }
        if net_state.role == .Client {
            net_request_plot_action(plot_idx, .PlantTree, pp)
            return
        }
        ok, msg := apply_plant_tree(plot_idx, pp)
        show_message(msg)
        if ok && net_state.role == .Host { net_broadcast_world_snapshot() }
    }
}

update_queen_bee_deploy :: proc() {
    if g.save_rename_slot >= 0 { return }
    if g.in_car { return }
    if !rl.IsKeyPressed(.Q) { return }

    if g.inv_queen_bees <= 0 {
        show_message("No queen bees in inventory! Buy one at the Market.")
        return
    }

    pp := g.player.pos

    if net_state.role == .Client {
        net_request_plot_action(-1, .DeployQueen, pp)
        return
    }

    ok, msg := apply_deploy_queen(pp)
    show_message(msg, 3)
    if ok && net_state.role == .Host { net_broadcast_world_snapshot() }
}

update_world :: proc() {
    if g.death_active { return }

    g.dt = rl.GetFrameTime()
    g.total_play_time += g.dt
    g.input_c_consumed = false
    g.input_e_consumed = false
    
    update_bee_cam_toggle()

    if g.bee_cam_active {
	update_bee_cam()
	update_bee_cam_camera()
    } else {
	try_enter_exit_car()
	if g.in_car {
	    update_car()
	} else {
	    update_player()
	}
	update_camera()
    }

    update_npcs()
    update_environment()
    update_festival(g.dt)
    update_festival_npcs(g.dt)
    update_bee_boxes()
    update_factory_indoor_box()
    update_soccer()
    update_animals()
    update_pond()
    update_fishing_minigame()
    update_birds()
    update_park_bear()
    update_bee_swarm()
    update_yoda()
    update_animal_buddy()
    update_lightning_bug_catching()
    update_lightning_bugs()

    if !g.bee_cam_active {
        update_interactions()
        update_planting()
        update_queen_bee_deploy()
    }

    update_message()
    update_minimap_toggle()
    update_inventory_toggle()
    update_bee_net_toggle()
    update_lantern_toggle()
    update_lightsaber_toggle()
    update_batarang_toggle()
    update_animal_menu_toggle()
    update_animal_menu()
    update_player_zoom_toggle()
    update_customize_toggle()
    update_customize_menu()
    update_festival_menu()
    update_edit_home_toggle()
    update_achievements_toggle()
    update_achievements_menu()
    update_stats_toggle()
    update_stats_menu()
    update_weather_toggle()
    update_weather_menu()
    update_camera_capture()
    update_camera_album()
    update_phone_toggle()
    update_phone_menu() 
    update_discovered_toggle()
    if rl.IsKeyPressed(.F5) {
	g.stats_open       = false
        g.menu_cursor      = 0
        g.save_rename_slot = -1
        g.state = .SaveMenu
    }

}


// UI HELPERS


draw_button :: proc(x, y, w, h: f32, label: string, font_size: i32 = 10) -> bool
 {
    rect    := rl.Rectangle{x, y, w, h}
    mouse   := rl.GetMousePosition()
    gm      := rl.Vector2{mouse.x / SCALE, mouse.y / SCALE}
    hovered := rl.CheckCollisionPointRec(gm, rect)
    col     := COL_BTN_HOV if hovered else COL_BTN
    rl.DrawRectangle(pxi(x)+2, pxi(y)+2, pxi(w), pxi(h), COL_SHADOW)
    rl.DrawRectangleRec(rect, col)
    rl.DrawRectangleLinesEx(rect, 1, COL_PANEL_BORDER)
    cstr := strings.clone_to_cstring(label, context.temp_allocator)
    tw   := rl.MeasureText(cstr, font_size)
    rl.DrawText(cstr, pxi(x)+pxi(w)/2-tw/2, pxi(y)+pxi(h)/2-font_size/2, font_size, COL_TEXT)
    return hovered && rl.IsMouseButtonPressed(.LEFT)
}

draw_panel :: proc(x, y, w, h: f32, title: string) {
    rl.DrawRectangle(pxi(x)+3, pxi(y)+3, pxi(w), pxi(h), {0,0,0,100})
    rl.DrawRectangle(pxi(x), pxi(y), pxi(w), pxi(h), COL_PANEL)
    rl.DrawRectangle(pxi(x)+1, pxi(y)+1, pxi(w)-2, 1, {255,255,255,20})
    rl.DrawRectangle(pxi(x)+1, pxi(y)+1, 1, pxi(h)-2, {255,255,255,20})
    rl.DrawRectangleLinesEx({x, y, w, h}, 1, COL_PANEL_BORDER)
    rl.DrawRectangle(pxi(x)+1, pxi(y)+1, pxi(w)-2, 14, COL_PANEL2)
    rl.DrawRectangle(pxi(x)+1, pxi(y)+15, pxi(w)-2, 1, COL_PANEL_BORDER)
    cstr := strings.clone_to_cstring(title, context.temp_allocator)
    tw   := rl.MeasureText(cstr, 10)
    rl.DrawText(cstr, pxi(x)+pxi(w)/2-tw/2, pxi(y)+3, 10, COL_HONEY)
}

draw_menu_item :: proc(x, y, w, h: f32, label: string, index: int, font_size: i32 = 9) -> bool {
    selected := (g.menu_cursor == index)
    bg_col   := COL_BTN_HOV if selected else COL_BTN
    rl.DrawRectangle(pxi(x), pxi(y), pxi(w), pxi(h), bg_col)
    if selected {
        rl.DrawRectangleLinesEx({x, y, w, h}, 1, COL_HONEY2)
        rl.DrawText(">", pxi(x)+3, pxi(y)+pxi(h)/2-font_size/2, font_size, COL_HONEY2)
    } else {
        rl.DrawRectangleLinesEx({x, y, w, h}, 1, COL_PANEL_BORDER)
    }
    cstr := strings.clone_to_cstring(label, context.temp_allocator)
    rl.DrawText(cstr, pxi(x)+14, pxi(y)+pxi(h)/2-font_size/2, font_size, COL_TEXT)
    return selected && g.menu_action
}

close_menu :: proc() {
    if g.state == .ShopMenu || g.state == .BankMenu || g.state == .DinerMenu ||
       g.state == .BarMenu  || g.state == .DoctorMenu || g.state == .SheriffMenu ||
       g.state == .CarDealerMenu || g.state == .BeeSanctuaryMenu || 
       g.state == .FuzzyBuddyMenu {
        g.state = .Interior
    } else if g.state == .EditHomeColorMenu {
        idx := g.selected_home
        if idx >= 0 && idx < NUM_HOMES {
            g.homes[idx].color    = CUSTOMIZE_PALETTE[g.edit_home_color_backup_idx]
            g.edit_home_color_idx = g.edit_home_color_backup_idx
        }
        g.state = .EditHomeMenu
    } else if g.state == .HomeDecorateMenu || g.state == .HomeTrophyMenu {
        g.state = .HomeInterior
    } else if g.state == .HomeTrophyPickMenu {
        g.state = .HomeTrophyMenu
    } else {
        g.state = .World
    }
    g.menu_cursor = 0
    g.menu_action = false
    g.shop_page   = 0
    g.fbf_page    = 0
}

update_menu_input :: proc(item_count: int) {
    g.menu_action = false
    if g.menu_frame_skip { g.menu_frame_skip = false; return }
    if rl.IsKeyPressed(.UP)    { g.menu_cursor -= 1; if g.menu_cursor < 0 { g.menu_cursor = item_count - 1 } }
    if rl.IsKeyPressed(.DOWN)  { g.menu_cursor += 1; if g.menu_cursor >= item_count { g.menu_cursor = 0 } }
    if rl.IsKeyPressed(.ENTER) || rl.IsKeyPressed(.KP_ENTER) { g.menu_action = true }
}
draw_stats_menu :: proc() {
    if !g.stats_open { return }

    plots_owned := 0
    for i in 0..<len(g.plots) {
        if g.plots[i].owner_is_player { plots_owned += 1 }
    }

    unlocked_count := 0
    for u in g.achievements_unlocked {
        if u { unlocked_count += 1 }
    }
    ach_pct := f32(unlocked_count) / f32(ACHIEVEMENT_COUNT) * 100.0

    total_seconds := int(g.total_play_time)
    hrs  := total_seconds / 3600
    mins := (total_seconds % 3600) / 60
    secs := total_seconds % 60

    pw :: f32(280); ph :: f32(220)
    px := f32(GAME_W)/2 - pw/2
    py := f32(GAME_H)/2 - ph/2
    draw_panel(px, py, pw, ph, "=== FARM STATS ===")

    lines := [8]string{
        fmt.aprintf("Honey Produced:  %.1f L", g.total_honey_produced_ml/ML_PER_LITER, allocator = context.temp_allocator),
        fmt.aprintf("Honey Sold:      %.1f L", g.total_honey_sold_ml/ML_PER_LITER, allocator = context.temp_allocator),
        fmt.aprintf("Money Earned:    $%.0f", g.total_money_earned, allocator = context.temp_allocator),
        fmt.aprintf("Current Money:   $%.0f", g.player.money, allocator = context.temp_allocator),
        fmt.aprintf("Plots Owned:     %d", plots_owned, allocator = context.temp_allocator),
        fmt.aprintf("Achievements:    %.0f%%  (%d/%d)", ach_pct, unlocked_count, ACHIEVEMENT_COUNT, allocator = context.temp_allocator),
        fmt.aprintf("Donated Sanctuary: $%.0f", g.sanctuary_donated, allocator = context.temp_allocator),
        fmt.aprintf("Time Played:     %02d:%02d:%02d", hrs, mins, secs, allocator = context.temp_allocator),
    }

    for i in 0..<len(lines) {
        cstr := strings.clone_to_cstring(lines[i], context.temp_allocator)
        rl.DrawText(cstr, pxi(px)+12, pxi(py)+24+i32(i)*20, 8, COL_TEXT)
    }

    rl.DrawText("F4 | CLOSE", pxi(px)+8, pxi(py)+pxi(ph)-14, 7, {140,140,100,200})
}



// MENUS

   handle_car_dealer_menu :: proc() {
    pw :: f32(300)
    ph :: f32(220)
    px := f32(GAME_W)/2 - pw/2
    py := f32(GAME_H)/2 - ph/2

    car_labels := [3]string{
        "Pollen 911 BT3RS $45,000",
        "Buzz B-150       $38,000",
        "Rari B40 LM      $62,000",
    }
    car_costs := [3]f32{45000, 38000, 62000}

    if rl.IsKeyPressed(.UP)   { g.menu_cursor -= 1 }
    if rl.IsKeyPressed(.DOWN) { g.menu_cursor += 1 }
    if g.menu_cursor < 0 { g.menu_cursor = 3 }
    if g.menu_cursor > 3 { g.menu_cursor = 0 }

    rl.DrawRectangle(pxi(px)-2, pxi(py)-2, pxi(pw)+4, pxi(ph)+4, COL_PANEL_BORDER)
    rl.DrawRectangle(pxi(px), pxi(py), pxi(pw), pxi(ph), COL_PANEL)
    rl.DrawText("=== HONEYVILLE MOTORS ===", pxi(px)+8, pxi(py)+8, 9, COL_HONEY)
    rl.DrawText("Ready to start your engine?", pxi(px)+8, pxi(py)+22, 8, COL_TEXT2)

    for i in 0..<3 {
        col := COL_BTN_HOV if g.menu_cursor == i else COL_BTN
        rl.DrawRectangle(pxi(px)+8, pxi(py)+40+i32(i)*38, pxi(pw)-16, 28, col)
        rl.DrawText(
            strings.clone_to_cstring(car_labels[i], context.temp_allocator),
            pxi(px)+14, pxi(py)+48+i32(i)*38, 8, COL_TEXT)
    }

    leave_col := COL_BTN_HOV if g.menu_cursor == 3 else COL_BTN
    rl.DrawRectangle(pxi(px)+pxi(pw)/2-60, pxi(py)+pxi(ph)-36, 120, 24, leave_col)
    rl.DrawText("Exit Dealership", pxi(px)+pxi(pw)/2-18, pxi(py)+pxi(ph)-30, 9, COL_TEXT)

    rl.DrawText("UP/DOWN: Navigate   ENTER: Select",
        pxi(px)+8, pxi(py)+pxi(ph)-14, 7, {140,140,100,200})

    if rl.IsKeyPressed(.ENTER) || rl.IsKeyPressed(.SPACE) {
        if g.menu_cursor < 3 {
            ci := g.menu_cursor
            if g.cars[ci].owned {
                show_message("You already own that car!", 3)
            } else if g.player.money >= car_costs[ci] {
                g.player.money    -= car_costs[ci]
                g.cars[ci].owned   = true
                g.cars[ci].active  = true
                dealer_door_x := f32(-360) + f32(320)/2
                dealer_door_y := f32(560)  + f32(160)
                g.cars[ci].pos = {
                    dealer_door_x + f32(ci - 1) * 60,
                    dealer_door_y + 40,
                }
                g.cars[ci].angle = 0
                show_message(fmt.aprintf("You bought a %s! It's waiting outside!",
                    car_labels[ci], allocator = context.temp_allocator), 5)
            } else {
                show_message("Not enough honey money for that ride!", 3)
            }
        } else {
            close_menu()
        }
    }
}

handle_shop_menu :: proc() {
    if rl.IsKeyPressed(.RIGHT) {
        g.shop_page   = (g.shop_page + 1) % 4
        g.menu_cursor = 0
    }
    if rl.IsKeyPressed(.LEFT) {
        g.shop_page   = (g.shop_page + 3) % 4
        g.menu_cursor = 0
    }

    pw :: f32(320); ph :: f32(240)
    px := f32(GAME_W)/2 - pw/2; py := f32(GAME_H)/2 - ph/2

    switch g.shop_page {
    case 0: draw_shop_page_hives(px, py, pw, ph)
    case 1: draw_shop_page_seeds(px, py, pw, ph)
    case 2: draw_shop_page_sell(px, py, pw, ph)
    case 3: draw_shop_page_animals(px, py, pw, ph)
    }
}

draw_shop_header :: proc(px, py, pw: f32) {
    rl.DrawText(strings.clone_to_cstring(fmt.aprintf("Money: $%.2f",
        g.player.money, allocator = context.temp_allocator), context.temp_allocator),
        pxi(px)+8, pxi(py)+20, 9, COL_GREEN_TEXT)
    rl.DrawText(strings.clone_to_cstring(fmt.aprintf("Honey: %.1f ml",
        g.player.honey_ml, allocator = context.temp_allocator), context.temp_allocator),
        pxi(px)+8, pxi(py)+31, 8, COL_HONEY)
}

draw_shop_footer :: proc(px, py, pw, ph: f32, close_index: int) {
    if draw_menu_item(px+8, py+ph-40, pw-16, 24, "Close Menu", close_index) { close_menu() }
    rl.DrawText("LEFT/RIGHT: Page   UP/DOWN: Navigate   ENTER: Select",
        pxi(px)+8, pxi(py)+pxi(ph)-14, 7, {140,140,100,200})
}

draw_shop_page_hives :: proc(px, py, pw, ph: f32) {
    NUM_ITEMS :: 4
    update_menu_input(NUM_ITEMS)
    draw_panel(px, py, pw, ph, "=== MARKET (1/4): BEE HIVES ===")
    draw_shop_header(px, py, pw)

    rl.DrawText("-- BUY BEE HIVES --", pxi(px)+8, pxi(py)+44, 9, COL_TEXT)
    for i in 0..<3 {
        item := g.shop_items[i]
        by   := py + 56 + f32(i)*38
        if g.player.owned_plot < 0 {
            rl.DrawRectangle(pxi(px)+8, pxi(by), pxi(pw)-16, 28, COL_BTN)
            rl.DrawRectangleLinesEx({px+8, by, pw-16, 28}, 1, COL_PANEL_BORDER)
            rl.DrawText(strings.clone_to_cstring(item.label, context.temp_allocator),
                pxi(px)+22, pxi(by)+9, 8, COL_TEXT2)
            rl.DrawText("(Buy land first)", pxi(px)+200, pxi(by)+9, 8, COL_RED_TEXT)
        } else {
            if draw_menu_item(px+8, by, pw-16, 28, item.label, i) {
                if g.player.money >= item.cost {
                    g.hive_address_kind   = item.kind
                    g.hive_address_cursor = 0
                    g.menu_action = false
                    g.state = .HiveAddressMenu
                } else { show_message("Not enough money!") }
            }
        }
    }

    draw_shop_footer(px, py, pw, ph, 3)
}
draw_shop_page_seeds :: proc(px, py, pw, ph: f32) {
    ph2 :: f32(280)
    NUM_ITEMS :: 5
    update_menu_input(NUM_ITEMS)
    draw_panel(px, py, pw, ph2, "=== MARKET (2/4): SEEDS & GEAR ===")
    draw_shop_header(px, py, pw)

    rl.DrawText("-- BUY SEEDS --", pxi(px)+8, pxi(py)+44, 9, COL_TEXT)

    flower_label := fmt.aprintf("Flower Seed x1  ($%.0f)  [Have: %d]",
        FLOWER_SEED_COST, g.inv_flower_seeds, allocator = context.temp_allocator)
    if draw_menu_item(px+8, py+56, pw-16, 28, flower_label, 0) {
        if g.player.money >= FLOWER_SEED_COST {
            g.player.money      -= FLOWER_SEED_COST
            g.inv_flower_seeds  += 1
            show_message(fmt.aprintf("Bought 1 flower seed! Press F on your land to plant. Seeds: %d",
                g.inv_flower_seeds, allocator = context.temp_allocator))
        } else { show_message("Not enough money!") }
    }

    tree_label := fmt.aprintf("Tree Seed x1    ($%.0f)  [Have: %d]",
        TREE_SEED_COST, g.inv_tree_seeds, allocator = context.temp_allocator)
    if draw_menu_item(px+8, py+94, pw-16, 28, tree_label, 1) {
        if g.player.money >= TREE_SEED_COST {
            g.player.money    -= TREE_SEED_COST
            g.inv_tree_seeds  += 1
            show_message(fmt.aprintf("Bought 1 tree seed! Press T on your land to plant. Seeds: %d",
                g.inv_tree_seeds, allocator = context.temp_allocator))
        } else { show_message("Not enough money!") }
    }

    rl.DrawLine(pxi(px)+4, pxi(py)+128, pxi(px)+pxi(pw)-4, pxi(py)+128, COL_PANEL_BORDER)
    rl.DrawText("-- QUEEN BEE UPGRADE --", pxi(px)+8, pxi(py)+132, 9, COL_TEXT)

    queen_label := fmt.aprintf("Queen Bee x1  ($%.0f)  [Have: %d]",
        QUEEN_BEE_COST, g.inv_queen_bees, allocator = context.temp_allocator)
    if draw_menu_item(px+8, py+144, pw-16, 28, queen_label, 2) {
        if g.player.money >= QUEEN_BEE_COST {
            g.player.money    -= QUEEN_BEE_COST
            g.inv_queen_bees  += 1
            show_message(fmt.aprintf("Bought a Queen Bee! Press Q near a bee box on your land to deploy her. Queen bees: %d",
                g.inv_queen_bees, allocator = context.temp_allocator), 4)
        } else { show_message("Not enough money!") }
    }

    rl.DrawLine(pxi(px)+4, pxi(py)+178, pxi(px)+pxi(pw)-4, pxi(py)+178, COL_PANEL_BORDER)
    rl.DrawText("-- GEAR --", pxi(px)+8, pxi(py)+182, 9, COL_TEXT)

    bee_net_label: string
    if g.inv_bee_net {
        bee_net_label = "Bee Net  [OWNED - Press 0]"
    } else {
        bee_net_label = fmt.aprintf("Bee Net  ($%.0f)", BEE_NET_COST, allocator = context.temp_allocator)
    }
    if draw_menu_item(px+8, py+194, pw-16, 28, bee_net_label, 3) {
        if g.inv_bee_net {
            show_message("You already own a Bee Net!")
        } else if g.player.money >= BEE_NET_COST {
            g.player.money -= BEE_NET_COST
            g.inv_bee_net   = true
            show_message("Bought a Bee Net! Press 0 to equip it", 5)
        } else { show_message("Not enough money!") }
    }

    draw_shop_footer(px, py, pw, ph2, 4)
}

draw_shop_page_sell :: proc(px, py, pw, ph: f32) {
    NUM_ITEMS :: 2
    update_menu_input(NUM_ITEMS)
    draw_panel(px, py, pw, ph, "=== MARKET (3/4): SELL ===")
    draw_shop_header(px, py, pw)

    rl.DrawText("-- SELL HONEY --", pxi(px)+8, pxi(py)+44, 9, COL_TEXT)

    honey_val := (g.player.honey_ml / ML_PER_LITER) * honey_value_per_liter()
    sell_str  := fmt.aprintf("Sell all honey  ($%.2f)", honey_val, allocator = context.temp_allocator)
    if draw_menu_item(px+8, py+56, pw-16, 28, sell_str, 0) {
        if g.player.honey_ml > 0 {
	    g.total_honey_sold_ml += g.player.honey_ml
	    g.total_money_earned  += honey_val
            g.player.money        += honey_val
            g.player.honey_ml  = 0
            show_message(fmt.aprintf("Sold honey for $%.2f!", honey_val,
                allocator = context.temp_allocator))
            unlock_achievement(ACH_SOLD_BANK)
        } else { show_message("No honey to sell!") }
    }

    draw_shop_footer(px, py, pw, ph, 1)
}
draw_shop_page_animals :: proc(px, py, pw, ph: f32) {
    ph2 :: f32(260)
    NUM_ITEMS :: ANIMAL_BUDDY_COUNT + 1
    update_menu_input(NUM_ITEMS)
    draw_panel(px, py, pw, ph2, "=== MARKET (4/4): ANIMAL BUDDIES ===")
    draw_shop_header(px, py, pw)
    rl.DrawText("-- ADOPT AN ANIMAL BUDDY --", pxi(px)+8, pxi(py)+44, 9, COL_TEXT)

    row_h       := f32(34)
    list_top    := py + 56
    list_bottom := py + ph2 - 44
    list_h      := list_bottom - list_top

    max_scroll := max(f32(ANIMAL_BUDDY_COUNT) * row_h - list_h, 0)

    cursor_for_scroll := min(g.menu_cursor, ANIMAL_BUDDY_COUNT - 1)
    target_scroll := f32(cursor_for_scroll) * row_h - list_h/2 + row_h/2
    scroll := clamp(target_scroll, 0, max_scroll)
    if g.menu_cursor == ANIMAL_BUDDY_COUNT { scroll = max_scroll }

    rl.BeginScissorMode(pxi(px), pxi(list_top), pxi(pw), pxi(list_h))

    for i in 0..<ANIMAL_BUDDY_COUNT {
        kind := AnimalBuddyType(i)
        by   := list_top + f32(i)*row_h - scroll
        if by + row_h < list_top || by > list_bottom { continue }

        label: string
        if g.owned_animal_buddies[kind] {
            label = fmt.aprintf("%s  [OWNED - Press 5 to follow]", ANIMAL_BUDDY_NAMES[i], allocator = context.temp_allocator)
        } else {
            label = fmt.aprintf("%s  ($%.0f)", ANIMAL_BUDDY_NAMES[i], ANIMAL_BUDDY_COSTS[i], allocator = context.temp_allocator)
        }
        if draw_menu_item(px+8, by, pw-16, 28, label, i) {
            if g.owned_animal_buddies[kind] {
                show_message("You already own this animal buddy!")
            } else if g.player.money >= ANIMAL_BUDDY_COSTS[i] {
                g.player.money -= ANIMAL_BUDDY_COSTS[i]
                g.owned_animal_buddies[kind] = true
                show_message(fmt.aprintf("You adopted a %s! Press 5 to have it follow you.",
                    ANIMAL_BUDDY_NAMES[i], allocator = context.temp_allocator), 4)
            } else {
                show_message("Not enough money!")
            }
        }
    }

    rl.EndScissorMode()

    if scroll > 0 {
        rl.DrawTriangle(
            {px+pw/2-4, list_top+2}, {px+pw/2+4, list_top+2}, {px+pw/2, list_top-2},
            rl.Color{200,200,200,200},
        )
    }
    if scroll < max_scroll {
        rl.DrawTriangle(
            {px+pw/2-4, list_bottom-2}, {px+pw/2, list_bottom+2}, {px+pw/2+4, list_bottom-2},
            rl.Color{200,200,200,200},
        )
    }

    draw_shop_footer(px, py, pw, ph2, ANIMAL_BUDDY_COUNT)
}

handle_hive_address_menu :: proc() {
    owned_plots := make([dynamic]int, context.temp_allocator)
    for i in 0..<len(g.plots) {
        if g.plots[i].owner_is_player { append(&owned_plots, i) }
    }
    num_items := len(owned_plots) + 1
    update_menu_input(num_items)

    pw :: f32(320); ph :: f32(260)
    px := f32(GAME_W)/2 - pw/2; py := f32(GAME_H)/2 - ph/2
    draw_panel(px, py, pw, ph, "=== SELECT PLOT ADDRESS ===")
    rl.DrawText("Choose a plot to install the hive:", pxi(px)+8, pxi(py)+22, 8, COL_TEXT)

    item := g.shop_items[int(g.hive_address_kind)]

    for i in 0..<len(owned_plots) {
        pi   := owned_plots[i]
        plot := &g.plots[pi]
        by   := py + 38 + f32(i)*32
        addr_label := fmt.aprintf("%s  [%s]  Hives: %d", plot.address, plot_size_label(plot.size), len(plot.boxes), allocator = context.temp_allocator)
        if draw_menu_item(px+8, by, pw-16, 26, addr_label, i) {
            if net_state.role == .Client {
                net_request_plot_action(pi, .PlaceBox, Vec2{}, g.hive_address_kind)
                g.menu_action = false
                g.state = .ShopMenu
                g.menu_cursor = 0
            } else {
                ok, result_msg := apply_place_box(pi, g.hive_address_kind)
                show_message(result_msg)
                if ok {
                    if net_state.role == .Host { net_broadcast_world_snapshot() }
                    g.menu_action = false
                    g.state = .ShopMenu
                    g.menu_cursor = 0
                }
            }
        }
    }
    cancel_idx := len(owned_plots)
    if draw_menu_item(px+8, py+ph-34, pw-16, 26, "Cancel", cancel_idx) {
        g.menu_action = false
        g.state = .ShopMenu
        g.menu_cursor = 0
    }
    rl.DrawText("UP/DOWN: Navigate   ENTER: Select", pxi(px)+8, pxi(py)+pxi(ph)-14, 7, {140,140,100,200})
}
handle_land_menu :: proc() {
    idx := g.selected_plot
    if idx < 0 || idx >= len(g.plots) { close_menu(); return }
    plot := &g.plots[idx]
    NUM_ITEMS :: 2
    update_menu_input(NUM_ITEMS)
    pw :: f32(280); ph :: f32(220)
    px := f32(GAME_W)/2 - pw/2; py := f32(GAME_H)/2 - ph/2
    draw_panel(px, py, pw, ph, "=== LAND FOR SALE ===")
    rl.DrawText(strings.clone_to_cstring(fmt.aprintf("Address: %s", plot.address, allocator = context.temp_allocator), context.temp_allocator), pxi(px)+10, pxi(py)+22, 8, COL_HONEY2)
    rl.DrawText(strings.clone_to_cstring(fmt.aprintf("Size:   %s",    plot_size_label(plot.size), allocator = context.temp_allocator), context.temp_allocator), pxi(px)+10, pxi(py)+34, 9, COL_TEXT)
    rl.DrawText(strings.clone_to_cstring(fmt.aprintf("Price:  $%.0f", plot.cost, allocator = context.temp_allocator), context.temp_allocator), pxi(px)+10, pxi(py)+48, 9, COL_HONEY)
    rl.DrawText(strings.clone_to_cstring(fmt.aprintf("Money:  $%.2f", g.player.money, allocator = context.temp_allocator), context.temp_allocator), pxi(px)+10, pxi(py)+62, 9, COL_GREEN_TEXT)
    rl.DrawText(strings.clone_to_cstring(fmt.aprintf("Trees: %d   Flowers: %d", len(plot.trees), len(plot.flowers), allocator = context.temp_allocator), context.temp_allocator), pxi(px)+10, pxi(py)+76, 8, COL_TREE_LEAF)
    if draw_menu_item(px+10, py+ph-64, 120, 26, "Buy Plot", 0) {
        if net_state.role == .Client {
            net_request_plot_action(idx, .BuyPlot, g.player.pos)
            close_menu()
        } else {
            ok, msg := apply_buy_plot(idx)
            show_message(msg)
            if ok {
                if net_state.role == .Host { net_broadcast_world_snapshot() }
                close_menu()
            }
        }
    }
    if draw_menu_item(px+pw-136, py+ph-64, 120, 26, "Cancel", 1) { close_menu() 
}
    rl.DrawText("UP/DOWN: Navigate   ENTER: Select", pxi(px)+8, pxi(py)+pxi(ph)-14, 7, {140,140,100,200})
}


handle_home_menu :: proc() {
    idx := g.selected_home
    if idx < 0 || idx >= NUM_HOMES { close_menu(); return }
    home := &g.homes[idx]
    num_items := 2
    update_menu_input(num_items)
    pw :: f32(280); ph :: f32(210)
    px := f32(GAME_W)/2 - pw/2; py := f32(GAME_H)/2 - ph/2
    title := fmt.aprintf("=== %s ===", home.label, allocator = context.temp_allocator)
    draw_panel(px, py, pw, ph, title)
    if home.owned {
	rl.DrawText("This is your home!", pxi(px)+10, pxi(py)+24, 9, COL_GREEN_TEXT)
	rl.DrawText("Honey production +10% bonus", pxi(px)+10, pxi(py)+40, 8, COL_TEXT2)
	if draw_menu_item(px+10, py+ph-70, pw-20, 26, "Enter Home", 0) {
	    enter_home_interior(idx)
	}
	if draw_menu_item(px+10, py+ph-40, pw-20, 26, "Leave", 1) { close_menu() }
    } else {
        rl.DrawText(strings.clone_to_cstring(fmt.aprintf("Price:  $%.0f", HOME_COST, allocator = context.temp_allocator), context.temp_allocator), pxi(px)+10, pxi(py)+24, 9, COL_HONEY)
        rl.DrawText(strings.clone_to_cstring(fmt.aprintf("Money:  $%.2f", g.player.money, allocator = context.temp_allocator), context.temp_allocator), pxi(px)+10, pxi(py)+38, 9, COL_GREEN_TEXT)
        if draw_menu_item(px+10, py+ph-64, 120, 26, "Buy Home", 0) {
            if g.player.money >= HOME_COST {
                g.player.money -= HOME_COST; home.owned = true
                show_message(fmt.aprintf("You bought %s!", home.label, allocator = context.temp_allocator))
		unlock_achievement(ACH_BOUGHT_HOME)
                close_menu()
            } else { show_message("Not enough money!") }
        }
        if draw_menu_item(px+pw-136, py+ph-64, 120, 26, "Cancel", 1) { close_menu() }
    }
    rl.DrawText("UP/DOWN: Navigate   ENTER: Select", pxi(px)+8, pxi(py)+pxi(ph)-14, 7, {140,140,100,200})
}

handle_edit_home_menu :: proc() {
    num_items := NUM_HOMES + 1
    update_menu_input(num_items)

    pw :: f32(280); ph :: f32(240)
    px := f32(GAME_W)/2 - pw/2; py := f32(GAME_H)/2 - ph/2
    draw_panel(px, py, pw, ph, "=== EDIT HOME ===")
    rl.DrawText("Select an owned home to customize:", pxi(px)+8, pxi(py)+20, 8, COL_TEXT)

    for i in 0..<NUM_HOMES {
        home := &g.homes[i]
        by   := py + 32 + f32(i)*32

        selected := (g.menu_cursor == i)
        bg := COL_BTN_HOV if selected else COL_BTN
        rl.DrawRectangle(pxi(px)+8, pxi(by), pxi(pw)-16, 26, bg)
        border_col := COL_HONEY2 if selected else COL_PANEL_BORDER
        rl.DrawRectangleLinesEx({px+8, by, pw-16, 26}, 1, border_col)

        rl.DrawRectangle(pxi(px)+14, pxi(by)+6, 14, 14, home.color)
        rl.DrawRectangleLinesEx({px+14, by+6, 14, 14}, 1, {0,0,0,150})

        label: string
        text_col: rl.Color
        if home.owned {
            label    = home.label
            text_col = COL_TEXT
        } else {
            label    = fmt.aprintf("%s  [LOCKED - not owned]", home.label,
                allocator = context.temp_allocator)
            text_col = COL_TEXT2
        }
        rl.DrawText(strings.clone_to_cstring(label, context.temp_allocator),
            pxi(px)+34, pxi(by)+9, 8, text_col)

        if selected && g.menu_action {
            if home.owned {
                g.selected_home              = i
                g.edit_home_color_idx        = find_palette_index(home.color)
                if g.edit_home_color_idx < 0 { g.edit_home_color_idx = 0 }
                g.edit_home_color_backup_idx = g.edit_home_color_idx
                g.menu_cursor                = 0
                g.state                      = .EditHomeColorMenu
            } else {
                show_message("You don't own that home yet — buy it first!")
            }
        }
    }

    if draw_menu_item(px+8, py+ph-34, pw-16, 26, "Close", NUM_HOMES) { close_menu() }
    rl.DrawText("UP/DOWN: Navigate   ENTER: Select", pxi(px)+8,
        pxi(py)+pxi(ph)-14, 7, {140,140,100,200})
}
EDIT_HOME_ROW_COLOR  :: 0
EDIT_HOME_ROW_SAVE   :: 1
EDIT_HOME_ROW_CANCEL :: 2
EDIT_HOME_ROW_COUNT  :: 3

handle_edit_home_color_menu :: proc() {
    idx := g.selected_home
    if idx < 0 || idx >= NUM_HOMES || !g.homes[idx].owned {
        g.state = .EditHomeMenu
        return
    }
    home := &g.homes[idx]

    if rl.IsKeyPressed(.UP) {
        g.menu_cursor -= 1
        if g.menu_cursor < 0 { g.menu_cursor = EDIT_HOME_ROW_COUNT - 1 }
    }
    if rl.IsKeyPressed(.DOWN) {
        g.menu_cursor += 1
        if g.menu_cursor >= EDIT_HOME_ROW_COUNT { g.menu_cursor = 0 }
    }

    if g.menu_cursor == EDIT_HOME_ROW_COLOR {
        if rl.IsKeyPressed(.RIGHT) {
            g.edit_home_color_idx = (g.edit_home_color_idx + 1) % CUSTOMIZE_PALETTE_COUNT
        }
        if rl.IsKeyPressed(.LEFT) {
            g.edit_home_color_idx = (g.edit_home_color_idx - 1 + CUSTOMIZE_PALETTE_COUNT) % CUSTOMIZE_PALETTE_COUNT
        }
    }

    home.color = CUSTOMIZE_PALETTE[g.edit_home_color_idx]

    if rl.IsKeyPressed(.ENTER) || rl.IsKeyPressed(.KP_ENTER) {
        switch g.menu_cursor {
        case EDIT_HOME_ROW_SAVE:
            g.edit_home_color_backup_idx = g.edit_home_color_idx
            show_message(fmt.aprintf("%s's exterior color updated!", home.label,
                allocator = context.temp_allocator), 3)
            g.state       = .EditHomeMenu
            g.menu_cursor = idx
        case EDIT_HOME_ROW_CANCEL:
            g.edit_home_color_idx = g.edit_home_color_backup_idx
            home.color             = CUSTOMIZE_PALETTE[g.edit_home_color_idx]
            g.state       = .EditHomeMenu
            g.menu_cursor = idx
        }
    }

    pw :: f32(260); ph :: f32(150)
    px := f32(GAME_W)/2 - pw/2; py := f32(GAME_H)/2 - ph/2
    title := fmt.aprintf("=== EDIT %s ===", home.label, allocator = context.temp_allocator)
    draw_panel(px, py, pw, ph, title)

    row_top :: f32(26); row_h :: f32(24)
    ry := py + row_top
    selected := (g.menu_cursor == EDIT_HOME_ROW_COLOR)
    bg := COL_BTN_HOV if selected else COL_BTN
    rl.DrawRectangle(pxi(px)+8, pxi(ry), pxi(pw)-16, 20, bg)
    rl.DrawRectangleLinesEx({px+8, ry, pw-16, 20}, 1, COL_HONEY2 if selected else COL_PANEL_BORDER)
    rl.DrawText("Exterior Color", pxi(px)+12, pxi(ry)+6, 8, COL_TEXT)

    value_x := pxi(px) + pxi(pw) - 86
    if selected { rl.DrawText("<", value_x-12, pxi(ry)+5, 9, COL_HONEY2) }
    rl.DrawRectangle(value_x, pxi(ry)+4, 24, 12, CUSTOMIZE_PALETTE[g.edit_home_color_idx])
    if selected { rl.DrawText(">", value_x+30, pxi(ry)+5, 9, COL_HONEY2) }
    rl.DrawText(strings.clone_to_cstring(CUSTOMIZE_PALETTE_NAMES[g.edit_home_color_idx],
        context.temp_allocator), pxi(px)+12, pxi(ry)+22, 7, COL_TEXT2)

    btn_y := ry + row_h + 14
    btn_w := (pw - 36) / 2
    save_sel := (g.menu_cursor == EDIT_HOME_ROW_SAVE)
    rl.DrawRectangle(pxi(px)+14, pxi(btn_y), pxi(btn_w), 22, COL_BTN_HOV if save_sel else COL_BTN)
    rl.DrawRectangleLinesEx({px+14, btn_y, btn_w, 22}, 1, COL_HONEY2 if save_sel else COL_PANEL_BORDER)
    rl.DrawText("Save", pxi(px)+14+pxi(btn_w)/2-14, pxi(btn_y)+6, 9, COL_GREEN_TEXT)

    cancel_x   := px + 14 + btn_w + 8
    cancel_sel := (g.menu_cursor == EDIT_HOME_ROW_CANCEL)
    rl.DrawRectangle(pxi(cancel_x), pxi(btn_y), pxi(btn_w), 22, COL_BTN_HOV if cancel_sel else COL_BTN)
    rl.DrawRectangleLinesEx({cancel_x, btn_y, btn_w, 22}, 1, COL_HONEY2 if cancel_sel else COL_PANEL_BORDER)
    rl.DrawText("Cancel", pxi(cancel_x)+pxi(btn_w)/2-18, pxi(btn_y)+6, 9, COL_RED_TEXT)

    rl.DrawText("LEFT/RIGHT: Change   UP/DOWN: Row   ENTER: Select", pxi(px)+8,
        pxi(py)+pxi(ph)-14, 7, {140,140,100,200})
}

handle_home_decorate_menu :: proc() {
    idx := g.interior_home
    if idx < 0 || idx >= NUM_HOMES { g.state = .HomeInterior; return }
    home := &g.homes[idx]

    if rl.IsKeyPressed(.UP)   { g.menu_cursor -= 1; if g.menu_cursor < 0 { g.menu_cursor = HOME_DECORATE_ROW_COUNT-1 } }
    if rl.IsKeyPressed(.DOWN) { g.menu_cursor += 1; if g.menu_cursor >= HOME_DECORATE_ROW_COUNT { g.menu_cursor = 0 } }

    wall_idx  := find_palette_index(home.interior_wall_color)
    floor_idx := find_palette_index(home.interior_floor_color)
    if wall_idx  < 0 { wall_idx  = 0 }
    if floor_idx < 0 { floor_idx = 0 }

    if g.menu_cursor == HOME_DECORATE_ROW_WALL {
        if rl.IsKeyPressed(.RIGHT) { wall_idx = (wall_idx + 1) % CUSTOMIZE_PALETTE_COUNT; home.interior_wall_color = CUSTOMIZE_PALETTE[wall_idx] }
        if rl.IsKeyPressed(.LEFT)  { wall_idx = (wall_idx - 1 + CUSTOMIZE_PALETTE_COUNT) % CUSTOMIZE_PALETTE_COUNT; home.interior_wall_color = CUSTOMIZE_PALETTE[wall_idx] }
    }
    if g.menu_cursor == HOME_DECORATE_ROW_FLOOR {
        if rl.IsKeyPressed(.RIGHT) { floor_idx = (floor_idx + 1) % CUSTOMIZE_PALETTE_COUNT; home.interior_floor_color = CUSTOMIZE_PALETTE[floor_idx] }
        if rl.IsKeyPressed(.LEFT)  { floor_idx = (floor_idx - 1 + CUSTOMIZE_PALETTE_COUNT) % CUSTOMIZE_PALETTE_COUNT; home.interior_floor_color = CUSTOMIZE_PALETTE[floor_idx] }
    }

    if rl.IsKeyPressed(.ENTER) || rl.IsKeyPressed(.KP_ENTER) {
        switch g.menu_cursor {
        case HOME_DECORATE_ROW_SAVE:   show_message("Home interior updated!", 2); g.state = .HomeInterior
        case HOME_DECORATE_ROW_CANCEL: g.state = .HomeInterior
        }
    }
    if rl.IsKeyPressed(.ESCAPE) { g.state = .HomeInterior }

    pw :: f32(260); ph :: f32(150)
    px := f32(GAME_W)/2 - pw/2; py := f32(GAME_H)/2 - ph/2
    draw_panel(px, py, pw, ph, "=== DECORATE HOME ===")

    row_top :: f32(26); row_h :: f32(24)
    labels := [2]string{"Wall Color", "Floor Color"}
    idxs   := [2]int{wall_idx, floor_idx}
    for i in 0..<2 {
        ry := py + row_top + f32(i)*row_h
        selected := (g.menu_cursor == i)
        bg := COL_BTN_HOV if selected else COL_BTN
        rl.DrawRectangle(pxi(px)+8, pxi(ry), pxi(pw)-16, 20, bg)
        rl.DrawRectangleLinesEx({px+8, ry, pw-16, 20}, 1, COL_HONEY2 if selected else COL_PANEL_BORDER)
        rl.DrawText(strings.clone_to_cstring(labels[i], context.temp_allocator), pxi(px)+12, pxi(ry)+6, 8, COL_TEXT)
        value_x := pxi(px) + pxi(pw) - 86
        rl.DrawRectangle(value_x, pxi(ry)+4, 24, 12, CUSTOMIZE_PALETTE[idxs[i]])
    }

    btn_y := py + row_top + 2*row_h + 10
    btn_w := (pw - 36) / 2
    save_sel := (g.menu_cursor == HOME_DECORATE_ROW_SAVE)
    rl.DrawRectangle(pxi(px)+14, pxi(btn_y), pxi(btn_w), 22, COL_BTN_HOV if save_sel else COL_BTN)
    rl.DrawText("Save", pxi(px)+14+pxi(btn_w)/2-14, pxi(btn_y)+6, 9, COL_GREEN_TEXT)
    cancel_x := px + 14 + btn_w + 8
    cancel_sel := (g.menu_cursor == HOME_DECORATE_ROW_CANCEL)
    rl.DrawRectangle(pxi(cancel_x), pxi(btn_y), pxi(btn_w), 22, COL_BTN_HOV if cancel_sel else COL_BTN)
    rl.DrawText("Cancel", pxi(cancel_x)+pxi(btn_w)/2-18, pxi(btn_y)+6, 9, COL_RED_TEXT)

    rl.DrawText("LEFT/RIGHT: Change  UP/DOWN: Row  ENTER: Select", pxi(px)+8, pxi(py)+pxi(ph)-14, 7, {140,140,100,200})
}

handle_home_trophy_menu :: proc() {
    idx := g.interior_home
    if idx < 0 || idx >= NUM_HOMES { g.state = .HomeInterior; return }
    home := &g.homes[idx]

    num_items := HOME_TROPHY_SLOTS + 1
    if rl.IsKeyPressed(.UP)   { g.menu_cursor -= 1; if g.menu_cursor < 0 { g.menu_cursor = num_items-1 } }
    if rl.IsKeyPressed(.DOWN) { g.menu_cursor += 1; if g.menu_cursor >= num_items { g.menu_cursor = 0 } }

    if rl.IsKeyPressed(.ENTER) || rl.IsKeyPressed(.KP_ENTER) {
        if g.menu_cursor == HOME_TROPHY_SLOTS {
            g.state = .HomeInterior
        } else {
            g.trophy_slot_editing = g.menu_cursor
            g.menu_cursor = 0
            g.state = .HomeTrophyPickMenu
        }
    }
    if rl.IsKeyPressed(.ESCAPE) { g.state = .HomeInterior }

    pw :: f32(280); ph :: f32(260)
    px := f32(GAME_W)/2 - pw/2; py := f32(GAME_H)/2 - ph/2
    draw_panel(px, py, pw, ph, "=== TROPHY CASE ===")
    rl.DrawText("Select a slot to assign a trophy:", pxi(px)+8, pxi(py)+20, 8, COL_TEXT)

    for i in 0..<HOME_TROPHY_SLOTS {
        by := py + 32 + f32(i)*30
        t  := home.trophies[i]
        label: string
        switch t.kind {
        case .Empty:  label = fmt.aprintf("Slot %d: (empty)", i+1, allocator = context.temp_allocator)
        case .Animal: label = fmt.aprintf("Slot %d: %s (Animal)", i+1, animal_label(t.animal), allocator = context.temp_allocator)
        case .Fish:   label = fmt.aprintf("Slot %d: %s (Fish)", i+1, fish_label(t.fish), allocator = context.temp_allocator)
        case .Photo:  label = fmt.aprintf("Slot %d: Photo (%s)", i+1, t.photo_file, allocator = context.temp_allocator)
        }
        draw_menu_item(px+8, by, pw-16, 26, label, i)
    }

    if draw_menu_item(px+8, py+ph-34, pw-16, 26, "Close", HOME_TROPHY_SLOTS) { g.state = .HomeInterior }
    rl.DrawText("UP/DOWN: Navigate   ENTER: Select", pxi(px)+8, pxi(py)+pxi(ph)-14, 7, {140,140,100,200})
}

handle_home_trophy_pick_menu :: proc() {
    idx := g.interior_home
    slot := g.trophy_slot_editing
    if idx < 0 || idx >= NUM_HOMES || slot < 0 || slot >= HOME_TROPHY_SLOTS {
        g.state = .HomeTrophyMenu; return
    }
    home := &g.homes[idx]
    confirm := rl.IsKeyPressed(.ENTER) || rl.IsKeyPressed(.KP_ENTER)
    if g.menu_frame_skip { confirm = false; g.menu_frame_skip = false }


    // Build the candidate list length: Empty + discovered animals + discovered fish + photos
    animal_list := make([dynamic]AnimalType, context.temp_allocator)
    for kind in AnimalType { if g.discovered_animals[kind] { append(&animal_list, kind) } }
    fish_list := make([dynamic]FishType, context.temp_allocator)
    for kind in FishType { if g.discovered_fish[kind] { append(&fish_list, kind) } }
    photo_count := len(g.camera_roll)

    num_items := 1 + len(animal_list) + len(fish_list) + photo_count + len(gallery_textures) + 1 // +1 Empty, +1 Cancel
    if rl.IsKeyPressed(.UP)   { g.menu_cursor -= 1; if g.menu_cursor < 0 { g.menu_cursor = num_items-1 } }
    if rl.IsKeyPressed(.DOWN) { g.menu_cursor += 1; if g.menu_cursor >= num_items { g.menu_cursor = 0 } }

    pw :: f32(300); ph :: f32(280)
    px := f32(GAME_W)/2 - pw/2; py := f32(GAME_H)/2 - ph/2
    title := fmt.aprintf("=== ASSIGN SLOT %d ===", slot+1, allocator = context.temp_allocator)
    draw_panel(px, py, pw, ph, title)

    row := 0
    by  := py + 24

    draw_menu_item(px+8, by, pw-16, 24, "(Clear slot)", row)
    if confirm && g.menu_cursor == row {
	home.trophies[slot] = Trophy{kind = .Empty}
	g.state = .HomeTrophyMenu
    }

    row += 1; by += 28

    for kind in animal_list {
    lbl := fmt.aprintf("Animal: %s", animal_label(kind), allocator = context.temp_allocator)
    draw_menu_item(px+8, by, pw-16, 24, lbl, row)
    if confirm && g.menu_cursor == row {
        home.trophies[slot] = Trophy{kind = .Animal, animal = kind}
        g.state = .HomeTrophyMenu
    }
    row += 1; by += 28
}

for kind in fish_list {
    lbl := fmt.aprintf("Fish: %s", fish_label(kind), allocator = context.temp_allocator)
    draw_menu_item(px+8, by, pw-16, 24, lbl, row)
    if confirm && g.menu_cursor == row {
        home.trophies[slot] = Trophy{kind = .Fish, fish = kind}
        g.state = .HomeTrophyMenu
    }
    row += 1; by += 28
}

for i in 0..<photo_count {
    photo := g.camera_roll[i]
    lbl := fmt.aprintf("Photo: %s", photo.filename, allocator = context.temp_allocator)
    draw_menu_item(px+8, by, pw-16, 24, lbl, row)
    if confirm && g.menu_cursor == row {
        tex := rl.LoadTexture(strings.clone_to_cstring(photo.filename, context.temp_allocator))
        home.trophies[slot] = Trophy{
            kind       = .Photo,
            photo_tex  = tex,
            photo_file = strings.clone(photo.filename),
        }
        g.state = .HomeTrophyMenu
    }
    row += 1; by += 28
}
for i in 0..<len(gallery_textures) {
    lbl := fmt.aprintf("Painting: %s", gallery_names[i], allocator = context.temp_allocator)
    draw_menu_item(px+8, by, pw-16, 24, lbl, row)
    if confirm && g.menu_cursor == row {
        home.trophies[slot] = Trophy{
            kind       = .Photo,
            photo_tex  = gallery_textures[i],
            photo_file = gallery_names[i],
        }
        g.state = .HomeTrophyMenu
    }
    row += 1; by += 28
}

draw_menu_item(px+8, by, pw-16, 24, "Cancel", row)
if confirm && g.menu_cursor == row {
    g.state = .HomeTrophyMenu
}
    rl.DrawText("UP/DOWN: Navigate   ENTER: Select", pxi(px)+8, pxi(py)+pxi(ph)-14, 7, {140,140,100,200})
    if rl.IsKeyPressed(.ESCAPE) { g.state = .HomeTrophyMenu }

}


handle_bank_menu :: proc() {
    NUM_ITEMS :: 3
    update_menu_input(NUM_ITEMS)
    pw :: f32(300); ph :: f32(250)
    px := f32(GAME_W)/2 - pw/2; py := f32(GAME_H)/2 - ph/2
    draw_panel(px, py, pw, ph, "= FIRST HONEY BANK =")
    rl.DrawText(strings.clone_to_cstring(fmt.aprintf("Balance:     $%.2f", g.player.money, allocator = context.temp_allocator), context.temp_allocator), pxi(px)+8, pxi(py)+22, 9, COL_GREEN_TEXT)
    honey_val := (g.player.honey_ml / ML_PER_LITER) * bank_honey_value_per_liter()
    val_line: string
    val_col:  rl.Color
    if auction_active() {
	val_line = fmt.aprintf("Honey Value: $%.2f  (RARE AUCTION x5!)", honey_val, allocator = context.temp_allocator)
	val_col  = COL_RED_TEXT
    } else {
	val_line = fmt.aprintf("Honey Value: $%.2f  (x%.1f season)", honey_val, honey_season_value_mult(), allocator = context.temp_allocator)
	val_col  = COL_HONEY
}
rl.DrawText(strings.clone_to_cstring(val_line, context.temp_allocator), pxi(px)+8, pxi(py)+36, 8, val_col)

    rl.DrawLine(pxi(px)+4, pxi(py)+52, pxi(px)+pxi(pw)-4, pxi(py)+52, COL_PANEL_BORDER)
    dep_str := fmt.aprintf("Deposit all honey ($%.2f)", honey_val, allocator = context.temp_allocator)
    if draw_menu_item(px+8, py+60, pw-16, 28, dep_str, 0) {
        if g.player.honey_ml > 0 {
            g.player.money += honey_val; g.player.honey_ml = 0
            show_message(fmt.aprintf("Deposited honey for $%.2f!", honey_val, allocator = context.temp_allocator))
        } else { show_message("No honey to deposit!") }
    }
    if draw_menu_item(px+8, py+94, pw-16, 28, "View Honey Stock Chart", 1) {
        g.bank_stock_cursor = 1
    }
    if g.bank_stock_cursor == 1 {
        draw_honey_stock_chart(px, py+130, pw, 80)
    } else {
        rl.DrawText("Honey Hours: 24/7", pxi(px)+8, pxi(py)+130, 8, {160,160,160,255})
        rl.DrawText("Member HDIC. Equal Honey Lender.", pxi(px)+8, pxi(py)+142, 7, {140,140,140,255})
        rl.DrawText("Honey Value by Season:", pxi(px)+8, pxi(py)+158, 8, COL_TEXT2)
        rl.DrawText("Spring: 0.8x  Summer: 1.0x", pxi(px)+8, pxi(py)+170, 7, COL_TEXT2)
        rl.DrawText("Fall:   2.0x  Winter: 3.0x", pxi(px)+8, pxi(py)+180, 7, COL_TEXT2)
    }
    if draw_menu_item(px+pw-136, py+ph-44, 120, 26, "Leave", 2) {
        g.bank_stock_cursor = 0
        close_menu()
    }
    rl.DrawText("UP/DOWN: Navigate   ENTER: Select", pxi(px)+8, pxi(py)+pxi(ph)-14, 7, {140,140,100,200})
}

draw_honey_stock_chart :: proc(px, py, pw, ph: f32) {
    rl.DrawRectangle(pxi(px)+4, pxi(py), pxi(pw)-8, pxi(ph), {10,8,4,220})
    rl.DrawRectangleLinesEx({px+4, py, pw-8, ph}, 1, COL_PANEL_BORDER)
    rl.DrawText("Honey $/L History", pxi(px)+8, pxi(py)+2, 7, COL_HONEY)
    if g.honey_stock_count == 0 {
        rl.DrawText("No data yet.", pxi(px)+8, pxi(py)+20, 7, COL_TEXT2)
        return
    }
    max_val := f32(0)
    for i in 0..<g.honey_stock_count {
        if g.honey_stock_history[i] > max_val { max_val = g.honey_stock_history[i] }
    }
    if max_val <= 0 { max_val = 1 }
    bar_area_w := pw - 20
    bar_w      := bar_area_w / f32(g.honey_stock_count)
    chart_h    := ph - 22
    for i in 0..<g.honey_stock_count {
        v    := g.honey_stock_history[i]
        bh   := (v / max_val) * chart_h
        bx   := px + 12 + f32(i)*bar_w
        by   := py + ph - bh - 4
        col: rl.Color
        switch g.honey_stock_season[i] {
        case .Spring: col = {100, 220, 100, 255}
        case .Summer: col = {255, 200,  40, 255}
        case .Fall:   col = {220, 120,  40, 255}
        case .Winter: col = {160, 200, 240, 255}
        }
        rl.DrawRectangle(pxi(bx), pxi(by), max(pxi(bar_w)-1, 1), pxi(bh), col)
        val_str := fmt.aprintf("%.0f", v, allocator = context.temp_allocator)
        rl.DrawText(strings.clone_to_cstring(val_str, context.temp_allocator), pxi(bx), pxi(by)-8, 6, COL_TEXT2)
    }
}
handle_fuzzy_buddy_menu :: proc() {
    if rl.IsKeyPressed(.RIGHT) {
        g.fbf_page    = (g.fbf_page + 1) % 3
        g.menu_cursor = 0
    }
    if rl.IsKeyPressed(.LEFT) {
        g.fbf_page    = (g.fbf_page + 2) % 3
        g.menu_cursor = 0
    }

    pw :: f32(320); ph :: f32(200)
    px := f32(GAME_W)/2 - pw/2; py := f32(GAME_H)/2 - ph/2

    switch g.fbf_page {
    case 0: draw_fbf_page_convert(px, py, pw, ph)
    case 1: draw_fbf_page_sell(px, py, pw, ph)
    case 2: draw_fbf_page_upgrades(px, py, pw, ph)
    }
}

draw_fbf_page_convert :: proc(px, py, pw, ph: f32) {
    num_items := 2 + int(g.fbf_indoor_owned)
    update_menu_input(num_items)
    draw_panel(px, py, pw, ph, "=== FACTORY (1/3): CONVERT ===")
    draw_shop_header(px, py, pw)

    rl.DrawText(
        strings.clone_to_cstring(
            fmt.aprintf("Honey Product: %.1f ml", g.honey_product_ml, allocator = context.temp_allocator),
            context.temp_allocator,
        ),
        pxi(px)+8, pxi(py)+40, 8, COL_HONEY2)

    convert_label := fmt.aprintf("Convert all raw honey -> product (x%.1f)",
        FACTORY_CONVERT_RATIO, allocator = context.temp_allocator)
    if draw_menu_item(px+8, py+56, pw-16, 28, convert_label, 0) {
        if g.player.honey_ml > 0 {
            produced := g.player.honey_ml * FACTORY_CONVERT_RATIO
            g.honey_product_ml += produced
            g.player.honey_ml   = 0
            show_message(fmt.aprintf("Converted honey into %.1f ml of honey product!",
                produced, allocator = context.temp_allocator))
        } else { show_message("No raw honey to convert!") }
    }

    if g.fbf_indoor_owned {
        collect_label := fmt.aprintf("Collect Indoor Box Honey (+%.1f ml)", g.fbf_indoor_honey_ml,
            allocator = context.temp_allocator)
        if draw_menu_item(px+8, py+88, pw-16, 28, collect_label, 1) {
           g.player.honey_ml    += g.fbf_indoor_honey_ml
           g.fbf_indoor_honey_ml = 0
           show_message("Collected")
        }
    }

    close_idx := 1 if !g.fbf_indoor_owned else 2
    draw_shop_footer(px, py, pw, ph, close_idx)
}


draw_fbf_page_sell :: proc(px, py, pw, ph: f32) {
    NUM_ITEMS :: 2
    update_menu_input(NUM_ITEMS)
    draw_panel(px, py, pw, ph, "=== FACTORY (2/3): SELL ===")
    draw_shop_header(px, py, pw)

    product_val := (g.honey_product_ml / ML_PER_LITER) * honey_value_per_liter() * FACTORY_PREMIUM_MULT
    sell_label := fmt.aprintf("Sell all honey product ($%.2f)", product_val,
        allocator = context.temp_allocator)
    if draw_menu_item(px+8, py+56, pw-16, 28, sell_label, 0) {
        if g.honey_product_ml > 0 {
            g.total_money_earned += product_val
            g.player.money       += product_val
            g.honey_product_ml    = 0
            show_message(fmt.aprintf("Sold honey product for $%.2f!", product_val,
                allocator = context.temp_allocator))
        } else { show_message("No honey product to sell!") }
    }

    draw_shop_footer(px, py, pw, ph, 1)
}
draw_fbf_page_upgrades :: proc(px, py, pw, ph: f32) {
    NUM_ITEMS :: 2
    update_menu_input(NUM_ITEMS)
    draw_panel(px, py, pw, ph, "=== FACTORY (3/3): UPGRADES ===")
    draw_shop_header(px, py, pw)

    if !g.fbf_indoor_owned {
        label := fmt.aprintf("Buy Indoor Bee Box ($%.0f)", FACTORY_INDOOR_BOX_COST,
            allocator = context.temp_allocator)
        if draw_menu_item(px+8, py+40, pw-16, 28, label, 0) {
            if g.player.money >= FACTORY_INDOOR_BOX_COST {
                g.player.money   -= FACTORY_INDOOR_BOX_COST
                g.fbf_indoor_owned = true
                show_message("Installed an Indoor Bee Box! It produces honey year-round, rain or shine.")
            } else {
                show_message("Not enough money for the Indoor Bee Box!")
            }
        }
        rl.DrawText("Produces honey regardless of weather or season.\nLimit: 1 per factory.",
            pxi(px)+8, pxi(py)+72, 8, rl.GRAY)
    } else {
        rl.DrawText(
            strings.clone_to_cstring(
                fmt.aprintf("Indoor Bee Box: OWNED (%.1f / %.1f ml stored)",
                    g.fbf_indoor_honey_ml, FACTORY_INDOOR_BOX_CAPACITY,
                    allocator = context.temp_allocator),
                context.temp_allocator),
            pxi(px)+8, pxi(py)+40, 8, COL_HONEY2)
        rl.DrawText("Already installed! 1 per factory.", pxi(px)+8, pxi(py)+56, 8, rl.GRAY)
    }

    draw_shop_footer(px, py, pw, ph, 1)
}


handle_diner_menu :: proc() {
    NUM_ITEMS :: 5
    update_menu_input(NUM_ITEMS)
    pw :: f32(280); ph :: f32(240)
    px := f32(GAME_W)/2 - pw/2; py := f32(GAME_H)/2 - ph/2
    draw_panel(px, py, pw, ph, "= HONEY POT DINER =")
    rl.DrawText("Howdy, partner! What'll it be?", pxi(px)+8, pxi(py)+22, 9, COL_TEXT)
    item_labels   := [4]string{"Honey Biscuits & Gravy  $8.50","Beekeeper's Breakfast  $12.00","Sweet Tea & Pie         $5.00","Honey BBQ Ribs         $18.00"}
    item_costs    := [4]f32{8.50, 12.00, 5.00, 18.00}
    item_is_drink := [4]bool{false, false, true, false}
    for i in 0..<4 {
        if draw_menu_item(px+8, py+36+f32(i)*34, pw-16, 26, item_labels[i], i) {
            if g.player.money >= item_costs[i] {
                g.player.money -= item_costs[i]
                if item_is_drink[i] {
                    g.inv_drink_count += 1
                    show_message(fmt.aprintf("Bought %s! (%d drinks in inventory)", item_labels[i], g.inv_drink_count, allocator = context.temp_allocator))
                } else {
                    g.inv_food_count += 1
                    show_message(fmt.aprintf("Bought %s! (%d food in inventory)", item_labels[i], g.inv_food_count, allocator = context.temp_allocator))
                }
            } else { show_message("Not enough money!") }
        }
    }
    if draw_menu_item(px+pw/2-60, py+ph-28, 120, 22, "Leave", 4) { close_menu() 
}
    rl.DrawText("UP/DOWN: Navigate   ENTER: Select", pxi(px)+8, pxi(py)+pxi(ph)-14, 7, {140,140,100,200})
}


handle_bar_menu :: proc() {
    NUM_ITEMS :: 6
    update_menu_input(NUM_ITEMS)
    pw :: f32(280); ph :: f32(260)
    px := f32(GAME_W)/2 - pw/2; py := f32(GAME_H)/2 - ph/2
    draw_panel(px, py, pw, ph, "THE BUZZED B's BAR")
    drink_labels := [5]string{"Honey Mead           $6.00","Beekeeper's Bourbon  $9.00","Wildflower Ale       $5.50","Clover Cider         $4.50","Sweet Sting Shot     $3.00"}
    drink_costs  := [5]f32{6.00, 9.00, 5.50, 4.50, 3.00}
    for i in 0..<5 {
        if draw_menu_item(px+8, py+24+f32(i)*32, pw-16, 24, drink_labels[i], i) 
{
            if g.player.money >= drink_costs[i] {
                g.player.money -= drink_costs[i]
                show_message(fmt.aprintf("Cheers! Enjoyed a %s!", drink_labels[i], allocator = context.temp_allocator))
            } else { show_message("Not enough money!") }
        }
    }
    if draw_menu_item(px+pw/2-60, py+ph-28, 120, 22, "Leave", 5) { close_menu() 
}
    rl.DrawText("UP/DOWN: Navigate   ENTER: Select", pxi(px)+8, pxi(py)+pxi(ph)-14, 7, {140,140,100,200})
}

handle_doctor_menu :: proc() {
    NUM_ITEMS :: 5
    update_menu_input(NUM_ITEMS)
    pw :: f32(280); ph :: f32(250)
    px := f32(GAME_W)/2 - pw/2; py := f32(GAME_H)/2 - ph/2
    draw_panel(px, py, pw, ph, "=== DR. FLORA'S OFFICE ===")
    service_labels := [4]string{"Bee Sting Treatment   FREE","Annual Check-up       $50","Allergy Testing      $120","Honey Therapy         $80"}
    service_costs  := [4]f32{0, 50, 120, 80}
    for i in 0..<4 {
        if draw_menu_item(px+8, py+24+f32(i)*36, pw-16, 28, service_labels[i], 
i) {
            if g.player.money >= service_costs[i] {
                g.player.money -= service_costs[i]
                show_message(fmt.aprintf("Received %s. Feeling better!", service_labels[i], allocator = context.temp_allocator))
            } else { show_message("Not enough money!") }
        }
    }
    if draw_menu_item(px+pw/2-60, py+ph-28, 120, 22, "Leave", 4) { close_menu() 
}
    rl.DrawText("UP/DOWN: Navigate   ENTER: Select", pxi(px)+8, pxi(py)+pxi(ph)-14, 7, {140,140,100,200})
}

handle_sheriff_menu :: proc() {
    NUM_ITEMS :: 6
    update_menu_input(NUM_ITEMS)
    pw :: f32(290); ph :: f32(250)
    px := f32(GAME_W)/2 - pw/2; py := f32(GAME_H)/2 - ph/2
    draw_panel(px, py, pw, ph, "=== SHERIFF'S OFFICE ===")
    rl.DrawText("Howdy! Sheriff Earl speakin'.", pxi(px)+8, pxi(py)+22, 9, COL_TEXT)
    notices := [5]string{
        "No trespassing on private land.",
        "Bee boxes on owned property only.",
        "Report suspicious activity.",
        "Watch out for Dale.",
	"Dont forget to save progress",
    }
    for i in 0..<5 {
        selected := (g.menu_cursor == i)
        bg := COL_BTN_HOV if selected else COL_BTN
        rl.DrawRectangle(pxi(px)+8, pxi(py)+38+i32(i)*30, pxi(pw)-16, 22, bg)
        if selected {
            rl.DrawRectangleLinesEx({px+8, py+38+f32(i)*30, pw-16, 22}, 1, COL_HONEY2)
        } else {
            rl.DrawRectangleLinesEx({px+8, py+38+f32(i)*30, pw-16, 22}, 1, COL_PANEL_BORDER)
        }
        rl.DrawText(strings.clone_to_cstring(notices[i], context.temp_allocator), pxi(px)+22, pxi(py)+38+i32(i)*30+6, 8, COL_TEXT)
    }
    if draw_menu_item(px+pw/2-60, py+ph-28, 120, 22, "Leave", 5) { close_menu() 
}
    rl.DrawText("UP/DOWN: Navigate   ENTER: Select", pxi(px)+8, pxi(py)+pxi(ph)-14, 7, {140,140,100,200})
}
handle_bee_sanctuary_menu :: proc() {
    NUM_ITEMS :: 4
    update_menu_input(NUM_ITEMS)
    pw :: f32(320); ph :: f32(260)
    px := f32(GAME_W)/2 - pw/2; py := f32(GAME_H)/2 - ph/2
    draw_panel(px, py, pw, ph, "=== BEE SANCTUARY DONATIONS ===")

    rl.DrawText(strings.clone_to_cstring(fmt.aprintf("Money: $%.2f",
        g.player.money, allocator = context.temp_allocator), context.temp_allocator),
        pxi(px)+8, pxi(py)+20, 9, COL_GREEN_TEXT)

    tracker := fmt.aprintf("Total Donated: $%.2f / $%.0f",
        g.sanctuary_donated, BEE_SANCTUARY_GOAL, allocator = context.temp_allocator)
    rl.DrawText(strings.clone_to_cstring(tracker, context.temp_allocator),
        pxi(px)+8, pxi(py)+34, 8, COL_HONEY)

    pct := clamp(g.sanctuary_donated / BEE_SANCTUARY_GOAL, 0, 1)
    rl.DrawRectangle(pxi(px)+8, pxi(py)+48, pxi(pw)-16, 10, {40,28,8,230})
    rl.DrawRectangle(pxi(px)+8, pxi(py)+48, i32(f32(pxi(pw)-16)*pct), 10, COL_HONEY2)
    rl.DrawRectangleLinesEx({px+8, py+48, pw-16, 10}, 1, COL_PANEL_BORDER)

    opt1 := fmt.aprintf("Donate $%.0f   (+1 bee)",  DONATE_TIER1, allocator = context.temp_allocator)
    opt2 := fmt.aprintf("Donate $%.0f  (+2 bees)",  DONATE_TIER2, allocator = context.temp_allocator)
    opt3 := fmt.aprintf("Donate $%.0f (+3 bees)",   DONATE_TIER3, allocator = context.temp_allocator)
    opts  := [3]string{opt1, opt2, opt3}
    costs := [3]f32{DONATE_TIER1, DONATE_TIER2, DONATE_TIER3}
    bees  := [3]int{1, 2, 3}

    for i in 0..<3 {
        by := py + 66 + f32(i)*34
        if draw_menu_item(px+8, by, pw-16, 28, opts[i], i) {
            if g.player.money >= costs[i] {
                g.player.money        -= costs[i]
                g.sanctuary_donated   += costs[i]
                g.sanctuary_bee_count += bees[i]
                show_message(fmt.aprintf("Thank you for donating $%.0f! %d bee(s) released into the sanctuary.",
                    costs[i], bees[i], allocator = context.temp_allocator), 4)
		unlock_achievement(ACH_DONATED_SANCTUARY)
            } else {
                show_message("Not enough money!")
            }
        }
    }

    if draw_menu_item(px+8, py+ph-34, pw-16, 26, "Close Menu", 3) { close_menu() }
    rl.DrawText("UP/DOWN: Navigate   ENTER: Select", pxi(px)+8, pxi(py)+pxi(ph)-14,
        7, {140,140,100,200})
}



// NPC MENU


handle_npc_menu :: proc() {
    idx := g.selected_npc
    if idx < 0 || idx >= NPC_COUNT { close_menu(); return }
    npc := &g.npcs[idx]

    update_menu_input(8)

    pw :: f32(310); ph :: f32(320)
    px := f32(GAME_W)/2 - pw/2; py := f32(GAME_H)/2 - ph/2

    title := fmt.aprintf("=== %s ===", npc.name, allocator = context.temp_allocator)
    draw_panel(px, py, pw, ph, title)

    kind_str := "Farmer" if npc.kind == .Farmer else "Civilian"
    rl.DrawText(strings.clone_to_cstring(kind_str, context.temp_allocator), pxi(px)+8, pxi(py)+20, 8, COL_TEXT2)

    rl.DrawText("-- TALK --", pxi(px)+8, pxi(py)+34, 8, COL_HONEY)
    for i in 0..<3 {
        if draw_menu_item(px+8, py+44+f32(i)*28, pw-16, 22, npc.dialogue[i], i)
        {
            show_message(fmt.aprintf("%s: \"%s\"", npc.name, npc.dialogue[i], allocator = context.temp_allocator), 4)
            npc_relationship_gain(idx, RELATIONSHIP_TALK_GAIN)
        }
    }

    rl.DrawLine(pxi(px)+4, pxi(py)+132, pxi(px)+pxi(pw)-4, pxi(py)+132, COL_PANEL_BORDER)
    buy_str := fmt.aprintf("Buy: %s  ($%.0f)", npc.sell_item, npc.sell_price, allocator = context.temp_allocator)
    if draw_menu_item(px+8, py+138, pw-16, 24, buy_str, 3) {
        if try_buy_lightsaber_special(npc) {
            npc_relationship_gain(idx, RELATIONSHIP_TRADE_GAIN)
        } else if try_buy_batarang_special(npc) {
            npc_relationship_gain(idx, RELATIONSHIP_TRADE_GAIN)
        } else if g.player.money >= npc.sell_price {
            g.player.money -= npc.sell_price
            show_message(fmt.aprintf("Bought %s from %s for $%.0f!", npc.sell_item, npc.name, npc.sell_price, allocator = context.temp_allocator))
            npc_relationship_gain(idx, RELATIONSHIP_TRADE_GAIN)
        } else {
            show_message("Not enough money!")
        }
    }

    food_str := fmt.aprintf("Buy: %s  ($%.2f)", npc.food_item, npc.food_price, allocator = context.temp_allocator)
    if draw_menu_item(px+8, py+166, pw-16, 24, food_str, 4) {
        if g.player.money >= npc.food_price {
            g.player.money  -= npc.food_price
            g.inv_food_count += 1
            show_message(fmt.aprintf("Bought %s from %s! (%d food in inventory)",
                npc.food_item, npc.name, g.inv_food_count, allocator = context.temp_allocator))
            npc_relationship_gain(idx, RELATIONSHIP_TRADE_GAIN)
        } else {
            show_message("Not enough money!")
        }
    }

    drink_str := fmt.aprintf("Buy: %s  ($%.2f)", npc.drink_item, npc.drink_price, allocator = context.temp_allocator)
    if draw_menu_item(px+8, py+194, pw-16, 24, drink_str, 5) {
        if g.player.money >= npc.drink_price {
            g.player.money   -= npc.drink_price
            g.inv_drink_count += 1
            show_message(fmt.aprintf("Bought %s from %s! (%d drinks in inventory)",
                npc.drink_item, npc.name, g.inv_drink_count, allocator = context.temp_allocator))
            npc_relationship_gain(idx, RELATIONSHIP_TRADE_GAIN)
        } else {
            show_message("Not enough money!")
        }
    }

    rl.DrawLine(pxi(px)+4, pxi(py)+222, pxi(px)+pxi(pw)-4, pxi(py)+222, COL_PANEL_BORDER)

    honey_val_npc := (g.player.honey_ml / ML_PER_LITER) * npc.buy_price
    sell_str := fmt.aprintf("Sell honey to %s  ($%.0f/L)", npc.name, npc.buy_price, allocator = context.temp_allocator)
    if draw_menu_item(px+8, py+228, pw-16, 24, sell_str, 6) {
        if g.player.honey_ml > 0 {
            g.total_honey_sold_ml += g.player.honey_ml
            g.total_money_earned  += honey_val_npc
            g.player.money        += honey_val_npc
            g.player.honey_ml = 0
            show_message(fmt.aprintf("Sold honey to %s for $%.2f!", npc.name, honey_val_npc, allocator = context.temp_allocator))
            unlock_achievement(ACH_SOLD_NPC)
            npc_relationship_gain(idx, RELATIONSHIP_TRADE_GAIN)
        } else {
            show_message("You have no honey to sell!")
        }
    }

    if draw_menu_item(px+pw/2-60, py+ph-32, 120, 24, "Leave", 7) { close_menu()
    }

    rl.DrawText("UP/DOWN: Navigate   ENTER: Select", pxi(px)+8, pxi(py)+pxi(ph)-14, 7, {140,140,100,200})
}

fixed_buf_to_cstring :: proc(buf: ^[32]u8, tmp: mem.Allocator) -> cstring {
    n := 0
    for n < 32 && buf[n] != 0 { n += 1 }
    return strings.clone_to_cstring(string(buf[:n]), tmp)
}

handle_save_menu :: proc() {
    if g.save_rename_slot >= 0 {
        ch := rl.GetCharPressed()
        for ch != 0 {
            if ch >= 32 && ch < 127 && g.save_rename_len < 31 {
                g.save_rename_buf[g.save_rename_len] = u8(ch)
                g.save_rename_len += 1
            }
            ch = rl.GetCharPressed()
        }
        if rl.IsKeyPressed(.BACKSPACE) && g.save_rename_len > 0 {
            g.save_rename_len -= 1
            g.save_rename_buf[g.save_rename_len] = 0
        }
        if rl.IsKeyPressed(.ENTER) || rl.IsKeyPressed(.KP_ENTER) {
            name_str := string(g.save_rename_buf[:g.save_rename_len])
            if save_game(g.save_rename_slot, name_str) {
                show_message(fmt.aprintf("Saved to slot %d!", g.save_rename_slot+1, allocator = context.temp_allocator))
            } else {
                show_message("Save failed!")
            }
            g.save_rename_slot = -1
            if g.state == .SaveMenu { g.state = .World }
        }
        if rl.IsKeyPressed(.ESCAPE) { g.save_rename_slot = -1 }
    }

    NUM_ITEMS :: 4
    if g.save_rename_slot < 0 { update_menu_input(NUM_ITEMS) }

    pw :: f32(360); ph :: f32(280)
    px := f32(GAME_W)/2 - pw/2; py := f32(GAME_H)/2 - ph/2
    draw_panel(px, py, pw, ph, "=== SAVE / LOAD ===")
    rl.DrawText("F5: Open this menu anytime", pxi(px)+8, pxi(py)+20, 8, COL_TEXT2)

    for slot in 0..<NUM_SAVE_SLOTS {
        sy    := py + 36 + f32(slot)*68
        hdr   := &g.save_headers[slot]
        is_sel := (g.menu_cursor == slot)
        bg := COL_BTN_HOV if is_sel else COL_BTN
        rl.DrawRectangle(pxi(px)+6, pxi(sy), pxi(pw)-12, 60, bg)
        border_col := COL_HONEY2 if is_sel else COL_PANEL_BORDER
        rl.DrawRectangleLinesEx({px+6, sy, pw-12, 60}, 1, border_col)
        rl.DrawText(strings.clone_to_cstring(fmt.aprintf("Slot %d", slot+1, allocator = context.temp_allocator), context.temp_allocator), pxi(px)+12, pxi(sy)+4, 9, COL_HONEY)
        if hdr.used {
            rl.DrawText(fixed_buf_to_cstring(&hdr.name, context.temp_allocator), pxi(px)+12, pxi(sy)+18, 8, COL_TEXT)
            rl.DrawText(fixed_buf_to_cstring(&hdr.timestamp, context.temp_allocator), pxi(px)+12, pxi(sy)+30, 7, COL_TEXT2)
            rl.DrawText(strings.clone_to_cstring(fmt.aprintf("$%.2f", hdr.money, allocator = context.temp_allocator), context.temp_allocator), pxi(px)+12, pxi(sy)+42, 7, COL_GREEN_TEXT)
        } else {
            rl.DrawText("-- Empty --", pxi(px)+12, pxi(sy)+22, 8, COL_TEXT2)
        }
        btn_x := px + pw - 12 - 180
        if draw_button(btn_x, sy+4, 54, 22, "Save", 8) || (is_sel && g.menu_action && g.save_rename_slot < 0) {
            g.save_rename_slot = slot; g.save_rename_len = 0
            for i in 0..<32 { g.save_rename_buf[i] = 0 }
            if hdr.used { n := 0; for n < 32 && hdr.name[n] != 0 { g.save_rename_buf[n] = hdr.name[n]; n += 1; g.save_rename_len = n } }
            g.menu_action = false
        }
        if draw_button(btn_x+60, sy+4, 54, 22, "Load", 8) {
            if hdr.used {
                if load_game(slot) {
                    show_message(fmt.aprintf("Loaded slot %d!", slot+1, allocator = context.temp_allocator)); close_menu()
                } else { show_message("Load failed!") }
            } else { show_message("No save in that slot!") }
        }
        if draw_button(btn_x+120, sy+4, 54, 22, "Rename", 8) {
            g.save_rename_slot = slot; g.save_rename_len = 0
            for i in 0..<32 { g.save_rename_buf[i] = 0 }
            if hdr.used { n := 0; for n < 32 && hdr.name[n] != 0 { g.save_rename_buf[n] = hdr.name[n]; n += 1; g.save_rename_len = n } }
        }
    }
    if g.save_rename_slot >= 0 {
        rix := px + 6; riy := py + 36 + f32(g.save_rename_slot)*68 + 18
        rl.DrawRectangle(pxi(rix), pxi(riy), pxi(pw)-12, 14, {0,0,0,200})
        rl.DrawRectangleLinesEx({rix, riy, pw-12, 14}, 1, COL_HONEY)
        cursor_str := fmt.aprintf("%s_", string(g.save_rename_buf[:g.save_rename_len]), allocator = context.temp_allocator)
        rl.DrawText(strings.clone_to_cstring(cursor_str, context.temp_allocator), pxi(rix)+4, pxi(riy)+2, 8, COL_HONEY2)
        rl.DrawText("Type name, ENTER to save", pxi(px)+8, pxi(py)+pxi(ph)-24, 7, {180,180,100,200})
    }
    if draw_menu_item(px+pw/2-60, py+ph-32, 120, 24, "Close", 3) { close_menu() 
}
    rl.DrawText("UP/DOWN: Navigate   ENTER: Save slot", pxi(px)+8, pxi(py)+pxi(ph)-14, 7, {140,140,100,200})
}

update_menus :: proc() {
    #partial switch g.state {
    case .ShopMenu:         handle_shop_menu()
    case .LandMenu:         handle_land_menu()
    case .HomeMenu:         handle_home_menu()
    case .EditHomeMenu:      handle_edit_home_menu()
    case .EditHomeColorMenu: handle_edit_home_color_menu()
    case .HomeDecorateMenu:    handle_home_decorate_menu()
    case .HomeTrophyMenu:      handle_home_trophy_menu()
    case .HomeTrophyPickMenu:  handle_home_trophy_pick_menu()
    case .BankMenu:          handle_bank_menu()
    case .DinerMenu:         handle_diner_menu()
    case .BarMenu:           handle_bar_menu()
    case .DoctorMenu:        handle_doctor_menu()
    case .SheriffMenu:       handle_sheriff_menu()
    case .SaveMenu:          handle_save_menu()
    case .NPCMenu:           handle_npc_menu()
    case .HiveAddressMenu:   handle_hive_address_menu()
    case .CarDealerMenu:     handle_car_dealer_menu()
    case .BeeSanctuaryMenu:  handle_bee_sanctuary_menu()
    case .FuzzyBuddyMenu:    handle_fuzzy_buddy_menu()
    case .World, .Interior, .HomeInterior, .GarageInterior, .MainMenu, .HelpMenu: // no-op
    }
    if rl.IsKeyPressed(.ESCAPE) && g.state != .World && g.state != .Interior &&
       g.state != .HomeInterior && g.state != .GarageInterior && g.state != .MainMenu && g.state != .HelpMenu {
        if g.state == .SaveMenu && g.save_rename_slot >= 0 { g.save_rename_slot = -1 } else { close_menu() }
    }

}


// INVENTORY SCREEN

draw_inventory :: proc() {
    if !g.inventory_open { return }

    rows := make([dynamic]InventoryRow, 0, 4, context.temp_allocator)

    if g.inv_flower_seeds > 0 {
        append(&rows, InventoryRow{
            text = fmt.aprintf("Flower Seeds: %d  (F to plant on owned land)", g.inv_flower_seeds, allocator = context.temp_allocator),
            color = COL_FLOWER_Y, usable = false, on_use = nil,
        })
    }
    if g.inv_tree_seeds > 0 {
        append(&rows, InventoryRow{
            text = fmt.aprintf("Tree Seeds:   %d  (T to plant on owned land)", g.inv_tree_seeds, allocator = context.temp_allocator),
            color = COL_TREE_LEAF, usable = false, on_use = nil,
        })
    }
    if g.inv_food_count > 0 {
        append(&rows, InventoryRow{
            text = fmt.aprintf("Food: %d  (ENTER to eat, +%.0f Hunger)", g.inv_food_count, FOOD_HUNGER_RESTORE, allocator = context.temp_allocator),
            color = COL_HUNGER, usable = true, on_use = consume_food,
        })
    }
    if g.inv_drink_count > 0 {
        append(&rows, InventoryRow{
            text = fmt.aprintf("Drinks: %d  (ENTER to drink, +%.0f Thirst)", g.inv_drink_count, DRINK_THIRST_RESTORE, allocator = context.temp_allocator),
            color = COL_THIRST, usable = true, on_use = consume_drink,
        })
    }

    if len(rows) > 0 {
        if g.inventory_cursor >= len(rows) { g.inventory_cursor = len(rows)-1 }
    } else {
        g.inventory_cursor = 0
    }

    if rl.IsKeyPressed(.UP)   { g.inventory_cursor -= 1; if g.inventory_cursor < 0 { g.inventory_cursor = 0 } }
    if rl.IsKeyPressed(.DOWN) { g.inventory_cursor += 1; if len(rows) > 0 && g.inventory_cursor >= len(rows) { g.inventory_cursor = len(rows)-1 } }

    pw :: f32(280); ph :: f32(200)
    px := f32(GAME_W)/2 - pw/2; py := f32(GAME_H)/2 - ph/2
    draw_panel(px, py, pw, ph, "=== INVENTORY ===")
    rl.DrawText("[I] to close", pxi(px)+8, pxi(py)+20, 8, COL_TEXT2)

    if len(rows) == 0 {
        rl.DrawText("Your inventory is empty.", pxi(px)+8, pxi(py)+50, 8, COL_TEXT2)
    } else {
        for row, i in rows {
            ry := py + 40 + f32(i)*18
            if i == g.inventory_cursor {
                rl.DrawRectangle(pxi(px)+4, pxi(ry)-2, pxi(pw)-8, 16, COL_BTN_HOV)
            }
            rl.DrawText(strings.clone_to_cstring(row.text, context.temp_allocator), pxi(px)+8, pxi(ry), 8, row.color)
        }
        if (rl.IsKeyPressed(.ENTER) || rl.IsKeyPressed(.KP_ENTER)) && g.inventory_cursor < len(rows) {
            sel := rows[g.inventory_cursor]
            if sel.usable && sel.on_use != nil {
                sel.on_use()
            }
        }
    }

    rl.DrawText("UP/DOWN: Navigate   ENTER: Use", pxi(px)+8, pxi(py)+pxi(ph)-14, 7, {140,140,100,200})
}

draw_camera_album :: proc() {
    if !g.album_open { return }

    pw :: f32(560); ph :: f32(320)
    px := f32(GAME_W)/2 - pw/2; py := f32(GAME_H)/2 - ph/2
    draw_panel(px, py, pw, ph, "=== CAMERA ROLL ===")

    n := len(g.camera_roll)
    if n == 0 {
        rl.DrawText("No photos yet. Press C to take one!", pxi(px)+12, pxi(py)+30, 9, COL_TEXT2)
        rl.DrawText("[P] Close", pxi(px)+8, pxi(py)+pxi(ph)-14, 7, {140,140,100,200})
        return
    }

    cols :: 4
    thumb_w :: f32(122); thumb_h :: f32(69); pad :: f32(8)
    grid_x := px + 12; grid_y := py + 22

    for i in 0..<n {
        col := i % cols; row := i / cols
        tx := grid_x + f32(col)*(thumb_w+pad)
        ty := grid_y + f32(row)*(thumb_h+pad)
        photo := g.camera_roll[i]
        src := rl.Rectangle{0, 0, f32(photo.texture.width), f32(photo.texture.height)}
        dst := rl.Rectangle{tx, ty, thumb_w, thumb_h}
        rl.DrawTexturePro(photo.texture, src, dst, {0,0}, 0, rl.WHITE)
        border_col := COL_HONEY2 if i == g.album_cursor else COL_PANEL_BORDER
        thick      := f32(2) if i == g.album_cursor else f32(1)
        rl.DrawRectangleLinesEx(dst, thick, border_col)
    }

    rl.DrawText("ARROWS: Browse   ENTER: View   P: Close", pxi(px)+8, pxi(py)+pxi(ph)-14, 7, {140,140,100,200})

    if g.album_viewing {
        photo := g.camera_roll[g.album_cursor]
        vw := f32(GAME_W) - 40
        vh := vw * (f32(GAME_H)/f32(GAME_W))
        vx := f32(GAME_W)/2 - vw/2
        vy := f32(GAME_H)/2 - vh/2
        rl.DrawRectangle(0, 0, GAME_W, GAME_H, {0,0,0,200})
        src := rl.Rectangle{0, 0, f32(photo.texture.width), f32(photo.texture.height)}
        dst := rl.Rectangle{vx, vy, vw, vh}
        rl.DrawTexturePro(photo.texture, src, dst, {0,0}, 0, rl.WHITE)
        rl.DrawRectangleLinesEx(dst, 2, COL_HONEY)
        rl.DrawText(strings.clone_to_cstring(photo.filename, context.temp_allocator), pxi(vx), pxi(vy)-14, 8, COL_TEXT2)
        rl.DrawText("ENTER: Back", pxi(vx), pxi(vy+vh)+4, 8, {140,140,100,200})
    }
}
draw_discovered :: proc() {
    if !g.discovered_open { return }

    pw :: f32(380); ph :: f32(240)
    px := f32(GAME_W)/2 - pw/2; py := f32(GAME_H)/2 - ph/2
    draw_panel(px, py, pw, ph, "=== WILDLIFE DISCOVERED ===")

    total_found := 0
    for kind in AnimalType { if g.discovered_animals[kind] { total_found += 1 } }
    for kind in FishType   { if g.discovered_fish[kind]    { total_found += 1 } }
    total_species := len(AnimalType) + len(FishType)

    progress := fmt.aprintf("Discovered: %d / %d", total_found, total_species,
        allocator = context.temp_allocator)
    rl.DrawText(strings.clone_to_cstring(progress, context.temp_allocator),
        pxi(px)+8, pxi(py)+20, 9, COL_HONEY)
    rl.DrawText("Photograph wildlife with C to discover new species!",
        pxi(px)+8, pxi(py)+32, 7, COL_TEXT2)

    draw_checklist_entry :: proc(x, y: f32, name: string, found: bool) {
        rl.DrawRectangle(pxi(x), pxi(y), 10, 10, {40, 28, 8, 230})
        rl.DrawRectangleLinesEx({x, y, 10, 10}, 1, COL_PANEL_BORDER)
        if found {
            rl.DrawRectangle(pxi(x)+2, pxi(y)+2, 6, 6, COL_GREEN_TEXT)
        }
        label := name if found else "???"
        col   := COL_TEXT if found else rl.Color{120, 110, 90, 255}
        rl.DrawText(strings.clone_to_cstring(label, context.temp_allocator),
            pxi(x)+16, pxi(y)+1, 9, col)
    }
    ax := px + 20
    rl.DrawText("-- ANIMALS --", pxi(ax), pxi(py)+48, 9, COL_HONEY2)
    row := 0
    for kind in AnimalType {
        draw_checklist_entry(ax, py + 64 + f32(row)*22,
            animal_label(kind), g.discovered_animals[kind])
        row += 1
    }

    cx := px + pw/2 + 20
    rl.DrawText("-- FISH --", pxi(cx), pxi(py)+48, 9, COL_HONEY2)
    row = 0
    for kind in FishType {
        draw_checklist_entry(cx, py + 64 + f32(row)*22,
            fish_label(kind), g.discovered_fish[kind])
        row += 1
    }

    rl.DrawText("[L] Close", pxi(px)+8, pxi(py)+pxi(ph)-14, 7,
        {140,140,100,200})
}




// INTERIOR OPTION MENU


draw_interior_option_menu :: proc() {
    if !g.interior_option_open { return }
    pw :: f32(200); ph :: f32(80)
    px := f32(GAME_W)/2 - pw/2; py := f32(GAME_H)/2 - ph/2 - 60
    draw_panel(px, py, pw, ph, "=== OPTIONS [O] ===")
    rl.DrawText("O: Open menu", pxi(px)+8, pxi(py)+22, 8, COL_TEXT)
    rl.DrawText("E: Leave", pxi(px)+8, pxi(py)+36, 8, COL_TEXT2)
    b := &g.buildings[g.interior_building]
    lbl := fmt.aprintf("Location: %s", b.label, allocator = context.temp_allocator)
    rl.DrawText(strings.clone_to_cstring(lbl, context.temp_allocator), pxi(px)+8, pxi(py)+50, 7, COL_HONEY)
    rl.DrawText("Press ENTER to open services", pxi(px)+8, pxi(py)+62, 7, {140,140,100,200})
}


// MINIMAP


world_to_minimap :: proc(wx, wy, mx, my, mw, mh: f32) -> (f32, f32) {
    half := MINIMAP_WORLD / 2
    nx := (wx + half) / MINIMAP_WORLD
    ny := (wy + half) / MINIMAP_WORLD
    return mx + nx*mw, my + ny*mh
}

draw_minimap :: proc() {
    mw, mh, mx, my: f32
    if g.minimap_full {
        margin :: f32(20)
        mx = margin; my = f32(GAME_H)*0.05 + 28
        mw = f32(GAME_W) - margin*2; mh = f32(GAME_H) - my - 20
    } else {
        mx = f32(GAME_W) - MINIMAP_W - MINIMAP_PAD
        my = f32(GAME_H) - MINIMAP_H - MINIMAP_PAD - 16
        mw = MINIMAP_W; mh = MINIMAP_H
    }
    rl.DrawRectangle(pxi(mx)-1, pxi(my)-1, pxi(mw)+2, pxi(mh)+2, COL_PANEL_BORDER)
    rl.DrawRectangle(pxi(mx), pxi(my), pxi(mw), pxi(mh), {10,20,10,220})

    for i in 0..<len(g.plots) {
        p := &g.plots[i]
        px1, py1 := world_to_minimap(p.rect.x, p.rect.y, mx, my, mw, mh)
        px2, py2 := world_to_minimap(p.rect.x+p.rect.width, p.rect.y+p.rect.height, mx, my, mw, mh)
        pw := max(px2-px1, 1); ph := max(py2-py1, 1)
        col: rl.Color
        if p.owner_is_player { col = {200,220,0,200} } else if p.owned { col = {60,160,60,180} } else { col = {60,100,40,160} }
        rl.DrawRectangle(pxi(px1), pxi(py1), pxi(pw), pxi(ph), col)
    }
    {

	for i in 0..<MAX_CARS {
	    c := &g.cars[i]
	    if !c.active { continue }
	    mm_x, mm_y := world_to_minimap(c.pos.x, c.pos.y, mx, my, mw, mh)
	    rl.DrawRectangle(pxi(mm_x) - 3, pxi(mm_y) - 1, 6, 3, c.body_col)
	    rl.DrawRectangle(pxi(mm_x) - 1, pxi(mm_y) - 3, 4, 2, c.body_col)
	    rl.DrawRectangleLines(pxi(mm_x) - 3, pxi(mm_y) - 3, 7, 6, COL_CAR_ICON)
	    if c.occupied {
		rl.DrawRectangle(pxi(mm_x), pxi(mm_y) - 4, 2, 2, COL_HONEY)
    }
}


        tx1, ty1 := world_to_minimap(-600, -600, mx, my, mw, mh)
        tx2, ty2 := world_to_minimap( 600,  600, mx, my, mw, mh)
        rl.DrawRectangle(pxi(tx1), pxi(ty1), pxi(tx2-tx1), pxi(ty2-ty1), {80,72,56,180})
    }
    for bt in BuildingType {
        b := &g.buildings[bt]
        bpx, bpy := world_to_minimap(b.rect.x+b.rect.width/2, b.rect.y+b.rect.height/2, mx, my, mw, mh)
        dot_r := f32(3) if g.minimap_full else f32(2)
        rl.DrawCircle(pxi(bpx), pxi(bpy), dot_r, b.color)
    }
    ppx, ppy := world_to_minimap(g.player.pos.x, g.player.pos.y, mx, my, mw, mh)
    rl.DrawCircle(pxi(ppx), pxi(ppy), 3, {255,80,80,255})
    rl.DrawCircle(pxi(ppx), pxi(ppy), 2, {255,200,200,255})
    rl.DrawRectangleLinesEx({mx, my, mw, mh}, 1, COL_PANEL_BORDER)
    if g.minimap_full {
        rl.DrawText("HONEYVILLE MAP  [M] Mini", pxi(mx)+4, pxi(my)+4, 9, COL_HONEY)
    } else {
        rl.DrawText("[M] Map", pxi(mx)+2, pxi(my)-10, 7, {180,180,120,200})
    }
}


// DRAWING HELPERS


draw_bricks :: proc(rx, ry, rw, rh: i32, col_a, col_b: rl.Color) {
    bh :: i32(6); bw :: i32(14)
    rows := rh / bh
    for row in 0..<rows {
        offset := i32(0) if row%2==0 else bw/2
        y := ry + row*bh
        cols := (rw / bw) + 2
        for col in 0..<cols {
            x := rx + col*bw - offset
            if x >= rx && x < rx+rw {
                w := min(bw-1, rx+rw-x)
                rl.DrawRectangle(x, y, w, bh-1, col_a)
            }
        }
        rl.DrawRectangle(rx, y+bh-1, rw, 1, col_b)
    }
}

draw_lamp_post :: proc(ix, iy: i32) {
    rl.DrawRectangle(ix-2, iy-36, 4, 44, {72,72,72,255})
    rl.DrawRectangle(ix-1, iy-36, 2, 44, {96,96,96,255})
    rl.DrawRectangle(ix-1, iy-36, 10, 2, {72,72,72,255})
    rl.DrawRectangle(ix+6, iy-42, 10, 8, {60,60,60,255})
    rl.DrawRectangle(ix+7, iy-41, 8, 6, {255,240,160,255})
    rl.DrawCircle(ix+11, iy-38, 8, {255,240,160,40})
    rl.DrawRectangle(ix-4, iy+6, 8, 4, {60,60,60,255})
}

draw_tree :: proc(x, y: f32) {
    ix := pxi(x); iy := pxi(y)
    rl.DrawEllipse(ix, iy+8, 10, 4, COL_SHADOW)
    rl.DrawRectangle(ix-3, iy-2, 6, 20, COL_TREE_TRUNK)
    rl.DrawRectangle(ix-2, iy-2, 4, 20, {108,72,36,255})
    rl.DrawCircle(ix, iy-14, 18, COL_TREE_DARK)
    rl.DrawCircle(ix-8, iy-8, 13, COL_TREE_LEAF)
    rl.DrawCircle(ix+8, iy-8, 13, COL_TREE_LEAF)
    rl.DrawCircle(ix, iy-20, 15, COL_TREE_LEAF)
    rl.DrawCircle(ix, iy-26, 10, COL_TREE_LEAF2)
    rl.DrawCircle(ix-4, iy-24, 5, {80,180,80,120})
}
draw_big_tree :: proc(x, y: f32) {
    ix := pxi(x); iy := pxi(y)
    rl.DrawEllipse(ix, iy+16, 26, 8, COL_SHADOW)
    rl.DrawRectangle(ix-7, iy-4, 14, 42, COL_TREE_TRUNK)
    rl.DrawRectangle(ix-4, iy-4, 6, 42, {108,72,36,255})
    rl.DrawCircle(ix, iy-30, 40, COL_TREE_DARK)
    rl.DrawCircle(ix-22, iy-18, 28, COL_TREE_LEAF)
    rl.DrawCircle(ix+22, iy-18, 28, COL_TREE_LEAF)
    rl.DrawCircle(ix, iy-44, 32, COL_TREE_LEAF)
    rl.DrawCircle(ix, iy-58, 22, COL_TREE_LEAF2)
    rl.DrawCircle(ix-10, iy-52, 11, {80,180,80,120})
    rl.DrawCircle(ix+14, iy-30, 9, {80,180,80,90})
}

draw_park_bear :: proc(pos: Vec2, anim_time: f32) {
    x := pxi(pos.x); y := pxi(pos.y)
    COL_BEAR_OUTLINE :: rl.Color{ 18,  14,  12, 255}
    COL_BEAR_BODY    :: rl.Color{ 44,  36,  32, 255}
    COL_BEAR_BODY_LT :: rl.Color{ 58,  48,  42, 255}
    COL_BEAR_TAN     :: rl.Color{172, 126,  90, 255}
    COL_BEAR_TAN_DK  :: rl.Color{142, 102,  72, 255}
    COL_JAR_GLASS    :: rl.Color{220, 235, 245, 200}

    cycle    :: f32(3.0)
    phase    := math.mod(anim_time, cycle) / cycle
    ang      := phase * math.PI * 2
    paw_lift := math.sin(ang) * 5.0
    chew     := i32(math.sin(ang*4.0) * 1.0)

    rl.DrawEllipse(x+10, y+16, 16, 5, COL_SHADOW)

    rl.DrawRectangle(x-9,  y+3, 14, 14, COL_BEAR_OUTLINE)
    rl.DrawRectangle(x+11, y+3, 14, 14, COL_BEAR_OUTLINE)
    rl.DrawRectangle(x-5, y-9, 26, 18, COL_BEAR_OUTLINE)
    rl.DrawRectangle(x+1, y-24, 18, 17, COL_BEAR_OUTLINE)
    rl.DrawRectangle(x-2, y-22, 7, 7, COL_BEAR_OUTLINE)
    rl.DrawRectangle(x+15, y-22, 7, 7, COL_BEAR_OUTLINE)
    rl.DrawRectangle(x-8,  y+4, 12, 12, COL_BEAR_BODY)
    rl.DrawRectangle(x+12, y+4, 12, 12, COL_BEAR_BODY)
    rl.DrawRectangle(x-4, y-8, 24, 16, COL_BEAR_BODY)
    rl.DrawRectangle(x-4, y-8, 24, 4, COL_BEAR_BODY_LT)
    rl.DrawRectangle(x+2, y-22, 16, 14, COL_BEAR_BODY)
    rl.DrawRectangle(x-1, y-20, 5, 5, COL_BEAR_BODY)
    rl.DrawRectangle(x+16, y-20, 5, 5, COL_BEAR_BODY)
    rl.DrawRectangle(x, y-19, 3, 3, COL_BEAR_TAN_DK)
    rl.DrawRectangle(x+17, y-19, 3, 3, COL_BEAR_TAN_DK)
    rl.DrawRectangle(x+2, y-4, 12, 10, COL_BEAR_TAN)
    rl.DrawRectangle(x+6, y-14+chew, 8, 6, COL_BEAR_TAN)
    rl.DrawRectangle(x-6, y+12, 6, 4, COL_BEAR_TAN_DK)
    rl.DrawRectangle(x+14, y+12, 6, 4, COL_BEAR_TAN_DK)
    rl.DrawRectangle(x+5, y-18, 2, 2, {15,12,10,255})
    rl.DrawRectangle(x+13, y-18, 2, 2, {15,12,10,255})
    rl.DrawRectangle(x+9, y-11+chew, 2, 2, {15,12,10,255})
    jar_x := x - 20; jar_y := y + 2
    rl.DrawRectangle(jar_x, jar_y, 12, 14, COL_JAR_GLASS)
    rl.DrawRectangle(jar_x, jar_y+6, 12, 8, COL_HONEY)
    rl.DrawRectangle(jar_x-1, jar_y-2, 14, 3, {160,110,40,255})
    paw_x := jar_x + 6
    paw_y := jar_y - i32(paw_lift) - 2
    rl.DrawCircle(paw_x, paw_y, 4, COL_BEAR_TAN_DK)
}


draw_flower :: proc(x, y: f32, seed: int) {
    colors := [5]rl.Color{COL_FLOWER_Y, COL_FLOWER_P, COL_FLOWER_W, COL_FLOWER_R, COL_FLOWER_B}
    col := colors[seed % 5]
    ix := pxi(x); iy := pxi(y)
    rl.DrawRectangle(ix, iy, 1, 7, {48,100,24,255})
    rl.DrawRectangle(ix-2, iy-3, 2, 2, col)
    rl.DrawRectangle(ix+1, iy-3, 2, 2, col)
    rl.DrawRectangle(ix-1, iy-5, 3, 2, col)
    rl.DrawRectangle(ix-1, iy-1, 3, 2, col)
    rl.DrawRectangle(ix-1, iy-3, 3, 3, {240,210,40,255})
}

draw_menu_flower :: proc(x, y: f32, seed: int) {
    petal_colors := [10]rl.Color{
        {255,  40, 200, 255}, // hot pink
        {255, 220,   0, 255}, // bright yellow
        {  0, 220, 255, 255}, // cyan
        {255,  80,   0, 255}, // orange
        {160,   0, 255, 255}, // purple
        {  0, 255,  80, 255}, // lime green
        {255,   0,  80, 255}, // red-pink
        {  0, 120, 255, 255}, // bright blue
        {255, 160,   0, 255}, // amber
        {  0, 255, 200, 255}, // teal
    }
    center_colors := [5]rl.Color{
        {255, 255,   0, 255},
        {255, 200,  40, 255},
        {255, 255, 160, 255},
        {255, 240,   0, 255},
        {255, 180,  80, 255},
    }
    col    := petal_colors[seed % 10]
    cencol := center_colors[seed % 5]
    ix := pxi(x); iy := pxi(y)
    // Stem
    rl.DrawRectangle(ix,   iy,   2, 12, {40, 140, 40, 255})
    rl.DrawRectangle(ix+1, iy+2, 2,  6, {60, 180, 60, 255})
    // Petals
    rl.DrawRectangle(ix-4, iy-8,  4, 4, col)
    rl.DrawRectangle(ix+3, iy-8,  4, 4, col)
    rl.DrawRectangle(ix-1, iy-12, 4, 4, col)
    rl.DrawRectangle(ix-1, iy-4,  4, 4, col)
    rl.DrawRectangle(ix-4, iy-12, 3, 3, rl.Color{col.r/2+40, col.g/2+40, col.b/2+40, 220})
    rl.DrawRectangle(ix+3, iy-12, 3, 3, rl.Color{col.r/2+40, col.g/2+40, col.b/2+40, 220})
    rl.DrawRectangle(ix-4, iy-5,  3, 3, rl.Color{col.r/2+40, col.g/2+40, col.b/2+40, 220})
    rl.DrawRectangle(ix+3, iy-5,  3, 3, rl.Color{col.r/2+40, col.g/2+40, col.b/2+40, 220})
    // Center
    rl.DrawRectangle(ix-1, iy-10, 4, 4, cencol)
    rl.DrawRectangle(ix,   iy-9,  2, 2, {255, 255, 255, 200})
}

draw_mailbox :: proc(x, y: f32) {
    ix := pxi(x); iy := pxi(y)
    rl.DrawRectangle(ix-1, iy-20, 3, 20, {80,60,40,255})
    rl.DrawRectangle(ix-8, iy-32, 16, 12, {60,80,180,255})
    rl.DrawRectangle(ix-8, iy-32, 16, 2, {40,60,160,255})
    rl.DrawRectangle(ix-7, iy-36, 14, 6, {60,80,180,255})
    rl.DrawRectangle(ix-6, iy-38, 12, 4, {60,80,180,255})
    rl.DrawRectangle(ix+7, iy-34, 2, 10, {140,120,80,255})
    rl.DrawRectangle(ix+9, iy-34, 6, 5, {220,40,40,255})
    rl.DrawRectangle(ix-5, iy-26, 10, 2, {30,50,140,255})
    rl.DrawText("MAIL", ix-8, iy-44, 6, COL_TEXT)
}

draw_for_sale_sign :: proc(x, y: f32, price: f32) {
    ix := pxi(x); iy := pxi(y)
    rl.DrawRectangle(ix-14, iy-40, 3, 40, {100,70,40,255})
    rl.DrawRectangle(ix+11, iy-40, 3, 40, {100,70,40,255})
    rl.DrawRectangle(ix-16, iy-56, 32, 18, {200,30,30,255})
    rl.DrawRectangleLinesEx({f32(ix-16), f32(iy-56), 32, 18}, 1, {240,60,60,255})
    rl.DrawText("FOR",  ix-10, iy-54, 7, {255,255,255,255})
    rl.DrawText("SALE", ix-12, iy-46, 7, {255,255,255,255})
    rl.DrawRectangle(ix-20, iy-36, 40, 12, {240,220,60,255})
    price_str := fmt.aprintf("$%.0f", price, allocator = context.temp_allocator)
    cstr := strings.clone_to_cstring(price_str, context.temp_allocator)
    tw   := rl.MeasureText(cstr, 7)
    rl.DrawText(cstr, ix - tw/2, iy-34, 7, {40,20,0,255})
}

draw_fence_segment :: proc(x1, y1, x2, y2: f32) {
    dx := x2 - x1; dy := y2 - y1
    length := math.sqrt(dx*dx + dy*dy)
    if length < 1 { return }
    steps := int(length / 32)
    if steps < 1 { steps = 1 }
    for i in 0..=steps {
        t  := f32(i) / f32(steps)
        px := x1 + dx*t; py := y1 + dy*t
        rl.DrawRectangle(pxi(px)-2, pxi(py)-8, 4, 16, {140,100,60,255})
        rl.DrawRectangle(pxi(px)-2, pxi(py)-8, 4, 2,  {180,140,90,255})
    }
    rl.DrawLine(pxi(x1), pxi(y1)-4, pxi(x2), pxi(y2)-4, {160,120,70,255})
    rl.DrawLine(pxi(x1), pxi(y1)+2, pxi(x2), pxi(y2)+2, {160,120,70,255})
}

draw_plot_fence :: proc(r: rl.Rectangle, has_gate: bool) {
    gate_cx := r.x + r.width/2
    gate_hw  :: f32(20)
    draw_fence_segment(r.x, r.y, r.x+r.width, r.y)
    if has_gate {
        draw_fence_segment(r.x, r.y+r.height, gate_cx-gate_hw, r.y+r.height)
        draw_fence_segment(gate_cx+gate_hw, r.y+r.height, r.x+r.width, r.y+r.height)
        rl.DrawRectangle(pxi(gate_cx-gate_hw)-3, pxi(r.y+r.height)-12, 6, 20, {120,80,40,255})
        rl.DrawRectangle(pxi(gate_cx+gate_hw)-3, pxi(r.y+r.height)-12, 6, 20, {120,80,40,255})
    } else {
        draw_fence_segment(r.x, r.y+r.height, r.x+r.width, r.y+r.height)
    }
    draw_fence_segment(r.x, r.y, r.x, r.y+r.height)
    draw_fence_segment(r.x+r.width, r.y, r.x+r.width, r.y+r.height)
}

racetrack_outer_rect :: proc() -> rl.Rectangle {
    return {RACETRACK_CENTER.x - RACETRACK_OUTER_W/2, RACETRACK_CENTER.y - RACETRACK_OUTER_H/2,
            RACETRACK_OUTER_W, RACETRACK_OUTER_H}
}
racetrack_inner_rect :: proc() -> rl.Rectangle {
    return {RACETRACK_CENTER.x - RACETRACK_INNER_W/2, RACETRACK_CENTER.y - RACETRACK_INNER_H/2,
            RACETRACK_INNER_W, RACETRACK_INNER_H}
}

draw_racetrack :: proc() {
    outer := racetrack_outer_rect()
    inner := racetrack_inner_rect()

    rl.DrawRectangle(pxi(outer.x)-3, pxi(outer.y)-3,
                     pxi(outer.width)+6, pxi(outer.height)+6, {45,45,50,255})
    rl.DrawRectangle(pxi(outer.x), pxi(outer.y),
                     pxi(outer.width), pxi(outer.height), COL_TRACK_ASPHALT)
    for sy := 0; sy < int(outer.height); sy += 26 {
        for sx := 0; sx < int(outer.width); sx += 34 {
            if (sx*7 + sy*13) % 5 == 0 {
                rl.DrawRectangle(pxi(outer.x)+i32(sx)+i32((sx+sy)%9),
                                 pxi(outer.y)+i32(sy), 3, 2, {90,90,96,70})
            }
        }
    }

    rl.DrawRectangle(pxi(inner.x), pxi(inner.y),
                     pxi(inner.width), pxi(inner.height), COL_TRACK_INFIELD)
    for s := 0; s < int(inner.height); s += 24 {
        if (s/24) % 2 == 0 {
            h := min(i32(12), pxi(inner.height) - i32(s))
            rl.DrawRectangle(pxi(inner.x), pxi(inner.y)+i32(s),
                             pxi(inner.width), h, {0,60,0,30})
        }
    }

    draw_pit_garages(inner, f32(g_race_timer.best_lap))
    draw_track_kerbs(inner)
    draw_finish_line()
    draw_track_direction_sign()
    skid := rl.Color{25,25,28,140}
    rl.DrawRectangle(pxi(inner.x)-30, pxi(inner.y)-14, 22, 3, skid)
    rl.DrawRectangle(pxi(inner.x)-26, pxi(inner.y)-10, 18, 3, skid)
    rl.DrawRectangle(pxi(inner.x+inner.width)+8,  pxi(inner.y)-14, 22, 3, skid)
    rl.DrawRectangle(pxi(inner.x+inner.width)+10, pxi(inner.y)-10, 18, 3, skid)
    rl.DrawRectangle(pxi(inner.x)-30, pxi(inner.y+inner.height)+10, 22, 3, skid)
    rl.DrawRectangle(pxi(inner.x+inner.width)+8,  pxi(inner.y+inner.height)+10, 22, 3, skid)


    draw_track_banners(outer)
    draw_racetrack_wall(outer)
    draw_track_spectators(outer)
    draw_camera_flashes(outer)
}
draw_track_kerbs :: proc(inner: rl.Rectangle) {
    KERB_T :: i32(6)
    SEG    :: i32(14)

    kerb_red   := rl.Color{210, 40, 40, 255}
    kerb_white := rl.Color{240, 240, 240, 255}

    ix := pxi(inner.x);     iy := pxi(inner.y)
    iw := pxi(inner.width); ih := pxi(inner.height)

    i := 0
    for x := ix; x < ix+iw; x += SEG {
        w   := min(SEG, ix+iw-x)
        col := kerb_red if i % 2 == 0 else kerb_white
        rl.DrawRectangle(x, iy-KERB_T, w, KERB_T, col)
        rl.DrawRectangle(x, iy+ih,     w, KERB_T, col)
        i += 1
    }
    i = 0
    for y := iy; y < iy+ih; y += SEG {
        h   := min(SEG, iy+ih-y)
        col := kerb_red if i % 2 == 0 else kerb_white
        rl.DrawRectangle(ix-KERB_T, y, KERB_T, h, col)
        rl.DrawRectangle(ix+iw,     y, KERB_T, h, col)
        i += 1
    }
    rl.DrawRectangle(ix-KERB_T, iy-KERB_T, KERB_T, KERB_T, kerb_red)
    rl.DrawRectangle(ix+iw,     iy-KERB_T, KERB_T, KERB_T, kerb_red)
    rl.DrawRectangle(ix-KERB_T, iy+ih,     KERB_T, KERB_T, kerb_red)
    rl.DrawRectangle(ix+iw,     iy+ih,     KERB_T, KERB_T, kerb_red)
}

RACE_CAR_COLORS := [3]rl.Color{
    {210,45,45,255},
    {45,95,220,255},
    {240,190,30,255},
}

draw_brick_wall :: proc(x, y, w, h: i32) {
    brick_w :: i32(10)
    brick_h :: i32(5)
    mortar  := rl.Color{70,60,58,255}
    brick_a := rl.Color{150,70,55,255}
    brick_b := rl.Color{140,62,48,255}

    rl.BeginScissorMode(x, y, w, h)
    rl.DrawRectangle(x, y, w, h, mortar)
    row: i32 = 0
    for ry := y; ry < y+h; ry += brick_h {
        offset := brick_w/2 if row % 2 == 1 else 0
        for rx := x - offset; rx < x+w; rx += brick_w {
            bcol := brick_a if (row + rx/brick_w) % 2 == 0 else brick_b
            rl.DrawRectangle(rx+1, ry+1, brick_w-1, brick_h-1, bcol)
        }
        row += 1
    }
    rl.EndScissorMode()
}

draw_steel_column :: proc(x, y, h: i32) {
    rl.DrawRectangle(x, y, 6, h, {60,63,70,255})
    rl.DrawRectangle(x+1, y, 1, h, {110,113,120,255})
    for ry := y+4; ry < y+h; ry += 9 {
        rl.DrawCircle(x+3, ry, 1, {25,25,28,255})
    }
}

draw_steel_roof :: proc(x, y, w, h: i32, title: cstring) {
    rl.DrawRectangle(x, y, w, h, {95,98,105,255})
    for i := i32(0); i*7 < w; i += 1 {
        rl.DrawLine(x+i*7, y, x+i*7, y+h, {60,63,70,255})
    }
    rl.DrawRectangle(x, y+h-2, w, 2, {40,40,44,255})
    tw := rl.MeasureText(title, 8)
    rl.DrawText(title, x + w/2 - tw/2, y + h/2 - 4, 8, {30,30,30,255})
}

draw_sponsor_sign :: proc(x, y, w, h: i32, label: cstring, bg: rl.Color) {
    t := f32(rl.GetTime())
    rl.DrawRectangle(x-2, y-2, w+4, h+4, {30,30,30,255})
    pulse := 0.8 + 0.2*math.sin(t*2)
    glow := rl.Color{u8(f32(bg.r)*pulse), u8(f32(bg.g)*pulse), u8(f32(bg.b)*pulse), 255}
    rl.DrawRectangle(x, y, w, h, glow)
    rl.DrawRectangle(x, y, w, 2, rl.WHITE)
    tw := rl.MeasureText(label, 8)
    rl.DrawText(label, x + w/2 - tw/2, y + h/2 - 4, 8, rl.WHITE)
    rl.DrawRectangle(x+3, y+h, 2, 4, {45,45,45,255})
    rl.DrawRectangle(x+w-5, y+h, 2, 4, {45,45,45,255})
}

format_lap_time :: proc(seconds: f32) -> string {
    if seconds <= 0 || seconds >= 36000 {
        return "--:--.---"
    }

    total_ms := i64(seconds * 1000.0)
    mins     := total_ms / 60000
    secs     := (total_ms / 1000) % 60
    millis   := total_ms % 1000

    return fmt.tprintf("%02d:%02d.%03d", mins, secs, millis)
}

draw_lap_timer :: proc(x, y: i32, best_lap: f32) {
    t := f32(rl.GetTime())

    w :: i32(106)
    h :: i32(31)

    black      := rl.Color{10, 11, 13, 255}
    frame_dark := rl.Color{38, 41, 46, 255}
    frame_mid  := rl.Color{79, 85, 92, 255}
    amber      := rl.Color{255, 190, 35, 255}
    green      := rl.Color{65, 255, 105, 255}

    rl.DrawRectangle(x+13, y+h+3, 5, 10, frame_dark)
    rl.DrawRectangle(x+w-18, y+h+3, 5, 10, frame_dark)
    rl.DrawRectangle(x+14, y+h+3, 1, 10, frame_mid)
    rl.DrawRectangle(x+w-17, y+h+3, 1, 10, frame_mid)

    rl.DrawRectangle(x-4, y+3, w+8, h-6, frame_dark)
    rl.DrawRectangle(x-2, y+1, w+4, h-2, frame_dark)
    rl.DrawRectangle(x, y, w, h, frame_mid)
    rl.DrawRectangle(x+2, y+2, w-4, h-4, black)

    rl.DrawRectangle(x+5, y+5, w-10, h-10, {4, 9, 7, 255})
    rl.DrawRectangle(x+5, y+5, w-10, 1, {42, 75, 55, 255})

    flash_step := i32(t * 6.0)

    for i: i32 = 0; i < 8; i += 1 {
        lamp_on := (i + flash_step) % 2 == 0
        lamp_col := amber if lamp_on else rl.Color{90, 55, 12, 255}
        lamp_x := x + 7 + i*13
        rl.DrawRectangle(lamp_x, y-2, 5, 3, frame_dark)
        rl.DrawRectangle(lamp_x+1, y-1, 3, 1, lamp_col)
    }

    label := strings.clone_to_cstring(
        "FASTEST LAP",
        context.temp_allocator,
    )
    label_w := rl.MeasureText(label, 7)
    rl.DrawText(
        label,
        x+w/2-label_w/2,
        y+5,
        7,
        amber,
    )

    time_text := strings.clone_to_cstring(
        format_lap_time(best_lap),
        context.temp_allocator,
    )
    time_w := rl.MeasureText(time_text, 11)
    rl.DrawText(
        time_text,
        x+w/2-time_w/2+1,
        y+15,
        11,
        {10, 60, 25, 255},
    )
    rl.DrawText(
        time_text,
        x+w/2-time_w/2,
        y+14,
        11,
        green,
    )
}

draw_retro_sticker :: proc(
    x, y, w, h: i32,
    label: cstring,
    bg, fg: rl.Color,
) {
    rl.DrawRectangle(x-1, y-1, w+2, h+2, {24, 24, 27, 255})
    rl.DrawRectangle(x, y, w, h, bg)
    rl.DrawRectangle(x+1, y+1, w-2, 1, {255, 255, 255, 130})

    tw := rl.MeasureText(label, 6)
    rl.DrawText(label, x+w/2-tw/2, y+h/2-3, 6, fg)
}


draw_retro_sponsor_sign :: proc(
    x, y, w, h: i32,
    label: cstring,
    bg: rl.Color,
    phase: f32,
) {
    t := f32(rl.GetTime())

    frame_dark := rl.Color{31, 33, 38, 255}
    frame_mid  := rl.Color{98, 103, 110, 255}

    rl.DrawRectangle(x+5, y+h, 3, 4, frame_dark)
    rl.DrawRectangle(x+w-8, y+h, 3, 4, frame_dark)

    rl.DrawRectangle(x-3, y-2, w+6, h+4, frame_dark)
    rl.DrawRectangle(x-1, y-1, w+2, h+2, frame_mid)
    rl.DrawRectangle(x, y, w, h, bg)

    shine_x := i32(math.mod(t*18.0+phase, f32(w+14))) - 7

    rl.BeginScissorMode(x, y, w, h)
    rl.DrawRectangle(x+shine_x, y, 4, h, {255, 255, 255, 75})
    rl.EndScissorMode()

    rl.DrawRectangle(x+2, y+2, 4, 2, rl.WHITE)
    rl.DrawRectangle(x+w-6, y+h-4, 4, 2, {20, 20, 24, 180})

    tw := rl.MeasureText(label, 7)
    rl.DrawText(label, x+w/2-tw/2+1, y+h/2-3+1, 7, {30, 30, 30, 190})
    rl.DrawText(label, x+w/2-tw/2, y+h/2-3, 7, rl.WHITE)
}


draw_retro_warning_light :: proc(
    x, y: i32,
    active: bool,
    col: rl.Color,
) {
    rl.DrawRectangle(x-3, y-3, 7, 7, {28, 29, 33, 255})

    if active {
        rl.DrawRectangle(x-4, y, 9, 1, {col.r, col.g, col.b, 60})
        rl.DrawRectangle(x, y-4, 1, 9, {col.r, col.g, col.b, 60})
        rl.DrawCircle(x, y, 3, col)
        rl.DrawCircle(x-1, y-1, 1, rl.WHITE)
    } else {
        rl.DrawCircle(
            x,
            y,
            2,
            {
                u8(i32(col.r)/4),
                u8(i32(col.g)/4),
                u8(i32(col.b)/4),
                255,
            },
        )
    }
}


draw_retro_closed_door :: proc(
    x, y, w, h: i32,
    phase: f32,
) {
    t := f32(rl.GetTime())

    dark  := rl.Color{31, 34, 39, 255}
    steel := rl.Color{78, 84, 92, 255}
    edge  := rl.Color{119, 127, 136, 255}

    rl.DrawRectangle(x-3, y-3, w+6, h+6, {22, 23, 27, 255})
    rl.DrawRectangle(x-1, y-1, w+2, h+2, edge)

    rl.DrawRectangle(x, y, w, h, steel)

    for slat_y := y; slat_y < y+h; slat_y += 6 {
        rl.DrawRectangle(x, slat_y, w, 1, {40, 43, 48, 255})
        rl.DrawLine(x+1, slat_y+1, x+w-2, slat_y+1, edge)
    }

    sweep := i32(math.mod(t*22.0+phase, f32(w+18))) - 9

    rl.BeginScissorMode(x, y, w, h)
    rl.DrawRectangle(x+sweep, y, 5, h, {210, 225, 235, 35})
    rl.DrawRectangle(x+sweep+2, y, 1, h, {240, 248, 255, 55})
    rl.EndScissorMode()

    rl.DrawRectangle(x, y+h-3, w, 3, dark)
    rl.DrawRectangle(x+w/2-5, y+h-8, 10, 3, dark)
    rl.DrawRectangle(x+w/2-3, y+h-7, 6, 1, edge)
}


draw_retro_open_bay :: proc(x, y, w, h: i32) {
    rl.DrawRectangle(x-3, y-3, w+6, h+6, {21, 22, 25, 255})
    rl.DrawRectangle(x, y, w, h, {12, 15, 19, 255})

    rl.DrawRectangle(x, y+h-8, w, 8, {57, 57, 59, 255})
    rl.DrawLine(x, y+h-8, x+w, y+h-8, {110, 110, 105, 255})

    rl.DrawRectangle(x+6, y+3, 18, 3, {55, 58, 61, 255})
    rl.DrawRectangle(x+7, y+3, 16, 1, {225, 240, 220, 255})

    rl.DrawRectangle(x+w-24, y+3, 18, 3, {55, 58, 61, 255})
    rl.DrawRectangle(x+w-23, y+3, 16, 1, {225, 240, 220, 255})

    rl.DrawRectangle(x, y, w, 6, {74, 79, 86, 255})
    rl.DrawRectangle(x, y+2, w, 1, {126, 132, 138, 255})
    rl.DrawRectangle(x, y+5, w, 2, {32, 34, 38, 255})

    tire_x := x + 13
    tire_bottom := y + h - 7

    for i: i32 = 0; i < 3; i += 1 {
        tire_y := tire_bottom - i*8
        rl.DrawCircle(tire_x, tire_y, 8, {10, 11, 13, 255})
        rl.DrawCircle(tire_x, tire_y, 5, {42, 45, 48, 255})
        rl.DrawCircle(tire_x, tire_y, 2, {92, 96, 101, 255})
        rl.DrawLine(tire_x-6, tire_y-5, tire_x-4, tire_y-7, {85, 85, 85, 255})
        rl.DrawLine(tire_x+4, tire_y-7, tire_x+6, tire_y-5, {85, 85, 85, 255})
    }

    chest_x := x + w - 25
    chest_y := y + h - 24

    rl.DrawRectangle(chest_x-1, chest_y-1, 23, 24, {21, 22, 25, 255})
    rl.DrawRectangle(chest_x, chest_y, 21, 21, {176, 31, 34, 255})
    rl.DrawRectangle(chest_x, chest_y, 21, 4, {218, 48, 42, 255})

    for drawer: i32 = 0; drawer < 3; drawer += 1 {
        dy := chest_y + 5 + drawer*5
        rl.DrawLine(chest_x+2, dy, chest_x+18, dy, {90, 20, 22, 255})
        rl.DrawRectangle(chest_x+8, dy+1, 5, 1, {215, 220, 220, 255})
    }

    rl.DrawCircle(chest_x+4, chest_y+23, 2, {18, 18, 20, 255})
    rl.DrawCircle(chest_x+17, chest_y+23, 2, {18, 18, 20, 255})

    rack_x := x + w/2 - 10
    rack_y := y + 12

    rl.DrawRectangle(rack_x, rack_y, 22, 3, {112, 76, 39, 255})
    rl.DrawLine(rack_x+4, rack_y+3, rack_x+4, rack_y+14, {185, 190, 193, 255})
    rl.DrawCircle(rack_x+4, rack_y+15, 2, {185, 190, 193, 255})

    rl.DrawLine(rack_x+11, rack_y+3, rack_x+11, rack_y+15, {185, 190, 193, 255})
    rl.DrawRectangle(rack_x+9, rack_y+14, 5, 3, {185, 190, 193, 255})

    rl.DrawLineEx(
        {f32(rack_x+18), f32(rack_y+3)},
        {f32(rack_x+14), f32(rack_y+16)},
        2,
        {185, 190, 193, 255},
    )
}

draw_pit_garages :: proc(inner: rl.Rectangle, best_lap: f32) {
    t := f32(rl.GetTime())

    car_spacing :: i32(110)
    bay_count   :: i32(3)
    bw := car_spacing * bay_count + 20

    gx := pxi(inner.x) + pxi(inner.width)/2 - bw/2
    gy := pxi(inner.y) + pxi(inner.height)/2 - 40

    building_h :: i32(80)
    door_w     :: i32(78)
    door_h     :: i32(34)
    door_y     :: i32(34)

    brick_dark := rl.Color{104, 49, 42, 255}
    steel_dark := rl.Color{40, 44, 50, 255}
    steel_mid  := rl.Color{82, 89, 98, 255}
    steel_high := rl.Color{135, 145, 154, 255}

    rl.DrawRectangle(gx-6, gy-2, bw+12, building_h+8, {18, 18, 21, 120})

    rl.DrawRectangle(gx-4, gy-4, bw+8, 88, steel_dark)
    rl.DrawRectangle(gx, gy, bw, building_h, brick_dark)

    draw_brick_wall(gx, gy+14, bw, building_h-24)

    rl.DrawRectangle(gx-3, gy-6, bw+6, 17, steel_dark)
    rl.DrawRectangle(gx, gy-4, bw, 13, steel_mid)

    for rib_x := gx; rib_x < gx+bw; rib_x += 8 {
        rl.DrawRectangle(rib_x, gy-4, 2, 13, steel_high)
        rl.DrawLine(rib_x+2, gy-4, rib_x+2, gy+8, {49, 53, 59, 255})
    }

    rl.DrawRectangle(gx, gy+9, bw, 6, {18, 19, 22, 255})

    for tile: i32 = 0; tile < bw/6; tile += 1 {
        tile_col := rl.WHITE if tile%2 == 0 else rl.Color{27, 28, 31, 255}
        rl.DrawRectangle(gx+tile*6, gy+9, 6, 3, tile_col)

        lower_col := rl.Color{27, 28, 31, 255} if tile%2 == 0 else rl.WHITE
        rl.DrawRectangle(gx+tile*6, gy+12, 6, 3, lower_col)
    }

    rl.DrawRectangle(gx, gy+69, bw, 11, {104, 101, 96, 255})
    rl.DrawRectangle(gx, gy+69, bw, 2, {55, 54, 53, 255})
    hazard_phase := i32(t*4.0) % 2

    for stripe: i32 = 0; stripe < bw/10+1; stripe += 1 {
        yellow_on := (stripe + hazard_phase) % 2 == 0
        stripe_col := rl.Color{239, 188, 24, 255} if yellow_on else rl.Color{28, 29, 31, 255}
        rl.DrawRectangle(gx+stripe*10, gy+74, 6, 6, stripe_col)
    }
    sponsors := [3]cstring{
        "BUZZ BEER",
        "HONEY MOTORS",
        "POLLEN FUEL",
    }

    sponsor_colors := [3]rl.Color{
        {205, 43, 38, 255},
        {28, 94, 191, 255},
        {28, 151, 89, 255},
    }

    sticker_a := [3]cstring{"3", "8", "1"}
    sticker_b := [3]cstring{"GT", "AM", "LM"}
    open_bay :: i32(1)

    door_group_w := (bay_count-1)*car_spacing + door_w
    first_door_x := gx + (bw-door_group_w)/2

    for b: i32 = 0; b < bay_count; b += 1 {
        door_x := first_door_x + b*car_spacing
        bay_center := door_x + door_w/2

        sign_w :: i32(86)
        sign_x := bay_center-sign_w/2

        draw_retro_sponsor_sign(
            sign_x,
            gy+17,
            sign_w,
            12,
            sponsors[b],
            sponsor_colors[b],
            f32(b)*23.0,
        )

        draw_retro_sticker(
            door_x-12,
            gy+37,
            10,
            9,
            sticker_a[b],
            sponsor_colors[b],
            rl.YELLOW,
        )

        draw_retro_sticker(
            door_x+door_w+2,
            gy+49,
            15,
            9,
            sticker_b[b],
            rl.Color{234, 191, 34, 255},
            {30, 30, 34, 255},
        )

        number_text := strings.clone_to_cstring(
            fmt.tprintf("%02d", b+1),
            context.temp_allocator,
        )

        rl.DrawRectangle(door_x+3, gy+31, 16, 5, {20, 21, 24, 255})
        rl.DrawText(number_text, door_x+5, gy+31, 6, rl.WHITE)

        if b == open_bay {
            draw_retro_open_bay(door_x, gy+door_y, door_w, door_h)
        } else {
            draw_retro_closed_door(
                door_x,
                gy+door_y,
                door_w,
                door_h,
                f32(b)*31.0,
            )
        }

        light_step := i32(t*5.0) + b
        red_on   := light_step%3 == 0
        amber_on := light_step%3 == 1
        green_on := light_step%3 == 2

        light_y := gy+31

        draw_retro_warning_light(
            bay_center-8,
            light_y,
            red_on,
            {255, 55, 45, 255},
        )
        draw_retro_warning_light(
            bay_center,
            light_y,
            amber_on,
            {255, 190, 30, 255},
        )
        draw_retro_warning_light(
            bay_center+8,
            light_y,
            green_on,
            {65, 255, 105, 255},
        )
    }
    draw_steel_column(gx, gy+15, 54)
    draw_steel_column(gx+bw-6, gy+15, 54)

    for b: i32 = 1; b < bay_count; b += 1 {
        column_x := first_door_x + b*car_spacing - (car_spacing-door_w)/2 - 3
        draw_steel_column(column_x, gy+15, 54)
    }

    title := strings.clone_to_cstring(
        "PIT LANE",
        context.temp_allocator,
    )
    title_w := rl.MeasureText(title, 8)

    rl.DrawRectangle(
        gx+bw/2-title_w/2-7,
        gy-3,
        title_w+14,
        11,
        {24, 25, 29, 255},
    )
    rl.DrawText(
        title,
        gx+bw/2-title_w/2,
        gy-1,
        8,
        {255, 215, 55, 255},
    )

    draw_lap_timer(gx+bw/2-53, gy-43, best_lap)
}


finish_line_rect :: proc() -> rl.Rectangle {
    outer := racetrack_outer_rect()
    inner := racetrack_inner_rect()
    return {
        RACETRACK_CENTER.x - FINISH_LINE_THICK/2,
        outer.y,
        FINISH_LINE_THICK,
        inner.y - outer.y,
    }
}

draw_finish_line :: proc() {
    fr := finish_line_rect()
    CHECKER :: i32(5)
    cols := i32(fr.width)  / CHECKER
    rows := i32(fr.height) / CHECKER
    for r in 0..<rows {
        for c in 0..<cols {
            col := rl.WHITE if (r+c)%2==0 else rl.BLACK
            rl.DrawRectangle(pxi(fr.x)+c*CHECKER, pxi(fr.y)+r*CHECKER, CHECKER, CHECKER, col)
        }
    }
    rl.DrawRectangleLines(pxi(fr.x), pxi(fr.y), pxi(fr.width), pxi(fr.height), rl.BLACK)
}

draw_track_banners :: proc(outer: rl.Rectangle) {
    sponsors  := [4]cstring{"BUZZ BEER", "HONEY MOTORS", "WAX & GO", "POLLEN FUEL"}
    colors    := [4]rl.Color{{200,40,40,255}, {40,90,200,255}, {230,180,30,255}, {40,150,60,255}}
    text_cols := [4]rl.Color{{255,255,255,255}, {255,255,255,255}, {40,20,0,255}, {255,255,255,255}}

    board_w :: i32(96)
    board_h :: i32(16)

    span := pxi(outer.width) - 40
    for s in 0..<4 {
        slot := span / 4
        bx := pxi(outer.x) + 20 + i32(s)*slot + (slot - board_w)/2
        by := pxi(outer.y) - 30

        rl.DrawRectangle(bx+2,         by+board_h, 3, 14, {90,90,95,255})
        rl.DrawRectangle(bx+board_w-5, by+board_h, 3, 14, {90,90,95,255})

        rl.DrawRectangle(bx, by, board_w, board_h, colors[s])
        rl.DrawRectangleLines(bx, by, board_w, board_h, {255,255,255,180})
        tw := rl.MeasureText(sponsors[s], 8)
        rl.DrawText(sponsors[s], bx + (board_w-tw)/2, by+4, 8, text_cols[s])
    }
}

get_track_spectator_positions :: proc(outer: rl.Rectangle) -> [MAX_TRACK_SPECTATORS]Vec2 {
    pts: [MAX_TRACK_SPECTATORS]Vec2
    idx := 0
    for i in 0..<4 {
        y := outer.y + 40 + f32(i) * (outer.height-80)/3
        pts[idx] = {outer.x - 16, y}; idx += 1
    }
    for i in 0..<4 {
        y := outer.y + 60 + f32(i) * (outer.height-100)/3
        pts[idx] = {outer.x + outer.width + 16, y}; idx += 1
    }
    pts[idx] = {RACETRACK_CENTER.x - RACETRACK_GATE_HW - 24, outer.y + outer.height + 14}; idx += 1
    pts[idx] = {RACETRACK_CENTER.x + RACETRACK_GATE_HW + 24, outer.y + outer.height + 14}
    return pts
}

draw_track_spectator :: proc(x, y: f32, shirt: rl.Color, flag: rl.Color, phase: f32) {
    ix := pxi(x); iy := pxi(y)
    t  := f32(rl.GetTime())
    wave := math.sin(t*3 + phase)
    rl.DrawEllipse(ix, iy+1, 6, 2, {0,0,0,60})
    rl.DrawRectangle(ix-3, iy-8, 2, 8, {50,50,70,255})
    rl.DrawRectangle(ix+1, iy-8, 2, 8, {50,50,70,255})
    rl.DrawRectangle(ix-4, iy-18, 8, 10, shirt)
    rl.DrawRectangle(ix-3, iy-24, 6, 6, {235,190,150,255})
    rl.DrawRectangle(ix+3, iy-22, 2, 6, shirt)
    pole_top := iy - 34
    rl.DrawRectangle(ix+4, pole_top, 1, 14, {120,90,50,255})
    fw := i32(10 + wave*2)
    rl.DrawRectangle(ix+5, pole_top, fw, 6, flag)
    rl.DrawRectangleLines(ix+5, pole_top, fw, 6, {0,0,0,60})
}

draw_track_spectators :: proc(outer: rl.Rectangle) {
    shirts := [5]rl.Color{{200,60,60,255},{60,120,200,255},{230,200,60,255},{90,180,90,255},{200,120,200,255}}
    flags  := [5]rl.Color{{240,240,240,255},{220,50,50,255},{255,200,40,255},{60,200,220,255},{240,240,240,255}}
    pts := get_track_spectator_positions(outer)
    phases := [MAX_TRACK_SPECTATORS]f32{0,1.3,1.9,2.6,3.2,3.9,2.0,2.5,2.9,3.8,4.7,4.5,4.2,5.1}
    for i in 0..<MAX_TRACK_SPECTATORS {
        draw_track_spectator(pts[i].x, pts[i].y, shirts[i%5], flags[i%5], phases[i])
    }
}


draw_racetrack_wall :: proc(outer: rl.Rectangle) {
    gate_cx := RACETRACK_CENTER.x
    draw_fence_segment(outer.x, outer.y, outer.x+outer.width, outer.y)
    draw_fence_segment(outer.x, outer.y, outer.x, outer.y+outer.height)
    draw_fence_segment(outer.x+outer.width, outer.y, outer.x+outer.width, outer.y+outer.height)
    draw_fence_segment(outer.x, outer.y+outer.height, gate_cx-RACETRACK_GATE_HW, outer.y+outer.height)
    draw_fence_segment(gate_cx+RACETRACK_GATE_HW, outer.y+outer.height, outer.x+outer.width, outer.y+outer.height)
    rl.DrawRectangle(pxi(gate_cx-RACETRACK_GATE_HW)-3, pxi(outer.y+outer.height)-12, 6, 20, {120,80,40,255})
    rl.DrawRectangle(pxi(gate_cx+RACETRACK_GATE_HW)-3, pxi(outer.y+outer.height)-12, 6, 20, {120,80,40,255})
}
g_race_timer: RaceTimer

point_in_rect :: proc(p: Vec2, r: rl.Rectangle) -> bool {
    return p.x >= r.x && p.x <= r.x+r.width && p.y >= r.y && p.y <= r.y+r.height
}

pos_on_racetrack :: proc(p: Vec2) -> bool {
    outer := racetrack_outer_rect()
    inner := racetrack_inner_rect()
    if !point_in_rect(p, outer) { return false }
    if point_in_rect(p, inner)  { return false }
    return true
}

update_race_timer :: proc() {
    dt := g.dt
    if !g_race_timer.enabled {
        return
    }

    track_pos: Vec2
    if g.in_car {
        track_pos = g.cars[g.current_car].pos
    } else {
        track_pos = g.player.pos
    }

    if !pos_on_racetrack(track_pos) {
        g_race_timer.active   = false
        g_race_timer.had_prev = false
        g_race_timer.current_lap = 0
        return
    }

    fr := finish_line_rect()
    on_straight := track_pos.y >= fr.y && track_pos.y <= fr.y + fr.height
    side := track_pos.x < fr.x + fr.width/2

    if g_race_timer.active {
        g_race_timer.current_lap += f64(dt)
    }

    if on_straight {
        if g_race_timer.had_prev && side != g_race_timer.prev_side {
            if g_race_timer.prev_side == true && side == false {
                if g_race_timer.active {
                    g_race_timer.last_lap = g_race_timer.current_lap
                    if g_race_timer.best_lap == 0 || g_race_timer.last_lap < g_race_timer.best_lap {
                        g_race_timer.best_lap = g_race_timer.last_lap
                    }
                    g_race_timer.laps += 1
                }
                g_race_timer.active = true
                g_race_timer.current_lap = 0
            }
        }
        g_race_timer.prev_side = side
        g_race_timer.had_prev = true
    }
}
update_race_timer_toggle :: proc() {
    if rl.IsKeyPressed(.LEFT_SHIFT) {
        track_pos: Vec2 = g.cars[g.current_car].pos if g.in_car else g.player.pos
        if pos_on_racetrack(track_pos) {
            g_race_timer.enabled = !g_race_timer.enabled
            if !g_race_timer.enabled {
                g_race_timer.active = false
                g_race_timer.current_lap = 0
            }
        }
    }
}
TrackFlash :: struct { timer: f32, active: bool, life: f32 }
g_track_flashes: [MAX_TRACK_SPECTATORS]TrackFlash

update_track_flashes :: proc() {
    dt := g.dt
    for i in 0..<MAX_TRACK_SPECTATORS {
        f := &g_track_flashes[i]
        if f.active {
            f.life -= dt
            if f.life <= 0 {
                f.active = false
                f.timer  = 1.2 + mp_night_hash01(u32(i)*911 + u32(f32(rl.GetTime())*137))*4.0
            }
        } else {
            f.timer -= dt
            if f.timer <= 0 {
                f.active = true
                f.life   = 0.12
            }
        }
    }
}

draw_camera_flashes :: proc(outer: rl.Rectangle) {
    pts := get_track_spectator_positions(outer)
    t := f32(rl.GetTime())
    for i in 0..<MAX_TRACK_SPECTATORS {
        f := g_track_flashes[i]
        if !f.active { continue }
        alpha := u8(255.0 * (f.life/0.12))
        fx := pxi(pts[i].x); fy := pxi(pts[i].y) - 26
        rl.DrawCircle(fx, fy, 10, {255,255,255,alpha/3})
        rl.DrawCircle(fx, fy, 5,  {255,255,255,alpha})
        for a in 0..<4 {
            ang := f32(a)*(math.PI*0.5) + t*10
            ex := fx + i32(math.cos(ang)*9)
            ey := fy + i32(math.sin(ang)*9)
            rl.DrawLine(fx, fy, ex, ey, {255,255,255,alpha})
        }
    }
}




format_race_time :: proc(t: f64) -> string {
    total_ms := int(t * 1000.0)
    seconds  := (total_ms / 1000) % 60
    minutes  := total_ms / 60000
    ms       := total_ms % 1000
    return fmt.tprintf("%02d:%02d.%03d", minutes, seconds, ms)
}

draw_race_timer_hud :: proc() {
    status := "ON" if g_race_timer.enabled else "OFF"
    status_col := rl.Color{80,255,80,255} if g_race_timer.enabled else rl.Color{200,80,80,255}
    status_cstr := strings.clone_to_cstring(fmt.tprintf("TIMER [T]: %s", status), context.temp_allocator)
    rl.DrawText(status_cstr, pxi(RACETRACK_CENTER.x)-30, pxi(racetrack_outer_rect().y)-64, 10, status_col)

    if !g_race_timer.enabled { return }

    cur_str  := format_race_time(g_race_timer.current_lap)
    cur_cstr := strings.clone_to_cstring(fmt.tprintf("LAP  %s", cur_str), context.temp_allocator)
    rl.DrawText(cur_cstr, pxi(RACETRACK_CENTER.x)-30, pxi(racetrack_outer_rect().y)-52, 10, rl.WHITE)

    if g_race_timer.best_lap > 0 {
        best_str  := format_race_time(g_race_timer.best_lap)
        best_cstr := strings.clone_to_cstring(fmt.tprintf("BEST %s", best_str), context.temp_allocator)
        rl.DrawText(best_cstr, pxi(RACETRACK_CENTER.x)-30, pxi(racetrack_outer_rect().y)-40, 10, {255,215,0,255})
    }
    if g_race_timer.laps > 0 {
        laps_cstr := strings.clone_to_cstring(fmt.tprintf("LAPS %d", g_race_timer.laps), context.temp_allocator)
        rl.DrawText(laps_cstr, pxi(RACETRACK_CENTER.x)-30, pxi(racetrack_outer_rect().y)-28, 10, rl.WHITE)
    }
}
draw_track_direction_arrow :: proc(cx, cy: f32) {
    col :: rl.Color{255,215,0,255} // yellow
    rl.DrawLineEx({cx+22, cy}, {cx+4, cy}, 4, col)
    rl.DrawTriangle({cx-12, cy}, {cx+4, cy-8}, {cx+4, cy+8}, col)
}

draw_track_direction_sign :: proc() {
    outer   := racetrack_outer_rect()
    gate_cx := RACETRACK_CENTER.x
    gate_y  := outer.y + outer.height + 20

    spacing := f32(30)
    for i in 0..<3 {
        ax := gate_cx - spacing + f32(i)*spacing
        draw_track_direction_arrow(ax, gate_y)
    }

    label     :: "TRACK DIRECTION:CLOCKWISE | TOGGLE LAP TIMER:LEFT SHIFT"
    label_col :: rl.Color{255,215,0,255}
    lcstr := strings.clone_to_cstring(label, context.temp_allocator)
    lw := rl.MeasureText(lcstr, 10)
    rl.DrawText(lcstr, pxi(gate_cx) - lw/2, pxi(gate_y+12), 8, label_col)
}


draw_park_entrance_sign :: proc(r: rl.Rectangle) {
    gate_cx := r.x + r.width/2
    fence_y := r.y + r.height

    title     :: "HONEYCOMB PARK"
    font_size :: i32(8)
    text_w    := rl.MeasureText(title, font_size)
    pad_x     :: i32(14)
    board_w   := text_w + pad_x*2
    board_h   :: i32(30)

    post_w    :: f32(6)
    overlap   :: f32(8)

    post_half_gap := f32(board_w)/2 - 4
    post_lx := gate_cx - post_half_gap
    post_rx := gate_cx + post_half_gap

    post_bottom := fence_y - 6 + f32(30)

    board_y := fence_y - 6 - f32(board_h) - 14

    post_top := board_y + f32(board_h) - overlap
    post_h   := post_bottom - post_top

    board_x := gate_cx - f32(board_w)/2

    rl.DrawRectangle(pxi(post_lx - post_w/2), pxi(post_top), pxi(post_w), pxi(post_h), COL_TREE_TRUNK)
    rl.DrawRectangle(pxi(post_lx - post_w/2), pxi(post_top), 2, pxi(post_h), {148,100,56,255})
    rl.DrawRectangle(pxi(post_rx - post_w/2), pxi(post_top), pxi(post_w), pxi(post_h), COL_TREE_TRUNK)
    rl.DrawRectangle(pxi(post_rx - post_w/2), pxi(post_top), 2, pxi(post_h), {148,100,56,255})

    rl.DrawRectangle(pxi(board_x), pxi(board_y), board_w, board_h, {80,56,24,255})
    rl.DrawRectangleLinesEx({board_x, board_y, f32(board_w), f32(board_h)}, 1, COL_HONEY)
    rl.DrawText(title, pxi(gate_cx) - text_w/2, pxi(board_y) + (board_h - font_size)/2, font_size, COL_HONEY)
}
draw_farmers_market :: proc() {
    b := g.buildings[.FarmersMarket]
    x, y := FARMERS_MARKET_X, FARMERS_MARKET_Y

    rl.DrawRectangle(pxi(x), pxi(y), pxi(FARMERS_MARKET_W), pxi(FARMERS_MARKET_H), COL_MARKET_STALL)
    rl.DrawRectangle(pxi(x)-6, pxi(y)-14, pxi(FARMERS_MARKET_W)+12, 16, COL_MARKET_AWNING)
    rl.DrawRectangleLinesEx({x, y, FARMERS_MARKET_W, FARMERS_MARKET_H}, 2, rl.BLACK)

    if !b.owned {
        rl.DrawText("Farmers Market", pxi(x)+8, pxi(y)+8, 10, rl.WHITE)
        rl.DrawText(fmt.ctprintf("Press E - $%.0f", FARMERS_MARKET_COST), pxi(x)+8, pxi(y)+24, 8, COL_HONEY)
    } else if g.is_night {
        rl.DrawText("CLOSED", pxi(x)+8, pxi(y)+8, 10, rl.RED)
    } else {
        rl.DrawText("OPEN - Press E", pxi(x)+8, pxi(y)+8, 9, rl.GREEN)
        rl.DrawText(fmt.ctprintf("Price: $%.0f", g.market_price), pxi(x)+8, pxi(y)+22, 8, COL_HONEY)
    }
}



// DRAW BUILDING (exterior)


draw_building :: proc(b: Building) {
    r  := b.rect
    rx := pxi(r.x);     ry := pxi(r.y)
    rw := pxi(r.width); rh := pxi(r.height)

    // Shadow
    rl.DrawRectangle(rx+4, ry+4, rw, rh, COL_SHADOW)

    if b.kind == .CarDealership {
        draw_car_dealership_exterior()
        if vec2_dist(g.player.pos, b.door) < INTERACT_DIST {
	    if b.kind == .Garage {
		if !b.owned {
		    rl.DrawText("[E] Buy Garage", pxi(b.door.x)-30, pxi(b.door.y)-16, 8, COL_HONEY)
		} else {
		    rl.DrawText("[E] Enter Garage", pxi(b.door.x)-34, pxi(b.door.y)-16, 8, COL_HONEY)
		}
	    } else {
		rl.DrawText("[E] Enter", pxi(b.door.x)-20, pxi(b.door.y)-16, 8, COL_HONEY)
	    }
        }

	return
    }

    draw_bricks(rx, ry, rw, rh, COL_BRICK, COL_BRICK2)
    rl.DrawRectangle(rx, ry, rw, rh, rl.Color{b.color.r, b.color.g, b.color.b, 120})

    rl.DrawRectangle(rx-4, ry-10, rw+8, 12, COL_ROOF)
    rl.DrawRectangle(rx-4, ry-10, rw+8, 3,  COL_ROOF2)
    for ti := rx-4; ti < rx+rw+4; ti += 8 {
        rl.DrawRectangle(ti,   ry-10, 7, 12, COL_ROOF)
        rl.DrawRectangle(ti+7, ry-10, 1, 12, COL_ROOF2)
    }

    // Chimney + smoke
    rl.DrawRectangle(rx+rw-28, ry-26, 14, 20, COL_CHIMNEY)
    rl.DrawRectangle(rx+rw-30, ry-28, 18,  4, COL_CHIMNEY)
    t := f32(rl.GetTime())
    for si in 0..<3 {
        sa := f32(si)*0.8 + t*0.4
        sx := rx + rw - 21 + i32(math.sin(sa)*3)
        sy := ry - 32 - i32(si)*8
        rl.DrawCircle(sx, sy, f32(4-i32(si)), {200,200,200,u8(80-si*20)})
    }

    // Windows
    win_col  := rl.Color{160,210,240,220}
    win_col2 := rl.Color{120,170,200,180}
    for wi in 0..<2 {
        wx := rx + 12 + i32(wi)*(rw-44)
        wy := ry + 18
        rl.DrawRectangle(wx,   wy,    20, 16, win_col2)
        rl.DrawRectangle(wx+1, wy+1,  18, 14, win_col)
        rl.DrawRectangle(wx+9, wy,     2, 16, {80,120,160,255})
        rl.DrawRectangle(wx,   wy+7,  20,  2, {80,120,160,255})
        rl.DrawRectangle(wx-1, wy+16, 22,  3, COL_SIDEWALK)
    }

    // Door
    door_x := rx + rw/2 - 8
    door_y := ry + rh - 28
    rl.DrawRectangle(door_x,    door_y,    16, 28, {56,36,16,255})
    rl.DrawRectangle(door_x+1,  door_y+1,  14, 26, {72,48,24,255})
    rl.DrawRectangle(door_x,    door_y-4,  16,  6, {56,36,16,255})
    rl.DrawCircle(door_x+8, door_y-2, 8, {56,36,16,255})
    rl.DrawRectangle(door_x+11, door_y+12,  3,  3, {200,170,50,255})
    rl.DrawRectangle(door_x-3,  door_y+26, 22,  4, COL_SIDEWALK)
    rl.DrawRectangle(door_x+2,  door_y+30, 12, 40, COL_PATH)

    // Lamp posts
    draw_lamp_post(rx-14,   ry+rh-10)
    draw_lamp_post(rx+rw+6, ry+rh-10)

    // Per-building unique details
    #partial switch b.kind {
    case .Market:
        for ai := 0; ai < 7; ai += 1 {
            col := COL_HONEY if ai%2==0 else rl.Color{255,255,255,200}
            rl.DrawRectangle(rx+i32(ai)*28, ry-22, 28, 14, col)
        }
        rl.DrawRectangle(rx, ry-22, rw, 2, {80,60,20,255})
        rl.DrawRectangle(rx+8, ry+rh-52, rw-16, 14, {40,28,8,230})
        rl.DrawRectangleLinesEx({f32(rx+8), f32(ry+rh-52), f32(rw-16), 14}, 1, COL_HONEY)
        rl.DrawText("   ==FRESH HONEY & GOODS==   ", rx+12, ry+rh-50, 7, COL_HONEY)
    case .SheriffOffice:
        rl.DrawText("*", door_x+4, door_y+6, 14, {255,220,0,255})
        rl.DrawRectangle(rx+rw-8,  ry-44,  3, 52, {100,80,60,255})
        rl.DrawRectangle(rx+rw-5,  ry-44, 22, 14, {200,40,40,255})
        rl.DrawRectangle(rx+rw-5,  ry-37, 22,  7, {255,255,255,255})
    case .BeeSanctuary:
    rl.DrawRectangle(rx+6, ry-20, rw-12, 12, {40,90,40,250})
    rl.DrawRectangleLinesEx({f32(rx+6), f32(ry-20), f32(rw-12), 12}, 1, {140,220,120,255})
    rl.DrawText("  ~*~ BEE SANCTUARY ~*~  ", rx+10, ry-18, 7, {180,255,150,255})
    rl.DrawCircle(rx+10, ry+rh-6, 6, COL_TREE_LEAF)
    rl.DrawCircle(rx+rw-10, ry+rh-6, 6, COL_TREE_LEAF)	
    case .DoctorOffice:
        rl.DrawRectangle(rx+rw/2-4,  ry+14,  8, 22, {200,40,40,255})
        rl.DrawRectangle(rx+rw/2-12, ry+20, 24,  8, {200,40,40,255})
        rl.DrawRectangle(rx+rw/2-3,  ry+15,  6, 20, {240,60,60,255})
    case .Bank:
	pillar_offsets := [4]i32{20, 60, 140, 180}
	for off in pillar_offsets {
	    cx := rx + off
	    rl.DrawRectangle(cx,    ry-6, 8, rh+6, {180,160,120,255})
	    rl.DrawRectangle(cx+1,  ry-6, 6, rh+6, {205,188,150,255})
	    rl.DrawRectangle(cx-2,  ry-8,     12, 4, {225,212,180,255}) // capital
	    rl.DrawRectangle(cx-2,  ry+rh-4,  12, 4, {225,212,180,255}) // base
        }
	apex_x := rx + rw/2
	rl.DrawTriangle(
	    {f32(rx-10), f32(ry-10)},
	    {f32(rx+rw+10), f32(ry-10)},
	    {f32(apex_x), f32(ry-34)},
	    {200,180,130,255})
        rl.DrawTriangleLines(
            {f32(rx-10), f32(ry-10)},
            {f32(apex_x), f32(ry-34)},
            {f32(rx+rw+10), f32(ry-10)},
            {90,70,40,255})

        rl.DrawRectangle(rx-6, ry+rh-4, rw+12, 6, {195,185,165,255})
        rl.DrawRectangle(rx-2, ry+rh+2, rw+4,  6, {175,165,145,255})
    	rl.DrawRectangle(rx+8, ry+rh-52, rw-16, 14, {60,48,20,230})
    	rl.DrawText("   ==FIRST HONEY BANK==   ", rx+14, ry+rh-50, 7, COL_HONEY)

    case .Diner:
        for ci in 0..<12 {
            col := rl.Color{240,240,240,200} if ci%2==0 else rl.Color{20,20,20,200}
            rl.DrawRectangle(rx+i32(ci)*16, ry+rh-10, 16, 10, col)
        }
        rl.DrawRectangle(rx+6, ry-20, rw-12, 12, {24,12,6,240})
        rl.DrawRectangleLinesEx({f32(rx+6), f32(ry-20), f32(rw-12), 12}, 1, {255,100,50,255})
        rl.DrawText("  -=-HONEY BEE DINER-=-  ", rx+10, ry-18, 7, {255,160,80,255})
    case .Bar:
        rl.DrawRectangle(rx+6, ry-20, rw-12, 12, {20,10,4,250})
        rl.DrawRectangleLinesEx({f32(rx+6), f32(ry-20), f32(rw-12), 12}, 1, {160,100,40,255})
        rl.DrawText("   =--THE BUZZED B's BAR--=   ", rx+10, ry-18, 7, {200,140,40,255})
    case .CarDealership:
}
    lbl := strings.clone_to_cstring(b.label, context.temp_allocator)
    tw  := rl.MeasureText(lbl, 9)
    rl.DrawRectangle(rx+rw/2-tw/2-3, ry+rh+2, tw+6, 11, {0,0,0,140})
    rl.DrawText(lbl, rx+rw/2-tw/2, ry+rh+3, 9, {255,255,255,220})

    if vec2_dist(g.player.pos, b.door) < INTERACT_DIST {
        rl.DrawText("[E] Enter", pxi(b.door.x)-20, pxi(b.door.y)-16, 8, COL_HONEY)
    }
    if b.kind == .BeeSanctuary && g.sanctuary_donated >= BEE_SANCTUARY_GOAL {
    sign_x := b.door.x + 40
    sign_y := b.door.y
    rl.DrawRectangle(pxi(sign_x)-3, pxi(sign_y)-30, 6, 30, {100,70,40,255})
    rl.DrawRectangle(pxi(sign_x)-34, pxi(sign_y)-46, 68, 20, {230,250,230,255})
    rl.DrawRectangleLinesEx({sign_x-34, sign_y-46, 68, 20}, 1, COL_SANCTUARY)
    rl.DrawText("Bee Sanctuary", pxi(sign_x)-30, pxi(sign_y)-44, 7, {30,90,30,255})
    rl.DrawText("funded by you.", pxi(sign_x)-30, pxi(sign_y)-35, 7, {30,90,30,255})
}
}

draw_pixel_car :: proc(x, y: f32, col: rl.Color) {
    ix := pxi(x); iy := pxi(y)
    // Body
    rl.DrawRectangle(ix,      iy - 10, 60, 14, col)
    // Roof
    rl.DrawRectangle(ix + 10, iy - 20, 36, 12, col)
    // Wheels
    rl.DrawCircle(ix + 12, iy + 4, 7, {30, 30, 30, 255})
    rl.DrawCircle(ix + 48, iy + 4, 7, {30, 30, 30, 255})
    rl.DrawCircle(ix + 12, iy + 4, 3, {180, 180, 180, 255})
    rl.DrawCircle(ix + 48, iy + 4, 3, {180, 180, 180, 255})
    // Windows
    rl.DrawRectangle(ix + 12, iy - 18, 14, 9, {160, 210, 240, 200})
    rl.DrawRectangle(ix + 30, iy - 18, 14, 9, {160, 210, 240, 200})
}

draw_car_dealership_exterior :: proc () {
	b	:= g.buildings[.CarDealership]
	rx	:= b.rect.x
	ry	:= b.rect.y
	rw	:= b.rect.width
	rh	:= b.rect.height

	rl.DrawRectangleRec(b.rect, COL_DEALER_STEEL)
	glass_h := rh * 0.60
	rl.DrawRectangle(pxi(rx + 4), pxi(ry + 4), pxi(rw - 8), pxi(glass_h),
	    COL_DEALER_GLASS)
	bar_count := int(rw / 40)
	for i in 1..<bar_count {
	    bx := rx + f32(i) * (rw / f32(bar_count))
	    rl.DrawRectangle(pxi(bx - 1), pxi(ry + 4), 3, pxi(glass_h), COL_DEALER_TRIM)
	}
	rl.DrawRectangle(pxi(rx), pxi(ry), pxi(rw), 5, COL_DEALER_TRIM)
	rl.DrawRectangle(pxi(rx), pxi(ry + glass_h), pxi(rw), 4, COL_DEALER_TRIM)
	rl.DrawRectangle(pxi(rx - 6), pxi(ry - 6), pxi(rw + 12), 10, COL_DEALER_TRIM)
	rl.DrawRectangle(pxi(rx + 20), pxi(ry + 6), pxi (rw - 40), 14, COL_DEALER_SIGN)
	rl.DrawText("HONEYVILLE MOTORS", pxi(rx + 28), pxi(ry + 8), 8, rl.WHITE)
	draw_pixel_car(rx + 28,  ry + glass_h - 28, COL_CAR_RED)
	draw_pixel_car(rx + 110, ry + glass_h - 28, COL_CAR_BLUE)
	draw_pixel_car(rx + 210, ry + glass_h - 28, COL_CAR_YELLOW)
	door_w :: f32(28);door_h :: f32(36)
	rl.DrawRectangle(pxi(b.door.x - door_w/2), pxi(b.door.y - door_h),
	    pxi(door_w), pxi(door_h), COL_DEALER_STEEL)
	rl.DrawRectangle(pxi(b.door.x - door_w/2 + 2), pxi(b.door.y - door_h + 2),
	    pxi(door_w - 4), pxi(door_h - 4), COL_DEALER_GLASS)
	rl.DrawRectangle(pxi(rx + 4), pxi(ry + rh), pxi(rw), 6, COL_SHADOW)
}
car_rotate_offset :: proc(local: Vec2, angle_deg: f32) -> Vec2 {
    rad := angle_deg * math.PI / 180.0
    c := math.cos(rad)
    s := math.sin(rad)
    return Vec2{ local.x*c - local.y*s, local.x*s + local.y*c }
}
car_world_point :: proc(car: Car, local: Vec2) -> Vec2 {
    off := car_rotate_offset(local, car.angle)
    return Vec2{ car.pos.x + off.x, car.pos.y + off.y }
}

car_draw_local_rect :: proc(car: Car, local: Vec2, w, h: f32, col: rl.Color) {
    center := car_world_point(car, local)
    rec := rl.Rectangle{ center.x, center.y, w, h }
    rl.DrawRectanglePro(rec, {w/2, h/2}, car.angle, col)
}

draw_car :: proc(car: Car) {
    if !car.active { return }

    rl.DrawEllipse(pxi(car.pos.x), pxi(car.pos.y + 10), 22, 6, COL_SHADOW)

    switch car.kind {

    case .HoneyRacer:
        car_draw_local_rect(car, {0, 0}, 34, 20, car.body_col)          // body
        car_draw_local_rect(car, {-5, 0}, 15, 16, COL_CAR_WINDOW)       // tall rear hatchback cabin/glass
        car_draw_local_rect(car, {16, -6}, 4, 4, HEADLIGHT_COL)         // headlight L
        car_draw_local_rect(car, {16,  6}, 4, 4, HEADLIGHT_COL)         // headlight R
        car_draw_local_rect(car, {-16, -6}, 4, 4, TAILLIGHT_COL)        // taillight L
        car_draw_local_rect(car, {-16,  6}, 4, 4, TAILLIGHT_COL)        // taillight R

    case .BeeCruiser:
        bed_col := rl.Color{
            u8(f32(car.body_col.r) * 0.75),
            u8(f32(car.body_col.g) * 0.75),
            u8(f32(car.body_col.b) * 0.75),
            car.body_col.a,
        }
        car_draw_local_rect(car, {-9, 0}, 30, 24, bed_col)              // cargo bed (rear, wider footprint)
        car_draw_local_rect(car, {14, 0}, 20, 22, car.body_col)         // cab (front)
        car_draw_local_rect(car, {10, 0}, 12, 16, COL_CAR_WINDOW)       // windshield
        car_draw_local_rect(car, {24, -8}, 5, 5, HEADLIGHT_COL)         // headlight L
        car_draw_local_rect(car, {24,  8}, 5, 5, HEADLIGHT_COL)         // headlight R
        car_draw_local_rect(car, {-24, -8}, 5, 5, TAILLIGHT_COL)        // taillight L
        car_draw_local_rect(car, {-24,  8}, 5, 5, TAILLIGHT_COL)        // taillight R

    case .PollenGT:
        car_draw_local_rect(car, {0, 0}, 46, 20, car.body_col)          // long, low, wide body
        car_draw_local_rect(car, {6, 0}, 12, 14, COL_CAR_WINDOW)        // narrow forward-set windshield
        car_draw_local_rect(car, {-24, 0}, 4, 26, rl.Color{20, 20, 20, 255}) // iconic rear spoiler bar
        rl.DrawCircle(pxi(car_world_point(car, {22, -8}).x), pxi(car_world_point(car, {22, -8}).y), 3, HEADLIGHT_COL) // headlight L
        rl.DrawCircle(pxi(car_world_point(car, {22,  8}).x), pxi(car_world_point(car, {22,  8}).y), 3, HEADLIGHT_COL) // headlight R
        car_draw_local_rect(car, {-19, -8}, 4, 4, TAILLIGHT_COL)        // taillight L
        car_draw_local_rect(car, {-19,  8}, 4, 4, TAILLIGHT_COL)        // taillight R
    }

    if car.occupied {
        rl.DrawText("vroom", pxi(car.pos.x)-10, pxi(car.pos.y)-26, 6, COL_HONEY)
    }
}

draw_cars :: proc() {
    for i in 0..<MAX_CARS {
        c := &g.cars[i]
        if c.active { draw_car(c^) }
    }
}

// DRAW BUILDING (INTERIOR)

interior_room_size :: proc(bt: BuildingType) -> (f32, f32) {
    #partial switch bt {
    case .BeeSanctuary, .FuzzyBuddyFactory:
        return 520, 340

    case .Market,
         .SheriffOffice,
         .DoctorOffice,
         .Bank,
         .Diner,
         .Bar,
         .CarDealership:
        return 300, 220
    }

    return 300, 220
}


int16_light :: proc(
    x, y: i32,
    active: bool,
    bright, dim: rl.Color,
) {
    // Dark square fixture.
    rl.DrawRectangle(x-5, y-3, 11, 7, {18, 19, 24, 255})
    rl.DrawRectangle(x-4, y-2, 9, 5, dim)

    if active {
        // Square pixel glow.
        rl.DrawRectangle(
            x-7,
            y-1,
            15,
            3,
            {bright.r, bright.g, bright.b, 42},
        )
        rl.DrawRectangle(
            x-1,
            y-5,
            3,
            11,
            {bright.r, bright.g, bright.b, 32},
        )

        rl.DrawRectangle(x-3, y-1, 7, 3, bright)
        rl.DrawRectangle(x-2, y-1, 2, 1, rl.WHITE)
    } else {
        rl.DrawRectangle(x-3, y-1, 7, 3, dim)
    }
}


int16_sign :: proc(
    x, y, w, h: i32,
    label: string,
    background, foreground: rl.Color,
    t, phase: f32,
) {
    // Pixel-stepped frame.
    rl.DrawRectangle(x-3, y+2, w+6, h-4, {23, 24, 29, 255})
    rl.DrawRectangle(x-1, y, w+2, h, {79, 84, 90, 255})
    rl.DrawRectangle(x, y+1, w, h-2, background)

    // Animated vertical shine.
    shine_range := f32(w+12)
    shine_x := i32(math.mod(t*18.0+phase, shine_range))-6

    rl.BeginScissorMode(x, y+1, w, h-2)
    rl.DrawRectangle(
        x+shine_x,
        y+1,
        4,
        h-2,
        {255, 255, 255, 55},
    )
    rl.EndScissorMode()

    text_w := rl.MeasureText(
        strings.clone_to_cstring(label, context.temp_allocator),
        8,
    )

    draw_retro_text(
        label,
        x+w/2-text_w/2,
        y+h/2-4,
        8,
        foreground,
    )
}
int16_floor :: proc(
    x, y, w, h: i32,
    first, second: rl.Color,
) {
    tile_size: i32 = 16

    for row: i32 = 0; row*tile_size < h; row += 1 {
        for col: i32 = 0; col*tile_size < w; col += 1 {
            tile_col := first
            if (row+col)%2 != 0 {
                tile_col = second
            }

            tx := x+col*tile_size
            ty := y+row*tile_size

            rl.DrawRectangle(tx, ty, tile_size-1, tile_size-1, tile_col)
            rl.DrawRectangle(
                tx+1,
                ty+1,
                tile_size-3,
                1,
                {255, 255, 255, 18},
            )
        }
    }
}

int16_plant :: proc(x, y: i32, t, phase: f32) {
    sway := i32(math.sin(t*1.5+phase)*2.0)

    // Terracotta pot.
    rl.DrawRectangle(x-8, y-12, 17, 4, {82, 46, 31, 255})
    rl.DrawRectangle(x-6, y-8, 13, 9, {159, 82, 51, 255})
    rl.DrawRectangle(x-5, y-7, 11, 2, {200, 108, 65, 255})
    rl.DrawRectangle(x-4, y-2, 9, 3, {110, 57, 38, 255})

    // Stem.
    rl.DrawRectangle(x, y-29, 2, 18, {38, 104, 49, 255})

    // Chunky leaves.
    rl.DrawRectangle(x-10+sway, y-28, 10, 6, {46, 139, 58, 255})
    rl.DrawRectangle(x-7+sway, y-32, 7, 6, {71, 172, 78, 255})

    rl.DrawRectangle(x+2-sway, y-25, 10, 6, {39, 119, 51, 255})
    rl.DrawRectangle(x+3-sway, y-30, 7, 6, {62, 158, 70, 255})

    rl.DrawRectangle(x-4, y-37, 10, 8, {72, 176, 79, 255})
    rl.DrawRectangle(x-2, y-39, 6, 3, {113, 202, 105, 255})
}


int16_produce_crate :: proc(
    x, y: i32,
    produce_col: rl.Color,
    t, phase: f32,
) {
    // Wooden crate.
    rl.DrawRectangle(x-2, y-2, 65, 30, {48, 31, 21, 255})
    rl.DrawRectangle(x, y, 61, 26, {150, 94, 46, 255})
    rl.DrawRectangle(x+3, y+4, 55, 17, {91, 58, 32, 255})
    rl.DrawRectangle(x+2, y+20, 57, 4, {193, 127, 65, 255})

    // Seven pieces of animated produce.
    for item: i32 = 0; item < 7; item += 1 {
        item_x := x+5+item*8
        item_y := y+6+(item%2)*6
        bob := i32(math.sin(t*2.0+phase+f32(item))*1.0)

        rl.DrawRectangle(
            item_x,
            item_y+bob,
            6,
            6,
            {43, 74, 35, 255},
        )
        rl.DrawRectangle(
            item_x+1,
            item_y+1+bob,
            5,
            5,
            produce_col,
        )
        rl.DrawRectangle(
            item_x+2,
            item_y-1+bob,
            2,
            2,
            {48, 132, 52, 255},
        )
        rl.DrawRectangle(
            item_x+2,
            item_y+2+bob,
            1,
            1,
            {255, 255, 255, 95},
        )
    }
}


int16_takeout_bag :: proc(
    x, y: i32,
    bag_col, logo_col: rl.Color,
) {
    // Handles.
    rl.DrawRectangle(x+3, y-5, 2, 6, {76, 50, 29, 255})
    rl.DrawRectangle(x+10, y-5, 2, 6, {76, 50, 29, 255})
    rl.DrawRectangle(x+4, y-6, 7, 2, {76, 50, 29, 255})

    // Bag outline and body.
    rl.DrawRectangle(x-1, y-1, 17, 18, {38, 29, 22, 255})
    rl.DrawRectangle(x, y, 15, 16, bag_col)
    rl.DrawRectangle(x+1, y+1, 13, 2, {238, 207, 147, 255})
    rl.DrawRectangle(x+2, y+14, 11, 1, {145, 104, 60, 255})

    // Cute pixel restaurant logo.
    rl.DrawRectangle(x+5, y+6, 6, 6, logo_col)
    rl.DrawRectangle(x+6, y+5, 4, 8, logo_col)
    rl.DrawRectangle(x+7, y+7, 2, 4, {255, 221, 126, 255})
}


int16_money_stack :: proc(x, y: i32, sparkle: bool) {
    for layer: i32 = 0; layer < 3; layer += 1 {
        layer_y := y-layer*4
        layer_x := x+(layer%2)

        rl.DrawRectangle(
            layer_x-1,
            layer_y-1,
            24,
            6,
            {22, 38, 27, 255},
        )
        rl.DrawRectangle(
            layer_x,
            layer_y,
            22,
            4,
            {54, 155, 77, 255},
        )
        rl.DrawRectangle(
            layer_x+2,
            layer_y+1,
            18,
            1,
            {113, 215, 127, 255},
        )
        rl.DrawRectangle(
            layer_x+9,
            layer_y,
            4,
            4,
            {230, 206, 112, 255},
        )
    }

    if sparkle {
        rl.DrawRectangle(x+24, y-16, 2, 10, {255, 244, 145, 255})
        rl.DrawRectangle(x+20, y-12, 10, 2, {255, 244, 145, 255})
        rl.DrawRectangle(x+23, y-13, 4, 4, rl.WHITE)
    }
}


int16_gold_stack :: proc(x, y: i32, sparkle: bool) {
    gold      := rl.Color{232, 174, 29, 255}
    gold_hi   := rl.Color{255, 223, 78, 255}
    gold_dark := rl.Color{148, 94, 16, 255}

    for bar: i32 = 0; bar < 3; bar += 1 {
        bx := x+bar*14

        rl.DrawRectangle(bx-1, y-1, 13, 9, gold_dark)
        rl.DrawRectangle(bx, y, 11, 7, gold)
        rl.DrawRectangle(bx+2, y+1, 7, 2, gold_hi)
    }

    for bar: i32 = 0; bar < 2; bar += 1 {
        bx := x+7+bar*14

        rl.DrawRectangle(bx-1, y-9, 13, 9, gold_dark)
        rl.DrawRectangle(bx, y-8, 11, 7, gold)
        rl.DrawRectangle(bx+2, y-7, 7, 2, gold_hi)
    }

    if sparkle {
        rl.DrawRectangle(x+36, y-16, 2, 10, {255, 245, 151, 255})
        rl.DrawRectangle(x+32, y-12, 10, 2, {255, 245, 151, 255})
        rl.DrawRectangle(x+35, y-13, 4, 4, rl.WHITE)
    }
}


int16_security_camera :: proc(
    x, y: i32,
    face_right: bool,
    active: bool,
) {
    // Wall mount.
    rl.DrawRectangle(x-2, y-2, 5, 12, {49, 54, 58, 255})

    body_x := x+7
    if !face_right {
        body_x = x-18
    }

    rl.DrawRectangle(body_x-1, y+5, 13, 10, {26, 29, 33, 255})
    rl.DrawRectangle(body_x, y+6, 11, 8, {157, 166, 170, 255})
    rl.DrawRectangle(body_x+2, y+7, 7, 2, {216, 222, 223, 255})

    lens_x := body_x+10
    if !face_right {
        lens_x = body_x
    }

    lens_col := rl.Color{255, 49, 44, 255}
    if !active {
        lens_col = {84, 27, 27, 255}
    }

    rl.DrawRectangle(lens_x-1, y+7, 3, 6, {19, 20, 23, 255})
    rl.DrawRectangle(lens_x, y+8, 1, 4, lens_col)
}


int16_medical_monitor :: proc(x, y: i32, t, phase: f32) {
    rl.DrawRectangle(x-2, y-2, 64, 29, {37, 43, 47, 255})
    rl.DrawRectangle(x, y, 60, 23, {5, 18, 17, 255})
    rl.DrawRectangle(x+23, y+25, 14, 4, {74, 82, 87, 255})

    scroll := math.mod(t*31.0+phase, 18.0)
    previous_x := x
    previous_y := y+12

    for i: i32 = 0; i < 60; i += 1 {
        px := x+i
        wave := math.mod(f32(i)+scroll, 18.0)
        py := y+12

        if wave >= 7.0 && wave < 9.0 {
            py = y+4
        } else if wave >= 9.0 && wave < 11.0 {
            py = y+20
        } else if wave >= 11.0 && wave < 13.0 {
            py = y+9
        }

        if i > 0 {
            rl.DrawLine(
                previous_x,
                previous_y,
                px,
                py,
                {61, 255, 128, 255},
            )
        }

        previous_x = px
        previous_y = py
    }

    pulse := math.mod(t*4.0, 1.0) < 0.5
    pulse_col := rl.Color{255, 196, 44, 255}
    if !pulse {
        pulse_col = {91, 69, 22, 255}
    }

    rl.DrawRectangle(x+53, y+3, 3, 3, pulse_col)
}


int16_hospital_bed :: proc(
    x, y: i32,
    blanket: rl.Color,
) {
    // Supports and wheels.
    rl.DrawRectangle(x+7, y+16, 3, 9, {72, 81, 88, 255})
    rl.DrawRectangle(x+53, y+16, 3, 9, {72, 81, 88, 255})
    rl.DrawCircle(x+8, y+26, 3, {27, 29, 32, 255})
    rl.DrawCircle(x+54, y+26, 3, {27, 29, 32, 255})

    // Metal frame.
    rl.DrawRectangle(x-2, y+13, 65, 6, {68, 78, 85, 255})

    // Mattress, blanket and pillow.
    rl.DrawRectangle(x, y+6, 60, 9, {223, 232, 231, 255})
    rl.DrawRectangle(x+17, y+8, 40, 7, blanket)
    rl.DrawRectangle(x+3, y+4, 15, 8, {244, 244, 236, 255})
    rl.DrawRectangle(x+5, y+5, 11, 2, rl.WHITE)

    // Bed rails.
    rl.DrawRectangle(x-3, y, 4, 20, {105, 125, 134, 255})
    rl.DrawRectangle(x+60, y+3, 4, 17, {105, 125, 134, 255})
}

int16_draw_market :: proc(x, y, w, h: i32, t: f32) {
    green  := rl.Color{51, 142, 65, 255}
    yellow := rl.Color{255, 218, 69, 255}

    // Wooden wall slats.
    for slat_y: i32 = y+4; slat_y < y+55; slat_y += 9 {
        rl.DrawRectangle(x+5, slat_y, w-10, 7, {120, 78, 43, 255})
        rl.DrawRectangle(x+5, slat_y, w-10, 1, {175, 119, 64, 255})
    }

    int16_sign(
        x+w/2-67,
        y+5,
        134,
        20,
        "MARKET",
        green,
        rl.WHITE,
        t,
        0,
    )

    sign_flash := i32(t*4.0)%2 == 0

    int16_light(
        x+w/2-76,
        y+15,
        sign_flash,
        yellow,
        {83, 68, 24, 255},
    )
    int16_light(
        x+w/2+76,
        y+15,
        !sign_flash,
        yellow,
        {83, 68, 24, 255},
    )

    // Warm pendant lights.
    for lamp: i32 = 0; lamp < 4; lamp += 1 {
        lamp_x := x+33+lamp*78
        lamp_on := (i32(t*3.0)+lamp)%7 != 0

        rl.DrawRectangle(lamp_x, y+1, 2, 12, {53, 48, 39, 255})
        int16_light(
            lamp_x+1,
            y+15,
            lamp_on,
            {255, 227, 147, 255},
            {88, 69, 41, 255},
        )
    }

    // Two rows of colorful fresh produce.
    int16_produce_crate(x+13,  y+42, {224, 58, 45, 255}, t, 0.0)
    int16_produce_crate(x+83,  y+42, {239, 179, 38, 255}, t, 1.0)
    int16_produce_crate(x+153, y+42, {77, 183, 70, 255}, t, 2.0)
    int16_produce_crate(x+223, y+42, {150, 77, 187, 255}, t, 3.0)

    int16_produce_crate(x+24,  y+78, {238, 217, 66, 255}, t, 4.0)
    int16_produce_crate(x+94,  y+78, {223, 91, 45, 255}, t, 5.0)
    int16_produce_crate(x+164, y+78, {91, 197, 88, 255}, t, 6.0)

    // Animated cooling mist.
    for mist: i32 = 0; mist < 8; mist += 1 {
        mist_x := x+18+mist*36
        rise := i32(math.mod(t*11.0+f32(mist)*7.0, 24.0))
        sway := i32(math.sin(t*1.6+f32(mist))*3.0)

        rl.DrawRectangle(
            mist_x+sway,
            y+111-rise,
            2,
            2,
            {211, 243, 247, 125},
        )
    }

    // Checkout counter.
    rl.DrawRectangle(x+13, y+122, w-26, 25, {61, 39, 27, 255})
    rl.DrawRectangle(x+16, y+125, w-32, 20, {150, 89, 45, 255})
    rl.DrawRectangle(x+10, y+119, w-20, 7, {196, 130, 66, 255})

    // Register.
    register_on := math.mod(t, 1.2) < 0.8

    rl.DrawRectangle(x+w-55, y+104, 31, 17, {44, 47, 48, 255})
    rl.DrawRectangle(x+w-50, y+98, 21, 9, {68, 72, 73, 255})
    rl.DrawRectangle(x+w-47, y+100, 15, 4, {11, 34, 20, 255})

    int16_light(
        x+w-32,
        y+101,
        register_on,
        {71, 255, 105, 255},
        {25, 78, 35, 255},
    )

    draw_retro_text(
        "Farm fresh fruit, vegetables and honey!",
        x+15,
        y+153,
        7,
        {255, 238, 184, 255},
    )
}


int16_draw_carryout :: proc(x, y, w, h: i32, t: f32) {
    red   := rl.Color{199, 49, 40, 255}
    amber := rl.Color{255, 190, 53, 255}
    green := rl.Color{67, 255, 108, 255}

    // Cream kitchen tiles.
    for row: i32 = 0; row < 7; row += 1 {
        for col: i32 = 0; col < 20; col += 1 {
            tile_x := x+col*16
            if row%2 != 0 {
                tile_x -= 8
            }

            tile_y := y+row*10

            rl.DrawRectangle(
                tile_x,
                tile_y,
                15,
                9,
                {221, 201, 160, 255},
            )
            rl.DrawRectangle(
                tile_x,
                tile_y,
                15,
                1,
                {247, 231, 193, 255},
            )
        }
    }

    int16_sign(
        x+w/2-75,
        y+5,
        150,
        21,
        "CARRY OUT",
        red,
        rl.WHITE,
        t,
        10,
    )

    sign_flash := i32(t*4.0)%2 == 0

    int16_light(
        x+w/2-84,
        y+15,
        sign_flash,
        amber,
        {94, 59, 20, 255},
    )
    int16_light(
        x+w/2+84,
        y+15,
        !sign_flash,
        amber,
        {94, 59, 20, 255},
    )

    // Kitchen pass-through window.
    rl.DrawRectangle(x+9, y+35, 121, 58, {31, 32, 35, 255})
    rl.DrawRectangle(x+13, y+39, 113, 49, {102, 108, 109, 255})

    for metal_y: i32 = y+42; metal_y < y+86; metal_y += 6 {
        rl.DrawLine(x+15, metal_y, x+124, metal_y, {139, 144, 144, 255})
    }

    heat_flash := i32(t*5.0)%2 == 0

    int16_light(
        x+41,
        y+49,
        heat_flash,
        {255, 143, 36, 255},
        {101, 44, 16, 255},
    )
    int16_light(
        x+98,
        y+49,
        !heat_flash,
        {255, 143, 36, 255},
        {101, 44, 16, 255},
    )

    rl.DrawRectangle(x+8, y+84, 122, 8, {49, 52, 54, 255})
    rl.DrawRectangle(x+10, y+84, 118, 2, {210, 215, 212, 255})

    // Order status board.
    board_x := x+143
    board_y := y+36
    board_w: i32 = 144

    rl.DrawRectangle(
        board_x-2,
        board_y-2,
        board_w+4,
        54,
        {26, 28, 32, 255},
    )
    rl.DrawRectangle(
        board_x,
        board_y,
        board_w,
        50,
        {5, 16, 10, 255},
    )

    draw_retro_text(
        "ORDERS READY",
        board_x+30,
        board_y+4,
        8,
        amber,
    )

    active_order := i32(t/1.8)%4

    for order: i32 = 0; order < 4; order += 1 {
        order_x := board_x+8+order*34
        active := order == active_order

        number_col := rl.Color{31, 92, 44, 255}
        if active {
            number_col = green
        }

        rl.DrawRectangle(
            order_x-2,
            board_y+19,
            28,
            20,
            {8, 35, 17, 255},
        )

        switch order {
        case 0:
            draw_retro_text("12", order_x+5, board_y+24, 8, number_col)
        case 1:
            draw_retro_text("18", order_x+5, board_y+24, 8, number_col)
        case 2:
            draw_retro_text("24", order_x+5, board_y+24, 8, number_col)
        case 3:
            draw_retro_text("31", order_x+5, board_y+24, 8, number_col)
        }

        if active {
            rl.DrawRectangle(order_x-2, board_y+42, 28, 2, green)
        }
    }

    // Moving kitchen conveyor.
    conveyor_y := y+100

    rl.DrawRectangle(x+14, conveyor_y, w-28, 8, {35, 38, 41, 255})
    rl.DrawRectangle(x+14, conveyor_y, w-28, 2, {105, 111, 114, 255})

    roller_scroll := i32(math.mod(t*20.0, 12.0))

    for roller_x: i32 = x+18-roller_scroll;
        roller_x < x+w-18;
        roller_x += 12
    {
        rl.DrawRectangle(
            roller_x,
            conveyor_y+3,
            7,
            3,
            {127, 133, 135, 255},
        )
    }

    moving_bag_x := x+22+i32(math.mod(t*19.0, f32(w-74)))

    int16_takeout_bag(
        moving_bag_x,
        conveyor_y-17,
        {210, 172, 104, 255},
        red,
    )

    // Long pickup counter.
    counter_y := y+125

    rl.DrawRectangle(x+10, counter_y, w-20, 27, {62, 30, 28, 255})
    rl.DrawRectangle(x+12, counter_y+3, w-24, 22, red)
    rl.DrawRectangle(x+7, counter_y-4, w-14, 8, {226, 201, 151, 255})

    for pickup: i32 = 0; pickup < 3; pickup += 1 {
        station_x := x+27+pickup*96
        station_active := pickup == active_order%3
        bob := i32(math.sin(t*3.0+f32(pickup))*1.5)

        int16_takeout_bag(
            station_x,
            counter_y-22+bob,
            {214, 175, 105, 255},
            red,
        )

        int16_light(
            station_x+40,
            counter_y+13,
            station_active,
            green,
            {24, 70, 34, 255},
        )
    }

    draw_retro_text(
        "Order here - pick up when your number flashes!",
        x+15,
        y+160,
        7,
        {255, 229, 180, 255},
    )
}


int16_draw_nightclub :: proc(x, y, w, h: i32, t: f32) {
    pink   := rl.Color{255, 51, 176, 255}
    cyan   := rl.Color{46, 224, 255, 255}
    violet := rl.Color{139, 64, 255, 255}
    lime   := rl.Color{82, 255, 135, 255}

    // Dark padded wall.
    for panel_x: i32 = x+4; panel_x < x+w-4; panel_x += 24 {
        rl.DrawRectangle(panel_x, y+4, 22, 57, {31, 23, 49, 255})
        rl.DrawRectangle(panel_x+2, y+6, 18, 2, {55, 38, 78, 255})
        rl.DrawRectangle(panel_x+10, y+22, 2, 2, {79, 49, 103, 255})
    }

    neon_step := i32(t*4.0)%3
    neon_col := pink

    if neon_step == 1 {
        neon_col = cyan
    } else if neon_step == 2 {
        neon_col = violet
    }

    int16_sign(
        x+w/2-80,
        y+6,
        160,
        21,
        "BUZZ NIGHTCLUB",
        {20, 12, 35, 255},
        neon_col,
        t,
        20,
    )

    // Disco ball.
    disco_x := x+w/2
    disco_y := y+44

    rl.DrawRectangle(disco_x, y+1, 2, 30, {91, 91, 104, 255})
    rl.DrawCircle(disco_x+1, disco_y, 14, {53, 56, 70, 255})

    for cell_y: i32 = -8; cell_y <= 8; cell_y += 5 {
        for cell_x: i32 = -8; cell_x <= 8; cell_x += 5 {
            if cell_x*cell_x+cell_y*cell_y <= 100 {
                color_index := (
                    i32(t*7.0)+
                    (cell_x+8)/5+
                    (cell_y+8)/5
                )%3

                cell_col := cyan

                if color_index == 1 {
                    cell_col = pink
                } else if color_index == 2 {
                    cell_col = {255, 230, 89, 255}
                }

                rl.DrawRectangle(
                    disco_x-1+cell_x,
                    disco_y+cell_y,
                    4,
                    4,
                    cell_col,
                )
            }
        }
    }

    // Animated ceiling chase lights.
    chase := i32(t*8.0)%10

    for light: i32 = 0; light < 10; light += 1 {
        light_x := x+14+light*29
        active := light == chase || light == (chase+1)%10

        light_col := pink
        if light%2 == 0 {
            light_col = cyan
        }

        int16_light(
            light_x,
            y+35,
            active,
            light_col,
            {43, 31, 58, 255},
        )
    }

    // Sweeping laser spotlights.
    beam_a := i32(math.sin(t*1.6)*105.0)
    beam_b := i32(math.sin(t*1.3+2.0)*105.0)

    for beam_line: i32 = 0; beam_line < 5; beam_line += 1 {
        offset := beam_line-2

        rl.DrawLine(
            x+35+offset,
            y+22,
            disco_x+beam_a+offset*4,
            y+126,
            {255, 46, 170, 38},
        )
        rl.DrawLine(
            x+w-35+offset,
            y+22,
            disco_x+beam_b+offset*4,
            y+126,
            {38, 212, 255, 38},
        )
    }

    // Illuminated bottle shelves.
    rl.DrawRectangle(x+8, y+65, 72, 57, {29, 18, 39, 255})
    rl.DrawRectangle(x+11, y+68, 66, 51, {55, 34, 63, 255})

    for shelf: i32 = 0; shelf < 2; shelf += 1 {
        shelf_y := y+85+shelf*25
        rl.DrawRectangle(x+13, shelf_y, 62, 3, {138, 95, 54, 255})

        for bottle: i32 = 0; bottle < 5; bottle += 1 {
            bottle_x := x+16+bottle*12
            bottle_col := pink

            switch bottle {
            case 0:
                bottle_col = {255, 75, 68, 255}
            case 1:
                bottle_col = {53, 184, 255, 255}
            case 2:
                bottle_col = {72, 227, 104, 255}
            case 3:
                bottle_col = {255, 200, 48, 255}
            case 4:
                bottle_col = {196, 68, 255, 255}
            }

            rl.DrawRectangle(bottle_x, shelf_y-15, 8, 15, bottle_col)
            rl.DrawRectangle(
                bottle_x+2,
                shelf_y-19,
                4,
                5,
                {82, 62, 49, 255},
            )

            glint := i32(
                math.mod(
                    t*15.0+f32(bottle*4+shelf*5),
                    12.0,
                ),
            )

            if glint < 3 {
                rl.DrawRectangle(
                    bottle_x+1,
                    shelf_y-13+glint,
                    2,
                    4,
                    rl.WHITE,
                )
            }
        }
    }

    // Animated audio equalizer.
    eq_x := x+w-68
    eq_y := y+69

    rl.DrawRectangle(eq_x-4, eq_y-4, 63, 52, {8, 8, 17, 255})

    for bar: i32 = 0; bar < 6; bar += 1 {
        bar_h := 8+i32(
            28.0*
            (0.5+0.5*math.sin(t*5.0+f32(bar)*1.3)),
        )

        bar_col := cyan

        switch bar {
        case 0:
            bar_col = pink
        case 1:
            bar_col = cyan
        case 2:
            bar_col = violet
        case 3:
            bar_col = lime
        case 4:
            bar_col = {255, 213, 50, 255}
        case 5:
            bar_col = {255, 83, 61, 255}
        }

        for segment_y: i32 = 0;
            segment_y < bar_h;
            segment_y += 5
        {
            rl.DrawRectangle(
                eq_x+bar*10,
                eq_y+43-segment_y,
                7,
                3,
                bar_col,
            )
        }
    }

    // Flashing dance floor.
    floor_y := y+127
    dance_phase := i32(t*5.0)

    for row: i32 = 0; row < 3; row += 1 {
        for col: i32 = 0; col < 10; col += 1 {
            tile_index := (row+col+dance_phase)%4
            tile_col := rl.Color{48, 28, 67, 255}

            if tile_index == 0 {
                tile_col = {237, 48, 168, 255}
            } else if tile_index == 1 {
                tile_col = {38, 196, 230, 255}
            } else if tile_index == 2 {
                tile_col = {114, 52, 221, 255}
            }

            rl.DrawRectangle(
                x+col*30,
                floor_y+row*13,
                29,
                12,
                tile_col,
            )
            rl.DrawRectangle(
                x+col*30+2,
                floor_y+row*13+2,
                25,
                2,
                {255, 255, 255, 30},
            )
        }
    }

    draw_retro_text(
        "DANCE FLOOR",
        x+w/2-34,
        y+163,
        7,
        {255, 229, 116, 255},
    )
}


int16_draw_hospital :: proc(x, y, w, h: i32, t: f32) {
    hospital_blue := rl.Color{77, 147, 180, 255}
    red_cross     := rl.Color{210, 42, 45, 255}

    // Sterile wall panels.
    for row: i32 = 0; row < 7; row += 1 {
        for col: i32 = 0; col < 16; col += 1 {
            panel_x := x+col*20

            if row%2 != 0 {
                panel_x -= 10
            }

            panel_y := y+row*12

            rl.DrawRectangle(
                panel_x,
                panel_y,
                19,
                11,
                {190, 215, 220, 255},
            )
            rl.DrawRectangle(
                panel_x,
                panel_y,
                19,
                1,
                {226, 240, 240, 255},
            )
        }
    }

    // Hospital sign and cross.
    rl.DrawRectangle(x+w/2-50, y+5, 100, 23, {44, 78, 91, 255})
    rl.DrawRectangle(x+w/2-46, y+9, 92, 15, {225, 238, 237, 255})

    rl.DrawRectangle(x+w/2-39, y+11, 5, 11, red_cross)
    rl.DrawRectangle(x+w/2-42, y+14, 11, 5, red_cross)

    draw_retro_text(
        "HOSPITAL",
        x+w/2-25,
        y+13,
        8,
        hospital_blue,
    )

    // Emergency lights.
    emergency_phase := i32(t*5.0)%2 == 0

    int16_light(
        x+w/2-60,
        y+16,
        emergency_phase,
        {255, 54, 47, 255},
        {90, 27, 25, 255},
    )
    int16_light(
        x+w/2+60,
        y+16,
        !emergency_phase,
        {61, 157, 255, 255},
        {23, 47, 91, 255},
    )

    // Hospital beds.
    int16_hospital_bed(
        x+12,
        y+70,
        {128, 193, 211, 255},
    )
    int16_hospital_bed(
        x+91,
        y+70,
        {125, 188, 162, 255},
    )

    // Privacy curtain.
    curtain_sway := i32(math.sin(t*1.1)*2.0)

    rl.DrawRectangle(x+78, y+35, 2, 72, {92, 102, 107, 255})
    rl.DrawRectangle(
        x+75+curtain_sway,
        y+39,
        7,
        62,
        {126, 183, 191, 210},
    )

    for fold_y: i32 = y+43; fold_y < y+98; fold_y += 8 {
        rl.DrawRectangle(
            x+76+curtain_sway,
            fold_y,
            5,
            2,
            {164, 211, 214, 220},
        )
    }

    // Heart monitor.
    int16_medical_monitor(x+174, y+39, t, 0)

    // IV stand and animated drip.
    iv_x := x+271
    iv_y := y+46

    rl.DrawRectangle(iv_x, iv_y, 2, 64, {118, 131, 136, 255})
    rl.DrawRectangle(iv_x-10, iv_y, 22, 2, {118, 131, 136, 255})
    rl.DrawLine(iv_x-8, iv_y+1, iv_x-8, iv_y+8, {118, 131, 136, 255})

    rl.DrawRectangle(iv_x-15, iv_y+8, 14, 22, {79, 106, 111, 255})
    rl.DrawRectangle(iv_x-13, iv_y+10, 10, 18, {194, 230, 237, 210})
    rl.DrawRectangle(iv_x-12, iv_y+21, 8, 6, {112, 190, 220, 180})

    drip_phase := math.mod(t*18.0, 30.0)

    if drip_phase < 22.0 {
        rl.DrawRectangle(
            iv_x-9,
            iv_y+31+i32(drip_phase),
            2,
            3,
            {122, 206, 236, 230},
        )
    }

    // Medicine cabinets.
    for cabinet: i32 = 0; cabinet < 3; cabinet += 1 {
        cabinet_x := x+176+cabinet*34
        cabinet_y := y+84

        rl.DrawRectangle(
            cabinet_x,
            cabinet_y,
            28,
            37,
            {99, 125, 135, 255},
        )
        rl.DrawRectangle(
            cabinet_x+2,
            cabinet_y+2,
            24,
            14,
            {226, 238, 237, 255},
        )
        rl.DrawRectangle(
            cabinet_x+2,
            cabinet_y+19,
            24,
            14,
            {226, 238, 237, 255},
        )

        rl.DrawRectangle(cabinet_x+13, cabinet_y+7, 3, 5, red_cross)
        rl.DrawRectangle(cabinet_x+12, cabinet_y+8, 5, 3, red_cross)
    }

    // Rolling instrument cart.
    cart_x := x+19
    cart_y := y+122

    rl.DrawRectangle(cart_x, cart_y, 53, 6, {152, 166, 170, 255})
    rl.DrawRectangle(cart_x+4, cart_y+6, 3, 20, {102, 115, 120, 255})
    rl.DrawRectangle(cart_x+46, cart_y+6, 3, 20, {102, 115, 120, 255})
    rl.DrawCircle(cart_x+5, cart_y+27, 3, {31, 34, 37, 255})
    rl.DrawCircle(cart_x+48, cart_y+27, 3, {31, 34, 37, 255})

    rl.DrawRectangle(cart_x+7, cart_y-4, 17, 4, {91, 104, 108, 255})
    rl.DrawRectangle(cart_x+29, cart_y-6, 3, 6, {199, 206, 207, 255})
    rl.DrawRectangle(cart_x+36, cart_y-5, 10, 5, {74, 114, 135, 255})

    draw_retro_text(
        "Emergency treatment and bee sting care",
        x+15,
        y+158,
        7,
        {230, 247, 244, 255},
    )
}


int16_draw_bank :: proc(x, y, w, h: i32, t: f32) {
    steel      := rl.Color{91, 100, 102, 255}
    steel_dark := rl.Color{42, 48, 49, 255}
    gold       := rl.Color{242, 190, 39, 255}
    laser_red  := rl.Color{255, 43, 46, 255}
    laser_dim  := rl.Color{88, 27, 29, 255}

    // Steel wall panels.
    for panel_y: i32 = y+4; panel_y < y+95; panel_y += 19 {
        for panel_x: i32 = x+4; panel_x < x+w-4; panel_x += 38 {
            rl.DrawRectangle(panel_x, panel_y, 36, 17, {69, 78, 78, 255})
            rl.DrawRectangle(panel_x+2, panel_y+2, 32, 2, {101, 111, 110, 255})
            rl.DrawRectangle(panel_x+3, panel_y+14, 3, 2, steel_dark)
            rl.DrawRectangle(panel_x+30, panel_y+14, 3, 2, steel_dark)
        }
    }

    int16_sign(
        x+w/2-68,
        y+5,
        136,
        20,
        "FIRST HONEY BANK",
        {108, 89, 45, 255},
        gold,
        t,
        30,
    )

    camera_step := i32(t*2.0)%2 == 0

    int16_security_camera(x+8, y+12, true, camera_step)
    int16_security_camera(x+w-9, y+12, false, !camera_step)

    int16_light(
        x+43,
        y+18,
        camera_step,
        laser_red,
        laser_dim,
    )
    int16_light(
        x+w-43,
        y+18,
        !camera_step,
        laser_red,
        laser_dim,
    )

    // Vault door.
    vault_x := x+13
    vault_y := y+38

    rl.DrawRectangle(vault_x-4, vault_y-4, 78, 92, {30, 34, 35, 255})
    rl.DrawRectangle(vault_x, vault_y, 70, 84, steel)
    rl.DrawRectangle(vault_x+5, vault_y+5, 60, 74, {112, 121, 121, 255})

    rl.DrawCircle(vault_x+35, vault_y+41, 24, steel_dark)
    rl.DrawCircle(vault_x+35, vault_y+41, 20, {127, 137, 136, 255})
    rl.DrawCircle(vault_x+35, vault_y+41, 5, steel_dark)

    // Slowly rotating vault wheel.
    vault_angle := t*0.6

    for spoke: i32 = 0; spoke < 4; spoke += 1 {
        angle := vault_angle+f32(spoke)*(math.PI/2.0)
        end_x := vault_x+35+i32(math.cos(angle)*16.0)
        end_y := vault_y+41+i32(math.sin(angle)*16.0)

        rl.DrawLine(
            vault_x+35,
            vault_y+41,
            end_x,
            end_y,
            {44, 50, 51, 255},
        )
        rl.DrawCircle(end_x, end_y, 3, {52, 59, 60, 255})
    }

    // Animated security lasers.
    laser_left := x+98
    laser_right := x+w-14
    laser_phase := i32(t*7.0)

    for laser: i32 = 0; laser < 5; laser += 1 {
        laser_y := y+39+laser*17
        active := (laser+laser_phase)%3 != 0

        laser_col := laser_dim
        if active {
            laser_col = laser_red
        }

        rl.DrawRectangle(laser_left-5, laser_y-3, 7, 7, steel_dark)
        rl.DrawRectangle(laser_right-1, laser_y-3, 7, 7, steel_dark)
        rl.DrawRectangle(laser_left-2, laser_y-1, 3, 3, laser_col)
        rl.DrawRectangle(laser_right, laser_y-1, 3, 3, laser_col)

        if active {
            scan_offset := i32(
                math.sin(t*1.8+f32(laser)*0.9)*5.0,
            )

            rl.DrawLine(
                laser_left,
                laser_y,
                laser_right,
                laser_y+scan_offset,
                {255, 38, 43, 190},
            )
            rl.DrawLine(
                laser_left,
                laser_y+1,
                laser_right,
                laser_y+scan_offset+1,
                {255, 108, 105, 75},
            )
        }
    }

    // Secured gold and cash platform.
    display_x := x+110
    display_y := y+112

    rl.DrawRectangle(display_x-6, display_y-20, w-116, 48, {37, 40, 39, 255})
    rl.DrawRectangle(display_x-3, display_y-17, w-122, 42, {84, 76, 55, 255})

    sparkle_a := i32(t*5.0)%2 == 0
    sparkle_b := i32(t*5.0+1.0)%2 == 0

    int16_gold_stack(display_x, display_y, sparkle_a)
    int16_gold_stack(display_x+51, display_y+4, sparkle_b)
    int16_money_stack(display_x+104, display_y+7, sparkle_a)
    int16_money_stack(display_x+139, display_y+3, sparkle_b)

    // Cute indoor plants.
    int16_plant(x+99, y+154, t, 0.0)
    int16_plant(x+w-15, y+154, t, 1.8)
    int16_plant(x+91, y+94, t, 3.1)

    // Alarm floor lights.
    for alarm: i32 = 0; alarm < 6; alarm += 1 {
        alarm_x := x+104+alarm*30
        alarm_on := (alarm+i32(t*6.0))%6 == 0

        int16_light(
            alarm_x,
            y+153,
            alarm_on,
            laser_red,
            laser_dim,
        )
    }

    draw_retro_text(
        "SECURITY SYSTEM: ACTIVE",
        x+107,
        y+164,
        8,
        laser_red,
    )
}

int16_draw_sheriff :: proc(x, y, w, h: i32, t: f32) {
    red_on := i32(t*5.0)%2 == 0

    // Desk.
    rl.DrawRectangle(x+18, y+54, 87, 42, {85, 57, 39, 255})
    rl.DrawRectangle(x+15, y+50, 93, 8, {145, 91, 52, 255})

    // Filing cabinets.
    for cabinet: i32 = 0; cabinet < 3; cabinet += 1 {
        cx := x+w-87+cabinet*24

        rl.DrawRectangle(cx, y+48, 20, 53, {74, 82, 91, 255})

        for drawer: i32 = 0; drawer < 4; drawer += 1 {
            dy := y+52+drawer*12
            rl.DrawRectangle(cx+2, dy, 16, 9, {104, 114, 124, 255})
            rl.DrawRectangle(cx+7, dy+2, 6, 2, {39, 43, 48, 255})
        }
    }

    // Police lights.
    int16_light(
        x+w/2-10,
        y+18,
        red_on,
        {255, 44, 43, 255},
        {82, 24, 25, 255},
    )
    int16_light(
        x+w/2+10,
        y+18,
        !red_on,
        {47, 111, 255, 255},
        {24, 38, 91, 255},
    )

    // Jail bars.
    rl.DrawRectangle(x+w-70, y+108, 58, 4, {34, 37, 42, 255})

    for bar: i32 = 0; bar < 7; bar += 1 {
        rl.DrawRectangle(x+w-67+bar*8, y+108, 3, 45, {48, 52, 58, 255})
    }

    int16_sign(
        x+w/2-65,
        y+5,
        130,
        20,
        "HONEYVILLE POLICE",
        {42, 66, 120, 255},
        rl.WHITE,
        t,
        5,
    )

    draw_retro_text(
        "Protecting every bee in town",
        x+17,
        y+142,
        7,
        {220, 229, 245, 255},
    )
}


int16_draw_dealership :: proc(x, y, w, h: i32, t: f32) {
    // Large glass wall.
    rl.DrawRectangle(x+5, y+5, w-10, 31, {111, 181, 218, 170})

    for divider: i32 = 0; divider < 7; divider += 1 {
        rl.DrawRectangle(x+5+divider*48, y+5, 3, 31, {202, 215, 223, 255})
    }

    shine_x := x+5+i32(math.mod(t*60.0, f32(w-10)))
    rl.DrawRectangle(shine_x, y+5, 10, 31, {255, 255, 255, 55})

    int16_sign(
        x+w/2-93,
        y+9,
        186,
        18,
        "HONEYVILLE MOTORS",
        {30, 96, 184, 255},
        rl.WHITE,
        t,
        12,
    )

    // Three compact display cars.
    for car: i32 = 0; car < 3; car += 1 {
        car_x := x+21+car*97
        car_y := y+81
        car_col := rl.Color{222, 48, 45, 255}

        if car == 1 {
            car_col = {44, 94, 211, 255}
        } else if car == 2 {
            car_col = {243, 196, 31, 255}
        }

        rl.DrawRectangle(car_x, car_y-18, 63, 22, {22, 25, 29, 255})
        rl.DrawRectangle(car_x+2, car_y-16, 59, 18, car_col)
        rl.DrawRectangle(car_x+13, car_y-29, 37, 13, car_col)
        rl.DrawRectangle(car_x+17, car_y-27, 13, 10, {133, 190, 218, 255})
        rl.DrawRectangle(car_x+33, car_y-27, 13, 10, {133, 190, 218, 255})

        rl.DrawCircle(car_x+14, car_y+3, 9, {22, 24, 28, 255})
        rl.DrawCircle(car_x+14, car_y+3, 4, {174, 183, 188, 255})
        rl.DrawCircle(car_x+51, car_y+3, 9, {22, 24, 28, 255})
        rl.DrawCircle(car_x+51, car_y+3, 4, {174, 183, 188, 255})

        spotlight := (i32(t*4.0)+car)%3 == 0

        int16_light(
            car_x+31,
            y+48,
            spotlight,
            {255, 243, 175, 255},
            {88, 82, 54, 255},
        )
    }

    draw_retro_text(
        "Press [O] to browse cars",
        x+w/2-78,
        y+127,
        8,
        {255, 220, 79, 255},
    )
}


int16_draw_sanctuary :: proc(x, y, w, h: i32, t: f32) {
    fx := f32(x); fy := f32(y); fw := f32(w); fh := f32(h)

    // Greenhouse glass tint.
    rl.DrawRectangle(x+4, y+4, w-8, h-8, {140, 200, 160, 60})

    for gi in 0..<8 {
        gx := x + 4 + i32(gi)*(w-8)/8
        rl.DrawRectangle(gx, y+4, 2, h-8, {200, 230, 210, 90})
    }

    // Sunbeams drifting through the glass.
    for rayi in 0..<3 {
        rx_off := i32(math.sin(t*0.2 + f32(rayi)*2.0)*20)
        ray_x := x + 40 + i32(rayi)*90 + rx_off
        rl.DrawTriangle(
            {f32(ray_x), f32(y+4)},
            {f32(ray_x-24), f32(y+h-8)},
            {f32(ray_x+24), f32(y+h-8)},
            {255, 255, 220, 18})
    }

    // Animated greenhouse plants (2x6 grid).
    plant_pos: [12][2]i32
    for row: i32 = 0; row < 2; row += 1 {
        for col: i32 = 0; col < 6; col += 1 {
            plant_x := x+35+col*88
	    plant_y := y+115+row*125

            int16_plant(
		plant_x,
		plant_y,
		t,
		f32(row*6+col)*0.7,
	    )

	    plant_pos[row*6+col] = {plant_x, plant_y}
        }
    }


    // Floating pollen motes rising from the plants.
    for poi in 0..<10 {
        pseed := u32(poi)
        src := plant_pos[poi % len(plant_pos)]
        rise := math.mod(t*10.0 + mp_night_hash01(pseed*7+2)*40.0, 40.0)
        pxx := src[0]+8 + i32(math.sin(t*0.8+f32(poi))*6)
        pyy := src[1] - i32(rise)
        rl.DrawCircle(pxx, pyy, 1, {255, 250, 200, u8(160.0*(1.0-rise/40.0))})
    }

    draw_retro_text("BEE SANCTUARY GREENHOUSE", x+20, y+80, 9, COL_SANCTUARY)
    draw_retro_text("Press [O] to open the Donation menu", x+20, y+94, 8, COL_TEXT)

    donated_str := fmt.aprintf("Total Donated: $%.2f", g.sanctuary_donated, allocator = context.temp_allocator)
    draw_retro_text(donated_str, x+20, y+108, 8, COL_HONEY)

    // Bees orbiting the greenhouse interior.
    for bi in 0..<g.sanctuary_bee_count {
        speed := get_sanctuary_bee_speed(bi)
        bangle := t*1.6*speed + f32(bi)*0.87
        bx := i32(fx + fw/2 + math.cos(bangle+f32(bi)*1.3)*(fw/2-24))
        by := i32(fy + fh/2 + math.sin(bangle*0.8+f32(bi)*1.7)*(fh/2-24))
        rl.DrawRectangle(bx-2, by-1, 4, 3, {220, 200, 0, 220})
        rl.DrawRectangle(bx-1, by-1, 2, 3, {40, 40, 40, 200})
        rl.DrawRectangle(bx-3, by-2, 2, 2, {200, 230, 255, 140})
        rl.DrawRectangle(bx+1, by-2, 2, 2, {200, 230, 255, 140})
    }
}


int16_draw_factory :: proc(x, y, w, h: i32, t: f32) {
    amber := rl.Color{255, 185, 41, 255}

    int16_sign(
        x+w/2-105,
        y+7,
        210,
        20,
        "FUZZY BUDDY FACTORY",
        {109, 77, 37, 255},
        rl.WHITE,
        t,
        25,
    )

    // Animated conveyor.
    belt_y := y+55

    rl.DrawRectangle(x+15, belt_y, w-30, 22, {34, 36, 39, 255})
    rl.DrawRectangle(x+15, belt_y, w-30, 4, {85, 89, 94, 255})

    conveyor_scroll := i32(math.mod(t*35.0, 20.0))

    for roller_x: i32 = x+18-conveyor_scroll;
        roller_x < x+w-18;
        roller_x += 20
    {
        rl.DrawRectangle(roller_x, belt_y+6, 5, 12, {18, 19, 22, 255})
    }

    // Honey jars moving on conveyor.
    for jar: i32 = 0; jar < 7; jar += 1 {
        jar_x := x+20+i32(
            math.mod(
                t*31.0+f32(jar)*72.0,
                f32(w-45),
            ),
        )

        rl.DrawRectangle(jar_x, belt_y-14, 13, 15, {102, 69, 28, 255})
        rl.DrawRectangle(jar_x+1, belt_y-13, 11, 13, amber)
        rl.DrawRectangle(jar_x+3, belt_y-16, 7, 3, {91, 92, 88, 255})
        rl.DrawRectangle(jar_x+3, belt_y-9, 7, 4, {255, 226, 108, 255})
    }

    // Processing tanks.
    for tank: i32 = 0; tank < 3; tank += 1 {
        tank_x := x+44+tank*145
        tank_y := y+122

        rl.DrawRectangle(tank_x, tank_y, 70, 76, {108, 112, 119, 255})
        rl.DrawRectangle(tank_x+4, tank_y+5, 62, 65, {147, 151, 158, 255})
        rl.DrawRectangle(tank_x, tank_y, 70, 9, {190, 194, 199, 255})

        honey_bob := i32(math.sin(t*2.0+f32(tank))*3.0)

        rl.DrawRectangle(
            tank_x+8,
            tank_y+42+honey_bob,
            54,
            18,
            amber,
        )

        status_on := (i32(t*4.0)+tank)%3 == 0

        int16_light(
            tank_x+35,
            tank_y-7,
            status_on,
            {71, 255, 105, 255},
            {26, 78, 36, 255},
        )
    }

    // Steam pixels.
    for steam: i32 = 0; steam < 9; steam += 1 {
        steam_x := x+78+(steam%3)*145
        rise := i32(math.mod(t*13.0+f32(steam)*8.0, 42.0))
        sway := i32(math.sin(t+f32(steam))*4.0)

        rl.DrawRectangle(
            steam_x+sway,
            y+120-rise,
            4,
            4,
            {235, 238, 239, 95},
        )
    }
}

draw_interior :: proc() {
    bt := g.interior_building
    rw, rh := interior_room_size(bt)

    rx := -rw/2
    ry := -rh/2

    ix := pxi(rx)
    iy := pxi(ry)
    iw := pxi(rw)
    ih := pxi(rh)

    t := f32(rl.GetTime())

    floor_first: rl.Color
    floor_second: rl.Color
    wall_col: rl.Color

    #partial switch bt {
    case .Market:
        floor_first  = {142, 104, 61, 255}
        floor_second = {119, 84, 48, 255}
        wall_col     = {67, 111, 61, 255}

    case .SheriffOffice:
        floor_first  = {106, 111, 128, 255}
        floor_second = {84, 90, 108, 255}
        wall_col     = {60, 71, 111, 255}

    case .DoctorOffice:
        floor_first  = {196, 219, 223, 255}
        floor_second = {171, 202, 208, 255}
        wall_col     = {106, 153, 171, 255}

    case .Bank:
        floor_first  = {116, 106, 88, 255}
        floor_second = {94, 87, 74, 255}
        wall_col     = {66, 75, 73, 255}

    case .Diner:
        floor_first  = {64, 65, 71, 255}
        floor_second = {47, 49, 55, 255}
        wall_col     = {155, 51, 43, 255}

    case .Bar:
        floor_first  = {42, 31, 61, 255}
        floor_second = {29, 23, 47, 255}
        wall_col     = {17, 13, 34, 255}

    case .CarDealership:
        floor_first  = {218, 220, 228, 255}
        floor_second = {191, 196, 207, 255}
        wall_col     = {47, 56, 72, 255}

    case .BeeSanctuary:
        floor_first  = {89, 149, 70, 255}
        floor_second = {72, 129, 59, 255}
        wall_col     = {49, 109, 50, 255}

    case .FuzzyBuddyFactory:
        floor_first  = {94, 90, 96, 255}
        floor_second = {72, 69, 76, 255}
        wall_col     = {54, 50, 59, 255}
    }

    // Room shadow and wall border.
    rl.DrawRectangle(ix-11, iy-11, iw+22, ih+22, {13, 14, 18, 255})
    rl.DrawRectangle(ix-8, iy-8, iw+16, ih+16, wall_col)

    // Base floor.
    int16_floor(
        ix,
        iy,
        iw,
        ih,
        floor_first,
        floor_second,
    )

    rl.DrawRectangleLinesEx(
	{f32(ix), f32(iy), f32(iw), f32(ih)},
	2,
	{0, 0, 0, 190},
    )

    #partial switch bt {
    case .Market:
        int16_draw_market(ix, iy, iw, ih, t)

    case .Diner:
        int16_draw_carryout(ix, iy, iw, ih, t)

    case .Bar:
        int16_draw_nightclub(ix, iy, iw, ih, t)

    case .DoctorOffice:
        int16_draw_hospital(ix, iy, iw, ih, t)

    case .Bank:
        int16_draw_bank(ix, iy, iw, ih, t)

    case .SheriffOffice:
        int16_draw_sheriff(ix, iy, iw, ih, t)

    case .CarDealership:
        int16_draw_dealership(ix, iy, iw, ih, t)

    case .BeeSanctuary:
        int16_draw_sanctuary(ix, iy, iw, ih, t)

    case .FuzzyBuddyFactory:
        int16_draw_factory(ix, iy, iw, ih, t)
    }

    exit_x: i32 = -12
    exit_y := iy+ih-28

    rl.DrawRectangle(exit_x, exit_y, 24, 28, {57, 34, 14, 255})
    rl.DrawRectangle(exit_x+1, exit_y+1, 22, 26, {105, 66, 31, 255})
    rl.DrawRectangle(exit_x, exit_y, 24, 4, {60, 35, 10, 255})
    rl.DrawRectangle(exit_x+17, exit_y+13, 3, 3, {238, 194, 70, 255})

    draw_retro_text(
        "[O] OPTIONS MENU",
        -14,
        iy+ih-40,
        8,
        COL_HONEY,
    )

    if g.player.pos.y > 60 {
        draw_retro_text(
            "[E] EXIT",
            -50,
            iy+ih-52,
            7,
            COL_TEXT,
        )
    }

    draw_player()
}

draw_retro_text :: proc(text: string, x, y: i32, size: i32, col: rl.Color) {
    ctext := strings.clone_to_cstring(text, context.temp_allocator)
    rl.DrawText(ctext, x+1, y+1, size, {0,0,0,200})
    rl.DrawText(ctext, x, y, size, col)
}
draw_spinning_wheel :: proc(cx, cy: i32, t: f32) {
    rl.DrawCircle(cx, cy, 6, {28,28,28,255})
    spin := t*6.0
    for si in 0..<4 {
        a := spin + f32(si)*(math.PI*0.5)
        ex := cx + i32(math.cos(a)*4)
        ey := cy + i32(math.sin(a)*4)
        rl.DrawLine(cx, cy, ex, ey, {150,150,150,255})
    }
}

// DRAW HOME


draw_home :: proc(h: Home, idx: int) {
    r  := h.rect
    rx := pxi(r.x); ry := pxi(r.y)
    rw := pxi(r.width); rh := pxi(r.height)

    rl.DrawRectangle(rx+3, ry+3, rw, rh, COL_SHADOW)
    draw_bricks(rx, ry, rw, rh, COL_BRICK, COL_BRICK2)
    rl.DrawRectangle(rx, ry, rw, rh, rl.Color{h.color.r, h.color.g, h.color.b, 100})

    rl.DrawRectangle(rx-6, ry-8, rw+12, 10, COL_ROOF)
    for gi in 0..<10 {
        gw := rw/2 - i32(gi)*6
        if gw > 0 { rl.DrawRectangle(rx+rw/2-gw, ry-8-i32(gi)*4, gw*2, 4, COL_ROOF2) }
    }
    rl.DrawRectangle(rx+rw-20, ry-22, 10, 18, COL_CHIMNEY)
    rl.DrawRectangle(rx+rw-22, ry-24, 14, 4,  COL_CHIMNEY)

    rl.DrawRectangle(rx+10, ry+16, 18, 14, {160,210,240,200})
    rl.DrawRectangle(rx+11, ry+17, 16, 12, {200,230,255,180})
    rl.DrawRectangle(rx+19, ry+16, 2, 14, {80,120,160,255})
    rl.DrawRectangle(rx+10, ry+22, 18, 2,  {80,120,160,255})

    dx := rx + rw/2 - 7; dy := ry + rh - 24
    rl.DrawRectangle(dx, dy, 14, 24, {56,36,16,255})
    rl.DrawRectangle(dx+1, dy+1, 12, 22, {72,48,24,255})
    rl.DrawRectangle(dx+10, dy+10, 3, 3, {200,170,50,255})
    rl.DrawRectangle(dx-2, dy+22, 18, 3, COL_SIDEWALK)
    rl.DrawRectangle(dx+1, dy+25, 12, 30, COL_PATH)

    for fi in 0..<4 {
        draw_flower(f32(rx+4+i32(fi)*8), f32(ry+rh-6), fi+idx*4)
    }

    lbl := strings.clone_to_cstring(h.label, context.temp_allocator)
    tw  := rl.MeasureText(lbl, 7)
    rl.DrawRectangle(rx+rw/2-tw/2-2, ry+rh+2, tw+4, 10, {0,0,0,140})
    rl.DrawText(lbl, rx+rw/2-tw/2, ry+rh+3, 7, h.color)
    if h.owned { rl.DrawText("OWNED", rx+rw/2-12, ry-32, 7, COL_GREEN_TEXT) }
    if vec2_dist(g.player.pos, h.door) < INTERACT_DIST {
        rl.DrawText("[E] View", pxi(h.door.x)-16, pxi(h.door.y)-14, 8, COL_HONEY)
    }
}
draw_home_interior :: proc() {
    idx := g.interior_home
    if idx < 0 || idx >= NUM_HOMES { return }
    home := &g.homes[idx]

    rw, rh := HOME_INT_W, HOME_INT_H
    rx := -rw/2; ry := -rh/2

    rl.DrawRectangle(pxi(rx)-8, pxi(ry)-8, pxi(rw)+16, pxi(rh)+16, home.interior_wall_color)
    tile :: i32(20)
    for ty := pxi(ry); ty < pxi(ry+rh); ty += tile {
        for tx := pxi(rx); tx < pxi(rx+rw); tx += tile {
            col := home.interior_floor_color if ((tx/tile)+(ty/tile))%2==0 else
                rl.Color{home.interior_floor_color.r-20, home.interior_floor_color.g-20, home.interior_floor_color.b-20, 255}
            rl.DrawRectangle(tx, ty, tile-1, tile-1, col)
        }
    }
    rl.DrawRectangleLinesEx({rx, ry, rw, rh}, 2, {0,0,0,180})

    rl.DrawRectangle(-12, pxi(ry+rh)-28, 24, 28, {80,50,20,255})
    rl.DrawRectangle(-11, pxi(ry+rh)-27, 22, 26, {100,65,30,255})
    rl.DrawText("EXIT", -14, pxi(ry+rh)-40, 8, COL_HONEY)
    if g.player.pos.y > 60 {
        rl.DrawText("[E] Leave", -50, pxi(ry+rh)-52, 7, COL_TEXT)
    }
    rl.DrawText("[O] Decorate", -50, pxi(ry+rh)-62, 7, COL_TEXT2)

    title_str := fmt.aprintf("~ %s ~", home.label, allocator = context.temp_allocator)
    title := strings.clone_to_cstring(title_str, context.temp_allocator)
    tw := rl.MeasureText(title, 9)
    rl.DrawText(title, -tw/2, pxi(ry)+4, 9, COL_HONEY)

    draw_home_trophies(home^, rx, ry)

    draw_player()
}

animal_trophy_color :: proc(k: AnimalType) -> rl.Color {
    switch k {
    case .Rabbit:    return {220,210,200,255}
    case .Fox:       return {210, 90, 30,255}
    case .Deer:      return {180,120, 60,255}
    case .Squirrel:  return {160,100, 40,255}
    case .Frog:      return { 60,160, 60,255}
    case .Butterfly: return {200, 80,200,255}
    }
    return COL_TEXT
}

draw_home_trophies :: proc(home: Home, rx, ry: f32) {
    slot_w :: f32(34); slot_h :: f32(26); gap :: f32(8)
    total_w := f32(HOME_TROPHY_SLOTS)*slot_w + f32(HOME_TROPHY_SLOTS-1)*gap
    start_x := -total_w/2
    top_y   := ry + 16

    for i in 0..<HOME_TROPHY_SLOTS {
        sx := start_x + f32(i)*(slot_w+gap)
        sy := top_y

        rl.DrawRectangle(pxi(sx)-2, pxi(sy)-2, pxi(slot_w)+4, pxi(slot_h)+4, {60,40,20,255})
        rl.DrawRectangleLinesEx({sx, sy, slot_w, slot_h}, 1, COL_HONEY2)

        t := home.trophies[i]
        switch t.kind {
        case .Empty:
            rl.DrawText("empty", pxi(sx)+3, pxi(sy)+9, 6, {140,140,140,180})
        case .Animal:
	    cx := sx + slot_w/2
	    cy := sy + slot_h/2 - 4
	    draw_animal_icon(t.animal, cx, cy, 0, false)
            lbl := strings.clone_to_cstring(animal_label(t.animal), context.temp_allocator)
            rl.DrawText(lbl, pxi(sx)+2, pxi(sy)+pxi(slot_h)-8, 6, COL_TEXT)
        case .Fish:
	    cx := sx + slot_w/2
	    cy := sy + slot_h/2 - 2
	    draw_fish_icon(t.fish, cx, cy, false, false) // no flip, static pose
	    lbl := strings.clone_to_cstring(fish_label(t.fish), context.temp_allocator)
	    rl.DrawText(lbl, pxi(sx)+2, pxi(sy)+pxi(slot_h)-8, 6, COL_TEXT)
	    rl.BeginScissorMode(pxi(sx), pxi(sy), pxi(slot_w), pxi(slot_h)-11)
	    draw_fish_icon(t.fish, cx, cy, false, false)
	    rl.EndScissorMode()
        case .Photo:
            if t.photo_tex.id != 0 {
                src := rl.Rectangle{0, 0, f32(t.photo_tex.width), f32(t.photo_tex.height)}
                dst := rl.Rectangle{sx+2, sy+2, slot_w-4, slot_h-4}
                rl.DrawTexturePro(t.photo_tex, src, dst, {0,0}, 0, rl.WHITE)
            }
        }
    }
}
draw_home_option_menu :: proc() {
    if !g.home_option_open { return }
    pw :: f32(190); ph :: f32(60)
    px := f32(GAME_W)/2 - pw/2; py := f32(GAME_H)/2 - ph/2 - 60
    draw_panel(px, py, pw, ph, "=== HOME OPTIONS [O] ===")

    labels := [2]string{"Decorate (Wall/Floor)", "Manage Trophies"}
    for i in 0..<2 {
        selected := (g.home_option_cursor == i)
        col := COL_HONEY2 if selected else COL_TEXT
        prefix := "> " if selected else "  "
        line := fmt.aprintf("%s%s", prefix, labels[i], allocator = context.temp_allocator)
        rl.DrawText(strings.clone_to_cstring(line, context.temp_allocator), pxi(px)+8, pxi(py)+20+i32(i)*16, 8, col)
    }
}
draw_home_interior_scene :: proc() {
    rl.BeginMode2D(g.camera)
    rl.DrawRectangle(-400, -300, 800, 600, {20,15,10,255}) // dark surround
    draw_home_interior()
    rl.EndMode2D()

    draw_home_option_menu()
}
draw_garage_interior :: proc() {
    rw, rh := GARAGE_INT_W, GARAGE_INT_H
    rx := -rw/2; ry := -rh/2

    floor_col := rl.Color{80, 80, 88, 255}
    wall_col  := rl.Color{50, 50, 58, 255}

    rl.DrawRectangle(pxi(rx)-8, pxi(ry)-8, pxi(rw)+16, pxi(rh)+16, wall_col)
    tile :: i32(20)
    for ty := pxi(ry); ty < pxi(ry+rh); ty += tile {
        for tx := pxi(rx); tx < pxi(rx+rw); tx += tile {
            col := floor_col if ((tx/tile)+(ty/tile))%2==0 else
                rl.Color{floor_col.r-15, floor_col.g-15, floor_col.b-15, 255}
            rl.DrawRectangle(tx, ty, tile-1, tile-1, col)
        }
    }
    rl.DrawRectangleLinesEx({rx, ry, rw, rh}, 2, {0,0,0,180})

    rl.DrawRectangle(-12, pxi(ry+rh)-28, 24, 28, {80,50,20,255})
    rl.DrawRectangle(-11, pxi(ry+rh)-27, 22, 26, {100,65,30,255})
    rl.DrawText("EXIT", -14, pxi(ry+rh)-40, 8, COL_HONEY)
    rl.DrawText("[E] Leave on foot", -60, pxi(ry+rh)-52, 7, COL_TEXT)
    rl.DrawText("~ YOUR GARAGE ~", -46, pxi(ry)+4, 9, COL_HONEY)

    for i in 0..<MAX_CARS {
        c := g.cars[i]
        if !c.owned || !c.in_garage { continue }

        slot_pos := garage_slot_pos(i)
        display  := c
        display.active = true
        display.pos    = slot_pos
        draw_car(display)

        if vec2_dist(g.player.pos, slot_pos) < INTERACT_DIST {
            rl.DrawText("[E] Drive out", pxi(slot_pos.x)-26, pxi(slot_pos.y)-30, 7, COL_HONEY)
        }
    }

    draw_player()
}

draw_garage_interior_scene :: proc() {
    rl.BeginMode2D(g.camera)
    rl.DrawRectangle(-400, -300, 800, 600, {20,15,10,255})
    draw_garage_interior()
    rl.EndMode2D()
}
draw_farmers_market_interior_scene :: proc() {
    rl.ClearBackground(rl.Color{40, 32, 20, 255})

    room_x :: f32(20)
    room_y :: f32(20)
    room_w := f32(GAME_W) - 40
    room_h := f32(GAME_H) - 40

    // Checkerboard floor tiles
    tile :: f32(16)
    floor_a := rl.Color{196, 156, 92, 255}
    floor_b := rl.Color{170, 132, 76, 255}
    nx := int(room_w / tile)
    ny := int(room_h / tile)
    for row in 0..<ny {
        for col in 0..<nx {
            tx := room_x + f32(col)*tile
            ty := room_y + f32(row)*tile
            c := floor_a if (row+col)%2==0 else floor_b
            rl.DrawRectangle(pxi(tx), pxi(ty), pxi(tile), pxi(tile), c)
        }
    }

    // Wood plank wall strip along the top
    wall_h :: f32(28)
    rl.DrawRectangle(pxi(room_x), pxi(room_y), pxi(room_w), pxi(wall_h), rl.Color{92, 58, 30, 255})
    for col in 0..<nx {
        lx := room_x + f32(col)*tile
        rl.DrawRectangle(pxi(lx), pxi(room_y), 2, pxi(wall_h), rl.Color{68, 42, 20, 255})
    }
    rl.DrawRectangleLinesEx({room_x, room_y, room_w, room_h}, 4, rl.Color{50, 32, 16, 255})

    // Stall + striped awning
    stall_w :: f32(180)
    stall_h :: f32(80)
    stall_x := f32(GAME_W)/2 - stall_w/2
    stall_y := f32(GAME_H)/2 - stall_h/2 + 10
    awning_y := stall_y - 22

    stripe_w := stall_w / 6
    for i in 0..<6 {
        c := COL_HONEY if i % 2 == 0 else COL_RED_TEXT
        rl.DrawRectangle(pxi(stall_x + f32(i)*stripe_w), pxi(awning_y), pxi(stripe_w)+1, 18, c)
    }
    rl.DrawRectangleLinesEx({stall_x, awning_y, stall_w, 18}, 2, rl.Color{40,24,12,255})

    rl.DrawRectangle(pxi(stall_x), pxi(stall_y), pxi(stall_w), pxi(stall_h), COL_MARKET_STALL)
    rl.DrawRectangleLinesEx({stall_x, stall_y, stall_w, stall_h}, 3, rl.Color{60,40,20,255})
    rl.DrawRectangle(pxi(stall_x)+4, pxi(stall_y)+pxi(stall_h), 6, 14, rl.Color{60,40,20,255})
    rl.DrawRectangle(pxi(stall_x)+pxi(stall_w)-10, pxi(stall_y)+pxi(stall_h), 6, 14, rl.Color{60,40,20,255})

    // Honey jars on the stall
    for i in 0..<4 {
        jx := stall_x + 14 + f32(i)*36
        jy := stall_y + 14
        rl.DrawRectangle(pxi(jx), pxi(jy), 18, 22, COL_HONEY)
        rl.DrawRectangle(pxi(jx)+4, pxi(jy)-6, 10, 6, rl.Color{160,110,40,255})
        rl.DrawRectangleLinesEx({jx, jy, 18, 22}, 1, rl.Color{120,80,20,255})
    }

    rl.DrawRectangle(pxi(room_x)+12, pxi(room_y)+pxi(room_h)-46, 30, 30, rl.Color{150,110,60,255})
    rl.DrawRectangleLinesEx({room_x+12, room_y+room_h-46, 30, 30}, 2, rl.Color{90,64,30,255})
    rl.DrawRectangle(pxi(room_x)+pxi(room_w)-42, pxi(room_y)+pxi(room_h)-46, 30, 30, rl.Color{150,110,60,255})
    rl.DrawRectangleLinesEx({room_x+room_w-42, room_y+room_h-46, 30, 30}, 2, rl.Color{90,64,30,255})

    draw_player()

    rl.DrawText("[E] Exit to Town", 20, pxi(f32(GAME_H)) - 24, 10, COL_TEXT)
    if !g.market_menu_open {
        rl.DrawText("[O] Manage Stall", 20, pxi(f32(GAME_H)) - 12, 10, COL_TEXT)
    }
}

// DRAW PLOT


draw_plot :: proc(plot: LandPlot, idx: int) {
    r := plot.rect

    ground_a, ground_b: rl.Color
    if plot.owner_is_player { ground_a = {108,164,28,255}; ground_b = {124,184,36,255} } else if plot.owned { ground_a = COL_GRASS2; ground_b = COL_GRASS3 } else { ground_a = COL_GRASS; ground_b = {68,104,32,255} }
    tile :: f32(16)
    tx := int(r.x / tile); ty := int(r.y / tile)
    cols := int(r.width/tile)+1; rows := int(r.height/tile)+1
    for row in 0..<rows {
        for col in 0..<cols {
            cx := r.x + f32(col)*tile; cy := r.y + f32(row)*tile
            cw := min(tile, r.x+r.width-cx); ch := min(tile, r.y+r.height-cy)
            if cw <= 0 || ch <= 0 { continue }
            col_use := ground_a if ((tx+col)+(ty+row))%2==0 else ground_b
            rl.DrawRectangle(pxi(cx), pxi(cy), pxi(cw), pxi(ch), col_use)
        }
    }

    draw_plot_fence(r, true)

    for tree in plot.trees { draw_tree(tree.x, tree.y) }
    for fi in 0..<len(plot.flowers) { draw_flower(plot.flowers[fi].x, plot.flowers[fi].y, fi) }

    cx := r.x + r.width/2
    cy := r.y + r.height/2
    gate_y := r.y + r.height

    if !plot.owned {
        draw_for_sale_sign(cx, gate_y + 30, plot.cost)
        addr_cstr := strings.clone_to_cstring(plot.address, context.temp_allocator)
        atw := rl.MeasureText(addr_cstr, 6)
        rl.DrawText(addr_cstr, pxi(cx)-atw/2, pxi(gate_y)+36, 6, {220,220,80,200})
        if vec2_dist(g.player.pos, {cx, cy}) < r.width/2 + 80 {
            rl.DrawText("[E] View", pxi(cx)-18, pxi(cy)+8, 7, COL_HONEY)
        }
    } else if plot.owner_is_player {
        draw_mailbox(cx, gate_y + 30)
        rl.DrawText("FUZZY BUDDY FARMS", pxi(cx)-24, pxi(cy)-5, 8, {240,210,0,200})
        addr_cstr := strings.clone_to_cstring(plot.address, context.temp_allocator)
        atw := rl.MeasureText(addr_cstr, 6)
        rl.DrawText(addr_cstr, pxi(cx)-atw/2, pxi(cy)+8, 6, {200,200,100,180})
    } else {
        rl.DrawText("OWNED", pxi(cx)-16, pxi(cy)-5, 8, COL_GREEN_TEXT)
    }
}
draw_park :: proc() {
    r := rl.Rectangle{PARK_X, PARK_Y, PARK_W, PARK_H}

    tile :: f32(16)
    cols := int(r.width/tile)+1
    rows := int(r.height/tile)+1
    for row in 0..<rows {
        for col in 0..<cols {
            cx := r.x + f32(col)*tile; cy := r.y + f32(row)*tile
            cw := min(tile, r.x+r.width-cx); ch := min(tile, r.y+r.height-cy)
            if cw <= 0 || ch <= 0 { continue }
            col_use := rl.Color{70,170,60,255} if (col+row)%2==0 else rl.Color{84,190,72,255}
            rl.DrawRectangle(pxi(cx), pxi(cy), pxi(cw), pxi(ch), col_use)
        }
    }

    gate_cx  := r.x + r.width/2
    path_top := PARK_TREE_Y + 34
    rl.DrawRectangle(pxi(gate_cx-10), pxi(path_top), 20, pxi((r.y+r.height) - path_top), COL_PATH)

    draw_plot_fence(r, true)

    draw_park_entrance_sign(r)

    for i in 0..<BIRD_COUNT {
        b := &g.birds[i]
        draw_bird(b.pos, b.color, b.anim_time, b.is_idle)

    draw_big_tree(PARK_TREE_X, PARK_TREE_Y)
    draw_park_bear({PARK_TREE_X - 34, PARK_TREE_Y + 30}, g.bear_anim_time)

    }
}
add_park_collision :: proc() {
    wall_thickness :: f32(8)
    gate_hw        :: f32(20)

    px := PARK_X; py := PARK_Y; pw := PARK_W; ph := PARK_H
    gate_cx := px + pw/2

    append(&g.collision_rects, rl.Rectangle{px, py - wall_thickness, pw, wall_thickness})
    append(&g.collision_rects, rl.Rectangle{px - wall_thickness, py, wall_thickness, ph})
    append(&g.collision_rects, rl.Rectangle{px + pw, py, wall_thickness, ph})
    append(&g.collision_rects, rl.Rectangle{px, py + ph, (gate_cx - gate_hw) - px, wall_thickness})
    append(&g.collision_rects, rl.Rectangle{gate_cx + gate_hw, py + ph, (px + pw) - (gate_cx + gate_hw), wall_thickness})
}
add_fountain_collision :: proc() {
    r := FOUNTAIN_RADIUS
    append(&g.collision_rects, rl.Rectangle{-r, -r, r*2, r*2})
}

// DRAW BEE BOX


draw_bee_box :: proc(box: BeeBox) {
    x := box.pos.x; y := box.pos.y
    ix := pxi(x); iy := pxi(y)
    fill := box.honey_ml / box.capacity

    switch box.kind {
    case .SmallGround:
        rl.DrawRectangle(ix-14, iy-10, 28, 20, COL_BOX_S)
        rl.DrawRectangleLinesEx({x-14, y-10, 28, 20}, 1, {80,50,20,255})
        rl.DrawRectangle(ix-12, iy+3, 24, 5, {40,28,12,255})
        rl.DrawRectangle(ix-12, iy+3, i32(24*fill), 5, COL_HONEY2)
        rl.DrawRectangle(ix-16, iy-14, 32, 6, {148,108,60,255})
    case .LargeGround:
        rl.DrawRectangle(ix-22, iy-16, 44, 32, COL_BOX_L)
        rl.DrawRectangleLinesEx({x-22, y-16, 44, 32}, 1, {60,35,10,255})
        rl.DrawRectangle(ix-20, iy+8, 38, 6, {40,28,12,255})
        rl.DrawRectangle(ix-20, iy+8, i32(38*fill), 6, COL_HONEY2)
        rl.DrawRectangle(ix-24, iy-22, 48, 8, {128,92,48,255})
    case .TreeHang:
        rl.DrawRectangle(ix, iy-28, 1, 16, {88,60,28,255})
        rl.DrawRectangle(ix-12, iy-14, 24, 18, COL_BOX_T)
        rl.DrawRectangleLinesEx({x-12, y-14, 24, 18}, 1, {40,20,5,255})
        rl.DrawRectangle(ix-10, iy-2, 18, 4, {40,28,12,255})
        rl.DrawRectangle(ix-10, iy-2, i32(18*fill), 4, COL_HONEY2)
    }

    if fill > 0 {
        pct := fmt.aprintf("%.0f%%", fill*100, allocator = context.temp_allocator)
        rl.DrawText(strings.clone_to_cstring(pct, context.temp_allocator), ix-8,
 iy-30, 7, COL_HONEY)
    }
    if vec2_dist(g.player.pos, box.pos) < INTERACT_DIST {
        rl.DrawText("[E] Collect", ix-22, iy-40, 7, COL_HONEY)
    }

    t := f32(rl.GetTime())
    for bi in 0..<min(box.bee_count, 5) {
        bangle := t*2.2 + f32(bi)*1.26
        bx := ix + i32(math.cos(bangle+f32(bi))*16)
        by := iy + i32(math.sin(bangle*0.8+f32(bi))*9) - 18
        rl.DrawRectangle(bx-2, by-1, 4, 3, {220,200,0,220})
        rl.DrawRectangle(bx-1, by-1, 2, 3, {40,40,40,200})
        rl.DrawRectangle(bx-3, by-2, 2, 2, {200,230,255,140})
        rl.DrawRectangle(bx+1, by-2, 2, 2, {200,230,255,140})
    }
}


// DRAW PLAYER
draw_batman_player :: proc() {
    ix := pxi(g.player.pos.x)
    iy := pxi(g.player.pos.y)

    rl.DrawRectangle(ix-9, iy-2, 18, 20, COL_BATMAN_BLACK)
    // Legs
    rl.DrawRectangle(ix-6, iy+6, 5, 10, COL_BATMAN_BLACK)
    rl.DrawRectangle(ix+1, iy+6, 5, 10, COL_BATMAN_BLACK)
    rl.DrawRectangle(ix-6, iy+6, 5, 3, COL_BATMAN_BLUE)
    rl.DrawRectangle(ix+1, iy+6, 5, 3, COL_BATMAN_BLUE)
    // Belt
    rl.DrawRectangle(ix-7, iy+7, 14, 3, COL_BATMAN_GOLD)
    // Torso / chest armor
    rl.DrawRectangle(ix-7, iy-4, 14, 12, COL_BATMAN_GREY)
    rl.DrawRectangle(ix-4, iy-4, 8, 3, COL_BATMAN_GOLD)      // collar trim
    rl.DrawRectangle(ix-2, iy-1, 4, 3, COL_BATMAN_BLACK)     // bat emblem body
    rl.DrawRectangle(ix-5, iy,   3, 2, COL_BATMAN_BLACK)     // bat wing L
    rl.DrawRectangle(ix+2, iy,   3, 2, COL_BATMAN_BLACK)     // bat wing R

    // Shoulders / gauntlets
    rl.DrawRectangle(ix-9, iy-4, 3, 8, COL_BATMAN_BLUE)
    rl.DrawRectangle(ix+6, iy-4, 3, 8, COL_BATMAN_BLUE)

    // Cowl
    rl.DrawRectangle(ix-6, iy-16, 12, 12, COL_BATMAN_BLACK)
    rl.DrawRectangle(ix-6, iy-20, 3, 5, COL_BATMAN_BLACK)    // left ear
    rl.DrawRectangle(ix+3, iy-20, 3, 5, COL_BATMAN_BLACK)    // right ear
    rl.DrawRectangle(ix-6, iy-16, 2, 10, COL_BATMAN_BLUE)    // cowl trim L
    rl.DrawRectangle(ix+4, iy-16, 2, 10, COL_BATMAN_BLUE)    // cowl trim R

    // Eyes
    rl.DrawRectangle(ix-4, iy-11, 3, 2, rl.WHITE)
    rl.DrawRectangle(ix+1, iy-11, 3, 2, rl.WHITE)

    // Exposed jaw
    rl.DrawRectangle(ix-3, iy-6, 6, 4, COL_BATMAN_SKIN)

    // Held Batarang
    hx := ix + pxi(BATARANG_HAND_OFFSET.x)
    hy := iy + pxi(BATARANG_HAND_OFFSET.y)
    rl.DrawRectangle(hx-4, hy-1, 8, 2, BATARANG_COLOR)
    rl.DrawRectangle(hx-2, hy-3, 2, 2, BATARANG_COLOR)
    rl.DrawRectangle(hx,   hy+1, 2, 2, BATARANG_COLOR)

    rl.DrawEllipse(ix, iy+18, 10, 3, COL_SHADOW)
}


draw_player :: proc() {
    if g.batarang_active { draw_batman_player(); return }	
    if g.in_car { return }
    x := pxi(g.player.pos.x); y := pxi(g.player.pos.y)
    rl.DrawEllipse(x, y+10, 8, 3, COL_SHADOW)
    rl.DrawRectangle(x-6, y+14, 5, 5, {48,32,16,255})
    rl.DrawRectangle(x+1, y+14, 5, 5, {48,32,16,255})
    rl.DrawRectangle(x-5, y+6, 4, 10, g.player.pants_color)
    rl.DrawRectangle(x+1, y+6, 4, 10, g.player.pants_color)
    rl.DrawRectangle(x-7, y-2, 14, 10, g.player.shirt_color)
    rl.DrawRectangle(x-11, y-1, 5, 8, g.player.shirt_color)
    rl.DrawRectangle(x+6,  y-1, 5, 8, g.player.shirt_color)

    pc := g.player.pattern_color
    switch g.player.clothing_pattern {
    case .Stripes:
        for si := 0; si < 4; si += 1 {
            rl.DrawRectangle(x-6+i32(si)*4, y-2, 1, 10, rl.Color{pc.r, pc.g, pc.b, 160})
        }
    case .Dots:
        rl.DrawCircle(x-3, y+2, 1, rl.Color{pc.r, pc.g, pc.b, 180})
        rl.DrawCircle(x+3, y+5, 1, rl.Color{pc.r, pc.g, pc.b, 180})
        rl.DrawCircle(x,   y+1, 1, rl.Color{pc.r, pc.g, pc.b, 180})
        rl.DrawCircle(x-2, y+6, 1, rl.Color{pc.r, pc.g, pc.b, 180})
    case .Plaid:
        rl.DrawRectangle(x-7, y,   14, 1, rl.Color{pc.r, pc.g, pc.b, 140})
        rl.DrawRectangle(x-7, y+5, 14, 1, rl.Color{pc.r, pc.g, pc.b, 140})
        rl.DrawRectangle(x-3, y-2, 1,  10, rl.Color{pc.r, pc.g, pc.b, 140})
        rl.DrawRectangle(x+2, y-2, 1,  10, rl.Color{pc.r, pc.g, pc.b, 140})
    case .Checkered:
        for ci := 0; ci < 4; ci += 1 {
            for ri := 0; ri < 2; ri += 1 {
                if (ci+ri)%2 == 0 {
                    rl.DrawRectangle(x-7+i32(ci)*4, y-1+i32(ri)*5, 3, 4, rl.Color{pc.r, pc.g, pc.b, 150})
                }
            }
        }
    case .Solid:
    }

    rl.DrawRectangle(x-2, y-6, 4, 5, g.player.skin_color)
    rl.DrawRectangle(x-5, y-14, 10, 10, g.player.skin_color)
    rl.DrawRectangle(x-3, y-11, 2, 2, {40,30,20,255})
    rl.DrawRectangle(x+1, y-11, 2, 2, {40,30,20,255})
    rl.DrawRectangle(x-7, y-16, 14, 4, g.player.hat_color)
    rl.DrawRectangle(x-5, y-22, 10, 8, g.player.hat_color)
    rl.DrawRectangle(x-7, y-16, 14, 2, rl.Color{pc.r, pc.g, pc.b, 160})

    if g.player.honey_ml > 0 {
        rl.DrawRectangle(x+8, y-14, 8, 8, COL_HONEY)
        rl.DrawText("$", x+10, y-13, 7, {60,30,0,255})
    }
}
draw_player_lightsaber :: proc() {
    if !g.lightsaber_active { return }

    hand := Vec2{g.player.pos.x + LIGHTSABER_HAND_OFFSET.x,
                 g.player.pos.y + LIGHTSABER_HAND_OFFSET.y}

    rl.DrawRectangle(pxi(hand.x)-1, pxi(hand.y), 3, pxi(LIGHTSABER_HILT_LEN), LIGHTSABER_HILT_COLOR)
    blade_top := hand.y - LIGHTSABER_BLADE_LEN
    rl.DrawRectangle(pxi(hand.x)-1, pxi(blade_top), 3, pxi(LIGHTSABER_BLADE_LEN), LIGHTSABER_BLADE_COLOR)
    rl.BeginBlendMode(.ADDITIVE)
    rl.DrawCircleGradient({f32(pxi(hand.x)), f32(pxi(blade_top + LIGHTSABER_BLADE_LEN/2))},
        10, rl.Color{80,170,255,120}, rl.Color{0,0,0,0})
    rl.EndBlendMode()
}
draw_player_bee_net :: proc() {
    if !g.bee_net_active || g.in_car { return }
    hand := Vec2{g.player.pos.x + 9, g.player.pos.y + 2}
    rl.DrawRectangle(pxi(hand.x)-1, pxi(hand.y)-6, 2, 12, {120, 80, 40, 255})
    hoop_y := hand.y - 12
    rl.DrawCircleLines(pxi(hand.x), pxi(hoop_y), 7, {200, 200, 210, 255})
    rl.DrawCircle(pxi(hand.x), pxi(hoop_y), 6, {230, 230, 240, 70})
    rl.DrawLine(pxi(hand.x)-5, pxi(hoop_y), pxi(hand.x)+5, pxi(hoop_y), {210, 210, 220, 150})
    rl.DrawLine(pxi(hand.x), pxi(hoop_y)-5, pxi(hand.x), pxi(hoop_y)+5, {210, 210, 220, 150})
}

// DRAW NPC (with clothing)

draw_npc :: proc(npc: NPC) {
    x := pxi(npc.pos.x); y := pxi(npc.pos.y)
    rl.DrawEllipse(x, y+9, 7, 3, COL_SHADOW)
    rl.DrawRectangle(x-5, y+12, 4, 4, {48,32,16,255})
    rl.DrawRectangle(x+1, y+12, 4, 4, {48,32,16,255})
    rl.DrawRectangle(x-4, y+5, 3, 8, npc.pants_color)
    rl.DrawRectangle(x+1, y+5, 3, 8, npc.pants_color)
    rl.DrawRectangle(x-6, y-2, 12, 9, npc.shirt_color)
    rl.DrawRectangle(x-9, y-1, 4, 7, npc.shirt_color)
    rl.DrawRectangle(x+5, y-1, 4, 7, npc.shirt_color)
    switch npc.clothing_pattern {
    case .Stripes:
        for si := 0; si < 3; si += 1 {
            rl.DrawRectangle(x-5+i32(si)*4, y-2, 1, 9, rl.Color{npc.pattern_color.r, npc.pattern_color.g, npc.pattern_color.b, 160})
        }
    case .Dots:
        rl.DrawCircle(x-2, y+2, 1, rl.Color{npc.pattern_color.r, npc.pattern_color.g, npc.pattern_color.b, 180})
        rl.DrawCircle(x+2, y+5, 1, rl.Color{npc.pattern_color.r, npc.pattern_color.g, npc.pattern_color.b, 180})
        rl.DrawCircle(x,   y+1, 1, rl.Color{npc.pattern_color.r, npc.pattern_color.g, npc.pattern_color.b, 180})
    case .Plaid:
        rl.DrawRectangle(x-5, y,   12, 1, rl.Color{npc.pattern_color.r, npc.pattern_color.g, npc.pattern_color.b, 140})
        rl.DrawRectangle(x-5, y+4, 12, 1, rl.Color{npc.pattern_color.r, npc.pattern_color.g, npc.pattern_color.b, 140})
        rl.DrawRectangle(x-2, y-2, 1,  9, rl.Color{npc.pattern_color.r, npc.pattern_color.g, npc.pattern_color.b, 140})
        rl.DrawRectangle(x+2, y-2, 1,  9, rl.Color{npc.pattern_color.r, npc.pattern_color.g, npc.pattern_color.b, 140})
    case .Checkered:
        for ci := 0; ci < 3; ci += 1 {
            for ri := 0; ri < 2; ri += 1 {
                if (ci+ri)%2 == 0 {
                    rl.DrawRectangle(x-5+i32(ci)*4, y-1+i32(ri)*4, 3, 3, rl.Color{npc.pattern_color.r, npc.pattern_color.g, npc.pattern_color.b, 150})
                }
            }
        }
    case .Solid:
    }
    rl.DrawRectangle(x-4, y-11, 8, 9, npc.color)
    rl.DrawRectangle(x-2, y-9, 2, 2, {40,30,20,255})
    rl.DrawRectangle(x+1, y-9, 2, 2, {40,30,20,255})
    if npc.kind == .Farmer {
        rl.DrawRectangle(x-7, y-13, 14, 3, npc.hat_color)
        rl.DrawRectangle(x-5, y-18, 10, 7, npc.hat_color)
        rl.DrawRectangle(x-5, y-14, 10, 2, rl.Color{npc.pattern_color.r, npc.pattern_color.g, npc.pattern_color.b, 200})
    } else {
        rl.DrawRectangle(x-5, y-13, 10, 4, npc.hat_color)
    }
    lbl := strings.clone_to_cstring(npc.name, context.temp_allocator)
    tw  := rl.MeasureText(lbl, 7)
    rl.DrawText(lbl, x-tw/2, y-26, 7, COL_FLOWER_R)
    if vec2_dist(g.player.pos, npc.pos) < INTERACT_DIST {
        rl.DrawText("[E] Talk", x-16, y-38, 7, COL_FLOWER_B)
    }
}
draw_npc_icon :: proc(npc: NPC, cx, cy: f32) {
    x := pxi(cx); y := pxi(cy)
    rl.DrawEllipse(x, y+9, 7, 3, COL_SHADOW)
    rl.DrawRectangle(x-5, y+12, 4, 4, {48,32,16,255})
    rl.DrawRectangle(x+1, y+12, 4, 4, {48,32,16,255})
    rl.DrawRectangle(x-4, y+5, 3, 8, npc.pants_color)
    rl.DrawRectangle(x+1, y+5, 3, 8, npc.pants_color)
    rl.DrawRectangle(x-6, y-2, 12, 9, npc.shirt_color)
    rl.DrawRectangle(x-9, y-1, 4, 7, npc.shirt_color)
    rl.DrawRectangle(x+5, y-1, 4, 7, npc.shirt_color)
    switch npc.clothing_pattern {
    case .Stripes:
        for si := 0; si < 3; si += 1 {
            rl.DrawRectangle(x-5+i32(si)*4, y-2, 1, 9, rl.Color{npc.pattern_color.r, npc.pattern_color.g, npc.pattern_color.b, 160})
        }
    case .Dots:
        rl.DrawCircle(x-2, y+2, 1, rl.Color{npc.pattern_color.r, npc.pattern_color.g, npc.pattern_color.b, 180})
        rl.DrawCircle(x+2, y+5, 1, rl.Color{npc.pattern_color.r, npc.pattern_color.g, npc.pattern_color.b, 180})
        rl.DrawCircle(x,   y+1, 1, rl.Color{npc.pattern_color.r, npc.pattern_color.g, npc.pattern_color.b, 180})
    case .Plaid:
        rl.DrawRectangle(x-5, y,   12, 1, rl.Color{npc.pattern_color.r, npc.pattern_color.g, npc.pattern_color.b, 140})
        rl.DrawRectangle(x-5, y+4, 12, 1, rl.Color{npc.pattern_color.r, npc.pattern_color.g, npc.pattern_color.b, 140})
        rl.DrawRectangle(x-2, y-2, 1,  9, rl.Color{npc.pattern_color.r, npc.pattern_color.g, npc.pattern_color.b, 140})
        rl.DrawRectangle(x+2, y-2, 1,  9, rl.Color{npc.pattern_color.r, npc.pattern_color.g, npc.pattern_color.b, 140})
    case .Checkered:
        for ci := 0; ci < 3; ci += 1 {
            for ri := 0; ri < 2; ri += 1 {
                if (ci+ri)%2 == 0 {
                    rl.DrawRectangle(x-5+i32(ci)*4, y-1+i32(ri)*4, 3, 3, rl.Color{npc.pattern_color.r, npc.pattern_color.g, npc.pattern_color.b, 150})
                }
            }
        }
    case .Solid:
    }
    rl.DrawRectangle(x-4, y-11, 8, 9, npc.color)
    rl.DrawRectangle(x-2, y-9, 2, 2, {40,30,20,255})
    rl.DrawRectangle(x+1, y-9, 2, 2, {40,30,20,255})
    if npc.kind == .Farmer {
        rl.DrawRectangle(x-7, y-13, 14, 3, npc.hat_color)
        rl.DrawRectangle(x-5, y-18, 10, 7, npc.hat_color)
        rl.DrawRectangle(x-5, y-14, 10, 2, rl.Color{npc.pattern_color.r, npc.pattern_color.g, npc.pattern_color.b, 200})
    } else {
        rl.DrawRectangle(x-5, y-13, 10, 4, npc.hat_color)
    }
}


// DRAW DIRT ROADS


DIRT_W   :: i32(44)
PLOT_BUF :: f32(48)

dirt_road_intervals :: proc(
    road_start, road_end: f32,
    fixed_coord: f32,
    axis: int,
    allocator := context.temp_allocator,
) -> [dynamic][2]f32 {
    intervals := make([dynamic][2]f32, allocator)
    append(&intervals, [2]f32{road_start, road_end})

    for i in 0..<len(g.plots) {
        r := g.plots[i].rect
        px0 := r.x - PLOT_BUF
        px1 := r.x + r.width  + PLOT_BUF
        py0 := r.y - PLOT_BUF
        py1 := r.y + r.height + PLOT_BUF

        perp_hit: bool
        if axis == 0 {
            perp_hit = fixed_coord >= py0 && fixed_coord <= py1
        } else {
            perp_hit = fixed_coord >= px0 && fixed_coord <= px1
        }
        if !perp_hit { continue }

        block_lo, block_hi: f32
        if axis == 0 {
            block_lo = px0; block_hi = px1
        } else {
            block_lo = py0; block_hi = py1
        }

        new_intervals := make([dynamic][2]f32, allocator)
        for seg in intervals {
            a := seg[0]; b := seg[1]
            if block_hi <= a || block_lo >= b {
                append(&new_intervals, [2]f32{a, b})
            } else {
                if block_lo > a { append(&new_intervals, [2]f32{a, block_lo}) }
                if block_hi < b { append(&new_intervals, [2]f32{block_hi, b}) }
            }
        }
        intervals = new_intervals
    }
    return intervals
}

draw_dirt_h :: proc(x1, x2, cy: f32) {
    segs := dirt_road_intervals(x1, x2, cy, 0)
    for seg in segs {
        sx := i32(seg[0]); ex := i32(seg[1])
        if ex <= sx { continue }
        w := ex - sx
        rl.DrawRectangle(sx, i32(cy)-DIRT_W/2, w, DIRT_W, COL_DIRT_ROAD)
        rl.DrawRectangle(sx, i32(cy)-DIRT_W/2, w, 2, COL_DIRT_ROAD2)
        rl.DrawRectangle(sx, i32(cy)+DIRT_W/2-2, w, 2, COL_DIRT_ROAD2)
    }
}

draw_dirt_v :: proc(y1, y2, cx: f32) {
    segs := dirt_road_intervals(y1, y2, cx, 1)
    for seg in segs {
        sy := i32(seg[0]); ey := i32(seg[1])
        if ey <= sy { continue }
        h := ey - sy
        rl.DrawRectangle(i32(cx)-DIRT_W/2, sy, DIRT_W, h, COL_DIRT_ROAD)
        rl.DrawRectangle(i32(cx)-DIRT_W/2, sy, 2, h, COL_DIRT_ROAD2)
        rl.DrawRectangle(i32(cx)+DIRT_W/2-2, sy, 2, h, COL_DIRT_ROAD2)
    }
}

draw_dirt_roads :: proc() {
    draw_dirt_v(-2400, -600,  0)
    draw_dirt_v( 600,  2400,  0)
    draw_dirt_h(-2400, -600,  0)
    draw_dirt_h( 600,  2400,  0)

    draw_dirt_h(-2400, 2400, -900)
    draw_dirt_h(-2400, 2400,  900)
    draw_dirt_v(-2400, 2400, -1100)
    draw_dirt_v(-2400, 2400,  1100)

    draw_dirt_h(-2400, 2400, -1700)
    draw_dirt_h(-2400, 2400,  1700)
    draw_dirt_v(-2400, 2400, -1900)
    draw_dirt_v(-2400, 2400,  1900)

    draw_dirt_h(-2600, 2600, -2400)
    draw_dirt_h(-2600, 2600,  2400)
    draw_dirt_v(-2600, 2600, -2600)
    draw_dirt_v(-2600, 2600,  2600)
}


// DRAW GROUND (town center)


draw_ground :: proc() {
    tile :: i32(16)
    for ty := i32(-600); ty < 600; ty += tile {
        for tx := i32(-600); tx < 600; tx += tile {
            col := COL_SIDEWALK if ((tx/tile)+(ty/tile))%2==0 else COL_SIDEWALK2
            rl.DrawRectangle(tx, ty, tile, tile, col)
        }
    }
    for ty := i32(-180); ty < 180; ty += 8 {
        for tx := i32(-180); tx < 180; tx += 8 {
            col := COL_GRASS2 if ((tx/8)+(ty/8))%2==0 else COL_GRASS3
            rl.DrawRectangle(tx, ty, 8, 8, col)
        }
    }
    rl.DrawRectangle(-600, -36, 1200, 72, COL_ROAD)
    rl.DrawRectangle(-36, -600, 72, 1200, COL_ROAD)
    rl.DrawRectangle(-600, -36, 1200, 2, COL_ROAD_LINE)
    rl.DrawRectangle(-600,  34, 1200, 2, COL_ROAD_LINE)
    rl.DrawRectangle(-36, -600, 2, 1200, COL_ROAD_LINE)
    rl.DrawRectangle( 34, -600, 2, 1200, COL_ROAD_LINE)
    for i := -10; i <= 10; i += 1 {
        if i % 2 == 0 {
            rl.DrawRectangle(i32(i)*56-20, -3, 40, 6, {200,190,60,180})
            rl.DrawRectangle(-3, i32(i)*56-20, 6, 40, {200,190,60,180})
        }
    }
    rl.DrawRectangleLinesEx({-600,-600,1200,1200}, 3, {120,110,90,255})
}


// DRAW TOWN DECORATIONS


draw_town_decorations :: proc() {
    bench_positions := [4][2]f32{{-80,-60},{80,-60},{-60,80},{60,80}}
    for bp in bench_positions {
        ix := pxi(bp[0]); iy := pxi(bp[1])
        rl.DrawRectangle(ix-14, iy-2, 28, 4, {108,72,36,255})
        rl.DrawRectangle(ix-14, iy-10, 28, 4, {108,72,36,255})
        rl.DrawRectangle(ix-12, iy+2, 3, 8, {88,56,28,255})
        rl.DrawRectangle(ix+9,  iy+2, 3, 8, {88,56,28,255})
    }

    // Fountain
    for fi := -38; fi <= 38; fi += 1 {
        h := i32(math.sqrt(max(0.0, 38.0*38.0 - f32(fi)*f32(fi))))
        rl.DrawRectangle(i32(fi)-1, -h, 2, h*2, COL_WATER)
    }
    for fi := -30; fi <= 30; fi += 1 {
        h := i32(math.sqrt(max(0.0, 30.0*30.0 - f32(fi)*f32(fi))))
        rl.DrawRectangle(i32(fi)-1, -h, 2, h*2, COL_WATER2)
    }
    rl.DrawRectangle(-3, -28, 6, 32, {160,180,200,255})
    rl.DrawRectangle(-5, -30, 10, 4, {180,200,220,255})
    t := f32(rl.GetTime())
    for ji in 0..<8 {
        ang := f32(ji)*0.785 + t*0.5
        jx  := i32(math.cos(ang)*10); jy := i32(math.sin(ang)*6) - 22
        rl.DrawRectangle(jx, jy, 2, 4, {180,220,255,200})
    }

    // Town sign
    rl.DrawRectangle(-52, -46, 104, 20, {80,56,24,255})
    rl.DrawRectangle(-52, -46, 104, 3,  {100,72,32,255})
    rl.DrawRectangleLinesEx({-52,-46,104,20}, 1, COL_HONEY)
    rl.DrawText("HONEYVILLE", -48, -42, 8, COL_HONEY)
    rl.DrawRectangle(-46, -26, 4, 20, {80,56,24,255})
    rl.DrawRectangle( 42, -26, 4, 20, {80,56,24,255})

    // Plaza flowers
    plaza_flowers := [8][2]f32{{-120,80},{120,-80},{120,80},{180,85},{-80,-
180},{90,-170},{-80,110},{80,90}}
    for fi in 0..<8 { draw_flower(plaza_flowers[fi][0], plaza_flowers[fi][1], 
fi) }

    // Bushes
    bush_pos := [5][2]f32{{-60,-134},{86,-78},{-86,67},{60,-170},{60,175}}
    for bp in bush_pos {
        ix := pxi(bp[0]); iy := pxi(bp[1])
        rl.DrawRectangle(ix-8, iy-4, 16, 8, {36,100,36,255})
        rl.DrawRectangle(ix-6, iy-7, 12, 6, {48,120,48,255})
        rl.DrawRectangle(ix-4, iy-9, 8, 4,  {60,140,60,255})
    }
}

draw_rain :: proc() {
    if g.rain_timer <= 0 { return }
    t := f32(rl.GetTime())
    rl.DrawRectangle(0, 0, GAME_W, GAME_H, {40, 60, 100, 60})
    for ri in 0..<80 {
        rx := i32(int(f32(ri)*83.7 + t*120) % GAME_W)
        ry := i32(int(f32(ri)*47.3 + t*200) % GAME_H)
        rl.DrawRectangle(rx, ry, 1, 6, {180, 210, 255, 120})
    }
}
draw_lightning_bugs :: proc() {
    if !g.is_night { return }

    t := f32(rl.GetTime())

    for i in 0..<LIGHTNING_BUG_COUNT {
        bug := &g.lightning_bugs[i]

        bangle := t * 1.8 + bug.flash_time
        wx := bug.pos.x + math.cos(bangle) * 6
        wy := bug.pos.y + math.sin(bangle * 0.75) * 4
        flash := (math.sin(bug.flash_time * 3.9) + 1.0) * 0.5
        bright_r := u8(220)
        bright_g := u8(255)
        bright_b := u8(0)
        dim_r    := u8(30)
        dim_g    := u8(50)
        dim_b    := u8(0)
        r := u8(f32(dim_r) + flash * f32(bright_r - dim_r))
        gv := u8(f32(dim_g) + flash * f32(bright_g - dim_g))
        b := u8(f32(dim_b) + flash * f32(bright_b - dim_b))
        body_col := rl.Color{r, gv, b, 255}
        glow_alpha := u8(flash * 80)
        glow_col   := rl.Color{220, 255, 0, glow_alpha}
        rl.DrawCircle(pxi(wx), pxi(wy), 6, glow_col)
        glow2_alpha := u8(flash * 140)
        glow2_col   := rl.Color{240, 255, 60, glow2_alpha}
        rl.DrawCircle(pxi(wx), pxi(wy), 3, glow2_col)
        rl.DrawRectangle(pxi(wx)-1, pxi(wy)-1, 2, 2, body_col)
        wing_alpha := u8(60 + u8(flash * 80))
        wing_col   := rl.Color{200, 230, 255, wing_alpha}
        rl.DrawRectangle(pxi(wx)-3, pxi(wy)-2, 2, 2, wing_col)
        rl.DrawRectangle(pxi(wx)+1, pxi(wy)-2, 2, 2, wing_col)
    }
}
draw_soccer :: proc() {
    sg := &g.soccer
    fw := SOCCER_FIELD_W
    fh := SOCCER_FIELD_H
    fx := SOCCER_FIELD_X
    fy := SOCCER_FIELD_Y
    wall :: f32(8)
    COL_PITCH      :: rl.Color{ 34, 120,  34, 255}
    COL_PITCH2     :: rl.Color{ 28, 100,  28, 255}
    COL_LINE       :: rl.Color{240, 240, 240, 200}
    COL_GOAL_POST  :: rl.Color{240, 240, 240, 255}
    COL_GOAL_NET   :: rl.Color{200, 200, 200, 100}
    stripe_w :: f32(34)
    stripe_count := int(fw / stripe_w) + 1
    for i in 0..<stripe_count {
        col := COL_PITCH if i%2 == 0 else COL_PITCH2
        sx := fx + f32(i) * stripe_w
        sw := min(stripe_w, fx + fw - sx)
        rl.DrawRectangle(pxi(sx), pxi(fy), pxi(sw), pxi(fh), col)
    }
draw_wall_3d :: proc(rx, ry, rw, rh: f32) {
    rl.DrawRectangle(pxi(rx)+3, pxi(ry)+3, pxi(rw), pxi(rh), COL_WALL_SHADOW)
    rl.DrawRectangle(pxi(rx)+2, pxi(ry)+2, pxi(rw), pxi(rh), COL_WALL_DARK)
    rl.DrawRectangle(pxi(rx), pxi(ry), pxi(rw), pxi(rh), COL_WALL_MID)
    rl.DrawRectangle(pxi(rx), pxi(ry), pxi(rw), 2, COL_WALL_LIGHT)
    rl.DrawRectangle(pxi(rx), pxi(ry), 2, pxi(rh), COL_WALL_LIGHT)
}

draw_wall_3d(fx, fy, fw, wall)
draw_wall_3d(fx, fy + fh - wall, fw, wall)
draw_wall_3d(fx, fy + wall, wall, sg.goal_left_y1 - (fy + wall))
draw_wall_3d(fx, sg.goal_left_y2, wall, (fy + fh - wall) - sg.goal_left_y2)
draw_wall_3d(fx + fw - wall, fy + wall, wall, sg.goal_right_y1 - (fy + wall))
draw_wall_3d(fx + fw - wall, sg.goal_right_y2, wall, (fy + fh - wall) - sg.goal_right_y2)

    cx := fx + fw/2
    rl.DrawRectangle(pxi(cx) - 1, pxi(fy + wall), 2, pxi(fh - wall*2), COL_LINE)
    rl.DrawCircleLines(pxi(cx), pxi(fy + fh/2), 30, COL_LINE)
    rl.DrawCircle(pxi(cx), pxi(fy + fh/2), 3, COL_LINE)

    goal_depth :: f32(18)
    goal_h := sg.goal_left_y2 - sg.goal_left_y1
    rl.DrawRectangle(pxi(fx - goal_depth), pxi(sg.goal_left_y1),
        pxi(goal_depth), pxi(goal_h), COL_GOAL_NET)
    rl.DrawRectangleLines(pxi(fx - goal_depth), pxi(sg.goal_left_y1),
        pxi(goal_depth), pxi(goal_h), COL_GOAL_POST)
    rl.DrawRectangle(pxi(fx + fw), pxi(sg.goal_right_y1),
        pxi(goal_depth), pxi(goal_h), COL_GOAL_NET)
    rl.DrawRectangleLines(pxi(fx + fw), pxi(sg.goal_right_y1),
        pxi(goal_depth), pxi(goal_h), COL_GOAL_POST)

    if sg.state == .GoalFlash {
        flash_col := rl.Color{255, 220, 0, u8(min(180, sg.goal_flash_time * 90))}
        rl.DrawRectangle(pxi(fx), pxi(fy), pxi(fw), pxi(fh), flash_col)
    }

np  := sg.npc.pos
nx  := pxi(np.x)
ny  := pxi(np.y)

REF_SHIRT   :: rl.Color{ 20,  20,  20, 255}
REF_STRIPE  :: rl.Color{240, 240, 240, 180}
REF_PANTS   :: rl.Color{ 30,  30,  30, 255}
REF_BOOTS   :: rl.Color{ 48,  32,  16, 255}
REF_SKIN    :: rl.Color{220, 180, 140, 255}
REF_SHADOW  :: rl.Color{  0,   0,   0,  60}
REF_HAT     :: rl.Color{  0,   0,   0, 255}

rl.DrawEllipse(nx, ny+9, 7, 3, REF_SHADOW)
rl.DrawRectangle(nx-5, ny+12, 4, 4, REF_BOOTS)
rl.DrawRectangle(nx+1, ny+12, 4, 4, REF_BOOTS)
rl.DrawRectangle(nx-4, ny+5, 3, 8, REF_PANTS)
rl.DrawRectangle(nx+1, ny+5, 3, 8, REF_PANTS)
rl.DrawRectangle(nx-6, ny-2, 12, 9, REF_SHIRT)
rl.DrawRectangle(nx-9, ny-1, 4, 7, REF_SHIRT)
rl.DrawRectangle(nx+5, ny-1, 4, 7, REF_SHIRT)
for si := 0; si < 3; si += 1 {
    rl.DrawRectangle(nx-5+i32(si)*4, ny-2, 1, 9, REF_STRIPE)
}
rl.DrawRectangle(nx-4, ny-11, 8, 9, REF_SKIN)
rl.DrawRectangle(nx-2, ny-9, 2, 2, {40, 30, 20, 255})
rl.DrawRectangle(nx+1, ny-9, 2, 2, {40, 30, 20, 255})
rl.DrawRectangle(nx-7, ny-13, 14, 3, REF_HAT)
rl.DrawRectangle(nx-5, ny-18, 10, 7, REF_HAT)
rl.DrawRectangle(nx-5, ny-14, 10, 2, rl.Color{220, 180, 40, 200})
rl.DrawText("LeeAnal Messy", nx-18, ny-26, 7, COL_FLOWER_R)

if sg.state == .Idle {
    dist := vec2_dist(g.player.pos, sg.npc.pos)
    if dist < SOCCER_CHALLENGE_DIST {
        rl.DrawText("[C] Challenge to 1v1", nx-50, ny-38, 8, COL_HONEY2)
    }
}

    bp := sg.ball.pos
    bob := math.sin(sg.ball.bob_time * SOCCER_BALL_BOUNCE_FREQ) * SOCCER_BALL_BOUNCE_AMP
    rl.DrawEllipse(pxi(bp.x), pxi(bp.y) + pxi(SOCCER_BALL_RADIUS), 6, 3,
        rl.Color{0, 0, 0, 60})
    // Ball body
    rl.DrawCircle(pxi(bp.x), pxi(bp.y + bob), SOCCER_BALL_RADIUS,
        rl.Color{240, 240, 240, 255})
    // Black pentagon patches
    rl.DrawCircle(pxi(bp.x), pxi(bp.y + bob), SOCCER_BALL_RADIUS - 2,
        rl.Color{240, 240, 240, 255})
    rl.DrawCircle(pxi(bp.x), pxi(bp.y + bob), 2, rl.Color{20, 20, 20, 255})
    rl.DrawRectangle(pxi(bp.x) - 1, pxi(bp.y + bob) - pxi(SOCCER_BALL_RADIUS) + 1,
        2, 2, rl.Color{20, 20, 20, 255})
    rl.DrawRectangle(pxi(bp.x) + pxi(SOCCER_BALL_RADIUS) - 3, pxi(bp.y + bob) - 1,
        2, 2, rl.Color{20, 20, 20, 255})
    rl.DrawRectangle(pxi(bp.x) - pxi(SOCCER_BALL_RADIUS) + 1, pxi(bp.y + bob) - 1,
        2, 2, rl.Color{20, 20, 20, 255})

    if sg.state == .Playing || sg.state == .GoalFlash {
        // Score bar at top of field
        score_str := fmt.aprintf("YOU %d  -  %d NPC", sg.player_score, sg.npc_score,
            allocator = context.temp_allocator)
        rl.DrawRectangle(pxi(fx + fw/2) - 60, pxi(fy) - 18, 120, 16, COL_HUD_BG)
        rl.DrawText(strings.clone_to_cstring(score_str, context.temp_allocator),
            pxi(fx + fw/2) - 55, pxi(fy) - 16, 10, COL_TEXT)
        rl.DrawText("[H] Help", pxi(fx + fw - 50), pxi(fy) - 16, 8, COL_TEXT2)
    }

    if sg.state == .GameOver {
        rl.DrawRectangle(pxi(fx + 20), pxi(fy + fh/2) - 30, pxi(fw - 40), 60, COL_PANEL)
        rl.DrawRectangleLines(pxi(fx + 20), pxi(fy + fh/2) - 30, pxi(fw - 40), 60, COL_PANEL_BORDER)
        if sg.player_score >= SOCCER_GOALS_TO_WIN {
            rl.DrawText("YOU WIN!  +$2000", pxi(fx + fw/2) - 55, pxi(fy + fh/2) - 18, 14, COL_GREEN_TEXT)
        } else {
            rl.DrawText("YOU LOST!  -$1000", pxi(fx + fw/2) - 58, pxi(fy + fh/2) - 18, 14, COL_RED_TEXT)
        }
        final_str := fmt.aprintf("Final: %d - %d", sg.player_score, sg.npc_score,
            allocator = context.temp_allocator)
        rl.DrawText(strings.clone_to_cstring(final_str, context.temp_allocator),
            pxi(fx + fw/2) - 35, pxi(fy + fh/2) + 4, 10, COL_TEXT)
    }

    if sg.show_help && (sg.state == .Playing || sg.state == .GoalFlash) {
        hx := pxi(fx + 10)
        hy := pxi(fy + 10)
        rl.DrawRectangle(hx, hy, 200, 110, COL_PANEL)
        rl.DrawRectangleLines(hx, hy, 200, 110, COL_PANEL_BORDER)
        rl.DrawText("⚽ SOCCER CONTROLS", hx + 6, hy + 6,  9, COL_HONEY2)
        rl.DrawText("WASD / Arrows - Move",  hx + 6, hy + 22, 8, COL_TEXT)
        rl.DrawText("Walk into ball - Kick",  hx + 6, hy + 34, 8, COL_TEXT)
        rl.DrawText("X - Slide Tackle",       hx + 6, hy + 46, 8, COL_TEXT)
        rl.DrawText("C - Challenge NPC",      hx + 6, hy + 58, 8, COL_TEXT)
        rl.DrawText("H - Toggle this help",   hx + 6, hy + 70, 8, COL_TEXT)
        rl.DrawText("Score 3 goals to win!",  hx + 6, hy + 84, 8, COL_GREEN_TEXT)
        rl.DrawText("Win: +$2000  Lose: -$1000", hx + 6, hy + 96, 8, COL_TEXT2)
    }
}
draw_animals :: proc() {
    for i in 0..<ANIMAL_COUNT {
        a := &g.animals[i]
        ax := pxi(a.pos.x)
        ay := pxi(a.pos.y)

        // Leg bob 
        leg_bob := i32(0)
        if !a.is_idle {
            leg_bob = i32(math.sin(a.anim_time) * 1.5)
        }

        fx :: proc(base_x: i32, offset: i32, flip: bool) -> i32 {
            if flip { return base_x - offset }
            return base_x + offset
        }

        switch a.kind {

        case .Rabbit:
            COL_R_BODY :: rl.Color{220, 210, 200, 255}
            COL_R_EAR  :: rl.Color{200, 160, 160, 255}
            COL_R_EYE  :: rl.Color{ 40,  20,  20, 255}
            COL_R_NOSE :: rl.Color{220, 120, 120, 255}
            // Shadow
            rl.DrawEllipse(ax, ay+7, 8, 3, COL_SHADOW)
            // Ears 
            ear_twitch := i32(0)
            if a.is_idle { ear_twitch = i32(math.sin(a.anim_time*2)*1.5) }
            rl.DrawRectangle(ax + 3, ay-16+ear_twitch, 3, 8, COL_R_BODY)
            rl.DrawRectangle(ax - 3, ay-15+ear_twitch, 1, 6, COL_R_EAR)
            rl.DrawRectangle(ax + 2, ay-15, 3, 8, COL_R_BODY)
            rl.DrawRectangle(ax + 2, ay-14, 1, 6, COL_R_EAR)
            // Body
            rl.DrawRectangle(ax-5, ay-7, 10, 9, COL_R_BODY)
            // Head
            rl.DrawRectangle(ax-4, ay-12, 8, 7, COL_R_BODY)
            // Eye
            rl.DrawRectangle(ax - 1, ay-10, 2, 2, COL_R_EYE)
            // Nose
            rl.DrawRectangle(ax + 2, ay-8,  2, 1, COL_R_NOSE)
            // Legs
            rl.DrawRectangle(ax - 4, ay+1+leg_bob, 3, 4, COL_R_BODY)
            rl.DrawRectangle(ax + 1, ay+1-leg_bob, 3, 4, COL_R_BODY)
            // Tail
            rl.DrawCircle(ax + 5, ay-2, 3, COL_R_BODY)

        case .Fox:
            COL_F_BODY :: rl.Color{210,  90,  30, 255}
            COL_F_BELLY:: rl.Color{240, 200, 160, 255}
            COL_F_EAR  :: rl.Color{180,  50,  20, 255}
            COL_F_EYE  :: rl.Color{ 30,  20,  10, 255}
            COL_F_TAIL :: rl.Color{240, 240, 240, 255}
            // Shadow
            rl.DrawEllipse(ax, ay+8, 10, 3, COL_SHADOW)
            // Tail 
            tail_wag := i32(0)
            if !a.is_idle { tail_wag = i32(math.sin(a.anim_time*1.5)*3) }
            rl.DrawRectangle(ax + 6, ay-2+tail_wag, 6, 4, COL_F_BODY)
            rl.DrawCircle(ax + 11, ay-1+tail_wag, 4, COL_F_TAIL)
            // Body
            rl.DrawRectangle(ax-6, ay-5, 12, 9, COL_F_BODY)
            // Belly
            rl.DrawRectangle(ax-3, ay-3, 6, 6, COL_F_BELLY)
            // Head
            rl.DrawRectangle(ax-5, ay-12, 10, 8, COL_F_BODY)
            // Snout
            rl.DrawRectangle(ax - 7, ay-9, 4, 4, COL_F_BELLY)
            // Ears
            rl.DrawRectangle(ax - 4, ay-18, 3, 6, COL_F_BODY)
            rl.DrawRectangle(ax - 3, ay-17, 1, 4, COL_F_EAR)
            rl.DrawRectangle(ax + 1, ay-17, 3, 5, COL_F_BODY)
            rl.DrawRectangle(ax + 2, ay-16, 1, 3, COL_F_EAR)
            // Eye
            rl.DrawRectangle(ax - 3, ay-10, 2, 2, COL_F_EYE)
            // Legs
            rl.DrawRectangle(ax - 5, ay+3+leg_bob, 3, 5, COL_F_BODY)
            rl.DrawRectangle(ax + 2, ay+3-leg_bob, 3, 5, COL_F_BODY)

        case .Deer:
            COL_D_BODY :: rl.Color{180, 120,  60, 255}
            COL_D_BELLY:: rl.Color{220, 190, 150, 255}
            COL_D_EYE  :: rl.Color{ 30,  20,  10, 255}
            COL_D_ANTLER::rl.Color{140,  90,  40, 255}
            COL_D_NOSE :: rl.Color{ 60,  30,  20, 255}
            // Shadow
            rl.DrawEllipse(ax, ay+12, 12, 4, COL_SHADOW)
            // Legs
            rl.DrawRectangle(ax - 6, ay+6+leg_bob,  3, 8, COL_D_BODY)
            rl.DrawRectangle(ax - 2, ay+6-leg_bob,  3, 8, COL_D_BODY)
            rl.DrawRectangle(ax + 2, ay+6+leg_bob,  3, 8, COL_D_BODY)
            rl.DrawRectangle(ax + 5, ay+6-leg_bob,  3, 8, COL_D_BODY)
            // Body
            rl.DrawRectangle(ax-8, ay-6, 16, 13, COL_D_BODY)
            // Belly patch
            rl.DrawRectangle(ax-5, ay-2, 10, 7, COL_D_BELLY)
            // Neck
            rl.DrawRectangle(ax - 4, ay-14, 5, 9, COL_D_BODY)
            // Head
            rl.DrawRectangle(ax-5, ay-20, 10, 8, COL_D_BODY)
            // Snout
            rl.DrawRectangle(ax - 7, ay-17, 4, 4, COL_D_BELLY)
            rl.DrawRectangle(ax - 7, ay-15, 3, 2, COL_D_NOSE)
            // Eye
            rl.DrawRectangle(ax - 1, ay-18, 2, 2, COL_D_EYE)
            // Antlers
            rl.DrawRectangle(ax - 3, ay-26, 2, 7, COL_D_ANTLER)
            rl.DrawRectangle(ax - 5, ay-26, 4, 2, COL_D_ANTLER)
            rl.DrawRectangle(ax + 1, ay-24, 2, 5, COL_D_ANTLER)
            rl.DrawRectangle(ax + 1, ay-24, 4, 2, COL_D_ANTLER)
            // Ears
            rl.DrawRectangle(ax + 3, ay-22, 4, 3, COL_D_BODY)
            rl.DrawRectangle(ax - 7, ay-22, 4, 3, COL_D_BODY)

        case .Squirrel:
            COL_SQ_BODY :: rl.Color{160, 100,  40, 255}
            COL_SQ_BELLY:: rl.Color{230, 200, 160, 255}
            COL_SQ_EYE  :: rl.Color{ 20,  10,   5, 255}
            COL_SQ_TAIL :: rl.Color{180, 120,  50, 255}
            // Shadow
            rl.DrawEllipse(ax, ay+7, 7, 3, COL_SHADOW)
            tail_curl := i32(math.sin(a.anim_time*0.8)*2)
            rl.DrawRectangle(ax + 4, ay-8+tail_curl, 5, 10, COL_SQ_TAIL)
            rl.DrawRectangle(ax + 5, ay-14+tail_curl,4, 7,  COL_SQ_TAIL)
            rl.DrawCircle(ax + 7, ay-14+tail_curl, 4, COL_SQ_TAIL)
            // Body
            rl.DrawRectangle(ax-5, ay-6, 9, 9, COL_SQ_BODY)
            // Belly
            rl.DrawRectangle(ax-3, ay-4, 5, 6, COL_SQ_BELLY)
            // Head
            rl.DrawRectangle(ax-4, ay-13, 8, 8, COL_SQ_BODY)
            // Ears
            rl.DrawRectangle(ax - 3, ay-17, 2, 4, COL_SQ_BODY)
            rl.DrawRectangle(ax + 1, ay-16, 2, 3, COL_SQ_BODY)
            // Eye
            rl.DrawRectangle(ax - 1, ay-11, 2, 2, COL_SQ_EYE)
            // Cheek pouch
            rl.DrawRectangle(ax - 5, ay-10, 3, 3, COL_SQ_BELLY)
            // Legs
            rl.DrawRectangle(ax - 4, ay+2+leg_bob, 3, 4, COL_SQ_BODY)
            rl.DrawRectangle(ax - 1, ay+2-leg_bob, 3, 4, COL_SQ_BODY)

        case .Frog:
            COL_FR_BODY :: rl.Color{ 60, 160,  60, 255}
            COL_FR_BELLY:: rl.Color{140, 210, 100, 255}
            COL_FR_EYE  :: rl.Color{240, 200,  20, 255}
            COL_FR_PUPIL:: rl.Color{ 10,  10,  10, 255}
            // Shadow
            rl.DrawEllipse(ax, ay+6, 9, 3, COL_SHADOW)
            // Frog hops 
            hop := i32(0)
            if !a.is_idle { hop = i32(math.abs(math.sin(a.anim_time*0.8))*-4) }
            // Back legs (wide)
            rl.DrawRectangle(ax-10, ay+3+hop, 5, 4, COL_FR_BODY)
            rl.DrawRectangle(ax+5,  ay+3+hop, 5, 4, COL_FR_BODY)
            // Body (wide and flat)
            rl.DrawRectangle(ax-7, ay-4+hop, 14, 9, COL_FR_BODY)
            // Belly
            rl.DrawRectangle(ax-5, ay-2+hop, 10, 6, COL_FR_BELLY)
            // Head (same width as body)
            rl.DrawRectangle(ax-7, ay-11+hop, 14, 8, COL_FR_BODY)
            // Mouth line
            rl.DrawRectangle(ax-5, ay-5+hop, 10, 1, COL_FR_BELLY)
            // Eyes on top of head (bulging)
            rl.DrawCircle(ax-4, ay-12+hop, 4, COL_FR_BODY)
            rl.DrawCircle(ax+4, ay-12+hop, 4, COL_FR_BODY)
            rl.DrawCircle(ax-4, ay-12+hop, 3, COL_FR_EYE)
            rl.DrawCircle(ax+4, ay-12+hop, 3, COL_FR_EYE)
            rl.DrawCircle(ax-4, ay-12+hop, 1, COL_FR_PUPIL)
            rl.DrawCircle(ax+4, ay-12+hop, 1, COL_FR_PUPIL)

        case .Butterfly:
            // Wings flap using anim_time
            flap := math.sin(a.anim_time * 4.0)
            wing_open := i32(flap * 8)

            // Pick a pretty wing color per-instance using index
            wing_col  := rl.Color{200,  80, 200, 200}
            wing_col2 := rl.Color{240, 160, 240, 160}
            if i % 3 == 1 {
                wing_col  = rl.Color{ 80, 160, 220, 200}
                wing_col2 = rl.Color{140, 210, 255, 160}
            } else if i % 3 == 2 {
                wing_col  = rl.Color{240, 180,  40, 200}
                wing_col2 = rl.Color{255, 220, 120, 160}
            }

            // Shadow (faint, butterfly is airborne)
            rl.DrawEllipse(ax, ay+10, 6, 2, rl.Color{0,0,0,30})

            // Upper wings
            rl.DrawRectangle(ax-8-wing_open, ay-10, 8+wing_open, 8, wing_col)
            rl.DrawRectangle(ax,             ay-10, 8+wing_open, 8, wing_col)
            // Lower wings (smaller)
            rl.DrawRectangle(ax-6-wing_open, ay-3,  6+wing_open, 6, wing_col2)
            rl.DrawRectangle(ax,             ay-3,  6+wing_open, 6, wing_col2)
            // Wing highlight
            rl.DrawRectangle(ax-7-wing_open, ay-9,  2, 5, rl.Color{255,255,255,80})
            // Body (thin)
            rl.DrawRectangle(ax-1, ay-12, 2, 14, rl.Color{30,20,10,255})
            // Antennae
            rl.DrawRectangle(ax-3, ay-16, 1, 5, rl.Color{30,20,10,200})
            rl.DrawRectangle(ax+2, ay-16, 1, 5, rl.Color{30,20,10,200})
            rl.DrawCircle(ax-3, ay-16, 1, rl.Color{30,20,10,255})
            rl.DrawCircle(ax+2, ay-16, 1, rl.Color{30,20,10,255})
        }
    }
}
draw_animal_icon :: proc(kind: AnimalType, cx, cy: f32, idx: int = 0, animate: bool = true) {
    ax := i32(cx)
    ay := i32(cy)

    t := animate ? f32(rl.GetTime()) : 0.0
    leg_bob := i32(0)
    if animate { leg_bob = i32(math.sin(t) * 1.5) }

    switch kind {

    case .Rabbit:
        COL_R_BODY :: rl.Color{220, 210, 200, 255}
        COL_R_EAR  :: rl.Color{200, 160, 160, 255}
        COL_R_EYE  :: rl.Color{ 40,  20,  20, 255}
        COL_R_NOSE :: rl.Color{220, 120, 120, 255}
        rl.DrawEllipse(ax, ay+7, 8, 3, COL_SHADOW)
        ear_twitch := animate ? i32(math.sin(t*2)*1.5) : 0
        rl.DrawRectangle(ax + 3, ay-16+ear_twitch, 3, 8, COL_R_BODY)
        rl.DrawRectangle(ax - 3, ay-15+ear_twitch, 1, 6, COL_R_EAR)
        rl.DrawRectangle(ax + 2, ay-15, 3, 8, COL_R_BODY)
        rl.DrawRectangle(ax + 2, ay-14, 1, 6, COL_R_EAR)
        rl.DrawRectangle(ax-5, ay-7, 10, 9, COL_R_BODY)
        rl.DrawRectangle(ax-4, ay-12, 8, 7, COL_R_BODY)
        rl.DrawRectangle(ax - 1, ay-10, 2, 2, COL_R_EYE)
        rl.DrawRectangle(ax + 2, ay-8,  2, 1, COL_R_NOSE)
        rl.DrawRectangle(ax - 4, ay+1+leg_bob, 3, 4, COL_R_BODY)
        rl.DrawRectangle(ax + 1, ay+1-leg_bob, 3, 4, COL_R_BODY)
        rl.DrawCircle(ax + 5, ay-2, 3, COL_R_BODY)

    case .Fox:
        COL_F_BODY :: rl.Color{210,  90,  30, 255}
        COL_F_BELLY:: rl.Color{240, 200, 160, 255}
        COL_F_EAR  :: rl.Color{180,  50,  20, 255}
        COL_F_EYE  :: rl.Color{ 30,  20,  10, 255}
        COL_F_TAIL :: rl.Color{240, 240, 240, 255}
        rl.DrawEllipse(ax, ay+8, 10, 3, COL_SHADOW)
        tail_wag := animate ? i32(math.sin(t*1.5)*3) : 0
        rl.DrawRectangle(ax + 6, ay-2+tail_wag, 6, 4, COL_F_BODY)
        rl.DrawCircle(ax + 11, ay-1+tail_wag, 4, COL_F_TAIL)
        rl.DrawRectangle(ax-6, ay-5, 12, 9, COL_F_BODY)
        rl.DrawRectangle(ax-3, ay-3, 6, 6, COL_F_BELLY)
        rl.DrawRectangle(ax-5, ay-12, 10, 8, COL_F_BODY)
        rl.DrawRectangle(ax - 7, ay-9, 4, 4, COL_F_BELLY)
        rl.DrawRectangle(ax - 4, ay-18, 3, 6, COL_F_BODY)
        rl.DrawRectangle(ax - 3, ay-17, 1, 4, COL_F_EAR)
        rl.DrawRectangle(ax + 1, ay-17, 3, 5, COL_F_BODY)
        rl.DrawRectangle(ax + 2, ay-16, 1, 3, COL_F_EAR)
        rl.DrawRectangle(ax - 3, ay-10, 2, 2, COL_F_EYE)
        rl.DrawRectangle(ax - 5, ay+3+leg_bob, 3, 5, COL_F_BODY)
        rl.DrawRectangle(ax + 2, ay+3-leg_bob, 3, 5, COL_F_BODY)

    case .Deer:
        COL_D_BODY  :: rl.Color{180, 120,  60, 255}
        COL_D_BELLY :: rl.Color{220, 190, 150, 255}
        COL_D_EYE   :: rl.Color{ 30,  20,  10, 255}
        COL_D_ANTLER:: rl.Color{140,  90,  40, 255}
        COL_D_NOSE  :: rl.Color{ 60,  30,  20, 255}
        rl.DrawEllipse(ax, ay+12, 12, 4, COL_SHADOW)
        rl.DrawRectangle(ax - 6, ay+6+leg_bob,  3, 8, COL_D_BODY)
        rl.DrawRectangle(ax - 2, ay+6-leg_bob,  3, 8, COL_D_BODY)
        rl.DrawRectangle(ax + 2, ay+6+leg_bob,  3, 8, COL_D_BODY)
        rl.DrawRectangle(ax + 5, ay+6-leg_bob,  3, 8, COL_D_BODY)
        rl.DrawRectangle(ax-8, ay-6, 16, 13, COL_D_BODY)
        rl.DrawRectangle(ax-5, ay-2, 10, 7, COL_D_BELLY)
        rl.DrawRectangle(ax - 4, ay-14, 5, 9, COL_D_BODY)
        rl.DrawRectangle(ax-5, ay-20, 10, 8, COL_D_BODY)
        rl.DrawRectangle(ax - 7, ay-17, 4, 4, COL_D_BELLY)
        rl.DrawRectangle(ax - 7, ay-15, 3, 2, COL_D_NOSE)
        rl.DrawRectangle(ax - 1, ay-18, 2, 2, COL_D_EYE)
        rl.DrawRectangle(ax - 3, ay-26, 2, 7, COL_D_ANTLER)
        rl.DrawRectangle(ax - 5, ay-26, 4, 2, COL_D_ANTLER)
        rl.DrawRectangle(ax + 1, ay-24, 2, 5, COL_D_ANTLER)
        rl.DrawRectangle(ax + 1, ay-24, 4, 2, COL_D_ANTLER)
        rl.DrawRectangle(ax + 3, ay-22, 4, 3, COL_D_BODY)
        rl.DrawRectangle(ax - 7, ay-22, 4, 3, COL_D_BODY)

    case .Squirrel:
        COL_SQ_BODY :: rl.Color{160, 100,  40, 255}
        COL_SQ_BELLY:: rl.Color{230, 200, 160, 255}
        COL_SQ_EYE  :: rl.Color{ 20,  10,   5, 255}
        COL_SQ_TAIL :: rl.Color{180, 120,  50, 255}
        rl.DrawEllipse(ax, ay+7, 7, 3, COL_SHADOW)
        tail_curl := animate ? i32(math.sin(t*0.8)*2) : 0
        rl.DrawRectangle(ax + 4, ay-8+tail_curl, 5, 10, COL_SQ_TAIL)
        rl.DrawRectangle(ax + 5, ay-14+tail_curl,4, 7,  COL_SQ_TAIL)
        rl.DrawCircle(ax + 7, ay-14+tail_curl, 4, COL_SQ_TAIL)
        rl.DrawRectangle(ax-5, ay-6, 9, 9, COL_SQ_BODY)
        rl.DrawRectangle(ax-3, ay-4, 5, 6, COL_SQ_BELLY)
        rl.DrawRectangle(ax-4, ay-13, 8, 8, COL_SQ_BODY)
        rl.DrawRectangle(ax - 3, ay-17, 2, 4, COL_SQ_BODY)
        rl.DrawRectangle(ax + 1, ay-16, 2, 3, COL_SQ_BODY)
        rl.DrawRectangle(ax - 1, ay-11, 2, 2, COL_SQ_EYE)
        rl.DrawRectangle(ax - 5, ay-10, 3, 3, COL_SQ_BELLY)
        rl.DrawRectangle(ax - 4, ay+2+leg_bob, 3, 4, COL_SQ_BODY)
        rl.DrawRectangle(ax - 1, ay+2-leg_bob, 3, 4, COL_SQ_BODY)

    case .Frog:
        COL_FR_BODY :: rl.Color{ 60, 160,  60, 255}
        COL_FR_BELLY:: rl.Color{140, 210, 100, 255}
        COL_FR_EYE  :: rl.Color{240, 200,  20, 255}
        COL_FR_PUPIL:: rl.Color{ 10,  10,  10, 255}
        rl.DrawEllipse(ax, ay+6, 9, 3, COL_SHADOW)
        hop := animate ? i32(math.abs(math.sin(t*0.8))*-4) : 0
        rl.DrawRectangle(ax-10, ay+3+hop, 5, 4, COL_FR_BODY)
        rl.DrawRectangle(ax+5,  ay+3+hop, 5, 4, COL_FR_BODY)
        rl.DrawRectangle(ax-7, ay-4+hop, 14, 9, COL_FR_BODY)
        rl.DrawRectangle(ax-5, ay-2+hop, 10, 6, COL_FR_BELLY)
        rl.DrawRectangle(ax-7, ay-11+hop, 14, 8, COL_FR_BODY)
        rl.DrawRectangle(ax-5, ay-5+hop, 10, 1, COL_FR_BELLY)
        rl.DrawCircle(ax-4, ay-12+hop, 4, COL_FR_BODY)
        rl.DrawCircle(ax+4, ay-12+hop, 4, COL_FR_BODY)
        rl.DrawCircle(ax-4, ay-12+hop, 3, COL_FR_EYE)
        rl.DrawCircle(ax+4, ay-12+hop, 3, COL_FR_EYE)
        rl.DrawCircle(ax-4, ay-12+hop, 1, COL_FR_PUPIL)
        rl.DrawCircle(ax+4, ay-12+hop, 1, COL_FR_PUPIL)

    case .Butterfly:
        flap := animate ? math.sin(t * 4.0) : 0.6
        wing_open := i32(flap * 8)
        wing_col  := rl.Color{200,  80, 200, 200}
        wing_col2 := rl.Color{240, 160, 240, 160}
        if idx % 3 == 1 {
            wing_col  = rl.Color{ 80, 160, 220, 200}
            wing_col2 = rl.Color{140, 210, 255, 160}
        } else if idx % 3 == 2 {
            wing_col  = rl.Color{240, 180,  40, 200}
            wing_col2 = rl.Color{255, 220, 120, 160}
        }
        rl.DrawEllipse(ax, ay+10, 6, 2, rl.Color{0,0,0,30})
        rl.DrawRectangle(ax-8-wing_open, ay-10, 8+wing_open, 8, wing_col)
        rl.DrawRectangle(ax,             ay-10, 8+wing_open, 8, wing_col)
        rl.DrawRectangle(ax-6-wing_open, ay-3,  6+wing_open, 6, wing_col2)
        rl.DrawRectangle(ax,             ay-3,  6+wing_open, 6, wing_col2)
        rl.DrawRectangle(ax-7-wing_open, ay-9,  2, 5, rl.Color{255,255,255,80})
        rl.DrawRectangle(ax-1, ay-12, 2, 14, rl.Color{30,20,10,255})
        rl.DrawRectangle(ax-3, ay-16, 1, 5, rl.Color{30,20,10,200})
        rl.DrawRectangle(ax+2, ay-16, 1, 5, rl.Color{30,20,10,200})
        rl.DrawCircle(ax-3, ay-16, 1, rl.Color{30,20,10,255})
        rl.DrawCircle(ax+2, ay-16, 1, rl.Color{30,20,10,255})
    }
}
draw_fish_icon :: proc(kind: FishType, cx, cy: f32, flip: bool = false, animate: bool = true, alpha: u8 = 255) {
    fx := i32(cx)
    fy := i32(cy)

    t := animate ? f32(rl.GetTime()) : 0.0
    tail_wag := animate ? i32(math.sin(t*3.0)*1.5) : 0

    fxo :: proc(base: i32, off: i32, flip: bool) -> i32 {
        return base - off if flip else base + off
    }

    switch kind {

    case .Bass:
        COL_BASS_BODY  :: rl.Color{ 60, 100,  70, 255}
        COL_BASS_BELLY :: rl.Color{140, 180, 140, 255}
        COL_BASS_FIN   :: rl.Color{ 40,  80,  55, 255}
        body  := rl.Color{COL_BASS_BODY.r,  COL_BASS_BODY.g,  COL_BASS_BODY.b,  alpha}
        belly := rl.Color{COL_BASS_BELLY.r, COL_BASS_BELLY.g, COL_BASS_BELLY.b, alpha}
        fin   := rl.Color{COL_BASS_FIN.r,   COL_BASS_FIN.g,   COL_BASS_FIN.b,   alpha}
        // Tail
        rl.DrawRectangle(fxo(fx, 9, flip), fy-2+tail_wag, 5, 2, fin)
        rl.DrawRectangle(fxo(fx, 9, flip), fy+1+tail_wag, 5, 2, fin)
        // Body
        rl.DrawRectangle(fx-6, fy-3, 14, 7, body)
        // Belly stripe
        rl.DrawRectangle(fx-5, fy,   12, 3, belly)
        // Dorsal fin
        rl.DrawRectangle(fx-3, fy-6, 6, 3, fin)
        // Eye
        rl.DrawRectangle(fxo(fx,-4,flip), fy-2, 2, 2, rl.Color{220,220,180,alpha})
        rl.DrawRectangle(fxo(fx,-4,flip), fy-2, 1, 1, rl.Color{10,10,10,alpha})

    case .Trout:
        COL_TR_BODY  :: rl.Color{160, 180, 190, 255}
        COL_TR_PINK  :: rl.Color{200, 120, 140, 255}
        COL_TR_SPOT  :: rl.Color{100, 120, 130, 255}
        body := rl.Color{COL_TR_BODY.r, COL_TR_BODY.g, COL_TR_BODY.b, alpha}
        pink := rl.Color{COL_TR_PINK.r, COL_TR_PINK.g, COL_TR_PINK.b, alpha}
        spot := rl.Color{COL_TR_SPOT.r, COL_TR_SPOT.g, COL_TR_SPOT.b, alpha}
        // Tail (forked)
        rl.DrawRectangle(fxo(fx, 8, flip), fy-3+tail_wag, 4, 2, body)
        rl.DrawRectangle(fxo(fx, 8, flip), fy+2+tail_wag, 4, 2, body)
        // Body (slim)
        rl.DrawRectangle(fx-7, fy-2, 15, 5, body)
        // Pink lateral stripe
        rl.DrawRectangle(fx-6, fy,    13, 2, pink)
        // Spots (3 dots)
        rl.DrawRectangle(fx-4, fy-2, 2, 2, spot)
        rl.DrawRectangle(fx,   fy-2, 2, 2, spot)
        rl.DrawRectangle(fx+3, fy-1, 2, 2, spot)
        // Eye
        rl.DrawRectangle(fxo(fx,-5,flip), fy-1, 2, 2, rl.Color{220,220,180,alpha})

    case .Catfish:
        COL_CAT_BODY :: rl.Color{ 80,  60,  40, 255}
        COL_CAT_BELLY:: rl.Color{150, 120,  80, 255}
        body  := rl.Color{COL_CAT_BODY.r,  COL_CAT_BODY.g,  COL_CAT_BODY.b,  alpha}
        belly := rl.Color{COL_CAT_BELLY.r, COL_CAT_BELLY.g, COL_CAT_BELLY.b, alpha}
        wht   := rl.Color{220, 210, 190, alpha}
        // Tail (wide fan)
        rl.DrawRectangle(fxo(fx, 9, flip), fy-4+tail_wag, 5, 3, body)
        rl.DrawRectangle(fxo(fx, 9, flip), fy+2+tail_wag, 5, 3, body)
        // Body (wide)
        rl.DrawRectangle(fx-7, fy-4, 16, 9, body)
        // Belly
        rl.DrawRectangle(fx-5, fy,   12, 4, belly)
        // Whiskers (barbels)
        rl.DrawRectangle(fxo(fx,-8,flip), fy-3, 4, 1, wht)
        rl.DrawRectangle(fxo(fx,-8,flip), fy-1, 4, 1, wht)
        rl.DrawRectangle(fxo(fx,-8,flip), fy+1, 4, 1, wht)
        // Eye
        rl.DrawRectangle(fxo(fx,-4,flip), fy-2, 2, 2, rl.Color{180,160,100,alpha})

    case .Goldfish:
        COL_GF_BODY :: rl.Color{240, 130,  20, 255}
        COL_GF_TAIL :: rl.Color{220,  80,  10, 255}
        COL_GF_FIN  :: rl.Color{255, 160,  40, 255}
        body := rl.Color{COL_GF_BODY.r, COL_GF_BODY.g, COL_GF_BODY.b, alpha}
        tail := rl.Color{COL_GF_TAIL.r, COL_GF_TAIL.g, COL_GF_TAIL.b, alpha}
        fin  := rl.Color{COL_GF_FIN.r,  COL_GF_FIN.g,  COL_GF_FIN.b,  alpha}
        // Fancy forked tail (wider)
        rl.DrawRectangle(fxo(fx, 7, flip), fy-4+tail_wag, 5, 3, tail)
        rl.DrawRectangle(fxo(fx, 7, flip), fy+2+tail_wag, 5, 3, tail)
        rl.DrawRectangle(fxo(fx, 9, flip), fy-5+tail_wag, 3, 2, tail)
        rl.DrawRectangle(fxo(fx, 9, flip), fy+4+tail_wag, 3, 2, tail)
        // Body (round)
        rl.DrawRectangle(fx-5, fy-4, 12, 9, body)
        // Dorsal fin
        rl.DrawRectangle(fx-2, fy-7, 5, 4, fin)
        // Pectoral fin
        rl.DrawRectangle(fxo(fx,-1,flip), fy+2, 4, 3, fin)
        // Eye (big, goldfish-style)
        rl.DrawCircle(fxo(fx,-3,flip), fy-1, 2, rl.Color{240,230,180,alpha})
        rl.DrawCircle(fxo(fx,-3,flip), fy-1, 1, rl.Color{10,10,10,alpha})

    case .Pike:
        COL_PK_BODY :: rl.Color{ 80, 120,  50, 255}
        COL_PK_STRIPE:: rl.Color{120, 160,  70, 255}
        COL_PK_BELLY:: rl.Color{200, 210, 170, 255}
        body   := rl.Color{COL_PK_BODY.r,   COL_PK_BODY.g,   COL_PK_BODY.b,   alpha}
        stripe := rl.Color{COL_PK_STRIPE.r, COL_PK_STRIPE.g, COL_PK_STRIPE.b, alpha}
        belly  := rl.Color{COL_PK_BELLY.r,  COL_PK_BELLY.g,  COL_PK_BELLY.b,  alpha}
        // Tail
        rl.DrawRectangle(fxo(fx,12,flip), fy-2+tail_wag, 5, 2, body)
        rl.DrawRectangle(fxo(fx,12,flip), fy+1+tail_wag, 5, 2, body)
        // Long body
        rl.DrawRectangle(fx-9, fy-2, 21, 5, body)
        // Belly
        rl.DrawRectangle(fx-8, fy+1, 19, 2, belly)
        // Camouflage stripes
        for si in 0..<4 {
            rl.DrawRectangle(fx-6+i32(si)*4, fy-2, 2, 5, stripe)
        }
        // Pointed snout
        rl.DrawRectangle(fxo(fx,-10,flip), fy-1, 3, 3, body)
        // Eye
        rl.DrawRectangle(fxo(fx,-6,flip), fy-1, 2, 2, rl.Color{220,200,100,alpha})

    case .Perch:
        COL_PE_BODY :: rl.Color{100, 140,  60, 255}
        COL_PE_STRIPE:: rl.Color{ 50,  80,  30, 255}
        COL_PE_FIN  :: rl.Color{200,  90,  30, 255}
        body   := rl.Color{COL_PE_BODY.r,   COL_PE_BODY.g,   COL_PE_BODY.b,   alpha}
        stripe := rl.Color{COL_PE_STRIPE.r, COL_PE_STRIPE.g, COL_PE_STRIPE.b, alpha}
        fin    := rl.Color{COL_PE_FIN.r,    COL_PE_FIN.g,    COL_PE_FIN.b,    alpha}
        // Tail
        rl.DrawRectangle(fxo(fx, 8, flip), fy-3+tail_wag, 4, 2, fin)
        rl.DrawRectangle(fxo(fx, 8, flip), fy+2+tail_wag, 4, 2, fin)
        // Body
        rl.DrawRectangle(fx-6, fy-3, 14, 7, body)
        // Vertical dark stripes (perch pattern)
        for si in 0..<4 {
            rl.DrawRectangle(fx-4+i32(si)*3, fy-3, 1, 7, stripe)
        }
        // Spiny dorsal fin (orange)
        rl.DrawRectangle(fx-3, fy-6, 7, 3, fin)
        // Pectoral fin
        rl.DrawRectangle(fxo(fx,-2,flip), fy+2, 4, 3, fin)
        // Eye
        rl.DrawRectangle(fxo(fx,-4,flip), fy-2, 2, 2, rl.Color{220,210,160,alpha})
    }
}

draw_bird :: proc(pos: Vec2, col: rl.Color, anim_time: f32, is_idle: bool) {
    x := pxi(pos.x); y := pxi(pos.y)
    COL_BIRD_BELLY :: rl.Color{250, 245, 225, 255}
    COL_BIRD_EYE   :: rl.Color{ 20,  20,  20, 255}
    COL_BIRD_BEAK  :: rl.Color{240, 160,  40, 255}

    wing_flap := i32(0)
    if !is_idle { wing_flap = i32(math.sin(anim_time * 10.0) * 2) }

    rl.DrawEllipse(x, y+7, 5, 2, COL_SHADOW)              // shadow
    rl.DrawRectangle(x-7, y-2, 3, 2, col)                 // tail
    rl.DrawRectangle(x-5, y-5, 10, 7, col)                // body
    rl.DrawRectangle(x-3, y-2, 6, 4, COL_BIRD_BELLY)      // belly
    rl.DrawRectangle(x-2, y-4+wing_flap, 5, 3, col)        // wing
    rl.DrawRectangle(x+3, y-9, 6, 6, col)                 // head
    rl.DrawRectangle(x+6, y-7, 1, 1, COL_BIRD_EYE)         // eye
    rl.DrawRectangle(x+9, y-6, 2, 2, COL_BIRD_BEAK)        // beak

    if is_idle {
        rl.DrawRectangle(x-1, y+2, 1, 2, COL_BIRD_BEAK)
        rl.DrawRectangle(x+1, y+2, 1, 2, COL_BIRD_BEAK)
    }
}

draw_pond :: proc() {
    p  := &g.pond
    px := POND_X
    py := POND_Y
    pw := POND_W
    ph := POND_H

    rl.DrawRectangle(pxi(px)+4, pxi(py)+4, pxi(pw), pxi(ph),
        rl.Color{0, 0, 0, 70})
    COL_STONE       :: rl.Color{ 90,  85,  78, 255}
    COL_STONE_LIGHT :: rl.Color{130, 122, 108, 255}
    COL_STONE_DARK  :: rl.Color{ 55,  50,  44, 255}
    rl.DrawRectangle(pxi(px), pxi(py), pxi(pw), pxi(ph), COL_STONE)
    rl.DrawRectangle(pxi(px), pxi(py), pxi(pw), 4, COL_STONE_LIGHT)
    rl.DrawRectangle(pxi(px), pxi(py), 4, pxi(ph), COL_STONE_LIGHT)
    rl.DrawRectangle(pxi(px + pw) - 4, pxi(py), 4, pxi(ph), COL_STONE_DARK)
    rl.DrawRectangle(pxi(px), pxi(py + ph) - 4, pxi(pw), 4, COL_STONE_DARK)

    border :: f32(8)
    wx := px + border; wy := py + border
    ww := pw - border*2; wh := ph - border*2

    rl.DrawRectangle(pxi(wx), pxi(wy), pxi(ww), pxi(wh), COL_WATER)

    for row in 0..<12 {
        sy := wy + f32(row) * (wh / 12)
        wave_offset := math.sin(p.wave_time * 1.4 + f32(row) * 0.7) * 6
        stripe_alpha := u8(18 + u8(math.abs(math.sin(p.wave_time + f32(row)*0.5)) * 22))
        rl.DrawRectangle(
            pxi(wx + wave_offset), pxi(sy),
            pxi(ww - 12), 3,
            rl.Color{160, 210, 240, stripe_alpha},
        )
    }

    for ri in 0..<5 {
        rphase := p.ripple_time * 1.1 + f32(ri) * 1.26
        rr     := (math.mod(rphase, 3.0) / 3.0) * 22  // grows 0→22
        ralpha := u8((1.0 - math.mod(rphase, 3.0)/3.0) * 60)
	rcx_offsets := []f32{0.2, 0.5, 0.75, 0.35, 0.62}
	rcy_offsets := []f32{0.3, 0.6, 0.25, 0.7, 0.5}
	rcx := wx + ww * rcx_offsets[ri]
	rcy := wy + wh * rcy_offsets[ri]
        rl.DrawCircleLines(pxi(rcx), pxi(rcy), rr, rl.Color{200, 230, 255, ralpha})
    }

    for i in 0..<POND_FISH_COUNT {
        f  := &p.fish[i]
        fx := pxi(f.pos.x)
        fy := pxi(f.pos.y)

        alpha := u8((1.0 - f.depth * 0.75) * 255)

        // Tail wag offset
        tail_wag := i32(math.sin_f32(f.anim_time) * 2.5)

        // Flip helper
        fxo :: proc(base: i32, off: i32, flip: bool) -> i32 {
            return base - off if flip else base + off
        }

        switch f.kind {

        case .Bass:
            COL_BASS_BODY  :: rl.Color{ 60, 100,  70, 255}
            COL_BASS_BELLY :: rl.Color{140, 180, 140, 255}
            COL_BASS_FIN   :: rl.Color{ 40,  80,  55, 255}
            body  := rl.Color{COL_BASS_BODY.r,  COL_BASS_BODY.g,  COL_BASS_BODY.b,  alpha}
            belly := rl.Color{COL_BASS_BELLY.r, COL_BASS_BELLY.g, COL_BASS_BELLY.b, alpha}
            fin   := rl.Color{COL_BASS_FIN.r,   COL_BASS_FIN.g,   COL_BASS_FIN.b,   alpha}
            // Tail
            rl.DrawRectangle(fxo(fx, 9, f.flip), fy-2+tail_wag, 5, 2, fin)
            rl.DrawRectangle(fxo(fx, 9, f.flip), fy+1+tail_wag, 5, 2, fin)
            // Body
            rl.DrawRectangle(fx-6, fy-3, 14, 7, body)
            // Belly stripe
            rl.DrawRectangle(fx-5, fy,   12, 3, belly)
            // Dorsal fin
            rl.DrawRectangle(fx-3, fy-6, 6, 3, fin)
            // Eye
            rl.DrawRectangle(fxo(fx,-4,f.flip), fy-2, 2, 2, rl.Color{220,220,180,alpha})
            rl.DrawRectangle(fxo(fx,-4,f.flip), fy-2, 1, 1, rl.Color{10,10,10,alpha})

        case .Trout:
            COL_TR_BODY  :: rl.Color{160, 180, 190, 255}
            COL_TR_PINK  :: rl.Color{200, 120, 140, 255}
            COL_TR_SPOT  :: rl.Color{100, 120, 130, 255}
            body := rl.Color{COL_TR_BODY.r, COL_TR_BODY.g, COL_TR_BODY.b, alpha}
            pink := rl.Color{COL_TR_PINK.r, COL_TR_PINK.g, COL_TR_PINK.b, alpha}
            spot := rl.Color{COL_TR_SPOT.r, COL_TR_SPOT.g, COL_TR_SPOT.b, alpha}
            // Tail (forked)
            rl.DrawRectangle(fxo(fx, 8, f.flip), fy-3+tail_wag, 4, 2, body)
            rl.DrawRectangle(fxo(fx, 8, f.flip), fy+2+tail_wag, 4, 2, body)
            // Body (slim)
            rl.DrawRectangle(fx-7, fy-2, 15, 5, body)
            // Pink lateral stripe
            rl.DrawRectangle(fx-6, fy,    13, 2, pink)
            // Spots (3 dots)
            rl.DrawRectangle(fx-4, fy-2, 2, 2, spot)
            rl.DrawRectangle(fx,   fy-2, 2, 2, spot)
            rl.DrawRectangle(fx+3, fy-1, 2, 2, spot)
            // Eye
            rl.DrawRectangle(fxo(fx,-5,f.flip), fy-1, 2, 2, rl.Color{220,220,180,alpha})

        case .Catfish:
            COL_CAT_BODY :: rl.Color{ 80,  60,  40, 255}
            COL_CAT_BELLY:: rl.Color{150, 120,  80, 255}
            body  := rl.Color{COL_CAT_BODY.r,  COL_CAT_BODY.g,  COL_CAT_BODY.b,  alpha}
            belly := rl.Color{COL_CAT_BELLY.r, COL_CAT_BELLY.g, COL_CAT_BELLY.b, alpha}
            wht   := rl.Color{220, 210, 190, alpha}
            // Tail (wide fan)
            rl.DrawRectangle(fxo(fx, 9, f.flip), fy-4+tail_wag, 5, 3, body)
            rl.DrawRectangle(fxo(fx, 9, f.flip), fy+2+tail_wag, 5, 3, body)
            // Body (wide)
            rl.DrawRectangle(fx-7, fy-4, 16, 9, body)
            // Belly
            rl.DrawRectangle(fx-5, fy,   12, 4, belly)
            // Whiskers (barbels)
            rl.DrawRectangle(fxo(fx,-8,f.flip), fy-3, 4, 1, wht)
            rl.DrawRectangle(fxo(fx,-8,f.flip), fy-1, 4, 1, wht)
            rl.DrawRectangle(fxo(fx,-8,f.flip), fy+1, 4, 1, wht)
            // Eye
            rl.DrawRectangle(fxo(fx,-4,f.flip), fy-2, 2, 2, rl.Color{180,160,100,alpha})

        case .Goldfish:
            COL_GF_BODY :: rl.Color{240, 130,  20, 255}
            COL_GF_TAIL :: rl.Color{220,  80,  10, 255}
            COL_GF_FIN  :: rl.Color{255, 160,  40, 255}
            body := rl.Color{COL_GF_BODY.r, COL_GF_BODY.g, COL_GF_BODY.b, alpha}
            tail := rl.Color{COL_GF_TAIL.r, COL_GF_TAIL.g, COL_GF_TAIL.b, alpha}
            fin  := rl.Color{COL_GF_FIN.r,  COL_GF_FIN.g,  COL_GF_FIN.b,  alpha}
            // Fancy forked tail (wider)
            rl.DrawRectangle(fxo(fx, 7, f.flip), fy-4+tail_wag, 5, 3, tail)
            rl.DrawRectangle(fxo(fx, 7, f.flip), fy+2+tail_wag, 5, 3, tail)
            rl.DrawRectangle(fxo(fx, 9, f.flip), fy-5+tail_wag, 3, 2, tail)
            rl.DrawRectangle(fxo(fx, 9, f.flip), fy+4+tail_wag, 3, 2, tail)
            // Body (round)
            rl.DrawRectangle(fx-5, fy-4, 12, 9, body)
            // Dorsal fin
            rl.DrawRectangle(fx-2, fy-7, 5, 4, fin)
            // Pectoral fin
            rl.DrawRectangle(fxo(fx,-1,f.flip), fy+2, 4, 3, fin)
            // Eye (big, goldfish-style)
            rl.DrawCircle(fxo(fx,-3,f.flip), fy-1, 2, rl.Color{240,230,180,alpha})
            rl.DrawCircle(fxo(fx,-3,f.flip), fy-1, 1, rl.Color{10,10,10,alpha})

        case .Pike:
            COL_PK_BODY :: rl.Color{ 80, 120,  50, 255}
            COL_PK_STRIPE::rl.Color{120, 160,  70, 255}
            COL_PK_BELLY:: rl.Color{200, 210, 170, 255}
            body   := rl.Color{COL_PK_BODY.r,   COL_PK_BODY.g,   COL_PK_BODY.b,   alpha}
            stripe := rl.Color{COL_PK_STRIPE.r,  COL_PK_STRIPE.g, COL_PK_STRIPE.b, alpha}
            belly  := rl.Color{COL_PK_BELLY.r,   COL_PK_BELLY.g,  COL_PK_BELLY.b,  alpha}
            rl.DrawRectangle(fxo(fx,12,f.flip), fy-2+tail_wag, 5, 2, body)
            rl.DrawRectangle(fxo(fx,12,f.flip), fy+1+tail_wag, 5, 2, body)
            rl.DrawRectangle(fx-9, fy-2, 21, 5, body)
            rl.DrawRectangle(fx-8, fy+1, 19, 2, belly)
            for si in 0..<4 {
                rl.DrawRectangle(fx-6+i32(si)*4, fy-2, 2, 5, stripe)
            }
            rl.DrawRectangle(fxo(fx,-10,f.flip), fy-1, 3, 3, body)
            rl.DrawRectangle(fxo(fx,-6,f.flip), fy-1, 2, 2, rl.Color{220,200,100,alpha})

        case .Perch:
            COL_PE_BODY :: rl.Color{100, 140,  60, 255}
            COL_PE_STRIPE::rl.Color{ 50,  80,  30, 255}
            COL_PE_FIN  :: rl.Color{200,  90,  30, 255}
            body   := rl.Color{COL_PE_BODY.r,   COL_PE_BODY.g,   COL_PE_BODY.b,   alpha}
            stripe := rl.Color{COL_PE_STRIPE.r,  COL_PE_STRIPE.g, COL_PE_STRIPE.b, alpha}
            fin    := rl.Color{COL_PE_FIN.r,     COL_PE_FIN.g,    COL_PE_FIN.b,    alpha}
            rl.DrawRectangle(fxo(fx, 8, f.flip), fy-3+tail_wag, 4, 2, fin)
            rl.DrawRectangle(fxo(fx, 8, f.flip), fy+2+tail_wag, 4, 2, fin)
            rl.DrawRectangle(fx-6, fy-3, 14, 7, body)
            for si in 0..<4 {
                rl.DrawRectangle(fx-4+i32(si)*3, fy-3, 1, 7, stripe)
            }
            rl.DrawRectangle(fx-3, fy-6, 7, 3, fin)
            rl.DrawRectangle(fxo(fx,-2,f.flip), fy+2, 4, 3, fin)
            rl.DrawRectangle(fxo(fx,-4,f.flip), fy-2, 2, 2, rl.Color{220,210,160,alpha})

	}
    }

    COL_DOCK       :: rl.Color{139, 100,  55, 255}
    COL_DOCK_LIGHT :: rl.Color{175, 135,  80, 255}
    COL_DOCK_DARK  :: rl.Color{ 90,  60,  28, 255}
    COL_DOCK_POST  :: rl.Color{ 80,  52,  24, 255}

    dock_x    := px + pw/2 - POND_DOCK_WIDTH/2
    dock_top  := py + ph/2
    dock_bot  := py + ph + 2
    dock_h    := dock_bot - dock_top

    rl.DrawRectangle(pxi(dock_x)+3, pxi(dock_top)+3, pxi(POND_DOCK_WIDTH), pxi(dock_h),
        rl.Color{0, 0, 0, 50})
    plank_count := int(dock_h / 8)
    for pi in 0..<plank_count {
        plank_y := dock_top + f32(pi) * 8
        col := COL_DOCK if pi%2==0 else COL_DOCK_LIGHT
        rl.DrawRectangle(pxi(dock_x), pxi(plank_y), pxi(POND_DOCK_WIDTH), 7, col)
    }
    rl.DrawRectangle(pxi(dock_x), pxi(dock_top), 3, pxi(dock_h), COL_DOCK_LIGHT)
    rl.DrawRectangle(pxi(dock_x + POND_DOCK_WIDTH) - 3, pxi(dock_top), 3, pxi(dock_h), COL_DOCK_DARK)
    post_count := int(dock_h / 40) + 1
    for pi in 0..<post_count {
        post_y := dock_top + f32(pi) * 40
        rl.DrawRectangle(pxi(dock_x) - 3, pxi(post_y), 4, 10, COL_DOCK_POST)
        rl.DrawRectangle(pxi(dock_x + POND_DOCK_WIDTH) - 1, pxi(post_y), 4, 10, COL_DOCK_POST)
    }
    rl.DrawRectangle(pxi(dock_x) - 4, pxi(dock_top), pxi(POND_DOCK_WIDTH) + 8, 10, COL_DOCK_LIGHT)

    if g.player_in_water {
        t := p.ripple_time * 3.0
        for ri in 0..<3 {
            phase := math.mod(t + f32(ri) * 1.0, 3.0)
            rr    := phase / 3.0 * 18
            ra    := u8((1.0 - phase/3.0) * 120)
            rl.DrawCircleLines(
                pxi(g.player.pos.x), pxi(g.player.pos.y),
                rr, rl.Color{160, 210, 255, ra},
            )
        }
    }
}
draw_fishing_spot :: proc() {
    if g.fishing_active { return }
    if vec2_dist(g.player.pos, FISHING_SPOT) < INTERACT_DIST {
        rl.DrawText("[E] Go Fishing", pxi(FISHING_SPOT.x)-32, pxi(FISHING_SPOT.y)-16, 8, COL_HONEY)
    }
}
draw_fishing_minigame_ui :: proc() {
    if !g.fishing_active { return }
    txt  := fmt.aprintf("Fishing... %.0fs left  [E] Reel In", g.fishing_timer,
        allocator = context.temp_allocator)
    cstr := strings.clone_to_cstring(txt, context.temp_allocator)
    tw   := rl.MeasureText(cstr, 10)
    rl.DrawRectangle(GAME_W/2 - tw/2 - 6, 6, tw+12, 16, COL_HUD_BG)
    rl.DrawText(cstr, GAME_W/2 - tw/2, 9, 10, COL_HONEY2)
}

draw_lantern_light :: proc() {
    if !g.lantern_active || !g.is_night { return }

    rl.BeginBlendMode(.ADDITIVE)
    rl.DrawCircleGradient(
        {f32(pxi(g.player.pos.x)), f32(pxi(g.player.pos.y))},
        LANTERN_LIGHT_RADIUS,
        LANTERN_LIGHT_COLOR,
        rl.Color{0,0,0,0},
    )
    rl.EndBlendMode()
}



// HUD


draw_hud :: proc() {
    rl.DrawRectangle(0, 0, GAME_W, 28, COL_HUD_BG)
    rl.DrawRectangle(0, 28, GAME_W, 1, COL_PANEL_BORDER)

    rl.DrawText(strings.clone_to_cstring(fmt.aprintf("$ %.2f", g.player.money, allocator = context.temp_allocator), context.temp_allocator), 8, 8, 10, COL_GREEN_TEXT)
    rl.DrawText(strings.clone_to_cstring(fmt.aprintf("Honey: %.1fml", g.player.honey_ml, allocator = context.temp_allocator), context.temp_allocator), 130, 9, 9, COL_HONEY)

    if g.player.owned_plot >= 0 && g.player.owned_plot < len(g.plots) {
	plot := &g.plots[g.player.owned_plot]
        rl.DrawText(strings.clone_to_cstring(fmt.aprintf("Farm: %s", plot_size_label(plot.size), allocator = context.temp_allocator), context.temp_allocator), 340, 9, 9, COL_TEXT)
    } else {
        rl.DrawText("No Farm", 340, 9, 9, COL_RED_TEXT)
    }

    box_count := 0
    for box in g.bee_boxes { if box.active { box_count += 1 } }
    rl.DrawText(strings.clone_to_cstring(fmt.aprintf("Boxes: %d", box_count, allocator = context.temp_allocator), context.temp_allocator), 460, 9, 9, COL_TEXT)

    homes_owned := 0
    for home in g.homes { if home.owned { homes_owned += 1 } }
    if homes_owned > 0 {
        rl.DrawText(strings.clone_to_cstring(fmt.aprintf("Homes: %d", homes_owned, allocator = context.temp_allocator), context.temp_allocator), 540, 9, 9, COL_GREEN_TEXT)
    }
    if g.sanctuary_donated > 0 {
    rl.DrawText(strings.clone_to_cstring(fmt.aprintf("Sanctuary: $%.0f",
        g.sanctuary_donated, allocator = context.temp_allocator), context.temp_allocator),
        230, 18, 7, COL_SANCTUARY)
    }


    if g.state == .Interior {
        b := &g.buildings[g.interior_building]
        rl.DrawText(strings.clone_to_cstring(fmt.aprintf("Inside: %s", b.label, allocator = context.temp_allocator), context.temp_allocator), 8, 9, 9, COL_HONEY)
    }

    time_str: string
    if g.is_night {
        time_str = fmt.aprintf("Night", allocator = context.temp_allocator)
    } else {
        time_str = fmt.aprintf("Day", allocator = context.temp_allocator)
    }
    day_col := rl.Color{80, 120, 200, 255} if g.is_night else rl.Color{255, 220, 80, 255}
    rl.DrawText(strings.clone_to_cstring(time_str, context.temp_allocator), 8, 18, 7, day_col)

    season_str := fmt.aprintf("| %s", season_label(g.season), allocator = context.temp_allocator)
    season_col: rl.Color
    switch g.season {
    case .Spring: season_col = {100, 220, 100, 255}
    case .Summer: season_col = {255, 200,  40, 255}
    case .Fall:   season_col = {220, 120,  40, 255}
    case .Winter: season_col = {160, 200, 240, 255}
    }
    rl.DrawText(strings.clone_to_cstring(season_str, context.temp_allocator), 36, 18, 7, season_col)

    if g.rain_timer > 0 {
        rl.DrawText("| RAIN", 90, 18, 7, {120, 180, 255, 255})
    }

    mult := honey_production_multiplier()
        mult_str := fmt.aprintf("| Prod: %.0f%%", mult*100, allocator = context.temp_allocator)
    mult_col := COL_GREEN_TEXT if mult >= 1.0 else COL_RED_TEXT
    rl.DrawText(strings.clone_to_cstring(mult_str, context.temp_allocator), 130, 18, 7, mult_col)

    {
        clock_hour   := int(g.day_time / INGAME_HOUR_REAL) % 24
        clock_min    := int((g.day_time - f32(clock_hour)*INGAME_HOUR_REAL) /
                            (INGAME_HOUR_REAL / 60.0)) % 60
        colon_char   := ":" if int(rl.GetTime()) % 2 == 0 else " "
        clock_str    := fmt.aprintf("%02d%s%02d", clock_hour, colon_char,clock_min, allocator = context.temp_allocator)
        clock_cstr   := strings.clone_to_cstring(clock_str, context.temp_allocator)
        clock_w      := rl.MeasureText(clock_cstr, 10)
        clock_x      := i32(GAME_W) - clock_w - 6
        day_in_season := int(g.season_time / DAY_DURATION) + 1
        day_cstr      := strings.clone_to_cstring(
            fmt.aprintf("Day %d", day_in_season, allocator = context.temp_allocator),
            context.temp_allocator)
        day_w := rl.MeasureText(day_cstr, 7)
        day_x := i32(GAME_W) - day_w - 6
        bezel_x := min(clock_x, day_x) - 4
        rl.DrawRectangle(bezel_x, 2, i32(GAME_W)-bezel_x-2, 24, {0, 16, 0, 220})
        rl.DrawRectangleLinesEx({f32(bezel_x), 2, f32(i32(GAME_W)-bezel_x-2), 24},
            1, {0, 160, 60, 180})
        rl.DrawText(clock_cstr, clock_x, 4,  10, rl.Color{0, 255, 80, 255})
        rl.DrawText(day_cstr,   day_x,   16,  7, rl.Color{0, 200, 60, 220})
    }

    rl.DrawRectangle(0, GAME_H-16, GAME_W, 16, COL_HUD_BG)

    rl.DrawRectangle(0, GAME_H-17, GAME_W, 1, COL_PANEL_BORDER)
    rl.DrawText("SPACE: Toggle Phone I:Inventory  F4:Stats  F5:Save  1:Customize",8, GAME_H-12, 7, {160,160,160,220})


    if g.message_timer > 0 && len(g.message) > 0 {
        alpha := u8(min(255, int(g.message_timer*140)))
        msg   := strings.clone_to_cstring(g.message, context.temp_allocator)
        tw    := rl.MeasureText(msg, 9)
        mx    := GAME_W/2 - int(tw)/2
        rl.DrawRectangle(i32(mx)-6, GAME_H/2+80, tw+12, 16, {0,0,0,u8(min(180,int(alpha)))})
        rl.DrawText(msg, i32(mx), GAME_H/2+83, 9, {255,220,80,alpha})
    }
}


// MAIN MENU

draw_menu_bee :: proc(cx, cy: i32, t: f32) {
    // Animated wing flap
    wing_offset := i32(math.sin(t * 12.0) * 3)
    rl.DrawRectangle(cx-6, cy+2,  12, 4, {240, 200,   0, 255}) // yellow
    rl.DrawRectangle(cx-6, cy+6,  12, 3, { 30,  30,  30, 255}) // black stripe
    rl.DrawRectangle(cx-5, cy+9,  10, 3, {240, 200,   0, 255}) // yellow
    rl.DrawRectangle(cx-5, cy+12,  10, 3, { 30,  30,  30, 255}) // black stripe
    rl.DrawRectangle(cx-4, cy+15,  8, 3, {240, 200,   0, 255}) // yellow tip
    rl.DrawRectangle(cx-5, cy-2,  10, 6, { 30,  30,  30, 255}) // black
    rl.DrawRectangle(cx-4, cy-1,   8, 4, { 60,  60,  60, 255}) // highlight
    // Head
    rl.DrawRectangle(cx-4, cy-8,   8, 7, {240, 200,   0, 255}) // yellow head
    rl.DrawRectangle(cx-3, cy-7,   6, 5, {255, 220,  40, 255}) // highlight
    // Eyes
    rl.DrawRectangle(cx-3, cy-6,   2, 2, { 10,  10,  10, 255})
    rl.DrawRectangle(cx+1, cy-6,   2, 2, { 10,  10,  10, 255})
    rl.DrawRectangle(cx-2, cy-5,   1, 1, {255, 255, 255, 200}) // eye shine
    rl.DrawRectangle(cx+2, cy-5,   1, 1, {255, 255, 255, 200})
    // Smile
    rl.DrawRectangle(cx-2, cy-3,   1, 1, { 30,  30,  30, 255})
    rl.DrawRectangle(cx-1, cy-2,   4, 1, { 30,  30,  30, 255})
    rl.DrawRectangle(cx+2, cy-3,   1, 1, { 30,  30,  30, 255})
    // Antennae
    rl.DrawRectangle(cx-3, cy-9,   1, 3, { 30,  30,  30, 255})
    rl.DrawRectangle(cx+2, cy-9,   1, 3, { 30,  30,  30, 255})
    rl.DrawRectangle(cx-4, cy-11,  2, 2, { 30,  30,  30, 255}) // antenna tip
    rl.DrawRectangle(cx+3, cy-11,  2, 2, { 30,  30,  30, 255})
    // Wings
    wing_y := cy - 4 + wing_offset
    // Left wing
    rl.DrawRectangle(cx-18, wing_y-4,  12, 8, {200, 240, 255, 160})
    rl.DrawRectangle(cx-16, wing_y-2,   8, 4, {220, 250, 255, 200})
    rl.DrawRectangleLinesEx({f32(cx-18), f32(wing_y-4), 12, 8}, 1, {100, 180, 255, 180})
    // Right wing
    rl.DrawRectangle(cx+6,  wing_y-4,  12, 8, {200, 240, 255, 160})
    rl.DrawRectangle(cx+8,  wing_y-2,   8, 4, {220, 250, 255, 200})
    rl.DrawRectangleLinesEx({f32(cx+6), f32(wing_y-4), 12, 8}, 1, {100, 180, 255, 180})
    // Stinger
    rl.DrawRectangle(cx-1, cy+18,  3, 3, { 30,  30,  30, 255})
    rl.DrawRectangle(cx,   cy+21,  1, 2, { 30,  30,  30, 255})
    // Fuzzy belly highlight
    rl.DrawRectangle(cx-2, cy+3,   4, 1, {255, 240, 100, 180})
    rl.DrawRectangle(cx-2, cy+10,  4, 1, {255, 240, 100, 180})
}
draw_menu_squirrel :: proc(x, y: i32, t: f32) {
    bob := i32(math.sin(t * 1.2) * 3)
    sy  := y + bob

    rl.DrawRectangle(x-2,  sy+10, 10, 18, {160, 100, 40, 255})
    rl.DrawRectangle(x+6,  sy+4,  10, 14, {160, 100, 40, 255})
    rl.DrawRectangle(x+10, sy,    10, 10, {240, 220, 180, 255})
    rl.DrawRectangle(x+14, sy-4,   8,  8, {240, 220, 180, 255})
    rl.DrawRectangle(x+16, sy-8,   6,  6, {240, 220, 180, 255})
    rl.DrawRectangle(x,    sy+12,  3, 12, {200, 140,  60, 255})
    rl.DrawRectangle(x+8,  sy+6,   3,  8, {200, 140,  60, 255})
    rl.DrawRectangle(x-8,  sy+10, 22, 20, {180, 110,  45, 255})
    rl.DrawRectangle(x-2,  sy+14, 10, 14, {240, 210, 160, 255})
    rl.DrawRectangle(x-6,  sy+12,  4, 10, {210, 140,  60, 255})
    rl.DrawRectangle(x-6,  sy-4,  20, 16, {180, 110,  45, 255})
    rl.DrawRectangle(x-2,  sy+4,  10,  6, {240, 200, 150, 255})
    rl.DrawRectangle(x-4,  sy-2,   4,  6, {210, 140,  60, 255})
    rl.DrawRectangle(x-4,  sy-12,  6,  8, {180, 110,  45, 255})
    rl.DrawRectangle(x-2,  sy-14,  4,  4, {180, 110,  45, 255})
    rl.DrawRectangle(x-2,  sy-10,  3,  5, {230, 160, 140, 255})
    rl.DrawRectangle(x+10, sy-12,  6,  8, {180, 110,  45, 255})
    rl.DrawRectangle(x+10, sy-14,  4,  4, {180, 110,  45, 255})
    rl.DrawRectangle(x+11, sy-10,  3,  5, {230, 160, 140, 255})
    rl.DrawRectangle(x-2,  sy,     5,  5, {255, 255, 255, 255})
    rl.DrawRectangle(x-1,  sy+1,   3,  3, {40,  30,  20, 255})
    rl.DrawRectangle(x,    sy+1,   1,  1, {255, 255, 255, 255})
    rl.DrawRectangle(x+8,  sy,     5,  5, {255, 255, 255, 255})
    rl.DrawRectangle(x+9,  sy+1,   3,  3, {40,  30,  20, 255})
    rl.DrawRectangle(x+10, sy+1,   1,  1, {255, 255, 255, 255})
    rl.DrawRectangle(x+4,  sy+6,   3,  2, {220, 130, 130, 255})
    rl.DrawRectangle(x+2,  sy+8,   2,  1, {140,  80,  40, 255})
    rl.DrawRectangle(x+7,  sy+8,   2,  1, {140,  80,  40, 255})
    rl.DrawRectangle(x-12, sy+16,  8,  5, {180, 110,  45, 255})
    rl.DrawRectangle(x+14, sy+16,  8,  5, {180, 110,  45, 255})
    rl.DrawRectangle(x-2,  sy+22,  14,  5, {100,  65,  20, 255})
    rl.DrawRectangle(x-1,  sy+20,  12,  3, {120,  80,  30, 255})
    rl.DrawRectangle(x,    sy+26,  10,  8, {200, 155,  80, 255})
    rl.DrawRectangle(x+2,  sy+27,   3,  5, {230, 190, 110, 255})
    rl.DrawRectangle(x+4,  sy+18,   2,  3, {100,  65,  20, 255})
    rl.DrawRectangle(x-6,  sy+28,   8,  4, {160,  95,  35, 255})
    rl.DrawRectangle(x+10, sy+28,   8,  4, {160,  95,  35, 255})
    rl.DrawRectangle(x-4,  sy+5,    3,  2, {230, 160, 160, 180})
    rl.DrawRectangle(x+13, sy+5,    3,  2, {230, 160, 160, 180})
    rl.DrawRectangle(x-8,  sy+32,  26,  3, {0, 0, 0, 60})
}


draw_main_menu :: proc() {
    t := f32(rl.GetTime())

    // Retro scanline background
    for ty := 0; ty < GAME_H; ty += 2 {
        rl.DrawRectangle(0, i32(ty), GAME_W, 1, {0, 30, 0, 80})
    }
    for gi in 0..<48 {
        gx   := i32(int(f32(gi) * 137.3) % int(GAME_W))
        base := i32(GAME_H) - i32(int(f32(gi)*53.7) % (GAME_H/3))
        // slight sway animation
        sway := i32(math.sin(t*1.4 + f32(gi)*0.7) * 2)
        h    := i32(12 + int(f32(gi)*17.3) % 20)
        // dark base blade
        rl.DrawRectangle(gx+sway,   base-h,   2, h,   {34,  80,  20, 255})
        // bright highlight stripe (retro pixel look)
        rl.DrawRectangle(gx+sway+1, base-h+2, 1, h/2, {100, 180,  50, 255})
        // tip pixel
        rl.DrawRectangle(gx+sway,   base-h-1, 1, 2,   {140, 210,  60, 255})
    }


    for i in 0..<28 {
        fl := &g.main_menu_flowers[i]
        draw_menu_flower(fl.x, fl.y, fl.seed)
    }

    bee_x := i32(GAME_W - 52)
    bee_y := i32(200) + i32(math.sin(t*1.8)*12)
    draw_menu_bee(bee_x, bee_y, t)
    squirrel_x := i32(28)
    squirrel_y := i32(190) + i32(math.sin(t*1.0)*8)
    draw_menu_squirrel(squirrel_x, squirrel_y, t)


    // Title box
    rl.DrawRectangle(20, 30, GAME_W-40, 80, {0, 0, 0, 200})
    rl.DrawRectangleLinesEx({20, 30, f32(GAME_W-40), 80}, 2, COL_HONEY)
    flicker := u8(180 + int(math.sin(t*4)*40))
    rl.DrawRectangleLinesEx({22, 32, f32(GAME_W-44), 76}, 1, {flicker, flicker/2, 0, 200})

    // Title text
    title1 := "FUZZY BUDDY FARMS"
    title2 := "HONEYVILLE EDITION"
    t1c := strings.clone_to_cstring(title1, context.temp_allocator)
    t2c := strings.clone_to_cstring(title2, context.temp_allocator)
    tw1 := rl.MeasureText(t1c, 20)
    tw2 := rl.MeasureText(t2c, 14)
    rl.DrawText(t1c, GAME_W/2-tw1/2+2, 42, 20, {80, 40, 0, 255})
    rl.DrawText(t1c, GAME_W/2-tw1/2,   40, 20, COL_HONEY)
    rl.DrawText(t2c, GAME_W/2-tw2/2+1, 68, 14, {60, 30, 0, 255})
    rl.DrawText(t2c, GAME_W/2-tw2/2,   66, 14, COL_HONEY2)

    for bi in 0..<3 {
        bangle := t*1.2 + f32(bi)*2.09
        bx := i32(GAME_W/2) + i32(math.cos(bangle)*120)
        by := i32(55) + i32(math.sin(bangle*0.7)*18)
        rl.DrawRectangle(bx-3, by-1, 6, 4, {220,200,0,200})
        rl.DrawRectangle(bx-1, by-1, 2, 4, {40,40,40,180})
        rl.DrawRectangle(bx-4, by-2, 2, 3, {200,230,255,120})
        rl.DrawRectangle(bx+2, by-2, 2, 3, {200,230,255,120})
    }

    if g.main_menu_mode == 1 || g.main_menu_mode == 2 {
        mode_label := "NEW GAME — Choose a Save Slot" if g.main_menu_mode == 1 else "LOAD GAME — Choose a Save Slot"
        draw_panel(f32(GAME_W)/2 - 180, 120, 360, 200, mode_label)

        if rl.IsKeyPressed(.UP)   { g.main_menu_cursor -= 1; if g.main_menu_cursor < 0 { g.main_menu_cursor = NUM_SAVE_SLOTS } }
        if rl.IsKeyPressed(.DOWN) { g.main_menu_cursor += 1; if g.main_menu_cursor > NUM_SAVE_SLOTS { g.main_menu_cursor = 0 } }

        for slot in 0..<NUM_SAVE_SLOTS {
            sy    := f32(140 + slot*44)
            hdr   := &g.save_headers[slot]
            label: string
            if hdr.used {
                name_n := 0
                for name_n < 32 && hdr.name[name_n] != 0 { name_n += 1 }
                name_str := string(hdr.name[:name_n])
                label = fmt.aprintf("Slot %d: %s  ($%.0f)", slot+1, name_str, hdr.money, allocator = context.temp_allocator)
            } else {
                label = fmt.aprintf("Slot %d: -- Empty --", slot+1, allocator = context.temp_allocator)
            }

            selected := (g.main_menu_cursor == slot)
            bg := COL_BTN_HOV if selected else COL_BTN
            btn_x := f32(GAME_W)/2 - 150
            rl.DrawRectangle(i32(btn_x), i32(sy), 300, 32, bg)
            rl.DrawRectangleLinesEx({btn_x, sy, 300, 32}, 1, COL_HONEY2 if selected else COL_PANEL_BORDER)
            if selected { rl.DrawText(">", i32(btn_x)+4, i32(sy)+10, 9, COL_HONEY2) }
            lbl_cstr := strings.clone_to_cstring(label, context.temp_allocator)
            lbl_tw   := rl.MeasureText(lbl_cstr, 9)
            rl.DrawText(lbl_cstr, i32(GAME_W)/2 - lbl_tw/2, i32(sy)+10, 9, COL_TEXT)

	    if g.suppress_enter_this_frame {
		g.suppress_enter_this_frame = false
	    } else if selected && (rl.IsKeyPressed(.ENTER) || rl.IsKeyPressed(.KP_ENTER)) {
                if g.main_menu_mode == 1 {
                    init_game()
                    g.save_rename_slot = slot
                    g.save_rename_len  = 0
                    for i in 0..<32 { g.save_rename_buf[i] = 0 }
                    g.main_menu_mode = 0
                    g.state = .SaveMenu
                } else {
                    if hdr.used {
                        init_game()
                        if load_game(slot) {
                            show_message(fmt.aprintf("Loaded slot %d!", slot+1, allocator = context.temp_allocator))
                            g.main_menu_mode = 0
                            if g.pending_host_after_load {
                                g.pending_host_after_load = false
                                passphrase := string(g.pending_host_passphrase_buf[:g.pending_host_passphrase_len])
				if net_host_start(NET_PORT_DEFAULT, passphrase) {
                                    g.state = .MultiplayerLobby
                                } else {
                                    show_message("Failed to host — check network settings.")
                                    g.state = .World
                                }
                            } else {
                                g.state = .World
                            }
                        } else {
                            show_message("Load failed!")
                        }
                    } else {
                        show_message("No save in that slot!")
                    }
                }
            }
        }

        back_selected := (g.main_menu_cursor == NUM_SAVE_SLOTS)
        back_bg := COL_BTN_HOV if back_selected else COL_BTN
        back_x := f32(GAME_W)/2 - 60
        back_y := f32(140 + NUM_SAVE_SLOTS*44)
        rl.DrawRectangle(i32(back_x), i32(back_y), 120, 28, back_bg)
        rl.DrawRectangleLinesEx({back_x, back_y, 120, 28}, 1, COL_HONEY2 if back_selected else COL_PANEL_BORDER)
        rl.DrawText("Back", i32(back_x)+44, i32(back_y)+8, 10, COL_TEXT)
        if back_selected && (rl.IsKeyPressed(.ENTER) || rl.IsKeyPressed(.KP_ENTER)) {
            g.main_menu_mode = 0
            g.main_menu_cursor = 0
        }
        if rl.IsKeyPressed(.ESCAPE) {
            g.main_menu_mode = 0
            g.main_menu_cursor = 0
        }

        rl.DrawText("UP/DOWN: Navigate   ENTER: Select", GAME_W/2-100, GAME_H-12, 7, {140,140,100,200})
        rl.DrawText("Created by ACS 'a creative solution'", 8, GAME_H-12, 7, {120,120,80,180})
        return
    }

    menu_labels := [4]string{"New Game", "Load Game", "Multiplayer", "Help"}
    num_items   := 4
    if rl.IsKeyPressed(.UP)   { g.main_menu_cursor -= 1; if g.main_menu_cursor < 0 { g.main_menu_cursor = num_items-1 } }
    if rl.IsKeyPressed(.DOWN) { g.main_menu_cursor += 1; if g.main_menu_cursor >= num_items { g.main_menu_cursor = 0 } }

    for i in 0..<num_items {
        my := f32(140 + i*44)
        selected := (g.main_menu_cursor == i)
        bg := COL_BTN_HOV if selected else COL_BTN
        rl.DrawRectangle(GAME_W/2-80, i32(my), 160, 32, bg)
        rl.DrawRectangleLinesEx({f32(GAME_W/2-80), my, 160, 32}, 1, COL_PANEL_BORDER)
        if selected {
            rl.DrawRectangleLinesEx({f32(GAME_W/2-80), my, 160, 32}, 1, COL_HONEY2)
            rl.DrawText(">", GAME_W/2-76, i32(my)+10, 10, COL_HONEY2)
        }
        lbl := strings.clone_to_cstring(menu_labels[i], context.temp_allocator)
        tw  := rl.MeasureText(lbl, 12)
        rl.DrawText(lbl, GAME_W/2-tw/2, i32(my)+9, 12, COL_TEXT)
    }

    if rl.IsKeyPressed(.ENTER) || rl.IsKeyPressed(.KP_ENTER) {
    	switch g.main_menu_cursor {
    	case 0:
	    g.main_menu_mode   = 1
	    g.main_menu_cursor = 0
	    for i in 0..<NUM_SAVE_SLOTS { refresh_save_header(i) }
    	case 1:
	    g.main_menu_mode   = 2
	    g.main_menu_cursor = 0
	    for i in 0..<NUM_SAVE_SLOTS { refresh_save_header(i) }
    	case 2:
	    g.state       = .MultiplayerMenu
	    g.menu_cursor = 0
	case 3:
	    g.state = .HelpMenu
	}
    }


    rl.DrawText("demo version | ACS 'a creative solution'", 8, GAME_H-12, 7, {120,120,80,180})
    rl.DrawText("UP/DOWN: Navigate   ENTER: Select", GAME_W/2-80, GAME_H-12, 7, {140,140,100,200})
}

draw_help_menu :: proc() {
    draw_mp_night_backdrop()
    pw :: f32(580); ph :: f32(300)
    px := f32(GAME_W)/2 - pw/2; py := f32(GAME_H)/2 - ph/2
    draw_panel(px, py, pw, ph, "=== KEYBINDS ===")

    lines := [16]string{
        "FUZZY BUDDY FARMS: HONEYVILLE EDITION",
        "",
        "CONTROLS:",
        "  WASD - Move player          ESC - Close Game [SAVE FIRST!]",
        "  CAR:",
	"  UP,DOWN,LEFT,RIGHT - Steering     C - Enter when near car",
	"  CAMERA:",
        "  C - Camera    P - PhotoAlbum    R-Remove Photo   L: List Animals",
	"  SOCCER:",
	"  C - Challenge when near    X - Slide Tackle    H - Help Menu",
	"  ETC:",
        "  E - Interact w Enviroment    I - Inventory    O - Options(inside)",
	"  F5 - Save/Load    F4 - Stats Toggle    1 - Customize    2 - Trophies",
	"  T - Plant Tree    F - Plant Flower     Q - release QueenBee",
	"  9 - Toggle Lantern    0 - Toggle Bee Net",
        "",
    }

    for i in 0..<16 {
        col := COL_HONEY if i == 0 else (COL_TEXT if i > 1 else COL_TEXT2)
        if i == 2 { col = COL_HONEY2 }
        if i == 8 { col = COL_HONEY2 }
        rl.DrawText(strings.clone_to_cstring(lines[i], context.temp_allocator), pxi(px)+8, pxi(py)+20+i32(i)*17, 8, col)
    }

    rl.DrawText("Press ENTER to return", pxi(px)+8, pxi(py)+pxi(ph)-14, 8, {140,140,100,200})
    if rl.IsKeyPressed(.ESCAPE) || rl.IsKeyPressed(.ENTER) || rl.IsKeyPressed(.KP_ENTER) { 
	g.state = .MainMenu
    }
}


// DRAW WORLD


draw_world :: proc() {
    rl.BeginMode2D(g.camera)

    for ty := -2800; ty < 2800; ty += 16 {
        for tx := -2800; tx < 2800; tx += 16 {
            base := COL_GRASS if ((tx/16)+(ty/16))%2==0 else rl.Color{64,96,28,255}
            col: rl.Color
            if g.is_night {
                col = rl.Color{base.r/3, base.g/3, base.b/3+20, 255}
            } else {
                col = base
            }
            rl.DrawRectangle(i32(tx), i32(ty), 16, 16, col)
        }
    }

    for i in 0..<len(g.plots) { draw_plot(g.plots[i], i) }

    draw_dirt_roads()

    draw_ground()

    draw_racetrack()
    draw_race_timer_hud()

    for bt in BuildingType { draw_building(g.buildings[bt]) }

    for i in 0..<NUM_HOMES { draw_home(g.homes[i], i) }

    draw_park()

    draw_festival()

    for box in g.bee_boxes { if box.active { draw_bee_box(box) } }

    for i in 0..<NPC_COUNT { draw_npc(g.npcs[i]) }

    draw_soccer()

    draw_animals()

    draw_bee_swarm()

    draw_pond()
    draw_fishing_spot()

    if g.bee_cam_active {
	draw_bee_cam_player()
    } else {
	draw_player()
    }
    draw_cars()
    draw_player()
    draw_remote_players()
    draw_player_lightsaber()
    draw_player_bee_net()
    draw_yoda()
    draw_animal_buddy()

    draw_lightning_bugs()

    draw_lantern_light()

    draw_town_decorations()

    rl.EndMode2D()

    if g.is_night {
        rl.DrawRectangle(0, 0, GAME_W, GAME_H, {0, 0, 30, 120})
    }

    draw_rain()
}

draw_rotated_rect :: proc(cx, cy, lx, ly, w, h, cos, sin: f32, col: rl.Color) {
    hw := w * 0.5
    hh := h * 0.5
    corners := [4]Vec2{
        {lx - hw, ly - hh}, {lx + hw, ly - hh},
        {lx + hw, ly + hh}, {lx - hw, ly + hh},
    }
    wc := [4]Vec2{}
    for j in 0..<4 {
        wc[j] = Vec2{
            cx + corners[j].x * cos - corners[j].y * sin,
            cy + corners[j].x * sin + corners[j].y * cos,
        }
    }
    rl.DrawTriangle(wc[0], wc[1], wc[2], col)
    rl.DrawTriangle(wc[0], wc[2], wc[3], col)
}

draw_car_world :: proc() {
    for i in 0..<MAX_CARS {
        c := &g.cars[i]
        if !c.active { continue }

        cx  := c.pos.x
        cy  := c.pos.y
        rad := c.angle * math.PI / 180.0
        cos := math.cos(rad)
        sin := math.sin(rad)
        draw_rotated_rect(cx, cy,  0,  0, 28, 14, cos, sin, c.body_col)
        draw_rotated_rect(cx, cy, -2, -9, 16,  8, cos, sin, c.body_col)
        draw_rotated_rect(cx, cy,  4, -8,  6,  6, cos, sin, COL_CAR_WINDOW)
        draw_rotated_rect(cx, cy, -5, -8,  5,  6, cos, sin, COL_CAR_WINDOW)
        draw_rotated_rect(cx, cy, 15,  0,  4,  14, cos, sin, COL_CAR_CHROME)
        draw_rotated_rect(cx, cy,-15,  0,  4,  14, cos, sin, COL_CAR_CHROME)
        wheel_offsets := [4]Vec2{{10, -8},{10, 8},{-10, -8},{-10, 8}}
        for wo in wheel_offsets {
            draw_rotated_rect(cx, cy, wo.x, wo.y, 5, 4, cos, sin, COL_CAR_WHEEL)
        }

        if !g.in_car && c.owned && !c.occupied {
            d := vec2_dist(g.player.pos, c.pos)
            if d < CAR_ENTER_DIST + 10 {
                rl.DrawText("[C] Enter",
                    pxi(cx) - 22, pxi(cy) - 28, 8, COL_TEXT)
            }
        }

        if c.occupied {
            draw_rotated_rect(cx, cy, -2, -13, 6, 4, cos, sin, COL_HONEY)
        }
    }
}



// DRAW INTERIOR SCENE

draw_interior_scene :: proc() {
    rl.BeginMode2D(g.camera)
    rl.DrawRectangle(-400, -300, 800, 600, {20,15,10,255})
    draw_interior()
    rl.EndMode2D()

    draw_interior_option_menu()
}


// MAIN


main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, TITLE)
    gallery_textures[0] = rl.LoadTexture("assets/bill_painting.png")
    billpainting_bytes := #load("assets/bill_painting.png")
    img := rl.LoadImageFromMemory(".png", raw_data(billpainting_bytes), i32(len(billpainting_bytes)))
    gallery_textures[0] = rl.LoadTextureFromImage(img)
    rl.UnloadImage(img)
    defer rl.CloseWindow()
    rl.SetTargetFPS(TARGET_FPS)

    g.render_tex = rl.LoadRenderTexture(GAME_W, GAME_H)
    rl.SetTextureFilter(g.render_tex.texture, .POINT)
    g.state = .MainMenu
    g.main_menu_cursor = 0
    g.main_menu_mode   = 0
    rng_seed(42069)

    init_main_menu_flowers()

    defer rl.UnloadRenderTexture(g.render_tex)

    src_rect := rl.Rectangle{0, 0, GAME_W, -GAME_H}
    dst_rect := rl.Rectangle{0, 0, SCREEN_WIDTH, SCREEN_HEIGHT}

    for !rl.WindowShouldClose() {
        g.dt = rl.GetFrameTime()

	if g.state != .MainMenu && g.state != .HelpMenu &&
	   g.state != .MultiplayerMenu && g.state != .MultiplayerIPEntry &&
	   g.state != .MultiplayerLobby && g.state != .MultiplayerHostPassphrase {
	    update_player_needs()
	}

	if net_state.role != .None {
	    net_update()
	}

        #partial switch g.state {
        case .MainMenu:
        case .HelpMenu:
	case .MultiplayerMenu:
	case .MultiplayerIPEntry: update_multiplayer_ip_entry()
	case .MultiplayerHostPassphrase: update_multiplayer_host_passphrase()
	case .MultiplayerLobby:
        case .World:
            update_world()
	    update_race_timer()
	    update_race_timer_toggle()
	    update_track_flashes()
        case .Interior:
            update_interior()
            update_message()
            update_minimap_toggle()
            update_inventory_toggle()
	    update_customize_toggle()
	    update_customize_menu()
	    update_phone_toggle()
	    update_phone_menu()        
	case .HomeInterior:
	    update_home_interior()
	case .GarageInterior:
	    update_garage_interior()
	    update_car_customize_toggle()
	    update_car_customize_menu()
	case .FarmersMarketInterior:
	    update_farmers_market_interior()
	    update_market_menu()
        case:
            update_camera()
            update_npcs()
	    update_market_menu()
            update_environment()
            update_bee_boxes()
	    update_race_timer_toggle()
	    update_race_timer()
	    update_track_flashes()
            update_message()
            update_minimap_toggle()
	    update_inventory_toggle()
	    update_customize_toggle()
	    update_customize_menu()
	    update_phone_toggle()
	    update_phone_menu()
	    update_achievements_toggle()
	    update_achievements_menu()
	    check_passive_achievements()

        }

        rl.BeginTextureMode(g.render_tex)
        rl.ClearBackground(COL_GRASS)

        #partial switch g.state {
        case .MainMenu:
            draw_main_menu()
        case .HelpMenu:
            draw_help_menu()
	case .MultiplayerMenu: draw_multiplayer_menu()
	case .MultiplayerIPEntry: draw_multiplayer_ip_entry()
	case .MultiplayerHostPassphrase: draw_multiplayer_host_passphrase()
	case .MultiplayerLobby: draw_multiplayer_lobby()
        case .World:
            draw_world()
            draw_hud()
	    draw_race_timer_hud()
	    draw_player_needs_hud()
            draw_minimap()
            draw_inventory()
	    draw_customize_menu()
	    draw_achievements_menu()
	    draw_weather_menu()
	    draw_animal_menu()
	    draw_camera_album()
	    draw_discovered()
	    draw_stats_menu()
	    draw_festival_menu()
	    draw_phone()
        case .Interior:
            draw_interior_scene()
            draw_hud()
	    draw_player_needs_hud()
            draw_minimap()
            draw_inventory()
	    draw_achievements_menu()
	    draw_weather_menu()
	    draw_customize_menu()
	    draw_phone()
	case .HomeInterior:
	    draw_home_interior_scene()
	    draw_hud()
	    draw_player_needs_hud()
	    draw_phone()
	case .GarageInterior:
	    draw_garage_interior_scene()
	    draw_player_needs_hud()
	    draw_car_customize_menu()
	    draw_phone()
	case .FarmersMarketInterior:
	    draw_farmers_market_interior_scene()
	    draw_player_needs_hud()
	    draw_market_menu()
	    draw_phone()
        case:
            draw_world()
            update_menus()
            draw_hud()
	    draw_race_timer_hud()
	    draw_player_needs_hud()
            draw_minimap()
            draw_inventory()
	    draw_customize_menu()
	    draw_car_customize_menu()
	    draw_achievements_menu()
	    draw_weather_menu()
	    draw_stats_menu()
	    draw_bee_cam_overlay()
	    draw_fishing_minigame_ui()
	    draw_farmers_market()
	    draw_phone()
        }

	draw_death_overlay()

        rl.EndTextureMode()

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        rl.DrawTexturePro(g.render_tex.texture, src_rect, dst_rect, {0,0}, 0, rl.WHITE)
        rl.EndDrawing()

        free_all(context.temp_allocator)
    }
}
