function [txt] = mat2TorchLong(M)
format = ['[',repmat('%u,',1,col(M)),'],\\ ',newline];
format(end-6) = [];
M = num2cell(M-1,2);
txt = ['torch.t(torch.tensor([\ ',newline,sprintf(format,M{:}),'],dtype=torch.int,device=device));'];
end