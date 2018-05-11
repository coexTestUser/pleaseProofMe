
name = '###';

N = max(A(:,1)); 
M = length(A(:,1));
T = max(A(:,2));

for a=1:N
    collect.fil{a} = [];
end

for b=1:M
    collect.fil{A(b,1)} = [collect.fil{A(b,1)}; A(b,:)];
end

B1 = zeros(N,1);

for c=1:N
    if ~isempty(collect.fil{c})
        B1(c,1) = c;
    end
end

B1 = B1(find(B1));
N1 = length(B1);

B2 = zeros(N1,1);
NonMov =zeros(N1,1);

for d=1:N1
    e = B1(d,1);
    P.tr{e}.x = collect.fil{e}(:,3); P.tr{e}.y = collect.fil{e}(:,4);
    P.tr{e}.dx = (diff(P.tr{e}.x)); P.tr{e}.dy = (diff(P.tr{e}.y));
    S.tr{e} = (((P.tr{e}.dx).^2)+((P.tr{e}.dy).^2)).^(1/2);
    S.tot{e} = mean(S.tr{e});
    NonMov(d,1) = S.tot{e};
end

NonMov = NonMov(find(NonMov));
MaxVel = max(NonMov);

for d=1:N1
    e = B1(d,1);
    if S.tot{e} > 2 
        B2(d,1) = e;
    end
end

B2 = B2(find(B2));
N2 = length(B2); clear NonMov;

B3 = zeros(N2,1);
Circ = zeros(N2,2);

for f=1:N2
    g = B2(f,1);
    C.x{f} = sum(P.tr{g}.dx); C.y{f} = sum(P.tr{g}.dy);
    C.tot{f} = (((C.x{f}).^2)+((C.y{f}).^2)).^(1/2);
    Circ(f,1:2) = [C.tot{f}/length(P.tr{g}.dx) length(P.tr{g}.dx)];
end

for f=1:N2
    g = B2(f,1);
    if ((C.tot{f}/length(P.tr{g}.dx)) <= 1.5) && (length(P.tr{g}.dx) >= 10)
        B3(f,1) = 0;
    else
        B3(f,1) = g;
    end
end

B3 = B3(find(B3));
N3 = length(B3); clear Circ;

LEN = zeros(N3,1);

for h=1:N3
    i=B3(h,1);
    SELECT.fil{h} = [collect.fil{i}(:,3) collect.fil{i}(:,4) collect.fil{i}(:,2) collect.fil{i}(:,5)];
    LEN(h,1) = length(SELECT.fil{h}(:,1));
end


clear A AA C L LEN M N N1 N2 N3 P S SIZE a b c d e f g h i j k


N = length(SELECT.fil);
ST=zeros(N,N);

for a=1:N
    display(strcat('a:',num2str(a),'of',num2str(N))),
    for b=1:N
        if (a~=b) && ((max(SELECT.fil{a}(:,3))) > (min(SELECT.fil{b}(:,3)))) && ((min(SELECT.fil{a}(:,3))) < (max(SELECT.fil{b}(:,3))))
            ST(a,b) =1;
        end
    end
end

DD = zeros(N,1);
for c=1:N
    display(strcat('c:',num2str(c),'of',num2str(N))),
    D.fil{c} = [];
    for d=1:N
        if ST(c,d) == 1
            D.fil{c} = [D.fil{c};d];
        end
    end
    D.L{c} = length(D.fil{c});
    if D.L{c} > 0
        DD(c,1) = c;
    end
end

DD = DD(find(DD));

EE = [];
for e=1:length(DD)
    display(strcat('e:',num2str(e),'of',num2str(length(DD)))),
    f = DD(e,1);
    
    Lf1 = [SELECT.fil{f}(1,3)-1; NaN(T-1,1)]; Lb1 = [T - SELECT.fil{f}(end,3); NaN(T-1,1)];
    X1 = [NaN(Lf1(1,1),1); SELECT.fil{f}(:,1); NaN(Lb1(1,1),1)];
    Y1 = [NaN(Lf1(1,1),1); SELECT.fil{f}(:,2); NaN(Lb1(1,1),1)];
    Ang1 = [zeros(Lf1(1,1),1); SELECT.fil{f}(:,4); zeros(Lb1(1,1),1)];
    FIL_NUM1 = [B3(f); NaN(T-1,1)];
    
    for g=1:D.L{f}
        h = D.fil{f}(g,1);
        
        Lf2 = [SELECT.fil{h}(1,3)-1; NaN(T-1,1)]; Lb2 = [T - SELECT.fil{h}(end,3); NaN(T-1,1)];
        X2 = [NaN(Lf2(1,1),1); SELECT.fil{h}(:,1); NaN(Lb2(1,1),1)];
        Y2 = [NaN(Lf2(1,1),1); SELECT.fil{h}(:,2); NaN(Lb2(1,1),1)];
        Ang2 = [zeros(Lf2(1,1),1); SELECT.fil{h}(:,4); zeros(Lb2(1,1),1)];
        FIL_NUM2 = [B3(h); NaN(T-1,1)];
        
        R = ((X1 - X2).^2 + (Y1 - Y2).^2).^(0.5);
        
        ALL.fil{e}.FIL{g} = [X1 Y1 X2 Y2 R Ang1 Ang2 Lf1 Lb1 Lf2 Lb2 FIL_NUM1 FIL_NUM2];
        ALL.fil{e}.MIN{g} = min(R);
        
        clear Lf2 Lb2 X2 Y2 R Ang2 FIL_NUM2;
    end
    clear Lf1 Lb1 X1 Y1 Ang1 FIL_NUM1;
    EE = [EE; size(ALL.fil{e}.FIL)];
end

clear D ST a b c d e f g h ans

RI = 20; 
prelimRI = 150; 
GG = zeros(length(DD),1);

for a=1:length(DD)
    FF.fil{a} = [];
    for b=1:EE(a,2)
        if ALL.fil{a}.MIN{b} < prelimRI
            FF.fil{a} = [FF.fil{a}; b];
        end
    end
    
    if ~isempty(FF.fil{a})
        GG(a,1) = a;
    end
end

GG = GG(find(GG));
    
for c=1:length(GG)
    d = GG(c,1);
    for e=1:length(FF.fil{d})
        f = FF.fil{d}(e,1);
        INT.fil{c}.FIL{e} = ALL.fil{d}.FIL{f};
    end
end

RESULT = [];

for g=1:length(INT.fil)
    INT.fil{g}.num = length(INT.fil{g}.FIL); INT.fil{g}.COI = []; INT.fil{g}.COO = [];
    for h=1:length(INT.fil{g}.FIL)
        if (INT.fil{g}.FIL{h}(1,9) < INT.fil{g}.FIL{h}(1,11))
            x1t1 = INT.fil{g}.FIL{h}(T-1-(INT.fil{g}.FIL{h}(1,11)),1); y1t1 = INT.fil{g}.FIL{h}(T-1-(INT.fil{g}.FIL{h}(1,11)),2);
            x2t1 = INT.fil{g}.FIL{h}(T-1-(INT.fil{g}.FIL{h}(1,11)),3); y2t1 = INT.fil{g}.FIL{h}(T-1-(INT.fil{g}.FIL{h}(1,11)),4);
            x1t2 = INT.fil{g}.FIL{h}(T-(INT.fil{g}.FIL{h}(1,11)),1); y1t2 = INT.fil{g}.FIL{h}(T-(INT.fil{g}.FIL{h}(1,11)),2);
            x2t2 = INT.fil{g}.FIL{h}(T-(INT.fil{g}.FIL{h}(1,11)),3); y2t2 = INT.fil{g}.FIL{h}(T-(INT.fil{g}.FIL{h}(1,11)),4);
            x1t3 = 2*x1t2 - x1t1; y1t3 = 2*y1t2 - y1t1; x2t3 = 2*x2t2 - x2t1; y2t3 = 2*y2t2 - y2t1;
            distance = sqrt((x1t3-x2t3)^2 + (y1t3-y2t3)^2);
            if distance < RI
                INT.fil{g}.COI(h,1) = 1;
            end
            clear x1t1 y1t1 x2t1 y2t1 x1t2 y1t2 x2t2 y2t2 x1t3 y1t3 x2t3 y2t3 distance

        elseif (INT.fil{g}.FIL{h}(1,8) < INT.fil{g}.FIL{h}(1,10))
            x1t1 = INT.fil{g}.FIL{h}(2+(INT.fil{g}.FIL{h}(1,10)),1); y1t1 = INT.fil{g}.FIL{h}(2+(INT.fil{g}.FIL{h}(1,10)),2);
            x2t1 = INT.fil{g}.FIL{h}(2+(INT.fil{g}.FIL{h}(1,10)),3); y2t1 = INT.fil{g}.FIL{h}(2+(INT.fil{g}.FIL{h}(1,10)),4);
            x1t2 = INT.fil{g}.FIL{h}(1+(INT.fil{g}.FIL{h}(1,10)),1); y1t2 = INT.fil{g}.FIL{h}(1+(INT.fil{g}.FIL{h}(1,10)),2);
            x2t2 = INT.fil{g}.FIL{h}(1+(INT.fil{g}.FIL{h}(1,10)),3); y2t2 = INT.fil{g}.FIL{h}(1+(INT.fil{g}.FIL{h}(1,10)),4);
            x1t3 = 2*x1t2 - x1t1; y1t3 = 2*y1t2 - y1t1; x2t3 = 2*x2t2 - x2t1; y2t3 = 2*y2t2 - y2t1;
            distance = sqrt((x1t3-x2t3)^2 + (y1t3-y2t3)^2);
            if distance < RI
                INT.fil{g}.COO(h,1) = 1;
            end
            clear x1t1 y1t1 x2t1 y2t1 x1t2 y1t2 x2t2 y2t2 x1t3 y1t3 x2t3 y2t3 distance

        end
    end
    
    INT.fil{g}.COIandCOO = [sum(INT.fil{g}.COI) sum(INT.fil{g}.COO)];
    INT.fil{g}.CO = min(INT.fil{g}.COIandCOO); INT.fil{g}.COs = sum(INT.fil{g}.COIandCOO);
    INT.fil{g}.TOTAL = INT.fil{g}.num - INT.fil{g}.COs + INT.fil{g}.CO;
    
    RESULT = [RESULT; INT.fil{g}.TOTAL INT.fil{g}.CO];
end

clear a b c d e f g h

WHOLE = [sum(RESULT(:,1)) sum(RESULT(:,2))];  

for a=1:length(INT.fil)
    MainFil = B3(DD(GG(a)));
    CO.fil{a}.COI = []; CO.fil{a}.COO = []; CO.fil{a}.COs = [];
    if INT.fil{a}.CO > 0
        for b=1:length(INT.fil{a}.COI(:,1))
            if INT.fil{a}.COI(b,1) == 1
                CO.fil{a}.COI = [CO.fil{a}.COI; b (T-INT.fil{a}.FIL{b}(1,11))];
            end
        end
        for c=1:length(INT.fil{a}.COO(:,1))
            if INT.fil{a}.COO(c,1) == 1
                CO.fil{a}.COO = [CO.fil{a}.COO; c (INT.fil{a}.FIL{c}(1,10)+1)];
            end
        end
        
        if INT.fil{a}.COIandCOO(1,1) <= INT.fil{a}.COIandCOO(1,2) 
            for d=1:length(CO.fil{a}.COI(:,1))
                e = CO.fil{a}.COI(d,1); f = CO.fil{a}.COI(d,2);
                Income1 = [INT.fil{a}.FIL{e}(f,1)-INT.fil{a}.FIL{e}(f-1,1) INT.fil{a}.FIL{e}(f,2)-INT.fil{a}.FIL{e}(f-1,2); INT.fil{a}.FIL{e}(f,3)-INT.fil{a}.FIL{e}(f-1,3) INT.fil{a}.FIL{e}(f,4)-INT.fil{a}.FIL{e}(f-1,4)];
                Income2 = normr(Income1);
                Income3 = [(atan2(Income2(1,2),Income2(1,1)))*(180/pi) (atan2(Income2(2,2),Income2(2,1)))*(180/pi)];
                Income4 = [Income3(1) Income3(2)];
                Income5 = abs(Income4(1)-Income4(2));
                IncomeNUM =  INT.fil{a}.FIL{e}(1,13);
                IncomeTIME = T - INT.fil{a}.FIL{e}(1,11);
                
                VecLen1 = ((Income1(1,1))^2 + (Income1(1,2))^2)^(0.5); VecLen2 = ((Income1(2,1))^2 + (Income1(2,2))^2)^(0.5);
                P1 = VecLen1.*[cosd(Income4(1)) sind(Income4(1))];
                P2 = [INT.fil{a}.FIL{e}(f,3)-INT.fil{a}.FIL{e}(f,1) INT.fil{a}.FIL{e}(f,4)-INT.fil{a}.FIL{e}(f,2)];
                P3 = P2 + VecLen2.*[cosd(Income4(2)) sind(Income4(2))];
                Theta = Income4(1);
                RotMat = [cosd(90-Theta) -sind(90-Theta); sind(90-Theta) cosd(90-Theta)];
                P1rot = (RotMat*(P1.')).'; P2rot = (RotMat*(P2.')).'; P3rot = (RotMat*(P3.')).';
                Inclination = (P2rot(2)-P3rot(2))/(P2rot(1)-P3rot(1)); Intersect = P2rot(2) - Inclination*P2rot(1);
                
                if ((abs(P2rot(1))-abs(P3rot(1))) >= 0) && (((P2rot(1))*(P3rot(1))) > 0) && ((Intersect-P1rot(2)) >= 0)
                    Place = 1;
                else
                    Place = 0;
                end   
                                
                Temp = [];
                for g=1:length(CO.fil{a}.COO(:,1))
                    if CO.fil{a}.COO(g,2) > f
                        Temp = [Temp; CO.fil{a}.COO(g,1)];
                    end
                end
                if ~isempty(Temp)
                    h = min(Temp); i = INT.fil{a}.FIL{h}(1,10)+1;
                    Outcome1 = [INT.fil{a}.FIL{h}(i+1,1)-INT.fil{a}.FIL{h}(i,1) INT.fil{a}.FIL{h}(i+1,2)-INT.fil{a}.FIL{h}(i,2); INT.fil{a}.FIL{h}(i+1,3)-INT.fil{a}.FIL{h}(i,3) INT.fil{a}.FIL{h}(i+1,4)-INT.fil{a}.FIL{h}(i,4)];
                    Outcome2 = normr(Outcome1);
                    Outcome3 = [(atan2(Outcome2(1,2),Outcome2(1,1)))*(180/pi) (atan2(Outcome2(2,2),Outcome2(2,1)))*(180/pi)];
                    Outcome4 = [Outcome3(1) Outcome3(2)];
                    Outcome5 = abs(Outcome4(1)-Outcome4(2));
                    OutcomeNUM = INT.fil{a}.FIL{h}(1,13);
                    OutcomeTIME = INT.fil{a}.FIL{h}(1,10) + 1;
                    Duration = OutcomeTIME - IncomeTIME;
                    tempCoordinateIN = find(collect.fil{MainFil}(:,2)==IncomeTIME);
                    CoordinateXin = collect.fil{MainFil}(tempCoordinateIN,3); CoordinateYin = collect.fil{MainFil}(tempCoordinateIN,4);
                    tempCoordinateOUT = find(collect.fil{MainFil}(:,2)==OutcomeTIME);
                    CoordinateXout = collect.fil{MainFil}(tempCoordinateOUT,3); CoordinateYout = collect.fil{MainFil}(tempCoordinateOUT,4);
                    tempBC1 = find(collect.fil{MainFil}(:,2)==(IncomeTIME-1)); tempBC2 = find(collect.fil{IncomeNUM}(:,2)==(IncomeTIME-1));
                    BC1x = collect.fil{MainFil}(tempBC1,3); BC1y = collect.fil{MainFil}(tempBC1,4);
                    BC2x = collect.fil{IncomeNUM}(tempBC2,3); BC2y = collect.fil{IncomeNUM}(tempBC2,4);
                    tempAC1 = find(collect.fil{MainFil}(:,2)==(OutcomeTIME+1)); tempAC2 = find(collect.fil{OutcomeNUM}(:,2)==(OutcomeTIME+1));
                    AC1x = collect.fil{MainFil}(tempAC1,3); AC1y = collect.fil{MainFil}(tempAC1,4);
                    AC2x = collect.fil{OutcomeNUM}(tempAC2,3); AC2y = collect.fil{OutcomeNUM}(tempAC2,4);
                    CO.fil{a}.COs = [CO.fil{a}.COs; Income5 Outcome5 MainFil IncomeNUM OutcomeNUM Place Duration IncomeTIME OutcomeTIME CoordinateXin CoordinateYin CoordinateXout CoordinateYout BC1x BC1y BC2x BC2y AC1x AC1y AC2x AC2y];
                end
                clear d e f g h i Income1 Income2 Income3 Income4 Income5 IncomeTIME Outcome1 Outcome2 Outcome3 Outcome4 Outcome5 OutcomeTIME Duration Temp IncomeNUM OutcomeNUM VecLen1 VecLen2 P1 P2 P3 Theta RotMat P1rot P2rot P3rot Inclination Intersect Place tempCoordinateIN CoordinateXin CoordinateYin tempCoordinateOUT CoordinateXout CoordinateYout BC1x BC1y BC2x BC2y AC1x AC1y AC2x AC2y tempBC1 tempBC2 tempAC1 tempAC2
            end           
        else 
            for j=1:length(CO.fil{a}.COO(:,1))
                k = CO.fil{a}.COO(j,1); l = CO.fil{a}.COO(j,2);
                Outcome1 = [INT.fil{a}.FIL{k}(l+1,1)-INT.fil{a}.FIL{k}(l,1) INT.fil{a}.FIL{k}(l+1,2)-INT.fil{a}.FIL{k}(l,2); INT.fil{a}.FIL{k}(l+1,3)-INT.fil{a}.FIL{k}(l,3) INT.fil{a}.FIL{k}(l+1,4)-INT.fil{a}.FIL{k}(l,4)];
                Outcome2 = normr(Outcome1);
                Outcome3 = [(atan2(Outcome2(1,2),Outcome2(1,1)))*(180/pi) (atan2(Outcome2(2,2),Outcome2(2,1)))*(180/pi)];
                Outcome4 = [Outcome3(1) Outcome3(2)];
                Outcome5 = abs(Outcome4(1)-Outcome4(2));
                OutcomeNUM = INT.fil{a}.FIL{k}(1,13);
                OutcomeTIME = INT.fil{a}.FIL{k}(1,10) + 1;
                Temp = [];
                for m=1:length(CO.fil{a}.COI(:,1))
                    if CO.fil{a}.COI(m,2) < l
                        Temp = [Temp; CO.fil{a}.COI(m,1)];
                    end
                end
                if ~isempty(Temp)
                    n = max(Temp); p = T-INT.fil{a}.FIL{n}(1,11);
                    Income1 = [INT.fil{a}.FIL{n}(p,1)-INT.fil{a}.FIL{n}(p-1,1) INT.fil{a}.FIL{n}(p,2)-INT.fil{a}.FIL{n}(p-1,2); INT.fil{a}.FIL{n}(p,3)-INT.fil{a}.FIL{n}(p-1,3) INT.fil{a}.FIL{n}(p,4)-INT.fil{a}.FIL{n}(p-1,4)];
                    Income2 = normr(Income1);
                    Income3 = [(atan2(Income2(1,2),Income2(1,1)))*(180/pi) (atan2(Income2(2,2),Income2(2,1)))*(180/pi)];
                    Income4 = [Income3(1) Income3(2)];
                    Income5 = abs(Income4(1)-Income4(2));
                    IncomeNUM = INT.fil{a}.FIL{n}(1,13);
                    IncomeTIME = T - INT.fil{a}.FIL{n}(1,11);
                    
                   
                    VecLen1 = ((Income1(1,1))^2 + (Income1(1,2))^2)^(0.5); VecLen2 = ((Income1(2,1))^2 + (Income1(2,2))^2)^(0.5);
                    P1 = VecLen1.*[cosd(Income4(1)) sind(Income4(1))];
                    P2 = [INT.fil{a}.FIL{n}(p,3)-INT.fil{a}.FIL{n}(p,1) INT.fil{a}.FIL{n}(p,4)-INT.fil{a}.FIL{n}(p,2)];
                    P3 = P2 + VecLen2.*[cosd(Income4(2)) sind(Income4(2))];
                    Theta = Income4(1);
                    RotMat = [cosd(90-Theta) -sind(90-Theta); sind(90-Theta) cosd(90-Theta)]; 
                    P1rot = (RotMat*(P1.')).'; P2rot = (RotMat*(P2.')).'; P3rot = (RotMat*(P3.')).';
                    Inclination = (P2rot(2)-P3rot(2))/(P2rot(1)-P3rot(1)); Intersect = P2rot(2) - Inclination*P2rot(1);
                
                    if ((abs(P2rot(1))-abs(P3rot(1))) >= 0) && (((P2rot(1))*(P3rot(1))) > 0) && ((Intersect-P1rot(2)) >= 0)
                        Place = 1; 
                    else
                        Place = 0;
                    end 
                                        
                    Duration = OutcomeTIME - IncomeTIME;
                    tempCoordinateIN = find(collect.fil{MainFil}(:,2)==IncomeTIME);
                    CoordinateXin = collect.fil{MainFil}(tempCoordinateIN,3); CoordinateYin = collect.fil{MainFil}(tempCoordinateIN,4);
                    tempCoordinateOUT = find(collect.fil{MainFil}(:,2)==OutcomeTIME);
                    CoordinateXout = collect.fil{MainFil}(tempCoordinateOUT,3); CoordinateYout = collect.fil{MainFil}(tempCoordinateOUT,4);
                    tempBC1 = find(collect.fil{MainFil}(:,2)==(IncomeTIME-1)); tempBC2 = find(collect.fil{IncomeNUM}(:,2)==(IncomeTIME-1));
                    BC1x = collect.fil{MainFil}(tempBC1,3); BC1y = collect.fil{MainFil}(tempBC1,4);
                    BC2x = collect.fil{IncomeNUM}(tempBC2,3); BC2y = collect.fil{IncomeNUM}(tempBC2,4);
                    tempAC1 = find(collect.fil{MainFil}(:,2)==(OutcomeTIME+1)); tempAC2 = find(collect.fil{OutcomeNUM}(:,2)==(OutcomeTIME+1));
                    AC1x = collect.fil{MainFil}(tempAC1,3); AC1y = collect.fil{MainFil}(tempAC1,4);
                    AC2x = collect.fil{OutcomeNUM}(tempAC2,3); AC2y = collect.fil{OutcomeNUM}(tempAC2,4);
                    CO.fil{a}.COs = [CO.fil{a}.COs; Income5 Outcome5 MainFil IncomeNUM OutcomeNUM Place Duration IncomeTIME OutcomeTIME CoordinateXin CoordinateYin CoordinateXout CoordinateYout BC1x BC1y BC2x BC2y AC1x AC1y AC2x AC2y]; 
                end
                clear j k l m n p Income1 Income2 Income3 Income4 Income5 IncomeTIME Outcome1 Outcome2 Outcome3 Outcome4 Outcome5 OutcomeTIME Duration Temp IncomeNUM OutcomeNUM VecLen1 VecLen2 P1 P2 P3 Theta RotMat P1rot P2rot P3rot Inclination Intersect Place tempCoordinateIN CoordinateXin CoordinateYin tempCoordinateOUT CoordinateXout CoordinateYout BC1x BC1y BC2x BC2y AC1x AC1y AC2x AC2y tempBC1 tempBC2 tempAC1 tempAC2
            end
        end
    end
    clear MainFil
end

display('Nearly there!')

Crossover = [];
for q=1:length(INT.fil)
    Crossover = [Crossover; CO.fil{q}.COs];
end

CrossoverALL = [];
for w=1:length(Crossover(:,1))
    if (Crossover(w,1) >= 0) && (Crossover(w,2) >= 0)
        CrossoverALL = [CrossoverALL; Crossover(w,:)];
    end
end

clear a b c q w
L = length(CrossoverALL(:,1));
FinalWHOLE = [WHOLE(1,1)-WHOLE(1,2)+L L];

CrOvIN = []; CrOvOUT = [];
for x=1:length(CrossoverALL(:,1))
    if (CrossoverALL(x,1) > 180) && (CrossoverALL(x,1) <= 360)
        CrOvIN = [CrOvIN; 360-CrossoverALL(x,1)];
    elseif (CrossoverALL(x,1) > 360) && (CrossoverALL(x,1) <= 540)
        CrOvIN = [CrOvIN; 540-CrossoverALL(x,1)];
    elseif (CrossoverALL(x,1) > 540) && (CrossoverALL(x,1) <= 720)
         CrOvIN = [CrOvIN; 720-CrossoverALL(x,1)];
    elseif (CrossoverALL(x,1) > 720) && (CrossoverALL(x,1) <= 900)
         CrOvIN = [CrOvIN; 900-CrossoverALL(x,1)];
    elseif (CrossoverALL(x,1) > 900) && (CrossoverALL(x,1) <= 1080)
        CrOvIN = [CrOvIN; 1080-CrossoverALL(x,1)];
    else
        CrOvIN = [CrOvIN; CrossoverALL(x,1)];
    end
    
    if (CrossoverALL(x,2) > 180) && (CrossoverALL(x,2) <= 360)
        CrOvOUT = [CrOvOUT; 360-CrossoverALL(x,2)];
    elseif (CrossoverALL(x,2) > 360) && (CrossoverALL(x,2) <= 540)
        CrOvOUT = [CrOvOUT; 540-CrossoverALL(x,2)];
    elseif (CrossoverALL(x,2) > 540) && (CrossoverALL(x,2) <= 720)
         CrOvOUT = [CrOvOUT; 720-CrossoverALL(x,2)];
    elseif (CrossoverALL(x,2) > 720) && (CrossoverALL(x,2) <= 900)
         CrOvOUT = [CrOvOUT; 900-CrossoverALL(x,2)];
    elseif (CrossoverALL(x,2) > 900) && (CrossoverALL(x,2) <= 1080)
         CrOvOUT = [CrOvOUT; 1080-CrossoverALL(x,2)];
    else
        CrOvOUT = [CrOvOUT; CrossoverALL(x,2)];
    end
end

clear x

CrOv = [CrOvIN CrOvOUT CrossoverALL(:,3:21)];

savename = strcat(name,'_CrOv');

save(savename,'CrOv','RI');
