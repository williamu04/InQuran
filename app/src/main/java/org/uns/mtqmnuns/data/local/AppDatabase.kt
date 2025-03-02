package org.uns.mtqmnuns.data.local

import androidx.room.*;
import android.content.Context;
import org.uns.mtqmnuns.data.entity.*; 

// pemanggilan database menggunakan singleton pattern,
// untuk mendapatkan instance database : 
//              
//     val db = AppDatabase.getInstance(context); 
//
// Penjelasan object Context : https://stackoverflow.com/questions/3572463/what-is-context-on-android
@Database(entities = [Surah::class, Ayah::class], version = 1)
public abstract class AppDatabase : RoomDatabase() {
    companion object {
        @Volatile
        private var instance: AppDatabase? = null

        fun getInstance(context: Context): AppDatabase {
            if (instance != null) {
                return instance as AppDatabase;
            }

            synchronized(this) {
                if (instance == null) {
                    // inisialisasi Database jika instance AppDatabase belum di buat
                    instance = Room.databaseBuilder(
                        context.applicationContext,
                        AppDatabase::class.java,
                        "app.db"
                    )
                    .createFromAsset("database/quran.db")
                    .build()
                }
            }
            return instance as AppDatabase 
        }
    }
}



