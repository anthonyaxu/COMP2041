// change this when you integrate with the real API, or when u start using the dev server
const API_URL = 'http://127.0.0.1:5000';

// const getJSON = (path, options) => 
//     fetch(path, options)
//         .then(res => res.json())
//         .catch(err => console.warn(`API_ERROR: ${err.message}`));

const getResponse = (path, options) =>
    fetch(path, options)
        .then(response => response.json())
        .catch(err => console.warn(`API_ERROR: ${err.message}`));

/**
 * This is a sample class API which you may base your code on.
 * You don't have to do this as a class.
 */
export default class API {

    /**
     * Defaults to the API URL
     * @param {string} url 
     */
    constructor(url = API_URL) {
        this.url = url;
    } 

    makeAPIRequest(path, options) {
        return getResponse(`${this.url}/${path}`, options);
    }

    getUser(user, id, options) {
        if (user == "" && id != "") {
            return this.makeAPIRequest("user/?id=" + id, options);
        } else if (id == "" && user != "") {
            return this.makeAPIRequest("user/?username=" + user, options);
        } else if (user != "" && id != "") {
            return this.makeAPIRequest("user/?username=" + user + "&id=" + id, options);
        } else { 
            return this.makeAPIRequest("user/", options);
        }
    }

    getFeed(options, p, n) {
        return this.makeAPIRequest("user/feed?p=" + p + "&n=" + n, options);
    }

    validateUser(options) {
        return this.makeAPIRequest("auth/login", options);
    }

    validateRegister(options) {
        return this.makeAPIRequest("auth/signup", options);
    }

    likePost(options, id) {
        return this.makeAPIRequest("post/like?id=" + id, options);
    }

    unlikePost(options, id) {
        return this.makeAPIRequest("post/unlike?id=" + id, options);
    }

    postImage(options) {
        return this.makeAPIRequest("post/", options);
    }

    postComment(id, options) {
        return this.makeAPIRequest("post/comment?id=" + id, options);
    }
}
