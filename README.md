### Ruby Code Testing

#### Introduction
The task is to implement a checkout system that conforms to the following interface:
```
co = Checkout.new(rules)
co.scan(item)
co.scan(item)
price = co.total
```

#### Item price
```
A,  $30
B,  $20
C,  $50
D,  $15
```
#### Promotions
```
If 3 of Item A are purchased, the price for all is $75.
If 2 of Item B are purchased, the price for both is $35.
If the total basket price (after previous discounts) is over $150, the basket receives a discount $20.
```
#### Example Test Data
```
Basket,  Price
A, B, C   $100
B, A, B, A, A   $110
C, B, A, A, D, A, B  $155
C, A, D, A, A        $140
```

#### Design considerations
We expect the marketing team will want to invent new types of promotional rules beyond the current multi-buy and basket total promotions.
The design should allow the system to be extended in a way that follows SOLID principles.
