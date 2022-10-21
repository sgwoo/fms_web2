<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*,acar.cont.*, acar.car_register.*, acar.secondhand.*"%>
<jsp:useBean id="shDb" 		class="acar.secondhand.SecondhandDatabase" 	scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//예상주행거리
	
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String s_rent_dt 	= request.getParameter("rent_dt")==null?"":AddUtil.replace(request.getParameter("rent_dt"),"-","");
	String s_serv_dt 	= request.getParameter("serv_dt")==null?"":AddUtil.replace(request.getParameter("serv_dt"),"-","");
	String s_tot_dist 	= request.getParameter("tot_dist")==null?"":AddUtil.replace(request.getParameter("tot_dist"),",","");
	String fee_size 	= request.getParameter("fee_size")==null?"":request.getParameter("fee_size");
	
	CommonDataBase c_db 	= CommonDataBase.getInstance();
	
	//차량정보
	Hashtable ht2 = shDb.getBase(car_mng_id, s_rent_dt, s_serv_dt, s_tot_dist);
	
	//차량정보
	Hashtable ht = shDb.getShBase(car_mng_id);
	
	String car_comp_id		= String.valueOf(ht.get("CAR_COMP_ID"));
	String car_id			= String.valueOf(ht.get("CAR_ID"));
	String car_seq			= String.valueOf(ht.get("CAR_SEQ"));
	String s_st 			= String.valueOf(ht.get("S_ST"));
	String jg_code 			= String.valueOf(ht.get("JG_CODE"));
	String car_no 			= String.valueOf(ht.get("CAR_NO"));
	String car_name			= String.valueOf(ht.get("CAR_NAME"));
	String init_reg_dt 		= String.valueOf(ht.get("INIT_REG_DT"));
	String secondhand_dt 	= String.valueOf(ht.get("SECONDHAND_DT"));
	String park		 		= String.valueOf(ht.get("PARK"));
	String dlv_dt 			= String.valueOf(ht.get("DLV_DT"));	
	String before_one_year 	= String.valueOf(ht.get("BEFORE_ONE_YEAR"));
	String lpg_yn	 		= String.valueOf(ht.get("LPG_YN"));
	String opt		 		= String.valueOf(ht.get("OPT"));
	String colo		 		= String.valueOf(ht.get("COL"));
	int car_amt 			= AddUtil.parseInt((String)ht.get("CAR_AMT"));
	int opt_amt 			= AddUtil.parseInt((String)ht.get("OPT_AMT"));
	int clr_amt 			= AddUtil.parseInt((String)ht.get("COL_AMT"));
	
	String tot_dist 		= String.valueOf(ht2.get("TOT_DIST"));
	String today_dist 		= String.valueOf(ht2.get("TODAY_DIST"));
	
	if(fee_size.equals("1"))	today_dist 		= String.valueOf(ht2.get("TOT_DIST"));
	
	String serv_dt	 		= String.valueOf(ht2.get("SERV_DT"));
	
	//차량등록 경과기간(차령)
	Hashtable carOld 	= c_db.getOld(init_reg_dt);
	
	
	if(serv_dt.equals(s_rent_dt)) today_dist = tot_dist;
	
	if(s_serv_dt.equals(s_rent_dt)) today_dist = s_tot_dist;
	
	Hashtable ht7 = shDb.getBase(car_mng_id, s_rent_dt, s_serv_dt, s_tot_dist);
	
	
%>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
	function set_today_dist(today_dist){
		opener.document.form1.sh_km.value = today_dist;
		self.window.close();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<style type="text/css">
<!--
.style1 {color: #333333}
-->
</style>
</head>
<body>
<p>
<form name='form1' action='' method='post'>
  <input type='hidden' name="s_rent_dt" 		value="<%=s_rent_dt%>">
  <input type='hidden' name="s_serv_dt" 		value="<%=s_serv_dt%>">
  <input type='hidden' name="serv_dt" 			value="<%=serv_dt%>">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>예상주행거리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량정보</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line">
    	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class="title" width="16%">최초등록일</td>
                    <td width="34%">&nbsp;<%=AddUtil.ChangeDate2(init_reg_dt)%></td>
                    <td class="title" width="16%">출고일자</td>
                    <td width="34%">&nbsp;<%=AddUtil.ChangeDate2(dlv_dt)%></td>
                </tr>
                <tr> 
                    <td class="title" width="16%">차령</td>
                    <td colspan='3'>&nbsp;<%= carOld.get("YEAR") %>년<%= carOld.get("MONTH") %>개월<%= carOld.get("DAY") %>일&nbsp;(기준일자:<%=AddUtil.getDate()%>)</td>
                </tr>		  
                <tr> 
                    <td class="title" width="16%">최종주행거리</td>                    
                    <td colspan='3'>&nbsp;<%=AddUtil.parseDecimal(s_tot_dist)%> km&nbsp;(최종입력:<%=AddUtil.ChangeDate2(s_serv_dt)%>)</td><!-- //AddUtil.parseDecimal(tot_dist) //AddUtil.ChangeDate2(serv_dt) -->
                </tr>		  
                <tr> 
                    <td class="title" width="16%">예상주행거리</td>
                    <td colspan='3'>&nbsp;<a href="javascript:set_today_dist('<%=AddUtil.parseDecimal(today_dist)%>');"><%=AddUtil.parseDecimal(today_dist)%></a> km&nbsp;(기준일자:<%=AddUtil.ChangeDate2(s_rent_dt)%>)</td>
                </tr>		  
            </table>
	    </td>
    </tr>	
  <tr> 
    <td align="right"> 
	  <a href="javascript:self.close();"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a>
    </td>
  </tr>  
</table>
</body>
</html>