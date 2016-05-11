clear
tic
conn = DBConnect();

try

    curs = exec(conn,['select team, airport from stadium_stats WHERE team in '...
        '(select distinct home from game_info_2016 where temp is null and '...
        'homeLong is not null)']);
    %curs = exec(conn,'select team, airport from stadium_stats');
    curs = fetch(curs);
    if ~isempty(curs.Message)
        disp(curs.Message)
    end
    
    for i=1:size(curs.Data,1)
        for year=2016:2016
            updateOldWeatherData(conn,curs.Data{i,2},year,curs.Data{i,1});
        end
    end
catch e
    disp(e)
    i
    year
end

close(conn)
disp('Weather Updates Done')
toc
