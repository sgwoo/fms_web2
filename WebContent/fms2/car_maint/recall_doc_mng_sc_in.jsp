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
	String cmd = "";
		
	
	Vector fines = FineDocDb.getFineDocLists("리콜", br_id, gubun1, gubun2, gubun3,  gubun4, "R", st_dt, end_dt, s_kd, t_wd, sort, asc);
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

<table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='55%' id='td_title' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width=10%>연번</td>
	           <td width=15% class='title'>문서번호</td>
                    <td width=17% class='title'>리콜접수일자</td>
                    <td width=23% class='title'> 제조사</td>
                    <td width=17% class='title'> 리콜고지일자</td>
                </tr>
            </table>
	    </td>
	    <td class='line' width='45%'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <tr> 
                <td class='title' width=10%>건수</td>
                <td class='title' width=30%>시행기간</td>
                <td class='title' width=60%>리콜방법</td>
	    					
              </tr>
            </table>
	    </td>
    </tr> 
    <tr>
	    <td class='line' width='55%' id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <%for(int i = 0 ; i < fine_size ; i++){
    				Hashtable ht = (Hashtable)fines.elementAt(i);%>
              <tr> 
                <td  align='center' width=10%><%=i+1%></td>
	       <td  width=15% align='center'><a href="javascript:parent.view_fine_doc('<%=ht.get("DOC_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("DOC_ID")%></a></td>
                <td  width=17% align='center'><%=AddUtil.getDate3(String.valueOf(ht.get("DOC_DT")))%></td>
                <td  width=23% align='center'><%=ht.get("GOV_NM")%></td>
                <td  width=17% align='center'><%=AddUtil.getDate3(String.valueOf(ht.get("PRINT_DT")))%></td>
              </tr>
              <%}%>
    		  <%if(fine_size==0){%>
                <td  align='center'>등록된 데이타가 없습니다.</td>		  
              <%}%>		  
            </table>
	    </td>
	    <td class='line' width='45%'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <%for(int i = 0 ; i < fine_size ; i++){
    				Hashtable ht = (Hashtable)fines.elementAt(i);%>
              <tr> 
                <td align="center" width=10%><%=ht.get("CNT")%>건</td>
                <td align="center" width=30%><%=ht.get("IP_DT")%>~<%=ht.get("END_DT")%></td>	
                 <td align="center" width=60%><%=ht.get("MNG_DEPT")%></td>					
               
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
