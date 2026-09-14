package com.example.data.local

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase

@Database(
  entities = [
    UserEntity::class,
    CourseEntity::class,
    GrievanceEntity::class,
    TransportRouteEntity::class,
    CircularEntity::class,
    SyncQueueEntity::class
  ],
  version = 1,
  exportSchema = false
)
abstract class GriDatabase : RoomDatabase() {
  abstract fun userDao(): UserDao
  abstract fun courseDao(): CourseDao
  abstract fun grievanceDao(): GrievanceDao
  abstract fun transportDao(): TransportDao
  abstract fun circularDao(): CircularDao
  abstract fun syncQueueDao(): SyncQueueDao

  companion object {
    @Volatile
    private var INSTANCE: GriDatabase? = null

    fun getDatabase(context: Context): GriDatabase {
      return INSTANCE ?: synchronized(this) {
        val instance = Room.databaseBuilder(
          context.applicationContext,
          GriDatabase::class.java,
          "gri_portal_database.db"
        )
          .fallbackToDestructiveMigration()
          .build()
        INSTANCE = instance
        instance
      }
    }
  }
}
