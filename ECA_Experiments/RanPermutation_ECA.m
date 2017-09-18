% Random Permutation Task, Using ECA 
%with  zeros at the sides R and between each input bits R0
%Each bit of input represented by Ri bits 
%Making shift after each time step to reduce the interference
%Using all and Last states of CA Iterationsfor predection

clear all
%addpath('../DataInput');
ruleNo = 90;

Lin = 100; %input length
Lout = 100;

Ntrain = 700;
Ntest = 100;

T = 1000;
I = 1;
R = round(I*T); %An array of zeros with length of R (buffers), hold the activity of the reservoir correspoonding to previous time steps

Ri = 1;
R0 = 0;

L = 2*R + Lin + (Lin-1)*R0;

datasetTrain = genDataRandPermSparse(T, Ntrain);
datasetTest = genDataRandPermSparse(T, Ntest);

datasetinputTrainRaw=zeros(T, Lin*Ri, Ntrain);
datasetinputTestRaw=zeros(T, Lin*Ri, Ntest);

for i=1:Ntrain
    for j=1:T
        for k=1:Lin
            datasetinputTrainRaw(j, (k-1)*Ri+1, i)=datasetTrain(j, k, i);
            datasetinputTrainRaw(j, (k-1)*Ri+1:k*Ri, i)=...
                                       (circshift( (datasetinputTrainRaw(j, (k-1)*Ri+1:k*Ri, i))',j-1))';
        end
    end
end

for i=1:Ntest
     for j=1:T
        for k=1:Lin
            datasetinputTestRaw(j, (k-1)*Ri+1, i)=datasetTest(j, k, i);
            datasetinputTestRaw(j, (k-1)*Ri+1:k*Ri, i)=...
                          (circshift( (datasetinputTestRaw(j, (k-1)*Ri+1:k*Ri, i))',j-1))';
        end
    end
end


datasetinputTrain=zeros(T, L, Ntrain);
for i=1:Ntrain
    for k=1:Lin
        datasetinputTrain(:, R+(k-1)*R0+((k-1)*Ri+1): R+(k-1)*R0+k*Ri, i)=...
                                                                 datasetinputTrainRaw(:, (k-1)*Ri+1:k*Ri, i);
    end
end

datasetinputTest=zeros(T, L, Ntest);
for i=1:Ntest
    for k=1:Lin
        datasetinputTest(:, R+(k-1)*R0+((k-1)*Ri+1): R+(k-1)*R0+k*Ri, i)=...
                                                                 datasetinputTestRaw(:, (k-1)*Ri+1:k*Ri, i);
    end
end

Alltime=tic;
operation_type='xor';  % operation type: or, and, xor, nadd=normalized addition

% 1- Training Stage
Ltime=tic;
A=zeros(L*I, T);

CAoutTrain=zeros(L*I*T,  Ntrain);
CATrain=zeros(L*I,  Ntrain);

for i=1:Ntrain
    initialstate=datasetinputTrain(1, :, i);
     A1=ECA4(ruleno, initialstate, I);
     A1_=(A1(2:end,:))';
     A(:, 1 )=A1_(:);
    %CAoutTrain_Last(:, (i-1)*T+1)=(A1(end,:))';
      for j=2:T
        switch operation_type
            case 'or'
                initialstate=datasetinputTrain(j,:, i) |  A1(end,:);
            case 'and'
                initialstate=datasetinputTrain(j, :, i) &  A1(end,:);
            case 'xor'
                initialstate=xor(datasetinputTrain(j, :, i) , A1(end,:));
            case 'nadd'    % Using Normalized Addition
                a=datasetinputTrain(j, :, i);
                b=A1(end,:);
                for k=1:L
                    if (a(1,k)~=b(1,k));
                        initialstate(1,k)=randi([0,1]);
                    else
                        initialstate(1,k)=  a(1,k) | b(1,k);
                    end
                end
            otherwise
                initialstate=datasetinputTrain(j, :, i);
%      if ((j==2) | (j==3))
%          O=ones(1, R);
%          A2(1, :)=A1(end, :) & [O [ 0 0 0 0 0 0 0] O];
%          initialstate=xor(datasetinputTrain(j, :, i) , A2(1,:));
%      else
%          initialstate=xor(datasetinputTrain(j, :, i) , A1(end,:));
%      end
                % initialstate=xor(xor(xor(datasetTrain(j, 1:L, i)), A1(I+1,:)), A1(I,:)), A1(I-1,:));
                % initialstate=dataset(j, 1:L, i)|A1(I+1,:)&A1(I,:)|A1(I-1,:)
        end
        A1=ECA4(ruleno, initialstate, I);
        A1_=(A1(2:end,:))';
        A(:, j)=A1_(:);
        %CAoutTrain_Last(:,(i-1)*T+j)=(A1(end,:))';
      end
    
    CAoutTrain(:,i)=A(:);
    CATrain(:,i)=A(:, T);
end

  





