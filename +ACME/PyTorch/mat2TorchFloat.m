function [txt] = mat2TorchFloat(M)
format = ['[',strjoin(repmat({'%f'},1,col(M)),', '),']'];
format = ['            ',format,',',newline];
format(end-6) = [];
M = num2cell(M,2);
txt = ['FloatTensor([',newline,sprintf(format,M{:}),'        ], device=''cpu'')'];
end