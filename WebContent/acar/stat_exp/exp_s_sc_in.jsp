<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.stat_exp.*" %>
<jsp:useBean id="se_bean" class="acar.stat_exp.StatExpBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "03", "14");
	
	StatExpDatabase sed = StatExpDatabase.getInstance();
	String car_mng_id = "";
	String rent_mng_id = "";
	String rent_l_cd = "";
	String gubun = "";
	String gubun_nm = "";
	String st = "0";
	String dt = "1";
	String ref_dt1 = Util.getDate();
	String ref_dt2 = Util.getDate();
	//String auth_rw = "";
	
	if(request.getParameter("car_mng_id") != null)	car_mng_id = request.getParameter("car_mng_id");
	if(request.getParameter("rent_mng_id") != null)	rent_mng_id = request.getParameter("rent_mng_id");
	if(request.getParameter("rent_l_cd") != null)	rent_l_cd= request.getParameter("rent_l_cd");
	if(request.getParameter("gubun") != null)	gubun= request.getParameter("gubun");
	if(request.getParameter("gubun_nm") != null)	gubun_nm= request.getParameter("gubun_nm");
	if(request.getParameter("st") != null)	st = request.getParameter("st");
	if(request.getParameter("dt") != null)	dt = request.getParameter("dt");
	if(request.getParameter("ref_dt1") != null)	ref_dt1 = request.getParameter("ref_dt1");
	if(request.getParameter("ref_dt2") != null)	ref_dt2 = request.getParameter("ref_dt2");
	if(request.getParameter("auth_rw") != null)	auth_rw= request.getParameter("auth_rw");
	
	StatExpBean se_r [] = sed.getExpAll2(br_id, gubun,gubun_nm,st,dt,ref_dt1,ref_dt2);
	
	long total_amt = 0;
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--

function ExpProc(name,gubun,d_gubun,rent_mng_id,rent_l_cd,car_mng_id,client_nm,firm_nm,car_name,car_no,plan_dt,amt,coll_dt)
{
	var theForm = document.ExpProcForm;
	var auth_rw = "";
	/*
	theForm.name.value = name;
	theForm.gubun.value = gubun;
	theForm.d_gubun.value = d_gubun;
	*/
	
	/*
	theForm.client_nm.value = client_nm;
	theForm.firm_nm.value = firm_nm;
	theForm.car_name.value = car_name;
	theForm.car_no.value = car_no;
	theForm.plan_dt.value = plan_dt;
	theForm.amt.value = amt;
	theForm.coll_dt.value = coll_dt;
	*/
	auth_rw = theForm.auth_rw.value; 

	if(name=="과태료"||name=="범칙금")
	{
		theForm.rent_mng_id.value = rent_mng_id;
		theForm.rent_l_cd.value = rent_l_cd;
		theForm.car_mng_id.value = car_mng_id;
		theForm.seq_no.value = gubun;
		theForm.target="d_content";
		theForm.submit();
	}else if(name=="보험료"){
		var SUBWIN="./exp_ins_id.jsp?auth_rw=" + auth_rw 
					+ "&rent_mng_id=" + rent_mng_id
					+ "&rent_l_cd=" + rent_l_cd 
					+ "&car_mng_id=" + car_mng_id; 
		window.open(SUBWIN, "ExpIns", "left=100, top=100, width=820, height=430, scrollbars=no");
	}else if(name=="취득세"){
		var SUBWIN="./exp_acq_id.jsp?auth_rw=" + auth_rw 
					+ "&rent_mng_id=" + rent_mng_id
					+ "&rent_l_cd=" + rent_l_cd 
					+ "&car_mng_id=" + car_mng_id; 
		window.open(SUBWIN, "ExpAcq", "left=100, top=100, width=820, height=220, scrollbars=no");
	}else if(name=="할부금"){
		gubun = replaceString("회","",gubun);
		var SUBWIN="./exp_debt_id.jsp?auth_rw=" + auth_rw 
					+ "&rent_mng_id=" + rent_mng_id
					+ "&rent_l_cd=" + rent_l_cd 
					+ "&car_mng_id=" + car_mng_id
					+ "&alt_tm=" + gubun; 
		window.open(SUBWIN, "ExpAcq", "left=100, top=100, width=500, height=150, scrollbars=no");
	}
	
}
function ExpLoad()
{
	var theForm = document.ExpLoadForm;
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
//-->
</script>
</head>
<body onLoad="javascript:init()">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='30%' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
			<tr>
				<td width=14% class='title'>연번</td>
				<td width=21% class='title'>구분</td>
				<td width=21% class='title'>세부구분</td>
				<td width=44% class='title'>계약번호</td>
        	</tr>
       		</table>
		</td>
		<td class='line' width='70%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
      		<tr>
				<td width=12% class='title'>계약자</td>
				<td width=18% class='title'>상호</td>
				<td width=17% class='title'>차종</td>
				<td width=13% class='title'>차량번호</td>
				<td width=12% class='title'>납부일</td>
				<td width=16% class='title'>납부금</td>
				<td width=12% class='title'>지출일</td>
        	</tr>
        	</table>
  		</td>
	</tr>
<% if(se_r.length != 0){ %>
	<tr>
		<td class='line' width='30%' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
    for(int i=0; i<se_r.length; i++){
        se_bean = se_r[i];
%>
        	<tr>
				<td width=14%  align="center"><%=i+1%></td>            	
        		<td width=21%  align="center"><%=se_bean.getName()%></td>
        		<td width=21%  align="center"><%=se_bean.getGubun()%></td>
        		<td width=44% align="center"><%=se_bean.getRent_l_cd()%></td>
           	</tr>
<%}%>
        	<tr>
	            <td class="title" align='center'></td>
	            <td class="title">&nbsp;</td>
	            <td class="title">&nbsp;</td>
    		    <td class="title" align='center'>합계</td>
           	</tr>
		  </table>
		  </td>
		<td class='line' width='70%'>
			
      <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          
<%
    for(int i=0; i<se_r.length; i++){
        se_bean = se_r[i];
%>
    	<tr>
    		<td width=12% align=center>&nbsp;<span title="<%=se_bean.getClient_nm()%>"><%=Util.subData(se_bean.getClient_nm(),4)%></span></td>
    		<td width=18% align="left">&nbsp;<span title="<%=se_bean.getFirm_nm()%>"><%=Util.subData(se_bean.getFirm_nm(),7)%></span></td>
    		<td width=17% align="left">&nbsp<span title="<%=se_bean.getCar_nm()%> <%=se_bean.getCar_name()%>"><%=Util.subData(se_bean.getCar_nm()+" "+se_bean.getCar_name(),8)%></span></td>
    		<td width=13% align="center"><%=se_bean.getCar_no()%></td>
    		<td width=12% align="center"><%=se_bean.getPlan_dt()%></td>
    		<td width=16% align="right"><%=Util.parseDecimal(se_bean.getAmt())%> 원&nbsp;</td>
    		<td width=12% align="center"><!--<a href="javascript:ExpProc('<%=se_bean.getName()%>','<%=se_bean.getGubun()%>','<%=se_bean.getD_gubun()%>','<%=se_bean.getRent_mng_id()%>','<%=se_bean.getRent_l_cd()%>','<%=se_bean.getCar_mng_id()%>','<%=se_bean.getClient_nm()%>','<%=se_bean.getFirm_nm()%>','<%=se_bean.getCar_name()%>','<%=se_bean.getCar_no()%>','<%=se_bean.getPlan_dt()%>','<%=se_bean.getAmt()%>','<%=se_bean.getColl_dt()%>')">--><%=se_bean.getColl_dt()%><!--</a>--></td>
    	</tr>
<%		total_amt = total_amt + Long.parseLong(String.valueOf(se_bean.getAmt()));
		}%>
          <tr> 
            <td class="title">&nbsp;</td>
            <td class="title">&nbsp;</td>
            <td class="title">&nbsp;</td>
            <td class="title">&nbsp;</td>
            <td class="title">&nbsp;</td>
            <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt)%> 원&nbsp;</td>
            <td class="title">&nbsp;</td>		  
          </tr>
  
       </table>
	  </td>
	</tr>
<%}%>
<% if(se_r.length == 0){ %>
	<tr>
		<td class='line' width='30%' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td align='center'>등록된 데이타가 없습니다</td>
				</tr>
			</table>
		</td>
		<td class='line' width='70%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
	
<%}%>
</table>

<form action="/acar/fine_mng/fine_mng_frame.jsp" name="ExpProcForm" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="gubun" value="<%=gubun%>">
<input type="hidden" name="st" value="<%=st%>">
<input type="hidden" name="dt" value="<%=dt%>">
<input type="hidden" name="ref_dt1" value="<%=ref_dt1%>">
<input type="hidden" name="ref_dt2" value="<%=ref_dt2%>">
<input type="hidden" name="rent_mng_id" value="">
<input type="hidden" name="rent_l_cd" value="">
<input type="hidden" name="car_mng_id" value="">
<input type="hidden" name="seq_no" value="">
</form>
<form action="./exp_s_sc_in.jsp" name="ExpLoadForm" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="gubun" value="<%=gubun%>">
<input type="hidden" name="gubun_nm" value="<%=gubun_nm%>">
<input type="hidden" name="st" value="<%=st%>">
<input type="hidden" name="dt" value="<%=dt%>">
<input type="hidden" name="ref_dt1" value="<%=ref_dt1%>">
<input type="hidden" name="ref_dt2" value="<%=ref_dt2%>">
</form>			
</body>
</html>
