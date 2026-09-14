package com.example

import android.content.Context
import androidx.room.Room
import androidx.test.core.app.ApplicationProvider
import com.example.data.local.CourseEntity
import com.example.data.local.GriDatabase
import com.example.data.local.GrievanceEntity
import com.example.data.local.UserEntity
import com.example.data.local.UserRole
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.runBlocking
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.annotation.Config

@RunWith(RobolectricTestRunner::class)
@Config(sdk = [36])
class GriDataLayerTest {

  private lateinit var database: GriDatabase

  @Before
  fun setup() {
    val context = ApplicationProvider.getApplicationContext<Context>()
    database = Room.inMemoryDatabaseBuilder(context, GriDatabase::class.java)
      .allowMainThreadQueries()
      .build()
  }

  @After
  fun teardown() {
    database.close()
  }

  @Test
  fun testUserInsertAndRoleQuery() = runBlocking {
    val student = UserEntity(
      id = "u1",
      name = "Srimari Vijay",
      email = "srimari@example.com",
      role = UserRole.STUDENT.name,
      rollNo = "23MCA042",
      department = "Computer Applications",
      semester = "Sem 4",
      cgpa = "8.92"
    )
    database.userDao().insertUser(student)

    val queried = database.userDao().getUserByRole(UserRole.STUDENT.name).first()
    assertNotNull(queried)
    assertEquals("Srimari Vijay", queried?.name)
    assertEquals("23MCA042", queried?.rollNo)
  }

  @Test
  fun testCourseAttendanceIncrement() = runBlocking {
    val course = CourseEntity(
      id = "c1",
      code = "CS501",
      title = "Advanced Cloud Computing",
      credits = 4,
      instructor = "Dr. Subramanian",
      schedule = "MW 10 AM",
      attendancePercent = 80,
      totalClasses = 20,
      attendedClasses = 16
    )
    database.courseDao().insertCourses(listOf(course))

    database.courseDao().markAttendance("c1")

    val updatedCourses = database.courseDao().getAllCourses().first()
    val updated = updatedCourses.first { it.id == "c1" }
    assertEquals(21, updated.totalClasses)
    assertEquals(17, updated.attendedClasses)
    assertEquals(80, updated.attendancePercent)
  }

  @Test
  fun testGrievanceLifecycle() = runBlocking {
    val grievance = GrievanceEntity(
      ticketNumber = "GRI-1001",
      category = "Hostel",
      subject = "Hot water availability",
      description = "Solar geyser check required",
      status = "PENDING",
      studentRollNo = "23MCA042"
    )
    val id = database.grievanceDao().insertGrievance(grievance)
    assertTrue(id > 0)

    val list = database.grievanceDao().getAllGrievances().first()
    assertEquals(1, list.size)
    assertEquals("PENDING", list[0].status)

    database.grievanceDao().updateGrievanceStatus(id, "RESOLVED", "Maintenance checked and cleared")
    val resolvedList = database.grievanceDao().getAllGrievances().first()
    assertEquals("RESOLVED", resolvedList[0].status)
    assertEquals("Maintenance checked and cleared", resolvedList[0].remarks)
  }
}
