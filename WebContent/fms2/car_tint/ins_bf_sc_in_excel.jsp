<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=ins_bf_sc_in_excel.xls");
%>

<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	String rent_or_lease = request.getParameter("rent_or_lease")	== null ? "" : request.getParameter("rent_or_lease");
	String con_f 			 = request.getParameter("con_f")			   	== null ? "" : request.getParameter("con_f");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	Vector vt = t_db.getCarTintInsBlackFileList(s_kd, t_wd, gubun1, gubun2, gubun3, st_dt, end_dt, sort, rent_or_lease, con_f);
	int vt_size = vt.size();
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--

//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 	value='<%=sort%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='ins_bf_frame.jsp'>
  <input type='hidden' name='rent_mng_id' value=''>
  <input type='hidden' name='rent_l_cd' value=''>
  <input type='hidden' name='tint_no' value=''>  
  <input type='hidden' name='mode' value=''>    
<table border="0" cellspacing="0" cellpadding="0" width='1000'>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>  
    <tr id='tr_title' style='position:relative;z-index:1'>
	<td class='line' width='300' id='td_title' style='position:relative;'>
	    <table border="1" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td rowspan="2" width='50' class='title' style='height:51'>연번</td>    
		    <td rowspan="2" width='100' class='title'>차량번호</td>						
        	    <td rowspan="2" width='150' class='title'>차대번호</td>		    
		    <td colspan="4" class='title' style='height:24'>블랙박스설치내역</td>
		    <td rowspan="2" width="100" class='title'>첨부파일</td>
		</tr>
		<tr>
		    <td width='150' class='title' style='height:23'>제조사</td>
		    <td width='150' class='title'>모델명</td>
		    <td width='200' class='title'>일련번호</td>
		    <td width='100' class='title'>설치일자</td>	
		</tr>
    <%	if(vt_size > 0){%>
                <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
		%>
		<tr>
		    <td width='50' align='center'><%=i+1%></td>		    
		    <td width='100' align='center'><%=ht.get("CAR_NO")%></td>
		    <td width='150' align='center'><%=ht.get("CAR_NUM")%></td>		    
	            <td width='150' align='center'><%=ht.get("COM_NM")%></td>
		    <td width='150' align='center'><%=ht.get("MODEL_NM")%></td>
		    <td width='200' align='center'><%=ht.get("SERIAL_NO")%></td>					
		    <td width='100' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("SUP_DT")))%></td>	
		    <td width='100' align='center'></td>									
		</tr>
		<%	}%>
	    </table>
	</td>
    </tr>	
    <%	}else{%>                     
    <%	}%>
</table>
</form>
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>

