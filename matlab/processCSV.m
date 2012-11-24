
Xin = textread('import.dat', '%s', 'delimiter', '\n');

[Xiny, Xinx] = size(Xin);
X = [];
for i=1:Xiny

input = cell2mat(Xin(i,:));
TargetVar = regexp(input,',','split');
X = [X;TargetVar];
end
yin = X(:,1);
X(:,1) = [];

y = ones(Xiny,1);
for i=1:Xiny
	input = cell2mat(yin(i));
	y(i) = str2num(input);
end

save('var.mat','X','y');
