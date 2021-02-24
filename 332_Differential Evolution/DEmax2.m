%��ɢ��ֽ�����������ֵ
%��ʼ��
close all;
clc;
NP=20;
D=2;
G=100; 
F=0.5;
%����Ӧ��ֽ����㷨�������0.4-0.8.һ��ѡȡ0.4����ɢ��ֽ����㷨����ͳ��ֽ����㷨ѡ��0.5
CR=0.1;
Xs=100;
Xx=-100;
%����ֵ
f=randi([Xx,Xs],NP,D);
Fit=zeros(1,NP);
NFit=zeros(1,NP);
v=zeros(NP,D);
u=zeros(NP,D);
trace=zeros(1,G);
%�����һ����Ⱥ����Ӧ��
for m=1:NP
    Fit(m)=-((f(m,1)^2+f(m,2)-1)^2+(f(m,1)+f(m,2)^2-7)^2)/200+10;
end
%��ֽ����㷨ѭ����ʼ
for k=1:G
    %���������ѡȡr1��r2��r3
    for m=1:NP
        a=randperm(NP,3);
        r1=a(1);
        r2=a(2);
        r3=a(3);
        v(m,:)=floor(f(r1,:)+F*(f(r2,:)-f(r3,:)));
    end
    %�������
    r=randi([1,D],1,NP);
    for m=1:NP
        for n=1:D
            cr=rand(1);
            if cr<CR||n==r(m)
                u(m,n)=v(m,n);
            else
                u(m,n)=f(m,n);
            end
        end
    end
    %�߽���������,�������߽��ֵ�����ڽ�ռ����������һ��ֵ��
    for m=1:NP
        for n=1:D
            if u(m,n)>Xs||u(m,n)<Xx
                u(m,n)=floor(rand*(Xs-Xx)+Xx);
            end
        end
    end
    %������콻�������Ⱥ�������Ӧ��
    for m=1:NP
        NFit(m)=-((u(m,1)^2+u(m,2)-1)^2+(u(m,1)+u(m,2)^2-7)^2)/200+10;
    end
    %��ÿһ������һ����ѡ�����
    for m=1:NP
        if NFit(m)>Fit(m)
            f(m,:)=u(m,:);
        end
    end
    %����ѡ�������Ⱥ����Ӧ��
    for m=1:NP
        Fit(m)=-((f(m,1)^2+f(m,2)-1)^2+(f(m,1)+f(m,2)^2-7)^2)/200+10;
    end
    %��¼���ֵ���������ڴ����޹ر���
    trace(k)=max(Fit);
    clear a cr r r1 r2 r3
end
[SortFit,Index]=sort(Fit);
f=f(Index,:);
xbest=f(NP,1);
ybest=f(NP,2);
zbest=SortFit(1,NP);
clear k m n 
figure;
plot(trace);
title('��Ӧ�Ƚ�������');