clear variables;
close all;
clc;
NP=100;
D=10;
G=500;
Pm=0.7;
alfa=1;
belta=1;
Xs=20;
Xx=-20;
detas=0.2;
Ncl=10;
deta0=1*Xs;
f=rand(NP,D)*(Xs-Xx)+Xx;
%%%%%%%%%%%%%%%%
sim=zeros(1,NP);
aff=zeros(1,NP);
den=zeros(1,NP);
Naaff=zeros(1,Ncl);
afaff=zeros(1,NP/2);
afden=zeros(1,NP/2);
bfaff=zeros(1,NP/2);
bfden=zeros(1,NP/2);
af=zeros(NP/2,D);
bf=zeros(NP/2,D);
afsim=zeros(1,NP/2);
bfsim=zeros(1,NP/2);
trace=zeros(1,G);
%%%%%%%%%%%%%%%%
for m=1:NP
    aff(m)=IAmin_func1(f(m,:));
    Sum=0;
    for i=1:NP
        sum=0;
        for j=1:D
            sum=sum+(f(m,j)-f(i,j))^2;
        end
        sum=sqrt(sum);
        if sum<detas
            S=1;
        else
            S=0;
        end
        Sum=Sum+S;
    end
    den(m)=Sum/NP;
    sim(m)=alfa*aff(m)-belta*den(m);
end
[Sortsim,Index]=sort(sim);
Sortf=f(Index,:);
for gen=1:G
    for i=1:NP/2
        a=Sortf(i,:);
        Na=repmat(a,Ncl,1);
        deta=deta0/gen;
        for m=1:Ncl
            for n=1:D
                if rand<Pm
                    Na(m,n)=Na(m,n)+(rand-0.5)*deta;
                end
                if (Na(m,n)<Xx)||(Na(m,n)>Xs)
                    Na(m,n)=rand*(Xs-Xx)+Xx;
                end
            end
        end
        Na(1,:)=Sortf(i,:);
        for j=1:Ncl
            Naaff(j)=IAmin_func1(Na(j,:));
        end
        [NaaffSort,Index]=sort(Naaff);
        afaff(i)=NaaffSort(1);
        af(i,:)=Na(Index(1),:); 
    end
    for m=1:NP/2
        Sum=0;
        for n=1:NP/2
            sum=0;
            for j=1:D
                sum=sum+(af(m,j)-af(i,j))^2;
            end
            sum=sqrt(sum);
            if sum<detas
                S=1;
            else
                S=0;
            end
            Sum=Sum+S;
        end
        afden(m)=Sum/NP;
        afsim(m)=alfa*afaff(m)-belta*afden(m);
    end
    bf=rand(NP/2,D)*(Xs-Xx)+Xx;
    for m=1:NP/2
        bfaff(m)=IAmin_func1(bf(m,:));
        Sum=0;
        for i=1:NP
            sum=0;
            for j=1:D
                sum=sum+(f(m,j)-f(i,j))^2;
            end
            sum=sqrt(sum);
            if sum<detas
                S=1;
            else
                S=0;
            end
            Sum=Sum+S;
        end
        bfden(m)=Sum/NP;
        bfsim(m)=alfa*bfaff(m)-belta*bfden(m);
    end
    sim=[afsim,bfsim];
    f=[af;bf];
    [Sortsim,Index]=sort(sim);
    Sortf=f(Index,:);
    trace(gen)=IAmin_func1(Sortf(1,:));
end
figure;
plot(trace);
xlabel('迭代次数');
ylabel('目标函数进化曲线')
title('免疫算法')

