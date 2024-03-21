% Initializes game state

%% Assign Country Data
% 1 = Player, 0 = Minor

powers = readtable("settings/defines/powers.csv");

% Count of players and minors
playerCount = sum(powers.player) - 1;
minorCount = sum(powers.colonizer) - sum(powers.player);

playerPowers = powers(powers.player == 1,:);

%% Import Initial State

% Import areas and join into one table
areaTypes = readtable("settings/defines/areaTypes.csv");
areas = readtable("settings/defines/areas.csv");

% Types of status marker
markerTypes = readtable("settings/defines/markerTypes.csv");

% Initial status marker placements
area_markers = readtable("settings/defines/area_markers.csv");

%% Game Loop
% Sets up initial game state

turn = 1;
yearTicker = 1880:4:1916;
year = yearTicker(turn); % Starting year

resentment = zeros(10,1); % Initial Chinese Resentment Index
tensions = zeros(10,1); % Initial European Tensions Index

randomEvents = zeros(10,6); % Random events
minorActions = zeros(10,minorCount); % Minor colonization attempts

% Money
colonialOffice = zeros(10,playerCount); % Colonial Office revenue
statusBought = zeros(10,playerCount); % Purchasing status markers
statusRevenue = zeros(10,playerCount); % Status marker revenue
statusUpkeep = zeros(10,playerCount); % Upkeep for status markers
armyUpkeep = zeros(10,playerCount); % Upkeep for armies
armyBought = zeros(10,playerCount); % Raising armies
navyUpkeep = zeros(10,playerCount); % Upkeep for navies
navyBought = zeros(10,playerCount); % Building navies

% VPs
vpBonus = zeros(10,playerCount); % Bonus
vpPenalty = zeros(10,playerCount); % Penalties
bpBought = zeros(10,playerCount); % Purchased
victoryPoints = zeros(10,playerCount); % Overall VPs