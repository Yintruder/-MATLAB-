close all;
clear variables;
clc;
NP=200;
G=100000;
Ncl=10;
detas=5;
alfa=1;
belta=1;
Pm=0.5;
C=[1304 2321;3639 1315;4177 2244;3712 1399;3488 1535;3326 1556;3238 1229;...
    4196 1044;4312 790;4386 570;3007 1970;2562 1756;2788 1491;2381 1676;...
    1332 695;3715 1678;3918 2179;4061 2370;3780 2212;3676 2578;4029 2838;...
    4263 2931;3429 1908;3507 2376;3394 2643;3439 3201;2935 3240;3140 3550;...
    2545 2357;2778 2826;2370 2975];
N=size(C,1);
D=zeros(N);
f=zeros(NP,N);
aff=zeros(1,NP);
den=zeros(1,NP);
sim=zeros(1,NP);
afaff=zeros(1,NP/2);
af=zeros(NP/2,N);
Na=zeros(Ncl,N);
Naaff=zeros(1,Ncl);
for i=1:N   %求出任意两城市之间的距离
    for j=1:N
        D(i,j)=sqrt(sum((C(i,:)-C(j,:)).^2));
    end
end
for i=1:NP  %初始化种群
    f(i,:)=randperm(N);
end
for m=1:NP  %求出每个个体的激励度
    aff(m)=D(f(m,N),f(m,1));
    for n=1:N-1
        aff(m)=aff(m)+D(f(m,n),f(m,n+1));
    end
    for n=1:NP
        for i=1:N
            if f(m,i)==f(n,i)
                Sum_2(i)=1;
            else
                Sum_2(i)=0;
            end
        end
        Sum_1(n)=sum(Sum_2);
        if Sum_1(n)>detas
            Sum_1(n)=1;
        else 
            Sum_1(n)=0;
        end
    end
    den(m)=sum(Sum_1)/NP;
    sim(m)=alfa*aff(m)-belta*den(m);
end
[Sortsim,Index]=sort(sim);
Sortf=f(Index,:);
for gen=1:G
    for m=1:NP/2
        Na=repmat(Sortf(m,:),Ncl,1);
        for n=1:Ncl
                if rand<Pm
                    a=randperm(N,2);
                    a1=a(1);
                    a2=a(2);
                    tem=Na(n,a1);
                    Na(n,a1)=Na(n,a2);
                    Na(n,a2)=tem;
                end
        end
        Na(1,:)=Sortf(m,:);
        for n=1:Ncl  %求出克隆种群中每个个体的亲和度
            Naaff(n)=D(Na(n,N),Na(n,1));
                for p=1:N-1
                    Naaff(n)=Naaff(n)+D(Na(n,p),Na(n,p+1));
                end
        end
        [SortNaaff,Index]=sort(Naaff);
        afaff(m)=SortNaaff(1);
        af(m,:)=Na(Index(1),:);
    end
    for i=1:NP/2
        bf(i,:)=randperm(N);
    end
    for i=1:NP/2  %求出刷新种群中每个个体的亲和度
        bfaff(i)=D(bf(i,N),bf(i,1));
        for p=1:N-1
            bfaff(i)=bfaff(i)+D(bf(i,p),bf(i,p+1));
        end
    end
    f=[af;bf];
    aff=[afaff,bfaff];
    [Sortaff,Index]=sort(aff);
    Sortf=f(Index,:);
    trace(gen)=Sortaff(1);
    R=Sortf(1,:);
end
figure;
plot(trace);
figure
for i=1:N-1
    plot([C(R(i),1),C(R(i+1),1)],[C(R(i),2),C(R(i+1),2)],'bo-')
    hold on;
end

    
        
                 
        
