function dataset = genDataRandPermSparse(T, N)
% generating training data for the Schmidhuber random permutation task, 
% in the Sutskever/Martens reading.
% T is length of a run, N is nr of datastrings 
% output dataset is a structure with N elements, each of which is a sparse
% input and target matrix

dataset=zeros(T, 200, N);
%dataset = cell(1,N);
for i = 1:N
    % initialize I/O data
    thisIO = zeros(T,200);
    % create pure distractor symbol sequence
    symbols = randi([3, 100],T,1);
    % decide whether 1 or 2 is first/last element
    choice = randi([1, 2]);
    symbols(1) = choice;
    
    
    % fill inputs
    for t = 1:T
        thisIO(t,symbols(t)) = 1;
    end
    % fill outputs
    for t = 1:T
        if  t == T
            thisIO(end,100+choice) = 1;
        else 
            thisIO(t,100+symbols(t+1)) = 1;        
        end
        
    end
 %   thisIO1 = sparse(thisIO);
    dataset(:, :,i) = thisIO;
end
