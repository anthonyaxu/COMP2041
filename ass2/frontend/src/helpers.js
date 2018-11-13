/* returns an empty array of size max */
export const range = (max) => Array(max).fill(null);

/* returns a randomInteger */
export const randomInteger = (max = 1) => Math.floor(Math.random()*max);

/* returns a randomHexString */
const randomHex = () => randomInteger(256).toString(16);

/* returns a randomColor */
export const randomColor = () => '#'+range(3).map(randomHex).join('');

/**
 * You don't have to use this but it may or may not simplify element creation
 * 
 * @param {string}  tag     The HTML element desired
 * @param {any}     data    Any textContent, data associated with the element
 * @param {object}  options Any further HTML attributes specified
 */
export function createElement(tag, data, options = {}) {
    const el = document.createElement(tag);
    el.textContent = data;
   
    // Sets the attributes in the options object to the element
    return Object.entries(options).reduce(
        (element, [field, value]) => {
            element.setAttribute(field, value);
            return element;
        }, el);
}

/**
 * Given a post, return a tile with the relevant data
 * @param   {object}        post 
 * @returns {HTMLElement}
 */
export function createPostTile(post, green) {
    const section = createElement('section', null, { class: 'post' });

    section.appendChild(createElement('h2', post.meta.author, { class: 'post-title' }));

    section.appendChild(createElement('img', null, 
        { src: 'data:image/png;base64,'+post.src, alt: post.id, class: 'post-image' }));

    const like = createElement('button', null);
    like.innerText = "Like";
    like.setAttribute("id", "likeButton");
    // Checks if the user has liked the post already
    if (green) {
        like.style.color = "green";
    } else {
        like.style.color = "black";
    }
    section.appendChild(like);

    const comment = createElement('button', null);
    comment.innerText = "Comment";
    comment.setAttribute("id", "commentButton");
    section.appendChild(comment);

    const like_count = createElement('p', post.meta.likes.length + ' likes', { class: 'post-likes'});
    like_count.setAttribute("id", "like_count");
    section.appendChild(like_count);

    section.appendChild(createElement('p', post.meta.description_text, { class: 'post-description'}));

    const comment_count = createElement('p', post.comments.length + ' comments', { class: 'post-comments'});
    comment_count.setAttribute("id", "comment_count");
    section.appendChild(comment_count);

    section.appendChild(createElement('small', post.meta.published, { class: 'post-time'}));

    return section;
}

// Given an input element of type=file, grab the data uploaded for use
export function uploadImage(event) {
    const [ file ] = event.target.files;

    const validFileTypes = [ 'image/jpeg', 'image/png', 'image/jpg' ]
    const valid = validFileTypes.find(type => type === file.type);

    // bad data, let's walk away
    if (!valid) {
        removeStore("dataURL");
        // console.log("bad");
        return false;
    }
    
    // if we get here we have a valid image
    const reader = new FileReader();
    
    reader.onload = (e) => {
        // do something with the data result
        const dataURL = e.target.result;
        setStore("dataURL", dataURL);
        // console.log(dataURL);
        // const image = createElement('img', null, { src: dataURL });
        // document.body.appendChild(image);
    };

    // this returns a base64 image
    reader.readAsDataURL(file);
}

/* 
    Reminder about localStorage
    window.localStorage.setItem('AUTH_KEY', someKey);
    window.localStorage.getItem('AUTH_KEY');
    localStorage.clear()
*/
export function checkStore(key) {
    if (window.localStorage)
        return window.localStorage.getItem(key)
    else
        return null
}

export function setStore(key, data) {
    window.localStorage.setItem(key, data);
}

export function clearStore() {
    window.localStorage.clear();
}

export function removeStore(key) {
    window.localStorage.removeItem(key);
}

// Create HTML for the login page
// Also contains the button to move onto the register page
export function createLogin() {
    const login = createElement("form", null, { class: "container", name: "loginform" });
    login.setAttribute("align", "center");

    const username = login.appendChild(createElement("input", null, { type: "text", placeholder: "Username", name: "username" }));
    username.setAttribute("required", "true");
    username.setAttribute("autofocus", "true");

    login.appendChild(createElement("br", null));

    const password = login.appendChild(createElement("input", null, { type: "password", placeholder: "Password", name: "password" }));
    password.setAttribute("required", "true");

    login.appendChild(createElement("br", null));

    const button = login.appendChild(createElement("button", "Log In", { class: "btn btn-lg btn-primary" }));
    button.setAttribute("id", "loginButton");
    button.setAttribute("type", "button");

    login.appendChild(createElement("br", null));
    login.appendChild(createElement("br", null));

    const registerTag = login.appendChild(createElement("small", null));
    registerTag.innerHTML = "<i>Don't have an account? Register <a href='javascript:;' id='showRegister'>here</a></i>";

    return login;
}

// Creates HTML for registering a new account
// Has a button to go back to the login page
export function createRegister() {
    const register = createElement("form", null, { class: "container", name: "registerform" });
    register.setAttribute("align", "center");

    register.appendChild(createElement("h3", "Make a new account"));

    const name = register.appendChild(createElement("input", null, { type: "text", placeholder: "Name", name: "register_name" }));
    name.setAttribute("required", "true");
    name.setAttribute("autofocus", "true");

    register.appendChild(createElement("br", null));

    const email = register.appendChild(createElement("input", null, { type: "text", placeholder: "Email", name: "register_email" }));
    email.setAttribute("required", "true");  

    register.appendChild(createElement("br", null));

    const username = register.appendChild(createElement("input", null, { type: "text", placeholder: "Username", name: "register_uname" }));
    username.setAttribute("required", "true");

    register.appendChild(createElement("br", null));

    const password = register.appendChild(createElement("input", null, { type: "password", placeholder: "Password", name: "register_pword" }));
    password.setAttribute("required", "true");

    register.appendChild(createElement("br", null));

    const button = register.appendChild(createElement("button", "Sign Up", { class: "btn btn-lg btn-primary" }));
    button.setAttribute("id", "registerButton");
    button.setAttribute("type", "button");

    register.appendChild(createElement("br", null));
    register.appendChild(createElement("br", null));

    const loginTag = register.appendChild(createElement("small", null));
    loginTag.innerHTML = "<i>Already have an account? Login <a href='javascript:;' id='showLogin'>here</a></i>";

    return register;
}

// Creates the nav bar in the header that is shown when the user is logged in
export function createNav(name) {
    const nav = createElement("ul", null, { class: "nav" });
    nav.setAttribute("id", "nav_id");

    const upload = createElement("button", "Post", { class: "upload-btn" });
    upload.setAttribute("id", "upload_id");
    nav.appendChild(upload);

    const dropdown = createElement("div", null, { class: "dropdown" });
    const dropButton = createElement("button", null, { class: "dropbtn" });
    dropButton.setAttribute("id", "profile_drop");
    dropButton.innerText = name;

    dropdown.appendChild(dropButton);

    const drop_content = createElement("div", null, { class: "dropdown-content" });
    drop_content.setAttribute("id", "drop_content");

    const prof_link = createElement("a", null);
    prof_link.setAttribute("href", "javascript:;");
    prof_link.innerText = "My Profile";
    prof_link.setAttribute("id", "profile_id");
    drop_content.appendChild(prof_link);

    const settings_link = createElement("a", null);
    settings_link.setAttribute("href", "javascript:;");
    settings_link.innerText = "Settings";
    drop_content.appendChild(settings_link);

    const logout = createElement("a", null);
    logout.setAttribute("href", "javascript:;");
    logout.setAttribute("id", "logoutButton");
    logout.innerText = "Log Out"
    drop_content.appendChild(logout);

    dropdown.appendChild(drop_content);

    nav.appendChild(dropdown);

    return nav;
}

// Generic function to create a modal given a header name and id
export function createModal(header_tag, id) {
    const modal = createElement("div", null, { class: "modal" });
    modal.setAttribute("id", id);

    const content = createElement("div", null, { class: "modal-content" });
    modal.appendChild(content);

    const header = createElement("div", null, { class: "modal-header" });
    header.appendChild(createElement("h2", header_tag));
    const close = createElement("span", null, { class: "close" });
    close.innerText = "x";
    header.appendChild(close);

    content.appendChild(header);

    const body = createElement("div", null, { class: "modal-body" });
    body.setAttribute("id", "modal_body");

    content.appendChild(body);

    return modal;
}

// Creates the next and previous buttons at the bottom of the page
export function createButtons() {
    const buttons = createElement("div", null);

    const left = createElement("button", "Previous", { class: "prev-btn" });
    left.setAttribute("id", "prev_page");

    const right = createElement("button", "Next", { class: "next-btn" });
    right.setAttribute("id", "next_page");

    buttons.appendChild(left);
    buttons.appendChild(right);

    return buttons;
}