/*
  Given a list of games, which are objects that look like:

  {
    "id": 112814,
    "matches": "123",
    "tries": "11"
  }

  return a object like such

  {
    "totalMatches": m,
    "totalTries": y
  }

  Where m is the sum of all matches for all games
  and t is the sum of all tries for all games.

  input = [
    {"id": 1,"matches": "123","tries": "11"},
    {"id": 2,"matches": "1","tries": "1"},
    {"id": 3,"matches": "2","tries": "5"}
  ]

  output = {
    matches: 126,
    tries: 17
  }

  test with `node test.js stats.json`
  or `node test.js stats_2.json`
*/

function countStats(list) {
    var numMatches = 0;
    var numTries = 0;
    for (player of list) {
        numMatches += Number(player.matches);
        numTries += Number(player.tries);
    }
    // HINT: maybe REDUCE the problem ;)
    return {
        matches: numMatches,
        tries: numTries
    };
}

module.exports = countStats;
