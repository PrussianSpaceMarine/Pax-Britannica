% Initializes game state
clear

noStop = 0; % 0 == Don't automatically run first turn information, 1 == Run

%% Assign Country Data
% 1 = Player, 0 = Minor

% Globals
global powers units area_markers areas areaTypes adj coast markerTypes statusBought

powers = readtable("settings/defines/powers.csv");

% Count of players and minors
playerCount = sum(powers.player);
minorCount = sum(powers.colonizer) - sum(powers.player);

playerPowers = powers(powers.player == 1,:);
minors = powers(powers.player == 0 & powers.colonizer == 1,:);

%% Import Initial State

% Import areas
areaTypes = readtable("settings/defines/areaTypes.csv");
areas = readtable("settings/defines/areas.csv");
adj = readtable("settings/defines/adjacency.csv");
coast = readtable("settings/defines/coastal.csv");

% Types of status marker
markerTypes = readtable("settings/defines/markerTypes.csv");

% Initial status marker placements
area_markers = readtable("settings/defines/area_markers.csv");
area_markersJ = join(join(area_markers,areas,"Keys","aID"),markerTypes,"Keys","mID");

% Initial Military Units
units = readtable("settings/defines/units.csv");

% Random Events
events = readtable("settings/defines/events.csv","Delimiter",',','ReadVariableNames',true);

% Unrest Tables
unrest = readtable("settings/defines/unrest.csv","Delimiter",',','ReadVariableNames',true);
unrest = join(unrest,areas,"Keys","aID");

% Colonial Office Funding Ranges
funding = readtable("settings/defines/funding.csv","Delimiter",',','ReadVariableNames',true);

% Minor Power Priorities
minorTables = readtable("settings/defines/minorTables.csv","Delimiter",',','ReadVariableNames',true);

%% Game Loop
% Sets up initial game state

% Globals
global turn spendable armyBought navyBought totalExpenditure remaining vpBonus vpPenalty

turn = 1;
yearTicker = 1880:4:1916;
yr = yearTicker(turn); % Starting year

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

totalRevenue = zeros(10,playerCount);
totalExpenditure = zeros(10,playerCount);
spendable = zeros(10,playerCount);
remaining = zeros(10,playerCount);

% Military
armies = zeros(10,playerCount);
navies = zeros(10,playerCount);

% VPs
vpBonus = zeros(10,playerCount); % Bonus
vpPenalty = zeros(10,playerCount); % Penalties
vpBought = zeros(10,playerCount); % Purchased
victoryPoints = zeros(10,playerCount); % Overall VPs

clc

if noStop == 1
    run1
end