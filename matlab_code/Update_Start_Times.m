clear

tic
conn = database('MLBDaily','root','','VENDOR','MySQL');

try
    curs = exec(conn,'select team from stadium_stats');
    if ~isempty(curs.Message)
        disp(curs.Message)
    end
    
    curs = fetch(curs);
    
    for i=1:length(curs.Data)
        
        for year=2002:2016
            data = getGameStartTimes(year,curs.Data{i});
            
            for j=1:size(data,1)
                
                if ~strcmp(data{j,2}(1:3),'at ')
                    
                    cursTmp = exec(conn,sprintf(['update game_info_%d set '...
                        'startTime = "%s" where home = "%s" AND `date` = "%s"'],...
                        year, data{j,3}, curs.Data{i}, data{j,1}));

                    if ~isempty(cursTmp.Message)
                        disp(cursTmp.Message)
                    end
                end
            end
        end
    end
catch e
    disp(e.message)
    i
    j
end

close(conn)

disp('Start Times done')
toc
