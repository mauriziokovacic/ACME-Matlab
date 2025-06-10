function [ fig ] = display_cage( P, T, varargin )
fig = display_mesh(P,zeros(size(P)),T,[0 0 0],'wireframe',[],varargin{:});
end