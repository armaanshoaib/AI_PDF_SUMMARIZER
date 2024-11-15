from __future__ import print_function 
from flask import Flask, request, redirect, render_template, jsonify, url_for
from cloudmersive_convert_api_client.rest import ApiException
import cloudmersive_convert_api_client
import os
import json
import http.client
from groq import Groq

app = Flask(__name__)
UPLOAD_FOLDER = 'uploads'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# Ensure upload directory exists
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/upload', methods=["POST"])
def upload_file():
    if 'inputDOC' not in request.files:
        return 'No file uploaded!', 400
    
    file = request.files['inputDOC']
    
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
    sampletxt = "The quick brown fox jumps over the lazy dog"
    try:        
        # # CONVERT .pdf .xlsx .txt .ppt .pptx .docx .doc TO TXT
        api_response = api_instance.convert_document_autodetect_to_txt(input_file, text_formatting_mode=text_formatting_mode)
        extracted_text = api_response.to_dict()['text_result']
        # #pprint(extract_text)      
        # # formatting the extracted text from pdf (removing extra spaces and other weird chars)
        formatted_txt = extracted_text.replace("\\r\\n", " ").replace("\\xa0", " ").splitlines()
        formatted_txt = ' '.join(line.strip().replace("'", "") for line in formatted_txt)
        # #Split the text into words and rejoin with a single space        
        extracted_cleaned_txt = ' '.join(formatted_txt.split())       
        # print("__________________________________________")
        # print("unpure extracted text = " + extracted_text)
        # print("=================")
        # print("extracted cleaned text = " + extracted_cleaned_txt)   
        # print("___________________________________________")   
        
        return summarize(extracted_cleaned_txt)
        
    except ApiException as e:
        #print("Exception when calling ConvertDocumentApi->convert_document_pdf_to_txt: %s\n" % e)
        return jsonify({"error": str(e)}), 500
    
    # # summarizing the text as DOCTXT
def summarize(DOCTXT):
    
    #print(DOCTXT)
    if(DOCTXT == "null" or DOCTXT == "" or DOCTXT == " " or DOCTXT == "'null'"):
        return render_template('error.html')
    
    summary = "null"
    suffix = "Summarize the given text : '" 
    prompt = suffix + DOCTXT + "'" 
    #print("prompt = " + prompt)
    # # API INSTANCE
    
    client = Groq(
    api_key="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",
    )
    chat_completion = client.chat.completions.create(
    messages=[
        {
            "role": "user",
            "content": prompt,
        }
    ],
    model="llama3-8b-8192",
    )
    summary = str(chat_completion.choices[0].message.content)
    #print(summary)

    return render_template('result.html',summary=summary)   
    

if __name__ == '__main__':
    app.run(host='0.0.0.0',port='5000',debug=False)
