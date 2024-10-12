% Permitir definiciones discontiguas
:- discontiguous father/2, mother/2, grandfather/2, grandmother/2, sibling/2, uncle/2, aunt/2, cousin/2, levelConsanguinity/3.

% Relaciones 
father(samuel, juan).
father(jorge, laura).     
father(carlos, pablo).   
father(luis, pablo).     
father(luis, juan).      

mother(mar, marta).      
mother(mar, samuel).    
mother(marta, laura).    
mother(laura, pablo).    
 
sibling(marta, samuel).  
sibling(juan, tobias).   
sibling(laura, mario).   
sibling(luis, pablo).   
uncle(mario, pablo).     
aunt(marta, juan).       
cousin(simon, jose).     

father(john, marta).    
mother(linda, marta).    
father(john, samuel).    
mother(linda, samuel).   
sibling(marta, samuel).  
sibling(bob, john).      
cousin(fred, john).      

father(michael, george). 
mother(sarah, george).   
grandfather(julio, michael).  
grandmother(susan, michael). 
uncle(tom, michael).   
aunt(susan, michael).    
uncle(mario, michael).    
father(steve, emily).   
mother(sara, emily).    
sibling(james, steve).    
sibling(taylor, steve).     
cousin(dan, steve).       
cousin(flor, steve).     
 
grandfather(julian, luis). 
grandfather(jorge, pablo).  

% Definiciones de abuelas
grandmother(X, Y) :- mother(X, Z), father(Z, Y).



% Niveles de consanguinidad
levelConsanguinity(X, Y, 1) :- father(X, Y).    % Nivel 1: padre
levelConsanguinity(X, Y, 1) :- mother(X, Y).    % Nivel 1: madre
levelConsanguinity(X, Y, 2) :- sibling(X, Y).   % Nivel 2: hermanos
levelConsanguinity(X, Y, 2) :- grandfather(X, Y). % Nivel 2: abuelo
levelConsanguinity(X, Y, 2) :- grandmother(X, Y). % Nivel 2: abuela
levelConsanguinity(X, Y, 3) :- uncle(X, Y).     % Nivel 3: tío
levelConsanguinity(X, Y, 3) :- aunt(X, Y).      % Nivel 3: tía
levelConsanguinity(X, Y, 3) :- cousin(X, Y).    % Nivel 3: primo

% Porcentajes por nivel 
percentage_by_level(1, 30).   % Nivel 1 (hijos, padres) reciben 30%
percentage_by_level(2, 20).   % Nivel 2 (hermanos, abuelos) reciben 20%
percentage_by_level(3, 10).   % Nivel 3 (tíos, tías, primos) reciben 10%

% Preguntar por herencia
ask_for_inheritance(Deceased, HeirsList) :-
    write('Ingrese el nombre del fallecido '), read(Deceased),
    write('Ingrese el número de hijos -'), read(NumChildren),
    write('Ingrese el número de padres: '), read(NumParents),
    write('Ingrese el número de abuelos: '), read(NumGrandparents),
    write('Ingrese el número de hermanos: '), read(NumSiblings),
    write('Ingrese el número de tios: '), read(NumUncles),
    write('Ingrese el número de primos: '), read(NumCousins),
    HeirsList = [children(NumChildren), parents(NumParents), grandparents(NumGrandparents), siblings(NumSiblings), uncles(NumUncles), cousins(NumCousins)].

% Distribuir la herencia segun niveles
distributeInheritance(InheritanceTotal, HeirsList, Distribution) :-
    percentage_by_level(1, Percent1),
    percentage_by_level(2, Percent2),
    percentage_by_level(3, Percent3),
    get_total_percentage(HeirsList, Percent1, Percent2, Percent3, TotalPercentage),
    adjust_percentages(TotalPercentage, Percent1, Percent2, Percent3, HeirsList, InheritanceTotal, Distribution).

% Calcular porcentaje total
get_total_percentage([children(NC), parents(NP), grandparents(NG), siblings(NS), uncles(NU), cousins(NCU)], Percent1, Percent2, Percent3, TotalPercentage) :-
    TotalPercentage is (NC + NP) * Percent1 + (NG + NS) * Percent2 + (NU + NCU) * Percent3.

% Ajustar los porcentajes si son mas que el 100%
adjust_percentages(TotalPercentage, Percent1, Percent2, Percent3, HeirsList, InheritanceTotal, Distribution) :-
    (TotalPercentage =< 100 ->
        calculate_distribution(Percent1, Percent2, Percent3, HeirsList, InheritanceTotal, Distribution)
    ;
        AdjustmentFactor is 100 / TotalPercentage,
        NewPercent1 is Percent1 * AdjustmentFactor,
        NewPercent2 is Percent2 * AdjustmentFactor,
        NewPercent3 is Percent3 * AdjustmentFactor,
        calculate_distribution(NewPercent1, NewPercent2, NewPercent3, HeirsList, InheritanceTotal, Distribution)
    ).

% Calcular distribucion
calculate_distribution(Percent1, Percent2, Percent3, [children(NC), parents(NP), grandparents(NG), siblings(NS), uncles(NU), cousins(NCU)], InheritanceTotal, Distribution) :-
    Total1 is (NC + NP) * Percent1 / 100 * InheritanceTotal,
    Total2 is (NG + NS) * Percent2 / 100 * InheritanceTotal,
    Total3 is (NU + NCU) * Percent3 / 100 * InheritanceTotal,
    Distribution = [level1(Total1), level2(Total2), level3(Total3)].


