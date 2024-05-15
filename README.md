# Customer Orders and Boycotts Assistant 

This repository contains Prolog solutions for managing customer orders and identifying boycott items and their alternatives based on provided data.

## Problem Statement

Given a `data.pl` file with facts about customers, items, orders, and boycott information, the Prolog program in this repository answers various questions about customers and their orders. It also assists customers in identifying items to boycott and suggests alternatives.

## Data File

The `data.pl` file includes facts such as:
- `customer(CustID, CustUserName).`
- `item(ItemName, companyName, Price).`
- `order(CustID, OrderID, [Items]).`
- `boycott_company(companyName, justification).`
- `alternative(ItemName, AlternativeItem).`

## Required Predicates

The program provides the following predicates:

1. **List Orders**: List all orders of a specific customer.
2. **Count Orders**: Get the number of orders of a specific customer given their ID.
3. **List Items in Order**: List all items in a specific customer order given customer ID and order ID.
4. **Count Items in Order**: Get the number of items in a specific customer order given customer name and order ID.
5. **Calculate Order Price**: Calculate the price of a given order given customer name and order ID.
6. **Boycott Check**: Determine whether an item or company is subject to boycott.
7. **Boycott Justification**: Find the justification for boycotting a company or an item.

## Setup

To run the Prolog program, you will need a Prolog interpreter. The most commonly used interpreter is SWI-Prolog, which is available for most operating systems.

### Installing SWI-Prolog

1. **Windows**: Download the installer from SWI-Prolog's website and follow the installation instructions.
2. **macOS**: Use Homebrew by running `brew install swi-prolog` in the terminal.
3. **Linux**: Use your distribution's package manager to install SWI-Prolog. For example, on Ubuntu, you can run `sudo apt-get install swi-prolog`.

### Running the Program

After installing SWI-Prolog, you can run the program by following these steps:

1. Clone the repository or download the files to your local machine.
2. Open a terminal or command prompt window.
3. Navigate to the directory containing the `data.pl` file and your Prolog solution files.
4. Start the SWI-Prolog interpreter by typing `swipl`.
5. In the SWI-Prolog environment, load the `data.pl` file by typing `[data].`
6. Now you can query the database using the predicates provided in the solution files.

### Example Query

```prolog
?- list_orders(shahd_ghazal2002, L).
L = [order(101, 2, [loreal_hair_serum_100ml, sunsilk_shampoo_350ml]), order(101, 1, [puvana, orange_1k, feba_dishwash_1L, snickers, ahlawy])].