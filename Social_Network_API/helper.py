import json
from datetime import datetime
from re import search
from flask import Flask, jsonify
from flask_mail import Mail, Message
from firebase_admin import credentials, firestore, initialize_app


# initialise Firestore database
cred = credentials.Certificate("key.json")
app = initialize_app(cred)
database = firestore.client()

# firebase collection reference
USERS_COLLECTION = database.collection("users")
POSTS_COLLECTION = database.collection("posts")

# creating flask app
social_network = Flask(__name__)

# initialise Flask-Mail
social_network.config['MAIL_SERVER'] = 'smtp.gmail.com'
social_network.config['MAIL_PORT'] = 465
social_network.config['MAIL_USERNAME'] = 'projectile.webgeeks@gmail.com'
social_network.config['MAIL_PASSWORD'] = 'mgsyuknntllkmdel'
social_network.config['MAIL_USE_SSL'] = True
mail = Mail(social_network)

# first year group in Ashesi
FIRST_YEAR_GROUP = 2002

# valid Ashesi majors
ASHESI_MAJORS = [
    "BA", "CS", "MIS", "CE", "ME", "EE", "MECHATRONICS"
]

# expected student attributes
STUDENT_ATTRIBUTES = [
    "student_id", "firstname", "lastname", "email",
    "dob", "major", "campus_resident", "best_food", "best_movie"
]

POST_ATTRIBUTES  =  [
    "email", "description",
]


def valid_request_body(request):
    """ensures that the request body is valid (not empty)

    Args:
        request (tuple): the request being sent to the API

    Returns:
        JSON: a boolean of whether or not the request is valid
    """
    
    if not request.data:
        return False    
    return True


def valid_keys(object_data, expected_keys):
    """ensures that all required keys for specified object are present

    Args:
        object_data (dict): JSON representation of a object's information

    Returns:
        dict: a dictionary of boolean and or list of messages from validation
    """
    
    result = {"is_valid": False}            # result from validation
    result_message = []                     # message from validation
    num_correct_keys = 0                    # variable to keep track of the number of matching keys
    data_keys = object_data.keys()
    
    for key in expected_keys:
        if key in data_keys:
            num_correct_keys += 1
        else:
            result_message.append(f"{key.capitalize()} is required")
    
    if num_correct_keys == len(expected_keys):
        
        # if more keys are present, flag the presence of extra keys
        if len(object_data) > len(expected_keys):
            result["message"] = f"Extra attributes identified. Expected keys are: {expected_keys}"
        else:
            result["is_valid"] = True
    else:
        result["message"] = result_message
    
    return result


def unique_keys(key_list, data, object_data):
    """ensures that all values corresponding to unique keys in the provided 
    object_data is unique (does not already exist in the database)

    Args:
        key_list (list): list of unique keys
        dictionary_list (list of dict): a list of object information (dict) in db
        object_data (dict): a dictionary containing the object's information

    Returns:
        dict: a dictionary containing the result from unique test
    """
    
    result = dict()
    for key in key_list:
        for voter in data:        
            if object_data[key] == voter[key]:  
                # account for uniqueness in update request, where student_id
                # and voter["student_id"] != object_data["student_id"]:
                result[key] = key + " already exists!"
    
    return result


def valid_student_id(student_id):
    """ensures that a given student_id is valid
    - a student ID is valid if it's eight characters long and numeric

    Args:
        student_id (str): a student's ID

    Returns:
        dict: a dictionary containing user_id (the first four values of a student id)
        and year_group (the year group of the student)
    """
    
    # ensure that the student id is of length 8
    if(len(student_id)) != 8:
        return False
    
    # ensure that the student id is numeric
    if not student_id.isnumeric():
        return False
    
    user_id = student_id[:4]
    year_group = student_id[4:]
    
    return {"user_id": user_id, "year_group": year_group} 


def valid_name(name):
    """determines whether or not a given name is valid (i.e. is a string)

    Args:
        name (string): the name to be verified

    Returns:
        bool: whether or not the name is valid
    """
       
    if not name.isalpha():
        return False
    return True


def valid_email(email):
    """determines whether or not a given email is a valid ashesi email

    Args:
        email (string): the email of the student

    Returns:
        bool: whether or not the email is valid
    """
    pattern = r"^[^0-9!@#$%^&*(+=)\\[\].></{}`]\w+([\.-_]?\w+)*@ashesi\.edu\.gh$"
    regex_match = search(pattern, email)
    return bool(regex_match)


def valid_dob(dob):
    return True


def valid_major(major):
    """determines whether or not a given student major is a valid
    major being offered in Ashesi University

    Args:
        major (str): the major of the student

    Returns:
        bool: whether or not the major is valid
    """
    
    if major.upper() in ASHESI_MAJORS:
        return True
    return False


def valid_image(filename):
    """determines whether or not a given filename is an image

    Args:
        filename (str): the name of the file

    Returns:
        bool: whether or not the file is an image
    """
    
    if filename.lower().endswith(('.png', '.jpg', '.jpeg', '.tiff', '.bmp', '.gif')):
        return True
    return False


def valid_student_info(request, unique_keys_list):
    """ensures that a student's request data is valid
    i.e. contains all necessary keys; contains unique values for
    unique keys; student_id, firstname, lastname and email are syntactically valid

    Args:
        request (tuple): request from client
        unique_keys (list): a list of keys that should be unique

    Returns:
        dict: dictionary containing the status of the validation 
        and a JSON representation of the voter's info from the request or
        appropriate message if an exception occurred
    """
    
    # ensure that the request body is not empty
    if valid_request_body(request) == False:
        return jsonify({"errro": "Student details missing!"}), 404
    
    # get request body
    student_info = json.loads(request.data)
    
    # ensure that the student's info contains all required attributes
    attributes = valid_keys(student_info, STUDENT_ATTRIBUTES)
    if not attributes["is_valid"]:
        return jsonify(attributes["message"]), 400
    
    # ensure that the student's id is syntactically correct
    valid_id = valid_student_id(student_info["student_id"])
    # if not syntactically correct, return appropriate message
    if not valid_id:
        return jsonify({"error": f"Student id ({student_info['student_id']}) is not valid!"}), 400
    # else if syntactically correct, ensure the year group is valid
    elif int(valid_id["year_group"]) < FIRST_YEAR_GROUP:
        return jsonify({"error": f"Student year group ({valid_id['year_group']}) is invalid!"}), 400
    
    # ensure that the student's firstname is valid
    if not valid_name(student_info["firstname"]):
        return jsonify({"error": "Student's firstname must be a string!"}), 400
    
    # ensure that the student's lastname is valid
    if not valid_name(student_info["lastname"]):
        return jsonify({"error": "Student's lastname must be a string!"}), 400
    
    # ensure that the student's email is valid
    if not valid_email(student_info["email"]):
        return jsonify({"error": "Student's email is not a valid Ashesi email!"}), 400
    
    # ensure that the student's date of birth is valid
    if not valid_dob(student_info["dob"]):
        return jsonify({"message": f"{student_info['dob']} is not valid."}), 400

    # ensure that the student's major is valid
    if not valid_major(student_info["major"]):
        return jsonify({"error": f"{student_info['major']} is not a valid Ashesi major!"}), 400
    
    # ensure that the file is an image
    if "profile_image" in student_info:
        if not valid_image(student_info["profile_image"]):
            return jsonify({"error": "Profile image must be an image file!"}), 400
    
    # ensure that the provided keys are unique
    students_collection = USERS_COLLECTION.get()     # retrieve existing user data
    students_data = list()
    
    for document in students_collection:
        students_data.append(document.to_dict())
    # key_list, data, object_data
    unique_data = unique_keys(unique_keys_list, students_data, student_info)
    if len(unique_data) > 0:
        return jsonify(unique_data), 400
    
    # if all conditions are satisfied, return student info
    return {"data": student_info}


def get_user_by_email(email):
    
    # retrieve students data
    data = USERS_COLLECTION.get()
    
    # return appropriate message if no user has been created
    if not data:
        return jsonify({"error": "No user has been registered!"}), 404
    
    for student in data:
        student = student.to_dict()
        if student["email"] == email:
            return student
    
    return jsonify({"error": f"User with email {email} is not registered!"}), 404


def valid_post(request):
    
    # ensure that the request body is not empty
    if valid_request_body(request) == False:
        return jsonify({"error": "Missing post information!"}), 404

    # retrieve request data
    post_data = json.loads(request.data)
    
    # ensure that post_data contains all expected keys
    attributes = valid_keys(post_data, POST_ATTRIBUTES)
    if not attributes["is_valid"]:
        return jsonify(attributes["message"]), 400
    
    # ensure that the post data contains at least a description or image
    if post_data["description"].strip() == "" and post_data["post_image"].strip() == "":
        return jsonify({"error": "Post data must contain at least a description or image!"}), 400
    
    # ensure that the student's email is valid
    if not valid_email(post_data["email"]):
        return jsonify({"error": "Student's email is not a valid Ashesi email!"}), 400
    
    # ensure that the user with the specified email exists
    result = get_user_by_email(post_data["email"])
    if type(result) == tuple:
        return result
        
    # if an image is uploaded, ensure that it is valid
    if "post_image" in post_data:
        if not valid_image(post_data["post_image"]):
            return jsonify({"error": "Post image must be an image file!"}), 400
    else:
        post_data["post_image"] = None
        
    # add date_created and date_updated to post data
    
    current_datetime = datetime.now()
    # dd/mm/YY H:M:S
    datetime_formatted = current_datetime.strftime("%d/%m/%Y %H:%M:%S")
    
    post_data["date_created"] = datetime_formatted
    post_data["date_updated"] = datetime_formatted
    
    # if all conditions are met, return the data
    return {"data": post_data}


def get_post(key, content):
    """retrieves all posts that had the content specified

    Args:
        content (str): the content on which posts are to be filtered
        key (str): the attribute of post to be used for filtering

    Returns:
        list: a list of all posts documents (dict) matching the specified content
    """
    
    # retrieve all posts from db
    posts = POSTS_COLLECTION.get()
    result = list()
    
    # ensure that there are existing posts 
    if not posts:
        return jsonify({"error": "No post has been made!"}), 404
    
    for post in posts:
        post = post.to_dict()
        # check if post contains content specified
        if content.strip().lower() in post[key].strip().lower():
            result.append(post)
            
    return result


def get_users_in_year_group(year_group):
    
    
    # retrieve users collection
    users = USERS_COLLECTION.get()
    
    if not users:
        return jsonify({"error": "No student has been registered"}), 400
    
    result_list = list()
    
    for user in users:
        user = user.to_dict()
        student_id = valid_student_id(user["student_id"])
        year = student_id["year_group"]
        if year_group == year:
            result_list.append(user)
    
    return result_list


def get_user_by_name(name):
    
    # retrieve users collection
    users = USERS_COLLECTION.get()
    
    if not users:
        return jsonify({"error": "No student has been registered"}), 400
    
    result_list = list()
    
    for user in users:
        user = user.to_dict()
        if user["firstname"].lower() == name.lower() or user["firstname"].lower().startswith(name.lower()):
            result_list.append(user)
        elif user["lastname"].lower() == name.lower() or user["lastname"].lower().startswith(name.lower()):
            result_list.append(user)
            
    return result_list


def get_date(post):
    
    return post["date_updated"]


def get_all_user_emails():
    
    # retrieve users collection
    users = USERS_COLLECTION.get()
    
    if not users:
        return jsonify({"error": "No student has been registered"}), 400
    
    result_list = list()
    
    for user in users:
        user = user.to_dict()
        result_list.append(user["email"])
    
    return result_list


def send_email(post_data):

    # retrieve all user emails
    recipients = get_all_user_emails()

    # get user who made the post
    user = get_user_by_email(post_data["email"])

    message = Message(
        "New post from " + user["firstname"] + " " + user["lastname"], 
        sender="ashesi.social@ashesi.edu.gh",
        recipients=recipients
        )
    message.body = user["firstname"] + " " + user["lastname"] + " has made a new post on Ashesi Social!\n"
    message.body += "Post content: " + post_data["description"] + "\n"
    message.body += "Date created: " + post_data["date_updated"] + "\n\n"
    message.body += "Regards, \n Ashesi Social Team."
    
    if mail.send(message):
        return "Email sent!"
    
    return "Email not sent!", 400