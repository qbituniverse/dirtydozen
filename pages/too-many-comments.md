---
title: VII. Too many comments
description: Code should tell you the story
permalink: ./too-many-comments/
---

# VII. Too many comments

## Code should tell you the story

Comments in programming are useful and absolutely valid when used sparingly and with an intention to explain something that wouldn't normally be obvious or to `provide clarification` regarding method usage i.e. `documentation`. Too many comments in code is normally regarded as `code smell` and therefore such code should be reviewed and probably re-structured.

> Comments in compiled languages, such as [C#](https://docs.microsoft.com/en-us/dotnet/csharp/) or [Java](https://www.java.com/en/) are ignored by the compiler.

```csharp
// One line comment...

/* 
This is multiline comment.
Providing more details.
Or clarification
*/
```

Let's now expand our `comments` example with something a bit more `realistic` and `smelly` at the same time.

```csharp
public void CompleteCheckout(Customer customer, Basket basket)
{
    // set initial values
    var checkoutPrice = 0.0;
    var tax = 0.2;
    var shipping = 0.0;
    var invoice = new Invoice();
    
    // calculate checkout price = (total product price * tax) + shipping
    foreach(var product in basket.Products)
    {
        var productPrice = product.Price;
        checkoutPrice += productPrice;
    }

    // add tax to checkoutPrice
    checkoutPrice *= tax;

    // get shipping cost
    shipping = _shippingService.GetCost(customer.Address);

    // add shipping to checkoutPrice
    checkoutPrice += shipping;

    // prepare itemised invoice
    foreach (var product in basket.Products)
    {
        var invoiceItem = new InvoiceItem();
        invoiceItem.ProductName = product.Name;
        invoiceItem.ProductDescription = product.Description;
        invoiceItem.ProductImage = product.Image;
        invoiceItem.ProductQuantity = product.Quantity;
        invoiceItem.ProductPrice = product.Price;
        invoiceItem.ProductTax = tax;
        invoiceItem.ProductPriceAndTax = (product.Price + tax) * product.Quantity;
        invoice.Add(invoiceItem);
    }

    // add totals and shipping to invoice
    invoice.ShippingCost = shipping;
    invoice.CheckoutPrice = checkoutPrice;

    // save invoice to Word document
    var wordDoc = new Word();
    // Word doc create details omitted for brevity

    // take payment
    var paid = _paymentService.TakePayment(customer.Address, customer.CardDetails, checkoutPrice);

    if (!paid)
    {
        Log("Error processing your payment! Error Details: xxxxxxx");

        // redirect customer to error page
        Redirect.PaymentError();
    }
    else
    {
        // create email
        var email = new Email();
        // Email create details omitted for brevity

        // send email
        _emailService.send(email);

        // redirect customer to success page
        Redirect.PaymentSuccess();
    }
}
```

## Problem Statement

The block of code above shows a number of potential avenues for refactoring. For starters, the [method body is very large](/large-method-bodies) [lines 1:69] making the code very difficult to follow. Hence, the programmer introduced an excessive use of `Too many comments` in order to explain almost line-by-line what's going on there.

Secondly, it's impossible to debug and [unit test](/no-unit-tests) this code due to its complexity.

## Solution

If you feel like you are writing an essay rather than compact piece of code, then best you stop and ask yourself this question: 

> Is the code I'm writing easy to follow by just eyeballing method or variable names?

If the answer is *Yes* then you are on the right path. If your answer is *No* then it'd be best you stop and refactor your work before it makes its way into Production.

For example, consider [smaller methods](/large-method-bodies) and if necessary [restructure the logic](/logic-in-wrong-places). Perhaps only consider `clarification comments` and let the code flow explain itself as the example below demonstrates.

```csharp
/// <summary>
/// Method to complete the checkout process.
/// Calculates totals, shipping, invoice.
/// Takes payment and sends email notification.
/// </summary>
/// <param name="customer"></param>
/// <param name="basket"></param>
public void CompleteCheckout(Customer customer, Basket basket)
{
    var checkoutPrice = CalculateCheckoutPrice(basket);
    var shippingCost = CalculateShipping(customer.Address);
    var invoice = CreateItemisedInvoice(basket);
    invoice.ShippingCost = shippingCost;
    invoice.CheckoutPrice = checkoutPrice;
    
    var paid = ProcessPayment(invoice);
    if (!paid) Redirect.PaymentError();

    var wordDoc = CreateWordDocument(invoice);
    SendEmail(wordDoc);
    Redirect.PaymentSuccess();
}
```

## Summary

Code is normally written to fulfil a `specific purpose`. If that purpose has to be explained with `excessive comments usage`, then get a cup of coffee and `start refactoring`.

> And if you are still fond of writing essays, then it's best you open [Word](https://www.microsoft.com/en-gb/microsoft-365/word) and take it from there...

### [<< Previous](/no-unit-tests) | [Next >>](/logic-in-wrong-places)