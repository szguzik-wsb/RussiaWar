%regrbtc2
%(C)Antoni Wilinski 2025

%dane - szereg czasowy para BTCUSD do 25.01.25 1d od 
%7313 razy do 26 marca 2013;
%Dane maja postaæ macierzy C, w której œwieca ma kolejnoœæ COHL + Vol
%regreth1 - dane od do 26.01.25

warning off

clear all


%btcusd1d230218;
ethusd260125;  %dane z Investing.com
M=size(C)

%poni¿ej, ustawienie wyrazów w ka¿dym wierszu w kolejnoœci OHLC - innej ni¿
%oryginalna

C1=C;
C1(:,4)=C(:,1);
C1(:,1)=C(:,2);
C1(:,2)=C(:,3);
C1(:,3)=C(:,4);
C=C1;


kwst=15;  %liczba kroków wstecz dla ustalenia okna aproksymacji
n=1;   %stopien wielomianu aproksymujacego wybrany fragment szeregu czasowego
rec=-1000000;
SL=15;

spread=5;  %w USD, tylko dla gie³d o duzej p³ynnosci; 5 usd wg https://www.tms.pl/rynek/wykresy/ETHUSD

for k1=5:5
    kwst=3*k1;
    
    for k2= 1:1
        n=k2;
        
Zs(24)=0;      
for i=25:1500
    Y=C(i-kwst:i-1,4); %fragment funkcji wyjscia (Close)
    [p,S]=polyfit([i-kwst:i-1],Y',n);
    [Ym,delta]=polyval(p, i-kwst:i-1, S); %Ym - model zmiennej zaleznej
    %e=Ym-C(i-kwst:i-1,6)'; %wektor b³edów pomiêdzy Ym a rzeczywistym przebiegiem Y
    %K1(i)=sum(abs(e)); %kryterium dopasowania modelu do rzeczywistego przebiegu
    [Yp,delta]=polyval(p, i-kwst:i, S);
    D1(i)=sign(Yp(end)-Y(end)); %decyzja o otwarciu pozycji d³ugiej lub krótkiej
    if D1(i)>0
        Z1(i)=C(i,4)-C(i-1,4)-spread;
        if C(i-1,4)-C(i,3)>SL
            Z1(i)=-SL;
        end
    else
        Z1(i)=-C(i,4)+C(i-1,4)-spread;
         if -C(i-1,4)+C(i,2)>SL
            Z1(i)=-SL;
        end
    end
    %Zs(i)=sum(Z1(1:i));
    Zs(i)=Zs(i-1)+Z1(i);
end
wyn(k1,k2)=Zs(end);

if wyn(k1,k2)>rec
    rec=wyn(k1,k2);
    paropt=[k1 k2]
    Zrec=Zs;
end

    end %k1
end  %k2

m1=size(Zrec);
maxZ=-11;
mdd=0;
for i=1:m1(2)
    if Zrec(i)>maxZ
        maxZ=Zs(i);
    end
    if (maxZ-Zrec(i))>mdd
        mdd=maxZ-Zrec(i);
    end
end

Calmar=Zrec(end)/mdd

rec
paropt

figure(1)
plot(Zrec,'LineWidth', 3)
title('Cumulative Profit for ETHUSD1d')
hold on
grid on




