function [AData] = ReadBufferAngle(h,MData,Direction)
if((nargin<2)||isempty(MData))
    MData = BufferMask(h);
end
if((nargin<3)||isempty(Direction))
    Direction = get_camera_direction(h);
end
NData     = color2normal(color2double(BufferNormal(h))).*MData;
Direction = reshape(Direction,1,1,3);
AData     = sum(NData .* Direction,3);
end