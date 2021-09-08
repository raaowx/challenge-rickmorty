# Where is Rick & Morty?

This iOS app is my own response to the following mobile code challenge.

**Task:** Create a native mobile app that displays a list of characters from Rick and Morty ́s show and allow the user to navigate to the details of the last known location of a character. The application must fetch the information from a public API (information provided below).

**Must-haves:**

- [X] List of characters.
- [X] Detail of each character's last known location.
- [X] Design your own UI, you have no limitations.

**Good-to-haves:**

- [X] Set a character as favorite.
- [X] Paginated list (infinite list scroll).
- [X] Unit and UI tests.

## Build

For building the app you have to keep in mind two things:

1. Set your own `Team` inside `Signing & Capabilities` section under `Targets > challenge-rickmorty`.
   1. This step may be also required for running unit tests and UI test. Go to `Targets > challenge-rickmortyTests` and `Targets > challenge-rickmortyUITests` respectively.
2. One of the build phases is a lint code phase. To successfully perform this phase you need [SwiftLint](https://github.com/realm/SwiftLint) tool. If you don't have it installed or you don't want to install it on your computer, just delete the build phase with name `Lint Code` inside `Build Phases` section under `Targets > challenge-rickmorty`.

## Code Comments

You'll find some comments along the code. Those comments explain something about the line or function below.

If you want to quickly find those comments search the string `NOTE:` in the code.

## Prints

There'll be some `print()` calls along the code. There are left behind on purpose. In a real world application, it will be useful to use a third party library for those `print()` in order to generate application logs and upload them to a server.

These can be done with tools like [CocoaLumberjack](https://cocoapods.org/pods/CocoaLumberjack) if you want to manage the upload yourself or use a tool like [DataDog](https://www.datadoghq.com) to have the process handled as a service. Of course, there are a lot of options, these were only two examples.

## Decisions

This section will expose some questions that may come to your mind while reviewing the code.

### Why I choose iOS 13.0 as the minimum OS version for the challenge?

I think is a good backwards compatibility version. This OS version will allow a lot of users to install the app. I base this opinion in the Apple's declared [adoption rate](https://developer.apple.com/support/app-store/) that expose that 85% of all iPhone use iOS 14 and the following 8% use iOS 13. This specific OS version also allows the project to use [SF Symbols](https://developer.apple.com/sf-symbols/) without the struggling of choosing icons for earliest OS versions.

_**Note:** Adoption rate data were retrieved the 10th of august of 2021. The percentage may be changed when you read this document._

### Why MVP architectural pattern?

Well, this pattern offers a good balance between decoupling model, view and business logic with being an easy pattern to implement in tiny applications.

In other kind of application another architectural pattern will fit better. This is something that always has to be studied before starting an app.

### Why store favorites as an `array` if requirements only request storing one?

Data structures are always a hard decision. In order to get the maximum performance from the app this has to be hardly studied before applying.

In this particular case, I've chosen `array` because it allows the app to be ready to accept more than one favorite character if requirements change in the future.

Also, in order to this topic, I've implemented a `limit` functionality to be able to increase the number of favorites easily.

At this point, the only thing that needs further development, in case the favorite limit increase, is the favorite showing area. The model is already done, so that change shouldn't be a big deal.

### Why only one `ViewController`?

I've imaged the application as a single page app based on the requirements. If the app requirements change and more information about the characters is given, it may require a redesign based on the new requirements.

### Further questions

If you have any other question about the implementation of the application, you can ask me. I'll be delighted to solve them.

## License & Copyright

The application is licensed with MIT License.

Copyright © 2021 **Álvaro López de Diego {raaowx}** <raaowx@protonmail.com>
