function separated_data = split_data(data,divisions,split_dim)


if sum(divisions(:)<0) > 1
    ME = MException('VerifyInput:BadFractions', ...
        'There are negative values in the given divisions');
    throw(ME)
end
if sum(divisions(:)) == 1
    divisions = divisions * size(data,split_dim);
    divisions_fl = floor(divisions);
    divisions_rm = divisions - divisions_fl;
    total_rm = round(sum(divisions_rm));
    for rm = 1:total_rm
        [~,i] = max(divisions_rm);
        divisions_fl(i) = divisions_fl(i)+1;
        divisions_rm(i) = 0;
    end
    divisions = divisions_fl;
elseif sum(divisions(:)) == size(data,split_dim) && isinteger(divisions)
    %Do nothing
else
    ME = MException('VerifyInput:BadFractions', ...
        'The given divisions do not sum to one OR are not intergers that sum to the size of the input data');
    throw(ME)
end

idx_cells = cell(1,ndims(data));
idx_cells(:) = {':'};

separated_data = cell(size(divisions));
for i = 1:size(data,split_dim)
    idx_cells{split_dim} = i;
    probs = divisions/sum(divisions(:));
    probs = cumsum(probs(:));
    roll = rand(1);
    assigned_idx = find(roll<probs,1);
    separated_data{assigned_idx} = cat(split_dim, separated_data{assigned_idx}, data(idx_cells{:}));
    divisions(assigned_idx) = divisions(assigned_idx) - 1;
end
end

