const axios = require('axios');

// Login as admin first to get JWT token
const API_BASE_URL = 'http://localhost:8080/api';

const juniorNTRMovies = [
    { title: 'RRR', description: 'A fictional story about two legendary revolutionaries and their journey away from home before they started fighting for their country in the 1920s.', duration: 187, language: 'Telugu', genre: 'Action/Drama', posterUrl: 'https://v3img.voot.com/resizeMedium,w_1090,h_613/v3Storage/assets/rrr-1920x1080-1647343093803.jpg', releaseDate: '2022-03-25', status: 'NOW_SHOWING', certification: 'UA' },
    { title: 'Aravinda Sametha Veera Raghava', description: 'A young scion of a powerful family with a long history of violence decides to put an end to the bloodshed which leads him to a path of self discovery.', duration: 162, language: 'Telugu', genre: 'Action/Drama', posterUrl: 'https://m.media-amazon.com/images/M/MV5BNmE3ZjJiYzUtYzNjNC00ZjgyLWEyMTMtOWY2NmJhNDY2YzBjXkEyXkFqcGdeQXVyODIwMDI1NjM@._V1_.jpg', releaseDate: '2018-10-11', status: 'NOW_SHOWING', certification: 'UA' },
    { title: 'Jai Lava Kusa', description: 'Triplets Jai, Lava and Kusa get separated during their childhood and are brought up in different backgrounds. However, their lives take an unexpected turn when they meet as adults.', duration: 150, language: 'Telugu', genre: 'Action/Thriller', posterUrl: 'https://m.media-amazon.com/images/M/MV5BYjE0YWQxZjktOGU4YS00YjE4LWI5ZjAtMzI2MzZkMzQ1MjJlXkEyXkFqcGdeQXVyODIwMDI1NjM@._V1_.jpg', releaseDate: '2017-09-21', status: 'NOW_SHOWING', certification: 'UA' },
    { title: 'Nannaku Prematho', description: 'A young man tries to revive his fathers company and save his family from financial ruin by seeking revenge on his business rival.', duration: 169, language: 'Telugu', genre: 'Action/Drama', posterUrl: 'https://m.media-amazon.com/images/M/MV5BZGY2ODllNWMtNmY5Mi00YmI4LThiNWYtMzJmMDBkNGE2MTI1XkEyXkFqcGdeQXVyODIwMDI1NjM@._V1_.jpg', releaseDate: '2016-01-13', status: 'NOW_SHOWING', certification: 'UA' },
    { title: 'Temper', description: 'A corrupt police officer faces challenges from his family and a criminal gang when he tries to mend his ways.', duration: 147, language: 'Telugu', genre: 'Action/Thriller', posterUrl: 'https://m.media-amazon.com/images/M/MV5BMTMwNDY2MDc3NF5BMl5BanBnXkFtZTgwMjI4NjQzNTE@._V1_.jpg', releaseDate: '2015-02-13', status: 'NOW_SHOWING', certification: 'UA' },
    { title: 'Rabhasa', description: 'A young man with a vendetta against a business tycoon seduces the tycoons daughter and goes to work for him, only to find his motives questioned.', duration: 163, language: 'Telugu', genre: 'Action/Comedy', posterUrl: 'https://m.media-amazon.com/images/M/MV5BZmNlNmU0NzYtYmY2Ni00YzM1LWI0MzMtNzkzNTAwMmRjMjQ1XkEyXkFqcGdeQXVyODIwMDI1NjM@._V1_.jpg', releaseDate: '2014-08-29', status: 'NOW_SHOWING', certification: 'UA' },
    { title: 'Ramayya Vasavadha', description: 'Nandu, a happy-go-lucky college student, falls head over heels in love with Akarsha and goes all out to win her affections.', duration: 165, language: 'Telugu', genre: 'Action/Drama', posterUrl: 'https://m.media-amazon.com/images/M/MV5BMTMxNDkwNjQ3N15BMl5BanBnXkFtZTgwMjQ2NTIyMDE@._V1_.jpg', releaseDate: '2013-10-10', status: 'NOW_SHOWING', certification: 'UA' },
    { title: 'Baadshah', description: 'Rama Rao fails to get a job with the police force due to his fathers connections with a gangster. But when his girlfriend is kidnapped, he sets out to rescue her.', duration: 167, language: 'Telugu', genre: 'Action/Comedy', posterUrl: 'https://m.media-amazon.com/images/M/MV5BMTgzNzYwNzUzNF5BMl5BanBnXkFtZTgwNzY0NTIyMDE@._V1_.jpg', releaseDate: '2013-04-05', status: 'NOW_SHOWING', certification: 'UA' },
    { title: 'Dammu', description: 'Rama Chandra, an orphan, is determined to avenge the death of his parents. However, he faces multiple challenges when the ruling party tries to hamper his plans.', duration: 153, language: 'Telugu', genre: 'Action', posterUrl: 'https://m.media-amazon.com/images/M/MV5BMjEwNjMzNTI3MV5BMl5BanBnXkFtZTgwNjQwNTIyMDE@._V1_.jpg', releaseDate: '2012-04-27', status: 'NOW_SHOWING', certification: 'UA' },
    { title: 'Oosaravelli', description: 'A youngster, who does anything for money, avenges on those who killed the familys bread winners.', duration: 163, language: 'Telugu', genre: 'Action/Thriller', posterUrl: 'https://m.media-amazon.com/images/M/MV5BMjA4MjQxOTY2MF5BMl5BanBnXkFtZTgwNzA1NTIyMDE@._V1_.jpg', releaseDate: '2011-10-06', status: 'NOW_SHOWING', certification: 'UA' },
    { title: 'Shakti', description: 'The central minister who wants to become the prime minister of the country tries every trick in the book to eliminate his son-in-law he never liked.', duration: 170, language: 'Telugu', genre: 'Action/Drama', posterUrl: 'https://m.media-amazon.com/images/M/MV5BMjMzNDE0MTU4N15BMl5BanBnXkFtZTgwNjkxNTIyMDE@._V1_.jpg', releaseDate: '2011-04-01', status: 'NOW_SHOWING', certification: 'UA' },
    { title: 'Brindavanam', description: 'Krish is a playboy who has a problem committing to one woman. In order to impress his girlfriends family, he asks his best friend Indu to pose as his girlfriend.', duration: 170, language: 'Telugu', genre: 'Romance/Comedy', posterUrl: 'https://m.media-amazon.com/images/M/MV5BMjA0NjY3NzQ3Ml5BMl5BanBnXkFtZTgwNjk1NTIyMDE@._V1_.jpg', releaseDate: '2010-10-14', status: 'NOW_SHOWING', certification: 'UA' },
    { title: 'Adhurs', description: 'Chari who is orphaned takes on the responsibility of his caretakers two sons. However, his life changes when he meets his estranged twin brother and his girlfriend.', duration: 147, language: 'Telugu', genre: 'Action/Comedy', posterUrl: 'https://m.media-amazon.com/images/M/MV5BMjM5MTM5ODU5Nl5BMl5BanBnXkFtZTgwNzI1NTIyMDE@._V1_.jpg', releaseDate: '2010-01-14', status: 'NOW_SHOWING', certification: 'UA' },
    { title: 'Kantri', description: 'An NRI returns to his village and brings a change in the society by reforming the rich and the influential.', duration: 165, language: 'Telugu', genre: 'Action/Drama', posterUrl: 'https://m.media-amazon.com/images/M/MV5BMTc3Njc5Mjc2MF5BMl5BanBnXkFtZTgwNzU1NTIyMDE@._V1_.jpg', releaseDate: '2008-05-09', status: 'NOW_SHOWING', certification: 'UA' },
    { title: 'Yamadonga', description: 'Raja who is born to make a difference enters the darkness of the underworld and with the help of Lord Krishna puts an end to evil forces.', duration: 185, language: 'Telugu', genre: 'Fantasy/Action', posterUrl: 'https://m.media-amazon.com/images/M/MV5BMjEwNDY3MTIxMV5BMl5BanBnXkFtZTgwNzk1NTIyMDE@._V1_.jpg', releaseDate: '2007-08-15', status: 'NOW_SHOWING', certification: 'UA' },
    { title: 'Rakhi', description: 'Rakhi, a young girl, is in love with her brothers friend but things take a turn when they reject the alliance.', duration: 165, language: 'Telugu', genre: 'Action/Drama', posterUrl: 'https://m.media-amazon.com/images/M/MV5BMjI0MTQxODE0NF5BMl5BanBnXkFtZTgwNzA2NTIyMDE@._V1_.jpg', releaseDate: '2006-12-22', status: 'NOW_SHOWING', certification: 'UA' },
    { title: 'Ashok', description: 'Ashok falls in love with Anjali who is the daughter of a powerful minister. However, he must prove his love and worth before he wins her heart.', duration: 175, language: 'Telugu', genre: 'Action/Romance', posterUrl: 'https://m.media-amazon.com/images/M/MV5BMjI1MTE0ODQ5NV5BMl5BanBnXkFtZTgwNzU2NTIyMDE@._V1_.jpg', releaseDate: '2006-07-13', status: 'NOW_SHOWING', certification: 'UA' },
    { title: 'Narasimhudu', description: 'Narasimha is a young man with the strength of a thousand men. He must fight an evil king who is terrorizing the village.', duration: 175, language: 'Telugu', genre: 'Action/Drama', posterUrl: 'https://m.media-amazon.com/images/M/MV5BMjE3MTE4NzQ3MV5BMl5BanBnXkFtZTgwNjY2NTIyMDE@._V1_.jpg', releaseDate: '2005-05-20', status: 'NOW_SHOWING', certification: 'UA' },
    { title: 'Samba', description: 'A man tries to protect the girl he loves from the plans of an evil businessman.', duration: 175, language: 'Telugu', genre: 'Action/Romance', posterUrl: 'https://m.media-amazon.com/images/M/MV5BMjQwMjAzMTUxMV5BMl5BanBnXkFtZTgwNzY2NTIyMDE@._V1_.jpg', releaseDate: '2004-07-08', status: 'NOW_SHOWING', certification: 'UA' },
    { title: 'Simhadri', description: 'Simhadri is a loyal servant who will go to any lengths to protect his masters daughter. However, things get complicated when he falls in love with her.', duration: 175, language: 'Telugu', genre: 'Action/Drama', posterUrl: 'https://m.media-amazon.com/images/M/MV5BMTk4NTAzNzQ3MV5BMl5BanBnXkFtZTgwNjk2NTIyMDE@._V1_.jpg', releaseDate: '2003-07-09', status: 'NOW_SHOWING', certification: 'UA' },
    { title: 'Aadi', description: 'Aadi, a young boy, takes a decision to overcome the mistakes done by his parents. However, destiny has other plans in store for him.', duration: 160, language: 'Telugu', genre: 'Action/Drama', posterUrl: 'https://m.media-amazon.com/images/M/MV5BMjI5NjYzMzc5Nl5BMl5BanBnXkFtZTgwNzA3NTIyMDE@._V1_.jpg', releaseDate: '2002-04-26', status: 'NOW_SHOWING', certification: 'UA' },
    { title: 'Student No. 1', description: 'A student stands up against corrupt college authorities who are involved in unethical practices.', duration: 165, language: 'Telugu', genre: 'Action/Drama', posterUrl: 'https://m.media-amazon.com/images/M/MV5BMjI2MTU0MTYxNl5BMl5BanBnXkFtZTgwNjg3NTIyMDE@._V1_.jpg', releaseDate: '2001-09-27', status: 'NOW_SHOWING', certification: 'UA' },
    { title: 'Ninnu Choodalani', description: 'A love story that revolves around a young couple who face opposition from their families.', duration: 150, language: 'Telugu', genre: 'Romance/Drama', posterUrl: 'https://m.media-amazon.com/images/M/MV5BMjE2MTAwMTU2NV5BMl5BanBnXkFtZTgwNzE3NTIyMDE@._V1_.jpg', releaseDate: '2001-05-04', status: 'NOW_SHOWING', certification: 'U' },
    { title: 'Naa Alludu', description: 'A young man tries to win the heart of his girlfriend and her familys approval.', duration: 154, language: 'Telugu', genre: 'Action/Comedy', posterUrl: 'https://m.media-amazon.com/images/M/MV5BMjQxNjg4Nzc5NF5BMl5BanBnXkFtZTgwNjI3NTIyMDE@._V1_.jpg', releaseDate: '2005-05-14', status: 'NOW_SHOWING', certification: 'UA' },
    { title: 'Andhrawala', description: 'A factionist picks an NRI for his daughter expecting him to be meek, but the guy turns out to be someone who stands up for the right.', duration: 180, language: 'Telugu', genre: 'Action/Drama', posterUrl: 'https://m.media-amazon.com/images/M/MV5BMjQzMjA3MjI5MV5BMl5BanBnXkFtZTgwNzI3NTIyMDE@._V1_.jpg', releaseDate: '2004-01-01', status: 'NOW_SHOWING', certification: 'UA' },
    { title: 'Naa Autograph', description: 'The story is about a young man who falls in love with his childhood sweetheart but circumstances separate them.', duration: 170, language: 'Telugu', genre: 'Romance/Drama', posterUrl: 'https://m.media-amazon.com/images/M/MV5BMjM0MjU1NzU3N15BMl5BanBnXkFtZTgwNzc3NTIyMDE@._V1_.jpg', releaseDate: '2004-02-19', status: 'NOW_SHOWING', certification: 'UA' }
];

async function addMovies() {
    try {
        // Login as admin
        const loginResponse = await axios.post(`${API_BASE_URL}/auth/login`, {
            username: 'admin',
            password: 'admin123'
        });

        const token = loginResponse.data.token;
        console.log('✅ Logged in as admin');

        // Add each movie
        let successCount = 0;
        let failCount = 0;

        for (const movie of juniorNTRMovies) {
            try {
                await axios.post(`${API_BASE_URL}/movies`, movie, {
                    headers: {
                        'Authorization': `Bearer ${token}`
                    }
                });
                successCount++;
                console.log(`✅ Added: ${movie.title}`);
            } catch (error) {
                failCount++;
                console.log(`❌ Failed: ${movie.title} - ${error.response?.data?.message || error.message}`);
            }
        }

        console.log(`\n📊 Summary:`);
        console.log(`   ✅ Successfully added: ${successCount} movies`);
        console.log(`   ❌ Failed: ${failCount} movies`);
        console.log(`   📝 Total: ${juniorNTRMovies.length} movies`);

    } catch (error) {
        console.error('❌ Error:', error.response?.data || error.message);
    }
}

addMovies();
