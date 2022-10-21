<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineGovBn" scope="page" class="acar.forfeit_mng.FineGovBean"/>
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
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
		
	
	Vector fines = FineDocDb.getFineGovLists(gubun1, AddUtil.replace(gubun2, "구", ""), t_wd);
	int fine_size = fines.size();
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">

<style type="text/css">
	.tr-top td {
    	border-top: 0.5px solid #b0baec !important;
    }
    .tr-left tr:nth-child(1), td:nth-child(1) {
    	border-left: 0.5px solid #b0baec !important;
    }
    .num {
    	min-width: 40px;
    	max-width: 50px;
    }
    .wid {
    	min-width: 200px;
    	max-width: 210px;
    }
    .wid2 {
    	min-width: 110px;
    	max-width: 120px;
    }
    .table-t td {
    	border-right: 0.5px solid #b0baec !important;
    	border-bottom: 0.5px solid #b0baec !important;
    }
</style>

</head>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	/* Title 고정 */
	/* function setupEvents(){
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
	} */
//-->
</script>
<body onLoad="javascript:init()">

<table class="table-t" border="0" cellspacing="0" cellpadding="0" width='100%' style="margin-top: 10px;">
	<thead>
		<tr class="tr-left tr-top"> 
            <td class='title num'>연번</td>
            <td class='title'>기관명</td>
            <td class='title'>문서24 기관명</td>
            <td class='title'>기관부서코드</td>
            <td class='title'>참조</td>
            <td class='title'>연락처</td>
            <td class='title'>주소</td>     
        </tr>
	</thead>
	<tbody>
		<%for(int i = 0 ; i < fine_size ; i++){
			FineGovBn = (FineGovBean)fines.elementAt(i);%>		
         <tr class="tr-left"> 
             <td align='center'><%=i+1%></td>
             <td align='center' class="wid"><%if(FineGovBn.getUse_yn().equals("N")){%><font color="red">[사용금지]</font><%}%><a href="javascript:parent.view_gov('<%=FineGovBn.getGov_id()%>')" onMouseOver="window.status=''; return true"><span title='<%=FineGovBn.getGov_nm()%>'><%=Util.subData(FineGovBn.getGov_nm(), 15)%></span></a></td>
             <td align='center'><span title='<%=FineGovBn.getGov_nm2()%>'><%=FineGovBn.getGov_nm2()%></span></td>
             <td align='center'><%=FineGovBn.getGov_dept_code()%></td>
             <td align='center' class="wid2"><span title="<%=FineGovBn.getMng_dept()%>"><%=Util.subData(FineGovBn.getMng_dept(), 7)%></span></td>
             <td align='center'><%=FineGovBn.getTel()%></td>
             <td>&nbsp;&nbsp;(<%=FineGovBn.getZip()%>) <span title="<%=FineGovBn.getAddr()%>"><%=Util.subData(FineGovBn.getAddr(), 40)%></span></td>
         </tr>
       	<%}%>	
	</tbody>
</table>

<%-- <table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr><td class=line2 colspan=2></td></tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='55%' id='td_title' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width="10%">연번</td>
                    <td width='26%' class='title'>기관명</td>
                    <td width='26%' class='title'>문서24 기관명</td>
                    <td width='20%' class='title'>참조</td>
                    <td width='18%' class='title'>연락처</td>          
                </tr>
            </table>
	    </td>
	    <td class='line' width='45%'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title'>주소</td>
                </tr>
            </table>
	    </td>
    </tr>  
    <tr>
	    <td class='line' width='55%' id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <%for(int i = 0 ; i < fine_size ; i++){
    				FineGovBn = (FineGovBean)fines.elementAt(i);%>		
                <tr> 
                    <td  align='center' width="10%"><%=i+1%></td>
                    <td  width='26%' align='center'><%if(FineGovBn.getUse_yn().equals("N")){%><font color="red">[사용금지]</font><%}%><a href="javascript:parent.view_gov('<%=FineGovBn.getGov_id()%>')" onMouseOver="window.status=''; return true"><span title='<%=FineGovBn.getGov_nm()%>'><%=Util.subData(FineGovBn.getGov_nm(), 15)%></span></a></td>
                    <td  width='26%' align='center'><%=FineGovBn.getGov_nm2()%></td>
                    <td  width='20%' align='center'><span title="<%=FineGovBn.getMng_dept()%>"><%=Util.subData(FineGovBn.getMng_dept(), 7)%></span></td>
                    <td  width='18%' align='center'><%=FineGovBn.getTel()%></td>
                </tr>
              <%}%>		  
            </table>
	    </td>
	    <td class='line' width='45%'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%for(int i = 0 ; i < fine_size ; i++){
				FineGovBn = (FineGovBean)fines.elementAt(i);%>		
                <tr> 
                    <td>&nbsp;&nbsp;(<%=FineGovBn.getZip()%>) <span title="<%=FineGovBn.getAddr()%>"><%=Util.subData(FineGovBn.getAddr(), 40)%></span></td>
                </tr>
          <%}%>		  		  
            </table>
	    </td>
    </tr>
</table> --%>
</body>
</html>
