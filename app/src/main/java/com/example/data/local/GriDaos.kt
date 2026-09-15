package com.example.data.local

import androidx.room.*
import kotlinx.coroutines.flow.Flow

@Dao
interface UserDao {
    @Query("SELECT * FROM users WHERE role = :role LIMIT 1")
    fun getUserByRole(role: String): Flow<UserEntity?>

    @Query("SELECT * FROM users")
    fun getAllUsers(): Flow<List<UserEntity>>

    @Query("SELECT * FROM users WHERE id = :id LIMIT 1")
    suspend fun getUserById(id: String): UserEntity?

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertUser(user: UserEntity)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertUsers(users: List<UserEntity>)
}

@Dao
interface CourseDao {
    @Query("SELECT * FROM courses ORDER BY code ASC")
    fun getAllCourses(): Flow<List<CourseEntity>>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertCourses(courses: List<CourseEntity>)

    @Query("UPDATE courses SET attendedClasses = attendedClasses + 1, totalClasses = totalClasses + 1, attendancePercent = ((attendedClasses + 1) * 100) / (totalClasses + 1) WHERE id = :courseId")
    suspend fun markAttendance(courseId: String)
}

@Dao
interface CircularDao {
    @Query("SELECT * FROM circulars ORDER BY publishedDate DESC")
    fun getAllCirculars(): Flow<List<CircularEntity>>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertCircular(circular: CircularEntity)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertCirculars(circulars: List<CircularEntity>)

    @Query("UPDATE circulars SET isRead = 1 WHERE id = :id")
    suspend fun markCircularRead(id: String)

    @Query("DELETE FROM circulars WHERE id = :id")
    suspend fun deleteCircular(id: String)
}

@Dao
interface GrievanceDao {
    @Query("SELECT * FROM grievances ORDER BY createdAt DESC")
    fun getAllGrievances(): Flow<List<GrievanceEntity>>

    @Query("SELECT COUNT(*) FROM grievances WHERE status = 'PENDING'")
    fun getPendingCount(): Flow<Int>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertGrievance(grievance: GrievanceEntity): Long

    @Query("UPDATE grievances SET status = :newStatus, remarks = :remarks WHERE id = :id")
    suspend fun updateGrievanceStatus(id: Long, newStatus: String, remarks: String)

    @Query("DELETE FROM grievances WHERE id = :id")
    suspend fun deleteGrievance(id: Long)
}

@Dao
interface TransportDao {
    @Query("SELECT * FROM transport_routes ORDER BY routeNo ASC")
    fun getAllRoutes(): Flow<List<TransportRouteEntity>>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertRoutes(routes: List<TransportRouteEntity>)

    @Query("UPDATE transport_routes SET currentStatus = :status WHERE id = :id")
    suspend fun updateRouteStatus(id: String, status: String)
}

@Dao
interface SyncQueueDao {
    @Query("SELECT * FROM sync_queue WHERE isSynced = 0 ORDER BY timestamp ASC")
    fun getPendingSyncItems(): Flow<List<SyncQueueEntity>>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun enqueue(item: SyncQueueEntity): Long

    @Query("UPDATE sync_queue SET isSynced = 1 WHERE id = :id")
    suspend fun markAsSynced(id: Long)

    @Query("DELETE FROM sync_queue WHERE isSynced = 1")
    suspend fun clearSynced()
}
