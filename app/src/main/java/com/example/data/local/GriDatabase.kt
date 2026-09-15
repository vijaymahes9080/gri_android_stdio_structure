package com.example.data.local

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase

@Database(
    entities = [
        UserEntity::class,
        CourseEntity::class,
        CircularEntity::class,
        GrievanceEntity::class,
        TransportRouteEntity::class,
        SyncQueueEntity::class
    ],
    version = 1,
    exportSchema = false
)
abstract class GriDatabase : RoomDatabase() {
    abstract fun userDao(): UserDao
    abstract fun courseDao(): CourseDao
    abstract fun circularDao(): CircularDao
    abstract fun grievanceDao(): GrievanceDao
    abstract fun transportDao(): TransportDao
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
                ).fallbackToDestructiveMigration(true)
                 .build()
                INSTANCE = instance
                instance
            }
        }
    }
}
