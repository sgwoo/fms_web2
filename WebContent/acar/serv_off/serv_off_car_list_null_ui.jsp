<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.serv_off.*" %>

<%
	ServOffDatabase sod = ServOffDatabase.getInstance();
	String auth_rw = "";
	String off_id = "";
	int count = 0;
	
	if(request.getParameter("auth_rw") != null) auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("off_id") != null) off_id = request.getParameter("off_id"); 
	
    /*******차량등록***********/	
	String code [] = null;
	
	code = request.getParameterValues("seq_no");
	
    Vector v = new Vector();
    Throwable error = null;
    if(code != null && code.length > 0){
        for(int i=0; i<code.length; i++){
            try{
	            int val [] = {Util.parseInt(code[i])};
                v.addElement(val);
            }catch(NoSuchElementException  nse){
                error = nse;
            }
        }
    }
    count = sod.deleteCustServ(off_id,v);
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>

</head>
<body leftmargin="15">

<script>
<%

		if(count!=0)
		{
%>
alert("정상적으로 처리되었습니다.");
//top.window.SMenuSearch();
parent.CustServList.CarListLoad();
window.location = "about:blank";

<%
		}

%>
</script>
</body>
</html>