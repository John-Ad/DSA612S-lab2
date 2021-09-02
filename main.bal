import ballerina/http;

type UserDetails record {|
    string email;
    string name;
    string surname;
|};

UserDetails[] users = [];

service /users on new http:Listener(8080) {
    resource function post add(@http:Payload UserDetails newUser) returns json {
        foreach var user in users {
            if user.email == newUser.email {
                return {stat: "err", data: (), err: "user already exists"};
            }
        }
        users.push(newUser);
        return {stat: "ok"};
    }

    resource function get user(@http:Payload string email) returns json {
        foreach var user in users {
            if email == user.email {
                return {stat: "ok", data: user};
            }
        }
        return {stat: "err", data: (), err: "user not found"};
    }

    resource function post update(@http:Payload UserDetails updatedUser) returns json {
        foreach var user in users {
            if user.email == updatedUser.email {
                user.name = updatedUser.name;
                user.surname = updatedUser.surname;
                return {stat: "ok"};
            }
        }
        return {stat: "err", data: (), err: "user not found"};
    }

    resource function post delete(@http:Payload string email) returns json {
        foreach int i in 0 ..< users.length() {
            if users[i].email == email {
                _ = users.remove(i);
                return {stat: "ok"};
            }
        }
        return {stat: "err", data: (), err: "user not found"};
    }

}
