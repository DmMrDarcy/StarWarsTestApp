# StarWarsTestApp

**Version:** minimal supported version is iOS 16.0

**Architecture:**  this project uses Clean Architecture.

**Routing:** there are 2 screens in the application: the main page and the favorites page.

**Description:** On the main screen there is an input field in which you can search for people, starships or planets by name.
The search will start after entering at least 2 characters. After that, the api https://swapi.dev/api/ will be called, which will 
return the combined model of people, spaceships and planets. Below the input field, cards with this data will be displayed. 
On each card, you can click the star and the selected card will be added to your favorites. All favorites can be viewed on the 
corresponding page by clicking on the button in the tab menu at the bottom of the screen. When you restart the application, 
all favorites remain available, because they are stored in AppStorage.

**Stack:** SwiftUI, Combine, Alamofire.

**Build:** clone this repo on your mac and run project in XCode, then start app on simulator. In the project settings on the 
"signing and capabilities" tab, the team is not selected, no certificates and profiles were used.