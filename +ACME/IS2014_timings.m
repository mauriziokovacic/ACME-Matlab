function [t] = IS2014_timings(filename)
fileID = fopen(strcat(filename,'.txt'),'rt');
data   = textscan(fileID,'%s','Delimiter','\n');
fclose(fileID);
data = data{1};
data = cellfun(@(d) delete_non_relevant(d), data, 'UniformOutput', false );
data = erase_empty(data);
data = cellfun(@(d) extract_duration(d), data, 'UniformOutput', false );
data = cell2mat(data);
data = data / 1000;
t = min(mean(data),median(data));
end


function [CData] = delete_non_relevant(CData)
if(~contains(CData,'IS2014'))
    CData = [];
end
end

function [CData] = extract_duration(CData)
CData = strsplit(CData,' ');
CData = str2double(CData{end});
end