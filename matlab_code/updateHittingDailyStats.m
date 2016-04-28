function updateHittingDailyStats(conn, espnID, year)

curs = exec(conn,sprintf(['select `date` from player_daily_%d where'...
    ' espnID = %d'], year, espnID));
curs = fetch(curs);

if ~isempty(curs.Message)
    disp(curs.Message)
end

cursName = exec(conn,['select playerName, fanduel_id from active_players where espnID = ' num2str(espnID)]);
cursName = fetch(cursName);
if ~isempty(cursName.Message)
    disp(cursName.Message)
end

options = weboptions('Timeout', 60);
html = webread(sprintf(['http://espn.go.com/mlb/player/gamelog/_/id/%d/'...
    'year/%d/'], espnID, year),options);
dates = getAllESPNHitterDates(html);


for i=1:length(dates)
    if ~ismember(dates{i}, curs.Data)
        if i > 1 && strcmp(dates{i},dates{i-1})
            dbHeaderNum = 2;
        else
            dbHeaderNum = 1;
        end
       addHittingDailyStats(conn,html,cursName.Data{1},espnID,...
           dates{i}, year, dbHeaderNum, cursName.Data{2});
    end
end
