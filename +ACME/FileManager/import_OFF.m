function [P,F,E] = import_OFF(filename)
[P,F,E] = import_from_file(filename,'off',@readDataFcn);
end

function [P,F,E] = readDataFcn(fileID)
    P = [];
    F = [];
    E = [];
    data = textscan(fileID,'%s','Delimiter',newline);
    data = data{1};
    data(cellfun(@(c) strcmp(c(1),'#'),data)) = [];
    if(~strcmpi(data{1},'OFF'))
        fclose(fileID);
        error('File is not a valid OFF.');
    end
    s  = sscanf(data{2}, '%u %u %u', [3 1])';
    P  = cell2mat(cellfun(@(c) sscanf(c,'%f %f %f',[3 1])',data(3:2+s(1)),'UniformOutput',false));

    x = @(s) strsplit(s,' ');
    m = @(d) cellfun(@(c) str2double(c),d(2:end));
    F = cellfun(@(c) m(x(c))+1,data(2+s(1)+1:2+s(1)+s(2)),'UniformOutput',false);
    F = poly2compact(F);
    
    E  = cell2mat(cellfun(@(c) sscanf(c,'%u %u',[2 1])',data(end-s(3)+1:end),'UniformOutput',false));
end