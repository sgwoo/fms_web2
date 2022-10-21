<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.incom.*, acar.util.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.incom.IncomDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String dt = request.getParameter("dt")==null?"1":request.getParameter("dt");
	String ref_dt1 = request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 = request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	Vector vt =  a_db.getIncomStat(t_wd, dt, ref_dt1, ref_dt2);
	int incom_size = vt.size();
	
	String value[] = new String[2];
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
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
<table border="0" cellspacing="0" cellpadding="0" width='750'>
  <tr id='tr_title' style='position:relative;z-index:1'>
  	<tr><td class=line2 colspan="2"></td></tr>		
    <td class='line' width='750' id='td_title' style='position:relative;'> 
	  <table border="0" cellspacing="1" cellpadding="0" width='750'>
        <tr> 
          <td width='50' class='title'>연번</td>
          <td width='150' class='title'>은행</td>
          <td width='200' class='title'>계좌번호</td>
          <td width="150" class='title'>건수</td>
       	  <td width="200" class='title'>금액</td>
	    
		</tr>
	  </table>
	</td>
  </tr>
  <%if(incom_size > 0){%>
  <tr>		
    <td class='line' width='750'10' id='td_con' style='position:relative;'> 
	  <table border="0" cellspacing="1" cellpadding="0" width='750'>
        <%	for(int i = 0 ; i < incom_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				
				StringTokenizer st = new StringTokenizer(String.valueOf(ht.get("BANK_NM")),":");
				int s=0; 
				while(st.hasMoreTokens()){
						value[s] = st.nextToken();
						s++;
				}
		%>
     	<tr> 
          <td width='50' align='center'><%=i+1%></td>
		  <td width='150' align='center'><%=value[1]%></td>
  		  <td width='200' align='center'><%=ht.get("BANK_NO")%></td>
          <td width='150' align='right'><a href="javascript:parent.view_incom('<%=ht.get("BANK_NM")%>', '<%=ht.get("BANK_NO")%>')" onMouseOver="window.status=''; return true" title="클릭하세요"><%=Util.parseDecimal(String.valueOf(ht.get("TOT_CNT")))%></a></td>
          <td width='200' align='right'><%=Util.parseDecimal(String.valueOf(ht.get("TOT_AMT")))%></td>
        </tr>
      
        <%		}	%>
      </table>
	</td>

<%	}	%>
</table>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=incom_size%>';
//-->
</script>
</body>
</html>

