## MemeMe

### *Tech Used*
* Xcode 7.3.1+ (through 9.0)
* Swift 2.2 (through 4.0)
* iOS 9.2 (through 11.0)

Frameworks:  
- Foundation  
- UIKit  


### *Description*
User selects image from camera or photo album, adds text, then can share as a meme via the "usual" Apple sharing methods.

Images are saved for the current session only (closing the app removes the images from memory). However, via sharing, users can save the images to their photo album or other locations.

During the current session, users can see their created memes in a table view or a collection view, via a tab bar controller.


### *Interesting Twists*
- Uses unwind segue to return from editor to either the table or collection view from which the user tapped Edit.
- Uses attributed text for meme creation.


### *Setup Requirements*
Just clone and go!

### *Notes*
- Gets messages on tests about classes being implemented in multiple locations. This is weirdness that is not under our control. Check this Stack Overflow question for possible resolutions if this occurs for you: [Class PLBuildVersion is implemented in both frameworks](https://stackoverflow.com/questions/39520499/class-plbuildversion-is-implemented-in-both-frameworks)
