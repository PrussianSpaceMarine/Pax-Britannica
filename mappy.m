%% Draws maps
% Mappy is my best friend

close all

global areas areaTypes

figure
hold on

xlim([0 18])
ylim([0 13])
pbaspect([18 13 1])

for a = 1:height(areas)
    a = areas(a,:);
    aY = 13-a.x;
    aX = a.y;
    boxColor = string(areaTypes{a.tID,"color"});
    
    % annotation("textbox",[aX/18 aY/13 0.5/18 0.5/13],'String',{string(areas{a,"name"}),"£"+string(areas{a,"ev"})+"     "+string(areas{a,"cs"})})
    % annotation("textbox",[aX/18 aY/13 0.05 0.05],'String',{string(areas{a,"name"}),"£"+string(areas{a,"ev"})+"     "+string(areas{a,"cs"})},'FitBoxToText','on')
    % rectangle('Position',[aX aY 0.3 0.3]);
    % text(aX+0.35, aY+0.15, {string(areas{a,"name"}),"£"+string(areas{a,"ev"})+"     "+string(areas{a,"cs"})},"FontSize",6,"FontWeight","bold",'EdgeColor',[0 0 0])
    if a.tID == 6 % Metropole
        text(aX, aY, string(a.name),"FontSize",6.5,"FontWeight","bold",'EdgeColor',[0 0 0],'HorizontalAlignment','center',Clipping='on')
    elseif a.tID == 7 % Sea Zones
        text(aX, aY, string(a.name),"FontSize",6.5,"FontWeight","bold",'EdgeColor',[0 0 0],'HorizontalAlignment','center',Clipping='on')
    else % All others
        text(aX, aY, {string(a.name),"£"+string(a.ev)+"    "+string(a.cs)},"FontSize",5.5,"FontWeight","bold",'EdgeColor',[0 0 0],'HorizontalAlignment','center',Clipping='on',BackgroundColor=boxColor)
    end
end

hold off