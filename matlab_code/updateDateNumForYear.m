function updateDateNumForYear(conn, year, table)
    yearString = num2str(year);
    formatIn = 'mmm dd yyyy';
    
    curs = exec(conn,['select distinct `date` from ' table '_' ...
        yearString]);
    if ~isempty(curs.Message)
        disp(curs.Message)
    end
    
    curs = fetch(curs);
    dateNums = zeros(length(curs.Data),1);
    for i=1:length(curs.Data)
        dateNums(i) = datenum([curs.Data{i} ' ' yearString],formatIn);
    end
    
    for i=1:length(dateNums)
        sqlquery = sprintf(['update %s_%d set dateNum = %d where'...
            ' `date` = "%s";'],table,year,dateNums(i),curs.Data{i});
        curs2 = exec(conn,sqlquery);
        if ~isempty(curs2.Message)
            disp(curs2.Message)
        end
    end
    
end

