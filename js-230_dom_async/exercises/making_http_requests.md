## Exploring the Booking App

**App Description**

The booking app is a tool for students to book the available schedule slots of staff. Staff provide the schedules that students can book. Note that this is only a simple booking app and by design it does not handle various scenarios and exceptions. For instance, the app doesn't bother to check whether the students who are registering have unique emails nor does it check the quality of the input provided (e.g., well formatted email, valid date value, valid time value).

**App Specifications**

The app has four resources and the following relationship:

- Staff Members: List of staff that can provide available time slots.
  - ID
  - Name
  - Email

- Schedules: List of schedules that students can book. A schedule is booked if there is a value for the student email.
  - ID
  - Staff ID
  - Date
  - Time
  - Student Email

- Students: List of students who can book a schedule.
  - ID
  - Name
  - Email

- Booking Sequences: List of booking sequences. A student who wants to register must have a booking sequence. Students get a booking sequence when they first try to book a schedule and they are not yet in the database.
  - ID
  - Student Email
  - Sequence

Relations:
- Staffs have many Schedules
- Students have many Schedules
- Students have many Booking Sequences


## Getting Schedules

Implement a function that retrieves all the schedules that are available. If one or more schedules are available, tally the count of schedules for each staff and alert the user of result as "key: value" pairs with the staff id as key (in the format of 'staff {id}'; e.g, 'staff 1') and the count of schedules as the value. If there are no schedules, alert the user that there are currently no schedules available for booking.

When implementing the function, keep in mind that server has been known to slow down when there are more than 7 schedules to retrieve. It doesn't always happen, but be sure to handle it accordingly. Once 5 seconds have passed, cancel the retrieval and inform the user to try again.

Finally, inform the user about the completion of the request regardless of the success or failure (timeout) of the request.

