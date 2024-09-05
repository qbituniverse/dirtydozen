---
title: V. Large method bodies
description: Count the lines, not pounds
permalink: ./large-method-bodies/
---

# V. Large method bodies

## Count the lines, not pounds

Programmers love code, you'd think the more code the better, right? Well, far from it. In fact, in modern applications concept of `small`, `compact` or `least privileged` is becoming the [de facto standard](https://en.wikipedia.org/wiki/Principle_of_least_privilege). However, it doesn't mean the quality of code gets better or that the code is structured in a better way as result.

Let’s consider this enormous *CompleteCheckout* method below as an example.

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

There's a lot going on inside of that method above, right? Pretty much the entire checkout process is coded in that one single method [lines 1:69]. This is effectively an example of a `Large method bodies` syndrome, where the method itself doesn’t even fit on one decent computer screen. Furthermore, number of side effects of such technique surface up here:

> 1. Code is difficult to follow due to `too many lines`
> 2. As result of above, programmer had to [introduce comments](./too-many-comments) in order to explain what's going on there
> 3. Code is difficult to debug
> 4. As result of above, programmer wasn't able to create suitable [unit tests](./no-unit-tests)
> 5. As result of all above, the code is prone to produce bugs and random behaviour taking hours to troubleshoot and fix

## Solution

The key here is to `create small enough methods` in your project so that each method or class represents what is called [Single Responsibility](https://en.wikipedia.org/wiki/Single-responsibility_principle) as defined in the [SOLID Principles](https://en.wikipedia.org/wiki/SOLID). Let's consider code that's been re-written in such way now.

```csharp
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

In the sample above the programmer has broken the code down into testable chunks [lines 3, 4, 5, 9, 12, 13], therefore, opening a window for [unit testing](./no-unit-tests) of the entire checkout process. Each method is now testable and runs in isolation. This approach has also opened up these methods for `re-use` in other parts of the same project or even in other projects.

## Summary

If you have to scroll a lot to read a single method or you notice overuse of comments then that means `code smell`. We all know what to do in such cases now, right?

> Start `slimming and breaking code down` before it's too late... 

### [<< Previous](./over-configuration) | [Next >>](./no-unit-tests)