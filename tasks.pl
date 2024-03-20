/* make this code dynamic so that it can be updated at runtime. */
:- dynamic item/3.
:- dynamic alternative/2.
:- dynamic boycott_company/2.
/*
task 3
If there is an order with a specific order id and customer id, then the items in the order are the items in the order with the same order id and customer id.
*/
items_in_order(CustomerID, OrderID, Items) :-
    order(CustomerID, OrderID, Items).
/*
end of task 3
*/

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


