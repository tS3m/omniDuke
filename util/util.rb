#Gets the pre-existing instructor with the name, or creates a new one if that instructor does not yet exist
def getCreateInstructor(name)
    foundInstructor = Instructor.find_by_name(name.downcase)
  if foundInstructor!=nil
    return foundInstructor
  else
    return Instructor.create!(name: name.downcase)
  end
end

def getCreateSubject(nameString, abbrString)
  foundSubjectByName = Subject.find_by_name(nameString.downcase)
  foundSubjectByAbbr = Subject.find_by_abbr(abbrString.upcase)
  if (foundSubjectByName != nil and foundSubjectByAbbr != nil and foundSubjectByName==foundSubjectByAbbr)
    return foundSubjectByName
  else
    return Subject.create!(name: nameString, abbr: abbrString)
  end
end

def getCreateSession(season, year)
  foundSession = Session.find_by_season_and_year(season, year)
  if(foundSession !=nil)
    return foundSession
  else
    return Session.create!(season: season, year: year)
  end
end

def setSectionTimeSlot(section, dayArray, startTimeString, endTimeString)
  timeslot = TimeSlot.new

  for day in dayArray
    timeslot.days_of_week << day
  end

  timeslot.start_time = Time.parse(startTimeString)
  timeslot.end_time = Time.parse(endTimeString)

  timeslot.save
  timeslot.sections << section
end