<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	
	Vector fines = FineDocDb.getFineDocLists("채권추심", br_id, gubun1, gubun2, gubun3, gubun4, "", st_dt, end_dt, s_kd, t_wd, sort, asc);
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
	
	function set_scd_stop(doc_id, doc_dt, file_name){
		opener.document.form1.stop_doc_id.value = doc_id;
		opener.document.form1.stop_doc_dt.value = doc_dt;
		opener.document.form1.stop_doc.value = file_name;	
		window.close();		
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">

<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='fee_size' value='<%=fine_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width='1000'>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='450' id='td_title' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='450'>
              <tr> 
                <td class='title' width="30">연번</td>
                <td width='120' class='title'>문서번호</td>
                <td width='100' class='title'>시행일자</td>
                <td width='200' class='title'>수신처</td>
              </tr>
            </table>
	    </td>
	    <td class='line' width='550'>			
            <table border="0" cellspacing="1" cellpadding="0" width='550'>
              <tr> 
                <td width='300' class='title'>제목</td>			
                <td class='title' width="100">미수채권 건수</td>
                <td class='title' width="100">유예기간</td>
                <td class='title' width="50">스캔</td>			
              </tr>
            </table>
	    </td>
    </tr> 
    <tr>
	    <td class='line' width='450' id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='450'>
              <%for(int i = 0 ; i < fine_size ; i++){
    				Hashtable ht = (Hashtable)fines.elementAt(i);%>
              <tr> 
                <td  align='center' width="30"><%=i+1%></td>
                <td  width='120' align='center'>
    			<%if(from_page.equals("/fms2/con_fee/fee_scd_u_stop.jsp")){%>
    			<a href="javascript:set_scd_stop('<%=ht.get("DOC_ID")%>','<%=AddUtil.ChangeDate2(String.valueOf(ht.get("DOC_DT")))%>','<%=ht.get("FILENAME")%>')" onMouseOver="window.status=''; return true"><%=ht.get("DOC_ID")%></a>
    			<%}else{%>
    			<a href="javascript:parent.view_fine_doc('<%=ht.get("DOC_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("DOC_ID")%></a>
    			<%}%>
    			</td>
                <td  width='100' align='center'><%=AddUtil.getDate3(String.valueOf(ht.get("DOC_DT")))%></td>
                <td  width='200' align='center'><%=Util.subData(String.valueOf(ht.get("GOV_NM")), 14)%></td>
              </tr>
              <%}%>
    		  <%if(fine_size==0){%>
                <td  align='center'>등록된 데이타가 없습니다.</td>		  
              <%}%>		  
            </table>
	    </td>
	    <td class='line' width='550'>			
            <table border="0" cellspacing="1" cellpadding="0" width='550'>
              <%for(int i = 0 ; i < fine_size ; i++){
    				Hashtable ht = (Hashtable)fines.elementAt(i);%>
              <tr> 
                <td  width='300' align='center'><%=ht.get("TITLE")%></td>			            <td align="center" width="100"><%=ht.get("CNT")%>건</td>
                <td align="center" width="100"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("END_DT")))%></td>
                <td align="center" width="50"><a href="https://fms3.amazoncar.co.kr/data/stop_doc/<%=ht.get("FILENAME")%>" target="_blank"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></td>			
              </tr>
              <%}%>		  
    		  <%if(fine_size==0){%>
                <td  align='center'></td>		  
              <%}%>				  
            </table>
	    </td>
    </tr>
</table>
</form>
</body>
</html>
