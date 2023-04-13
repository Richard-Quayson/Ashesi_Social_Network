import json
from flask import Flask, jsonify, request

# import helper methods and other essential data
from helper import (
    FIRST_YEAR_GROUP, USERS_COLLECTION, POSTS_COLLECTION,
    
    valid_request_body, valid_student_id, valid_student_info,
    valid_name, valid_dob, valid_major, valid_email, valid_post,
    get_post, get_users_in_year_group, get_user_by_name
    
)

# creating flask app
social_network = Flask(__name__)


# _______________________________________________________________________________________________
# REGISTER A STUDENT AS A USER
@social_network.route("/users/profile/create/", methods=["POST"])
def register_user():
    
    # validate student details in request
    unique_keys = ["student_id", "email"]
    result = valid_student_info(request, unique_keys)
    if type(result) == tuple:
        return result
    
    # write student's data into database
    student_info = result["data"]
    USERS_COLLECTION.document(student_info["student_id"]).set(student_info)
    
    return jsonify(student_info), 201


# ______________________________________________________________________________________________
# EDIT STUDENT PROFILE
@social_network.route("/users/profile/edit/<student_id>/", methods=["PATCH"])
def edit_profile(student_id):
    
    # ensure that the student_id specified is valid
    valid_id = valid_student_id(student_id)
    # if not syntactically correct, return appropriate message
    if not valid_id:
        return jsonify({"error": "Student id is not valid!"}), 400
    # else if syntactically correct, ensure the year group is valid
    elif int(valid_id["year_group"]) < FIRST_YEAR_GROUP:
        return jsonify({"error": "Student year group is invalid!"}), 400

    # ensure that the request body is not empty
    if not valid_request_body(request):
        return jsonify({"error": "Student update information missing!"}), 404
    
    # get request data
    update_info = json.loads(request.data)
    
    # ensure that specified data does not contain student_id,
    # name and email since they cannot be changed
    
    if "student_id" in update_info:
        return jsonify({"error": "Student id cannot be changed!"}), 403
    
    if "firstname" in update_info or "lastname" in update_info:
        return jsonify({"error": "Name cannot be changed!"}), 403
    
    if "email" in update_info:
        return jsonify({"error": "Email cannot be changed!"}), 403
    
    if "dob" in update_info:
        return jsonify({"error": "Date of birth cannot be changed"}), 403
    
    # ensure that provided update information are valid
    
    if "major" in update_info:
        if not valid_major(update_info["major"]):
            return jsonify({"error": "Major specified is not offered in Ashesi!"}), 400
        
    if "campus_resident" in update_info:
        if bool(update_info["campus_resident"]) != True or bool(update_info["campus_resident"]) != False:
            return jsonify({"error": "Campus resident must be a boolean!"})
        
    # get student with the specified id
    student_data = USERS_COLLECTION.document(student_id).get().to_dict()
    
    # update specified info
    for key in update_info:
        student_data[key] = update_info[key]
        
    # write updated data back into database
    USERS_COLLECTION.document(student_id).set(student_data)
    
    return jsonify(student_data)


# _______________________________________________________________________________________________
# VIEW STUDENT PROFILE
@social_network.route("/users/profile/view/", methods=["GET"])
def get_student_profile():
    """uses all specified arguments (attributes of student) parsed for filtering
    matching students and returns the result. If no attribute is parsed, it retrieves
    all students. If any exception occur, it returns an appropriate message of the exception
    * Attributes being used for filtering are: 
    - student_id    - firstname     - lastname      - email         - dob
    - year_group    - campus_resident   - best_food     - best_movie

    Returns:
        dict: JSON representation of the list of students (dict) that match filter attributes
    """
    
    # dict to store all keys and values for filter
    filter_dict = dict()
    
    # stores resulting list from filtering
    result_list = list()
    final_result_list = list()
    
    # get all attributes specified in the request args
    if request.args.get("student_id"):
        filter_dict["student_id"] = request.args.get("student_id")
        
    if request.args.get("firstname"):
        filter_dict["firstname"] = request.args.get("firstname")
        
    if request.args.get("lastname"):
        filter_dict["lastname"] = request.args.get("lastname")
        
    if request.args.get("email"):
        filter_dict["email"] = request.args.get("email")
        
    if request.args.get("dob"):
        filter_dict["dob"] = request.args.get("dob")
        
    if request.args.get("year_group"):
        filter_dict["year_group"] = request.args.get("year_group")
        
    if request.args.get("campus_resident"):
        filter_dict["campus_resident"] = request.args.get("campus_resident")
        
    if request.args.get("major"):
        filter_dict["major"] = request.args.get("major")
        
    if request.args.get("best_food"):
        filter_dict["best_food"] = request.args.get("best_food")

    # read the students file
    data = USERS_COLLECTION.get()
    students_data = list()
    for student in data:
        students_data.append(student.to_dict())
        
    if not students_data:
        return jsonify({"message": "No student has been registered!"}), 404
    
    # if no argument is parsed, retrieve all users
    if not filter_dict:
        return jsonify(students_data)
        
    for key in filter_dict.keys():

        # ensure that the value of key is valid
        if key == "student_id":
            if not valid_student_id(filter_dict[key]):
                return jsonify({"message": "Student ID is not valid."}), 400

        elif key == "firstname":
            if not valid_name(filter_dict[key]):
                return jsonify({"message": "Firstname must be a string."}), 400
            
        elif key == "lastname":
            if not valid_name(filter_dict[key]):
                return jsonify({"message": "Lastname must be a string."}), 400
        
        elif key == "email":
            if not valid_email(filter_dict[key]):
                return jsonify({"message": "Email must be a valid Ashesi email address."}), 400
        
        elif key == "major":
            if not valid_major(filter_dict[key]):
                return jsonify({"message": "Major not offered in Ashesi."}), 404
            
        elif key == "dob":
            if not valid_dob(filter_dict[key]):
                return jsonify({"message": "Date of birth is not valid."}), 400
            
        elif key == "campus_resident":
            if filter_dict[key].lower() == "true":
                filter_dict[key] = True
            elif filter_dict[key].lower() == "false":
                filter_dict[key] = False
            else:
                return jsonify({"message": "Invalid value for campus_resident attribute!"}), 400
            
        elif key == "year_group":
            if int(filter_dict["year_group"]) < FIRST_YEAR_GROUP:
                return jsonify({"message": "Student year group is invalid."})
            
        # empty the result list before new filter is applied
        result_list.clear()
            
        # get all user with specified key
        for student in students_data:
            # since year group isn't being stored, handle it differently
            if key == "year_group":
                # get year group of student from student's student_id
                student_id_details = valid_student_id(student.get("student_id"))
                year_group = student_id_details["year_group"]
                if year_group == filter_dict[key]:
                    result_list.append(student)
            else:
                if type(filter_dict[key]) == str:
                    if student.get(key).lower() == filter_dict[key].lower() or student.get(key).lower().startswith(filter_dict[key].lower()):
                        result_list.append(student)
                else:
                    if student.get(key) == filter_dict[key]:
                        result_list.append(student)
        
        # update the data being returned
        final_result_list = result_list[:]
        
        # update the data being used for filtering
        students_data = final_result_list
                
    # ensure that the result list is not empty
    if not final_result_list:
        return jsonify({"message": "No student found with the provided details"}), 404
            
    return jsonify(final_result_list)


# _________________________________________________________________________________________________
# CREATE POST
@social_network.route("/users/posts/create/", methods=["POST"])
def create_post():
    
    
    # ensure that post_data is valid
    result = valid_post(request)
    if type(result) == tuple:
        return result
        
    # write data to collection
    post_data = result["data"]

    if post_data["post_image"]:
        post_image = request.files()
        
        
    POSTS_COLLECTION.document().set(post_data)
    
    return jsonify(post_data)



# ________________________________________________________________________________________________
# VIEW FEED
@social_network.route("/users/posts/feed/", methods=["GET"])
def retrieve_feed():
    
    # attributes to be used include:
    # name, either first or last
    # student_id, year group
    # and description of feed / post
    
    # idea: get the value the user entered in the text field
    value = request.args.get("value")
    posts = POSTS_COLLECTION.get()
    post_data = list()
    for post in posts:
        post_data.append(post.to_dict())
        
    if not value:
        return jsonify(post_data)
    
    # determine the type of the value
    # whether it's firstname, lastname, student_id,
    # year_group or description
    
    if valid_student_id(value):
        key = "student_id"
    elif len(value) == 4 and value.isdigit():
        key = "year_group"
    elif valid_email(value):
        key = "email"
    else:
        key = list()
        if valid_name(value):
            key.append("name")
        key.append("description")
        
    if type(key) == list:
        # the key list will always contain description
        result_list = get_post("description", value)
        
        # if name in key list, get corresponding post for name
        if len(key) > 1:
            response = get_user_by_name(value)
            
            if type(response) == tuple:
                return response
            
            for user in response:
                user_post = get_post("email", user["email"])
                result_list.extend(user_post)
    
    # if user attribute detected, get corresponding email and filter post
    elif key == "student_id" or key == "year_group":
        # if student_id, get the student with the given id
        if key == "student_id":
            users_list = list()
            student_info = USERS_COLLECTION.document(value).get().to_dict()
            users_list.append(student_info)
        else:
            # get users in a year group
            users_list = get_users_in_year_group(value)
        
        result_list = list()
        # loop through users list and retrieve all posts for said users
        for user in users_list:
            result = get_post("email", user["email"])
            result_list.extend(result)
            
    elif key == "email":
        result_list = get_post(key, value)
        
    # else, return appropriate response of unrecognisable attribute
    else:
        return jsonify({"error": "Unrecognisable attribute!"}), 404
    
    if not result_list:
        return jsonify({"error": "No user found with specified value!"}), 404
    
    return jsonify(result_list)

    
if __name__=='__main__':
    social_network.run(debug=True)