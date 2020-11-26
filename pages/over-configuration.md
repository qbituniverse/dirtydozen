---
title: IV. Over configuration
description: Keep things simple
permalink: /over-configuration/
---

# IV. Over configuration

## Keep things simple

Config is great, it can take shape of an innocent boolean switch value or contain more [sensitive information](/sensitive-config) such as access key or password. Last thing we want as programmers is having to `recompile` and `redeploy` our code every time database connection that happens to be `hard-coded` and buried somewhere in your [Data Access Layer](https://en.wikipedia.org/wiki/Data_access_layer) needs to be changed.

> Bigger problems normally arise when people enter what I call the `Over configuration` mode. Such situation can be dangerous, it can lead to confusion and cause much more serious headaches than just hard-coding stuff in the first place.

Let's consider this config, which on the face of it doesn't look too bad, right?

```json
{
    "databaseConnection": "db://abcdef",
    "clientApiUri": "https://api.client.com",
    "productApiUri": "https://api.product.com"
}
```

## Problem Statement

Let's now revisit the config example and add, what I'd regard, a result of someone entering the `Over configuration` mode.

```json
{
    "databaseConnection": "db://abcdef",
    "clientApiUri": "https://api.client.com",
    "clientApiNewEndpoint": "/create",
    "clientApiUpdateEndpoint": "/update",
    "clientApiDeleteEndpoint": "/delete",
    "productApiUri": "https://api.product.com",
    "productApiFetchEndpoint": "/fetch?{param1Key}={param1Value}&{param2Key}={param2Value}",
    "param1Key": "firstname"
}
```

The example above is still a fairly `small` exhibit. However, imagine this growing out of proportion to accommodate more APIs or Endpoints...

## Solution

> Simply sit down and figure out which config items should and should not be in that file - kind of `agility vs simplicity` trade off, as demonstrated in the two scenarios below.

##### Scenario 1 - Extremely static config

The chances for these config pieces to change is almost non-existent. I'd argue that these just `pollute` and `confuse` the config file and don't bring any value.

```json
{
    "clientApiNewEndpoint": "/create",
    "clientApiUpdateEndpoint": "/update",
    "clientApiDeleteEndpoint": "/delete"
}
```

These `strings` could simply be defined at code level in a [variable](/magic-strings) and managed there.

```csharp
public const string clientApiNewEndpoint = "/create";
public const string clientApiUpdateEndpoint = "/update";
public const string clientApiDeleteEndpoint = "/delete";
```

##### Scenario 2 - Extremely confusing config

Here we have *fetch* endpoint defined which takes two parameters (for simplicity only two in this example).

```json
{
    "productApiFetchEndpoint": "/fetch?{param1Key}={param1Value}&{param2Key}={param2Value}",
    "param1Key": "firstname"
}
```

Someone decided that for a good measure it'd be great to:

> 1. Keep the *productApiFetchEndpoint* value itself in config
> 2. Furthermore, *param1Key* is also parameterised in the config as item on its own, meaning that you have dependency here with the *productApiFetchEndpoint* item
> 3. The *param1Value*, *param2Key* and *param2Value* appear to be code variables which are expected to provide values at runtime; Therefore dependency here on code supplying these variables with exactly the same variable names at runtime which is often seen in cases where code is simply written [too generic](/writing-too-generic-code)

Break this config down into code components, like [variable](/magic-strings) and [single responsibility](/large-method-bodies) objects. There's no benefit at all of keeping it in configuration files because it's `static`, does `not vary` from one environment to another and is `only referenced once` in the codebase.

```csharp
// acquire firstname and lastname from some other source
var firstname = "Foo";
var lastname = "Bar";

// pass values to the endpoint call
var result = await client.GetAsync($"/fetch?firstname={firstname}&lastname={lastname}");
```

## Summary

When you write code where you alter application's behaviour using configuration always try to think how difficult it'd be for a new programmer to really understand and make sense of what's happening there. If the code is over configured it's difficult to debug and support, let alone [extend](/writing-too-generic-code) or even [test](/no-unit-tests).

> One phrase comes to mind when considering over configuration - `simply try to KISS...`

### [<< Previous](/sensitive-config) | [Next >>](/large-method-bodies)