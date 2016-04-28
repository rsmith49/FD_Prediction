clear
tic
conn = database('MLBDaily','root','','VENDOR','MySQL');

try
    curs = exec(conn,'select distinct `Date` from daily_rg_2015_16');
    curs = fetch(curs);
    if ~isempty(curs.Message)
        disp(curs.Message);
    end
    
    for i=1:length(curs.Data)
        newDateNum = datenum(curs.Data{i},'yyyymmdd');
        sqlquery = sprintf('update daily_rg_2015_16 SET dateNum = %d where `Date` = %s',...
            newDateNum, curs.Data{i});
        tmpCurs = exec(conn,sqlquery);
        if ~isempty(tmpCurs.Message)
            disp(tmpCurs.Message)
            
        end
    end
    
catch e
    disp(e)
end

close(conn);
toc