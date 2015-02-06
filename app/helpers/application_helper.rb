module ApplicationHelper

  def alert_messages
    AlertMessage.where(active: true)
  end

  def options_for_course_select
     # as currently coded, this uses the course name (authority's :term) as the option value
     # to use the course ID (authority's :id) as the option value, replace the "options << ..."
     # of the loop below with
     # options << [ course.fetch(:term), course.fetch(:id) ]
     # will need to alter sort block body as well
     options = []
     courses = Qa::Authorities::Local.terms('courses')
     courses.each do |course|
       if course.fetch(:active, true)
         options << course.fetch(:term)
       end
     end
     options.sort { |x,y| x.downcase <=> y.downcase }
   end

end
