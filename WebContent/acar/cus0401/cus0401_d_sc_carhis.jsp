<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_service.*" %>
<jsp:useBean id="cinfo_bean" class="acar.car_service.ContInfoBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
//System.out.println("c="+car_mng_id);
	CarServDatabase csd = CarServDatabase.getInstance();
	ServiceBean sb_r [] = csd.getServiceAll(car_mng_id);
	cinfo_bean = csd.getContInfo(rent_mng_id, rent_l_cd, car_mng_id);	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
	function LoadService(){
		var theForm = ServiceList.document.LoadServiceForm;
		theForm.submit();
	}
	
	function pop_excel(){
		var fm = ServiceList.document.LoadServiceForm;
		fm.target = "_blak";
		fm.action = "/acar/car_service/popup_excel.jsp";
		fm.submit();
	}
	function regService(){
		var theForm = document.form1;
		theForm.action = "jakup2.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&rent_mng_id=<%= rent_mng_id %>&rent_l_cd=<%= rent_l_cd %>";
		theForm.target = 'd_content';	
		theForm.submit();
		//var SUBWIN="./cus0401_d_sc_carhis_reg.jsp?auth_rw=<%= auth_rw %>&car_mng_id=<%= car_mng_id %>";
		//window.open(SUBWIN, "ServReg", "left=100, top=110, width=820, height=420, scrollbars=no");		
	}
	function regService_etc(){
		//var theForm = document.form1;
		//theForm.action = "cus0401_d_sc_carhis_reg2.jsp.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&rent_mng_id=<%= rent_mng_id %>&rent_l_cd=<%= rent_l_cd %>";
		//theForm.target = 'd_content';	
		//theForm.submit();
		var SUBWIN="./cus0401_d_sc_carhis_reg2.jsp?auth_rw=<%= auth_rw %>&car_mng_id=<%= car_mng_id %>&serv_st=2";
		window.open(SUBWIN, "ServReg", "left=100, top=110, width=820, height=420, scrollbars=no");		
	}
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}
	//차종내역 보기
	function view_car_service(car_id){
		window.open("/acar/secondhand_hp/service_history.jsp?c_id=<%=car_mng_id%>&from_page=/fms2/lc_rent/lc_b_s.jsp", "VIEW_CAR_SERV", "left=100, top=100, width=630, height=500, scrollbars=yes");		
	}
	
//-->
</script>
</head>

<body>
<form action="" name="form1" method="post">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>정비등록</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td align="left">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td class="line">
                        <table cellspacing="1" cellpadding='0' border="0" width="100%">
                            <tr> 
                                <td width=10% class=title>현주행거리</td>
                                <td width=21% align=center><%=Util.parseDecimal(cinfo_bean.getTot_dist())%> km</td>
                                  <td width=14% class=title>일평균주행거리</td>
                                <td width=21% align=center><%=Util.parseDecimal(cinfo_bean.getAverage_dist())%> km</td>
                                <td width=14% class=title>예상주행거리</td>
                                <td width=20% align=center><b><%=Util.parseDecimal(cinfo_bean.getToday_dist())%> km</b>
		    	    			  &nbsp;&nbsp;
								  <span class="b"><a href="javascript:view_car_service('')" onMouseOver="window.status=''; return true" title="정비내역보기"><img src=/acar/images/center/button_in_jhir.gif align=absmiddle border=0></a></span>							  								
								</td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td align="left">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td align="right" colspan=2>    
                  
        			  <a href="javascript:MM_openBrWindow('/acar/cus_reg/serv_reg.jsp?&car_mng_id=<%=car_mng_id%>&rent_mng_id=<%= rent_mng_id %>&rent_l_cd=<%= rent_l_cd %>&cmd=b','popwin_serv_reg','scrollbars=yes,status=yes,resizable=yes,width=850,height=600,top=50,left=50')"><img src="/acar/images/center/button_reg_bjg.gif" align="absmiddle" border="0"></a>&nbsp;
                      <a href="javascript:pop_excel();"><img src="/acar/images/center/button_excel.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;&nbsp;&nbsp;</td>
                </tr>
                <tr>
                    <td class=line2></td>
                </tr>
                <tr> 
                    <td class="line">
                        <table border="0" cellspacing="1" cellpadding="0" width="100%">
                            <tr> 
                                <td width=5% class=title>연번</td>
                                <td width=10% class=title>정비일자</td>
                                <td width=10% class=title>정비구분</td>
                                <td width=10% class=title>담당자</td>
                                <td width=15% class=title>정비업체</td>
                                <td class=title width=25%>점검품목</td>
                                <td width=10% class=title>주행거리</td>
                                <td width=10% class=title>정비금액</td>
                                <td width=5% class=title>삭제</td>
                            </tr>
                        </table>
                    </td>
                    <td width=16>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td><iframe src="./cus0401_d_sc_carhis_in.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&rent_mng_id=<%= rent_mng_id %>&rent_l_cd=<%= rent_l_cd %>" name="ServiceList" width="100%" height="120" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0" scrolling="auto"></iframe></td>
    </tr>
</table>
</form>
</body>
</html>
