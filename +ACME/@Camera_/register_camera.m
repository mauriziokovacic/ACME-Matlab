function [obj] = register_camera(obj,h)
obj = obj.register_position(h);
obj = obj.register_target(h);
obj = obj.register_upvector(h);
obj = obj.register_viewangle(h);
obj = obj.register_xlim(h);
obj = obj.register_ylim(h);
obj = obj.register_zlim(h);
obj.Path = obj.Path+1;
end