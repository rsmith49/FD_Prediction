clear
tic
conn = database('MLBDaily','root','','VENDOR','MySQL');

try
   curs = exec(conn,['select distinct dateNum from player_daily_' num2str(year(today('datenum')))]);
   curs = fetch(curs);
   if ~isempty(curs.Message)
       disp(curs.Message)
   end
   
   latestDateNum = max([curs.Data{:}]);
   for i=latestDateNum:today('datenum')
       updateFDSalaries(conn,i);
   end
catch e
    disp(e)
end

close(conn)
disp('------------------------------------')
disp('------------------------------------')
disp('Finished Updating FanDuel Salaries')
toc
disp('------------------------------------')
disp('------------------------------------')
