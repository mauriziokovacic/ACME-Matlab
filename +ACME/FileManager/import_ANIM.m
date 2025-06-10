function [Frame] = import_ANIM( filename )
format = '%u %u %f %f %f %f %f %f %f %f %f %f %f %f\n';
fileID = fopen(strcat(filename,'.anim'),'r');
P = fscanf( fileID, format,  [14 Inf] )';
fclose(fileID);
F = P(:,1);
I = P(:,2)+1;
P = P(:,3:end);

for i = 1 : size(F,1)
   Frame{F(i)}(I(i),:) = P(i,:); 
end

end