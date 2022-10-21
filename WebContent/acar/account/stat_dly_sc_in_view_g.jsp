<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.account.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//수금 스케줄 리스트 이동
	function list_move(bus_id2)
	{
		var fm = document.form1;
		var url = "";
		fm.gubun1.value = '1';
		fm.gubun2.value = '3';
		fm.gubun3.value = '3';	
		fm.s_kd.value = '8';		
		fm.t_wd.value = bus_id2;			
		url = "/fms2/con_fee/fee_frame_s.jsp";
		fm.action = url;		
		fm.target = 'd_content';	
		fm.submit();						
	}				
//-->
</script>
</head>

<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String search_kd = request.getParameter("search_kd")==null?"":request.getParameter("search_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String dept_id = request.getParameter("dept_id")==null?"0001":request.getParameter("dept_id");	
	String bus_id2 = request.getParameter("bus_id2")==null?"":request.getParameter("bus_id2");
	
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	String tot_dly_amt = request.getParameter("tot_dly_amt")==null?"0":request.getParameter("tot_dly_amt");
	String tot_dly_per = request.getParameter("tot_dly_per")==null?"0":request.getParameter("tot_dly_per");
	float dly_per1 = 0;
	float dly_per2 = 0;
	String per2 = "";
	
	CommonDataBase c_db = CommonDataBase.getInstance();
%>
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value=''>
<input type='hidden' name='gubun2' value=''>
<input type='hidden' name='gubun3' value=''>
<input type='hidden' name='gubun4' value='1'>
<input type='hidden' name='s_kd' value=''>
<input type='hidden' name='t_wd' value=''>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td class="line">          
            <TABLE align=center border=0 width=100% cellspacing=1 cellpadding=0>
        <%//연체율 그래픽
			Vector feedps = ad_db.getDlyBusStat(brch_id, dept_id, save_dt);
			int feedp_size = feedps.size();
			if(feedp_size > 0){
				for (int i = 0 ; i < feedp_size ; i++){
					IncomingSBean feedp = (IncomingSBean)feedps.elementAt(i);
					dly_per1 = Float.parseFloat(feedp.getTot_su3())*125;
					if(feedp.getTot_su4().equals("")){
						dly_per2 = Float.parseFloat(feedp.getTot_amt2())/Float.parseFloat(tot_dly_amt)*100;
						per2 = (dly_per2==0)?"0.0":Float.toString(dly_per2).substring(0,Float.toString(dly_per2).indexOf(".")+3);
					}else{
						per2 = feedp.getTot_su4();
					}
					if(dly_per1 > 500) dly_per1=500;
					%>
                <TR> 
                    <TD style='background:e2fff8;' width="6%" align=center><a href="javascript:list_move('<%=feedp.getGubun()%>');" onMouseOver="window.status=''; return true"><%=c_db.getNameById(feedp.getGubun(), "USER")%></a></TD>
                    <TD style='background:e2fff8;' width="6%" align=center><a href="javascript:list_move('<%=feedp.getGubun()%>');" onMouseOver="window.status=''; return true"><%=feedp.getPartner_nm()%></a></TD>
                    <TD align="center" width=11%><input type="text" name="per1" value="<%=AddUtil.parseFloatCipher(feedp.getTot_su3(),2)%>" size="6" class="whitenum">%</TD>
                    <TD align="center" width=11%><input type="text" name="per2" value="<%=AddUtil.parseFloatCipher(per2,2)%>" size="6" class="whitenum">%</TD>
                    <TD><img src=../../images/result1.gif width=<%=Float.toString(dly_per1).substring(0,Float.toString(dly_per1).indexOf("."))%> height=10></TD>
                </TR>
        <%	}
			}else{%>
                <TR align="center"> 
                    <TD colspan="4">등록된 자료가 없습니다.</TD>
                </TR>
        <%}%>
            </TABLE>
        </td>
    </tr>
</table>
</form>
</body>
</html>
