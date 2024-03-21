% Initializes game state

%% Assign Country Data
% 1 = Player, 0 = Minor

powers = readtable("settings/defines/powers.csv");

playerCount = sum(powers.player) - 1;
playerPowers = powers(powers.player == 1,:);

%% Initial State

% Import areas and join into one table
areaTypes = readtable("settings/defines/areaTypes.csv");
areas = readtable("settings/defines/areas.csv");

% Types of status marker
markerTypes = readtable("settings/defines/markerTypes.csv");

% Initial status marker placements
area_markers = readtable("settings/defines/area_markers.csv");