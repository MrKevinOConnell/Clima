#  Clima

## What you will use

* Use the UITextField to get user input (UITextFieldDelegate). 
* Swift protocols and extensions. 
* Learn to use Grand Central Dispatch to fetch the main thread.

### You can use the following switch statement to get the correct image for the conditionImageView
```
switch conditionID {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
```

![End Banner](Documentation/readme-end-banner.png)
