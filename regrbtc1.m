%regrbtc1
%(C)Antoni Wilinski 2014
%skypt poczatkowy dla doktorantów - 

%dane - szereg czasowy para walutowa eurusd próblowana co godzine 
%7313 razy do 26 marca 2013;
%Dane maja postaæ macierzy C, w której C(:,[3:6]) to OHLC
%regr2 - badanie optymalnych parametrów %
%w przestrzeni 2 wym - liczba kroków wstecz i stopieñ  wielomianu
%regrbtc1 - z regr2 dla btc jeden szereg danych

clear all


%btcusd1d230218;
%btcusd1d230218;
btcusdd250125;
M=size(C)

C1=C;
C1(:,4)=C(:,1);
C1(:,1)=C(:,2);
C1(:,2)=C(:,3);
C1(:,3)=C(:,4);
C=C1;


kwst=11;  %liczba kroków wstecz dla ustalenia okna aproksymacji
n=1;   %stopien wielomianu aproksymujacego wybrany fragment szeregu czasowego
rec=-1000;

spread=30;  %w USD, tylko dla gie³d o duzej p³ynnosci
SL=50;

for k1=5:5
    kwst=3*k1;
    
    for k2= 1:2
        n=k2;
        
Zs(24)=0;      
for i=25:2000
    Y=C(i-kwst:i-1,1); %fragment funkcji wyjscia (Close)
    [p,S]=polyfit([i-kwst:i-1],Y',n);
    [Ym,delta]=polyval(p, i-kwst:i-1, S); %Ym - model zmiennej zaleznej
    %e=Ym-C(i-kwst:i-1,6)'; %wektor b³edów pomiêdzy Ym a rzeczywistym przebiegiem Y
    %K1(i)=sum(abs(e)); %kryterium dopasowania modelu do rzeczywistego przebiegu
    [Yp,delta]=polyval(p, i-kwst:i, S);
    D1(i)=sign(Yp(end)-Y(end)); %decyzja o otwarciu pozycji d³ugiej lub krótkiej
    if D1(i)>0   %long
        Z1(i)=C(i,4)-C(i-1,4)-spread;
        if C(i-1,4)-C(i,3)>SL
            Z1(i)=-SL;
        end
    else
        Z1(i)=-C(i,4)+C(i-1,4)-spread;  %short
    
    if -C(i-1,4)+C(i,2)>SL
            Z1(i)=-SL;
    end
    end
    %Zs(i)=sum(Z1(1:i));
    Zs(i)=Zs(i-1)+Z1(i);
end
wyn(k1,k2)=Zs(end);

if wyn(k1,k2)>rec
    rec=wyn(k1,k2)
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
title('Cumulative Profit for BTCUSD1d')
hold on

