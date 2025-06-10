function [SData] = import_SGM( filename )
formatN = 'n %u\n';
formatS = 's %u %u %f %f %f %f\n';

fileID = fopen(strcat(filename,'.sgm'),'r');
n = fscanf( fileID, formatN, [1 1  ] );
S = fscanf( fileID, formatS, [6 Inf] )';
fclose(fileID);

I = S(:,1)+1;
T = S(:,2)+1;
A = [S(:,3:4) 1-sum(S(:,3:4),2)];
B = [S(:,5:6) 1-sum(S(:,5:6),2)];

SData = cell(n,1);
% SData = cellfun(@(c) struct('A',[],'B',[],'T',[]),SData);

ID = unique(I);
for i = 1 : numel(ID)
    j = find(I==ID(i));
    SData(ID(i)).A = A(j,:); 
    SData(ID(i)).B = B(j,:);
    SData(ID(i)).T = T(j,:);
end

end