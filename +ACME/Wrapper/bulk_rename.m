function bulk_rename(path,oldpattern,newpattern,renumber,offset)
if((nargin<5)||isempty(offset))
    offset = 0;
end
if((nargin<4)||isempty(renumber))
    renumber = false;
end
filename = dir([path,filesep,'*']);
filename = extractfield(filename,'name')';
pattern = strrep(regexptranslate('escape',oldpattern),'%d','\d+');
filename(cellfun('isempty',...
                 cellfun(@(s) regexp(s,pattern),...
                         filename,...
                         'UniformOutput',false))) = [];
file = cell(row(filename),3);
for i = 1 : row(filename)
    [~,file{i,1},file{i,3}] = fileparts(filename{i});
end
n = cellfun(@(s) sscanf(s,oldpattern),file(:,1));
if(renumber)
    n = reindex(n) + offset;
end
n = num2str(n);
n(n==' ') = '0';
newpattern = strrep(newpattern,'%d','%s');
file(:,2) = cellfun(@(s) sprintf(newpattern,s), cellstr(n),'UniformOutput',false);
arrayfun(@(i) movefile([path,filesep,file{i,1},file{i,3}],...
                       [path,filesep,file{i,2},file{i,3}]),...
              1:row(file));
% for i = 1 : row(file)
%     old = [path,'\',file{i,1},file{i,3}];
%     new = [path,'\',file{i,2},file{i,3}];
%     movefile(old,new);
% end
end