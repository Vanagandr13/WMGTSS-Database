-- \i "C:/Users/jackg/Documents/Warwick Work/Software Dev Lifecycle/SDLC Assessment 2/WMGTSS-Database/create_database_script.sql"

--createdb datafileDB postgres

--\c datafileDB;

DROP TABLE IF EXISTS dataFileTable;
DROP TABLE IF EXISTS clusterTable;
DROP TABLE IF EXISTS boardTable;
DROP FUNCTION IF EXISTS getBoardClusters;

REVOKE ALL PRIVILEGES ON DATABASE datafiledb FROM tutor;

DROP USER IF EXISTS student;
DROP USER IF EXISTS tutor;



CREATE TABLE boardTable (
    moduleName varchar(20) PRIMARY KEY,
    boardOwnerId varchar(20));

CREATE TABLE clusterTable (
    clusterId SERIAL PRIMARY KEY,
    moduleName varchar(20) REFERENCES boardTable(moduleName) ON DELETE CASCADE,
    displayTitle text,
    clusterDescription text);


-- how should datafiles relate to data boards and clusters
CREATE TABLE dataFileTable (
    fileId SERIAL PRIMARY KEY,
    clusterId int REFERENCES clusterTable(clusterId) ON DELETE CASCADE,
    fileName text NOT NULL,
    uploader varchar(20) NOT NULL, -- currently unused, but in the real system recording the file uploader is important XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    uploadDate varchar(20),
    fileSize varchar(20),
	downloadCounter int,
	UNIQUE(clusterId, fileName));

CREATE OR REPLACE FUNCTION getBoardClusters(inputModuleName varchar(20))
    RETURNS TABLE(clusterId int,
                  moduleName varchar(20),
                  displayTitle text,
                  clusterDescription text,
                  fileId int,
                  fileName text,
                  uploader varchar(20),
                  uploadDate varchar(20),
                  fileSize varchar(20),
				  downloadCounter int) 
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
			dataFileTable.downloadCounter
        FROM
            clusterTable
        FULL OUTER JOIN dataFileTable ON clusterTable.clusterId = dataFileTable.clusterId
        WHERE clusterTable.moduleName = inputModuleName
    $$;
	
CREATE OR REPLACE FUNCTION getClusterFiles(inputClusterId int)
    RETURNS TABLE(clusterId int,
                  fileId int,
                  fileName text,
                  uploader varchar(20),
                  uploadDate varchar(20),
                  fileSize varchar(20),
				  downloadCounter int) 
    LANGUAGE SQL
    AS $$
        SELECT
            dataFileTable.clusterId,
            dataFileTable.fileId,
            dataFileTable.fileName,
            dataFileTable.uploader,
            dataFileTable.uploadDate,
            dataFileTable.fileSize,
			dataFileTable.downloadCounter
        FROM
            dataFileTable
        WHERE dataFileTable.clusterId = inputClusterId
    $$;
	
CREATE OR REPLACE FUNCTION checkClusterContainsFile(inputClusterId int, inputFileId int)
    RETURNS TABLE(clusterId int,
                  fileId int,
                  fileName text,
                  uploader varchar(20),
                  uploadDate varchar(20),
                  fileSize varchar(20),
				  downloadCounter int) 
    LANGUAGE SQL
    AS $$
        SELECT
            dataFileTable.clusterId,
            dataFileTable.fileId,
            dataFileTable.fileName,
            dataFileTable.uploader,
            dataFileTable.uploadDate,
            dataFileTable.fileSize,
			dataFileTable.downloadCounter
        FROM
            dataFileTable
        WHERE dataFileTable.fileId = inputfileId AND dataFileTable.clusterId = inputClusterId
    $$;
	
CREATE OR REPLACE FUNCTION getCluster(inputClusterId int)
    RETURNS TABLE(clusterId int,
				  moduleName varchar(20),
				  displayTitle text,
				  description text) 
    LANGUAGE SQL
    AS $$
        SELECT
            clusterTable.clusterId,
            clusterTable.moduleName,
            clusterTable.displayTitle,
            clusterTable.clusterDescription
        FROM
            clusterTable
        WHERE clusterTable.clusterId = inputClusterId
    $$;
	
CREATE OR REPLACE FUNCTION getFile(inputFileId int)
    RETURNS TABLE(clusterId int,
                  fileId int,
                  fileName text,
                  uploader varchar(20),
                  uploadDate varchar(20),
                  fileSize varchar(20),
				  downloadCounter int) 
    LANGUAGE SQL
    AS $$
        SELECT
            dataFileTable.clusterId,
            dataFileTable.fileId,
            dataFileTable.fileName,
            dataFileTable.uploader,
            dataFileTable.uploadDate,
            dataFileTable.fileSize,
			dataFileTable.downloadCounter
        FROM
            dataFileTable
        WHERE dataFileTable.fileId = inputfileId
    $$;
	
CREATE OR REPLACE FUNCTION incramentFileDownloadCounter(inputFileId int)
    RETURNS VOID
    LANGUAGE SQL
    AS $$
        UPDATE dataFileTable
		SET
			downloadCounter = dataFileTable.downloadCounter + 1
        WHERE dataFileTable.fileId = inputfileId
    $$;
	
CREATE OR REPLACE FUNCTION addCluster(inputModuleName varchar(20), inputDisplayTitle text, inputDescription text)
		RETURNS TABLE (clusterId int,
				  moduleName varchar(20),
				  displayTitle text,
				  clusterDescription text)
		LANGUAGE SQL
		AS $$
			INSERT INTO clusterTable (moduleName, displayTitle, clusterDescription) 
			VALUES (inputModuleName, inputDisplayTitle, inputDescription)
			returning *;
		$$;
		
CREATE OR REPLACE FUNCTION modifyCluster(inputClusterId int, inputDisplayTitle text, inputDescription text)
		RETURNS TABLE (clusterId int,
				  moduleName varchar(20),
				  displayTitle text,
				  clusterDescription text)
		LANGUAGE SQL
		AS $$
			    UPDATE clusterTable
				SET displayTitle       = inputDisplayTitle,
				    clusterDescription = inputDescription
				WHERE clusterId        = inputClusterId
				returning *;
		$$;
	
CREATE OR REPLACE FUNCTION addFile(inputClusterId int, inputFileName text, inputUploader varchar(20), inputUploadDate varchar(20), inputFileSize varchar(20), inputDownloadCounter int)
		RETURNS VOID
		LANGUAGE SQL
		AS $$
			INSERT INTO datafileTable (clusterId, fileName, uploader, uploadDate, fileSize, downloadCounter)
			VALUES (inputClusterId, inputFileName, inputUploader, inputUploadDate, inputFileSize, inputDownloadCounter)
		$$;

CREATE OR REPLACE FUNCTION deleteBoard(inputModuleName varchar(20))
	RETURNS VOID
    LANGUAGE SQL
    AS $$
        DELETE FROM boardTable 
        WHERE boardTable.moduleName = inputModuleName
    $$;

CREATE OR REPLACE FUNCTION deleteCluster(inputClusterId int)
	RETURNS TABLE(clusterId int,
				  moduleName varchar(20),
				  displayTitle text,
				  clusterDescription text)
    LANGUAGE SQL
    AS $$
        DELETE FROM clusterTable
        WHERE clusterTable.clusterId = inputClusterId
		returning *;
    $$;
	
CREATE OR REPLACE FUNCTION deleteFile(inputFileId int)
    RETURNS TABLE (fileId int,
				   clusterId int,
                   fileName text,
                   uploader varchar(20),
                   uploadDate varchar(20),
                   fileSize varchar(20),
				   downloadCounter int) 
    LANGUAGE SQL
    AS $$
        DELETE FROM dataFileTable
        WHERE dataFileTable.fileId = inputFileId
		returning *;
    $$;


CREATE USER student WITH PASSWORD 'student';
CREATE USER tutor WITH PASSWORD 'tutor';

REVOKE ALL PRIVILEGES ON TABLE dataFileTable FROM tutor;
GRANT ALL PRIVILEGES ON TABLE dataFileTable TO tutor;

REVOKE ALL PRIVILEGES ON TABLE clusterTable FROM tutor;
GRANT ALL PRIVILEGES ON TABLE clusterTable TO tutor;

GRANT EXECUTE ON FUNCTION getBoardClusters(varchar(20)) TO tutor;

REVOKE ALL PRIVILEGES ON SEQUENCE datafiletable_fileid_seq FROM tutor;
GRANT ALL PRIVILEGES ON SEQUENCE datafiletable_fileid_seq TO tutor;

REVOKE ALL PRIVILEGES ON SEQUENCE clusterTable_clusterid_seq FROM tutor;
GRANT ALL PRIVILEGES ON SEQUENCE clusterTable_clusterid_seq TO tutor;

GRANT ALL PRIVILEGES ON DATABASE datafiledb TO tutor;

GRANT EXECUTE ON FUNCTION getBoardClusters(varchar(20)) TO student;
--GRANT EXECUTE ON FUNCTION getBoardClusters(varchar(20)) TO student;
GRANT SELECT ON TABLE clusterTable TO student;
GRANT SELECT ON TABLE datafileTable TO student;

INSERT INTO boardTable
    VALUES ('WM300', 'u100'),
           ('WM350', 'u200');

INSERT INTO clusterTable (moduleName, displayTitle, clusterDescription)
    VALUES ('WM300', 'Assessment Datafiles', 'please read through the assessment brief and cover sheet carefully before starting your assessment'),
           ('WM300', 'Lecture Slides', 'New lecture slides will be uploaded after each lecture'),
		   ('WM300', 'Excerises', 'Please complete these excerises in time for the next session'),
           ('WM350', 'Assessment Datafiles', 'please read through the assessment brief and cover sheet carefully before starting your assessment'),
           ('WM350', 'Lecture Slides', 'New lecture slides will be uploaded after each lecture'),
		   ('WM350', 'Excerises', 'Please complete these excerises in time for the next session');


INSERT INTO datafileTable (clusterId, fileName, uploader, uploadDate, fileSize, downloadCounter)
    VALUES (1, 'assessemnt_brief.pdf', 'u100', '12.1.2022', '300Kb', 0),
           (1, 'assessemnt_frontSheet.docx', 'u100', '12.1.2022', '200Kb', 0),
           (2, 'lectureSlides_1.pptx', 'u100', '12.1.2022', '400Kb', 0),
           (2, 'lectureSlides_2.pptx', 'u100', '12.1.2022', '360Kb', 0),
           (4, 'assessemnt_brief.pdf', 'u100', '12.1.2022', '230Kb', 0),
           (4, 'assessemnt_frontSheet.docx', 'u100', '12.1.2022', '180Kb', 0),
           (5, 'lectureSlides_1.pptx', 'u100', '12.1.2022', '450Kb', 0),
           (5, 'lectureSlides_2.pptx', 'u100', '12.1.2022', '320Kb', 0);

