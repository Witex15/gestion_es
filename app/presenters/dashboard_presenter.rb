class DashboardPresenter
  def initialize(person)
    @person = person
  end

  def sections
    case @person.role.to_sym
    when :student
      student_sections
    when :teacher
      teacher_sections
    when :dean
      dean_sections
    else
      []
    end
  end

  private

  def student_sections
    [
      {
        title: "My Grades",
        description: "View your academic performance",
        path: "grades_path",
        color: "blue",
        icon: "📊"
      },
      {
        title: "My Classes",
        description: "View your enrolled classes",
        path: "school_classes_path",
        color: "green",
        icon: "📚"
      }
    ]
  end

  def teacher_sections
    [
      {
        title: "My Classes",
        description: "Manage your classes and students",
        path: "school_classes_path",
        color: "blue",
        icon: "👥"
      },
      {
        title: "Grade Management",
        description: "Add and manage student grades",
        path: "grades_path",
        color: "green",
        icon: "📝"
      },
      {
        title: "Examinations",
        description: "Create and manage examinations",
        path: "examinations_path",
        color: "purple",
        icon: "✍️"
      }
    ]
  end

  def dean_sections
    [
      {
        title: "User Management",
        description: "Manage teachers, students, and staff",
        path: "people_path",
        color: "purple",
        icon: "👤"
      },
      {
        title: "Subject Management",
        description: "Manage subjects and assignments",
        path: "subjects_path",
        color: "blue",
        icon: "📖"
      },
      {
        title: "Class Management",
        description: "Manage school classes",
        path: "school_classes_path",
        color: "green",
        icon: "🏫"
      },
      {
        title: "Grade Reports",
        description: "Generate and view grade reports",
        path: "root_path", # Temporary until reports are implemented
        color: "yellow",
        icon: "📋"
      }
    ]
  end
end 