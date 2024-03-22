:-consult(data).


% problem 2
countOrdersOfCustomer(UserName,Count):-
    findall(_,(customer(UserID,UserName),order(UserID,_,_)),Orders), length(Orders,Count).


%____________________________________________________________




% problem 5

calcPriceOfOrder(UserName,OrderID ,TotalPrice):-
    customer(UserID,UserName),% Get customer ID
    order(UserID,OrderID,Items), % Get the items for the given order ID
    calc_price(Items ,TotalPrice). % calculate the total price of items


calc_price([],0).
calc_price([Head|Tail],Sum) :-
     calc_price(Tail , Sum1),
     item(Head,_,Price),
     Sum is Sum1 + Price.
%___________________________________________________________




% problem 8

removeBoycottItemsFromAnOrder(UserName , OrderID, NewList):-
    customer(UserID,UserName),
    order(UserID,OrderID,Items),
    add_to_alternative_list(Items,NewList).

add_to_alternative_list([],[]).
add_to_alternative_list([Head|Tail],[Head |NewTail]):-
    \+ isBoycott(Head) , add_to_alternative_list(Tail,NewTail).
add_to_alternative_list([Head|Tail],NewTail):-
     isBoycott(Head),
     add_to_alternative_list(Tail,NewTail).


isBoycott(ItemOrCompany) :-
    boycott_company(ItemOrCompany, _);
    alternative(ItemOrCompany, _).

%____________________________________________________________



% problem 11

getTheDifferenceInPriceBetweenItemAndAlternative(BoycottName,AlternativeName, DiffPrice):-
    alternative(BoycottName,AlternativeName),
    item(BoycottName,_,BoycottPrice) ,
    item(AlternativeName,_,AlternativePrice),
    DiffPrice is BoycottPrice - AlternativePrice.







