void main(List<String> arguments) {
  // if argument init: init this program
  // create database: don't do this when there is a database in database dir
  // don't run upgade as the database is empty

  // if argument upgrade: get new web from github
  // save the version of /web/info.json
  // remove the web folder
  // dowload the new web folder from git
  // if the version is the same: do nothing
  // if version is different: run over all menus in the database
  // create new dir for new menus if necessary
  // deploy them to the server

  // if argument upgrade _company_name_: check for of the menu
  // compare info.json from web dir with info.json from menus/_company_name_ dir
  // if dir is not there: new company
  // create new if necessary and then deploy

  // if no argument or help: print help instructions for the use of this program
}
