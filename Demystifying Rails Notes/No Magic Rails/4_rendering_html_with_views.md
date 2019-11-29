### Content Using Views

At this point, we have content in the action. This isn't the controller's job.

The controller action is the director of the request handling -- it should delegate other responsibilities to other parts of the application.
    (In other words, it's to call other parts of the application and, when needed, put the results together.)

#### Creating a Simple View

All views live in the `app/views` directory. From there, the following directories correspond to the controller calling it, and the file is named after the action that calls the view.
