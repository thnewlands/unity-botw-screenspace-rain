## BOTW Style Screen Space Rain Impacts for Deferred Rendering
![](http://i.imgur.com/OUWhM19.gif)

This is a currently rough (still WIP) -- study of Breath of the Wild's rain impact effect for the ridges of objects. 

### The Basic Idea:
Sample a depth and a depth below it to determine whether something is an edge or curved. Then we should check if normals of the objects we checked (in world space) are facing upwards then they're probably getting hit by rain. If something satisfies both of those conditions then we should throw some nice rain on top of it. So, we sample a really quickly moving noise texture which is cutoff in such a way that it looks like the pattering of rain. 

### Improvements to be Made:
Make flat faces hit by the rain more varied 
Add more soft volume to droplets
Make the pattering deal with occlusion of the rain
Add some kind of fog to wrap around ridges to compliment the effect.
Rewrite without the normal texture to make it compatible with Forward rendering.

Please feel free to branch and make pull requests as you see fit! 

*The flycam included in the demo scene has its own credits from the Unity wiki page.*
