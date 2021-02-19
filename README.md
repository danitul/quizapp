# Quizapp

Simple Quiz application, that shows to a user 
a number of questions as separate pages, shown one after another. 
Each question will have 2-5 predefined answers that 
the user can pick from, open answers are not possible.

On the admin-side, we should be able to 
 - add/edit questions and to add/edit answer options for each question.  A seed file should be provided with 5 questions with 2-5 answers each (question/answer text does not matter).
 - see all the anonymous user submissions formatted for easy reading.

Other Requirements
 - The user should not be able to access the next question without answering current, or going back to previous questions.
 - Users are able to answer the questions anonymously (without log-in)
 - The user should be able to do the quiz only once (We expect that users always use the same browser, default browser settings and don't use incognito).

## Implementation Assumptions and Considerations

 - There's multiple ways to form a string of questions.
   I went with the last option, using all the question.
   For current purposes it seemed the easiest:
   - Wrap them in a Quiz object
   - Randomly pick n
   - use an order_id
   - use active/inactive 
   - just use all the questions
 - I assumed that updating a question's answers
will overwrite the old ones. This is mainly a choice based on time constraints.
 - I haven't used any authentication gem to keep it simple
   and within time constraints, but would make sense if for example
   we'd like to be able to promote anonymous users to regular users.
 - I haven't created a serializer for the controllers responses
   as I would normally, also for time constraints reasons.
 - it would make sense to create a cron job that periodically
checks for anonymous users who were created, let's say a month ago and deletes them.

   