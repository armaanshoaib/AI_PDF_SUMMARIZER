<%@ page import="java.io.*, java.net.*" %>
<%
    String savePath = application.getRealPath("/") + "uploads";
    File fileSaveDir = new File(savePath);

    if (!fileSaveDir.exists()) {
        fileSaveDir.mkdir();
    }
    
    // File uploaded by the user
    String fileName = request.getPart("inputPDF").getSubmittedFileName();
    Part filePart = request.getPart("inputPDF");
    String filePath = savePath + File.separator + fileName;
    
    // Save file on the server
    filePart.write(filePath);

    // Now send the file to the Python script
    String pythonScript = "python3 PdfHandler.py " + filePath;
    
    Process process = Runtime.getRuntime().exec(pythonScript);
    BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
    String line;
    while ((line = reader.readLine()) != null) {
        out.println(line + "<br>");
    }
%>
