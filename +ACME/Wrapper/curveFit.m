function [P] = curveFit(P,varargin)
expectedFitting = {'linear','poly','spline'};
parser = inputParser;
addRequired(parser,'Point',@(data) isnumeric(data)&&(row(P)>=2));
addParameter(parser,'Degree',10,@(data) isscalar(data)&&(data>=0));
addParameter(parser,'Samples',row(P),@(data) isscalar(data)&&(data>0));
addOptional( parser, 'Fitting',expectedFitting{2}, @(x) any(validatestring(x,expectedFitting)))
parse(parser,P,varargin{:});

P    = parser.Results.Point;
D    = parser.Results.Degree;
n    = parser.Results.Samples;
type = parser.Results.Fitting;

x = curve2param(P);
t = linspace(0,1,n)';
switch type
    case 'linear'
        P = interp1(x,P,t,'linear');
    case 'poly'
        x = cell2mat(arrayfun(@(i) polyfit(x,P(:,i),D),(1:col(P))','UniformOutput',false));
        P = cell2mat(arrayfun(@(i) polyval(x(i,:),t),(1:col(P)),'UniformOutput',false));
    case 'spline'
        P = cell2mat(arrayfun(@(i) pchip(x,P(:,i),t),(1:col(P)),'UniformOutput',false));
end
end

