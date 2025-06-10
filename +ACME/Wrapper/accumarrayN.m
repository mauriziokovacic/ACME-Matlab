function [Output] = accumarrayN(I,V,varargin)
% Output = cell(1,col(V));
% for i = 1 : col(Value)
%     Output{i} = accumarray(I,V(:,i),varargin{:});
% end
% Output = cell2mat(Output);


Output = accumarray([repmat(I,col(V),1) repelem((1:col(V))',numel(I),1)],...
    V(:),...
    varargin{:});

end