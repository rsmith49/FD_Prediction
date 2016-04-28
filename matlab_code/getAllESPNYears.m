% years(end) is the earliest year
function years = getAllESPNYears(html)

ends = strfind(html, '</option>');
years = zeros(length(ends)-1,1);

for i=2:length(ends)
    years(i-1) = str2num(html(ends(i)-4:ends(i)-1));
end