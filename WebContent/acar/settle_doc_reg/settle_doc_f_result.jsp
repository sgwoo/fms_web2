<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
    String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");// 거래처

	
	Vector fines = FineDocDb.getFineDocFResultLists("채권추심", client_id);
	int fine_size = fines.size();
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
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
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">

<form name='form1' action='' method='post' target='d_content'>

<input type='hidden' name='fee_size' value='<%=fine_size%>'>

<table border="0" cellspacing="0" cellpadding="0" width='650'>
  <tr>
    <td colspan=2 class=line2></td>
 </tr>
  <tr id='tr_title' style='position:relative;z-index:1'>
	<td class='line' width='650' id='td_title' style='position:relative;'>			
        <table border="0" cellspacing="1" cellpadding="0" width='650'>
          <tr> 
            <td class='title' width="30">연번</td>
            <td width='120' class='title'>문서번호</td>
            <td width='100' class='title'>시행일자</td>
            <td width='400' class='title'>반송주소</td>
          </tr>
        </table>
	</td>

  </tr> 
  
  <tr>
	<td class='line' width='650' id='td_con' style='position:relative;'>			
        <table border="0" cellspacing="1" cellpadding="0" width='650'>
          <%for(int i = 0 ; i < fine_size ; i++){
				Hashtable ht = (Hashtable)fines.elementAt(i);%>
          <tr> 
            <td  align='center' width="30"><%=i+1%></td>
            <td  width='120' align='center'><%=ht.get("DOC_ID")%></td>
            <td  width='100' align='center'><%=AddUtil.getDate3(String.valueOf(ht.get("DOC_DT")))%></td>
            <td  width='400' align='center'><%=String.valueOf(ht.get("GOV_ADDR"))%></td>
          </tr>
          <%}%>
		  <%if(fine_size==0){%>
            <td  align='center'>등록된 데이타가 없습니다.</td>		  
          <%}%>		  
        </table>
	</td>
	
  </tr>
</table>

</form>
</body>
</html>
