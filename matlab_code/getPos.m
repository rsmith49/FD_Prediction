function posOut = getPos(posIn)

switch posIn
    case 'P'
        posOut = 1;
    case 'C'
        posOut = 2;
    case '1B'
        posOut = 3;
    case '2B'
        posOut = 4;
    case '3B'
        posOut = 5;
    case 'SS'
        posOut = 6;
    case 'LF'
        posOut = 7;
    case 'CF'
        posOut = 8;
    case 'RF'
        posOut = 9;
    case 'DH'
        posOut = 10;
    case 1
        posOut = 'P';
    case 2
        posOut = 'C';
    case 3
        posOut = '1B';
    case 4
        posOut = '2B';
    case 5
        posOut = '3B';
    case 6
        posOut = 'SS';
    case 7
        posOut = 'LF';
    case 8
        posOut = 'CF';
    case 9
        posOut = 'RF';
    case 10
        posOut = 'DH';
    case 11
        posOut = 'OF';
    otherwise
        posOut = [];
end