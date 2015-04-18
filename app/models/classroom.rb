class Classroom < ActiveRecord::Base
  belongs_to :teacher
  has_many :classroom_students
  has_many :students, :through => :classroom_students
  attr_accessible :class_type, :end_date, :name, :program, :start_date, :link, :short_link
  validates_presence_of :teacher, :class_type, :name

  TEST_URLS = {'pre' => 'https://docs.google.com/forms/d/18fGk0NX-z_Slad4WvlpPQFAugEsRoyVqpcscx6o8cdM/viewform?',
                 'post' => 'https://docs.google.com/forms/d/1H7Wwbo8mTbnKpCwMr231ZjWixIUo6sHXm0M431vwHU0/viewform?'}

  def get_short_link(test_type)
    bitly = Bitly.client
    bitly.shorten(self.get_link(test_type)).short_url
  end

  def get_link(test_type)
    teacher = self.teacher
    TEST_URLS[test_type] + 
      %Q{entry.1019834039=} + Classroom.sanitize_field(teacher.name) +
      %Q{&entry.56447872=} + Classroom.sanitize_field(teacher.city) +
      %Q{&entry.1968199897=} + Classroom.sanitize_field(teacher.state) +
      %Q{&entry.1945527637=} + self.id.to_s +
      %Q{&entry.514626172=} + teacher.id.to_s

  end

  def self.sanitize_field(field)
    if field != nil
      field.split(" ").join("+")
    end
  end

  def create_students(student_names)
    for student_name in student_names
      first_and_last = student_name.split(" ")
      first_name = first_and_last[0]
      last_name = first_and_last[1]
      self.students.create(:first_name => first_name, :last_name => last_name)
    end
  end
end
