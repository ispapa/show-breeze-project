# ShowBreeze

https://drive.google.com/file/d/1su60B3_Ettk0R0VVBNLCwp409VtskNNT/view?usp=sharing

ShowBreeze is an event and ticketing management app catering to concerts, theater, plays, musicals, and more. It seamlessly connects event-goers, performers, venue managers, and organizers, offering easy seat selection, ticket purchase, and resale options while prioritizing smaller events often overlooked by major platforms.

This repo contains a boilerplate setup for spinning up 3 Docker containers: 
1. A MySQL 8 container for obvious reasons
1. A Python Flask container to implement a REST API
1. A Local AppSmith Server

## How to setup and start the containers
**Important** - you need Docker Desktop installed

1. Clone this repository.  
1. Create a file named `db_root_password.txt` in the `secrets/` folder and put inside of it the root password for MySQL. 
1. Create a file named `db_password.txt` in the `secrets/` folder and put inside of it the password you want to use for the a non-root user named webapp. 
1. In a terminal or command prompt, navigate to the folder with the `docker-compose.yml` file.  

1. Build the images with `docker compose build`
1. Start the containers with `docker compose up`.  To run in detached mode, run `docker compose up -d`. 




