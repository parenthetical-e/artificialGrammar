seq = cell(1);

for ii = 1:length(seqraw),
	seq{ii,1} = str2num(seqraw{ii,1});
end