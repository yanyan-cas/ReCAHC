function dataset = genDataXOR_Add(T, N)
 % Modified by marwan (fixing the total length)

% generating training data for the Schmidhuber addition task
% T is min length of addition sequence, N is Nr of generated samples
% dataset is array of size ceil(11 * T / 10) x 3 x N, where the first column
% per page contains the addition candidates, the second the trigger bits,
% and the last in its first row the total used length of the current
% series, and in its second row the required normalized sum.

%maxlength = ceil(11 * T / 10);
maxlength=T;  % Marwan add this line and ignore previous line to fix the sequence length
dataset = zeros(maxlength, 3, N);
for i = 1:N
    % compute current useful length
%    Tprime = T + ceil(rand * T / 10);
      Tprime = T; % Marwan add this line and ignore previous line to fix the sequence length
    % compute first add index
    T1 = ceil(rand * T / 10);
    T2 = ceil(rand * T / 2);
    while T1 >= T2
        T2 = ceil(rand * T / 2);
    end
    % fill first column
    dataset(1:Tprime,1,i) = randi([0 1],Tprime,1);
    
    % fill second column
    dataset(T1,2,i) = 1;
    dataset(T2,2,i) = 1;
    % fill third column
    dataset(1,3,i) = Tprime;
    arg1 = dataset(T1,1,i); arg2 = dataset(T2,1,i);
    dataset(2,3,i) =arg1+arg2 ;
end