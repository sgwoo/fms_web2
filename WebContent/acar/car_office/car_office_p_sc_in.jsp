<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*, acar.common.*" %>
<%@ page import="acar.car_office.*" %>
<jsp:useBean id="coe_bean" class="acar.car_office.CarOffEmpBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String gubun 		= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gu_nm 		= request.getParameter("gu_nm")==null?"":request.getParameter("gu_nm");
	String sort_gubun 	= request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String sort 		= request.getParameter("sort")==null?"":request.getParameter("sort");
	String cng_rsn 		= request.getParameter("cng_rsn")==null?"":request.getParameter("cng_rsn");
	
	String gubun1 		= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")==null?"0":request.getParameter("gubun4");
	String st_dt 		= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	CarOffEmpBean coe_r [] = umd.getCarOffEmpAllList2(gubun1,gubun2,gubun3,gubun4,gubun, gu_nm, sort_gubun, sort, cng_rsn, st_dt, end_dt);
	
	
	
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
-->
</script>
<script language="JavaScript">
<!--
function DispatchSearch()
{
	var theForm = document.DispatchSearchFrom;
	theForm.submit();
}
function ContractContent(id)
{
	var theForm = document.ContractContentFrom;
	theForm.h_cont_id.value = id;
	theForm.submit();
}
function CompanyAdd()
{
	
	var SUBWIN="./car_company_i.html";	
	window.open(SUBWIN, "CompanyList", "left=100, top=100, width=300, height=300, scrollbars=yes");
}
function OfficeAdd()
{
	
	var SUBWIN="./car_office_i.html";	
	window.open(SUBWIN, "OfficeList", "left=100, top=100, width=350, height=330, scrollbars=yes");
}
function OpenMemo(emp_id)
{
	var theForm = document.CarOffEmpUpdateForm;
	var auth_rw = theForm.auth_rw.value;
	var SUBWIN="./office_memo_i.jsp?emp_id="+emp_id + "&auth_rw=" +auth_rw;	
	window.open(SUBWIN, "Memo", "left=100, top=100, width=570, height=320, scrollbars=no");
}
function UpdateList(arg)
{
	
	var theForm = document.CarOffEmpUpdateForm;
	theForm.emp_id.value = arg;
	theForm.target="d_content";
	theForm.submit();
}
function damdang_list(arg){
	var SUBWIN="./damdang_list.jsp?emp_id="+arg;	
	window.open(SUBWIN, "update_list", "left=100, top=100, width=440, height=320, scrollbars=yes");	
}
//-->
</script>
</head>
<body onLoad="javascript:init()">
<form action="./car_office_p_s.jsp" name="CarOffEmpUpdateForm" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="gubun" value="<%=gubun%>">
<input type="hidden" name="gu_nm" value="<%=gu_nm%>">
<input type="hidden" name="gubun1" value="<%=gubun1%>">
<input type="hidden" name="gubun2" value="<%=gubun2%>">
<input type="hidden" name="gubun3" value="<%=gubun3%>">
<input type="hidden" name="gubun4" value="<%=gubun4%>">
<input type="hidden" name="st_dt" value="<%=st_dt%>">
<input type="hidden" name="end_dt" value="<%=end_dt%>">
<input type="hidden" name="emp_id" value="">
<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr>
        <td>
            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                <tr>
                    <td class=line2 colspan=2></td>
                </tr>
	            <tr id='tr_title' style='position:relative;z-index:1'>		
                    <td width=32% class='line' id='td_title' style='position:relative;'> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr> 
                                <td width='18%' class='title' style='height:51'>연번</td>
                                <td width='38%' class='title' height="31" >소속사</td>
                                <td width='44%' class='title' height="31" >근무지역</td>
                            </tr>
                        </table>
                    </td>		
                    <td width=68% class='line'> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr> 
                                <td width='15%' class='title' rowspan="2">근무처</td>
                                <td width='11%' class='title' rowspan="2">성명</td>
                                <td width='10%' class='title' rowspan="2">직급</td>
                                <td colspan="2" class='title'>연락처</td>
            				    <td width="11%" rowspan="2" class='title'>담당자</td>
            				    <td width="12%" rowspan="2" class='title'>지정사유</td>
            				    <td width="13%" rowspan="2" class='title'>지정일자</td>
                            </tr>
                            <tr> 
                                <td width='14%' class='title'>사무실</td>
                                <td width='14%' class='title'>핸드폰</td>
                            </tr>
                        </table>
 		            </td>
	            </tr>
<%if(coe_r.length > 0 ){%>
	            <tr>
                    <td width=32% class='line' id='td_con' style='position:relative;'> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <%
    for(int i=0; i<coe_r.length; i++){
        coe_bean = coe_r[i];
		Hashtable ht = umd.getCar_off_addr(coe_bean.getCar_off_id());
%>
                            <tr> 
                                <td width='18%' align='center'> <%=i+1%></td>
                                <td width='38%' align='center'><%= coe_bean.getCar_comp_nm() %></td>
                                <td width='22%' align="center"><%=ht.get("ADDR1")%></td>
                                <td width='22%' align="center"><%= ht.get("ADDR2") %></td>
                            </tr>
                            <%}%>
                            <tr> 
                                <td align='center'  class='title'>&nbsp;</td>
                                <td  class='title' align='center'>&nbsp;</td>
                                <td colspan="2" align='center'  class='title'>&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                    <td width=68% class='line'> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100% >
                <%
    for(int i=0; i<coe_r.length; i++){
        coe_bean = coe_r[i]; %>
                            <tr> 
                                <td width='15%' align='center' ><span title="<%= coe_bean.getCar_off_nm() %>"><%if(coe_bean.getCar_off_nm().indexOf("영업소")>0){
            				  										out.print(AddUtil.subData(AddUtil.replace(coe_bean.getCar_off_nm(),"영업소","(영)"),7));
            													}else if(coe_bean.getCar_off_nm().indexOf("대리점")>0){
            														out.print(AddUtil.subData(AddUtil.replace(coe_bean.getCar_off_nm(),"대리점","(대)"),7));
            													}else{
            														out.print(AddUtil.subData(coe_bean.getCar_off_nm(),7));
            													}%></span></td>
                                <td width='11%' align='center' ><span title="<%= coe_bean.getEmp_nm() %>"><a href="javascript:UpdateList('<%= coe_bean.getEmp_id() %>')" onMouseOver="window.status=''; return true"><%= AddUtil.subData(coe_bean.getEmp_nm(),3) %></a></span></td>
                                <td width='10%' align='center' ><span title="<%= coe_bean.getEmp_pos() %>"><%= AddUtil.subData(coe_bean.getEmp_pos(),3) %></span></td>
                                <td width='14%' align='center' ><%= coe_bean.getCar_off_tel() %></td>
                                <td width='14%' align='center' ><%= coe_bean.getEmp_m_tel() %></td>
            				    <td width="11%" align='center'><%= c_db.getNameById(coe_bean.getDamdang_id(),"USER") %></td>
            				    <td width="12%" align='center'>
            				  	<% if(AddUtil.parseInt(coe_bean.getSeq())>1){ %><a href="javascript:damdang_list('<%= coe_bean.getEmp_id() %>')"  onMouseOver="window.status=''; return true"><% } %>
            					  <% if(coe_bean.getCng_rsn().equals("1"))	 out.print("1.최근계약");
            				  			else if(coe_bean.getCng_rsn().equals("2")) out.print("2.대면상담");
            				  			else if(coe_bean.getCng_rsn().equals("3")) out.print("3.전화상담");
            				  			else if(coe_bean.getCng_rsn().equals("4")) out.print("4.전산배정");														
            				  			else if(coe_bean.getCng_rsn().equals("5")) out.print("5.기타"); %>
            					<% if(AddUtil.parseInt(coe_bean.getSeq())>1){ %></a><% } %></td>
            				    <td width="13%" align='center'><%= AddUtil.ChangeDate2(coe_bean.getCng_dt()) %></td>					  
                            </tr>
                            <%}%>
                            <tr> 
                                <td colspan="8" align='center'  class='title' >&nbsp;</td>
                            </tr>
                        </table>
		            </td>
	            </tr>
<%}else{%>
	            <tr>
	                <td width=32% class='line' id='td_con' style='position:relative;'> 
	                    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr> 
                                <td align='center'></td>
                            </tr>
                        </table>
                    </td>
	                <td width=68% class='line'> 
                        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr> 
                                <td  align='left' >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;해당 데이터가 없습니다.</td>
                            </tr>          
                        </table>
		            </td>
	            </tr>
<%}%>		
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>