function [NData] = fetchNormalData(NBuffer,bufferIndex)
[NData] = color2normal(color2double(fetchBufferData(NBuffer,bufferIndex)));
end