<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.cooperation.*, java.io.*,acar.user_mng.*,acar.insur.*"%>
<%@ page import="acar.util.*,acar.coolmsg.*"%>
<%@ include file="/acar/cookies.jsp"%>


<%
	String[] seq = request.getParameterValues("seq");
	String[] sort = request.getParameterValues("sort");
	
	
  	int flag = 0;
	Vector vt = new Vector();
	try{
		for(int i=0; i<seq.length; i++){
			if(seq[i] != ""){
				if(sort[i] == ""){
					sort[i] ="0";
				}
				 InsComDatabase ic_db = InsComDatabase.getInstance();
				if(ic_db.updateInsExcelComSort(Integer.parseInt(seq[i]), Integer.parseInt(sort[i]))){
					flag += 1;
				} 
			}
		}
	}catch(Exception e){
		System.out.println(e);
		flag = -1;
	}  
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='javascript'>
 	if(<%=flag%>>0){
	}else if(<%=flag%> <0){
		alert("파일 형식이 기존과 다릅니다.");
	}else{
		alert("차량번호 확인이 필요합니다.");
	}
	opener.location.reload();
	self.close(); 
	
</script>
</head>
<body>
	

</body>
</html>
