
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

Parse.Cloud.define("getPlayerLifetimeTotalPuzzles", function(request, response){
                   var stageAssemble = Parse.Object.extend('stageAssemble');
                   var query = new Parse.Query(stageAssemble);
                   query.equalTo("playerName", request.params.playerName);
                   query.limit(100);
                   query.find({
                              success: function(results){
                              var sum = 0;
                              for (var i = 0; i < results.length; i++)
                              {
                                sum += results[i].get("totalResponses");
                              } // for ends here
                              
                              //response.success(sum/results.length);
                              response.success(sum);
                              
                              }, // success ends here
                              error: function(){
                              response.error("NA");
                              } // error ends here
            }); // query.find ends here
});

Parse.Cloud.define("getPlayerLifetimeTotalCorrectPuzzles", function(request, response){
                   var stageAssemble = Parse.Object.extend('stageAssemble');
                   var query = new Parse.Query(stageAssemble);
                   query.equalTo("playerName", request.params.playerName);
                   query.limit(100);
                   query.find({
                              success: function(results){
                              var sum = 0, wrong = 0;
                              for (var i = 0; i < results.length; i++)
                              {
                                sum += results[i].get("totalResponses");
                                wrong += results[i].get("totalResponsesWrong");
                              } // for ends here
                              
                              response.success(sum - wrong);
                              
                              }, // success ends here
                              error: function(){
                              response.error("NA");
                              } // error ends here
            }); // query.find ends here
});

//
// STAGE ONE
//
Parse.Cloud.define("getPlayerStageOneTotalPuzzles", function(request, response){
                   var stageAssemble = Parse.Object.extend('stageAssemble');
                   
                   var query11 = new Parse.Query(stageAssemble);
                   query11.equalTo("playerName", request.params.playerName);
                   query11.equalTo("levelPlayed", 11);
                   query11.limit(100);
                   
                   var query12 = new Parse.Query(stageAssemble);
                   query12.equalTo("playerName", request.params.playerName);
                   query12.equalTo("levelPlayed", 12);
                   query12.limit(100);
                   
                   var query13 = new Parse.Query(stageAssemble);
                   query13.equalTo("playerName", request.params.playerName);
                   query13.equalTo("levelPlayed", 13);
                   query13.limit(100);
                   
                   var query = Parse.Query.or(query11, query12, query13);
                   query.find({
                              success: function(results){
                              var sum = 0, wrong = 0;
                              for (var i = 0; i < results.length; i++)
                              {
                              sum += results[i].get("totalResponses");
                              //wrong += results[i].get("totalResponsesWrong");
                              } // for ends here
                              
                              //response.success(sum - wrong);
                              response.success(sum);
                              
                              }, // success ends here
                              error: function(){
                              response.error("NA");
                              } // error ends here
                              }); // query.find ends here
                   });

Parse.Cloud.define("getPlayerStageOneTotalCorrectPuzzles", function(request, response){
                   var stageAssemble = Parse.Object.extend('stageAssemble');
                   
                   var query11 = new Parse.Query(stageAssemble);
                   query11.equalTo("playerName", request.params.playerName);
                   query11.equalTo("levelPlayed", 11);
                   query11.limit(100);
                   
                   var query12 = new Parse.Query(stageAssemble);
                   query12.equalTo("playerName", request.params.playerName);
                   query12.equalTo("levelPlayed", 12);
                   query12.limit(100);
                   
                   var query13 = new Parse.Query(stageAssemble);
                   query13.equalTo("playerName", request.params.playerName);
                   query13.equalTo("levelPlayed", 13);
                   query13.limit(100);
                   
                   var query = Parse.Query.or(query11, query12, query13);
                   query.find({
                              success: function(results){
                              var sum = 0, wrong = 0;
                              for (var i = 0; i < results.length; i++)
                              {
                              sum += results[i].get("totalResponses");
                              wrong += results[i].get("totalResponsesWrong");
                              } // for ends here
                              
                              response.success(sum - wrong);
                             
                              }, // success ends here
                              error: function(){
                              response.error("NA");
                              } // error ends here
                              }); // query.find ends here
                   });

Parse.Cloud.define("getPlayerStageOneResponseTime", function(request, response){
                   var stageAssemble = Parse.Object.extend('stageAssemble');
                   
                   var query11 = new Parse.Query(stageAssemble);
                   query11.equalTo("playerName", request.params.playerName);
                   query11.equalTo("levelPlayed", 11);
                   query11.limit(100);
                   
                   var query12 = new Parse.Query(stageAssemble);
                   query12.equalTo("playerName", request.params.playerName);
                   query12.equalTo("levelPlayed", 12);
                   query12.limit(100);
                   
                   var query13 = new Parse.Query(stageAssemble);
                   query13.equalTo("playerName", request.params.playerName);
                   query13.equalTo("levelPlayed", 13);
                   query13.limit(100);
                   
                   var query = Parse.Query.or(query11, query12, query13);
                   query.find({
                              success: function(results){
                              var sum = 0, wrong = 0;
                              for (var i = 0; i < results.length; i++)
                              {
                                sum += results[i].get("levelAverageResponseTimeInMs");
                                //wrong += results[i].get("totalResponsesWrong");
                              } // for ends here
                              
                              if (results.length)
                              {
                                sum = sum / results.length;
                              }
                              
                              response.success(sum);
                              
                              }, // success ends here
                              error: function(){
                              response.error("NA");
                              } // error ends here
                              }); // query.find ends here
                   });

//
// STAGE TWO
//
Parse.Cloud.define("getPlayerStageTwoTotalPuzzles", function(request, response){
                   var stageAssemble = Parse.Object.extend('stageAssemble');
                   
                   var query21 = new Parse.Query(stageAssemble);
                   query21.equalTo("playerName", request.params.playerName);
                   query21.equalTo("levelPlayed", 21);
                   query21.limit(100);
                   
                   var query22 = new Parse.Query(stageAssemble);
                   query22.equalTo("playerName", request.params.playerName);
                   query22.equalTo("levelPlayed", 22);
                   query22.limit(100);
                   
                   var query = Parse.Query.or(query21, query22);
                   query.find({
                              success: function(results){
                              var sum = 0, wrong = 0;
                              for (var i = 0; i < results.length; i++)
                              {
                              sum += results[i].get("totalResponses");
                              } // for ends here
                              
                              response.success(sum);
                              
                              }, // success ends here
                              error: function(){
                              response.error("NA");
                              } // error ends here
                              }); // query.find ends here
                   });

Parse.Cloud.define("getPlayerStageTwoTotalCorrectPuzzles", function(request, response){
                   var stageAssemble = Parse.Object.extend('stageAssemble');
                   
                   var query21 = new Parse.Query(stageAssemble);
                   query21.equalTo("playerName", request.params.playerName);
                   query21.equalTo("levelPlayed", 21);
                   query21.limit(100);
                   
                   var query22 = new Parse.Query(stageAssemble);
                   query22.equalTo("playerName", request.params.playerName);
                   query22.equalTo("levelPlayed", 22);
                   query22.limit(100);
                   
                   var query = Parse.Query.or(query21, query22);
                   query.find({
                              success: function(results){
                              var sum = 0, wrong = 0;
                              for (var i = 0; i < results.length; i++)
                              {
                              sum += results[i].get("totalResponses");
                              wrong += results[i].get("totalResponsesWrong");
                              } // for ends here
                              
                              response.success(sum - wrong);
                              
                              }, // success ends here
                              error: function(){
                              response.error("NA");
                              } // error ends here
                              }); // query.find ends here
                   });


Parse.Cloud.define("getPlayerStageTwoResponseTime", function(request, response){
                   var stageAssemble = Parse.Object.extend('stageAssemble');
                   
                   var query21 = new Parse.Query(stageAssemble);
                   query21.equalTo("playerName", request.params.playerName);
                   query21.equalTo("levelPlayed", 21);
                   query21.limit(100);
                   
                   var query22 = new Parse.Query(stageAssemble);
                   query22.equalTo("playerName", request.params.playerName);
                   query22.equalTo("levelPlayed", 22);
                   query22.limit(100);
                   
                   var query23 = new Parse.Query(stageAssemble);
                   query23.equalTo("playerName", request.params.playerName);
                   query23.equalTo("levelPlayed", 23);
                   query23.limit(100);
                   
                   var query = Parse.Query.or(query21, query22, query23);
                   query.find({
                              success: function(results){
                              var sum = 0, wrong = 0;
                              for (var i = 0; i < results.length; i++)
                              {
                              sum += results[i].get("levelAverageResponseTimeInMs");
                              //wrong += results[i].get("totalResponsesWrong");
                              } // for ends here
                              
                              if (results.length)
                              {
                                sum = sum / results.length;
                              }
                              
                              response.success(sum);
                              
                              }, // success ends here
                              error: function(){
                              response.error("NA");
                              } // error ends here
                              }); // query.find ends here
                   });
//
// STAGE THREE
//
Parse.Cloud.define("getPlayerStageThreeTotalPuzzles", function(request, response){
                   var stageAssemble = Parse.Object.extend('stageAssemble');
                   
                   var query31 = new Parse.Query(stageAssemble);
                   query31.equalTo("playerName", request.params.playerName);
                   query31.equalTo("levelPlayed", 31);
                   query31.limit(100);
                   
                   var query32 = new Parse.Query(stageAssemble);
                   query32.equalTo("playerName", request.params.playerName);
                   query32.equalTo("levelPlayed", 32);
                   query32.limit(100);
                   
                   var query = Parse.Query.or(query31, query32);
                   query.find({
                              success: function(results){
                              var sum = 0, wrong = 0;
                              for (var i = 0; i < results.length; i++)
                              {
                              sum += results[i].get("totalResponses");
                              } // for ends here
                              
                              response.success(sum);
                              
                              }, // success ends here
                              error: function(){
                              response.error("NA");
                              } // error ends here
                              }); // query.find ends here
                   });

Parse.Cloud.define("getPlayerStageThreeTotalCorrectPuzzles", function(request, response){
                   var stageAssemble = Parse.Object.extend('stageAssemble');
                   
                   var query31 = new Parse.Query(stageAssemble);
                   query31.equalTo("playerName", request.params.playerName);
                   query31.equalTo("levelPlayed", 31);
                   query31.limit(100);
                   
                   var query32 = new Parse.Query(stageAssemble);
                   query32.equalTo("playerName", request.params.playerName);
                   query32.equalTo("levelPlayed", 32);
                   query32.limit(100);
                   
                   var query = Parse.Query.or(query31, query32);
                   query.find({
                              success: function(results){
                              var sum = 0, wrong = 0;
                              for (var i = 0; i < results.length; i++)
                              {
                              sum += results[i].get("totalResponses");
                              wrong += results[i].get("totalResponsesWrong");
                              } // for ends here
                              
                              response.success(sum - wrong);
                              
                              }, // success ends here
                              error: function(){
                              response.error("NA");
                              } // error ends here
                              }); // query.find ends here
                   });

Parse.Cloud.define("getPlayerStageThreeResponseTime", function(request, response){
                   var stageAssemble = Parse.Object.extend('stageAssemble');
                   
                   var query31 = new Parse.Query(stageAssemble);
                   query31.equalTo("playerName", request.params.playerName);
                   query31.equalTo("levelPlayed", 31);
                   query31.limit(100);
                   
                   var query32 = new Parse.Query(stageAssemble);
                   query32.equalTo("playerName", request.params.playerName);
                   query32.equalTo("levelPlayed", 32);
                   query32.limit(100);
                   
                   var query33 = new Parse.Query(stageAssemble);
                   query33.equalTo("playerName", request.params.playerName);
                   query33.equalTo("levelPlayed", 33);
                   query33.limit(100);
                   
                   var query = Parse.Query.or(query31, query32, query33);
                   query.find({
                              success: function(results){
                              var sum = 0, wrong = 0;
                              for (var i = 0; i < results.length; i++)
                              {
                              sum += results[i].get("levelAverageResponseTimeInMs");
                              //wrong += results[i].get("totalResponsesWrong");
                              } // for ends here
                              
                              if (results.length)
                              {
                                sum = sum / results.length;
                              }
                              
                              response.success(sum);
                              
                              }, // success ends here
                              error: function(){
                              response.error("NA");
                              } // error ends here
                              }); // query.find ends here
                   });

//
// Global Ranking for given playerName
//
Parse.Cloud.define("updatePlayerGlobalRank", function(request, response){
                   var stageAssemble = Parse.Object.extend('stageAssemble');
                   var query = new Parse.Query(stageAssemble);
                   query.equalTo("playerName", request.params.playerName);
                   query.limit(100);
                   query.find({
                              success: function(results){
                              var sum = 0, wrong = 0, timeLeft = 0, total = 0;
                              for (var i = 0; i < results.length; i++)
                              {
                              sum += results[i].get("totalResponses");
                              wrong += results[i].get("totalResponsesWrong");
                              timeLeft += results[i].get("levelAverageResponseTimeInMs");
                              } // for ends here
                              
                              //response.success((sum - wrong)/sum * timeLeft);
                              total = ((sum - wrong)/sum * timeLeft);
                              
                              var rankUpdate = new Parse.Query("stageAssembleGlobalRank");
                              rankUpdate.equalTo("playerName", request.params.playerName);
                              rankUpdate.find({
                                              success: function(results) {
                                              var obj = results[0];
                                              
                                              if (obj != null)
                                              {
                                              obj.set("playerTotalScore", total);
                                              
                                              obj.save(null,{
                                                       success: function (object) {
                                                       response.success("player found, score updated");
                                                       },
                                                       error: function (object, error) {
                                                       response.error("player found, score not updated");
                                                       }
                                                       });
                                              } // if ends
                                              else
                                              {
                                              var glbRank = Parse.Object.extend('stageAssembleGlobalRank');
                                              var queryRank = new glbRank();
                                              
                                              queryRank.set("playerName", request.params.playerName);
                                              queryRank.set("playerTotalScore", total);
                                              
                                              // Save
                                              queryRank.save(null, {
                                                             success: function(queryRank) {
                                                             response.success("Saved score for new player");
                                                             },
                                                             error: function(queryRank, error){
                                                             response.error("Not saved score for new player");
                                                             }
                                                             });
                                              }
                                              response.success("rank update find success");
                                              },
                                              error: function(result, error) {
                                              response.error("rank update find error");
                                              //console.log("failed");
                                              }
                                              });
                              
                              
                              }, // success ends here
                              error: function(){
                              response.error("player not found");
                              } // error ends here
                              }); // query.find ends here
                   });

Parse.Cloud.define("getPlayerGlobalRank", function(request, response){
                   var stageAssemble = Parse.Object.extend('stageAssembleGlobalRank');
                   var query = new Parse.Query(stageAssemble);
                   query.equalTo("playerName", request.params.playerName);
                   query.limit(1000);
                   query.find({
                              success: function(results){
                              var sum = results[0].get("playerTotalScore");
                              console.log(sum);
                              var stageAssemble = Parse.Object.extend('stageAssembleGlobalRank');
                              var query = new Parse.Query(stageAssemble);
                              query.greaterThanOrEqualTo("playerTotalScore", sum);
                              query.find({
                                         success: function(results){
                                         //console.log(results);
                                         //console.log(results.length);
                                         response.success(results.length);
                                         }, // success ends here
                                         error: function(){
                                         response.error("No rank for current player");
                                         } // error ends here
                                         }); // query.find ends here
                              }, // success ends here
                              error: function(){
                              response.error("No rank and player in database");
                              } // error ends here
                              }); // query.find ends here
                   });
