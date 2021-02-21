close all;
clc;
NP=50;
L=10;
G=100;
Pc=0.8;
Pm=0.05;
V=300;
afa=2;
C=[95,75,23,73,50,22,6,57,89,98];
W=[89,59,19,43,100,72,44,16,7,64];
f=randi([0,1],NP,L);
trace=zeros(1,G);
for k=1:G;
    Fit=zeros(1,NP);
    nf=zeros(NP,L);
    for i=1:NP;
        fit=sum(f(i,:).*W);
        TotalSize=sum(f(i,:).*C);
        if TotalSize>V
            fit=fit-afa*(TotalSize-V);
        end
        Fit(i)=fit;
    end
    maxFit=max(Fit);
    minFit=min(Fit);
    rr=find(Fit==maxFit);
    fbest=f(rr(1,1),:);
    Fit=(Fit-minFit)/(maxFit-minFit);
    sum_Fit=sum(Fit);
    fitvalue=Fit./sum_Fit;
    fitvalue=cumsum(fitvalue);
    ms=sort(rand(NP,1));
    newi=1;
    fiti=1;
    while newi<=NP;
        if (ms(newi))<fitvalue(fiti)
            nf(newi,:)=f(fiti,:);
            newi=newi+1;  
        else
            fiti=fiti+1;
        end
    end
    for i=1:2:NP
        p=rand;
        if p<Pc;
            q=randi([0,1],1,L);
            for j=1:L
                if q(j)==1
                temp=nf(i,j);
                nf(i,j)=nf(i+1,j);
                nf(i+1,j)=temp;
                end
            end
        end
    end
    for m=1:NP;
        for n=1:L
            r=rand(1,1);
            if r<Pm
                nf(m,n)=~nf(m,n);
            end
        end
    end
    f=nf;
    f(1,:)=fbest;
    trace(k)=maxFit;
end
fbest;
figure
plot(trace)
xlabel('迭代次数')
ylabel('目标函数值')
title('适应度进化曲线')

