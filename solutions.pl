:-consult(data).  % Load the data from the file data.pl
/* make this code dynamic so that it can be updated at runtime. */
:- dynamic item/3.
:- dynamic alternative/2.
:- dynamic boycott_company/2.


% problem 1
list_orders(CustomerName,Orders):-
    customer(CustomerID,CustomerName),
    getAllOrders(CustomerID,1,Orders).

getOrders(CustomerID, CurrentOrderID, Orders):- 
    \+ order(CustomerID, CurrentOrderID, _), % If there is no order for the given order ID then return empty list
     Orders = [].

getOrders(CustomerID, CurrentOrderID, Orders):-
    order(CustomerID, CurrentOrderID, Items),    % Get the items for the given order ID
    NextOrderID is CurrentOrderID + 1,  % Get the next order ID
    getOrders(CustomerID, NextOrderID, Temp),  % Get the orders for the next order ID
    Orders = [order(CustomerID,CurrentOrderID, Items) | Temp].  % Add the current order to the list of orders



%__________________________________________________________________


% problem 2
countOrdersOfCustomer(UserName,Count):-
    findall(_,(customer(UserID,UserName),order(UserID,_,_)),Orders), length(Orders,Count).


%____________________________________________________________


/*
task 3
If there is an order with a specific order id and customer id, then the items in the order are the items in the order with the same order id and customer id.
*/
items_in_order(CustomerID, OrderID, Items) :-
    order(CustomerID, OrderID, Items).
/*
end of task 3
*/
%____________________________________________________________


% problem 4
getNumOfItems(CustomerName, OrderId, ItemCount) :-
    customer(ID, CustomerName), % Get the customer ID
    order(ID, OrderId, Items), % Get the items for the given order ID
    getLength(Items, ItemCount). 

getLength([], 0).
getLength([_|T], Cnt) :-
    getLength(T, Cnt1),
    Cnt is Cnt1 + 1.
%________________________________________________

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

/*
task 6
If is as an item and there exist any alternative for it, then it is boycotted. If it is a company and it's company name is in the boycott_company list, then it is boycotted.
*/
isBoycott(ItemOrCompany) :-
    boycott_company(ItemOrCompany, _);   
    alternative(ItemOrCompany, _).
/*
end of task 6
*/

%____________________________________________________________



% problem 7
whyToBoycott(Name, Reason):-
    boycott_company(Name, Reason);  % If the name is a company name then return the reason
    item(Name, CompanyName, _) , % If the name is an item name then get the company name
    boycott_company(CompanyName, Reason). % Get the reason for the company name


%________________________________________________



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


/*
task 9:  To implement the logic for updating an order such that all boycotted items are replaced by alternatives (if they exist), we can follow these steps:
Retrieve the items of the specified order for the given username and order ID.
Check each item in the order:
If the item is boycotted, replace it with its alternative (if it exists).
If the item is not boycotted, keep it as it is.
Return the updated order list.
*/
% if the item is not boycotted, keep it as it is

replace_boycott_item(Item, Item) :- \+ isBoycott(Item). 

% Rule to replace a boycotted item with its alternative

replace_boycott_item(Item, Alternative) :-  
    alternative(Item, Alternative), % Check if there is an alternative for the item
    isBoycott(Item). % Check if the item is boycotted

% Base case: when there are no more items to process
update_order([], [], _). 

% Recursive case: update each item in the order
update_order([Item|Rest], [NewItem|UpdatedRest], Username) :-
    replace_boycott_item(Item, NewItem),
    update_order(Rest, UpdatedRest, Username).

% Predicate to replace boycotted items in an order for a given user and order ID
replaceBoycottItemsFromAnOrder(Username, OrderID, NewList) :-
    order(CustomerID, OrderID, OldList),
    customer(CustomerID, Username), % Verify the username and order ID
    update_order(OldList, NewList, Username).
/*
end of task 9
*/

%____________________________________________________________



% problem 10
calcPriceAfterReplacingBoycottItemsFromAnOrder(UserName, OrderId, NewItems, TotalPrice) :-
    customer(ID, UserName),
    order(ID, OrderId, Items),
    getNewItems(Items, NewItems, TotalPrice).


% Get the alternative item for the given item if it exists else return the same item
getAlternative(Item, AlternativeItem):- 
    alternative(Item, AlternativeItem);
    AlternativeItem = Item.


% Base case for getNewItems
getNewItems([],[], 0).
% Get the new items and total price after replacing the boycott items
getNewItems([H| T], NewItems, TotalPrice):-
    getAlternative(H, AlternativeItem),   % Get the alternative item for the given item 
    item(AlternativeItem, _, Price), % Get the price of the alternative item
    getNewItems(T, TempNewItems, TempPrice), % Get the new items and total price after replacing the boycott items
    NewItems = [AlternativeItem | TempNewItems], % Add the alternative item to the new items list
    TotalPrice is Price + TempPrice. % Add the price of the alternative item to the total price

%__________________________________________________________________
% problem 11

getTheDifferenceInPriceBetweenItemAndAlternative(BoycottName,AlternativeName, DiffPrice):-
    alternative(BoycottName,AlternativeName),
    item(BoycottName,_,BoycottPrice) ,
    item(AlternativeName,_,AlternativePrice),
    DiffPrice is BoycottPrice - AlternativePrice.



%____________________________________________________________


/*
task 12
*/
% Add a new item to the knowledge base
add_item(Item, Company, Price) :-
    assert(item(Item, Company, Price)). % means that the item is added to the end of the knowledge base
% Remove an item from the knowledge base
remove_item(Item, Company, Price) :- 
    retract(item(Item, Company, Price)). % means that the item is removed from the knowledge base

% Add a new alternative item to the knowledge base
add_alternative(Item, Alternative) :- 
    assert(alternative(Item, Alternative)).

% Remove an alternative item from the knowledge base
remove_alternative(Item, Alternative) :-
    retract(alternative(Item, Alternative)).

% Add a new boycotted company to the knowledge base
add_boycott_company(Company, Reason) :- 
    assert(boycott_company(Company, Reason)).

% Remove a boycotted company from the knowledge base
remove_boycott_company(Company) :-
    retract(boycott_company(Company, _)).
/*
end of task 12
*/




