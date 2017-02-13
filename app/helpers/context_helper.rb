module ContextHelper
  CONTEXT_CONFIG = :config
  CONTEXT_COURSES = :courses
  CONTEXT_COURSE_CREATE = :course_create
  CONTEXT_COURSE_DELETE = :course_delete
  CONTEXT_ERROR = :error
  CONTEXT_MESSAGE = :message
  CONTEXT_STUDENTS = :students
  CONTEXT_SEARCH_FORWARD = :search_forward
  CONTEXT_SEARCH_BACKWARD = :search_backward
  CONTEXT_STUDENT_CREATE = :student_create
  CONTEXT_STUDENT_DELETE = :student_delete

  CONTEXT_GROUP_PRIMARY = [
    CONTEXT_COURSES,
    CONTEXT_STUDENTS
  ]

  CONTEXT_GROUP_SECONDARY = [
    CONTEXT_CONFIG,
    CONTEXT_COURSES,
    CONTEXT_COURSE_CREATE,
    CONTEXT_COURSE_DELETE,
    CONTEXT_ERROR,
    CONTEXT_MESSAGE,
    CONTEXT_STUDENT_CREATE,
    CONTEXT_STUDENT_DELETE
  ]

  def is_primary_context? context
    return true if CONTEXT_GROUP_PRIMARY.includes? context
    false
  end

  def is_secondary_context? context
    return true if CONTEXT_GROUP_SECONDARY.includes? context
    false
  end
end
