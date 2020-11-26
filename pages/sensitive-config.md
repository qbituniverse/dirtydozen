---
title: III. Sensitive config
description: Don't share it with the rest of the world
permalink: /sensitive-config/
---

# III. Sensitive config

## Don't share it with the rest of the world

Modern applications are built on the basis of small (distinct) components (microservices) interconnected with each other either at Networking ([REST](https://en.wikipedia.org/wiki/Representational_state_transfer), [RPC](https://en.wikipedia.org/wiki/Remote_procedure_call)) level or Code Dependency ([Nuget](https://docs.microsoft.com/en-us/nuget/), [npm](https://www.npmjs.com/)) level. Often these `dependencies` will require some sort of authentication (who you are) as well as authorisation (what can you do) performed in order to consume these.

> Programmatically, this is achieved by identifying yourself as a `Client`, sometimes this information is also associated with `Key` and in some cases also a `Secret`.

These pieces of information are normally stored in configuration files where [JSON](https://www.json.org/json-en) format being predominant choice in most cases, as per examples below.

```json
{
    "azure": {
        "kv_client": "123456",
        "kv_key": "abcdef",
        "kv_secret": "009988"
    }
}
```

## Problem Statement

During development phases this type of config is a commonplace, you will find it in project structure alongside your source code. Very often these keys are `Development Environment` only. However, as it quite often tends to be the case, there are exceptions to that rule. Hence the `Sensitive config` alert!

Code is normally stored in Code Repositories, such as [GitHub](https://github.com/), [TFS](https://azure.microsoft.com/en-gb/services/devops/server/) or [Subversion](https://subversion.apache.org/). Therefore, what normally tends to happen, our JSON Config File being part of our codebase indivertibly ends up in the repository, alongside the source code.

When it becomes `seriously bad news` is when these keys make their way into `Public Repository` - and the result being?

> Sensitive config exposure to the rest of the World! Imagine what could happen if your sensitive config got into `unwanted hands`.

The above is especially true with applications which tend to be [too generic in nature](/writing-too-generic-code) which then leads into [over configuration](/over-configuration) symptoms. Lesser impact of the sensitive config issue is on the `Private Repositories`.

> However, a good practice would dictate to avoid storing such config in code repos whenever possible.

## Solution

There are three steps you can do to prevent leakage of your `Sensitive config` to the unwanted hands.

##### Step 1 - Default "Configuration.json"

Store `Default Configuration` with `empty` values. As result, this file essentially provides config structure, key names and types that are expected by your code. This file is then pushed to the repo.

```json
{
    "azure": {
        "kv_client": "",
        "kv_key": "",
        "kv_secret": ""
    }
}
```

##### Step 2 - Environment "Configuration.Environment.json"

These files will contain your `Environment Specific` sensitive config. Notice the naming convention which derives from previous step - *Configuration.`Environment`.json*.

```text
Configuration.Development.json
Configuration.Staging.json
Configuration.Production.json
```

##### Step 3 - Ignore Environment Configuration

Finally, define your repo `filter` file (.gitignore) to `ignore` pushing your sensitive `Environment` config files into the repo.

```text
# other ignore rules removed for brevity
...

# ignore sensitive configuration files
**/Configuration.Development.json
**/Configuration.Staging.json
**/Configuration.Production.json
```

## Summary

It only takes one innocent [Pull Request (PR)](https://docs.github.com/en/free-pro-team@latest/github/collaborating-with-issues-and-pull-requests/about-pull-requests) to accidentally push configuration files containing sensitive values into your code repo.

> However, now you know how to prevent your `Sensitive config` from being shared with `the rest of the World...`

### [<< Previous](/one-trick-pony-variables) | [Next >>](/over-configuration)