function dataset = genDataTempOrder3Sym(T, N)
% generating training data for the Schmidhuber temporal order (3 symbols) 
% task. 
%
% T is length of sequence, N is Nr of generated samples
% dataset is array of size T x 14 x N, where the first 6 columns
% contain the input, the last 8 contain the target output (only given 
% at the last timestep)


dataset = zeros(T, 14, N);
for i = 1:N
    
    % create pure distractor symbol sequence
    symbols = randi([3, 6],T,1);
    % choose insertion indices for special symbols
    t1 = randi([T/10, T/5]);
    t2 = randi([3*T/10, 4*T/10]);
    t3 = randi([6*T/10, 7*T/10]);
    % choose temporal order case
    orderCase = randi([1, 8]);
    % insert special symbols
    if orderCase == 1
        symbols([t1 t2 t3],1) = [1 1 1]';
    elseif orderCase == 2
        symbols([t1 t2 t3],1) = [1 1 2]';
    elseif orderCase == 3
        symbols([t1 t2 t3],1) = [1 2 1]';
    elseif orderCase == 4
        symbols([t1 t2 t3],1) = [1 2 2]';
    elseif orderCase == 5
        symbols([t1 t2 t3],1) = [2 1 1]';
    elseif orderCase == 6
        symbols([t1 t2 t3],1) = [2 1 2]';
    elseif orderCase == 7
        symbols([t1 t2 t3],1) = [2 2 1]';
    elseif orderCase == 8
        symbols([t1 t2 t3],1) = [2 2 2]';
    end 
    % fill inputs
    for t = 1:T
        dataset(t,symbols(t),i) = 1;
    end
    % fill output
    dataset(T,6+orderCase,i) = 1;
end