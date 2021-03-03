close all;
clear variables;
clc;
D=2;
NP=50;
Xs=4;
Xx=-4;
G=100;
Pm=0.7;
alfa=2;
belta=1;
detas=0.2;
Ncl=5;
deta0=0.5*Xs;
f=rand(NP,D)*(Xs-Xx)+Xx;
%%%%%%%%%%%%
aff=zeros(1,NP);
%%%%%%%%%%%%
for m=1:NP
    aff(m)=IAmin2_func1(f(m,:));
    for n=1:NP
        S(n)=sqrt(sum((f(m,:)-f(n,:)).^2));
        if S(n)<detas
            S(n)=1;
        else
            S(n)=0;
        end
    end
    den(m)=sum(S)/NP;
    sim(m)=alfa*aff(m)-belta*den(m);
end
[Sortsim,Index]=sort(sim);
Sortf=f(Index,:);
for gen=1:G
    for m=1:NP/2
        Na=repmat(Sortf(m,:),Ncl,1);
        deta=deta0/gen;
        for n=1:Ncl
            for j=1:D
                if rand<Pm
                    Na(n,j)=Na(n,j)+(rand-0.5)*deta;
                end
                if Na(n,j)<Xx||Na(n,j)>Xs
                    Na(n,j)=rand*(Xs-Xx)+Xx;
                end
            end
        end
        Na(1,:)=Sortf(m,:);
        for i=1:Ncl
            Naaff(i)=IAmin2_func1(Na(i,:));
        end
        [SortNaaff,Index]=sort(Naaff);
        af(m,:)=Na(Index(1),:);
        afaff(m)=SortNaaff(1);
    end
    for m=1:NP/2
        for n=1:NP/2
            S(n)=sqrt(sum((af(m,:)-af(n,:)).^2));
            if S(n)<detas
                S(n)=1;
            else 
                S(n)=0;
            end
        end
        afden(m)=sum(S)/NP/2;
    end
    afsim=alfa*afaff-belta*afden;
    bf=rand(NP/2,D)*(Xs-Xx)+Xx;
    for m=1:NP/2
        bfaff(m)=IAmin2_func1(bf(m,:));
        for n=1:NP/2
            S(n)=sqrt(sum((bf(m,:)-bf(n,:)).^2));
            if S(n)<detas
                S(n)=1;
            else 
                S(n)=0;
            end
        end
        bfden(m)=sum(S)/NP/2;
    end
    bfsim=alfa*bfaff-belta*bfden;
    f=[af;bf];
    sim=[afsim,bfsim];
    [Sortsim,Index]=sort(sim);
    Sortf=f(Index,:);
    trace(gen)=IAmin2_func1(Sortf(1,:));  
end
figure;
plot(trace);
xlabel('迭代次数');
ylabel('目标函数值');
title('免疫算法');


