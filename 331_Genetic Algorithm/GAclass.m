close all;
NP=50;
L=20;
G=100;
Xx=10;
Xs=0;
Pc=0.8;
Pm=0.1;
f=randi([0,1],NP,L);
track=zeros(1,G);
nf=zeros(NP,L);
for k=1:G
    x=zeros(1,NP);
    Fit=zeros(1,NP);
    for i=1:NP
        U=f(i,:);
        m=0;
        for j=1:L
            m=m+U(j)*2^(j-1);
        end
        x(i)=Xs+m*(Xx-Xs)/(2^L-1);
        Fit(i)=x(i)+10*sin(5*x(i))+7*cos(4*x(i));
    end
    minFit=min(Fit);
    maxFit=max(Fit);
    rr=find(Fit==maxFit);
    fbest=f(rr(1,1),:);
    xbest=x(rr(1,1));
    Fit=(Fit-minFit)/maxFit-minFit;
    sum_Fit=sum(Fit);
    fitvalue=Fit./sum_Fit;
    fitvalue=cumsum(fitvalue);
    ms=sort(rand(NP,1));
    fiti=1;
    newi=1;
    while newi<=NP;
        if  ms(newi)<fitvalue(fiti)
            nf(newi,:)=f(fiti,:);
            newi=newi+1;
        else
            fiti=fiti+1;
        end
    end
    for i=1:2:NP;
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
    i=1;
    while i<=round(NP*Pm)
        h=randi([1,NP],1,1);
        for j=1:round(L*Pm)
            g=randi([1,L],1,1);
            nf(h,g)=~nf(h,g);
        end
        i=i+1;
    end
    f=nf;
    f(1,:)=fbest;
    track(k)=maxFit;
end
xbest;
figure;
plot(track);
xlabel('迭代次数')
ylabel('目标函数值')
title('适应度进化曲线')
