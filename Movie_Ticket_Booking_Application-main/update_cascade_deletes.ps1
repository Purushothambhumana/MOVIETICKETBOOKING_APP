# Script to update deleteScreen and deleteShow methods with cascade deletion

# TheatreService.java - Update deleteScreen method
$theatreFile = 'c:\Users\Admin\Documents\antimovie\backend\src\main\java\com\bookmyshow\service\TheatreService.java'
$content = Get-Content $theatreFile -Raw

# Replace deleteScreen method
$oldPattern = '(?s)([\t ]*)public void deleteScreen\(Long id\) \{[^}]+\}'
$newMethod = @'
	@Transactional
	public void deleteScreen(Long id) {
		Screen screen = screenRepository.findById(id)
				.orElseThrow(() -> new ResourceNotFoundException("Screen not found with id: " + id));
		
		// Get all shows for this screen
		List<Show> shows = showRepository.findByScreenId(id);
		
		// Delete all shows and their dependencies
		for (Show show : shows) {
			// Get all bookings for this show
			List<Booking> bookings = bookingRepository.findByShowId(show.getId());
			
			// Delete all booking seats and bookings
			for (Booking booking : bookings) {
				bookingSeatRepository.deleteAll(bookingSeatRepository.findByBookingId(booking.getId()));
				bookingRepository.delete(booking);
			}
			
			// Delete the show
			showRepository.delete(show);
		}
		
		// Delete all seats for this screen
		seatRepository.deleteByScreenId(id);
		
		// Finally delete the screen
		screenRepository.delete(screen);
	}
'@

$content = $content -replace $oldPattern, $newMethod
Set-Content $theatreFile $content

Write-Host "TheatreService.java updated successfully!"

# ShowService.java -Update deleteShow method  
$showFile = 'c:\Users\Admin\Documents\antimovie\backend\src\main\java\com\bookmyshow\service\ShowService.java'
$content = Get-Content $showFile -Raw

# Replace deleteShow method
$oldPattern = '(?s)([\t ]*)public void deleteShow\(Long id\) \{[^}]+\}'
$newMethod = @'
	@Transactional
	public void deleteShow(Long id) {
		Show show = showRepository.findById(id)
				.orElseThrow(() -> new ResourceNotFoundException("Show not found with id: " + id));
		
		// Get all bookings for this show
		List<Booking> bookings = bookingRepository.findByShowId(id);
		
		// Delete all booking seats and bookings
		for (Booking booking : bookings) {
			// Delete all booking seats for this booking
			bookingSeatRepository.deleteAll(bookingSeatRepository.findByBookingId(booking.getId()));
			
			// Delete the booking
			bookingRepository.delete(booking);
		}
		
		// Finally delete the show
		showRepository.delete(show);
	}
'@

$content = $content -replace $oldPattern, $newMethod
Set-Content $showFile $content

Write-Host "ShowService.java updated successfully!"
Write-Host "All cascade deletions implemented!"
