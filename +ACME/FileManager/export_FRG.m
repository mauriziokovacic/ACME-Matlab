function export_FRG(filename,data)
function writeDataFcn(fileID)
    I = '';
    for i = 1 : row(data)
        I = [I,'i ',strjoin(cellfun(@(txt) strrep(txt,' ',''),...
                            make_row(cellstr(num2str(data{i,1}))),...
                            'UniformOutput',false),...
                    ' '), newline];
    end
    
    fprintf(fileID,'%s', I );
    fprintf(fileID,['d %f',newline],cell2mat(data(:,2)));
    fprintf(fileID,['h %u',newline],cell2mat(data(:,3)));
%     H = cell2mat(arrayfun(@(i) repmat(H(i),numel(I{i}),1),(1:numel(I))','UniformOutput',false));
%     I = cell2mat(I);
%     E = [H I];
%     fprintf(fileID,['%u %u',newline], E' );
end
export_to_file(filename,'frg',@writeDataFcn);
end