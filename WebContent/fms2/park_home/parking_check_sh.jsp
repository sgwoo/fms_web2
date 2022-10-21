<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_office.*, acar.res_search.*,acar.car_register.*"%> 
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%	
	CommonDataBase c_db = CommonDataBase.getInstance();
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no"); //차량번호 또는 차대번호
	String car_nm = request.getParameter("car_nm")==null?"":request.getParameter("car_nm"); //차종
	String car_mng_id	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id"); //차량관리번호
	String init_reg_dt	= request.getParameter("init_reg_dt")==null?"":request.getParameter("init_reg_dt"); //최초등록일
	String dpm	= request.getParameter("dpm")==null?"":request.getParameter("dpm"); //배기량
	String fuel_kd	= request.getParameter("fuel_kd")==null?"":request.getParameter("fuel_kd"); //연료
	String colo	= request.getParameter("colo")==null?"":request.getParameter("colo"); // 색상
	int car_km = request.getParameter("car_km")==null?0:Util.parseInt(request.getParameter("car_km")); //주행거리
	String io_gubun	= request.getParameter("io_gubun")==null?"":request.getParameter("io_gubun");
	String park_id	= request.getParameter("park_id")==null?"1":request.getParameter("park_id");
	
	int count = 0;
	
	LoginBean login = LoginBean.getInstance();
	String acar_id = login.getCookieValue(request, "acar_id");
	
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이

	int cnt = 10; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-80;//현황 라인수만큼 제한 아이프레임 사이즈
	
	
	CarRegDatabase crd = CarRegDatabase.getInstance();
	cr_bean = crd.getCarRegBean(car_mng_id);
	

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

//-->
</script>
</head>

<body>
<form name="form1" method="post">
<input type='hidden' name='car_mng_id' value='<%=car_mng_id%>'>

<table width="100%" border="0" cellspacing="1" cellpadding="0">
	<tr> 
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>예약시스템 > 예비차관리 > 주차장현황 > <span class=style5>차량정보</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>            
		</td>
	</tr>
	<tr> 
		<td class=h></td>
	</tr>
	<tr> 
		<td class=line2></td>
	</tr>

	<tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
                <tr> 
                    <td class=title width=13%>최초등록일</td>
                    <td width=21%>&nbsp; 
                      <input type="text" name="init_reg_dt" value="<%=cr_bean.getInit_reg_dt()%>" size="10" class=whitetext  maxlength="10">
                    </td>
                    <td class=title width=12%>지역</td>
                    <td width=21%>&nbsp; 
                      <%=c_db.getNameByIdCode("0032", "", cr_bean.getCar_ext())%>                      
                    </td>
                    <td class=title width=12%>관리번호</td>
                    <td width=21%>&nbsp; 
                      <input type="text" name="car_doc_no" value="<%=cr_bean.getCar_doc_no()%>" size="10" class=whitetext  maxlength="10">
                    </td>					
                </tr>
                <tr> 
                    <td class=title>자동차관리번호</td>
                    <td>&nbsp; 
                      <input type="text" name="car_no" value="<%=cr_bean.getCar_no()%>" size="15" class=whitetext maxlength="15">
                    </td>
                    <td class=title>차종</td>
                    <td>&nbsp; 
                      <%=c_db.getNameByIdCode("0041", "", cr_bean.getCar_kd())%>                        
                    </td>
                    <td class=title>용도</td>
                    <td>&nbsp; 
                      <%if(cr_bean.getCar_use().equals("1")){%>영업용<%}%>
                      <%if(cr_bean.getCar_use().equals("2")){%>자가용<%}%>                      
                    </td>
                </tr>
                <tr> 
                    <td class=title>차명</td>
                    <td>
                        <table width=100% border=0 cellspacing=0 cellpadding=3>
                            <tr>
                                <td>
                                    <%=cr_bean.getCar_nm()%>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td class=title>차대번호</td>
                    <td>&nbsp; 
                      <input type="text" name="car_num" value="<%=cr_bean.getCar_num()%>" size="20" class=whitetext maxlength="20">
                    </td>
                    <td class=title>연식</td>
                    <td>&nbsp; 
                      <input type="text" name="car_y_form" value="<%=cr_bean.getCar_y_form()%>" size="6" class=whitetext>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>

	<tr> 
		<td>&nbsp;</td>
	</tr>

	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
						<iframe src="parking_check_s_in.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&car_km=<%=car_km%>" name="inner" width="100%"  frameborder=0 scrolling="auto" topmargin=0 marginwidth="0" marginheight="0" >
						</iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

</form>
</body>
</html>


