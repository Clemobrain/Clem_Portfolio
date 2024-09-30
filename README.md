

# Clem_Portfolio
**Data Engineering/ Data Scientist Portfolio**

---

## 1. Creating a Variable Name for Clinical Trial and Pharma Dataset
```python
dbutils.fs.ls(f"/FileStore/tables/")

clinical_tiral_file = "clinicaltrial_2021"
pharma_file = "pharma"

clinical_tiral_zip_file_exists = True
pharma_zip_file_exists = True

2. Defining a Function and Then Checking That the Files Needed Actually Exist

def check_zip_file(_file):
    try:
        db = dbutils.fs.ls(f"/FileStore/tables/{_file}.zip")
    except Exception:
        zip_file_exists = False

## Function to Check If the File Exists in the File System
def check_zip_file(_file):
    try:
        db = dbutils.fs.ls(f"/FileStore/tables/{_file}.zip")
    except Exception:
        zip_file_exists = False
## Checking Files
check_zip_file(clinical_tiral_file)
check_zip_file(pharma_file)


### Step 4: Enable GitHub Pages

1. Go to the **Settings** tab of your repository.
2. Scroll down to the **Pages** section in the left sidebar.
3. Under **Source**, choose `main` as the branch and `/root` for the folder.
4. Click **Save**.

After a few moments, GitHub will build and deploy your site. You will be provided with a URL where your portfolio will be hosted (e.g., `https://your-username.github.io/Clem_Portfolio/`).

### Step 5: Customize (Optional)

You can further customize your web page by choosing a theme for GitHub Pages under **Settings > Pages > Theme chooser**.

---

### Final Notes:
- After following these steps, your portfolio will be live, and you can share the URL with others.
- GitHub automatically converts the Markdown file to a webpage. Any Python code sections will be displayed as formatted code blocks.

Let me know if you need additional help!

