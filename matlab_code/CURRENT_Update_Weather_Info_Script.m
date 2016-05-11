clear
tic
conn = DBConnect();
todayNum = today('datenum');

try

    curs = exec(conn,['select team, airport from stadium_stats WHERE team in '...
        '(select distinct home from game_info_' num2str(year(todayNum)) ' where temp is null and '...
        'homeLong is not null)']);
    %curs = exec(conn,'select team, airport from stadium_stats');
    curs = fetch(curs);
    if ~isempty(curs.Message)
        disp(curs.Message)
    end
    
    for i=1:size(curs.Data,1)
        
            updateOldWeatherData(conn,curs.Data{i,2},year(todayNum),curs.Data{i,1});
        
    end
catch e
    disp(e)
    i
    year
end

close(conn)
disp('------------------------------------')
disp('------------------------------------')
disp('Weather Updates Done')
toc
disp('------------------------------------')
disp('------------------------------------')
