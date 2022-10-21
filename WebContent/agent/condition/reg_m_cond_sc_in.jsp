<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.condition.*" %>
<jsp:useBean id="c_bean" class="acar.condition.ConditionBean" scope="page"/>

<%
	ConditionDatabase cdb = ConditionDatabase.getInstance();
	String gubun = "1";
	String ref_dt1 = Util.getDate();
	String ref_dt2 = Util.getDate();
	String br_id = "";
	String fn_id = "0";
	String dt = "1";
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	if(request.getParameter("gubun") != null)	gubun = request.getParameter("gubun");
	if(request.getParameter("dt") != null)	dt = request.getParameter("dt");
	if(request.getParameter("ref_dt1") != null)	ref_dt1 = request.getParameter("ref_dt1");
	if(request.getParameter("ref_dt2") != null)	ref_dt2 = request.getParameter("ref_dt2");
	if(request.getParameter("br_id") != null)	br_id = request.getParameter("br_id");
	if(request.getParameter("fn_id") != null ) fn_id = request.getParameter("fn_id");
	
	
	ConditionBean c_r [] = cdb.getRegCondAll2(gubun,dt,ref_dt1,ref_dt2, br_id, fn_id, user_id);

%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>등록리스트</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
function CarRegList(rent_mng_id, rent_l_cd, car_mng_id, reg_gubun, rpt_no, firm_nm, client_nm, imm_amt)
{
	var theForm = document.CarRegDispForm;
	theForm.rent_mng_id.value = rent_mng_id;
	theForm.rent_l_cd.value = rent_l_cd;
	theForm.car_mng_id.value = car_mng_id;
	theForm.cmd.value = reg_gubun;
	theForm.rpt_no.value = rpt_no;
	theForm.firm_nm.value = firm_nm;
	theForm.client_nm.value = client_nm;
	theForm.imm_amt.value = imm_amt;
	
<% 
//	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))
//	{
%>
		//theForm.action = "./register_frame.jsp";
//		theForm.action = "./register_frame.jsp";
<%
//	}else{
%>
		if(reg_gubun=="id")
		{
			alert("미등록 상태입니다.");
			return;
		}
		//theForm.action = "./register_r_frame.jsp";
		theForm.action = "./register_frame.jsp";
<%
//	}
%>
	theForm.target = "d_content"
	theForm.submit();
}
/* Title 고정 */
function setupEvents()
{
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
}

function moveTitle()
{
    var X ;
    document.all.title.style.pixelTop = document.body.scrollTop ;
                                                                              
    document.all.title_col0.style.pixelLeft	= document.body.scrollLeft ; 
    document.all.D1_col.style.pixelLeft	= document.body.scrollLeft ;   
    
}
function init() {
	
	setupEvents();
}
function view_client(rent_mng_id, rent_l_cd, r_st)
{
	var SUBWIN="/agent/con_fee/con_fee_client_s.jsp?m_id="+rent_mng_id+"&l_cd="+rent_l_cd+"&r_st="+r_st;	
	window.open(SUBWIN, "View_CLIENT", "left=50, top=50, width=820, height=700, resizable=yes, scrollbars=yes");
}
//-->
</script>
</head>
<body onLoad="javascript:init()">
<table border=0 cellspacing=0 cellpadding=0 width="2000">
    <tr>
        <td>
            <table border=0 cellspacing=0 cellpadding=0 width="100%">
                <tr>
                    <td class=line2 colspan=2></td>
                </tr>
            	<tr id='title' style='position:relative;z-index:1'>
            		<td width=150 class=line id='title_col0' style='position:relative;'>
            			<table border=0 cellspacing=1 width="100%">
            				<tr>
								<td width=50 class=title style="height:45">연번</td>
			            		<td width=100 class=title>계약번호</td>
			            	</tr>
			            </table>
			        </td>
			        <td class=line width=1850>
			        	<table  border=0 cellspacing=1 width="100%">
			        		<tr>
			            		<td width=80 rowspan=2 class=title>계약일</td>
			            		<td width=200 rowspan=2 class=title>상호</td>
			            		<td width=80 rowspan=2 class=title>계약자</td>			            		
              					<td width=150 rowspan=2 class=title>차종</td>
              					<td width=80 rowspan=2 class=title>대금결재일</td>
			            		<td width=80 rowspan=2 class=title>출고요청일</td>
			            		<td width=80 rowspan=2 class=title>출고예정일</td>
								<td width=60 rowspan=2 class=title>최초<br>영업자</td>
			            		<td width=60 rowspan=2 class=title>대여<br>방식</td>
			            		<td width=60 rowspan=2 class=title>대여<br>기간</td>
			            		<td colspan=4 class=title>영업사원</td>
			            		<td colspan=4 class=title>출고사원</td>
			            		<td width=200 rowspan=2 class=title>출고지연사유</td>
			            	</tr>
			            	<tr>
			            		<td width=100 class=title>소속사</td>
								<td width=100 class=title>영업소</td>
			            		<td width=60 class=title>담당자</td>			            		
               					<td width=100 class=title>전화번호</td>
			            		<td width=100 class=title>제조사</td>
								<td width=100 class=title>영업소</td>
			            		<td width=60 class=title>담당자</td>			            		
              					<td width=100 class=title>전화번호</td>
			            	</tr>
			            </table>
			        </td>
				</tr>
<% if(c_r.length != 0){ %>
            	<tr>
            		<td class=line id='D1_col' style='position:relative;'>
            			<table border=0 cellspacing=1 width=150>
<%
    for(int i=0; i<c_r.length; i++){
        c_bean = c_r[i];
%>            				<tr>
								<td align="center" width=50><%= i+1 %></td>
            					<td align="center" width=100><%= c_bean.getRent_l_cd() %></td>
			            	</tr>
<%}%>
			            </table>
			        </td>            		            		
            		<td class=line idth=1850>
            			<table border=0 cellspacing=1 width=100%>
<%
    for(int i=0; i<c_r.length; i++){
        c_bean = c_r[i];
%>
							<tr>
								<td width=80 align="center"><%= c_bean.getRent_dt() %></td>
			            		<td width=200 align="left">&nbsp;<span title="<%= c_bean.getFirm_nm() %>"><a href="javascript:view_client('<%=c_bean.getRent_mng_id()%>','<%=c_bean.getRent_l_cd()%>','<%=c_bean.getR_st()%>')"><%= Util.subData(c_bean.getFirm_nm(),10) %></a></span></td>
			            		<td width=80 align="center"><span title="<%= c_bean.getClient_nm() %>"><%= Util.subData(c_bean.getClient_nm(),4) %></span></td>
			            		
                                <td width=150 align="left">&nbsp;<span title="<%=c_bean.getCar_jnm()+" "+c_bean.getCar_name()%>"><%= Util.subData(c_bean.getCar_jnm()+" "+c_bean.getCar_name(),10) %></span></td>
			            		<td width=80 align="center"><%= c_bean.getPur_pay_dt() %></td>
			            		<td width=80 align="center"><%= c_bean.getPur_req_dt() %></td>
			            		<td width=80 align="center"><%= c_bean.getDlv_est_dt() %></td>
								<td width=60 align="center"><%= c_bean.getBus_nm() %></td>								
			            		<td width=60 align="center"><%= c_bean.getRent_way_nm() %></td>
			            	
			            		<td width=60 align="center"><%= c_bean.getCon_mon()+" 개월" %></td>
								<td width=100 align="center"><%=c_bean.getCar_off_name1()%></td>
			            		<td width=100 align="center"><%= Util.subData(c_bean.getIn_car_off_nm(), 6)  %></td>
			            		<td width=60 align="center"><%=  c_bean.getIn_emp_nm() %></td>
			            		
                                <td width=100 align="center"><%= Util.subData(c_bean.getIn_car_off_tel(), 10) %></td>
			            		<td width=100 align="center"><%=c_bean.getCar_off_name2()%></td>
								<td width=100 align="center"><%=  Util.subData(c_bean.getOut_car_off_nm(), 6)  %></td>
			            		<td width=60 align="center"><%=  c_bean.getOut_emp_nm() %></td>
			            		
                                <td width=100 align="center"><%=  Util.subData(c_bean.getOut_car_off_tel(),10) %></td>
                                <td width=200 align="center"><span title="<%= c_bean.getDelay_cont() %>"><%= Util.subData(c_bean.getDelay_cont(), 16) %></span></td>
			            	</tr>
<%}%>
			            </table>
			        </td>            		            		
            	</tr>
<%}%>
<% if(c_r.length == 0){ %>
	            <tr>
            		<td class=line id='D1_col' style='position:relative;'>
            			<table border=0 cellspacing=1 width=150>
	           				<tr>
								<td align="center" width=100%></td>
			            	</tr>
			            </table>
			        </td>            		            		
            		<td class=line width=1850>
            			<table border=0 cellspacing=1 width=100%>
							<tr>
								<td> &nbsp;등록된 데이타가 없습니다.</td>
			            	</tr>
			            </table>
			        </td>            		            		
            	</tr>
<%}%>
            </table>
        </td>
    </tr>
</table>

<form action="./register_frame.jsp" name="CarRegDispForm" method="POST">
<input type="hidden" name="rent_mng_id" value="">
<input type="hidden" name="rent_l_cd" value="">
<input type="hidden" name="car_mng_id" value="">
<input type="hidden" name="rpt_no" value="">
<input type="hidden" name="firm_nm" value="">
<input type="hidden" name="client_nm" value="">
<input type="hidden" name="imm_amt" value="">
<input type="hidden" name="cmd" value="">
<!-- <input type="hidden" name="auth_rw" value="<%//=auth_rw%>"> -->
</form>
</body>
</html>