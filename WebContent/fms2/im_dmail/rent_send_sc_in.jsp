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
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	ImEmailDatabase ie_db = ImEmailDatabase.getInstance();
	
	
	Vector vt =  ie_db.getReNewInfoMailDocSendList(s_kd, t_wd, st_dt, end_dt, gubun1, gubun2, gubun3, gubun4, gubun5);
	int vt_size = vt.size();
	
	long total_amt1	= 0;
	long total_amt2	= 0;
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}
	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    	    
	}
	
	function init(){		
		setupEvents();
	}
	
		
//-->
</script>
</head>
<body onLoad="javascript:init()">
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
  <input type='hidden' name='from_page' value='/fms2/im_dmail/rent_send_sc_in.jsp'>  
<table border="0" cellspacing="0" cellpadding="0" width='1450'>
  <tr id='tr_title' style='position:relative;z-index:1'>
  	<tr><td class=line2 colspan="2"></td></tr>		
    <td class='line' width='450' id='td_title' style='position:relative;'> 
	  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr> 
          <td width='60' class='title'>연번</td>		    
          <td width='90' class='title'>발송여부</td>		  
		  <td width='80' class='title'>수신여부</td>
          <td width='220' class='title'>받는사람</td>		  
          </tr>
      </table>
	</td>
	<td class='line' width='1000'>
	  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		  <td width="160" class='title'>발송일시</td>		
		  <td width="160" class='title'>확인일시</td>				  				
		  <td width="680" class='title'>제목</td>
		  </tr>
	  </table>
	</td>
  </tr>
  <%if(vt_size > 0){%>
  <tr>		
    <td class='line' width='450' id='td_con' style='position:relative;'> 
	  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);%>
        <tr> 		
          <td width='60' align='center'><%=i+1%></td>		  
		  <td width='90' align='center'><span title='<%=ht.get("NOTE")%>'><%=ht.get("ERRCODE_NM")%></span></td>		  
          <td width='80' align='center'><%=ht.get("OCNT_NM")%></td>
  		  <td width='220' align='center'><a href="javascript:parent.view_im_dmail('<%=ht.get("ST")%>','<%=ht.get("DMIDX")%>')" onMouseOver="window.status=''; return true" title="클릭하세요"><%=ht.get("EMAIL")%></a>
  		  	<%if(String.valueOf(ht.get("EMAIL")).equals("")){ %>
  		  		<%=ht.get("SQL")%>
  		  	<%} %>
  		  </td>
        </tr>      
        <%	}%>
				<tr>						
				    <td class='title'>&nbsp;</td>
				    <!--<td class='title'>&nbsp;</td>-->
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>					
				</tr>		
      </table>
	</td>
	<td class='line' width='1000'>
	  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				%>
		<tr>
		  <td width='160' align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("STIME")))%>
		  	<%if(String.valueOf(ht.get("STIME")).equals("")){ %>
  		  		<%=AddUtil.ChangeDate3(String.valueOf(ht.get("SDATE")))%>
  		  	<%} %>
		  </td>
		  <td width='160' align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("OTIME")))%></td>
          <td width='680'>&nbsp;<span title='<%=ht.get("SUBJECT")%>'><%=ht.get("SUBJECT2")%></span>&nbsp;<%=ht.get("R_ST")%></td>         				  
		  </tr>	
<%		}	%>
				<tr>		
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
			    </tr>
	  </table>
	</td>
<%	}else{%>                     
    <tr>
	    <td class='line' width='450' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td align='center'>등록된 데이타가 없습니다</td>
                </tr>
                </table>
	    </td>
	    <td class='line' width='1000'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
		            <td>&nbsp;</td>
		        </tr>
	        </table>
	    </td>
    </tr>
<%	}	%>
</table>
</form>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>

