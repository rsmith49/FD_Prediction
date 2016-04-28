function updateFDSalaries(conn,dateNum)
todayNum = today('datenum');
dateStr = getDateStr(dateNum);

sqlquery = sprintf(['UPDATE player_daily_%d AS a, temp_daily_fd_player_list_%d_%d'...
    ' AS b SET a.fd_salary = b.Salary WHERE a.`date` = "%s" AND b.id LIKE '...
    'CONCAT("%%",a.fd_id)'],...
    year(todayNum),month(dateNum),day(dateNum),dateStr);

curs = exec(conn,sqlquery);
if ~isempty(curs.Message)
    disp(curs.Message);
end

sqlquery = sprintf(['UPDATE pitcher_daily_%d AS a, temp_daily_fd_player_list_%d_%d'...
    ' AS b SET a.fd_salary = b.Salary WHERE a.`date` = "%s" AND b.id LIKE '...
    'CONCAT("%%",a.fd_id)'],...
    year(todayNum),month(dateNum),day(dateNum),dateStr);

curs = exec(conn,sqlquery);
if ~isempty(curs.Message)
    disp(curs.Message);
end
