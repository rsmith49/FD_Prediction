% cols is an N by 2 cell array, with column 1 being the column name,
% column 2 being the table name
function [b,bint,r,rint,stats] = basicDBRegressFDPoints(conn,espnID,cols,hitter)
yearNum = year(today('datenum'));
if hitter
    table = ['player_daily_' num2str(year(yearNum))];
else
    table = ['pitcher_daily_' num2str(year(yearNum))];
end

tablecount = 0;
diffTables = cell(size(cols,1),1);
for i=1:size(cols,1)
    if ~ismember(cols{i,2},diffTables)
        tablecount = tablecount + 1;
        diffTables{tablecount} = cols{i,2};
    end
end


sqlquery = ['select ' table '.fd_points'];
for i=1:size(cols,1)
    sqlquery = [sqlquery ', ' cols{i,2} '.' cols{i,1}];
end
sqlquery = [sqlquery ' from '];

for i=1:tablecount
    sqlquery = [sqlquery ', ' diffTables{tablecount}];
end
sqlquery = [sqlquery ' where '];

for i=1:tablecount
    if ~isempty(strfind([diffTables{:}],'game_info'))
        sqlquery = [sqlquery '(' table '.opp = ' diffTables{i} '.home OR '...
            table '.opp =  ' diffTables{i} '.vis) AND '];
    end
end


