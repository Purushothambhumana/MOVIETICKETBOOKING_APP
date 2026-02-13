# Movie Ticket Booking Application

**Developed by:** Bhumana Purushotham

A fully functional movie ticket booking application built with Spring Boot backend and React frontend.

## 🎬 Features

### User Features
- **Authentication**: User registration and login with JWT security
- **City Selection**: Select your city to view movies and theatres
- **Movie Browsing**: Browse movies (Now Showing / Upcoming)
- **Movie Details**: View detailed information about movies
- **Theatre & Show Selection**: Choose theatre and show timings
- **Seat Selection**: Interactive seat selection with modern grid interface
  - Different seat types (Silver, Gold, Platinum)
  - Real-time seat availability
  - Visual seat selection interface
- **Booking**: Book tickets with instant confirmation
- **My Bookings**: View booking history and cancel bookings

### Admin Features
- **Movie Management**: Add, update, delete movies
- **Theatre Management**: Manage theatres across cities
- **Screen Management**: Configure screens with custom seat layouts
- **Show Management**: Create shows with date, time, and pricing
- **Seat Layout Configuration**: Set rows, columns, and seat types

## 🛠️ Tech Stack

### Backend
- Java 8+
- Spring Boot 2.7.x
- Spring Security (JWT Authentication)
- Spring Data JPA (Hibernate)
- MySQL 5.7+
- Maven

### Frontend
- React 18
- React Router DOM
- Bootstrap 5
- Axios
- Modern Theme (Red/White color scheme)

## 📋 Prerequisites

Before running this application, ensure you have:

- **Java 8+** installed ([Download](https://www.oracle.com/java/technologies/downloads/))
- **Maven 3.6+** installed ([Download](https://maven.apache.org/download.cgi))
- **MySQL 5.7+** installed and running ([Download](https://dev.mysql.com/downloads/))
- **Node.js 14+** and npm installed ([Download](https://nodejs.org/))

## 🚀 Setup Instructions

### 1. Database Setup

1. Start your MySQL server
2. Open MySQL command line or MySQL Workbench
3. Run the database schema:

```bash
mysql -u root -p < database/schema.sql
```

Or manually:
- Create database: `CREATE DATABASE bookmyshow_db;`
- Run the SQL script located at `database/schema.sql`

**Default Admin Credentials (created by schema):**
- Username: `admin`
- Password: `admin123`

### 2. Backend Setup

1. Navigate to backend directory:
```bash
cd backend
```

2. Update database credentials in `src/main/resources/application.properties`:
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/bookmyshow_db
spring.datasource.username=root
spring.datasource.password=your_mysql_password
```

3. Install dependencies and build:
```bash
mvn clean install
```

4. Run the Spring Boot application:
```bash
mvn spring-boot:run
```

The backend will start on `http://localhost:8080`

**Verify backend is running:**
- Open browser: `http://localhost:8080/api/movies`
- You should see a JSON response with movies

### 3. Frontend Setup

1. Navigate to frontend directory:
```bash
cd frontend
```

2. Install dependencies:
```bash
npm install
```

3. Start the React development server:
```bash
npm start
```

The frontend will start on `http://localhost:3000` and automatically open in your browser.

## 🎯 Using the Application

### For Users:

1. **Register**: Create a new account at `/register`
2. **Login**: Login with your credentials at `/login`
3. **Select City**: Choose your city from the home page
4. **Browse Movies**: View available movies
5. **Select Movie**: Click on a movie to see details
6. **Choose Show**: Select theatre and show time
7. **Select Seats**: Pick your seats on the interactive seat map
8. **Confirm Booking**: Review and confirm your booking
9. **View Bookings**: Check all your bookings at `/my-bookings`

### For Admins:

1. **Login** as admin (username: `admin`, password: `admin123`)
2. **Access Admin Panel**: Click "Admin" in navbar or go to `/admin`
3. **Manage Movies**: Add new movies with all details
4. **Manage Theatres**: Create theatres in different cities
5. **Manage Screens**: Add screens to theatres and configure seat layouts
6. **Manage Shows**: Create shows for movies with pricing

## 📁 Project Structure

```
antimovie/
├── backend/
│   ├── src/main/java/com/bookmyshow/
│   │   ├── entity/          # JPA Entities
│   │   ├── repository/      # Data repositories
│   │   ├── service/         # Business logic
│   │   ├── controller/      # REST controllers
│   │   ├── dto/             # Data Transfer Objects
│   │   ├── security/        # JWT & Security config
│   │   └── exception/       # Exception handling
│   ├── src/main/resources/
│   │   └── application.properties
│   └── pom.xml
├── frontend/
│   ├── src/
│   │   ├── components/
│   │   │   ├── auth/        # Login, Register
│   │   │   ├── user/        # User components
│   │   │   ├── admin/       # Admin dashboard
│   │   │   └── common/      # Navbar, PrivateRoute
│   │   ├── services/        # API services
│   │   ├── utils/           # Axios config
│   │   ├── App.jsx
│   │   └── App.css
│   └── package.json
├── database/
│   └── schema.sql
└── README.md
```

## 🔌 API Endpoints

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user

### Movies
- `GET /api/movies` - Get all movies
- `GET /api/movies/{id}` - Get movie by ID
- `GET /api/movies/status/{status}` - Get movies by status
- `POST /api/movies` - Create movie (Admin)
- `PUT /api/movies/{id}` - Update movie (Admin)
- `DELETE /api/movies/{id}` - Delete movie (Admin)

### Theatres
- `GET /api/theatres` - Get all theatres
- `GET /api/theatres/city/{city}` - Get theatres by city
- `POST /api/theatres` - Create theatre (Admin)
- `POST /api/theatres/screens` - Create screen (Admin)
- `POST /api/theatres/screens/{screenId}/seats` - Create seats (Admin)

### Shows
- `GET /api/shows` - Get all shows
- `GET /api/shows/movie/{movieId}` - Get shows by movie
- `GET /api/shows/movie/{movieId}/city/{city}` - Get shows by movie and city
- `POST /api/shows` - Create show (Admin)
- `DELETE /api/shows/{id}` - Delete show (Admin)

### Bookings
- `POST /api/bookings` - Create booking (Authenticated)
- `GET /api/bookings/my-bookings` - Get user bookings (Authenticated)
- `PUT /api/bookings/{id}/cancel` - Cancel booking (Authenticated)
- `GET /api/bookings/shows/{showId}/available-seats` - Get available seats

## 🎨 UI/UX Features

- **Clean Modern Theme**: Professional red (#C4242B) and white color scheme
- **Responsive Design**: Works on desktop, tablet, and mobile
- **Interactive Seat Map**: Click to select/deselect seats
- **Real-time Updates**: Seat availability updates in real-time
- **Smooth Navigation**: React Router for seamless page transitions
- **Form Validation**: Client and server-side validation
- **Error Handling**: User-friendly error messages

## 🔐 Security Features

- JWT-based authentication
- Password encryption using BCrypt
- Role-based access control (USER, ADMIN)
- Protected routes on frontend
- CORS configuration for frontend-backend communication
- Request/Response validation

## 🧪 Testing

### Test the complete user flow:

1. **Register** a new user account
2. **Login** with new credentials
3. **Browse** movies on home page
4. **Select** a movie and view details
5. **Choose** a show time
6. **Select** seats on the seat map
7. **Book** tickets
8. **View** booking confirmation
9. **Check** "My Bookings" page
10. **Cancel** a booking (if needed)

### Test admin functions:

1. Login as admin
2. Add a new movie
3. Create a theatre
4. Add a screen with seat layout
5. Create shows for movies
6. Verify shows appear for users

## 🐛 Troubleshooting

### Backend won't start:
- Check MySQL is running
- Verify database credentials in `application.properties`
- Ensure port 8080 is not in use

### Frontend won't start:
- Delete `node_modules` and run `npm install` again
- Check Node.js version (should be 14+)
- Ensure port 3000 is not in use

### Can't login:
- Verify user exists in database
- Check backend logs for errors
- Ensure JWT secret is properly configured

### Seats not showing:
- Run seats creation API for the screen
- Check browser console for errors
- Verify show ID is correct

## 📝 Notes

- This is a demonstration project for educational purposes
- Payment integration is mocked (not real payment processing)
- For production use, additional security measures should be implemented
- Database should be properly optimized for production workloads

## 👨‍💻 Development

- Backend runs on port **8080**
- Frontend runs on port **3000**
- MySQL runs on port **3306** (default)

## 📄 License

This project is for educational purposes only.

## 🤝 Support

For issues or questions:
1. Check the troubleshooting section
2. Verify all prerequisites are installed
3. Check that all services are running
4. Review browser console and backend logs for errors

---

**Enjoy booking your favorite movies! 🎬🍿**

---

## 👤 Author

**Bhumana Purushotham**

## 📜 Copyright & License

© 2024-2026 Bhumana Purushotham. All Rights Reserved.

This project is created for educational and portfolio purposes. Unauthorized commercial use is prohibited.

---

*Made with ❤️ by Bhumana Purushotham*
