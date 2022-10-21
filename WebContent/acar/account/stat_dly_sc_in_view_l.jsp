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
<script language="JavaScript">
<!--
	//일별통계
	function stat_search(mode, bus_id2){
		var fm = document.form1;	
		fm.mode.value = mode;
		fm.bus_id2.value = bus_id2;
		fm.action = 'stat_case_sh.jsp';
		fm.target='d_content';
		fm.submit();		
	}	

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
	float dly_per1 = 0;
	float dly_per2 = 0;
	String per2 = "";
	
	CommonDataBase c_db = CommonDataBase.getInstance();
%>
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='search_kd' value='<%=search_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='dept_id' value='<%=dept_id%>'>
<input type='hidden' name='bus_id2' value='<%=bus_id2%>'>
<input type='hidden' name='save_dt' value='<%=save_dt%>'>
<input type='hidden' name='tot_dly_amt' value='<%=tot_dly_amt%>'>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='gubun1' value=''>
<input type='hidden' name='gubun2' value=''>
<input type='hidden' name='gubun3' value=''>
<input type='hidden' name='gubun4' value='1'>
<input type='hidden' name='s_kd' value=''>
<input type='hidden' name='t_wd' value=''>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td class="line">              
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
              <%//연체율 리스트
    			Vector feedps = ad_db.getDlyBusStat(brch_id, dept_id, save_dt);
    			int feedp_size = feedps.size();%>
    			<input type='hidden' name='size' value='<%=feedp_size%>'>
    <%			if(feedp_size > 0){
    				for (int i = 0 ; i < feedp_size ; i++){
    					IncomingSBean feedp = (IncomingSBean)feedps.elementAt(i);
    					if(feedp.getTot_su4().equals("")){
    						dly_per2 = Float.parseFloat(feedp.getTot_amt2())/Float.parseFloat(tot_dly_amt)*100;
    						per2 = (dly_per2==0)?"0.0":Float.toString(dly_per2).substring(0,Float.toString(dly_per2).indexOf(".")+3);
    					}else{
    						per2 = feedp.getTot_su4();
    					}
    		  %>
                <tr> 
                    <td align="center" width="5%"><%=i+1%></td>
                    <td align="center" width="8%"><%=c_db.getNameById(feedp.getBr_id(), "BRCH")%></td>
                    <td align="center" width="8%"><%if(feedp.getGubun().equals("000003")){%>총무팀<%}else{%><%=c_db.getNameById(feedp.getDept_id(), "DEPT")%><%}%></td>
                    <td align="center" width="7%"><a href="javascript:list_move('<%=feedp.getGubun()%>');" onMouseOver="window.status=''; return true"><%=c_db.getNameById(feedp.getGubun(), "USER")%></a>
                      <input type="hidden" name="bus_id" value="<%=feedp.getGubun()%>">
                    </td>
                    <td align="center" width="7%"><a href="javascript:list_move('<%=feedp.getGubun()%>');" onMouseOver="window.status=''; return true"><%=feedp.getPartner_nm()%></a></td>
                    <td align="center" width="13%"> 
                      <input type="text" name="tot_amt" value="<%=Util.parseDecimalLong(feedp.getTot_amt1())%>" size="12" class="whitenum">
                      원</td>
                    <td align="center" width="8%"> 
                      <input type="text" name="su" value="<%=Util.parseDecimal(feedp.getTot_su2())%>" size="6" class="whitenum">
                      건</td>
                    <td align="center" width="12%"> 
                      <input type="text" name="amt" value="<%=Util.parseDecimal(feedp.getTot_amt2())%>" size="12" class="whitenum">
                      원</td>
                    <td align="center" width="9%"> 
                      <input type="text" name="per1" value="<%=AddUtil.parseFloatCipher(feedp.getTot_su3(),2)%>" size="6" class="whitenum">
                      %</td>
                    <td align="center" width="9%"> 
                      <input type="text" name="per2" value="<%=AddUtil.parseFloatCipher(per2,2)%>" size="6" class="whitenum">
                      %</td>
                    <td align="center" width="7%"> 
                      <a href="javascript:stat_search('d', '<%=feedp.getGubun()%>');" name="stat_dg"><img src=../images/center/button_in_day.gif align=absmiddle border=0></a>
                    </td>
                    <td align="center" width="7%"> 
                      <a href="javascript:stat_search('m', '<%=feedp.getGubun()%>');" name="stat_mg"><img src=../images/center/button_in_month.gif align=absmiddle border=0></a>
                    </td>
                </tr>
              <%	}
    			}else{%>
                <tr> 
                    <td align="center" colspan="12">등록된 자료가 없습니다.</td>
                </tr>
              <%}%>
            </table>
		</td>
    </tr>
</table>
</form>  
</body>
</html>
