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
	
	<h1> ���� ���ε� ���</h1>
	
	<body>
		<table border="1" width="500" >
			<tr>
				<!--<th>������ ������</th>-->
				<!--<th>������ �ڵ�</th>-->
				<th>���� ���ϸ�</th>
				<th>���ϻ�����</th>
				<th>���� Ÿ��</th>
				<!--<th>�������ϸ�</th>-->
				<!--<th>����������</th>-->
				<th>����� ������</th>
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
				<td colspan="4" >����� ������ �����ϴ�.			
				<%if(sizeLimit>0){%> <%=sizeLimit/1024/1024%>MB �����Դϴ�.<%}%>
				</td>
			</tr>
		<%	
		}
		%>
		</table>
	</body>
        <input type="button" value="�ݱ�" onclick="javascript:window.close()" />
</html>
<script language="JavaScript" type="text/JavaScript">
        <%if( result != null && result.size() > 0 ){	%>
        alert("��ϵǾ����ϴ�.");
		window.close();
        <%}%>
</script>
