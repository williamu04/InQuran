package org.uns.mtqmnuns.data.local

import androidx.room.*
import org.uns.mtqmnuns.data.entity.Surah

@Dao
interface SurahDao {
    @Query("SELECT * FROM surah")
    fun getAll(): List<Surah>
    
    @Query("SELECT * From surah WHERE id = :id LIMIT 1")
    fun getById(id: Int): Surah
}
