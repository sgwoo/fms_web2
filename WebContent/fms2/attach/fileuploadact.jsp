<%@page import="acar.beans.AttachedFile"%>
<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="acar.util.*" %>

<%

	String cn = request.getParameter(Webconst.Common.contentCodeName);


//	System.out.println("cn="+cn+"<br>");

	String savePath = "";

	savePath = cn == null ? UploadInfoEnum.FREE_TIME.getText() : UploadInfoEnum.getEnumByText(cn).getText();


	cn = cn == null ? "0" : UploadInfoEnum.getEnumByText(cn).getLimit();

//	System.out.println("cn limit ="+cn+"<br>");
	
	int sizeLimit = ( Integer.parseInt(cn) );
	out.println(sizeLimit);
	if( sizeLimit > 0 ){
		sizeLimit = sizeLimit * 1024 * 1024 ;
	}
	
		
	MultipartFileUpload uploadComponent = new MultipartFileUpload();
	
	List<AttachedFile> result = null;
	
	result = uploadComponent.MultipartRequestFileSave(request, sizeLimit, savePath, true);
	
	System.out.println("savePath="+savePath+"<br>");
	
	
	
%> 
<html>
	<head><title>FMS</title>
	
	</head>
	
	<h1> 파일 업로드 결과</h1>
	
	<body>
		<table border="1" width="500" >
			<tr>
				<!--<th>컨텐츠 시퀀스</th>-->
				<!--<th>컨텐츠 코드</th>-->
				<th>실제 파일명</th>
				<th>파일사이즈</th>
				<th>파일 타입</th>
				<!--<th>저장파일명</th>-->
				<!--<th>저장폴더명</th>-->
				<th>등록자 시퀀스</th>
			</tr>
		<%
		if( result != null && result.size() > 0 ){
			
			for( AttachedFile file : result ){
		%>
			<tr>
				<!--<td><%=file.getContentSeq() %></td>-->
				<!--<td><%=file.getContentCode() %></td>-->
				<td><%=file.getFileName() %></td>
				<td><%=file.getFileSize() %></td>
				<td><%=file.getFileType() %></td>
				<!--<td><%=file.getSaveFile() %></td>-->
				<!--<td><%=file.getSaveFolder() %></td>-->
				<td><%=file.getRegUser() %></td>
			</tr>
		<%
			}
		}else{
		%>
			<tr>
				<td colspan="4" >저장된 파일이 없습니다.			
				<%if(sizeLimit>0){%> <%=sizeLimit/1024/1024%>MB 제한입니다.<%}%>
				</td>
			</tr>
		<%	
		}
		%>
		</table>
	</body>
        <input type="button" value="닫기" onclick="javascript:window.close()" />
</html>
<script language="JavaScript" type="text/JavaScript">
        <%if( result != null && result.size() > 0 ){	%>
        alert("등록되었습니다.");
		window.close();
        <%}%>
</script>
