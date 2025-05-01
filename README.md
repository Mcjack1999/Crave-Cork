# Crave & Cork 
## A Food & Wine Pairing Database for Takeout

**Project Summary**  
Crave & Cork is a MySQL-based relational database designed to bring wine pairing into everyday life. The idea started with a simple question: how can we make the takeout experience feel a little more special? With this project, I wanted to create something that combines the practicality of a food database with the joy and richness of pairing meals with wine—even if it's just delivery. Crave & Cork helps users find wine suggestions for their favorite dishes, and more importantly, understand *why* those pairings work.

**Tech Stack**  
- MySQL (Relational Database)  
- MySQL Workbench (Logical Modeling with Crow’s Foot Notation)  
- SQL Features: Views, Triggers, Constraints, Joins
  
### Concept & Design

Ordering takeout has become a routine part of modern life, but that doesn’t mean it has to feel routine. Crave & Cork was inspired by the idea that small, thoughtful choices—like enjoying a glass of wine with your favorite takeout—can turn even a weeknight dinner into something memorable. I’ve always appreciated how wine educator André Mack talks about making wine approachable and fun, rather than intimidating or exclusive. That spirit shaped this project. I wanted to build a system that reflects that mindset: curious, accessible, and easy to use. 

The database is designed to help users explore food and wine pairings with meaningful filters such as cuisine type, budget, dietary needs, and personal taste. But it’s not just about matching—it’s about learning why different flavors go together and how thoughtful pairings can transform a meal.

### Features & Functionality

The structure of the database includes tables for users, dishes, wines, pairings, orders, favorites, and ratings. Wines are described by attributes like varietal, origin, importer, tasting notes, and price. Dishes are tagged by cuisine, flavor profile, dietary category, and protein (where applicable). Each pairing entry includes a note explaining the reasoning behind the match—for example, how a dry Riesling balances the heat of a spicy noodle dish.

The database also includes SQL views, such as one called `BestPairings`, which makes it easy to surface top-rated combinations. I implemented two SQL triggers: one to update a user's order history automatically, and another to track changes in wine pricing over time. These additions not only improve usability but also demonstrate the kind of automated logic you can build into a system like this. The logical model for the database can be found in the `/diagrams` folder, and the SQL implementation files are located in the `/sql` directory.

#### Logical Model

![Logical Model Diagram](diagrams/Logical_Model.jpg)

### Who It’s For

Crave & Cork was designed for a range of users. For takeout lovers, the system offers a quick and enjoyable way to find wine suggestions that elevate their meal. Wine enthusiasts can use it to discover new combinations and dig into tasting notes, varietals, and wine origins. Professionals in the wine or hospitality industry may find value in seeing how consumers are pairing their wines and identifying emerging trends in food and drink combinations.

### Use Case Examples

This system supports a wide variety of real-world queries. Someone might want to find a wine under $20 that pairs well with spicy Korean fried chicken. Another user might already have a bottle of Bordeaux at home and want to know what kind of food to order that will bring out its best qualities. Crave & Cork also tracks pairing history, allowing users to build a more intentional and informed relationship with their meals over time.

### What’s Next

This version of the project lays the foundation, but I see lots of potential for next steps. I’d like to integrate a machine learning model to offer personalized recommendations based on user preferences and order history. A public-facing web or mobile interface would make the system more accessible, and I’m also interested in exploring API integrations with food delivery services or wine retailers. Eventually, I’d love to include user reviews, dynamic filtering, and even visual tools to help users explore the world of food and wine pairing in a more interactive way.

### View the Full Project

To view the full case study and explore visual assets, visit: [Crave & Cork on My Portfolio](https://michaelaj.me/crave-cork)

## Note

All data used in this project is fictional or adapted from public sources for educational and demonstration purposes only.
