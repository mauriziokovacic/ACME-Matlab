function [buffer] = FetchBuffers(h)
buffer.Mask     = ReadBufferMask(h);
buffer.Color    = ReadBufferColor(h);
buffer.Depth    = ReadBufferDepth(h);
buffer.Position = ReadBufferPosition(h);
buffer.Normal   = ReadBufferNormal(h);
buffer.Light    = ReadBufferLight(h);
filterSize      = 2;
buffer.SSAO     = SSAO(buffer,filterSize,1);
r               = (filterSize+1:row(buffer.SSAO)-filterSize)';
c               = (filterSize+1:col(buffer.SSAO)-filterSize)';
buffer.SSAO     = buffer.SSAO(r,c).^3;
end