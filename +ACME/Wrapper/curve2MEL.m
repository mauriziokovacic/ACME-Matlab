function [mel] = curve2MEL(P)
mel = 'curve -d 3';
for i = 1 : row(P)
    mel = [mel,' -p ',num2str(P(i,:),'%f %f %f')];
end
mel = [mel,';',newline];
end