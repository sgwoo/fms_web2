<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.im_email.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>


<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	String firm_nm 	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	ImEmailDatabase ie_db = ImEmailDatabase.getInstance();
	
	
	gubun4 	= "1";
	gubun1 	= "3";
	st_dt 	= String.valueOf(AddUtil.getDate2(1)-1)+"0101";
	end_dt 	= AddUtil.getDate();
	gubun2	= "";
	s_kd	= "3";
	t_wd	= firm_nm;
	
	Vector vt =  ie_db.getFmsInfoMailPaySendList(s_kd, t_wd, st_dt, end_dt, gubun1, gubun2, gubun3, gubun4, gubun5);
	int vt_size = vt.size();
	
	long total_amt1	= 0;
	long total_amt2	= 0;
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
<script language='javascript'>
<!--

//-->
</script>
</head>
<body>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>    
  <input type='hidden' name='req_dt'    value=''>      
  <input type='hidden' name='from_page' value='/fms2/im_dmail/pay_send_sc_in.jsp'>  
<table border="0" cellspacing="0" cellpadding="0" width='1220'>
  <tr><td>* 청구메일</td></tr>	
  <tr><td class=line2></td></tr>	
  <tr>
	<td class='line'> 
	  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr> 
          <td width='30' class='title'>연번</td>		    
          <td width='80' class='title'>발송여부</td>		  
		  <td width='80' class='title'>수신여부</td>
          <td width='230' class='title'>받는사람</td>		  
		  <td width="150" class='title'>발송일시</td>		
		  <td width="150" class='title'>확인일시</td>				  				
		  <td width="500" class='title'>제목</td>
		  </tr>
  <%if(vt_size > 0){%>
        <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);%>
        <tr> 
          <td width='30' align='center'><%=i+1%></td>		  
		  <td width='80' align='center'><span title='<%=ht.get("NOTE")%>'><%=ht.get("ERRCODE_NM")%></span></td>		  
          <td width='80' align='center'><%=ht.get("OCNT_NM")%></td>
  		  <td width='230' align='center'><%=ht.get("EMAIL")%></td>
		  <td width='150' align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("STIME")))%></td>
		  <td width='150' align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("OTIME")))%></td>
          <td width='500'>&nbsp;<span title='<%=ht.get("SUBJECT")%>'><%=ht.get("SUBJECT2")%></span>&nbsp;<%=ht.get("R_ST")%></td>         				  
		  </tr>	
<%		}	%>
<%	}	%>
	  </table>
	</td>
  </tr>
<%	vt =  ie_db.getFmsInfoMailDocSendList(s_kd, t_wd, st_dt, end_dt, gubun1, gubun2, gubun3, gubun4, gubun5);
	vt_size = vt.size();%>  
  <tr><td>* 안내메일</td></tr>	
  <tr><td class=line2></td></tr>	
  <tr>
	<td class='line'> 
	  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr> 
          <td width='30' class='title'>연번</td>		    
          <td width='80' class='title'>발송여부</td>		  
		  <td width='80' class='title'>수신여부</td>
          <td width='230' class='title'>받는사람</td>		  
		  <td width="150" class='title'>발송일시</td>		
		  <td width="150" class='title'>확인일시</td>				  				
		  <td width="500" class='title'>제목</td>
		  </tr>
  <%if(vt_size > 0){%>
        <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);%>
        <tr> 
          <td width='30' align='center'><%=i+1%></td>		  
		  <td width='80' align='center'><span title='<%=ht.get("NOTE")%>'><%=ht.get("ERRCODE_NM")%></span></td>		  
          <td width='80' align='center'><%=ht.get("OCNT_NM")%></td>
  		  <td width='230' align='center'><%=ht.get("EMAIL")%></td>
		  <td width='150' align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("STIME")))%></td>
		  <td width='150' align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("OTIME")))%></td>
          <td width='500'>&nbsp;<span title='<%=ht.get("SUBJECT")%>'><%=ht.get("SUBJECT2")%></span>&nbsp;<%=ht.get("R_ST")%></td>         				  
		  </tr>	
<%		}	%>
<%	}	%>
	  </table>
	</td>
  </tr>
</table>
</form>
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>

