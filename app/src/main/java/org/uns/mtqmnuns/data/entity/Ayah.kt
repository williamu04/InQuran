package org.uns.mtqmnuns.data.entity

import androidx.room.*

@Entity(
    tableName = "Ayah",
    foreignKeys = [
        ForeignKey (
            entity = Surah::class,
            parentColumns = ["id"], 
            childColumns = ["surahId"],
        )
    ],
    indices = [Index(value = ["surahId"])]
)
data class Ayah (
    @PrimaryKey 
    val id: Int,
    
    @ColumnInfo(name = "surahId")  
    val surahId: Int,

    @ColumnInfo(name = "ayahText") 
    val ayahText: String,

    @ColumnInfo(name = "indoText") 
    val indoText: String,

    @ColumnInfo(name = "readText") 
    val readText: String,
)
