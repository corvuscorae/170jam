# Pocket Vrooms
Take care of your car throughout its life. Try to maximize its lifespan by maintaining it.

- Raven Cruz
- Shazer Rizzo Varela

### Gameplay Loop
Car parts deteriorate and can be damaged, work to repair and maintain the health and utility of each part as you manage the various components of your car and how to fix them when unexpected issues arise.

### Parts and Upgrades
Can upgrade parts for more longevity, though at a higher cost. More specifically the player would have to do resource management with both money and car parts to see which upgrades or repairs they must conduct.

### Technical approach 
We are utilizing Love2d, which will be utilize to display and manage:  Basic car sprite with "health" separated into systems, Mileage counter that increases over time, Simple shop interface for repairs, Event system that triggers random problems, and an overview of the different car parts.

### TODO
- improve balancing
    - implement shop, parts with varying prices
    - improve income system
    - add part-specific random events (like if headlights are out, you might get pulled over)
- graphical indications when events are triggered
- pull all part handling into the part entity (refactor)