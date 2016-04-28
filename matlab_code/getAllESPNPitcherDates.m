function dates = getAllESPNPitcherDates(html)

starts = strfind(html, '<tr ');
ends = strfind(html,'</tr>');

datesTmp = cell(length(starts),2);
count = 0;
for i=1:length(starts)
    line = html(starts(i):ends(i));
    start = strfind(line,'<td>');
    fin = strfind(line,'</td>');
    if ~isempty(start)
        datesTmp{i,1} = line(start(1)+4:fin(1)-1);
        if isempty(strfind(datesTmp{i,1},'DATE'))
            count = count+1;
            datesTmp{i,2} = 1;
        else
            datesTmp{i,2} = 0;
        end
    else
        datesTmp{i,2} = 0;
    end  
end

dates = cell(count,1);
ndx = 1;
for i=1:size(datesTmp,1)
    if datesTmp{i,2}
        dates{ndx} = datesTmp{i,1};
        ndx = ndx + 1;
    end
end
            
end