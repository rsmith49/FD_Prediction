function dateStr = getDateStr(dateNum)

switch month(dateNum)
    case 1
        monthStr = 'Jan';
    case 2
        monthStr = 'Feb';
    case 3
        monthStr = 'Mar';
    case 4
        monthStr = 'Apr';
    case 5
        monthStr = 'May';
    case 6
        monthStr = 'Jun';
    case 7
        monthStr = 'Jul';
    case 8
        monthStr = 'Aug';
    case 9
        monthStr = 'Sep';
    case 10
        monthStr = 'Oct';
    case 11
        monthStr = 'Nov';
    case 12
        monthStr = 'Dec';
    otherwise
        monthStr = 'What';
end

dateStr = [monthStr ' ' num2str(day(dateNum))];