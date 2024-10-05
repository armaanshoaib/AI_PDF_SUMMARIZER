from __future__ import print_function 
from flask import Flask, request, redirect, render_template, jsonify
from cloudmersive_convert_api_client.rest import ApiException
import cloudmersive_convert_api_client
import os

app = Flask(__name__)
UPLOAD_FOLDER = 'uploads'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# Ensure upload directory exists
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/upload', methods=['POST'])
def upload_file():
    if 'inputPDF' not in request.files:
        return 'No file uploaded!!', 400
    
    file = request.files['inputPDF']
    
    if file.filename == '':
        return 'No selected file', 400

    # #Save the file
    file_path = os.path.join(app.config['UPLOAD_FOLDER'], file.filename)
    file.save(file_path)

    # #Extract text from PDF
    return extract_text(file_path)

def extract_text(file_path):
    # #Configure API key authorization: Apikey
    configuration = cloudmersive_convert_api_client.Configuration()
    configuration.api_key['Apikey'] = '91450927-5419-4e3f-8de6-49b6b1ef2c59'

# #create an instance of the API class
    api_instance = cloudmersive_convert_api_client.ConvertDocumentApi(cloudmersive_convert_api_client.ApiClient(configuration))
    input_file = file_path # file | Input file to perform the operation on.
    text_formatting_mode = 'minimizeWhitespace'
    extracted_text="null"
    sampletxt = "some random text"
    try:
        
        # #Convert PDF Document to Text (txt)
        api_response = api_instance.convert_document_pdf_to_txt(input_file, text_formatting_mode=text_formatting_mode)
        extracted_text = api_response.to_dict()['text_result']
        # #pprint(extract_text)      
        # # formatting the extracted text from pdf (removing extra spaces and other wierd chars)
        formatted_txt = extracted_text.replace("\\r\\n", " ").replace("\\xa0", " ").splitlines()
        formatted_txt = ' '.join(line.strip().replace("'", "") for line in formatted_txt)
        # #Split the text into words and rejoin with a single space
        extracted_cleaned_txt = ' '.join(formatted_txt.split())
        print(extracted_cleaned_txt)      
        # #Forward to summarize.jsp with extracted text        
        return redirect("http://localhost:8080/PDFSUMMARY_AI/summarize.jsp?extractedText=" + extracted_cleaned_txt)

    except ApiException as e:
        print("Exception when calling ConvertDocumentApi->convert_document_pdf_to_txt: %s\n" % e)
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
