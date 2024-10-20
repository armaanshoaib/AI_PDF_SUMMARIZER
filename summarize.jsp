<%-- 
    Document   : summarize
    Created on : 22-Sep-2024, 6:56:42 pm
    Author     : shaik
--%>
<% // // THIS jsp IS OF NO USE ANYMORE.
// // ITS FUNCTIONALITY IS IMPLEMENTED IN THE PYTHON FILE (app.py) ITSELF
%>
<%@page import="java.net.http.HttpRequest" %>
<%@page import="java.net.URI" %>
<%@page import="java.util.*" %>
<%@page import="java.io.*" %>
<%@page import="java.net.http.*" %>
<%@page import="java.net.http.*" %>
<%@page import="org.json.*" %>
<%@page import="java.nio.file.*" %>


<%@page import="com.cloudmersive.client.invoker.*" %>
<%@page import="com.cloudmersive.client.invoker.auth.*" %>
<%@page import="com.cloudmersive.client.ConvertDocumentApi" %>
<%@page import="com.cloudmersive.client.model.TextConversionResult" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%  
   String summary = "null";
   String suffix = "Summarize the given text : '";
   String PDFTXT = request.getParameter(extractedText);
    
  String prompt = suffix + PDFTXT;
  if(PDFTXT != "null" || PDFTXT != "" || PDFTXT != null || PDFTXT != " "){   
//   HttpRequest req = HttpRequest.newBuilder()
//           .uri(URI.create("https://chatgpt-42.p.rapidapi.com/gpt4"))
//           .header("x-rapidapi-key", "cea11f5bccmshdf4d7b192553da4p16a2d2jsn63aab5fe3783")
//           .header("x-rapidapi-host", "chatgpt-42.p.rapidapi.com")
//           .header("Content-Type", "application/json")
//           .method("POST", HttpRequest.BodyPublishers.ofString("{\"messages\":[{\"role\":\"user\",\"content\":\"" + prompt + "\"}],\"web_access\":false}"))
//           .build();
//   HttpResponse<String> resp = HttpClient.newHttpClient().send(req, HttpResponse.BodyHandlers.ofString());
//   String respBody = resp.body();
//   JSONObject jsonObject = new JSONObject(respBody);

//   if (resp.statusCode() == 200 && jsonObject.has("result")) {
//       summary = jsonObject.getString("result");
//   }
   //out.println(summary);
  }
        
%>
<html>
    <head>

        <link type="image/png" sizes="32x32" rel="icon" href="aiFavicon.png">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>AI PDF Summarizer</title>
        <style>
            body {
                background: linear-gradient(#0D0919,#0E0919);
                font-family: 'Segoe UI';
                display: flex;
                justify-content: center;
                align-items: flex-start;
                height: 100vh;
                margin: 0;
                padding: 0;
            }

            .container {
                margin: 20px;
                padding: 20px;
                border-radius: 12px;
                max-width: 600px;
                width: 90%;
                text-align: center;
                border: 1px solid wheat;
                box-shadow:0px 0px 10px wheat;
                color: white;

            }
            #heading {
                margin-top: 0px;
                margin-bottom: 0px;
                color: white;
                font-size: 32px;
                font-weight: bold;
            }
            #openAi{
                background: -webkit-linear-gradient(red, violet);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                font-size: 32px;
                font-weight: bold;
                text-shadow: 1px 1px 25px white;
            }
            #summary {
                background: rgba(255, 255, 255, 0.15);
                padding: 10px;
                border-radius: 8px;
                margin: 10px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
                backdrop-filter: blur(10px);
                color: yellow;
                animation-name: fade-in;
                animation-duration: 2s;
            }
            @keyframes fade-in {
                from {
                    opacity: 0;
                }
                to {
                    opacity: 1;
                }
            }
            #copyBtn{
                width: 30%;
                cursor: pointer;
                background-color: transparent;
                border-color: yellow;
                color: white;
                border: 1px solid wheat;
                padding: 12px 12px;
                border-radius: 6px;
                font-size: 14px;
                margin: 10px;

            }
            #error {
                background-color: #07012C;
                padding: 20px;
                margin: 20px;
                border-radius: 8px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
                border: 1px solid wheat;
                max-width: 90%;
                box-sizing: border-box;
            }

            #errMsg {
                color: red;
                font-family: Consolas;
                font-size: 28px;
            }
            #errList {
                color: red;
                font-family: Consolas;
                font-size: 28px;
            }
            #goBack{
                color: greenyellow;
                font-family: Verdana, sans-serif;
                font-size: 28px;
            }
            #nextPdf{
                color: green;
                font-family: Verdana, sans-serif;
                font-size: 18px;
            }

        </style>
        <script>
            function copyText(id) {
                var copyText = document.getElementById(id).innerText;
                navigator.clipboard.writeText(copyText).then(function () {
                    alert('Copied to clipboard');
                });
            }
        </script>
    </head>
    <body>
        <% // if ( summary != "null") { %>

        <div class="container">
            <p id="heading"> Summary by  <span id="openAi"> AI </span> </p>
            <p id="summary"> <%= summary %> </p>
            <button onclick='copyText("summary")' id='copyBtn'>Copy Summary </button>
            <br>
            <a href="index.jsp" id="nextPdf"> Summarize another PDF... </a>
        </div>
        <% // } else { %>
        
            <div id="error">
            <p id="errMsg"> Uh Oh! Error occurred! The PDF is either : </p>
            <ul id="errList" >
                <li>Password Protected</li>
                <li>Contains Unreadable Text</li>
                <li>Corrupt</li>
            </ul>
</ul> 
            <a href="index.jsp" id="goBack"> Click here to retry. </a>
        </div>    
       

        <% // } %>
    </body>
</html>

