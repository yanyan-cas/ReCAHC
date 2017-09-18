% 5 bit Memory Task, Using ECA 
%with  zeros at the sides R and between each input bits R0
%Each bit of input represented by Ri bits 
%Making shift after each time step to reduce the interference
%Using all states of CA Iteration

clear all
addpath('../DataInput');

ruleNo = 90; %ECA rule Number
nTrain = 25;
nTest = 10;

Td = 7; % Length of distractor sequence

D = 2; % Number of input symbols

M = 5; %Length of to-be-memorized period

T = Td + 2*M;  %Total length = distractor length Td and the TBM length 5 and the results

Lin = D + 2; % Lin for the task
Lout = D + 2;

I = 16;  

R =  I * T; % R - Zeros Array, added to both sides of original input

Ri = 4;  % Ri - reducing Interference

L = 2 * R + Lin * Ri;

R0 = 0;

%%
%Transform the input

datasetTrain = genDataMem(Td, D, M, nTrain);
datasetTest = genDataMem(Td, D, M, nTest);

datasetinputTrainRaw=zeros(T, Lin*Ri, nTrain);
datasetinputTestRaw=zeros(T, Lin*Ri, nTest);

%Using Ri bits to represent 1 bit of the input
for i=1:nTrain
    for j=1:T
        for k=1:Lin
            datasetinputTrainRaw(j, (k-1)*Ri+1, i)=datasetTrain(j, k, i);
           datasetinputTrainRaw(j, (k-1)*Ri+1:k*Ri, i)=...
                                       (circshift( (datasetinputTrainRaw(j, (k-1)*Ri+1:k*Ri, i))',j-1))';
        end
    end
end

for i=1:nTest
     for j=1:T
        for k=1:Lin
            datasetinputTestRaw(j, (k-1)*Ri+1, i)=datasetTest(j, k, i);
            datasetinputTestRaw(j, (k-1)*Ri+1:k*Ri, i)=...
                          (circshift( (datasetinputTestRaw(j, (k-1)*Ri+1:k*Ri, i))',j-1))';
        end
    end
end

%Adding zeros 
datasetinputTrain=zeros(T, L, nTrain);
for i=1:nTrain
    for k=1:Lin
        datasetinputTrain(:, R+(k-1)*R0+((k-1)*Ri+1): R+(k-1)*R0+k*Ri, i)=...
                                                                 datasetinputTrainRaw(:, (k-1)*Ri+1:k*Ri, i);
    end
end

datasetinputTest=zeros(T, L, nTest);
for i=1:nTest
    for k=1:Lin
        datasetinputTest(:, R+(k-1)*R0+((k-1)*Ri+1): R+(k-1)*R0+k*Ri, i)=...
                                                                 datasetinputTestRaw(:, (k-1)*Ri+1:k*Ri, i);
    end
end

%% Training stage
%
Alltime = tic;
operationType = 'xor'; % operation tyep include or, and, xor, nadd = normalized addition

Ltime = tic;
A = zeros(L*I, T);

CAoutTrain = zeros(L*I, T*nTrain);
CATrain = zeros(L*I, T*nTrain);

for i = 1 : nTrain
    
    %the firts input as the first element of A
    initialState = datasetinputTrain(1, :, i);
    
    A1 = ECA4(ruleNo, initialState, I);
    A1_ = (A1(2:end, :))';
    A(:, 1 ) = A1_(:);
    
    %the rest input use XOR or other operation to combine with former info
    for j = 2 : T
        
        switch operationType
            case 'or'
                initialState=datasetinputTrain(j,:, i) |  A1(end,:);
            case 'and'
                initialState=datasetinputTrain(j,:, i) &  A1(end,:);
            case 'xor'
                initialState=xor(datasetinputTrain(j, :, i) , A1(end,:));
            otherwise
                initialState=datasetinputTrain(j, :, i);
        end %now we get the operated input for the second or later CA evolution
        
        A1=ECA4(ruleNo, initialState, I);
        A1_=(A1(2:end,:))';
        A(:, j)=A1_(:);
        
    end
    
    CATrain(:,(i-1)*T+1:i*T)=A;
end

CAoutTrain_Last=CATrain(1:end, :);

%Output Train Vectorization

Target = zeros(Lout, T * nTrain);

for i=1:nTrain
    output=(datasetTrain(:, Lout+1:2*Lout, i))';
    Target(:, (i-1)*T+1:i*T)=output;
end

Wout_Last= (pinv(CAoutTrain_Last')*Target')';
Learning_time=toc(Ltime);














