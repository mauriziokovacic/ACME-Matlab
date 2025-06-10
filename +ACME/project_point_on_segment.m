function [Q,varargout] = project_point_on_segment(A,B,P)
[Q,varargout{1:nargout-1}] = project_point_on_line(A,B,P,'segment');
end