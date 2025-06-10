function [P] = bresenham(X,Y)
x1    = round(X(1));
x2    = round(X(2));
y1    = round(Y(1));
y2    = round(Y(2));
dx    = abs(x2-x1);
dy    = abs(y2-y1);
steep = dy>dx;
if( steep )
    [dx,dy] = swap(dx,dy);
end
if( dy == 0 ) 
    q = zeros(dx+1,1);
else
    q = cumsum([0;diff(mod((floor(dx/2):-dy:-dy*dx+floor(dx/2))',dx))>=0]);
end
if( steep )
    [y,x] = compute_pixel(y1,y2,x1,x2,q);
else
    [x,y] = compute_pixel(x1,x2,y1,y2,q);
end
P = [x,y];
end

function [a,b] = compute_pixel(a1,a2,b1,b2,q)
a = linspace(a1,a2,abs(a1-a2)+1)';
b = b1 + (1-2*(b1>b2)) .* q;
end