-- \i "C:/Users/jackg/Documents/Warwick Work/Software Dev Lifecycle/SDLC Assessment 2/WMGTSS-Database/create_database_script.sql"

--createdb datafileDB postgres

--\c datafileDB;

DROP TABLE IF EXISTS dataFileTable;
DROP TABLE IF EXISTS clusterTable;
DROP TABLE IF EXISTS boardTable;
DROP FUNCTION IF EXISTS getBoardClusters;

DROP USER IF EXISTS student;
DROP USER IF EXISTS tutor;



CREATE TABLE boardTable (
    moduleName varchar(20) PRIMARY KEY,
    boardOwnerId varchar(20));

CREATE TABLE clusterTable (
    clusterId int PRIMARY KEY,
    moduleName varchar(20) REFERENCES boardTable(moduleName),
    displayTitle text,
    clusterDescription text);


-- how should datafiles relate to data boards and clusters
CREATE TABLE dataFileTable (
    fileId int PRIMARY KEY,
    clusterId int REFERENCES clusterTable(clusterId),
    fileName text NOT NULL,
    uploader varchar(20) NOT NULL,
    uploadDate date,
    fileSize varchar(20),
    path text);

CREATE OR REPLACE FUNCTION getBoardClusters(inputModuleName varchar(20))
    RETURNS TABLE(clusterId int,
                  moduleName varchar(20),
                  displayTitle text,
                  clusterDescription text,
                  fileId int,
                  fileName text,
                  uploader varchar(20),
                  uploadDate date,
                  fileSize varchar(20),
                  path text) 
    LANGUAGE SQL
    AS $$
        SELECT
            clusterTable.clusterId,
            clusterTable.moduleName,
            clusterTable.displayTitle,
            clusterTable.clusterDescription,
            dataFileTable.fileId,
            dataFileTable.fileName,
            dataFileTable.uploader,
            dataFileTable.uploadDate,
            dataFileTable.fileSize,
            dataFileTable.path
        FROM
            clusterTable
        INNER JOIN dataFileTable ON clusterTable.clusterId = dataFileTable.clusterId
        WHERE clusterTable.moduleName = inputModuleName
    $$;

CREATE USER student WITH PASSWORD 'student';
CREATE USER tutor WITH PASSWORD 'tutor';

GRANT EXECUTE ON FUNCTION getBoardClusters(varchar(20)) TO student;
GRANT SELECT ON TABLE clusterTable TO student;
GRANT SELECT ON TABLE datafileTable TO student;

INSERT INTO boardTable
    VALUES ('WM300', 'u100'),
           ('WM350', 'u200');

INSERT INTO clusterTable
    VALUES (0, 'WM300', 'Assessment Datafiles', 'please read through the assessment brief and cover sheet carefully before starting your assessment'),
           (1, 'WM300', 'Lecture Slides', 'New lecture slides will be uploaded after each lecture'),
           (2, 'WM350', 'Assessment Datafiles', 'please read through the assessment brief and cover sheet carefully before starting your assessment'),
           (3, 'WM350', 'Lecture Slides', 'New lecture slides will be uploaded after each lecture');

INSERT INTO datafileTable
    VALUES (0, 0, 'assessemnt_brief.pdf', 'u100', '12.1.2022', '300Kb', 'maths/assessemnt_brief.pdf'),
           (1, 0, 'assessemnt_frontSheet.docx', 'u100', '12.1.2022', '200Kb', 'maths/assessemnt_frontSheet.docx'),
           (2, 1, 'lectureSlides_1.pptx', 'u100', '12.1.2022', '400Kb', 'C:\\Users\\jackg\\Documents\\Warwick Work\\Software Dev Lifecycle\\WMGTSS-FrontEnd\\src\\assets\\test-data\\TestDownloadFile.txt'),
           (3, 1, 'lectureSlides_2.pptx', 'u100', '12.1.2022', '360Kb', 'maths/lectureSlides_2.pptx'),
           (4, 2, 'assessemnt_brief.pdf', 'u100', '12.1.2022', '230Kb', 'business/assessemnt_brief.pdf'),
           (5, 2, 'assessemnt_frontSheet.docx', 'u100', '12.1.2022', '180Kb', 'business/assessemnt_frontSheet.docx'),
           (6, 3, 'lectureSlides_1.pptx', 'u100', '12.1.2022', '450Kb', 'business/lectureSlides_1.pptx'),
           (7, 3, 'lectureSlides_2.pptx', 'u100', '12.1.2022', '320Kb', 'business/lectureSlides_2.pptx');

