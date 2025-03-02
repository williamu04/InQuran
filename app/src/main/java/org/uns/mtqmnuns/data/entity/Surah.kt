package org.uns.mtqmnuns.data.entity

import androidx.room.*

@Entity(tableName = "surah")
data class Surah (
    @PrimaryKey 
    @ColumnInfo(name = "id")        
    val id: Int,

    @ColumnInfo(name = "name")        
    val name: String,

    @ColumnInfo(name = "nameLatin")   
    val nameLatin: String,

    @ColumnInfo(name = "nameIndo")    
    val nameIndo: String,

    @ColumnInfo(name = "description") 
    val description: String,

    @ColumnInfo(name = "totalAyah")   
    val totalAyah: Int,

    @ColumnInfo(name = "place")       
    val place: String,
)
