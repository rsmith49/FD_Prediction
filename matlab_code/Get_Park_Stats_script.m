clear

tic
conn = DBConnect();

try
    curs = exec(conn,'select buildYear, stadiumName from stadium_stats;');
    if ~isempty(curs.Message)
        disp(curs.Message);
    end
    curs = fetch(curs);
    html = cell(15,1);
    for i=1:length(html)
        html{i} = webread(['http://espn.go.com/mlb/stats/parkfactor/_/year/'...
            num2str(2000+i)]);
    end
    
    for i=1:size(curs.Data,1)
        try
            factors = zeros(1,6);
            for year=max(2001,curs.Data{i,1}):2015
                
                factors = factors + parkFactorsForYear(html{year-2000},...
                    curs.Data{i,2});
                
            end
            factors = factors./(2016-max(2001,curs.Data{i,1}));
            sqlquery = sprintf(['UPDATE stadium_stats SET rFactor = %d,'...
                ' hrFactor = %d, hFactor = %d, 2BFactor = %d,'...
                ' 3BFactor = %d, bbFactor = %d where stadiumName = "%s"'],...
                factors(1), factors(2), factors(3), factors(4), factors(5),...
                factors(6), curs.Data{i,2});
            tmpCurs = exec(conn,sqlquery);
            if ~isempty(tmpCurs)
                disp(tmpCurs.Message)
            end
            
        catch e
            disp(e)
        end
            
    end
                    
catch e
    disp(e)
    disp(e.cause)
    disp(e.stack)
    disp(e.message)
end

close(conn)
toc
