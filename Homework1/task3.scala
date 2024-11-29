/*
Задание 3
Определите в какой нормальной форме данная таблица, приведите её ко 2 и 3 нормальным формам последовательно.
+-----------+--------+-----+---------+-----------+----------+
|Employee_ID|Job_Code| Name|City_Code|        Job| Home_City|
+-----------+--------+-----+---------+-----------+----------+
|       E001|     J01|Alice|       26|       Chef|    Moscow|
|       E001|     J02|Alice|       26|     Waiter|    Moscow|
|       E002|     J02|  Bob|       56|     Waiter|      Perm|
|       E002|     J03|  Bob|       56|  Bartender|      Perm|
|       E003|     J01|Alice|       56|       Chef|      Perm|
+-----------+--------+-----+---------+-----------+----------+

cd "K:\Мой диск\GeekBrains\ETL\homework1"
chcp 65001 && spark-shell -i task3.scala --conf "spark.driver.extraJavaOptions=-Dfile.encoding=utf-8"
*/


import org.apache.spark.sql.functions._
import org.apache.spark.sql.expressions.Window

val t1 = System.currentTimeMillis()
if(1==1){
    var df1 = spark.read.option("delimiter"," ")
        .option("header", "true")
        .option("useHeader", "false")
        .csv("task3.csv")

    df1.select("Employee_ID", "Name", "City_code").distinct
    .write.format("jdbc").option("url","jdbc:mysql://localhost:3306/spark?user=root&password=1230&serverTimezone=UTC")
    .option("driver", "com.mysql.cj.jdbc.Driver").option("dbtable", "Employees")
    .mode("overwrite").save()

	df1.select("Job_Code", "Job").distinct
    .write.format("jdbc").option("url","jdbc:mysql://localhost:3306/spark?user=root&password=1230&serverTimezone=UTC")
    .option("driver", "com.mysql.cj.jdbc.Driver").option("dbtable", "Jobs")
    .mode("overwrite").save()

    df1.select("City_code", "Home_City").distinct
    .write.format("jdbc").option("url","jdbc:mysql://localhost:3306/spark?user=root&password=1230&serverTimezone=UTC")
    .option("driver", "com.mysql.cj.jdbc.Driver").option("dbtable", "Cities")
    .mode("overwrite").save()
    
    df1.select("Employee_ID", "Job_Code").distinct
    .write.format("jdbc").option("url","jdbc:mysql://localhost:3306/spark?user=root&password=1230&serverTimezone=UTC")
    .option("driver", "com.mysql.cj.jdbc.Driver").option("dbtable", "Employee_Jobs")
    .mode("overwrite").save()

	println("Homework1 is completed")

    spark.stop()
}

val s0 = (System.currentTimeMillis() - t1)/1000
val s = s0 % 60
val m = (s0/60) % 60
val h = (s0/60/60) % 24
println("%02d:%02d:%02d".format(h, m, s))
System.exit(0)