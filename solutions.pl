:-consult(data).  % Load the data from the file data.pl


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


% problem 7
whyToBoycott(Name, Reason):-
    boycott_company(Name, Reason);  % If the name is company name then return the reason
    item(Name, CompanyName, _) , % If the name is item name then get the company name
    boycott_company(CompanyName, Reason). % Get the reason for the company name


%________________________________________________


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



