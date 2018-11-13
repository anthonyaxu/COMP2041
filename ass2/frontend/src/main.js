// importing named exports we use brackets
import { createPostTile, createElement, uploadImage, createLogin, createRegister, createNav, createButtons, checkStore, setStore, clearStore, removeStore, createModal } from './helpers.js';

// when importing 'default' exports, use below syntax
import API from './api.js';

const api  = new API();

var header = document.querySelectorAll('[class="banner"]');
var main = document.querySelectorAll('[role="main"]');
var token;
// Variable to store which page we are on
var page_num = 0;

/*
    Checks if user has logged in before
    and if not, display login page
*/
if (checkStore("token") == null) {
    showLogin();
} else {
    loadNav();
    getFeed(page_num);
    createPageButtons();
}

// Loads the profile dropdown and the button to post images to the header once user is logged in
function loadNav() {
    const nav = createNav(checkStore("username"));
    header[0].appendChild(nav);

    // Shows the dropdown menu when the username is clicked
    const profile_drop = document.getElementById('profile_drop');
    profile_drop.addEventListener('click', function() {
        document.getElementById('drop_content').style.display = "block";
    });

    // When you click somewhere else on the website, it stops showing the profile dropdown
    window.onclick = function(event) {
        if (!event.target.matches('.dropbtn')) {
            document.getElementById('drop_content').style.display = "none";
        }
    }

    // eventListener to show ther user's profile page in a modal when clicked
    const profile_id = document.getElementById('profile_id');
    profile_id.addEventListener('click', showProfile);

    // eventListener to show the 'post image' modal when it is clicked
    const upload_id = document.getElementById('upload_id');
    upload_id.addEventListener('click', showUpload);

    // eventListener to logout the user when clicked
    const logoutButton = document.getElementById('logoutButton');
    logoutButton.addEventListener('click', logoutUser);
}

// Once user is logged in, display all posts from users they follow
function getFeed(page) {
    token = checkStore("token");
    let options = {
        headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Token ' + token
        },
        method: "GET",
    };
    // Feed is defaulted to show 10 posts at a time
    var p = 0 + page*10;
    var n = 10 + page*10;
    // Display all the images to the feed
    api.getFeed(options, JSON.stringify(p), JSON.stringify(n)).then(function(response) {
        document.getElementById('large-feed').style.display = "block";

        response.posts.reduce((parent, post) => {
            // Following code to convert epoch time to regular date format taken and modified from stackoverflow
            // at https://stackoverflow.com/questions/4631928/convert-utc-epoch-to-local-date/22237139
            var utcSeconds = post.meta.published;
            var d = new Date(0);
            d.setUTCSeconds(utcSeconds);
            post.meta.published = d;

            // Checks to see if the current user has liked the page
            // and renders the like button to either be green or black
            var green = false; 
            var current_id = checkStore("id");
            for (var i = 0; i < post.meta.likes.length; i++) {
                if (post.meta.likes[i] == current_id) {
                    green = true;
                }
            }

            parent.appendChild(createPostTile(post, green));       
            return parent;

        }, document.getElementById('large-feed'));
        return response;
    }).then(function(response) {
        var feed_posts = document.querySelectorAll('[class="post"]');
        for (var i = 0; i < feed_posts.length; i++) {

            // Adds eventListener for the like button
            var post_id = feed_posts[i].childNodes[1].alt;
            feed_posts[i].childNodes[2].addEventListener('click', likePost.bind(this, post_id, feed_posts[i].childNodes[2]), false);

            // console.log(feed_posts[i].childNodes[3]);
            feed_posts[i].childNodes[3].addEventListener('click', commentPost.bind(this, post_id), false);

            // Adds eventListener to view likes on each post
            feed_posts[i].childNodes[4].addEventListener('click', viewLikes.bind(this, response.posts[i].meta.likes), false);

            // Adds eventListener to view comments on each post
            feed_posts[i].childNodes[6].addEventListener('click', viewComments.bind(this, response.posts[i].comments), false);
        }
    });
}

// Validates the user's input and alerts them if any info is incorrect
function validateLogin() {
    var username = document.forms['loginform']['username'].value;
    var password = document.forms['loginform']['password'].value;
    var details = {
        "username": username,
        "password": password 
    };
    let options = {
        headers: { 'Content-Type': 'application/json' },
        method: "POST",
        body: JSON.stringify(details)
    };
    api.validateUser(options).then(function(response) {
        if (response.token == undefined) {
            // If details don't match the system, display error
            alert(response.message);
        } else {
            // Store the user's token so that the server remembers them until they log out
            setStore("token", response.token);
            // Store the id of the user for future use
            let options = {
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': 'Token ' + response.token
                },
                method: "GET",
            };
            var id = "";
            api.getUser(username, id, options).then(function(user) {
                setStore("id", user.id);
            });
            // Stores username of user to display on feed
            setStore("username", username);

            // Remove the login html and load feed
            removeLast();
            loadNav();
            getFeed(page_num);
            createPageButtons();
        }
    });
}

// Similar to validateUser, but the user makes a new account
// Usernames must be unique
function registerUser() {
    var name = document.forms['registerform']['register_name'].value;
    var email = document.forms['registerform']['register_email'].value;
    var username = document.forms['registerform']['register_uname'].value;
    var password = document.forms['registerform']['register_pword'].value;
    var details = {
        "username": username,
        "password": password,
        "email": email,
        "name": name
    };
    let options = {
        headers: { 'Content-Type': 'application/json' },
        method: "POST",
        body: JSON.stringify(details)
    };
    api.validateRegister(options).then(function(response) {
        if (response.token == undefined) {
            alert(response.message);
        } else {
            setStore("token", response.token);
            // Store the id of the user for future use
            let options = {
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': 'Token ' + response.token
                },
                method: "GET",
            };
            var id = "";
            api.getUser(username, id, options).then(function(user) {
                setStore("id", user.id);
            });
            setStore("username", username);

            removeLast();
            loadNav();
            getFeed(page_num);
            createPageButtons();
        }
    });
}

// Creates HTML for the login form, with a button to show the register page
function showLogin() {
    removeLast();
    const login = createLogin();
    main[0].appendChild(login);

    const logIn = document.getElementById('loginButton');
    logIn.addEventListener('click', validateLogin);

    const show_register = document.getElementById('showRegister');
    show_register.addEventListener('click', showRegister);
}

// Shows the form to register a new account
function showRegister() {
    removeLast();
    const register = createRegister();
    main[0].appendChild(register);

    const register_user = document.getElementById('registerButton');
    register_user.addEventListener('click', registerUser);

    const show_login = document.getElementById('showLogin');
    show_login.addEventListener('click', showLogin);
}

// Creates a next and previous button to show different pages
function createPageButtons() {
    const buttons = createButtons();

    main[0].appendChild(buttons);

    const left = document.getElementById('prev_page');
    left.addEventListener('click', getPrevPage);

    const right = document.getElementById('next_page');
    right.addEventListener('click', getNextPage);
}

// Creates modal to post new content
function showUpload() {
    const modal = createModal("Upload", "upload_modal");
    main[0].appendChild(modal);

    var modal_item = document.getElementById("upload_modal");
    modal_item.style.display = "block";

    var span = document.getElementsByClassName("close")[0];
    span.addEventListener("click", function() {
        // Remove it from the HTML
        removeLast();
    });
    var body = document.getElementById("modal_body");

    const upload_file = createElement("li", null, { class: "nav-item" });
    upload_file.innerHTML = '<input type="file"/>';
    body.appendChild(upload_file);

    // Creating text box to write your post's description
    body.appendChild(createElement("br", null));
    body.appendChild(createElement("br", null));
    const desc = createElement("textarea", null, { class: "desc", placeholder: "Post Description" });
    desc.setAttribute("id", "desc_id");
    body.appendChild(desc);

    // Creates a button to submit the post
    body.appendChild(createElement("br", null));
    body.appendChild(createElement("br", null));
    const upload_btn = createElement("button", "Post", { class: "btn btn-primary btn-sm" });
    upload_btn.setAttribute("id", "upload_btn");
    body.appendChild(upload_btn);

    const input = document.querySelector('input[type="file"]');
    input.addEventListener('change', uploadImage);

    const btn = document.getElementById('upload_btn');
    btn.addEventListener('click', postImage);
}

// Removes the last HTML element from the main body
// Removes the buttons, login page or the register page
// Also removes modals
function removeLast() {
    main[0].removeChild(main[0].lastChild);
}

// Log the user out of the site, removes their auth token from local storage
function logoutUser() {
    clearStore();
    location.reload();
}

// Likes the post if the user hasn't already and changes the 'like' button to green
// Unlikes the post if the user already liked it and changes button back to black
function likePost(post_id, like_id) {
    token = checkStore("token");
    let options = {
        headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Token ' + token
        },
        method: "PUT",
    };
    // If button is green, user has already liked it and if pressed again, they will unlike the post
    if (like_id.style.color == "green") {
        api.unlikePost(options, post_id).then(function(response) {
            if (response.message != "success") {
                alert(response.message);
            } else {
                like_id.style.color = "black";
            }
        });
    } else {
        // else, user likes the post and changes the colour of the button
        api.likePost(options, post_id).then(function(response) {
            if (response.message != "success") {
                alert(response.message);
            } else {
                like_id.style.color = "green";
            }
        });
    }
    
}

// Creates a modal in which you can write comments to a post
function commentPost(post_id) {
    // Creates modal
    const modal = createModal("Write a comment", "write_modal");
    main[0].appendChild(modal);

    var modal_item = document.getElementById("write_modal");
    modal_item.style.display = "block";

    var span = document.getElementsByClassName("close")[0];
    span.addEventListener("click", function() {
        modal.style.display = "none";
        // Remove it from the HTML
        removeLast();
    });
    var body = document.getElementById("modal_body");

    // Creating a text box to write your comment and a button to submit the comment
    const box = createElement("textarea", null, { class: "comment", placeholder: "Write a nice comment" });
    box.setAttribute("id", "comment_id");
    body.appendChild(box);
    body.appendChild(createElement("br", null));
    const btn = createElement("button", "Post", { class: "btn btn-primary btn-sm" });
    btn.setAttribute("id", "post_comment");
    body.appendChild(btn);

    btn.addEventListener('click', postComment.bind(this, post_id), false);
}

function postComment(post_id) {
    // Get the comment from the text area
    const comment = document.getElementById('comment_id').value;
    var name = checkStore("username");
    // How to get UNIX timestamp taken from https://www.electrictoolbox.com/unix-timestamp-javascript/
    var timestamp = Math.round((new Date()).getTime() / 1000);
    var payload = {
        'author': name,
        'published': timestamp,
        'comment': comment
    };
    token = checkStore("token");
    let options = {
        headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Token ' + token
        },
        method: "PUT",
        body: JSON.stringify(payload)
    };
    // Makes a request to write a comment, alerts user the response status of the request
    api.postComment(post_id, options).then(function(response) {
        if (response.message != "success") {
            alert(response.message);
        } else {
            alert("Posted comment successfully!");
        }
    });
}

// Creates modal to show the users who liked the post
function viewLikes(likes) {
    const modal = createModal("Likes", "like_modal");
    main[0].appendChild(modal);

    var modal_item = document.getElementById("like_modal");
    // Displays the modal be default
    modal_item.style.display = "block";

    // eventListener to close the modal and remove it's HTML
    var span = document.getElementsByClassName("close")[0];
    span.addEventListener("click", function() {
        modal.style.display = "none";
        // Remove it from the HTML
        removeLast();
    });
    token = checkStore("token");
    let options = {
        headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Token ' + token
        },
        method: "GET",
    };
    var body = document.getElementById("modal_body");
    // Username is defaulted to an empty string, it is dealt with within the API
    var username = "";
    var id = "";
    // Loops through the users that like the post and creates a new element to append to the modal body
    for (var i = 0; i < likes.length; i++) {
        id = likes[i];
        api.getUser(username, id, options).then(function(response) {
            const temp = createElement("p", response.username);
            body.appendChild(temp);
        });
    }
}

// Creates modal to view the comments on a post
// Similar to viewLikes 
function viewComments(comments) {
    const modal = createModal("Comments", "comment_modal");
    main[0].appendChild(modal);

    var modal_item = document.getElementById("comment_modal");
    modal_item.style.display = "block";

    var span = document.getElementsByClassName("close")[0];
    span.addEventListener("click", function() {
        modal.style.display = "none";
        // Remove it from the HTML
        removeLast();
    });
    var body = document.getElementById("modal_body");
    // Loop through all the comments on the post and create paragraph elements to append to the modal body
    for (var i = 0; i < comments.length; i++) {
        const comment = createElement("p", null);
        comment.innerHTML += "<b>" + comments[i].author + ":</b> " + comments[i].comment;
        body.appendChild(comment);
    }
}

// Function that sends an API request to post an image
function postImage() {
    // Grabs the description user inputted
    const desc = document.getElementById("desc_id").value;
    const src = checkStore("dataURL");
    // Regex to remove the inital 'data:src' text
    const newsrc = src.replace(/^.*,/, '');
    var payload = {
        'description_text': desc,
        'src': newsrc
    };
    token = checkStore("token");
    let options = {
        headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Token ' + token
        },
        method: "POST",
        body: JSON.stringify(payload)
    };
    api.postImage(options).then(function(response) {
        // Alerts user if the content wasn't able to be posted
        if (response.message != undefined) {
            alert(response.message);
        } else {
            alert("Posted image!");
        }
    });
    // Remove the dataURL so that it isn't somehow used next time around
    removeStore("dataURL");
}

// Show a modal of all detail of current user
function showProfile() {
    // Create modal
    const name = checkStore("username");
    const modal = createModal(name, "profile_modal");
    main[0].appendChild(modal);

    var modal_item = document.getElementById("profile_modal");
    modal_item.style.display = "block";

    var span = document.getElementsByClassName("close")[0];
    span.addEventListener("click", function() {
        modal.style.display = "none";
        // Remove it from the HTML
        removeLast();
    });
    var body = document.getElementById("modal_body");

    let options = {
        headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Token ' + token
        },
        method: "GET",
    };
    var username = "";
    var id = "";
    token = checkStore("token");
    api.getUser(username, id, options).then(function(response) {
        // Append all user's details to the modal body
        const name = createElement("p", null);
        name.innerHTML = "<b>Name: </b>" + response.name;
        const post_num = createElement("p", null);
        post_num.innerHTML = "<b>Number of posts: </b>" + response.posts.length;
        const followed = createElement("p", null);
        followed.innerHTML = "<b>Followed by: </b>" + response.followed_num + " users";
        const following = createElement("p", null);
        following.innerHTML = "<b>Following: </b>";

        body.appendChild(name);
        body.appendChild(post_num);
        body.appendChild(followed);
        body.appendChild(following);

        // Loop through all the users the current user follows and add their usernames to the modal
        for (var i = 0; i < response.following.length; i++) {
            const last = response.following.length - 1;
            api.getUser(username, response.following[i], options).then(function(user) {
                following.innerHTML += user.username + " ";
            });
        }
    });
}

// Returns the previous page
// If page is the inital page, pressing button will do nothing
function getPrevPage() {
    if (page_num - 1 < 0) {
        return;
    }
    page_num -= 1;
    removeLast();
    removeFeed();
    getFeed(page_num);
    createPageButtons();
}

// Returns the next page
// If the next page doesn't contain any posts, do nothing
function getNextPage() {
    token = checkStore("token");
    let options = {
        headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Token ' + token
        },
        method: "GET",
    };
    page_num += 1;
    var p = 0 + page_num*10;
    var n = 10 + page_num*10;
    // Display all the images to the feed
    api.getFeed(options, JSON.stringify(p), JSON.stringify(n)).then(function(response) {
        // Checks if there are more posts to show, if not then don't move onto the next page
        if (response.posts.length > 0) {
            removeLast();
            removeFeed();
            getFeed(page_num);
            createPageButtons();
        } else {
            page_num -= 1;
            return;
        }
    });
}

// Clears all posts in the feed
function removeFeed() {
    const feed = document.getElementById("large-feed");
    while (feed.lastChild) {
        feed.removeChild(feed.lastChild);
    }
}