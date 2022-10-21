<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*, acar.car_office.*" %>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
	String base_dt = request.getParameter("base_dt")==null?"":request.getParameter("base_dt");
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");

	
	CarOfficeDatabase co_db	= CarOfficeDatabase.getInstance();
	EstiJuyoDatabase ej_db = EstiJuyoDatabase.getInstance();
	
	
	
	
	Vector vt = ej_db.getReg_dtList();
	Vector vt2 = ej_db.getReg_dtListHp();
	
	//자동차회사 리스트
	CarCompBean cc_r [] = co_db.getCarCompAll_Esti();
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//조회
	function search(){
		var fm = document.form1;
		fm.action = "main_car_sc.jsp";
		fm.target = "c_foot";
		fm.submit();
	}
	function EnterDown(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	//등록
	function esti_reg(){
		var fm = document.form1;
		fm.action = "main_car_add_20090901.jsp";
		fm.target = 'd_content';
		fm.submit();
	}	
	//전체사용안함
	function all_no(){
		var fm = document.form1;
		if(!confirm("해당 주요차종 월대여료 견적사용을 마감하시겠습니까?")) 	return;
		fm.action = "main_car_all_no.jsp";
		fm.target = 'nodisplay';
		fm.submit();
	}		
	//전체 홈페이지 적용
	function all_hp(){
		var fm = document.form1;
		if(!confirm("현재 주요차종 월대여료 견적을 홈페이지에 적용하시겠습니까?")) 	return;
	//	var SUBWIN="sp_esti_reg_hp_upload.jsp";
		var SUBWIN="http://cms.amazoncar.co.kr:8080/acar/admin/sp_esti_reg_hp_upload.jsp";
		window.open(SUBWIN, "SP_JuyoEsti", "left=0, top=0, width=5, height=5, scrollbars=yes, status=yes, resizeable=yes");	
	}			
	//전체견적
	function all_esti(){
		var fm = document.form1;
		if(!confirm("해당 주요차종 월대여료 견적하시겠습니까?")) 	return;
		parent.c_foot.EstiList.main_car_upd_all_h();
	}			
	//전체견적
	function all_esti_r(){
		var fm = document.form1;
		if(!confirm("해당 주요차종 월대여료 견적하시겠습니까?")) 	return;
		parent.c_foot.EstiList.main_car_upd_all_h_r();
	}				
	//전체견적
	/* 201905 약정주행거리 3종류 추가로 전체견적은 예약으로만 처리
	function all_esti_p(){
		var fm = document.form1;
		if(!confirm("해당 주요차종 월대여료 견적하시겠습니까?")) 	return;
		fm.action = "http://cms.amazoncar.co.kr:8080/acar/admin/sp_esti_reg_hp.jsp";
		fm.target = 'nodisplay';
		fm.submit();
	}
	*/
	
	
	//인기차량 리스트
	function open_hotcar(){
		var fm = document.form1;
		var SUBWIN='./main_car_hotcar.jsp?auth_rw=<%=auth_rw%>&base_dt=<%=base_dt%>&car_comp_id=<%=car_comp_id%>&t_wd=<%=t_wd%>';
		window.open(SUBWIN, "OrderHotCar", "left=200, top=200, width=650, height=600, scrollbars=yes, status=yes");	
	}
	
//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST" >
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<input type='hidden' name='base_dt' value='<%=base_dt%>'>
<table border=0 cellspacing=0 cellpadding=0 width=98%>
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > <span class=style5>주요차종관리</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>    
    <tr> 
        <td>
            <table border=0 cellpadding=0 cellspacing=1 width="100%">
                <tr> 
                    <td width=60%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                     
                      <img src=../images/center/arrow_jjs.gif align=absmiddle>&nbsp;
                      <select name="car_comp_id" >
                        <option value="" <%if(car_comp_id.equals(""))%>selected<%%>>-전체-</option>                        
                        <%for(int i=0; i<cc_r.length; i++){
        						        cc_bean = cc_r[i];%>
                        <option value="<%= cc_bean.getCode() %>" <%if(car_comp_id.equals(cc_bean.getCode()))%>selected<%%>><%= cc_bean.getNm() %></option>
                        <%	}	%>
                        <option value="etc" <%if(car_comp_id.equals("etc"))%>selected<%%>>-수입차-</option>
                        
                      </select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        			  <img src=../images/center/arrow_cj.gif align=absmiddle>
        			  <input type="text" name="t_wd" value="<%=t_wd%>" size="20" class=text onKeyDown="javasript:EnterDown()">
                      &nbsp;<a href="javascript:search()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="../images/center/button_search.gif" border="0" align="absmiddle"></a> 
                    </td>
                    <td align="right">
                        <%if(!auth_rw.equals("1")){%>
					  <a href="javascript:all_hp()" onMouseOver="window.status=''; return true" title='홈페이지적용'><img src="../images/center/button_hpage.gif" border="0" align="absmiddle"></a>&nbsp;&nbsp;					  
					  <!-- 201905 약정주행거리 3종류 추가로 전체견적은 예약으로만 처리  &nbsp;&nbsp;<a href="javascript:all_esti_p();" title='일괄 프로시저 견적'><img src=../images/center/button_p_allgj.gif border=0 align=absmiddle></a>-->					  
					  &nbsp;&nbsp;<a href="javascript:open_hotcar();" title='인기차량'><img src="../images/center/button_ppl.gif" border="0" align="absmiddle"></a>					  
			<%}%>		  
					</td>
                    <td align="right">
                        <%if(!auth_rw.equals("1")){%>
					  <a href="javascript:esti_reg()" onMouseOver="window.status=''; return true" title='등록'><img src="../images/center/button_reg.gif" border="0" align="absmiddle"></a>&nbsp;&nbsp;&nbsp;
			<%}%>		  
	            </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>

