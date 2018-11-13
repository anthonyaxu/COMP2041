/*
* Given a list of career stats for a team of rugby players,
* a list of player names, and a list of team names, in the format below:
*
* players
* {
*     "players": [
*         {
*             "id": 112814,
*             "matches": "123",
*             "tries": "11"
*         }
*     ],
*     "team": {
*         "id": 10,
*         "coach": "John Simmons"
*     }
* }
* names
* {
*     "names": [
*         {
*             "id": 112814,
*             "name": "Greg Growden"
*         }
*     ]
* }
* teams
* {
*     "teams": [
*         {
*             "id": 10,
*             "team": "NSW Waratahs"
*         }
*     ]
* }
* Write a program that returns a 'team sheet' that lists
* the team, coach, players in that order in the following list format.
*
* [
*     "Team Name, coached by CoachName",
*     "1. PlayerName",
*     "2. PlayerName"
*     ....
* ]
*
* Where each element is a string, and the order of the players
* is ordered by the most number of matches played to the least number of matches played.
*
* For example, the following input should match the
* following output exactly.
*
* input data
* {
*     "players": [
*         {"id": 1,"matches": "123", "tries": "11"},
*         {"id": 2,"matches": "1",   "tries": "1"},
*         {"id": 3,"matches": "2",   "tries": "5"}
*     ],
*     "team": {
*         "id": 10,
*         "coach": "John Simmons"
*     }
* }
*
* {
*     "names": [
*         {"id": 1, "John Fake"},
*         {"id": 2, "Jimmy Alsofake"},
*         {"id": 3, "Jason Fakest"}
*     ]
* }
*
* {
*     "teams": [
*         {"id": 10, "Greenbay Packers"},
*     ]
* }
*
* output
* [
*     "Greenbay Packers, coached by John Simmons",
*     "1. John Fake",
*     "2. Jason Fakest",
*     "3. Jimmy Alsofake"
* ]
*
* test with
* `node test.js team.json names.json teams.json`
*/

function bubbleSort(array) {
    var swapped;
    do {
        swapped = false;
        for (var i = 0; i < array.length-1; i++) {
            if (array[i].matches < array[i+1].matches) {
                var temp = array[i];
                array[i] = array[i+1];
                array[i+1] = temp;
                swapped = true;
            }
        }
    } while (swapped);
    return array;
}

function makeTeamList(teamData, namesData, teamsData) {
    let coach = teamData.team;
    var coachName = coach.coach
    var coachID = coach.id
    
    for (let teams of teamsData) {
        if (teams.id === coachID) {
            var coachTeam = teams.team;
        }
    }
    var matchesArray = [];
    var playerName;
    for (let players of teamData.players) {
        for (let names of namesData) {
            if (players.id === names.id) {
                playersName = names.name;
                break;
            }
        }
        matchesArray.push({id: players.id, matches: players.matches, playerName: playersName});
    }
    matchesArray = bubbleSort(matchesArray);
    
    var namesArray = [];
    namesArray.push(coachTeam + ", coached by " + coachName);
    for (var i = 0; i < matchesArray.length; i++) {
        namesArray.push(i+1 + ". " + matchesArray[i].playerName);
    }
    return namesArray;
}

module.exports = makeTeamList;
