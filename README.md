# Clem_Portfolio
Data Engineering/ Data Scientist Portfolio

* CREATING A VARIABLE NAME FOR CLINICAL TRIAL AND PHARMA DATASET
dbutils.fs.ls(f"/FileStore/tables/")

* DEFINING A FUNTION AND THEN CHECKING THAT THE FILES NEEDED ACTUALLY EXIST
clinical_tiral_file = "clinicaltrial_2021"
pharma_file = "pharma"

clinical_tiral_zip_file_exists = True
pharma_zip_file_exists = True

 [Fuction to check if file exists in the file system]
def check_zip_file(_file):
    try:
        db = dbutils.fs.ls(f"/FileStore/tables/{_file}.zip")
    except Exception:
        zip_file_exists = False

check_zip_file(clinical_tiral_file)
check_zip_file(pharma_file)
