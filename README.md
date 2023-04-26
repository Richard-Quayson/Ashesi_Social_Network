# Ashesi_Social_Network

The Ashesi_Social_Network project provide an API that uses a firebase database, and a Frontend web application in Flutter.
The API provides functions that allow users to register onto a social media application, make posts
and add posts to their favourites. The API provides **functionalities** that supports the following:
1. Register as a user -> POST.
**Endpoint:** .../users/profile/create/

2. Edit user profile -> PATCH.
\n**Endpoint:** .../users/profile/edit/<int: student_id>/

3. Filter to retrieve user(s) information by any attributes of a user -> GET.
**Endpoint:** .../users/profile/view/?<attribute_name>=<attribute_value>
Eg. .../users/profile/view/?firstname=richard

4. Create a post. After post is created, all registered users are notified through an email broadcast -> POST.
**Endpoint:** .../users/posts/create/

5. Filter feed by either the content, the name, id or email of the user who made it -> GET.
**Endpoint:** .../users/posts/feed/?value=<attribute_value>
Eg. .../users/posts/feed/?value=project
Eg. .../users/posts/feed/?value=richard.quayson@ashesi.edu.gh

6. Add / remove a post from your list of favourites post -> POST.
**Endpoint:** .../users/posts/favourites/?user_id=<user's_id>&post_id=<post's id>
Eg. .../users/posts/favourites/?user_id=29962024&post_id=BG3NKZatn024SJRlLO4j


## Project Structure
### Social_Network_API
This folder contains the app.py, helper.py, http_version.py, requirements.txt and key.json.
- helper.py -> defines methods to be used by the API like validation and other essential queries.
- requirements.txt -> contains all libraries and packages needed to run the backend app.
- key.json -> contains the permission key to the firebase backend of the application.
- app.py -> uses methods defined in helper.py to create a Flask app that provides endpoints to the functionalities listed above.
- http_version.py -> contains a modified version of app.py to create a single http function that can be deployed to Google Cloud.


#### app.py
The Flask version of the API uses the [flask framework](https://flask.palletsprojects.com/en/2.2.x/) to create an app that provides
the functionaities listed above. It uses a firebase database for storing information.

#### Usage 
**Note:** Create a firebase database and update the key.json file with the database credentials.
```
**Filename to be updated:** key.json
```

#### Running the Flask version
To run the program, move into the Social_Network_API folder in your terminal and set up a virtual environment. Install the packages 
in the requirements.txt file, activate the virtual environment,  and run the app.py file. You can test the API functionalities using 
any HTTP client like [Postman](https://www.postman.com/)

```Python

# run the app.py file
python voting_system.py
```

#### http_version.py
The http version of the API uses the functions framework to create an http function that routes request to functions that define
the functionaities listed above. It uses a firebase database for storing information.

#### Usage 
**Note:** Create a firebase database and update the key.json file with the database credentials.
```
**Filename to be updated:** key.json
```

The http version has been deployed to google cloud as an http function and can be tested using any HTTP client like 
[Postman](https://www.postman.com/) at this [address](https://us-central1-ashesi-social-network-384820.cloudfunctions.net/ashesi_social_network_2996/users/posts/feed)

You can check tests performed on the API in the test_result.pdf in the Social_Network_API folder.

### flutter_frontend
This folder contains a Flutter project that creates a web application to consum the API defined in the Social_Network_API. The dart
files have been defined in the lib folder. The flutter project has been linked to the deployed http version of the API and can be tested
by running the flutter application in the terminal using any browser as an emulator.


## Program Overview:
For an overview on the project, check the file task_instructions.pdf the main tree.


## Future updates:
Future updates will:
- [ ] Deploy flutter application.
- [ ] Improve validation of student's information.
- [ ] Integrate filter system for user and post with search bar created in the flutter project.
- [ ] Provide endpoints and corresponding dart files for tracking read and unread posts by users [🙂].
- [ ] Improve runtime filter for retrieving user and post information.


## Message:
****It's Richard here, happy coding 😁😂✌️💪❗****
