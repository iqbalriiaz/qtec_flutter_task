
# Qtec Solution Limited Flutter Developer Task - February 2023  
This is a Flutter app developed as a part of the Qtec Solution Limited Flutter Developer Task for February 2023. The main purpose of the app is to allow users to search for products and view their details.  
  
## Project Overview  
The app contains two screens: 
- Product Search Screen  
- Product Details Screen  
  
The Search screen displays a search bar where users can enter their search query. The screen also displays a list of products based on the search query, with pagination to display more products. Each product item in the list displays the product name, image, and price.  
  
The Product Details screen displays the details of a specific product. It includes the product name, image, price, description.  
  
The app uses the Bloc and Cubit pattern for state management, though there are some setState() used but I will work on that. The app also uses APIs to fetch search products and product details.  
  
### Screenshots  
The following are some screenshots of the app:  


Screenshot1 | Screenshot2 |  Screenshot3 |  Screenshot4
:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:
![image](https://github.com/iqbalriiaz/qtec_flutter_task/blob/main/images/Screenshot%20from%202023-03-01%2005-04-10.png) | ![image](https://github.com/iqbalriiaz/qtec_flutter_task/blob/main/images/Screenshot%20from%202023-03-01%2005-04-17.png) | ![image](https://github.com/iqbalriiaz/qtec_flutter_task/blob/main/images/Screenshot%20from%202023-03-01%2005-04-33.png) | ![image] (https://github.com/iqbalriiaz/qtec_flutter_task/blob/main/images/Screenshot%20from%202023-03-01%2005-04-39.png) 

Screencast 
:-------------------------:
![image](https://github.com/iqbalriiaz/qtec_flutter_task/blob/main/images/qtec-task.gif)

  
### Getting Started  
To run the app on your local machine, follow these steps:  
  
- Clone this repository to your local machine.  
- Open the cloned project in a code editor of your choice.  
- Run flutter pub get to install the required dependencies.  
- Run the app using flutter run command.  

### Production-Ready  
The app has been developed with production-readiness in mind. Some things that have been done to ensure this include:  
  
- Separation of concerns, with code organized into different directories for easy maintenance and scalability.  
- Use of asynchronous methods to avoid blocking the UI thread.  
- Implementation of pagination for the search results to improve performance.  

### Conclusion  
This was a fun and challenging project that allowed me to learn new things and improve my Flutter skills. I hope you find my work satisfactory, and I look forward to any feedback you may have. Thank you for the opportunity to work on this project!
