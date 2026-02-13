import re

# Read the file
with open(r'c:\Users\Admin\Documents\antimovie\backend\src\main\java\com\bookmyshow\service\ShowService.java', 'r', encoding='utf-8') as f:
    content = f.read()

# Define the old method
old_method = r'''	public void deleteShow\(Long id\) \{
		Show show = showRepository\.findById\(id\)
				\.orElseThrow\(\(\) -> new ResourceNotFoundException\("Show not found with id: " \+ id\)\);
		showRepository\.delete\(show\);
	\}'''

# Define the new method
new_method = '''	@Transactional
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
	}'''

# Replace the method
content = re.sub(old_method, new_method, content)

# Write back
with open(r'c:\Users\Admin\Documents\antimovie\backend\src\main\java\com\bookmyshow\service\ShowService.java', 'w', encoding='utf-8') as f:
    f.write(content)

print("File updated successfully!")
