<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.condition.*, acar.common.*" %>
<jsp:useBean id="cc_bean" class="acar.condition.ClsCondBean" scope="page"/>

<%
	ConditionDatabase cdb = ConditionDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String ref_dt1 = Util.getDate();
	String ref_dt2 = Util.getDate();
	String auth_rw = "";
	String dt = "2";
	
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");

	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("dt") != null)	dt = request.getParameter("dt");
	if(request.getParameter("ref_dt1") != null)	ref_dt1 = request.getParameter("ref_dt1");
	if(request.getParameter("ref_dt2") != null)	ref_dt2 = request.getParameter("ref_dt2");
	
	ClsCondBean cc_r [] = cdb.getClsCondAll2_new(dt,ref_dt1,ref_dt2, gubun2, gubun3);
	String car_gu_nm = "";
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
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
	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))
	{
%>
		//theForm.action = "./register_frame.jsp";
		theForm.action = "./register_frame.jsp";
<%
	}else{
%>
		if(reg_gubun=="id")
		{
			alert("미등록 상태입니다.");
			return;
		}
		//theForm.action = "./register_r_frame.jsp";
		theForm.action = "./register_frame.jsp";
<%
	}
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
//-->
</script>
</head>
<body rightmargin=0>
<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
		<td class='line'>			 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=4% class=title>연번</td>
                    <td width=8% class=title>구분</td>
                    <td width=9% class=title>계약번호</td>
                    <td width=12% class=title>상호</td>
                    <td width=8% class=title>계약자</td>
                    <td width=10% class=title>차량번호</td>
                    <td width=9% class=title>차종</td>
                    <td width=6% class=title>연료</td>
                    <td width=6% class=title>차량구분</td>
                    <td width=8% class=title>해지일자</td>
                    <td width=12% class=title>해지내용</td>
                    <td width=7% class=title>담당자</td>
                </tr>
	  
        <%
    for(int i=0; i<cc_r.length; i++){
        cc_bean = cc_r[i];
        
        //a.car_gu, b.fuel_kd
        String vt[] = cdb.getClsCondCar(cc_bean.getRent_l_cd()); 
        if ( !vt[1].equals("XX")) {
        	car_gu_nm = c_db.getNameByIdCode("0039", "", vt[1]);
        }else {
        	car_gu_nm = "";
        }
%>
                <tr> 
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%= cc_bean.getCls_st_nm() %></td>
                    <td align="center"><%= cc_bean.getRent_l_cd() %></td>
                    <td>&nbsp;<span title='<%=cc_bean.getFirm_nm()%>'><%=AddUtil.subData(cc_bean.getFirm_nm(), 8)%></span></td>
                    <td align="center"><span title='<%=cc_bean.getClient_nm()%>'><%=AddUtil.subData(cc_bean.getClient_nm(), 4)%></span></td>
                    <td align="center"><%= cc_bean.getCar_no() %></td>
                    <td>&nbsp;<span title='<%=cc_bean.getCar_name()%>'><%=AddUtil.subData(cc_bean.getCar_name(), 6)%></span></td>
                    <td align="center">&nbsp;<%=car_gu_nm%></td>
                    <td align="center">&nbsp;
                    <% if ( vt[0].equals("1")) { %>신차
                    <% } else if ( vt[0].equals("0")) { %>재리스
                    <% } else if ( vt[0].equals("2")) { %>중고차
                    <% } else if ( vt[0].equals("2")) { %>월렌트
                    <% } %>  
                    </td>
                    <td align="center"><%=AddUtil.ChangeDate2(cc_bean.getCls_dt())%></td>
                    <td>&nbsp;<span title='<%=cc_bean.getCls_cau()%>'><%=AddUtil.subData(cc_bean.getCls_cau(), 16)%></span></td>
                    <td align="center"><%= cc_bean.getReg_nm() %></td>
                </tr>
        <%}%>
        <% if(cc_r.length == 0){ %>
                <tr> 
                    <td colspan="12" align="center"> &nbsp;등록된 데이타가 없습니다.</td>
                </tr>
        <%}%>
            </table>
        </td>            		            		
	</tr>
</table>
</body>
</html>