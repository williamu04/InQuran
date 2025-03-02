package org.uns.mtqmnuns.data.local

import androidx.room.*;
import org.uns.mtqmnuns.data.entity.Ayah

@Dao
interface AyahDao {
    @Query("SELECT * FROM ayah")
    fun getAll(): List<Ayah>

    @Query("SELECT * FROM ayah WHERE surahId = :surahId")
    fun getAyahBySurah(surahId: Int): List<Ayah>
}

