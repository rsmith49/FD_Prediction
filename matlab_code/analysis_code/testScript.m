%conn = database('MLBDaily','root','','VENDOR','MySQL');
%year = 2016;

curs = exec(conn,sprintf(['select a.fd_points, b.temp, b.dewPoint, b.percentHumidity, '...
    'b.pressure, b.visibility, b.windSpeed, b.gustSpeed, b.precip '...
    'from player_daily_%d as a, game_info_%d as b where '...
    '(a.opp = b.home OR a.opp = b.vis) AND a.dateNum = b.dateNum AND a.playerName = "Todd Frazier"'],...
    year,year));
curs = fetch(curs);
if ~isempty(curs.Message)
    disp(curs.Message)
end

X = zeros(size(curs.Data,1),9);
y = zeros(size(curs.Data,1),1);
for i=1:size(curs.Data,1)
    for j=1:8
        X(i,j) = curs.Data{i,j+1};
    end
    X(i,9) = 1;
    y(i) = curs.Data{i,1};
end

%[b,bint,r,rint,stats] = regress(y,X);