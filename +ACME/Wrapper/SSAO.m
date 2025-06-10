function [AOData] = SSAO(buffer,filterRadius,varargin)
name = fieldnames(buffer);
for i = 1 : numel(name)
    buffer.(name{i}) = padarray(buffer.(name{i}),[filterRadius filterRadius 0]);
end
s    = size(buffer.Mask);
x    = find(buffer.Mask);
% ao   = cell(numel(x),1);
filt = disk_mask(filterRadius);
filt(filterRadius+1,filterRadius+1) = 0;

[i,j] = ind2sub(s,x);
ao = arrayfun(@(a,b) pixel_ao(buffer,filt,a,b),i,j);

AOData = ones(s);
AOData(x) = ao;
for i = 1 : 3
    gauss = double(disk_mask(filterRadius*i));
    AOData = imfilter(AOData,gauss./sum(sum(gauss)),'replicate');
end
end

% function [AOData] = SSAO(buffer,filterRadius,filterSamples)
% name = fieldnames(buffer);
% for i = 1 : numel(name)
%     buffer.(name{i}) = padarray(buffer.(name{i}),[filterRadius filterRadius 0]);
% end
% s = size(buffer.Mask);
% x = find(buffer.Mask);
% ao = cell(numel(x),1);
% parfor p = 1 : numel(x)
%     filt = ones(filterRadius*2+1);%rand_kernel(filterRadius*2+1,filterSamples);
%     filt(ceil(numel(filt)/2)) = 0;
%     [i,j] = ind2sub(s,x(p));
%     ao{p} = pixel_ao(buffer,filt,i,j);
% end
% AOData = ones(s);
% AOData(x) = cell2mat(ao);
% AOData = imfilter(AOData,fspecial('disk',filterSamples),'replicate');
% end

function [ao] = pixel_ao(buffer,filt,i,j)
[dx,dy] = find(filt);
dx = dx - ceil(col(filt)/2);
dy = dy - ceil(row(filt)/2);

p = sub2ind(size(buffer.Mask),i+dx,j+dy);
p(~buffer.Mask(p)) = [];

P = reshape(buffer.Position(i,j,:),1,3);
N = reshape(buffer.Normal(i,j,:),1,3);

ao = ones(numel(p),1);
n  = 0;
for i = 1:numel(p)
    [x,y] = ind2sub(size(buffer.Mask),p(i));
    PP = reshape(buffer.Position(x,y,:),1,3);
    E = normr(PP-P);
    d = dot(E,N,2);
    if(d<0)
        continue;
    end
    ao(i) = ao(i) - d;
end
ao = mean(ao);
end