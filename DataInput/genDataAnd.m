function dataset = genDataAnd(T, N, NoBits)
%This code has been modified by Marwan where T is the sequence length and
%the output is And for 2 Inputs has (NoBits) # of Bits
% The original Comments of the author Jaeger are below
% generating training data for the Schmidhuber addition task
%
% T is min length of addition sequence, N is Nr of generated samples
% dataset is array of size ceil(11 * T / 10) x 3 x N, where the first column
% per page contains the addition candidates, the second the trigger bits,
% and the last in its first row the total used length of the current
% series, and in its second row the required normalized sum.
% T=10;
% NoBits=3;
% N=3;
%maxlength = ceil(11 * T / 10);
dataset = zeros(T, 2*NoBits+1, N);
for i = 1:N
    % compute current useful length
    % Tprime = T + ceil(rand * T / 10);
    % compute first add index
    T1 = ceil(rand * T / 10);
    T2 = ceil(rand * T / 2);
    while T1 >= T2
        T2 = ceil(rand * T / 2);
    end
    % fill first column
    dataset(:,1:NoBits,i) = randi([0 1],T,NoBits);
    % fill second column
    dataset(T1,NoBits+1,i) = 1;
    dataset(T2,NoBits+1,i) = 1;
    % fill third column
    dataset(1,end,i) = T;
    %     a1= bi2de( dataset(T1,1:4,i),'left-msb');
    %     a2= bi2de( dataset(T2,1:4,i),'left-msb');
    dataset(2,NoBits+2:end,i) = dataset(T1,1:NoBits,i) & dataset(T2,1:NoBits,i) ;
    %     dataset(T,6:10,i) = de2bi( dataset(2,6,i),5,'left-msb');
end
end