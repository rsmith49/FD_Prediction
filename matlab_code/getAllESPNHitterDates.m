function dates = getAllESPNHitterDates(html)

locs = strfind(html, 'td align="left">');
dates = cell(length(locs),1);
for i=1:length(locs)
    endOffset = strfind(html(locs(i):end), '</td>');
    endOffset = endOffset(1);
    dates{i} = html(locs(i)+16:locs(i)+endOffset-2);
end

