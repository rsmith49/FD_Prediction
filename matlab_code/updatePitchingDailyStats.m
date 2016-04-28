function updatePitchingDailyStats(conn, espnID, year)

curs = exec(conn,sprintf(['select `date` from pitcher_daily_%d where'...
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

html = webread(sprintf(['http://espn.go.com/mlb/player/gamelog/_/id/%d/'...
    'year/%d/'], espnID, year));
dates = getAllESPNPitcherDates(html);


for i=1:length(dates)
    if ~ismember(dates{i}, curs.Data)
        
       addPitchingDailyStats(conn,html,cursName.Data{1},espnID,...
           dates{i}, year, cursName.Data{2});
    end
end
