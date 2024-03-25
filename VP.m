%% VP
% Calculates current VP totals as of this turn

% Filter to powers controlled by a player
playerPowers = powers(powers{:,"player"} == 1,:);

% Remake area_markersJ
area_markersJ = join(join(area_markers,areas,"Keys","aID"),markerTypes,"Keys","mID");

% Begin chart
figure(12);
tiledlayout(2,1);
nexttile;
rev = zeros(1,height(playerPowers));

for p = 1:height(playerPowers)

    % Identify power
    pp = playerPowers{p,"pID"};

    % Color
    color = playerPowers{p,"color"};
    
    % Divisor
    VPdiv = playerPowers{p,"vpDiv"};

    %% Calculate VP total
    
    % Established status markers
    f = area_markersJ(area_markersJ{:,"pID"} == pp & area_markersJ{:,"tID"} ~= 6 & area_markersJ{:,"established"} == 1,:);

    % Revenue
    rev(p) = sum(f.ev .* f.evM);

    % Divide by VP divisor
    rev(p) = rev(p) / VPdiv;

    % Apply bonuses/penalties
    victoryPoints(turn,p) = rev(p) * 2 - vpPenalty(turn,p) + vpBonus(turn,p) + vpBought(turn,p);

end

%% Finish Chart

% Bar
b = bar(string(playerPowers{:,"n"}),victoryPoints(turn,:),0.7,"grouped","yellow");
b.FaceColor = 'flat';
grid on;
for bb = 1:height(playerPowers)
    b.CData(bb,:) = hex2rgb(playerPowers{bb,"color"});
end
xlabel("Powers")
ylabel("Victory Points")

% Line
nexttile;
xticks(yearTicker);
xlim([1880 1916]);
hold on;
for bb = 1:height(playerPowers)
    color = playerPowers{bb,"color"};
    c = plot(yearTicker,victoryPoints(:,bb),"Color",hex2rgb(color),"LineWidth",3);
end
grid on;
legend([playerPowers{:,"n"}]);
xlabel("Powers")
ylabel("Victory Points")
hold off;