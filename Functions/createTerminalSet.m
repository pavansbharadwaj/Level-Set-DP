function TerminalSet = createTerminalSet(grid_x, xfMin, xfMax)

nDim = numel(xfMin);
xfMin = reshape(xfMin,1,nDim);
xfMax = reshape(xfMax,1,nDim);


TerminalSet1 = grid_x <= xfMax;
TerminalSet2 = grid_x >= xfMin;

TerminalSet = true(size(grid_x,1),1);
for i = 1:nDim
    TerminalSet = logical(TerminalSet.*TerminalSet1(:,i).*TerminalSet2(:,i));
end

TerminalSet = logical(TerminalSet);

end